#' ESPN play types, as sdv-py retypes them before modeling
#'
#' Port of the relabel block at the end of sportsdataverse-py's
#' `__helper_cfb_pbp_features()` (cfb_pbp.py). Vectors are in play order: the
#' untyped two-point rule reads the last touchdown row before each row.
#'
#' * a row ESPN scored as a field goal / extra point (`scoringType`) takes that
#'   type -- the 2004 feed files its kicks with no type;
#' * a row with no type is "Unknown";
#' * a try the defence returned for two is a "Defensive 2pt Conversion" (2004-13
#'   files it as the kick it started as, or with no type);
#' * an untyped regulation row describing the two-point try its touchdown row
#'   already folds, at that touchdown's clock, is that try (401525903);
#' * 2007-13 old-NCAA feeds file a touchdown and its kick as ONE row typed as the
#'   kick: a pass / rush touchdown becomes the scrimmage type (its start spot from
#'   the text's "for N yards"), a return / fumble touchdown its return type, and a
#'   kickoff, field goal, penalty or period marker typed as a kick its own type.
#'
#' Not ported: the four "Extra Point Missed" string rules the block carried until
#' sportsdataverse-py #642. They only matched ESPN's "Blocked Field Goal
#' (Touchdown)" and mistyped ~71 of them; both sides keep ESPN's type.
#'
#' @param type,text Play type and text.
#' @param scoring_type ESPN `scoringType.displayName`.
#' @param period,clock Period number and clock display value.
#' @param scoring_play ESPN `scoringPlay`.
#' @param start_team,end_team Start / end possession team ids.
#' @param start_ytg,start_down,start_distance Start yards to the end zone, down, distance.
#' @param end_down,end_distance,end_ytg End down, distance, yards to the end zone.
#' @return List: `type`, `start_ytg`, `start_down`, `start_distance`.
#' @keywords internal
#' @noRd
.espn_retype_plays <- function(type, text, scoring_type, period, scoring_play, clock,
                               start_team, end_team, start_ytg, start_down, start_distance,
                               end_down, end_distance, end_ytg) {
  n <- length(type)
  orig <- as.character(type)
  tx <- ifelse(is.na(text), "", as.character(text))
  has <- function(pattern) grepl(pattern, tx, ignore.case = TRUE, perl = TRUE)
  type <- orig
  type <- ifelse(scoring_type %in% "Field Goal", "Field Goal Good", type)
  type <- ifelse(scoring_type %in% "Extra Point", "Extra Point Good", type)
  type <- ifelse(is.na(type), "Unknown", type)

  # polars comparisons with a null are null, and a null condition never fires
  def_try <- (type %in% .try_types | type == "Unknown") & has(.defensive_try_return)
  td_row <- grepl("touchdown", type, ignore.case = TRUE)
  # `x` on the last touchdown-typed row strictly before each row. sdv-py forward-fills
  # each column on its own, so a touchdown row with a null period / clock / text
  # reads an older touchdown's value there; R reads NA (no such row in the corpus)
  prev_td <- c(0L, cummax(ifelse(td_row, seq_len(n), 0L))[-n])
  last_td <- function(x) x[ifelse(prev_td > 0L, prev_td, NA_integer_)]
  untyped_2pt <- type == "Unknown" & (period <= 4) %in% TRUE & scoring_play %in% FALSE &
    has("two-point conversion") & (last_td(period) == period) %in% TRUE &
    (last_td(clock) == clock) %in% TRUE &
    grepl("conversion", last_td(as.character(text)), ignore.case = TRUE) %in% TRUE
  type <- ifelse(def_try, "Defensive 2pt Conversion",
                 ifelse(untyped_2pt,
                        ifelse(has("failed|no good"), "Two-Point Conversion Missed", "Two-Point Conversion Good"),
                        type))

  kick <- c("Extra Point Good", "Extra Point Missed")
  td_text <- has("touchdown|\\btd\\b")
  try_td <- has("(?:extra point|kick attempt|conversion).*(?:touchdown|\\btd\\b)")
  scrimmage_td <- type %in% c(kick, "2pt Conversion") & td_text &
    !(try_td | has("intercept|fumble|punt|kick ?off|\\breturn"))
  # the touchdown stood unless a no-play marker negates it; on a scored row only
  # the text up to the touchdown's clock tail counts (the try follows it)
  head <- sub("(touchdown, clock \\d{1,2}:\\d{2}).*$", "\\1", tx, ignore.case = TRUE, perl = TRUE)
  negated <- ifelse(scoring_play %in% TRUE,
                    grepl(.penalty_negated_text, head, ignore.case = TRUE, perl = TRUE),
                    has(.penalty_negated_text))
  same_team <- (start_team == end_team) %in% TRUE
  return_td <- type %in% kick & td_text & !try_td & has("intercept|fumbl|\\bpunt") & !negated &
    ((start_team != end_team) %in% TRUE | has("\\bpunt\\b.*\\bfumbl"))
  misfiled <- type %in% kick & !has("extra point|kick attempt|conversion|pass attempt|rush attempt")
  type <- ifelse(
    scrimmage_td,
    ifelse(has("\\bpass\\b"), "Pass Completion",
           ifelse(has("\\brush|\\brun\\b|scramble|sneak"), "Rush", type)),
    ifelse(
      return_td,
      ifelse(same_team, "Punt Team Fumble Recovery Touchdown",
             ifelse(has("\\bpunt\\b.*\\bblocked|\\bblocked punt"), "Blocked Punt Touchdown",
                    ifelse(has("\\bpunt\\b"), "Punt Return Touchdown",
                           ifelse(has("intercept"), "Interception Return Touchdown",
                                  "Fumble Recovery (Opponent) Touchdown")))),
      ifelse(
        misfiled,
        ifelse(has("\\bkickoff\\b"), "Kickoff",
               ifelse(has("field goal (?:is )?good"), "Field Goal Good",
                      ifelse(has("\\bpenalty\\b"), "Penalty",
                             ifelse(has("(?:start|end) of .*(?:quarter|half|overtime)"), "End Period", type)))),
        type)))

  # sdv-py's pre-2014 label normalization (__add_new_play_types), gated on labels
  # only the old feeds carry: the bare "2pt Conversion" is good or missed by the
  # scoring flag (the text wins), 2004's "Unknown" markers and kicks take their
  # type from the text, and an onside recovery "Kickoff Return (Defense)" is a kickoff
  unknown <- type == "Unknown"
  type <- ifelse(
    type == "2pt Conversion",
    ifelse(scoring_play %in% TRUE & !has("failed|no good"), "Two-Point Conversion Good",
           "Two-Point Conversion Missed"),
    ifelse(unknown & has("(start|end) of (the )?.*(quarter|half|game|overtime|regulation)"), "End Period",
    ifelse(unknown & has("field goal") & has("no good|missed|blocked"), "Field Goal Missed",
    ifelse(unknown & has("field goal") & has("is good"), "Field Goal Good",
    ifelse(unknown & has("extra point") & has("no good|missed|blocked"), "Extra Point Missed",
    ifelse(unknown & has("extra point") & has("is good"), "Extra Point Good",
    ifelse(type == "Kickoff Return (Defense)", "Kickoff", type)))))))

  # a touchdown's gain is its distance to the end zone: "for 19 yards" is where the snap was
  spot <- suppressWarnings(as.integer(sub("^.*?\\bfor (\\d{1,2}) (?:yards?|yds?|yd)\\b.*$", "\\1",
                                          tx, ignore.case = TRUE, perl = TRUE)))
  spot[!has("\\bfor \\d{1,2} (?:yards?|yds?|yd)\\b")] <- NA
  moved <- orig %in% c(kick, "2pt Conversion") & type %in% c("Pass Completion", "Rush")
  start_ytg <- ifelse(moved & !is.na(spot), spot, start_ytg)
  # ... and its down and distance are the snap's, not the try's (-1, -1: ESPN's 2005-13
  # "no down", which the EP model cannot score): the end state of the play before, when
  # that play ended at the snap's spot; otherwise first down, goal to go inside the 10.
  # ESPN writes "& Goal" as distance 0, the distance to the goal line.
  real <- !grepl("^(?:timeout|end\\b)", type, ignore.case = TRUE, perl = TRUE)
  prev_play <- function(x) {
    # sdv-py: when(real).then(x).shift(1).forward_fill()
    v <- c(x[NA_integer_], ifelse(real, x, NA)[-n])
    i <- cummax(ifelse(is.na(v), 0L, seq_len(n)))
    v[ifelse(i > 0L, i, NA_integer_)]
  }
  spot_ok <- (prev_play(end_ytg) == start_ytg) %in% TRUE & prev_play(end_down) %in% 1:4
  prev_dist <- prev_play(end_distance)
  start_down <- ifelse(moved, ifelse(spot_ok, prev_play(end_down), 1L), start_down)
  # goal to go is the distance to the goal line however far out (303102638: 3rd and
  # goal from the 13)
  start_distance <- ifelse(
    moved,
    ifelse(spot_ok & (prev_dist > 0) %in% TRUE, pmin(prev_dist, start_ytg, na.rm = TRUE),
           ifelse(spot_ok & (prev_dist == 0) %in% TRUE, start_ytg, pmin(10L, start_ytg, na.rm = TRUE))),
    start_distance)
  list(type = type, start_ytg = start_ytg, start_down = start_down, start_distance = start_distance)
}

