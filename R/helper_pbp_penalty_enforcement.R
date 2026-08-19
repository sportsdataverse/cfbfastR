#' @rdname helpers_pbp
#'
#' @description Resolve how a penalty was ENFORCED, and whether the play it sits
#'   on counted. Ported from `sportsdataverse`'s `CFBPlayProcess.__setup_penalty_data`
#'   (sdv-py `sportsdataverse/cfb/cfb_pbp.py`), which is where five of the eight
#'   August-2026 CFB parsing fixes landed.
#'
#' @details `penalty_detection()` answers *was there a penalty*. This answers
#'   *what did it do to the play*, which is the question EPA needs: a nullified
#'   play must not be credited with its yards or its touchdown.
#'
#'   Three behaviours are deliberately not simplifications of the existing flags:
#'
#'   * **A play can carry more than one penalty.** A single boolean cannot say
#'     "two fouls, one declined". `penalty_all_declined` is therefore the only
#'     safe test for "the play stood" -- `penalty_declined` merely means at least
#'     one was declined.
#'   * **`"nullified by penalty"` is ESPN's own verdict** and is the reliable
#'     negation signal. Deriving negation from the foul name is not safe: a play
#'     can carry two fouls where one is declined and the other accepted, so
#'     "declined" appearing in the text does not mean the play stood.
#'   * **Automatic-first-down fouls resolve to `"unknown"`, on purpose.** A
#'     negated play resets the down to 1 rather than repeating it, so the
#'     down-replay signal cannot separate "wiped out the play" from "dead-ball
#'     foul after a play that stood". Guessing here is the defect that shipped as
#'     cfbfastR-cfb-data#30.
#'
#' @param raw_df (*data.frame* required): play-by-play frame that has already
#'   been through [penalty_detection()].
#' @return `raw_df` with the following columns appended:
#' \describe{
#' \item{`penalty_count`: Number of penalties detected in the play text.}{.}
#' \item{`penalty_declined_count`: Number of them declined.}{.}
#' \item{`penalty_all_declined`: TRUE only when every penalty on the play was declined.}{.}
#' \item{`penalty_enforcement`: One of `no_play`, `declined`, `offsetting`, `negating_foul`, `play_stands`, `unknown`; `NA` on non-penalty plays.}{.}
#' \item{`penalty_negated_play`: TRUE/FALSE whether the play was wiped out; `NA` when the enforcement class is `unknown`.}{.}
#' }
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom stringr str_count str_detect regex
#' @importFrom dplyr mutate case_when
#' @noRd

# Infractions that WIPE OUT the play, measured by how often the down is replayed
# among plays with penalty text and no explicit outcome marker (no-penalty
# baseline 0.155): false start 0.976, ineligible downfield 0.968, delay of game
# 0.919, offside/encroachment 0.761, offensive holding 0.738, illegal
# formation/shift/motion 0.627.
.penalty_negating_foul <- paste0(
  "false start|ineligible|delay of game|offside|encroachment|neutral zone",
  "|holding|illegal (formation|shift|motion|substitution)|clipping|chop block"
)

# Infractions after which the play STANDS and the down advances: intentional
# grounding 0.045 (a loss of down, so an advancing down is correct) and illegal
# forward pass 0.175 -- both at or below the 0.155 baseline.
.penalty_play_stands_foul <- "intentional grounding|illegal forward pass"

# Infractions carrying an AUTOMATIC FIRST DOWN, deliberately NOT classified.
# See the @details note above: the replay signal cannot distinguish the two
# causes, so these resolve to "unknown" until a valid instrument exists.
.penalty_auto_first_down_foul <-
  "pass interference|personal foul|face ?mask|roughing|targeting|unsportsmanlike"

# ESPN's own negation marker. "no play" and "nullified by penalty" both appear;
# the second says nothing about "no play" on 26 of the 179 plays carrying it.
.penalty_negated_text <- "no play|nullified by penalty"

.penalty_enforcement <- function(raw_df) {
  if (!nrow(raw_df)) {
    return(dplyr::mutate(
      raw_df,
      penalty_count          = integer(),
      penalty_declined_count = integer(),
      penalty_all_declined   = logical(),
      penalty_enforcement    = character(),
      penalty_negated_play   = logical()
    ))
  }

  txt <- raw_df$play_text
  ci <- function(p) stringr::regex(p, ignore_case = TRUE)

  raw_df <- raw_df |>
    dplyr::mutate(
      # A play can carry more than one penalty (398 plays across 2015/2021/2025).
      # 54 of those have SOME but not all declined -- their down-replay rate is
      # 0.231 against 0.813 when none are declined, so the two groups genuinely
      # differ and collapsing them loses information.
      penalty_count          = stringr::str_count(txt, ci("penalty")),
      penalty_declined_count = stringr::str_count(txt, ci("declined"))
    ) |>
    dplyr::mutate(
      # Only when EVERY penalty was declined does the play stand.
      penalty_all_declined = .data$penalty_count > 0 &
        .data$penalty_count == .data$penalty_declined_count
    ) |>
    dplyr::mutate(
      # Resolved in priority order; `unknown` is a real answer, not a gap.
      penalty_enforcement = dplyr::case_when(
        !.data$penalty_flag                                     ~ NA_character_,
        .data$penalty_no_play                                   ~ "no_play",
        .data$penalty_all_declined                              ~ "declined",
        .data$penalty_offset                                    ~ "offsetting",
        stringr::str_detect(txt, ci(.penalty_auto_first_down_foul)) ~ "unknown",
        stringr::str_detect(txt, ci(.penalty_negating_foul))     ~ "negating_foul",
        stringr::str_detect(txt, ci(.penalty_play_stands_foul))  ~ "play_stands",
        TRUE                                                    ~ "unknown"
      )
    ) |>
    dplyr::mutate(
      # NA (not FALSE) for `unknown`, so a caller cannot silently read
      # "we do not know" as "the play counted".
      penalty_negated_play = dplyr::case_when(
        is.na(.data$penalty_enforcement)                                    ~ FALSE,
        .data$penalty_enforcement %in% c("no_play", "offsetting", "negating_foul") ~ TRUE,
        .data$penalty_enforcement %in% c("declined", "play_stands")         ~ FALSE,
        TRUE                                                                ~ NA
      )
    )

  raw_df
}
