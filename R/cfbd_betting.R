
#' @name cfbd_betting
#' @aliases cfbd_betting betting lines spreads
#' @title
#' **CFBD Betting Endpoint Overview**
#' @description
#'
#' * `cfbd_betting_lines()`: Get betting lines information for games.
#' * `cfbd_betting_ats()`: Get against-the-spread (ATS) summary records by team.
#'
#' @details
#' ## **Get betting lines information for games**
#'
#' ```r
#' cfbd_betting_lines(year = 2018, week = 12, team = "Florida State")
#' ```
#'
#' ## **Get against-the-spread (ATS) summary records by team**
#'
#' ```r
#' cfbd_betting_ats(year = 2023, team = "Michigan")
#' ```
#'
NULL

#' @title **CFBD Betting Lines Endpoint Overview**
#' @description **Get betting lines information for games**
#' @param game_id (*Integer* optional): Game ID filter for querying a single game. Required if year not provided \cr
#' Can be found using the [cfbd_game_info()] function
#' @param year (*Integer* optional): Year, 4 digit format(*YYYY*). Required if game_id not provided
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* default regular): Select Season Type: regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param home_team (*String* optional): Home D-I Team
#' @param away_team (*String* optional): Away D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference \cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC \cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC \cr
#' @param line_provider (*String* optional): Select Line Provider - Caesars, consensus, numberfire, or teamrankings
#' @param provider (*String* optional): Sportsbook filter, e.g. `DraftKings`, `Bovada`, `ESPN Bet`.
#' @return Betting information for games with the following 21 columns:
#'
#'    |col_name            |types     |description                                                                |
#'    |:-------------------|:---------|:--------------------------------------------------------------------------|
#'    |game_id             |integer   |Unique CFBD game identifier.                                               |
#'    |season              |integer   |Four-digit season year (e.g. 2024).                                        |
#'    |season_type         |character |Season type (regular, postseason, both).                                   |
#'    |week                |integer   |Week of the season; 1-15, or 1-14 for seasons pre-playoff (2013 earlier).  |
#'    |start_date          |character |Kickoff timestamp in ISO 8601 format.                                      |
#'    |home_team           |character |Home D-I team name.                                                        |
#'    |home_conference     |character |Home team D-I conference.                                                  |
#'    |home_classification |character |Home team conference classification (fbs, fcs, ii, iii).                   |
#'    |home_score          |integer   |Final score of the home team.                                              |
#'    |away_team           |character |Away D-I team name.                                                        |
#'    |away_conference     |character |Away team D-I conference.                                                  |
#'    |away_classification |character |Away team conference classification (fbs, fcs, ii, iii).                   |
#'    |away_score          |integer   |Final score of the away team.                                              |
#'    |provider            |character |Sportsbook / line provider name.                                           |
#'    |spread              |character |Closing point spread for the game.                                         |
#'    |formatted_spread    |character |Human-readable formatted spread (e.g. "Florida State -7.5").               |
#'    |spread_open         |character |Opening point spread for the game.                                         |
#'    |over_under          |character |Closing over/under (total) for the game.                                   |
#'    |over_under_open     |character |Opening over/under (total) for the game.                                   |
#'    |home_moneyline      |character |Home team moneyline odds.                                                  |
#'    |away_moneyline      |character |Away team moneyline odds.                                                  |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_url_query req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom purrr map_if
#' @importFrom dplyr filter as_tibble rename
#' @importFrom tidyr unnest
#' @importFrom stringr str_replace_all
#' @family CFBD Betting Functions
#' @export
#' @examples
#' \donttest{
#'    try(cfbd_betting_lines(year = 2018, week = 12, team = "Florida State"))
#' }
cfbd_betting_lines <- function(game_id = NULL,
                               year = NULL,
                               week = NULL,
                               season_type = "regular",
                               team = NULL,
                               home_team = NULL,
                               away_team = NULL,
                               conference = NULL,
                               line_provider=NULL,
                               provider = NULL) {

  # Validation Lists ----
  providers <- c(
    'teamrankings', 'numberfire', 'consensus', 'Caesars', 'Bovada',
    'SugarHouse', 'William Hill (New Jersey)', 'Caesars (Pennsylvania)',
    'Caesars Sportsbook (Colorado)', 'ESPN Bet', 'DraftKings'
  )

  # Validation ----
  validate_api_key()
  validate_reqs(game_id, year)
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)
  validate_id(game_id)
  validate_list(line_provider, providers)

  # Team Name Handling ----
  team <- handle_accents(team)
  home_team <- handle_accents(home_team)
  away_team <- handle_accents(away_team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/lines"
  query_params <- list(
    "gameId" = game_id,
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "home" = home_team,
    "away" = away_team,
    "conference" = conference,
    "provider" = line_provider,
    "provider" = provider
  )
  full_url <- httr2::request(base_url) |>
    httr2::req_url_query(!!!.compact(query_params)) |>
    purrr::pluck("url")

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        stringr::str_replace_all("NaN", 'null') |>
        jsonlite::fromJSON(flatten = TRUE) |>
        purrr::map_if(is.data.frame, list) |>
        dplyr::as_tibble() |>
        tidyr::unnest("lines")


      if (!is.null(line_provider)) {
        if (is.list(df) & length(df) == 0) {
          df <- data.frame(game_id = game_id, spread = 0, formatted_spread = "home 0")
        } else if (!is.null(df$provider)) {
          df <- df |>
            dplyr::filter(.data$provider == line_provider) |>
            janitor::clean_names() |>
            dplyr::rename("game_id" = "id") |>
            as.data.frame()
        } else {
          df <- data.frame(game_id = game_id, spread = 0, formatted_spread = "home 0")
        }
      }
      if (is.list(df) & length(df) == 0) {
        df <- data.frame(game_id = game_id, spread = 0, formatted_spread = "home 0")
      } else {
        df <- df |>
          janitor::clean_names() |>
          dplyr::rename("game_id" = "id") |>
          as.data.frame()
      }

      df <- df |>
        make_cfbfastR_data("Betting lines data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no betting lines data available! {conditionMessage(e)}"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title **CFBD Against-the-Spread (ATS) Records**
#' @description **Get against-the-spread (ATS) summary records by team**
#'
#' Retrieves a season-level against-the-spread summary for each team:
#' how often the team covered, failed to cover, or pushed relative to
#' the closing spread, plus the average margin by which it beat the
#' spread. Complements [cfbd_betting_lines()], which returns the
#' per-game lines themselves.
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*).
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference \cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC \cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC \cr
#' @return Against-the-spread records with the following 9 columns:
#'
#'    |col_name         |types     |description                                                  |
#'    |:----------------|:---------|:------------------------------------------------------------|
#'    |year             |integer   |Four-digit season year.                                      |
#'    |team_id          |integer   |Unique CFBD team identifier.                                 |
#'    |team             |character |D-I team name.                                               |
#'    |conference       |character |Team conference name.                                        |
#'    |games            |integer   |Number of games included in the ATS summary.                 |
#'    |ats_wins         |integer   |Games the team covered the spread.                           |
#'    |ats_losses       |integer   |Games the team failed to cover the spread.                   |
#'    |ats_pushes       |integer   |Games that pushed against the spread.                        |
#'    |avg_cover_margin |numeric   |Average margin by which the team beat the spread.            |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_url_query req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom dplyr as_tibble
#' @family CFBD Betting Functions
#' @export
#' @examples
#' \donttest{
#'    try(cfbd_betting_ats(year = 2023, team = "Michigan"))
#' }
cfbd_betting_ats <- function(year = NULL,
                             team = NULL,
                             conference = NULL) {

  # Validation ----
  validate_api_key()
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the against-the-spread endpoint.")
  }
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/teams/ats"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference
  )
  full_url <- httr2::request(base_url) |>
    httr2::req_url_query(!!!.compact(query_params)) |>
    purrr::pluck("url")

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content -- /teams/ats returns a flat array, no nesting
      parsed <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      if (is.data.frame(parsed) && nrow(parsed) > 0) {
        df <- parsed |>
          janitor::clean_names() |>
          dplyr::as_tibble()
      }

      df <- df |>
        make_cfbfastR_data("Against-the-spread records from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ATS data available! {conditionMessage(e)}"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