.defensive_try_return <- paste0(
  "for (?:a )?(?:2-point |two-point |2 )?defensive (?:pat|two-point conversion|(?:point )?conversion)",
  "|returned\\b.{0,60}\\bfor (?:a )?(?:two|2)[- ]?point(?:s\\b| conversion)",
  "|missed pat returned"
)

#' Retype the ESPN v2 frame's plays before the adapter reads them
#'
#' Runs [.espn_retype_plays()] in play order and writes `type_text` and the start
#' state (`start_yards_to_endzone`, `start_down`, `start_distance`) back in the
#' frame's own row order.
#' @keywords internal
#' @noRd
.espn_retype_frame <- function(df, season) {
  if (!nrow(df)) return(df)
  stopifnot(c("scoring_type_display_name", "scoring_play") %in% names(df))
  o <- .espn_play_order(df$play_id, df$sequence_number, df$period, df$clock, df$drive_drive_id,
                        df$type_text, df$start_down_distance_text, df$end_down_distance_text,
                        season, df$home_score, df$away_score)
  rt <- .espn_retype_plays(df$type_text[o], df$text[o], df$scoring_type_display_name[o],
                           df$period[o], df$scoring_play[o], df$clock[o],
                           df$start_team_id[o], df$end_team_id[o], df$start_yards_to_endzone[o],
                           df$start_down[o], df$start_distance[o],
                           df$end_down[o], df$end_distance[o], df$end_yards_to_endzone[o])
  # the start team's margin change on the row (a kickoff's start team is the receiver):
  # this row's score against the row before it, the first row against 0-0
  n <- length(o)
  home <- as.character(df$home_team_id[o])
  away <- as.character(df$away_team_id[o])
  st <- as.character(df$start_team_id[o])
  pos <- ifelse(rt$type %in% .sdvpy_kickoff_types,
                ifelse(st == home, away, ifelse(st == away, home, st)), st)
  hs <- suppressWarnings(as.numeric(df$home_score[o]))
  as_ <- suppressWarnings(as.numeric(df$away_score[o]))
  hs0 <- c(0, hs[-n])
  as0 <- c(0, as_[-n])
  hs0[is.na(hs0)] <- 0
  as0[is.na(as0)] <- 0
  margin <- function(h, a) ifelse(pos == home, h - a, a - h)
  rt$type <- .espn_type_scored_rows(rt$type, df$text[o], df$scoring_play[o],
                                    margin(hs, as_) - margin(hs0, as0),
                                    tolower(df$scoring_type_display_name[o]) %in% "touchdown")
  df$type_text[o] <- rt$type
  df$start_yards_to_endzone[o] <- rt$start_ytg
  df$start_down[o] <- rt$start_down
  df$start_distance[o] <- rt$start_distance
  df
}

