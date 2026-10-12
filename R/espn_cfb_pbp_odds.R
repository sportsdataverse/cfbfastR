#' Pre-game line for an ESPN game: `spread` and `over_under`
#'
#' Port of sportsdataverse-py `CFBPlayProcess.__helper_cfb_pickcenter` and
#' `__helper__espn_cfb_odds_information__` (`sportsdataverse/cfb/cfb_pbp.py`,
#' main `dfdf288b`, lines 3739-3870). The game summary's `pickcenter` is used
#' when it lists more than one provider (games before 2024); ESPN emptied it for
#' 2024+, so those games, and any whose `pickcenter` is short, read the core-v2
#' odds collection, preferring ESPN BET.
#'
#' `spread` is the HOME team's line, negative when the home team is favoured --
#' the CFBD convention `.wp_pos_team_spread()` reads. Deliberate divergences
#' from sdv-py: a game with no line gets `NA`, not the `(2.5, 55.5)` defaults,
#' matching the CFBD path; a `pickcenter` whose providers carry no spread falls
#' through to the odds API (sdv-py takes 2.5 when the column is absent and
#' fails when every value is null); and a failed request warns rather than
#' reading as an unlined game.
#'
#' @param game_id ESPN game id.
#' @param season Season of the game. Before 2024 the summary is fetched for its
#'   `pickcenter`; from 2024 it is known to be empty and is not requested.
#' @return `list(spread, over_under)`, both `NA_real_` when no line is found.
#' @keywords internal
#' @noRd
.espn_cfb_pbp_line <- function(game_id, season) {
  none <- list(spread = NA_real_, over_under = NA_real_)
  fetch <- function(what, url) {
    tryCatch(.espn_cfb_json(url), error = function(e) {
      cli::cli_warn("Could not fetch the ESPN {what} for game {game_id}: {conditionMessage(e)}")
      NULL
    })
  }
  if (isTRUE(season < 2024)) {
    summary <- fetch("summary", paste0(
      "https://site.api.espn.com/apis/site/v2/sports/football/college-football/summary?event=",
      game_id
    ))
    line <- .espn_cfb_line_from_pickcenter(summary[["pickcenter"]])
    if (!is.null(line)) return(line)
  }
  odds <- fetch("odds", paste0(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/college-football/events/",
    game_id, "/competitions/", game_id, "/odds?limit=100"
  ))
  .espn_cfb_line_from_odds(odds[["items"]]) %||% none
}

#' GET an ESPN JSON resource as records; errors on any failure.
#' @keywords internal
#' @noRd
.espn_cfb_json <- function(url) {
  httr2::request(url) |>
    httr2::req_headers(
      `User-Agent` = paste0(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
        "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
      ),
      Accept = "application/json, text/plain, */*",
      Origin = "https://www.espn.com",
      Referer = "https://www.espn.com/"
    ) |>
    httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
    httr2::req_perform() |>
    httr2::resp_body_string(encoding = "UTF-8") |>
    jsonlite::fromJSON(simplifyVector = FALSE)
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

.espn_num <- function(x) suppressWarnings(as.numeric(x %||% NA)[1])
.espn_flag <- function(odds) as.logical(odds[["favorite"]] %||% NA)[1]

#' Line from the summary `pickcenter` records
#'
#' Providers ordered by id as sdv-py's string sort orders them; the spread,
#' total and favourite flag are each the first non-missing value, so they can
#' come from different providers, exactly as in sdv-py.
#' @keywords internal
#' @noRd
.espn_cfb_line_from_pickcenter <- function(pickcenter) {
  # one provider is not enough: sdv-py sends those games to the odds API
  if (length(pickcenter) < 2) return(NULL)
  ids <- vapply(pickcenter, function(p) as.character(p[["provider"]][["id"]] %||% NA)[1], character(1))
  pickcenter <- pickcenter[order(ids, method = "radix")]
  first <- function(x) x[!is.na(x)][1]
  spread <- first(vapply(pickcenter, function(p) .espn_num(p[["spread"]]), numeric(1)))
  if (is.na(spread)) return(NULL)
  fav <- first(vapply(pickcenter, function(p) .espn_flag(p[["homeTeamOdds"]]), logical(1)))
  list(
    spread = .espn_cfb_home_line(spread, fav),
    over_under = first(vapply(pickcenter, function(p) .espn_num(p[["overUnder"]]), numeric(1)))
  )
}

#' Line from the core-v2 odds `items`: the ESPN BET item, else the first
#'
#' As in sdv-py, an ESPN BET item without a spread means no line; other
#' providers are not consulted.
#' @keywords internal
#' @noRd
.espn_cfb_line_from_odds <- function(items) {
  if (!length(items)) return(NULL)
  names <- vapply(items, function(it) tolower(it[["provider"]][["name"]] %||% "")[1], character(1))
  it <- items[[c(which(names == "espn bet"), 1L)[1]]]
  spread <- .espn_num(it[["spread"]])
  if (is.na(spread)) return(NULL)
  list(spread = .espn_cfb_home_line(spread, .espn_flag(it[["homeTeamOdds"]])),
       over_under = .espn_num(it[["overUnder"]]))
}
