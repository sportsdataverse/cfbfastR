#' @name cfbd_games
#' @aliases cfbd_games
#' @title
#' **CFBD Games Endpoint Overview**
#' @description Get results, statistics and information for games
#'
#' * `cfbd_game_box_advanced()`: Get game advanced box score information.
#' * `cfbd_game_player_stats()`: Get results information from games.
#' * `cfbd_game_team_stats()`: Get team statistics by game.
#' * `cfbd_game_info()`: Get results information from games.
#' * `cfbd_live_scoreboard()`: Get live scoreboard information.
#' * `cfbd_game_weather()`: Get weather from games.
#' * `cfbd_game_records()`: Get team records by year.
#' * `cfbd_calendar()`: Get calendar of weeks by season.
#' * `cfbd_game_media()`: Get game media information (TV, radio, etc).
#'
#' @details
#' ### **Get game advanced box score information.**
#' ```r
#' cfbd_game_box_advanced(game_id = 401114233)
#' ```
#' ### **Get player statistics by game**
#' ```r
#' cfbd_game_player_stats(2018, week = 15, conference = "Ind")
#'
#' cfbd_game_player_stats(2013, week = 1, team = "Florida State", category = "passing")
#' ```
#' ### **Get team records by year**
#' ```r
#' cfbd_game_records(2018, team = "Notre Dame")
#'
#' cfbd_game_records(2013, team = "Florida State")
#' ```
#' ### **Get team statistics by game**
#' ```r
#' cfbd_game_team_stats(2019, team = "LSU")
#'
#' cfbd_game_team_stats(2013, team = "Florida State")
#' ```
#' ### **Get results information from games.**
#' ```r
#' cfbd_game_info(2018, week = 1)
#'
#' cfbd_game_info(2018, week = 7, conference = "Ind")
#'
#' # 7 OTs LSU @ TAMU
#' cfbd_game_info(2018, week = 13, team = "Texas A&M", quarter_scores = TRUE)
#' ```
#' ### **Get weather from games.**
#' ```r
#' cfbd_game_weather(2018, week = 1)
#'
#' cfbd_game_info(2018, week = 7, conference = "Ind")
#'```
#' ### **Get calendar of weeks by season.**
#' ```r
#' cfbd_calendar(2019)
#' ```
#' ### **Get game media information (TV, radio, etc).**
#' ```r
#' cfbd_game_media(2019, week = 4, conference = "ACC")
#' ```
#'
NULL

# Internal: resolve a conference abbreviation (e.g. "SEC") to its full
# `cfbd_conferences()` name (e.g. "SEC" -> "SEC", "P12" -> "Pac-12"). Used
# by the per-conference filter sites in `cfbd_game_team_stats()` and
# similar wrappers. Returns a length-1 character; errors loudly via cli
# when the abbreviation matches zero rows or more than one row in the
# conferences table (the prior code passed the multi-element vector
# straight to `dplyr::filter()`, producing the "longer object length is
# not a multiple of shorter object length" recycling warning and an
# incomplete filtered frame -- see GH #119).
#' @noRd
#' @keywords internal
.lookup_conference_name <- function(conference) {
  confs <- cfbd_conferences()
  match_rows <- confs[confs$abbreviation == conference, , drop = FALSE]
  if (nrow(match_rows) == 0L) {
    cli::cli_abort(c(
      "Unknown conference abbreviation {.val {conference}}.",
      i = "See {.fn cfbd_conferences} for the list of valid abbreviations."
    ))
  }
  if (nrow(match_rows) > 1L) {
    cli::cli_warn(c(
      "Multiple conferences match abbreviation {.val {conference}}.",
      i = "Using the first match: {.val {match_rows$name[1L]}}.",
      i = "Other matches: {.val {match_rows$name[-1L]}}."
    ))
  }
  match_rows$name[1L]
}

#' @title
#' **Get results information from games.**
#' @param year (*Integer* required): Year, 4 digit format(*YYYY*)
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* default both): Select Season Type: regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param home_team (*String* optional): Home D-I Team
#' @param away_team (*String* optional): Away D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param division (*String* optional): Division abbreviation - Select a valid division: fbs/fcs/ii/iii
#' @param game_id (*Integer* optional): Game ID filter for querying a single game
#' @param quarter_scores (*Logical* default FALSE): This is a parameter to return the
#' list columns that give the score at each quarter: `home_line_scores` and `away_line_scores`.
#' I have defaulted the parameter to false so that you will not have to go to the trouble of dropping it.
#'
#' @param competition (*String* optional): Competition filter; `cfp` restricts to College Football Playoff games.
#' @param round (*String* optional): Playoff round -- `first_round`, `quarterfinal`, `semifinal`, `championship`.
#' @return [cfbd_game_info()] - A data frame with 30 variables:
#'
#'   |col_name           |types     |description                                                                |
#'   |:------------------|:---------|:--------------------------------------------------------------------------|
#'   |game_id            |integer   |Referencing game id.                                                       |
#'   |season             |integer   |Season of the game.                                                        |
#'   |week               |integer   |Game week.                                                                 |
#'   |season_type        |character |Season type of the game.                                                   |
#'   |start_date         |character |Game date.                                                                 |
#'   |start_time_tbd     |logical   |TRUE/FALSE flag for if the game's start time is to be determined.          |
#'   |neutral_site       |logical   |TRUE/FALSE flag for the game taking place at a neutral site.               |
#'   |conference_game    |logical   |TRUE/FALSE flag for this game qualifying as a conference game.             |
#'   |attendance         |integer   |Reported attendance at the game.                                           |
#'   |venue_id           |integer   |Referencing venue id.                                                      |
#'   |venue              |character |Venue name.                                                                |
#'   |home_id            |integer   |Home team referencing id.                                                  |
#'   |home_team          |character |Home team name.                                                            |
#'   |home_conference    |character |Home team conference.                                                      |
#'   |home_division      |character |Home team division.                                                        |
#'   |home_points        |integer   |Home team points.                                                          |
#'   |home_post_win_prob |character |Home team post-game win probability.                                       |
#'   |home_pregame_elo   |character |Home team pre-game ELO rating.                                             |
#'   |home_postgame_elo  |character |Home team post-game ELO rating.                                            |
#'   |away_id            |integer   |Away team referencing id.                                                  |
#'   |away_team          |character |Away team name.                                                            |
#'   |away_conference    |character |Away team conference.                                                      |
#'   |away_division      |character |Away team division.                                                        |
#'   |away_points        |integer   |Away team points.                                                          |
#'   |away_post_win_prob |character |Away team post-game win probability.                                       |
#'   |away_pregame_elo   |character |Away team pre-game ELO rating.                                             |
#'   |away_postgame_elo  |character |Away team post-game ELO rating.                                            |
#'   |excitement_index   |character |Game excitement index.                                                     |
#'   |highlights         |character |Game highlight urls.                                                       |
#'   |notes              |character |Game notes.                                                                |
#'
#' @keywords Game Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Games
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_game_info(2018, week = 7, conference = "Ind"))
#' }

