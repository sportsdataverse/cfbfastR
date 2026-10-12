#' Pre-game line for an ESPN game: `spread` and `over_under`
#'
#' Port of sportsdataverse-py `CFBPlayProcess.__helper_cfb_pickcenter` and
#' `__helper__espn_cfb_odds_information__` (`sportsdataverse/cfb/cfb_pbp.py`,
#' main `dfdf288b`, lines 3739-3870). The summary's `pickcenter` is used when
#' it lists more than one provider (every game before 2024); ESPN emptied it
#' for 2024+ games, so those fall back to the core-v2 odds collection,
#' preferring ESPN BET.
#'
#' `spread` is the HOME team's line, negative when the home team is favoured --
#' the CFBD convention [.wp_pos_team_spread()] reads. One deliberate divergence:
#' a game with no line gets `NA`, not sdv-py's `(2.5, 55.5)` defaults, matching
#' the CFBD path, where an unlined game keeps `NA` rather than a guessed spread.
#' Likewise a `pickcenter` whose providers carry no spread falls through to the
#' odds API (sdv-py takes 2.5 when the column is absent and fails when every
#' value is null). A failed odds request warns: it is not an unlined game.
#'
#' @param game_id ESPN game id.
#' @param pickcenter The summary's `pickcenter` array as a list of records
#'   (`NULL` when the caller has no summary, e.g. the core-v2 engine).
#' @return `list(spread, over_under)`, both `NA_real_` when no line is found.
#' @keywords internal
#' @noRd
.espn_cfb_pbp_line <- function(game_id, pickcenter = NULL) {
  line <- .espn_cfb_line_from_pickcenter(pickcenter)
  if (is.null(line)) {
    # espn_cfb_game_odds() turns a failed request into a message and an empty
    # frame, which would read exactly like a game with no line.
    failed <- FALSE
    odds <- withCallingHandlers(
      espn_cfb_game_odds(game_id),
      message = function(m) {
        failed <<- TRUE
        invokeRestart("muffleMessage")
      }
    )
    if (failed) {
      cli::cli_warn("Could not fetch the ESPN odds for game {game_id}; {.field spread} is {.code NA}.")
    }
    line <- .espn_cfb_line_from_odds(odds)
  }
  line %||% list(spread = NA_real_, over_under = NA_real_)
}

#' The home line from a spread and the home-favourite flag
#'
#' sdv-py takes the magnitude from the spread and the side from the flag. With
#' no flag, ESPN's spread is itself already the home line.
#' @keywords internal
#' @noRd
.espn_cfb_home_line <- function(spread, home_favorite) {
  if (is.na(spread) || is.na(home_favorite)) return(spread)
  if (isTRUE(home_favorite)) -abs(spread) else abs(spread)
}

#' Line from the summary `pickcenter`: providers ordered by id (as sdv-py's
#' string sort), first non-missing spread, total and favourite flag.
#' @keywords internal
#' @noRd
.espn_cfb_line_from_pickcenter <- function(pickcenter) {
  # one provider is not enough: sdv-py sends those games to the odds API
  if (length(pickcenter) < 2) return(NULL)
  num <- function(x) suppressWarnings(as.numeric(x %||% NA)[1])
  ids <- vapply(pickcenter, function(p) as.character(p$provider$id %||% NA)[1], character(1))
  pickcenter <- pickcenter[order(ids, method = "radix")]
  first <- function(x) x[!is.na(x)][1]
  spread <- first(vapply(pickcenter, function(p) num(p$spread), numeric(1)))
  if (is.na(spread)) return(NULL)
  fav <- first(vapply(pickcenter, function(p) as.logical(p$homeTeamOdds$favorite %||% NA)[1], logical(1)))
  list(
    spread = .espn_cfb_home_line(spread, fav),
    over_under = first(vapply(pickcenter, function(p) num(p$overUnder), numeric(1)))
  )
}

#' Line from an [espn_cfb_game_odds()] frame: the ESPN BET row, else the first.
#' @keywords internal
#' @noRd
.espn_cfb_line_from_odds <- function(odds) {
  if (!is.data.frame(odds) || !nrow(odds) || !"spread" %in% names(odds)) return(NULL)
  bet <- which(tolower(odds$provider_name) == "espn bet")
  row <- odds[if (length(bet)) bet[1] else 1, ]
  if (is.na(row$spread)) return(NULL)
  list(spread = .espn_cfb_home_line(row$spread, row$home_favorite),
       over_under = row$over_under)
}