#' Rebuild the start spot the 2004 feed leaves at 0, as sdv-py does
#'
#' The 2004 feed writes `start.yardsToEndzone` 0 on every play; its `start.yardLine`
#' is the home-relative field position. sdv-py's features (cfb_pbp.py, `start.yard`)
#' turn that into yards to the end zone for the offence and use it where the feed's
#' is 0. (The end spot is not rebuilt: the engine builds the after-state from the
#' next play and the gain, and sdv-py's end-state backfills are a separate chain.)
#' @keywords internal
#' @noRd
.espn_fill_spots <- function(df) {
  if (!nrow(df)) return(df)
  home <- (as.character(df$start_team_id) == as.character(df$home_team_id)) %in% TRUE
  start_yard <- ifelse(home, 100L - df$start_yard_line, df$start_yard_line)
  df$start_yards_to_endzone <- ifelse((df$start_yards_to_endzone == 0) %in% TRUE, start_yard,
                                      df$start_yards_to_endzone)
  df
}

#' Type the rows ESPN scored that no text rule did, as sdv-py does
#'
#' Port of sportsdataverse-py's `_type_espn_scored_rows()` (cfb_pbp.py), the last
#' pass of its play-type fixes. A row ESPN marks `scoringPlay` whose type is still
#' not a score realised the play's model end state instead of the points. Who
#' scored is the start team's margin change on the row: +6 to +8 the offence, -6
#' to -8 the defence, +3 a field goal. Where ESPN's scoreboard does not move (2006-11
#' feeds freeze it across a pick-six), the play family says, when the text or ESPN's
#' `scoringType` says touchdown. A row whose margin credits the other side than its
#' family, and a frozen-board fumble on a rush or pass, are left as they are.
#'
#' @param type,text Play type (after [.espn_retype_plays()]) and text.
#' @param scoring_play ESPN `scoringPlay`.
#' @param delta The start team's margin change on the row.
#' @param espn_td ESPN's `scoringType` is a touchdown.
#' @return The play types.
#' @keywords internal
#' @noRd
.espn_type_scored_rows <- function(type, text, scoring_play, delta, espn_td) {
  ty <- ifelse(is.na(type), "", as.character(type))
  tx <- ifelse(is.na(text), "", as.character(text))
  has <- function(pattern) grepl(pattern, tx, ignore.case = TRUE, perl = TRUE)
  head <- sub("(touchdown, clock \\d{1,2}:\\d{2}).*$", "\\1", tx, ignore.case = TRUE, perl = TRUE)
  negated <- ifelse(scoring_play %in% TRUE,
                    grepl(.penalty_negated_text, head, ignore.case = TRUE, perl = TRUE),
                    has(.penalty_negated_text))
  scored <- scoring_play %in% TRUE & !(ty %in% .sdvpy_scored_types)
  td_evidence <- (has("touchdown|\\bfor a TD\\b") | has(.try_paren_re) | espn_td %in% TRUE) & !negated
  fam_int <- ty %in% .sdvpy_int_types | has("intercept")
  fam_punt <- ty %in% .sdvpy_punt_types | has("\\bpunt")
  fam_blocked_punt <- ty == "Blocked Punt" | (fam_punt & has("block"))
  fam_fg <- ty %in% c("Blocked Field Goal", "Field Goal Missed", "Missed Field Goal Return") |
    has("field goal|\\bfg\\b")
  # by type only: a kickoff's start team is the receiver, so its margin reads the other way
  fam_kick <- ty %in% .sdvpy_kickoff_types
  fam_fumble <- has("fumble")
  fam_pass <- grepl("^pass|reception|completion", ty, ignore.case = TRUE, perl = TRUE) |
    has("\\bpass(?:ed)?\\b")
  fam_rush <- ty %in% c("Rush", "Sack") | has("\\brush|\\brun\\b|\\bsacked\\b|\\bscrambl")
  defence_family <- fam_int | ty == "Fumble Recovery (Opponent)" | fam_blocked_punt |
    (fam_fg & has("block") & has("return"))
  moved <- (abs(delta) >= 6 & abs(delta) <= 8) %in% TRUE
  frozen <- (delta == 0) %in% TRUE & td_evidence
  td <- moved | frozen
  defence <- (moved & (delta < 0) %in% TRUE) | (frozen & defence_family)
  offence <- (moved & (delta > 0) %in% TRUE & !defence_family) |
    (frozen & !defence_family & !fam_fumble & (fam_pass | fam_rush))
  field_goal <- (delta %in% c(3, 0)) & !fam_kick & has("field goal\\b.*\\bgood|\\bfg good")
  # the defence scores on a rush or pass only through a turnover: a fumble, or a sack's
  def_turnover <- fam_fumble | ty == "Fumble Recovery (Opponent)" | ty == "Sack" | has("\\bsacked\\b")
  out <- as.character(type)
  pick <- function(cond, value) {
    hit <- cond & is.na(new)
    new[hit] <<- value
  }
  new <- rep(NA_character_, length(ty))
  pick(scored & field_goal & !td, "Field Goal Good")
  pick(scored & defence & fam_int, "Interception Return Touchdown")
  pick(scored & defence & fam_blocked_punt, "Blocked Punt Touchdown")
  pick(scored & defence & fam_punt, "Punt Return Touchdown")
  pick(scored & defence & fam_fg & has("block"), "Blocked Field Goal Touchdown")
  pick(scored & defence & fam_fg, "Missed Field Goal Return Touchdown")
  pick(scored & defence & fam_kick, "Kickoff Team Fumble Recovery Touchdown")
  pick(scored & defence & def_turnover, "Fumble Recovery (Opponent) Touchdown")
  pick(scored & offence & fam_kick, "Kickoff Return Touchdown")
  pick(scored & offence & fam_punt, "Punt Team Fumble Recovery Touchdown")
  pick(scored & offence & fam_fumble, "Fumble Recovery (Own) Touchdown")
  pick(scored & offence & fam_pass, "Passing Touchdown")
  pick(scored & offence & fam_rush, "Rushing Touchdown")
  ifelse(is.na(new), out, new)
}