cfbd_game_info <- function(year,
                           week = NULL,
                           season_type = "both",
                           team = NULL,
                           home_team = NULL,
                           away_team = NULL,
                           conference = NULL,
                           division = 'fbs',
                           game_id = NULL,
                           quarter_scores = FALSE,
                           competition = NULL,
                           round = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)
  validate_id(game_id)

  # Team Name Handling ----
  team <- handle_accents(team)
  home_team <- handle_accents(home_team)
  away_team <- handle_accents(away_team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/games?"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "home" = home_team,
    "away" = away_team,
    "conference" = conference,
    # CFBD v5 renamed this query parameter to `classification`; sending
    # `division=` is silently IGNORED (measured: division=fcs returned all
    # 270 week-5 games, classification=fcs returned the correct 56). The R
    # argument keeps its name so callers are unaffected.
    "classification" = division,
    "id" = game_id,
    "competition" = competition,
    "round" = round
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        janitor::clean_names()

      if (!quarter_scores) {
        df <- dplyr::select(df, -"home_line_scores", -"away_line_scores") |>
          dplyr::rename("game_id" = "id") |>
          as.data.frame()
      } else {
        df <- df |>
          tidyr::unnest_wider("home_line_scores", names_sep = "_Q") |>
          tidyr::unnest_wider("away_line_scores", names_sep = "_Q")

        colnames(df) <- gsub("_line_scores", "_scores", colnames(df))
        df <- df |>
          dplyr::rename("game_id" = "id")
      }
      df <- df |>
        dplyr::rename(
          "home_division" = "home_classification",
          "home_post_win_prob" = "home_postgame_win_probability",
          "away_division" = "away_classification",
          "away_post_win_prob" = "away_postgame_win_probability"
        ) |>
        make_cfbfastR_data("Game information from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game info data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get weather from games.**
#' @param year (*Integer* required): Year, 4 digit format(*YYYY*)
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* default regular): Select Season Type: regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#'
#' @param division (*String* optional): Division/classification filter -- one of `fbs`, `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.
#' @return [cfbd_game_weather()] - A data frame with 23 variables:
#'
#'   |col_name               |types     |description                                                          |
#'   |:----------------------|:---------|:--------------------------------------------------------------------|
#'   |game_id                |integer   |Referencing game id.                                                 |
#'   |season                 |integer   |Season of the game.                                                  |
#'   |week                   |integer   |Game week.                                                           |
#'   |season_type            |character |Season type of the game.                                             |
#'   |start_date             |character |Game date.                                                           |
#'   |start_time_tbd         |logical   |TRUE/FALSE flag for if the game's start time is to be determined.    |
#'   |game_indoors           |logical   |TRUE/FALSE flag for if the game is indoors.                          |
#'   |home_team              |character |Home team name.                                                      |
#'   |home_conference        |character |Home team conference.                                                |
#'   |away_team              |character |Away team name.                                                      |
#'   |away_conference        |character |Away team conference.                                                |
#'   |venue_id               |integer   |Referencing venue id.                                                |
#'   |venue                  |character |Venue name.                                                          |
#'   |temperature            |integer   |Game-time temperature, in degrees Fahrenheit.                        |
#'   |dew_point              |integer   |Dew point at kickoff, in degrees Fahrenheit.                         |
#'   |humidity               |integer   |Relative humidity at kickoff, as a percentage (0-100).               |
#'   |precipitation          |integer   |Precipitation total at kickoff, in inches.                           |
#'   |snowfall               |integer   |Snowfall total at kickoff, in inches.                                |
#'   |wind_direction         |integer   |Wind direction, in degrees (0-360, 0 = north).                       |
#'   |wind_speed             |integer   |Wind speed, in miles per hour.                                       |
#'   |pressure               |integer   |Barometric pressure, in millibars.                                   |
#'   |weather_condition_code |integer   |Weather condition code from the upstream weather provider.           |
#'   |weather_condition      |character |Free-text weather condition (e.g. "Clear", "Light rain").            |
#'
#' @keywords Game Weather
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Games
#' @export
cfbd_game_weather <- function(year,
                              week = NULL,
                              season_type = "regular",
                              team = NULL,
                              conference = NULL,
                              division = NULL) {

  # Validation ----
  validate_api_key()
  validate_division(division)
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/games/weather?"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "classification" = division
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content as parsed JSON first so we can distinguish an
      # empty-array response (upstream has not collected weather for
      # this year/week yet -- common during the in-season window before
      # CFBD backfills, see GH #116) from a parse/HTTP error.
      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON()

      if (length(raw) == 0L || (is.data.frame(raw) && nrow(raw) == 0L)) {
        cli::cli_alert_info(c(
          "CFBD returned no weather rows for the requested filters.",
          "i" = "CFBD backfills weather mid-week during the season; ",
          "i" = "try again later, or pass a prior `year` to confirm the call shape."
        ))
        df <- data.frame()
      } else {
        df <- raw |>
          janitor::clean_names() |>
          dplyr::rename("game_id" = "id") |>
          make_cfbfastR_data(
            "Game weather data from CollegeFootballData.com",
            Sys.time()
          )
      }
    },
    error = function(e) {
      cli::cli_alert_danger(c(
        "{Sys.time()}: Failed to fetch game weather data.",
        "x" = "Error: {conditionMessage(e)}"
      ))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get calendar of weeks by season.**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @return [cfbd_calendar()] - A data frame with 5 variables:
#'
#'   |col_name         |types     |description                                       |
#'   |:----------------|:---------|:-------------------------------------------------|
#'   |season           |character |Calendar season.                                  |
#'   |week             |integer   |Calendar game week.                               |
#'   |season_type      |character |Season type of calendar week.                     |
#'   |first_game_start |character |First game start time of the calendar week.      |
#'   |last_game_start  |character |Last game start time of the calendar week.       |
#'
#' @importFrom dplyr rename mutate
#' @importFrom janitor clean_names
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Games
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_calendar(2019))
#' }

cfbd_calendar <- function(year) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/calendar?"
  query_params <- list(
    "year" = year
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        janitor::clean_names() |>
        dplyr::select(
          "season",
          "week",
          "season_type",
          "first_game_start" = "start_date",
          "last_game_start" = "end_date"
        )


      df <- df |>
        make_cfbfastR_data("Calendar data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no calendar data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get game media information (TV, radio, etc).**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param week (*Integer* optional): Week, values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* default both): Select Season Type, regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param media_type (*String* optional): Media type filter: tv, radio, web, ppv, or mobile
#' @param division (*String* optional): Division abbreviation - Select a valid division: fbs/fcs/ii/iii
#'
#' @return [cfbd_game_media()] - A data frame with 13 variables:
#'
#'   |col_name          |types     |description                                                       |
#'   |:-----------------|:---------|:-----------------------------------------------------------------|
#'   |game_id           |integer   |Referencing game id.                                              |
#'   |season            |integer   |Season of the game.                                               |
#'   |week              |integer   |Game week.                                                        |
#'   |season_type       |character |Season type of the game.                                          |
#'   |start_time        |character |Game start time.                                                  |
#'   |is_start_time_tbd |logical   |TRUE/FALSE flag for if the start time is still to be determined.  |
#'   |home_team         |character |Home team of the game.                                            |
#'   |home_conference   |character |Conference of the home team.                                      |
#'   |away_team         |character |Away team of the game.                                            |
#'   |away_conference   |character |Conference of the away team.                                      |
#'   |tv                |list      |TV broadcast networks.                                            |
#'   |radio             |logical   |Radio broadcast networks.                                         |
#'   |web               |list      |Web viewing platforms carrying the game.                          |
#'
#' @keywords Game Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom dplyr rename select all_of everything
#' @importFrom tidyr pivot_wider
#' @family CFBD Games
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_game_media(2019, week = 4, conference = "ACC"))
#' }
cfbd_game_media <- function(year,
                            week = NULL,
                            season_type = "both",
                            team = NULL,
                            conference = NULL,
                            media_type = NULL,
                            division = 'fbs') {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/games/media?"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "mediaType" = media_type,
    "classification" = division
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  cols <- c(
    "game_id", "season", "week", "season_type", "start_time",
    "is_start_time_tbd", "home_team", "home_conference", "away_team",
    "away_conference", "tv", "radio", "web"
  )

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        tidyr::pivot_wider(
          names_from = "mediaType",
          values_from = "outlet",
          values_fn = list
        ) |>
        janitor::clean_names() |>
        dplyr::rename("game_id" = "id")

      df[cols[!(cols %in% colnames(df))]] <- NA
      df <- df[!duplicated(df), ]

      df <- df |>
        dplyr::select(dplyr::all_of(cols), dplyr::everything())


      df <- df |>
        make_cfbfastR_data("Game media data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game media data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **Get game advanced box score information.**
#' @param game_id (*Integer* required): Game ID filter for querying a single game
#' Can be found using the [cfbd_game_info()] function
#' @param long (*Logical* default `FALSE`): Return the data in a long format.
#' @return [cfbd_game_box_advanced()] - A data frame with 2 rows and 69 variables:
#'
#'   |col_name                              |types     |description                                                                       |
#'   |:-------------------------------------|:---------|:---------------------------------------------------------------------------------|
#'   |team                                  |character |Team name.                                                                        |
#'   |plays                                 |numeric   |Number of plays.                                                                  |
#'   |ppa_overall_total                     |numeric   |Predicted points added (PPA) overall total.                                       |
#'   |ppa_overall_quarter1                  |numeric   |Predicted points added (PPA) overall Q1.                                          |
#'   |ppa_overall_quarter2                  |numeric   |Predicted points added (PPA) overall Q2.                                          |
#'   |ppa_overall_quarter3                  |numeric   |Predicted points added (PPA) overall Q3.                                          |
#'   |ppa_overall_quarter4                  |numeric   |Predicted points added (PPA) overall Q4.                                          |
#'   |ppa_passing_total                     |numeric   |Passing predicted points added (PPA) total.                                       |
#'   |ppa_passing_quarter1                  |numeric   |Passing predicted points added (PPA) Q1.                                          |
#'   |ppa_passing_quarter2                  |numeric   |Passing predicted points added (PPA) Q2.                                          |
#'   |ppa_passing_quarter3                  |numeric   |Passing predicted points added (PPA) Q3.                                          |
#'   |ppa_passing_quarter4                  |numeric   |Passing predicted points added (PPA) Q4.                                          |
#'   |ppa_rushing_total                     |numeric   |Rushing predicted points added (PPA) total.                                       |
#'   |ppa_rushing_quarter1                  |numeric   |Rushing predicted points added (PPA) Q1.                                          |
#'   |ppa_rushing_quarter2                  |numeric   |Rushing predicted points added (PPA) Q2.                                          |
#'   |ppa_rushing_quarter3                  |numeric   |Rushing predicted points added (PPA) Q3.                                          |
#'   |ppa_rushing_quarter4                  |numeric   |Rushing predicted points added (PPA) Q4.                                          |
#'   |cumulative_ppa_plays                  |numeric   |Cumulative predicted points added (PPA) added total.                              |
#'   |cumulative_ppa_overall_total          |numeric   |Cumulative predicted points added (PPA) total.                                    |
#'   |cumulative_ppa_overall_quarter1       |numeric   |Cumulative predicted points added (PPA) Q1.                                       |
#'   |cumulative_ppa_overall_quarter2       |numeric   |Cumulative predicted points added (PPA) Q2.                                       |
#'   |cumulative_ppa_overall_quarter3       |numeric   |Cumulative predicted points added (PPA) Q3.                                       |
#'   |cumulative_ppa_overall_quarter4       |numeric   |Cumulative predicted points added (PPA) Q4.                                       |
#'   |cumulative_ppa_passing_total          |numeric   |Cumulative passing predicted points added (PPA) total.                            |
#'   |cumulative_ppa_passing_quarter1       |numeric   |Cumulative passing predicted points added (PPA) Q1.                               |
#'   |cumulative_ppa_passing_quarter2       |numeric   |Cumulative passing predicted points added (PPA) Q2.                               |
#'   |cumulative_ppa_passing_quarter3       |numeric   |Cumulative passing predicted points added (PPA) Q3.                               |
#'   |cumulative_ppa_passing_quarter4       |numeric   |Cumulative passing predicted points added (PPA) Q4.                               |
#'   |cumulative_ppa_rushing_total          |numeric   |Cumulative rushing predicted points added (PPA) total.                            |
#'   |cumulative_ppa_rushing_quarter1       |numeric   |Cumulative rushing predicted points added (PPA) Q1.                               |
#'   |cumulative_ppa_rushing_quarter2       |numeric   |Cumulative rushing predicted points added (PPA) Q2.                               |
#'   |cumulative_ppa_rushing_quarter3       |numeric   |Cumulative rushing predicted points added (PPA) Q3.                               |
#'   |cumulative_ppa_rushing_quarter4       |numeric   |Cumulative rushing predicted points added (PPA) Q4.                               |
#'   |success_rates_overall_total           |numeric   |Success rates overall total.                                                      |
#'   |success_rates_overall_quarter1        |numeric   |Success rates overall Q1.                                                         |
#'   |success_rates_overall_quarter2        |numeric   |Success rates overall Q2.                                                         |
#'   |success_rates_overall_quarter3        |numeric   |Success rates overall Q3.                                                         |
#'   |success_rates_overall_quarter4        |numeric   |Success rates overall Q4.                                                         |
#'   |success_rates_standard_downs_total    |numeric   |Success rates standard downs total.                                               |
#'   |success_rates_standard_downs_quarter1 |numeric   |Success rates standard downs Q1.                                                  |
#'   |success_rates_standard_downs_quarter2 |numeric   |Success rates standard downs Q2.                                                  |
#'   |success_rates_standard_downs_quarter3 |numeric   |Success rates standard downs Q3.                                                  |
#'   |success_rates_standard_downs_quarter4 |numeric   |Success rates standard downs Q4.                                                  |
#'   |success_rates_passing_downs_total     |numeric   |Success rates passing downs total.                                                |
#'   |success_rates_passing_downs_quarter1  |numeric   |Success rates passing downs Q1.                                                   |
#'   |success_rates_passing_downs_quarter2  |numeric   |Success rates passing downs Q2.                                                   |
#'   |success_rates_passing_downs_quarter3  |numeric   |Success rates passing downs Q3.                                                   |
#'   |success_rates_passing_downs_quarter4  |numeric   |Success rates passing downs Q4.                                                   |
#'   |explosiveness_overall_total           |numeric   |Explosiveness rates overall total.                                                |
#'   |explosiveness_overall_quarter1        |numeric   |Explosiveness rates overall Q1.                                                   |
#'   |explosiveness_overall_quarter2        |numeric   |Explosiveness rates overall Q2.                                                   |
#'   |explosiveness_overall_quarter3        |numeric   |Explosiveness rates overall Q3.                                                   |
#'   |explosiveness_overall_quarter4        |numeric   |Explosiveness rates overall Q4.                                                   |
#'   |rushing_power_success                 |numeric   |Rushing power success rate.                                                       |
#'   |rushing_stuff_rate                    |numeric   |Rushing stuff rate.                                                               |
#'   |rushing_line_yds                      |numeric   |Rushing offensive line yards.                                                     |
#'   |rushing_line_yds_avg                  |numeric   |Rushing line yards average.                                                       |
#'   |rushing_second_lvl_yds                |numeric   |Rushing second-level yards.                                                       |
#'   |rushing_second_lvl_yds_avg            |numeric   |Average second level yards per rush.                                              |
#'   |rushing_open_field_yds                |numeric   |Rushing open field yards.                                                         |
#'   |rushing_open_field_yds_avg            |numeric   |Average rushing open field yards average.                                         |
#'   |havoc_total                           |numeric   |Total havoc rate.                                                                 |
#'   |havoc_front_seven                     |numeric   |Front-7 players havoc rate.                                                       |
#'   |havoc_db                              |numeric   |Defensive back players havoc rate.                                                |
#'   |scoring_opps_opportunities            |numeric   |Number of scoring opportunities.                                                  |
#'   |scoring_opps_points                   |numeric   |Points on scoring opportunity drives.                                             |
#'   |scoring_opps_pts_per_opp              |numeric   |Points per scoring opportunity drives.                                            |
#'   |field_pos_avg_start                   |numeric   |Average starting field position.                                                  |
#'   |field_pos_avg_starting_predicted_pts  |numeric   |Average starting predicted points (PP) for the average starting field position.   |
#'
#' @keywords Game Advanced Box Score
#' @importFrom tibble enframe
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom stringr str_detect
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @family CFBD Games
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_game_box_advanced(game_id = 401114233))
#' }
#'

cfbd_game_box_advanced <- function(game_id, long = FALSE) {

  # Validation ----
  validate_api_key()
  validate_id(game_id)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/game/box/advanced?"
  query_params <- list(
    "id" = game_id
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content, tidyr::unnest, and return result as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        purrr::map_if(is.data.frame, list) |>
        purrr::map_if(is.data.frame, list)

      df <- tibble::enframe(unlist(df$teams, use.names = TRUE))
      team1 <- seq(1, nrow(df) - 1, by = 2)
      df1 <- df[team1, ] |>
        dplyr::rename(
          "stat" = "name",
          "team1" = "value"
        )

      team2 <- seq(2, nrow(df), by = 2)
      df2 <- df[team2, ] |>
        dplyr::rename("team2" = "value") |>
        dplyr::select("team2")

      df <- data.frame(cbind(df1, df2))
      df$stat <- substr(df$stat, 1, nchar(df$stat) - 1)
      df$stat <- sub(".overall.", "_overall_", df$stat)
      df$stat <- sub("Downs.", "_downs_", df$stat)
      df$stat <- sub("Rates.", "_rates_", df$stat)
      df$stat <- sub("Rate", "_rate", df$stat)
      df$stat <- sub(".passing.", "_passing_", df$stat)
      df$stat <- sub(".rushing.", "_rushing_", df$stat)
      df$stat <- sub("rushing.", "rushing_", df$stat)
      df$stat <- sub("rushing.", "rushing_", df$stat)
      df$stat <- sub("fieldPosition.", "field_pos_", df$stat)
      df$stat <- sub("lineYards", "line_yds", df$stat)
      df$stat <- sub("secondLevelYards", "second_lvl_yds", df$stat)
      df$stat <- sub("openFieldYards", "open_field_yds", df$stat)
      df$stat <- sub("Success", "_success", df$stat)
      df$stat <- sub("scoringOpportunities.", "scoring_opps_", df$stat)
      df$stat <- sub("pointsPerOpportunity", "pts_per_opp", df$stat)
      df$stat <- sub("Seven", "_seven", df$stat)
      df$stat <- sub("havoc.", "havoc_", df$stat)
      df$stat <- sub(".Average", "_avg", df$stat)
      df$stat <- sub("averageStartingPredictedPoints", "avg_starting_predicted_pts", df$stat)
      df$stat <- sub("averageStart", "avg_start", df$stat)
      df$stat <- sub(".team", "_team", df$stat)
      df$stat <- sub(".plays", "_plays", df$stat)
      df$stat <- sub("cumulativePpa", "cumulative_ppa", df$stat)

      if (!long) {
        team <- df |>
          dplyr::filter(.data$stat == "ppa_team") |>
          tidyr::pivot_longer(cols = c("team1", "team2")) |>
          dplyr::transmute(team = .data$value)

        df <- df |>
          dplyr::filter(!stringr::str_detect(.data$stat, "team")) |>
          tidyr::pivot_longer(cols = c("team1", "team2")) |>
          tidyr::pivot_wider(names_from = "stat", values_from = "value") |>
          dplyr::select(-"name") |>
          dplyr::mutate_all(as.numeric) |>
          dplyr::bind_cols(team)  |>
          dplyr::select("team", dplyr::everything())
        df <- df |>
          dplyr::rename(
            "rushing_line_yds_avg" = "rushing_line_yd_avg",
            "rushing_second_lvl_yds_avg" = "rushing_second_lvl_yd_avg",
            "rushing_open_field_yds_avg" = "rushing_open_field_yd_avg")

        df <- df |>
          make_cfbfastR_data("Advanced box score data from CollegeFootballData.com",Sys.time())

      }
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: game_id '{game_id}' invalid or no game advanced box score data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get player statistics by game**
#' @param year (*Integer* required): Year, 4 digit format(*YYYY*)
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* default regular): Select Season Type: regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param category (*String* optional): Category filter (e.g defensive)
#' Offense: passing, receiving, rushing
#' Defense: defensive, fumbles, interceptions
#' Special Teams: punting, puntReturns, kicking, kickReturns
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param game_id (*Integer* optional): Game ID filter for querying a single game
#' Can be found using the [cfbd_game_info()] function
#'
#' @param division (*String* optional): Division/classification filter -- one of `fbs`, `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.
#' @return [cfbd_game_player_stats()] - A data frame with 32 variables:
#'
#'   |col_name            |types     |description                                                                        |
#'   |:-------------------|:---------|:----------------------------------------------------------------------------------|
#'   |game_id             |integer   |CFBD-internal game id; join key to other CFBD endpoints.                           |
#'   |team                |character |Full team name (e.g. "Alabama") for the player's team.                             |
#'   |conference          |character |Conference name of the player's team (e.g. "SEC").                                 |
#'   |home_away           |character |Whether the player's team played at home or away ("home"/"away").                  |
#'   |team_points         |integer   |Total points scored by the player's team in this game.                             |
#'   |athlete_id          |integer   |CFBD-internal athlete id for the player.                                           |
#'   |athlete_name        |character |Player's display name as reported by CFBD.                                         |
#'   |defensive_td        |numeric   |Defensive touchdowns scored by the player.                                         |
#'   |defensive_qb_hur    |numeric   |Quarterback hurries credited to the player.                                        |
#'   |defensive_pd        |numeric   |Passes defended (pass breakups) by the player.                                     |
#'   |defensive_tfl       |numeric   |Tackles for loss credited to the player.                                           |
#'   |defensive_sacks     |numeric   |Sacks credited to the player.                                                      |
#'   |defensive_solo      |numeric   |Solo (unassisted) tackles by the player.                                           |
#'   |defensive_tot       |numeric   |Total tackles (solo plus assisted) by the player.                                  |
#'   |fumbles_rec         |numeric   |Fumbles recovered by the player.                                                   |
#'   |fumbles_lost        |numeric   |Fumbles by the player that were lost to the opposing team.                         |
#'   |fumbles_fum         |numeric   |Fumbles committed by the player.                                                   |
#'   |punting_long        |numeric   |Longest punt by the player, in yards.                                              |
#'   |punting_in_20       |numeric   |Punts downed inside the opponent 20-yard line.                                     |
#'   |punting_tb          |numeric   |Punts resulting in a touchback.                                                    |
#'   |punting_avg         |numeric   |Average yards per punt.                                                            |
#'   |punting_yds         |numeric   |Total punting yards (gross).                                                       |
#'   |punting_no          |numeric   |Number of punts attempted.                                                         |
#'   |kicking_pts         |numeric   |Total points scored by the kicker (FGs + XPs).                                     |
#'   |kicking_long        |numeric   |Longest made field goal, in yards.                                                 |
#'   |kicking_pct         |numeric   |Field-goal percentage (made / attempted), 0-100.                                   |
#'   |punt_returns_td     |numeric   |Touchdowns scored on punt returns.                                                 |
#'   |punt_returns_long   |numeric   |Longest punt return, in yards.                                                     |
#'   |punt_returns_avg    |numeric   |Average yards per punt return.                                                     |
#'   |punt_returns_yds    |numeric   |Total punt-return yards.                                                           |
#'   |punt_returns_no     |numeric   |Number of punt returns.                                                            |
#'   |kick_returns_td     |numeric   |Touchdowns scored on kickoff returns.                                              |
#'   |kick_returns_long   |numeric   |Longest kickoff return, in yards.                                                  |
#'   |kick_returns_avg    |numeric   |Average yards per kickoff return.                                                  |
#'   |kick_returns_yds    |numeric   |Total kickoff-return yards.                                                        |
#'   |kick_returns_no     |numeric   |Number of kickoff returns.                                                         |
#'   |interceptions_td    |numeric   |Touchdowns scored on interception returns (pick-sixes).                            |
#'   |interceptions_yds   |numeric   |Interception-return yards.                                                         |
#'   |interceptions_int   |numeric   |Number of interceptions made by the player.                                        |
#'   |receiving_long      |numeric   |Longest reception by the player, in yards.                                         |
#'   |receiving_td        |numeric   |Receiving touchdowns.                                                              |
#'   |receiving_avg       |numeric   |Average yards per reception.                                                       |
#'   |receiving_yds       |numeric   |Total receiving yards.                                                             |
#'   |receiving_rec       |numeric   |Number of receptions (catches).                                                    |
#'   |rushing_long        |numeric   |Longest rush by the player, in yards.                                              |
#'   |rushing_td          |numeric   |Rushing touchdowns.                                                                |
#'   |rushing_avg         |numeric   |Average yards per rushing attempt.                                                 |
#'   |rushing_yds         |numeric   |Total rushing yards.                                                               |
#'   |rushing_car         |numeric   |Rushing carries (attempts).                                                        |
#'   |passing_int         |numeric   |Interceptions thrown by the passer.                                                |
#'   |passing_td          |numeric   |Passing touchdowns thrown.                                                         |
#'   |passing_avg         |numeric   |Yards per pass attempt.                                                            |
#'   |passing_yds         |numeric   |Total passing yards.                                                               |
#'   |passing_completions |numeric   |Pass completions (split from CFBD's `C/ATT` field).                                |
#'   |passing_attempts    |numeric   |Pass attempts (split from CFBD's `C/ATT` field).                                   |
#'   |passing_qbr         |numeric   |ESPN Quarterback Rating (QBR) for the player in this game.                         |
#'   |kicking_xpm         |numeric   |Extra points made (split from CFBD's `XP` field).                                  |
#'   |kicking_xpa         |numeric   |Extra points attempted (split from CFBD's `XP` field).                             |
#'   |kicking_fgm         |numeric   |Field goals made (split from CFBD's `FG` field).                                   |
#'   |kicking_fga         |numeric   |Field goals attempted (split from CFBD's `FG` field).                              |
#'
#' @keywords Game Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @family CFBD Games
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_game_player_stats(year = 2020, week = 15, team = "Alabama"))
#'
#'   try(cfbd_game_player_stats(2013, week = 1, team = "Florida State", category = "passing"))
#' }

cfbd_game_player_stats <- function(year,
                                   week = NULL,
                                   season_type = "regular",
                                   team = NULL,
                                   conference = NULL,
                                   category = NULL,
                                   game_id = NULL,
                                   division = NULL) {

  stat_categories <- c(
    "passing", "receiving", "rushing", "defensive", "fumbles",
    "interceptions", "punting", "puntReturns", "kicking", "kickReturns"
  )

  args <- list(year, week, season_type, team, conference, category, game_id)

  args <- args[lengths(args) != 0]

  # Validation ----
  validate_api_key()
  validate_division(division)
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)
  validate_id(game_id)
  validate_list(category, stat_categories)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/games/players?"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "category" = category,
    "gameId" = game_id,
    "classification" = division
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  cols <- c(
    "game_id", "team", "conference", "home_away", "team_points",
    "athlete_id", "athlete_name", "defensive_td",
    "defensive_qb_hur",
    "defensive_pd",
    "defensive_tfl",
    "defensive_sacks",
    "defensive_solo",
    "defensive_tot",
    "fumbles_rec",
    "fumbles_lost",
    "fumbles_fum",
    "punting_long",
    "punting_in_20",
    "punting_tb",
    "punting_avg",
    "punting_yds",
    "punting_no",
    "kicking_pts",
    "kicking_long",
    "kicking_pct",
    "punt_returns_td",
    "punt_returns_long",
    "punt_returns_avg",
    "punt_returns_yds",
    "punt_returns_no",
    "kick_returns_td",
    "kick_returns_long",
    "kick_returns_avg",
    "kick_returns_yds",
    "kick_returns_no",
    "interceptions_td",
    "interceptions_yds",
    "interceptions_int",
    "receiving_long",
    "receiving_td",
    "receiving_avg",
    "receiving_yds",
    "receiving_rec",
    "rushing_long",
    "rushing_td",
    "rushing_avg",
    "rushing_yds",
    "rushing_car",
    "passing_int",
    "passing_td",
    "passing_avg",
    "passing_yds",
    "passing_c_att",
    "passing_completions",
    "passing_attempts",
    "passing_qbr",
    "kicking_xp",
    "kicking_xpm",
    "kicking_xpa",
    "kicking_fg",
    "kicking_fgm",
    "kicking_fga"
  )
  split_cols <-   c(
    "passing_c_att",
    "kicking_xp",
    "kicking_fg"
  )
  numeric_cols <- c(
    "defensive_td",
    "defensive_qb_hur",
    "defensive_pd",
    "defensive_tfl",
    "defensive_sacks",
    "defensive_solo",
    "defensive_tot",
    "fumbles_rec",
    "fumbles_lost",
    "fumbles_fum",
    "punting_long",
    "punting_in_20",
    "punting_tb",
    "punting_avg",
    "punting_yds",
    "punting_no",
    "kicking_pts",
    "kicking_long",
    "kicking_pct",
    "punt_returns_td",
    "punt_returns_long",
    "punt_returns_avg",
    "punt_returns_yds",
    "punt_returns_no",
    "kick_returns_td",
    "kick_returns_long",
    "kick_returns_avg",
    "kick_returns_yds",
    "kick_returns_no",
    "interceptions_td",
    "interceptions_yds",
    "interceptions_int",
    "receiving_long",
    "receiving_td",
    "receiving_avg",
    "receiving_yds",
    "receiving_rec",
    "rushing_long",
    "rushing_td",
    "rushing_avg",
    "rushing_yds",
    "rushing_car",
    "passing_int",
    "passing_td",
    "passing_avg",
    "passing_yds",
    "passing_completions",
    "passing_attempts",
    "passing_qbr",
    "kicking_xpm",
    "kicking_xpa",
    "kicking_fgm",
    "kicking_fga"
  )

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content, tidyr::unnest, and return result as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        purrr::map_if(is.data.frame, list) |>
        dplyr::as_tibble() |>
        dplyr::rename("game_id" = "id") |>
        tidyr::unnest("teams") |>
        purrr::map_if(is.data.frame, list) |>
        dplyr::as_tibble() |>
        tidyr::unnest("categories") |>
        purrr::map_if(is.data.frame, list) |>
        dplyr::as_tibble() |>
        dplyr::rename("category" = "name") |>
        tidyr::unnest("types") |>
        purrr::map_if(is.data.frame, list) |>
        dplyr::as_tibble() |>
        dplyr::rename("stat_category" = "name") |>
        dplyr::mutate(
          statType = paste0(.data$category, "_", .data$stat_category)) |>
        tidyr::unnest("athletes") |>
        dplyr::rename(
          "athlete_id" = "id",
          "athlete_name" = "name",
          "team_points" = "points",
          "value" = "stat"
        ) |>
        dplyr::select(-dplyr::any_of(c("category", "stat_category"))) |>
        dplyr::group_by(.data$game_id, .data$team, .data$conference, .data$athlete_id, .data$athlete_name,
                        .data$homeAway, .data$team_points) |>
        tidyr::pivot_wider(names_from = "statType", values_from = "value", values_fn = first) |>
        janitor::clean_names()

      df[cols[!(cols %in% colnames(df))]] <- NA

      suppressWarnings(
        df <- df |>
          dplyr::select(dplyr::all_of(cols), dplyr::everything()) |>
          tidyr::separate("passing_c_att",into = c("passing_completions","passing_attempts"), sep = "/") |>
          tidyr::separate("kicking_xp",into = c("kicking_xpm","kicking_xpa"), sep = "/") |>
          tidyr::separate("kicking_fg",into = c("kicking_fgm","kicking_fga"), sep = "/") |>
          dplyr::mutate_at(numeric_cols, as.numeric) |>
          dplyr::mutate(athlete_id = as.integer(.data$athlete_id)) |>
          as.data.frame()
      )



      df <- df |>
        dplyr::select(dplyr::any_of(cols), dplyr::everything()) |>
        make_cfbfastR_data("Game player stats data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game player stats data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  # is_c_att_present <- any(grepl("C/ATT",colnames(df)))
  # if(is_c_att_present){
  #   df <- df |>
  #    dplyr::mutate("C/ATT"="0/0")
  # }
  return(df)
}




#' @title
#' **Get team records by year**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*)
#' @param team (*String* optional): Team - Select a valid team, D1 football
#' @param conference (*String* optional): DI Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @return [cfbd_game_records()] - A data frame with 35 variables:
#'
#'   |col_name              |types     |description                                                          |
#'   |:---------------------|:---------|:--------------------------------------------------------------------|
#'   |year                  |integer   |Season of the games.                                                 |
#'   |team_id               |integer   |Referencing team id.                                                 |
#'   |team                  |character |Team name.                                                           |
#'   |classification        |character |Conference classification (fbs, fcs, ii, iii).                       |
#'   |conference            |character |Conference of the team.                                              |
#'   |division              |character |Division in the conference of the team.                              |
#'   |expected_wins         |numeric   |Expected number of wins based on post-game win probability.          |
#'   |total_games           |integer   |Total number of games played.                                        |
#'   |total_wins            |integer   |Total wins.                                                          |
#'   |total_losses          |integer   |Total losses.                                                        |
#'   |total_ties            |integer   |Total ties.                                                          |
#'   |conference_games      |integer   |Number of conference games.                                          |
#'   |conference_wins       |integer   |Total conference wins.                                               |
#'   |conference_losses     |integer   |Total conference losses.                                             |
#'   |conference_ties       |integer   |Total conference ties.                                               |
#'   |home_games            |integer   |Total home games.                                                    |
#'   |home_wins             |integer   |Total home wins.                                                     |
#'   |home_losses           |integer   |Total home losses.                                                   |
#'   |home_ties             |integer   |Total home ties.                                                     |
#'   |away_games            |integer   |Total away games.                                                    |
#'   |away_wins             |integer   |Total away wins.                                                     |
#'   |away_losses           |integer   |Total away losses.                                                   |
#'   |away_ties             |integer   |Total away ties.                                                     |
#'   |neutral_games         |integer   |Total neutral site games.                                            |
#'   |neutral_wins          |integer   |Total neutral site wins.                                             |
#'   |neutral_losses        |integer   |Total neutral site losses.                                           |
#'   |neutral_ties          |integer   |Total neutral site ties.                                             |
#'   |regular_season_games  |integer   |Total regular season games.                                          |
#'   |regular_season_wins   |integer   |Total regular season wins.                                           |
#'   |regular_season_losses |integer   |Total regular season losses.                                         |
#'   |regular_season_ties   |integer   |Total regular season ties.                                           |
#'   |postseason_games      |integer   |Total postseason games.                                              |
#'   |postseason_wins       |integer   |Total postseason wins.                                               |
#'   |postseason_losses     |integer   |Total postseason losses.                                             |
#'   |postseason_ties       |integer   |Total postseason ties.                                               |
#'
#' @keywords Team Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom cli cli_abort
#' @import dplyr
#' @import tidyr
#' @family CFBD Games
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_game_records(2018, team = "Notre Dame"))
#'
#'   try(cfbd_game_records(2013, team = "Florida State"))
#' }

cfbd_game_records <- function(year,
                              team = NULL,
                              conference = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/records?"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        dplyr::rename(
          "team_id" = "teamId",
          "expected_wins" = "expectedWins",
          "total_games" = "total.games",
          "total_wins" = "total.wins",
          "total_losses" = "total.losses",
          "total_ties" = "total.ties",
          "conference_games" = "conferenceGames.games",
          "conference_wins" = "conferenceGames.wins",
          "conference_losses" = "conferenceGames.losses",
          "conference_ties" = "conferenceGames.ties",
          "home_games" = "homeGames.games",
          "home_wins" = "homeGames.wins",
          "home_losses" = "homeGames.losses",
          "home_ties" = "homeGames.ties",
          "away_games" = "awayGames.games",
          "away_wins" = "awayGames.wins",
          "away_losses" = "awayGames.losses",
          "away_ties" = "awayGames.ties",
          "neutral_games" = "neutralSiteGames.games",
          "neutral_wins" = "neutralSiteGames.wins",
          "neutral_losses" = "neutralSiteGames.losses",
          "neutral_ties" = "neutralSiteGames.ties",
          "regular_season_games" = "regularSeason.games",
          "regular_season_wins" = "regularSeason.wins",
          "regular_season_losses" = "regularSeason.losses",
          "regular_season_ties" = "regularSeason.ties",
          "postseason_games" = "postseason.games",
          "postseason_wins" = "postseason.wins",
          "postseason_losses" = "postseason.losses",
          "postseason_ties" = "postseason.ties"
        )

      df <- df |>
        make_cfbfastR_data("Game records data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game records data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}



#' @title
#' **Get team statistics by game**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*). Required year filter (along with one of `week`, `team`, or `conference`), unless `game_id` is specified
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier. Required if `team` and `conference` not specified.
#' @param season_type (*String* default: regular): Select Season Type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team. Required if `week` and `conference` not specified.
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' Required if `week` and `team` not specified.
#' @param division (*String* optional): Division abbreviation - Select a valid division: fbs/fcs/ii/iii
#' @param game_id (*Integer* optional): Game ID filter for querying a single game
#' Can be found using the [cfbd_game_info()] function
#' @param rows_per_team (*Integer* default 1): Both Teams for each game on one or two row(s), Options: 1 or 2
#'
#' @return [cfbd_game_team_stats()] - A data frame with 78 variables:
#'
#'   |col_name                       |types     |description                                                |
#'   |:------------------------------|:---------|:----------------------------------------------------------|
#'   |game_id                        |integer   |Referencing game id.                                       |
#'   |team                           |character |Team name.                                                 |
#'   |conference                     |character |Conference of the team.                                    |
#'   |home_away                      |character |Home/Away Flag.                                            |
#'   |opponent                       |character |Opponent team name.                                        |
#'   |opponent_conference            |character |Conference of the opponent team.                           |
#'   |points                         |integer   |Team points.                                               |
#'   |total_yards                    |character |Team total yards.                                          |
#'   |net_passing_yards              |character |Team net passing yards.                                    |
#'   |completion_attempts            |character |Team completion attempts.                                  |
#'   |passing_tds                    |character |Team passing touchdowns.                                   |
#'   |yards_per_pass                 |character |Team game yards per pass.                                  |
#'   |passes_intercepted             |character |Team passes intercepted.                                   |
#'   |interception_yards             |character |Interception yards.                                        |
#'   |interception_tds               |character |Interceptions returned for a touchdown.                    |
#'   |rushing_attempts               |character |Team rushing attempts.                                     |
#'   |rushing_yards                  |character |Team rushing yards.                                        |
#'   |rush_tds                       |character |Team rushing touchdowns.                                   |
#'   |yards_per_rush_attempt         |character |Team yards per rush attempt.                               |
#'   |first_downs                    |character |First downs earned by the team.                            |
#'   |third_down_eff                 |character |Third down efficiency.                                     |
#'   |fourth_down_eff                |character |Fourth down efficiency.                                    |
#'   |punt_returns                   |character |Team punt returns.                                         |
#'   |punt_return_yards              |character |Team punt return yards.                                    |
#'   |punt_return_tds                |character |Team punt return touchdowns.                               |
#'   |kick_return_yards              |character |Team kick return yards.                                    |
#'   |kick_return_tds                |character |Team kick return touchdowns.                               |
#'   |kick_returns                   |character |Team kick returns.                                         |
#'   |kicking_points                 |character |Team points from kicking the ball.                         |
#'   |fumbles_recovered              |character |Team fumbles recovered.                                    |
#'   |fumbles_lost                   |character |Team fumbles lost.                                         |
#'   |total_fumbles                  |character |Team total fumbles.                                        |
#'   |tackles                        |character |Team tackles.                                              |
#'   |tackles_for_loss               |character |Team tackles for a loss.                                   |
#'   |sacks                          |character |Team sacks.                                                |
#'   |qb_hurries                     |character |Team QB hurries.                                           |
#'   |interceptions                  |character |Team interceptions.                                        |
#'   |passes_deflected               |character |Team passes deflected.                                     |
#'   |turnovers                      |character |Team turnovers.                                            |
#'   |defensive_tds                  |character |Team defensive touchdowns.                                 |
#'   |total_penalties_yards          |character |Team total penalty yards.                                  |
#'   |possession_time                |character |Team time of possession.                                   |
#'   |points_allowed                 |integer   |Points for the opponent.                                   |
#'   |total_yards_allowed            |character |Opponent total yards.                                      |
#'   |net_passing_yards_allowed      |character |Opponent net passing yards.                                |
#'   |completion_attempts_allowed    |character |Opponent completion attempts.                              |
#'   |passing_tds_allowed            |character |Opponent passing TDs.                                      |
#'   |yards_per_pass_allowed         |character |Opponent yards per pass allowed.                           |
#'   |passes_intercepted_allowed     |character |Opponent passes intercepted.                               |
#'   |interception_yards_allowed     |character |Opponent interception yards.                               |
#'   |interception_tds_allowed       |character |Opponent interception TDs.                                 |
#'   |rushing_attempts_allowed       |character |Opponent rushing attempts.                                 |
#'   |rushing_yards_allowed          |character |Opponent rushing yards.                                    |
#'   |rush_tds_allowed               |character |Opponent rushing touchdowns.                               |
#'   |yards_per_rush_attempt_allowed |character |Opponent rushing yards per attempt.                        |
#'   |first_downs_allowed            |character |Opponent first downs.                                      |
#'   |third_down_eff_allowed         |character |Opponent third down efficiency.                            |
#'   |fourth_down_eff_allowed        |character |Opponent fourth down efficiency.                           |
#'   |punt_returns_allowed           |character |Opponent punt returns.                                     |
#'   |punt_return_yards_allowed      |character |Opponent punt return yards.                                |
#'   |punt_return_tds_allowed        |character |Opponent punt return touchdowns.                           |
#'   |kick_return_yards_allowed      |character |Opponent kick return yards.                                |
#'   |kick_return_tds_allowed        |character |Opponent kick return touchdowns.                           |
#'   |kick_returns_allowed           |character |Opponent kick returns.                                     |
#'   |kicking_points_allowed         |character |Opponent points from kicking.                              |
#'   |fumbles_recovered_allowed      |character |Opponent fumbles recovered.                                |
#'   |fumbles_lost_allowed           |character |Opponent fumbles lost.                                     |
#'   |total_fumbles_allowed          |character |Opponent total number of fumbles.                          |
#'   |tackles_allowed                |character |Opponent tackles.                                          |
#'   |tackles_for_loss_allowed       |character |Opponent tackles for loss.                                 |
#'   |sacks_allowed                  |character |Opponent sacks.                                            |
#'   |qb_hurries_allowed             |character |Opponent quarterback hurries.                              |
#'   |interceptions_allowed          |character |Opponent interceptions.                                    |
#'   |passes_deflected_allowed       |character |Opponent passes deflected.                                 |
#'   |turnovers_allowed              |character |Opponent turnovers.                                        |
#'   |defensive_tds_allowed          |character |Opponent defensive touchdowns.                             |
#'   |total_penalties_yards_allowed  |character |Opponent total penalty yards.                              |
#'   |possession_time_allowed        |character |Opponent time of possession.                               |
#'
#' @keywords Team Game Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @family CFBD Games
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_game_team_stats(2022, team = "LSU"))
#'
#'   try(cfbd_game_team_stats(2013, team = "Florida State"))
#' }

cfbd_game_team_stats <- function(year,
                                 week = NULL,
                                 season_type = "regular",
                                 team = NULL,
                                 conference = NULL,
                                 game_id = NULL,
                                 division = 'fbs',
                                 rows_per_team = 1) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)
  validate_id(game_id)
  validate_list(rows_per_team, c(1,2))

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/games/teams?"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "classification" = division,
    "gameId" = game_id
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      cols <- c(
        "id", "team", "conference", "home_away",
        "points", "rushing_t_ds", "punt_return_yards", "punt_return_t_ds",
        "punt_returns", "passing_t_ds", "kicking_points",
        "interception_yards", "interception_t_ds", "passes_intercepted",
        "fumbles_recovered", "total_fumbles", "tackles_for_loss",
        "defensive_t_ds", "tackles", "sacks", "qb_hurries",
        "passes_deflected", "possession_time", "interceptions",
        "fumbles_lost", "turnovers", "total_penalties_yards",
        "yards_per_rush_attempt", "rushing_attempts", "rushing_yards",
        "yards_per_pass", "completion_attempts", "net_passing_yards",
        "total_yards", "fourth_down_eff", "third_down_eff",
        "first_downs", "kick_return_yards", "kick_return_t_ds",
        "kick_returns"
      )
      # Get the content, unnest, and return result as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        purrr::map_if(is.data.frame, list) |>
        dplyr::as_tibble()

      if (nrow(df) == 0) {
        warning("Most likely a bye week, the data pulled from the API was empty. Returning nothing
              for this one week or team.")
        return(NULL)
      }
      df <- df |>
        tidyr::unnest("teams") |>
        tidyr::unnest("stats") |>
        # Occasionally CFBD will have duplicated stats that causes an error here
        #and the current long df is returned. Distinct removes duplicates.
        dplyr::distinct()

      # Pivot category columns to get stats for each team game on one row
      df <- tidyr::pivot_wider(df,
                               names_from = "category",
                               values_from = "stat"
      )
      df <- df |>
        janitor::clean_names()
      df[cols[!(cols %in% colnames(df))]] <- NA
      df <- df |>
        dplyr::rename(
          "game_id" = "id",
          "rush_tds" = "rushing_t_ds",
          "punt_return_tds" = "punt_return_t_ds",
          "passing_tds" = "passing_t_ds",
          "interception_tds" = "interception_t_ds",
          "defensive_tds" = "defensive_t_ds",
          "kick_return_tds" = "kick_return_t_ds"
        )

      if (rows_per_team == 1) {
        # Join pivoted data with itself to get ultra-wide row
        # containing all game stats on one row for both teams
        df <- df |>
          dplyr::mutate(opponent_home_away = ifelse(.data$home_away == "home","away","home")) |>
          dplyr::left_join(df,
                           by = c("game_id", "opponent_home_away" = "home_away"),
                           suffix = c("", "_allowed")
          ) |>
          dplyr::rename(
            "opponent" = "team_allowed",
            "opponent_conference" = "conference_allowed")

        cols1 <- c(
          "game_id", "team", "conference", "home_away","opponent","opponent_conference",
          "points", "total_yards", "net_passing_yards",
          "completion_attempts", "passing_tds", "yards_per_pass",
          "passes_intercepted", "interception_yards", "interception_tds",
          "rushing_attempts", "rushing_yards", "rush_tds", "yards_per_rush_attempt",
          "first_downs", "third_down_eff", "fourth_down_eff",
          "punt_returns", "punt_return_yards", "punt_return_tds",
          "kick_return_yards", "kick_return_tds", "kick_returns", "kicking_points",
          "fumbles_recovered", "fumbles_lost", "total_fumbles",
          "tackles", "tackles_for_loss", "sacks", "qb_hurries",
          "interceptions", "passes_deflected", "turnovers", "defensive_tds",
          "total_penalties_yards", "possession_time",
          "points_allowed", "total_yards_allowed", "net_passing_yards_allowed",
          "completion_attempts_allowed", "passing_tds_allowed", "yards_per_pass_allowed",
          "passes_intercepted_allowed", "interception_yards_allowed", "interception_tds_allowed",
          "rushing_attempts_allowed", "rushing_yards_allowed", "rush_tds_allowed", "yards_per_rush_attempt_allowed",
          "first_downs_allowed", "third_down_eff_allowed", "fourth_down_eff_allowed",
          "punt_returns_allowed", "punt_return_yards_allowed", "punt_return_tds_allowed",
          "kick_return_yards_allowed", "kick_return_tds_allowed", "kick_returns_allowed", "kicking_points_allowed",
          "fumbles_recovered_allowed", "fumbles_lost_allowed", "total_fumbles_allowed",
          "tackles_allowed", "tackles_for_loss_allowed", "sacks_allowed", "qb_hurries_allowed",
          "interceptions_allowed", "passes_deflected_allowed", "turnovers_allowed", "defensive_tds_allowed",
          "total_penalties_yards_allowed", "possession_time_allowed"
        )

        if (!is.null(team)) {
          team <- URLdecode(team)

          df <- df |>
            dplyr::filter(.data$team == team) |>
            dplyr::select(dplyr::all_of(cols1))


        } else if (!is.null(conference)) {
          conference <- URLdecode(conference)
          conf_name <- .lookup_conference_name(conference)

          df <- df |>
            dplyr::filter(.data$conference == conf_name) |>
            dplyr::select(dplyr::all_of(cols1))


        } else {
          df <- df |>
            dplyr::select(dplyr::all_of(cols1))

        }
      } else {
        cols2 <- c(
          "game_id", "team", "conference", "home_away",
          "points", "total_yards", "net_passing_yards",
          "completion_attempts", "passing_tds", "yards_per_pass",
          "passes_intercepted", "interception_yards", "interception_tds",
          "rushing_attempts", "rushing_yards", "rush_tds", "yards_per_rush_attempt",
          "first_downs", "third_down_eff", "fourth_down_eff",
          "punt_returns", "punt_return_yards", "punt_return_tds",
          "kick_return_yards", "kick_return_tds", "kick_returns", "kicking_points",
          "fumbles_recovered", "fumbles_lost", "total_fumbles",
          "tackles", "tackles_for_loss", "sacks", "qb_hurries",
          "interceptions", "passes_deflected", "turnovers", "defensive_tds",
          "total_penalties_yards", "possession_time"
        )
        if (!is.null(team)) {
          team <- URLdecode(team)

          df <- df |>
            dplyr::filter(.data$team == team) |>
            dplyr::select(dplyr::all_of(cols2))

        } else if (!is.null(conference)) {
          conference <- URLdecode(conference)
          conf_name <- .lookup_conference_name(conference)

          df <- df |>
            dplyr::filter(.data$conference == conf_name) |>
            dplyr::select(dplyr::all_of(cols2))


        } else {
          df <- df |>
            dplyr::select(dplyr::all_of(cols2))

        }
      }


      df <- df |>
        dplyr::rename("school" = "team") |>
        make_cfbfastR_data("Team stats data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no team stats data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **Get live game scoreboard information from games.**
#'
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param division (*String* optional): Division abbreviation - Select a valid division: fbs/fcs/ii/iii
#'
#' @return [cfbd_live_scoreboard()] - A data frame with 41 variables:
#'
#'  |col_name                 |types     |description                                                                        |
#'  |:------------------------|:---------|:----------------------------------------------------------------------------------|
#'  |game_id                  |integer   |CFBD-internal game id; join key to other CFBD endpoints.                           |
#'  |start_date               |character |Scheduled kickoff timestamp (ISO 8601, UTC).                                       |
#'  |start_time_tbd           |logical   |TRUE if the scheduled kickoff time is still to be determined.                      |
#'  |tv                       |character |Television network broadcasting the game (e.g. "ESPN", "ABC").                     |
#'  |neutral_site             |logical   |TRUE if the game is being played at a neutral site.                                |
#'  |conference_game          |logical   |TRUE if both teams are in the same conference.                                     |
#'  |status                   |character |Game status (e.g. "scheduled", "in_progress", "completed").                        |
#'  |period                   |integer   |Current period/quarter number (1-4, 5+ for overtime).                              |
#'  |clock                    |character |Game clock display as "MM:SS" remaining in the current period.                     |
#'  |situation                |character |Free-text down-and-distance / field-position summary for the current play.         |
#'  |possession               |character |Abbreviation of the team currently in possession.                                  |
#'  |last_play                |character |Free-text description of the most recent play.                                     |
#'  |venue_name               |character |Stadium / venue name.                                                              |
#'  |venue_city               |character |City where the venue is located.                                                   |
#'  |venue_state              |character |State (or province/country) where the venue is located.                            |
#'  |home_team_id             |integer   |CFBD-internal team id for the home team.                                           |
#'  |home_team_name           |character |Full home team name (e.g. "Georgia").                                              |
#'  |home_team_conference     |character |Conference name of the home team.                                                  |
#'  |home_team_classification |character |Division classification of the home team (fbs/fcs/ii/iii).                         |
#'  |home_team_points         |integer   |Current total points scored by the home team.                                      |
#'  |home_team_line_scores_Q1 |integer   |Home team points scored in the first quarter.                                      |
#'  |home_team_line_scores_Q2 |integer   |Home team points scored in the second quarter.                                     |
#'  |home_team_line_scores_Q3 |integer   |Home team points scored in the third quarter.                                      |
#'  |home_team_line_scores_Q4 |integer   |Home team points scored in the fourth quarter.                                     |
#'  |away_team_id             |integer   |CFBD-internal team id for the away team.                                           |
#'  |away_team_name           |character |Full away team name (e.g. "Auburn").                                               |
#'  |away_team_conference     |character |Conference name of the away team.                                                  |
#'  |away_team_classification |character |Division classification of the away team (fbs/fcs/ii/iii).                         |
#'  |away_team_points         |integer   |Current total points scored by the away team.                                      |
#'  |away_team_line_scores_Q1 |integer   |Away team points scored in the first quarter.                                      |
#'  |away_team_line_scores_Q2 |integer   |Away team points scored in the second quarter.                                     |
#'  |away_team_line_scores_Q3 |integer   |Away team points scored in the third quarter.                                      |
#'  |away_team_line_scores_Q4 |integer   |Away team points scored in the fourth quarter.                                     |
#'  |weather_temperature      |numeric   |Temperature at kickoff, in degrees Fahrenheit.                                     |
#'  |weather_description      |character |Free-text weather description (e.g. "Clear", "Light rain").                        |
#'  |weather_wind_speed       |numeric   |Wind speed, in miles per hour.                                                     |
#'  |weather_wind_direction   |integer   |Wind direction, in degrees (0-360, 0 = north).                                     |
#'  |betting_spread           |numeric   |Pre-game point spread relative to the home team (negative = home favored).         |
#'  |betting_over_under       |numeric   |Pre-game over/under (total) line in points.                                        |
#'  |betting_home_moneyline   |integer   |American-odds moneyline for the home team.                                         |
#'  |betting_away_moneyline   |integer   |American-odds moneyline for the away team.                                         |
#'
#' @keywords Game Scoreboard
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Games
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_live_scoreboard(division='fbs', conference = "B12"))
#' }

cfbd_live_scoreboard <- function(division = 'fbs',
                                 conference = NULL) {

  # Validation ----
  validate_api_key()

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/scoreboard?"
  query_params <- list(
    "conference" = conference,
    # CFBD v5 renamed this query parameter to `classification`; sending
    # `division=` is silently IGNORED (measured: division=fcs returned all
    # 270 week-5 games, classification=fcs returned the correct 56). The R
    # argument keeps its name so callers are unaffected.
    "classification" = division
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        janitor::clean_names()

      df <- df |>
        dplyr::rename("game_id" = "id") |>
        tidyr::unnest_wider("venue", names_sep = "_") |>
        tidyr::unnest_wider("home_team", names_sep = "_") |>
        tidyr::unnest_wider("away_team", names_sep = "_") |>
        tidyr::unnest_wider("weather", names_sep = "_") |>
        tidyr::unnest_wider("betting", names_sep = "_") |>
        janitor::clean_names()

      df <- df |>
        tidyr::unnest("home_team_line_scores") |>
        tidyr::unnest("away_team_line_scores") |>
        tidyr::unnest_wider("home_team_line_scores", names_sep="_Q") |>
        tidyr::unnest_wider("away_team_line_scores", names_sep="_Q") |>
        make_cfbfastR_data("Live Scoreboard information from CollegeFootballData.com",Sys.time())

    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game info data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