#: A try or kick in parentheses closing a touchdown row: "(Aaron Boumerhi KICK)".
.try_paren_re <- "\\([^()]*\\b(?:kick|pat|two-point|2-point)\\b[^()]*\\)"

# sdv-py's model_vars lists, verbatim: the backstop reads sdv-py's notion of a score,
# not the engine taxonomy's (which files "Kickoff Return Touchdown" on both sides)
.sdvpy_kickoff_types <- c(
  "Kickoff", "Kickoff Return (Offense)", "Kickoff Return Touchdown", "Kickoff Touchdown",
  "Kickoff Team Fumble Recovery", "Kickoff Team Fumble Recovery Touchdown", "Kickoff (Safety)",
  "Penalty (Kickoff)"
)
.sdvpy_punt_types <- c(
  "Blocked Punt", "Blocked Punt Touchdown", "Blocked Punt (Safety)", "Punt (Safety)", "Punt",
  "Punt Return", "Punt Touchdown", "Punt Team Fumble Recovery", "Punt Team Fumble Recovery Touchdown",
  "Punt Return Touchdown"
)
.sdvpy_int_types <- c(
  "Interception", "Interception Return", "Interception Return Touchdown", "Pass Interception",
  "Pass Interception Return", "Pass Interception Return Touchdown"
)
.sdvpy_scored_types <- c(
  # scores_vec
  "Blocked Punt Touchdown", "Blocked Punt (Safety)", "Punt (Safety)", "Blocked Field Goal Touchdown",
  "Missed Field Goal Return Touchdown", "Fumble Recovery (Opponent) Touchdown", "Fumble Return Touchdown",
  "Interception Return Touchdown", "Pass Interception Return Touchdown", "Punt Touchdown",
  "Punt Return Touchdown", "Sack Touchdown", "Uncategorized Touchdown", "Defensive 2pt Conversion",
  "Uncategorized", "Two Point Rush", "Safety", "Penalty (Safety)", "Punt Team Fumble Recovery Touchdown",
  "Kickoff Team Fumble Recovery Touchdown", "Kickoff (Safety)", "Passing Touchdown", "Rushing Touchdown",
  "Field Goal Good", "Pass Reception Touchdown", "Fumble Recovery (Own) Touchdown",
  # offense_score_vec / defense_score_vec beyond it
  "Kickoff Return Touchdown", "Kickoff Touchdown",
  # the try rows (_TRY_TYPES)
  "Extra Point Good", "Extra Point Missed", "Two-Point Conversion Good", "Two-Point Conversion Missed",
  "Two Point Pass", "Blocked PAT"
)
