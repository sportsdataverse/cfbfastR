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
#' * `cfbd_game_schedule()`: Get the active or next game schedule slate.
#' * `cfbd_game_preview()`: Get a pregame preview for a game.
#' * `cfbd_game_preview_adjusted()`: Get an adjusted-metrics pregame preview for a game.
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
#' @param year (*Integer* required): Year, 4 digit format(*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_game_info', 'min_year']`
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
#' @return A data frame with one row per game and 32 variables. With
#' `quarter_scores = TRUE` the per-period scores are inserted after `home_points` and
#' after `away_points`: one `home_scores_Q<n>` and one `away_scores_Q<n>` column per
#' period played by any game in the result, so overtime adds `_Q5` onward (the
#' seven-overtime 2018 LSU at Texas A&M game reaches `_Q11`). An empty data frame is
#' returned if the request fails.
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |game_id |integer |Unique CFBD game identifier. |
#'  |season |integer |Season of the game. |
#'  |week |integer |Game week (postseason games restart at week 1). |
#'  |season_type |character |Season type of the game (e.g. regular, postseason). |
#'  |start_date |character |Game start date-time (ISO 8601, UTC). |
#'  |start_time_tbd |logical |TRUE/FALSE flag for if the game's start time is to be determined. |
#'  |completed |logical |TRUE if the game has been completed. |
#'  |neutral_site |logical |TRUE/FALSE flag for the game taking place at a neutral site. |
#'  |conference_game |logical |TRUE/FALSE flag for this game qualifying as a conference game. |
#'  |attendance |integer |Reported attendance at the game; NA when not reported. |
#'  |venue_id |integer |CFBD venue id. |
#'  |venue |character |Venue name. |
#'  |home_id |integer |Home team CFBD id. |
#'  |home_team |character |Home team name. |
#'  |home_division |character |Home team division (CFBD classification): fbs, fcs, ii, ii/iii or iii. |
#'  |home_conference |character |Home team conference. |
#'  |home_points |integer |Home team points; NA until the game has a score. |
#'  |home_scores_Q1 |integer |Home team points in the first quarter; present only with `quarter_scores = TRUE`. |
#'  |home_scores_Q2 |integer |Home team points in the second quarter; present only with `quarter_scores = TRUE`. |
#'  |home_scores_Q3 |integer |Home team points in the third quarter; present only with `quarter_scores = TRUE`. |
#'  |home_scores_Q4 |integer |Home team points in the fourth quarter; present only with `quarter_scores = TRUE`. |
#'  |home_post_win_prob |double |Home team post-game win probability (proportion 0-1). |
#'  |home_pregame_elo |integer |Home team pre-game Elo rating. |
#'  |home_postgame_elo |integer |Home team post-game Elo rating. |
#'  |away_id |integer |Away team CFBD id. |
#'  |away_team |character |Away team name. |
#'  |away_division |character |Away team division (CFBD classification): fbs, fcs, ii, ii/iii or iii. |
#'  |away_conference |character |Away team conference. |
#'  |away_points |integer |Away team points; NA until the game has a score. |
#'  |away_scores_Q1 |integer |Away team points in the first quarter; present only with `quarter_scores = TRUE`. |
#'  |away_scores_Q2 |integer |Away team points in the second quarter; present only with `quarter_scores = TRUE`. |
#'  |away_scores_Q3 |integer |Away team points in the third quarter; present only with `quarter_scores = TRUE`. |
#'  |away_scores_Q4 |integer |Away team points in the fourth quarter; present only with `quarter_scores = TRUE`. |
#'  |away_post_win_prob |double |Away team post-game win probability (proportion 0-1). |
#'  |away_pregame_elo |integer |Away team pre-game Elo rating. |
#'  |away_postgame_elo |integer |Away team post-game Elo rating. |
#'  |excitement_index |double |Game excitement index (CFBD measure of in-game win-probability swings; higher is more exciting). |
#'  |highlights |character |Game highlight URL; NA or empty when none. |
#'  |notes |character |Game notes (e.g. the bowl name); NA when none. |
#'  |playoff |data.frame |Playoff context. An all-NA logical column when no game in the result has playoff context; otherwise a nested data frame column (not flattened) of `competition`, `format`, `round`, `roundName`, `bracketSlot`, `homeSeed`, `awaySeed`, `bowlName`, NA for non-playoff games. See the `playoff_*` columns of [cfbd_game_schedule()] for their meaning. |
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
#' @param year (*Integer* required unless `game_id` is supplied): Year, 4 digit format(*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_game_weather', 'min_year']`
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* default regular): Select Season Type: regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#'
#' @param division (*String* optional): Division/classification filter -- one of `fbs`, `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.
#' @param game_id (*Integer* optional): Game ID. When specified, returns weather for that game.
#' @return A data frame with one row per game and 22 variables. An empty data frame is
#' returned, with an informational message, when CFBD has no weather for the filters
#' yet (it backfills weather mid-week in season), and also if the request fails.
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |game_id |integer |Unique CFBD game identifier. |
#'  |season |integer |Season of the game. |
#'  |week |integer |Game week. |
#'  |season_type |character |Season type of the game (e.g. regular, postseason). |
#'  |start_time |character |Game start date-time (ISO 8601, UTC). |
#'  |game_indoors |logical |TRUE/FALSE flag for if the game is indoors. |
#'  |home_team |character |Home team name. |
#'  |home_conference |character |Home team conference. |
#'  |away_team |character |Away team name. |
#'  |away_conference |character |Away team conference. |
#'  |venue_id |integer |CFBD venue id. |
#'  |venue |character |Venue name. |
#'  |temperature |double |Game-time temperature, in degrees Fahrenheit. |
#'  |dew_point |double |Dew point at kickoff, in degrees Fahrenheit. |
#'  |humidity |integer |Relative humidity at kickoff, as a percentage (0-100). |
#'  |precipitation |double |Precipitation at kickoff, in inches; parses as integer when every value in the result is a whole number (e.g. all 0). |
#'  |snowfall |double |Snowfall at kickoff, in inches; parses as integer when every value in the result is a whole number (e.g. all 0). |
#'  |wind_direction |integer |Wind direction, in degrees (0-360, 0 = north). |
#'  |wind_speed |double |Wind speed, in miles per hour. |
#'  |pressure |double |Barometric pressure, in millibars. |
#'  |weather_condition_code |integer |Numeric weather condition code, labelled by `weather_condition` (e.g. 1 = Clear, 3 = Cloudy, 8 = Rain, 25 = Thunderstorm). |
#'  |weather_condition |character |Weather condition label (e.g. Clear, Cloudy, Light Rain, Thunderstorm). |
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
#' @examples
#' \donttest{
#'   try(cfbd_game_weather(year = 2025, week = 1, conference = "SEC"))
#' }
cfbd_game_weather <- function(year = NULL,
                              week = NULL,
                              season_type = "regular",
                              team = NULL,
                              conference = NULL,
                              division = NULL,
                              game_id = NULL) {

  # Validation ----
  validate_api_key()
  validate_division(division)
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)
  validate_id(game_id)
  # CFBD: `year` is required unless `gameId` is specified.
  if (is.null(year) && is.null(game_id)) {
    cli::cli_abort("Supply {.arg year}, or {.arg game_id} for a single game.")
  }

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
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_calendar', 'min_year']`
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
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_game_media', 'min_year']`
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
#' @return A data frame with two rows, one per team, and 69 variables, all double
#' except `team`. Rows are assembled by position: the first entry of every CFBD
#' section goes to the first team (the first team of the `ppa` section), so a section
#' CFBD lists in the other team order lands on the other team's row. In sampled games
#' that is `havoc`, which CFBD lists in reverse order (see the `long = TRUE` output,
#' whose `havoc_team` row names the team behind each value). For games from 2025 on,
#' CFBD also sends enriched `passing` and `rushingAdvanced` sections, which this parser
#' appends as about 550 extra columns with raw dotted names (e.g.
#' `passing.defense.ppa`, `rushing_dvanced.offense.attempts`) coerced to double with
#' warnings; they are not described here, and the same data comes from
#' [cfbd_passing_teams_games()] and [cfbd_rushing_teams_games()]. PPA is predicted
#' points added. An empty data frame is returned if the request fails.
#'
#' **wide** (`long = FALSE`, the default) - one row per team:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |team |character |Team name. |
#'  |ppa_plays |double |Number of plays in the team's PPA sample. |
#'  |ppa_overall_total |double |Average PPA per play, whole game. |
#'  |ppa_overall_quarter1 |double |Average PPA per play, first quarter. |
#'  |ppa_overall_quarter2 |double |Average PPA per play, second quarter. |
#'  |ppa_overall_quarter3 |double |Average PPA per play, third quarter. |
#'  |ppa_overall_quarter4 |double |Average PPA per play, fourth quarter. |
#'  |ppa_passing_total |double |Average PPA per pass play, whole game. |
#'  |ppa_passing_quarter1 |double |Average PPA per pass play, first quarter. |
#'  |ppa_passing_quarter2 |double |Average PPA per pass play, second quarter. |
#'  |ppa_passing_quarter3 |double |Average PPA per pass play, third quarter. |
#'  |ppa_passing_quarter4 |double |Average PPA per pass play, fourth quarter. |
#'  |ppa_rushing_total |double |Average PPA per rush, whole game. |
#'  |ppa_rushing_quarter1 |double |Average PPA per rush, first quarter. |
#'  |ppa_rushing_quarter2 |double |Average PPA per rush, second quarter. |
#'  |ppa_rushing_quarter3 |double |Average PPA per rush, third quarter. |
#'  |ppa_rushing_quarter4 |double |Average PPA per rush, fourth quarter. |
#'  |cumulative_ppa_plays |double |Number of plays in the cumulative PPA sample (same as `ppa_plays`). |
#'  |cumulative_ppa_overall_total |double |Total PPA summed over all plays, whole game. |
#'  |cumulative_ppa_overall_quarter1 |double |Total PPA, first quarter. |
#'  |cumulative_ppa_overall_quarter2 |double |Total PPA, second quarter. |
#'  |cumulative_ppa_overall_quarter3 |double |Total PPA, third quarter. |
#'  |cumulative_ppa_overall_quarter4 |double |Total PPA, fourth quarter. |
#'  |cumulative_ppa_passing_total |double |Total PPA on pass plays, whole game. |
#'  |cumulative_ppa_passing_quarter1 |double |Total PPA on pass plays, first quarter. |
#'  |cumulative_ppa_passing_quarter2 |double |Total PPA on pass plays, second quarter. |
#'  |cumulative_ppa_passing_quarter3 |double |Total PPA on pass plays, third quarter. |
#'  |cumulative_ppa_passing_quarter4 |double |Total PPA on pass plays, fourth quarter. |
#'  |cumulative_ppa_rushing_total |double |Total PPA on rushes, whole game. |
#'  |cumulative_ppa_rushing_quarter1 |double |Total PPA on rushes, first quarter. |
#'  |cumulative_ppa_rushing_quarter2 |double |Total PPA on rushes, second quarter. |
#'  |cumulative_ppa_rushing_quarter3 |double |Total PPA on rushes, third quarter. |
#'  |cumulative_ppa_rushing_quarter4 |double |Total PPA on rushes, fourth quarter. |
#'  |success_rates_overall_total |double |Success rate (proportion 0-1 of plays that were successful), whole game. |
#'  |success_rates_overall_quarter1 |double |Success rate, first quarter; NA when the team had no plays in the quarter. |
#'  |success_rates_overall_quarter2 |double |Success rate, second quarter; NA when the team had no plays in the quarter. |
#'  |success_rates_overall_quarter3 |double |Success rate, third quarter; NA when the team had no plays in the quarter. |
#'  |success_rates_overall_quarter4 |double |Success rate, fourth quarter; NA when the team had no plays in the quarter. |
#'  |success_rates_standard_downs_total |double |Success rate on standard downs, whole game. |
#'  |success_rates_standard_downs_quarter1 |double |Success rate on standard downs, first quarter; NA when there were none. |
#'  |success_rates_standard_downs_quarter2 |double |Success rate on standard downs, second quarter; NA when there were none. |
#'  |success_rates_standard_downs_quarter3 |double |Success rate on standard downs, third quarter; NA when there were none. |
#'  |success_rates_standard_downs_quarter4 |double |Success rate on standard downs, fourth quarter; NA when there were none. |
#'  |success_rates_passing_downs_total |double |Success rate on passing downs, whole game. |
#'  |success_rates_passing_downs_quarter1 |double |Success rate on passing downs, first quarter; NA when there were none. |
#'  |success_rates_passing_downs_quarter2 |double |Success rate on passing downs, second quarter; NA when there were none. |
#'  |success_rates_passing_downs_quarter3 |double |Success rate on passing downs, third quarter; NA when there were none. |
#'  |success_rates_passing_downs_quarter4 |double |Success rate on passing downs, fourth quarter; NA when there were none. |
#'  |explosiveness_overall_total |double |Explosiveness (average PPA on successful plays), whole game. |
#'  |explosiveness_overall_quarter1 |double |Explosiveness, first quarter; NA when the team had no successful plays. |
#'  |explosiveness_overall_quarter2 |double |Explosiveness, second quarter; NA when the team had no successful plays. |
#'  |explosiveness_overall_quarter3 |double |Explosiveness, third quarter; NA when the team had no successful plays. |
#'  |explosiveness_overall_quarter4 |double |Explosiveness, fourth quarter; NA when the team had no successful plays. |
#'  |rushing_power_success |double |Proportion of short-yardage runs (third or fourth down, 2 yards or fewer to go) that gained a first down or touchdown. |
#'  |rushing_stuff_rate |double |Proportion of rushes stopped at or behind the line of scrimmage. |
#'  |rushing_line_yds |double |Total offensive line yards (Football Outsiders line-yards method). |
#'  |rushing_line_yds_avg |double |Offensive line yards per rush. |
#'  |rushing_second_lvl_yds |double |Total second-level yards: rushing yards gained 5 to 10 yards past the line of scrimmage. |
#'  |rushing_second_lvl_yds_avg |double |Second-level yards per rush. |
#'  |rushing_open_field_yds |double |Total open-field yards: rushing yards gained more than 10 yards past the line of scrimmage. |
#'  |rushing_open_field_yds_avg |double |Open-field yards per rush. |
#'  |havoc_total |double |Havoc rate the team's offense faced: the opponent defense's proportion of plays with a tackle for loss, forced fumble, interception or pass breakup (positional pairing, see above). |
#'  |havoc_front_seven |double |Front-seven havoc rate the team's offense faced (opponent defense's value, see above). |
#'  |havoc_db |double |Defensive-back havoc rate the team's offense faced (opponent defense's value, see above). |
#'  |scoring_opps_opportunities |double |Scoring opportunities: drives with a first down inside the opponent 40. |
#'  |scoring_opps_points |double |Points scored on scoring-opportunity drives. |
#'  |scoring_opps_pts_per_opp |double |Points per scoring opportunity. |
#'  |field_pos_avg_start |double |Average drive start, in yards to the end zone being attacked (70 = own 30). |
#'  |field_pos_avg_starting_predicted_pts |double |Average predicted points of the team's drive starts. |
#'
#' **long** (`long = TRUE`) - a plain data frame (not `cfbfastR_data`), one row per
#' statistic in CFBD order:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |stat |character |Statistic name, as in the wide columns except that the three rushing averages end in `_yd_avg` (e.g. `rushing_line_yd_avg`), plus one `<section>_team` row per section (e.g. `havoc_team`) naming the team whose values fill `team1` and `team2` for that section. |
#'  |team1 |character |Value for the first team listed in the section, as text. |
#'  |team2 |character |Value for the second team listed in the section, as text. |
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
#' @param year (*Integer* required unless `game_id` is supplied): Year, 4 digit format(*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_game_player_stats', 'min_year']`
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
#' @param game_id (*Integer* optional): Game ID filter for querying a single game. When supplied it is sent alone as `id`; `year`, `week`, `season_type`, `team` and `conference` are omitted (CFBD rejects them alongside `id`).
#' Can be found using the [cfbd_game_info()] function
#'
#' @param division (*String* optional): Division/classification filter -- one of `fbs`, `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.
#' @return [cfbd_game_player_stats()] - A data frame with 32 variables:
#'
#'   |col_name            |type      |description                                                                        |
#'   |:-------------------|:---------|:----------------------------------------------------------------------------------|
#'   |game_id             |integer   |CFBD-internal game id; join key to other CFBD endpoints.                           |
#'   |team                |character |Full team name (e.g. "Alabama") for the player's team.                             |
#'   |conference          |character |Conference name of the player's team (e.g. "SEC").                                 |
#'   |home_away           |character |Whether the player's team played at home or away ("home"/"away").                  |
#'   |team_points         |integer   |Total points scored by the player's team in this game.                             |
#'   |athlete_id          |integer   |CFBD-internal athlete id for the player.                                           |
#'   |athlete_name        |character |Player's display name as reported by CFBD.                                         |
#'   |defensive_td        |double    |Defensive touchdowns scored by the player.                                         |
#'   |defensive_qb_hur    |double    |Quarterback hurries credited to the player.                                        |
#'   |defensive_pd        |double    |Passes defended (pass breakups) by the player.                                     |
#'   |defensive_tfl       |double    |Tackles for loss credited to the player.                                           |
#'   |defensive_sacks     |double    |Sacks credited to the player.                                                      |
#'   |defensive_solo      |double    |Solo (unassisted) tackles by the player.                                           |
#'   |defensive_tot       |double    |Total tackles (solo plus assisted) by the player.                                  |
#'   |fumbles_rec         |double    |Fumbles recovered by the player.                                                   |
#'   |fumbles_lost        |double    |Fumbles by the player that were lost to the opposing team.                         |
#'   |fumbles_fum         |double    |Fumbles committed by the player.                                                   |
#'   |punting_long        |double    |Longest punt by the player, in yards.                                              |
#'   |punting_in_20       |double    |Punts downed inside the opponent 20-yard line.                                     |
#'   |punting_tb          |double    |Punts resulting in a touchback.                                                    |
#'   |punting_avg         |double    |Average yards per punt.                                                            |
#'   |punting_yds         |double    |Total punting yards (gross).                                                       |
#'   |punting_no          |double    |Number of punts attempted.                                                         |
#'   |kicking_pts         |double    |Total points scored by the kicker (FGs + XPs).                                     |
#'   |kicking_long        |double    |Longest made field goal, in yards.                                                 |
#'   |kicking_pct         |double    |Field-goal percentage (made / attempted), 0-100.                                   |
#'   |punt_returns_td     |double    |Touchdowns scored on punt returns.                                                 |
#'   |punt_returns_long   |double    |Longest punt return, in yards.                                                     |
#'   |punt_returns_avg    |double    |Average yards per punt return.                                                     |
#'   |punt_returns_yds    |double    |Total punt-return yards.                                                           |
#'   |punt_returns_no     |double    |Number of punt returns.                                                            |
#'   |kick_returns_td     |double    |Touchdowns scored on kickoff returns.                                              |
#'   |kick_returns_long   |double    |Longest kickoff return, in yards.                                                  |
#'   |kick_returns_avg    |double    |Average yards per kickoff return.                                                  |
#'   |kick_returns_yds    |double    |Total kickoff-return yards.                                                        |
#'   |kick_returns_no     |double    |Number of kickoff returns.                                                         |
#'   |interceptions_td    |double    |Touchdowns scored on interception returns (pick-sixes).                            |
#'   |interceptions_yds   |double    |Interception-return yards.                                                         |
#'   |interceptions_int   |double    |Number of interceptions made by the player.                                        |
#'   |receiving_long      |double    |Longest reception by the player, in yards.                                         |
#'   |receiving_td        |double    |Receiving touchdowns.                                                              |
#'   |receiving_avg       |double    |Average yards per reception.                                                       |
#'   |receiving_yds       |double    |Total receiving yards.                                                             |
#'   |receiving_rec       |double    |Number of receptions (catches).                                                    |
#'   |rushing_long        |double    |Longest rush by the player, in yards.                                              |
#'   |rushing_td          |double    |Rushing touchdowns.                                                                |
#'   |rushing_avg         |double    |Average yards per rushing attempt.                                                 |
#'   |rushing_yds         |double    |Total rushing yards.                                                               |
#'   |rushing_car         |double    |Rushing carries (attempts).                                                        |
#'   |passing_int         |double    |Interceptions thrown by the passer.                                                |
#'   |passing_td          |double    |Passing touchdowns thrown.                                                         |
#'   |passing_avg         |double    |Yards per pass attempt.                                                            |
#'   |passing_yds         |double    |Total passing yards.                                                               |
#'   |passing_completions |double    |Pass completions (split from CFBD's `C/ATT` field).                                |
#'   |passing_attempts    |double    |Pass attempts (split from CFBD's `C/ATT` field).                                   |
#'   |passing_qbr         |double    |ESPN Quarterback Rating (QBR) for the player in this game.                         |
#'   |kicking_xpm         |double    |Extra points made (split from CFBD's `XP` field).                                  |
#'   |kicking_xpa         |double    |Extra points attempted (split from CFBD's `XP` field).                             |
#'   |kicking_fgm         |double    |Field goals made (split from CFBD's `FG` field).                                   |
#'   |kicking_fga         |double    |Field goals attempted (split from CFBD's `FG` field).                              |
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

cfbd_game_player_stats <- function(year = NULL,
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
  # CFBD 5.31.1: `id` selects one game and must travel alone -- the API rejects
  # `year` alongside it ("either week, team, or conference are required") --
  # while without `id`, `year` is required.
  if (is.null(year) && is.null(game_id)) {
    cli::cli_abort("Supply {.arg year}, or {.arg game_id} for a single game.")
  }
  if (!is.null(game_id)) {
    year <- week <- season_type <- team <- conference <- category <- NULL
  }

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
    "id" = game_id,
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
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_game_records', 'min_year']`
#' @param team (*String* optional): Team - Select a valid team, D1 football
#' @param conference (*String* optional): DI Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @return [cfbd_game_records()] - A data frame with 35 variables:
#'
#'   |col_name              |type      |description                                                          |
#'   |:---------------------|:---------|:--------------------------------------------------------------------|
#'   |year                  |integer   |Season of the games.                                                 |
#'   |team_id               |integer   |Referencing team id.                                                 |
#'   |team                  |character |Team name.                                                           |
#'   |classification        |character |Conference classification (fbs, fcs, ii, iii).                       |
#'   |conference            |character |Conference of the team.                                              |
#'   |division              |character |Division in the conference of the team.                              |
#'   |expected_wins         |double    |Expected number of wins based on post-game win probability.          |
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
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*). Required year filter (along with one of `week`, `team`, or `conference`), unless `game_id` is specified \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_game_team_stats', 'min_year']`
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier. Required if `team` and `conference` not specified.
#' @param season_type (*String* default: regular): Select Season Type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team. Required if `week` and `conference` not specified.
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' Required if `week` and `team` not specified.
#' @param division (*String* optional): Division abbreviation - Select a valid division: fbs/fcs/ii/iii
#' @param game_id (*Integer* optional): Game ID filter for querying a single game. When supplied it is sent alone as `id`; `year`, `week`, `season_type`, `team` and `conference` are omitted (CFBD rejects them alongside `id`).
#' Can be found using the [cfbd_game_info()] function
#' @param rows_per_team (*Integer* default 1): Both Teams for each game on one or two row(s), Options: 1 or 2
#'
#' @return A data frame with one row per team per game and 78 variables. A `team` query
#' keeps both teams of each of that team's games; a `conference` query keeps only the
#' rows of that conference's teams. The box-score statistics are character, as CFBD
#' sends them, and NA when CFBD has no value for that team. Every column from `points`
#' to `possession_time` is repeated with the suffix `_allowed`, holding the opponent's
#' value from the same game. With `rows_per_team = 2`, `opponent`,
#' `opponent_conference` and the `_allowed` columns are dropped (40 variables). `NULL`
#' is returned with a warning when CFBD returns no games (e.g. a bye week), and an
#' empty data frame if the request fails.
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |game_id |integer |Unique CFBD game identifier. |
#'  |school |character |Team name (CFBD `team`, renamed). |
#'  |conference |character |Conference of the team. |
#'  |home_away |character |home or away. |
#'  |opponent |character |Opponent team name; absent with `rows_per_team = 2`. |
#'  |opponent_conference |character |Conference of the opponent; absent with `rows_per_team = 2`. |
#'  |points |integer |Team points. |
#'  |total_yards |character |Total offensive yards. |
#'  |net_passing_yards |character |Net passing yards. |
#'  |completion_attempts |character |Completions and pass attempts as completions-attempts text (e.g. 21-28). |
#'  |passing_tds |character |Passing touchdowns. |
#'  |yards_per_pass |character |Yards per pass attempt. |
#'  |passes_intercepted |character |Opponent passes the team intercepted; NA when none recorded. |
#'  |interception_yards |character |Return yards on the team's interceptions. |
#'  |interception_tds |character |Interceptions the team returned for a touchdown. |
#'  |rushing_attempts |character |Rushing attempts. |
#'  |rushing_yards |character |Rushing yards. |
#'  |rush_tds |character |Rushing touchdowns. |
#'  |yards_per_rush_attempt |character |Yards per rushing attempt. |
#'  |first_downs |character |First downs. |
#'  |third_down_eff |character |Third-down conversions as conversions-attempts text (e.g. 6-11). |
#'  |fourth_down_eff |character |Fourth-down conversions as conversions-attempts text (e.g. 1-1). |
#'  |punt_returns |character |Punt returns; NA when none recorded. |
#'  |punt_return_yards |character |Punt return yards. |
#'  |punt_return_tds |character |Punt return touchdowns. |
#'  |kick_return_yards |character |Kickoff return yards. |
#'  |kick_return_tds |character |Kickoff return touchdowns. |
#'  |kick_returns |character |Kickoff returns. |
#'  |kicking_points |character |Points from kicking (field goals and extra points). |
#'  |fumbles_recovered |character |Fumbles recovered. |
#'  |fumbles_lost |character |Fumbles lost to the opponent. |
#'  |total_fumbles |character |Total fumbles; NA when none recorded. |
#'  |tackles |character |Tackles. |
#'  |tackles_for_loss |character |Tackles for loss. |
#'  |sacks |character |Sacks by the team's defense. |
#'  |qb_hurries |character |Quarterback hurries by the team's defense. |
#'  |interceptions |character |Interceptions thrown by the team (counted in `turnovers`). |
#'  |passes_deflected |character |Passes deflected by the team's defense. |
#'  |turnovers |character |Turnovers committed. |
#'  |defensive_tds |character |Defensive touchdowns. |
#'  |total_penalties_yards |character |Penalties and penalty yards as penalties-yards text (e.g. 8-71). |
#'  |possession_time |character |Time of possession as minutes:seconds text (e.g. 36:19). |
#'  |points_allowed |integer |Points scored by the opponent. |
#'  |total_yards_allowed |character |Opponent total offensive yards. |
#'  |net_passing_yards_allowed |character |Opponent net passing yards. |
#'  |completion_attempts_allowed |character |Opponent completions and pass attempts as completions-attempts text. |
#'  |passing_tds_allowed |character |Opponent passing touchdowns. |
#'  |yards_per_pass_allowed |character |Opponent yards per pass attempt. |
#'  |passes_intercepted_allowed |character |Team passes the opponent intercepted; NA when none recorded. |
#'  |interception_yards_allowed |character |Return yards on the opponent's interceptions. |
#'  |interception_tds_allowed |character |Interceptions the opponent returned for a touchdown. |
#'  |rushing_attempts_allowed |character |Opponent rushing attempts. |
#'  |rushing_yards_allowed |character |Opponent rushing yards. |
#'  |rush_tds_allowed |character |Opponent rushing touchdowns. |
#'  |yards_per_rush_attempt_allowed |character |Opponent yards per rushing attempt. |
#'  |first_downs_allowed |character |Opponent first downs. |
#'  |third_down_eff_allowed |character |Opponent third-down conversions as conversions-attempts text. |
#'  |fourth_down_eff_allowed |character |Opponent fourth-down conversions as conversions-attempts text. |
#'  |punt_returns_allowed |character |Opponent punt returns; NA when none recorded. |
#'  |punt_return_yards_allowed |character |Opponent punt return yards. |
#'  |punt_return_tds_allowed |character |Opponent punt return touchdowns. |
#'  |kick_return_yards_allowed |character |Opponent kickoff return yards. |
#'  |kick_return_tds_allowed |character |Opponent kickoff return touchdowns. |
#'  |kick_returns_allowed |character |Opponent kickoff returns. |
#'  |kicking_points_allowed |character |Opponent points from kicking. |
#'  |fumbles_recovered_allowed |character |Opponent fumbles recovered. |
#'  |fumbles_lost_allowed |character |Fumbles the opponent lost. |
#'  |total_fumbles_allowed |character |Opponent total fumbles; NA when none recorded. |
#'  |tackles_allowed |character |Opponent tackles. |
#'  |tackles_for_loss_allowed |character |Opponent tackles for loss. |
#'  |sacks_allowed |character |Sacks by the opponent's defense. |
#'  |qb_hurries_allowed |character |Quarterback hurries by the opponent's defense. |
#'  |interceptions_allowed |character |Interceptions thrown by the opponent. |
#'  |passes_deflected_allowed |character |Passes deflected by the opponent's defense. |
#'  |turnovers_allowed |character |Turnovers committed by the opponent. |
#'  |defensive_tds_allowed |character |Opponent defensive touchdowns. |
#'  |total_penalties_yards_allowed |character |Opponent penalties and penalty yards as penalties-yards text. |
#'  |possession_time_allowed |character |Opponent time of possession. |
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

cfbd_game_team_stats <- function(year = NULL,
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
  # CFBD 5.31.1: `id` selects one game and must travel alone -- the API rejects
  # `year` alongside it ("either week, team, or conference are required") --
  # while without `id`, `year` is required.
  if (is.null(year) && is.null(game_id)) {
    cli::cli_abort("Supply {.arg year}, or {.arg game_id} for a single game.")
  }
  if (!is.null(game_id)) {
    year <- week <- season_type <- team <- conference <- NULL
  }

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
    "id" = game_id
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
#' @return A data frame with one row per game on the current CFBD scoreboard. The
#' quarter columns depend on how far the games have gone: `home_team_line_scores_Q1`
#' and `away_team_line_scores_Q1` are always present (all NA before any game starts),
#' `_Q2` to `_Q4` appear once any game in the result has reached that quarter, and
#' overtime adds `_Q5` onward. So there are 37 variables before kickoff and 43 once a
#' game reaches the fourth quarter. An empty data frame is returned if the request fails.
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |game_id |integer |CFBD-internal game id; join key to other CFBD endpoints. |
#'  |start_date |character |Scheduled kickoff timestamp (ISO 8601, UTC). |
#'  |start_time_tbd |logical |TRUE if the scheduled kickoff time is still to be determined. |
#'  |tv |character |Television network broadcasting the game (e.g. ESPNU). |
#'  |neutral_site |logical |TRUE if the game is being played at a neutral site. |
#'  |conference_game |logical |TRUE if the game is a conference game. |
#'  |status |character |Game status: scheduled, in_progress or completed. |
#'  |period |integer |Current period/quarter number (1-4, 5+ for overtime); NA before kickoff. |
#'  |clock |character |Game clock remaining in the current period, as sent by CFBD; NA before kickoff. |
#'  |situation |character |Free-text down-and-distance / field-position summary for the current play; NA before kickoff. |
#'  |possession |character |Team currently in possession, as sent by CFBD; NA before kickoff. |
#'  |last_play |character |Free-text description of the most recent play; NA before kickoff. |
#'  |venue_name |character |Stadium / venue name. |
#'  |venue_city |character |City where the venue is located. |
#'  |venue_state |character |State (or province/country) where the venue is located. |
#'  |home_team_id |integer |CFBD-internal team id for the home team. |
#'  |home_team_name |character |Home team display name including mascot (e.g. Kansas Jayhawks). |
#'  |home_team_conference |character |Conference name of the home team. |
#'  |home_team_classification |character |Division classification of the home team: fbs, fcs, ii, ii/iii or iii. |
#'  |home_team_points |integer |Current total points scored by the home team; NA before kickoff. |
#'  |home_team_line_scores_Q1 |integer |Home team points scored in the first quarter; NA before kickoff. |
#'  |home_team_line_scores_Q2 |integer |Home team points scored in the second quarter; present once any game in the result has reached it. |
#'  |home_team_line_scores_Q3 |integer |Home team points scored in the third quarter; present once any game in the result has reached it. |
#'  |home_team_line_scores_Q4 |integer |Home team points scored in the fourth quarter; present once any game in the result has reached it. |
#'  |home_team_win_probability |double |Home team win probability reported by CFBD; NA while the game is scheduled. |
#'  |away_team_id |integer |CFBD-internal team id for the away team. |
#'  |away_team_name |character |Away team display name including mascot (e.g. Middle Tennessee Blue Raiders). |
#'  |away_team_conference |character |Conference name of the away team. |
#'  |away_team_classification |character |Division classification of the away team: fbs, fcs, ii, ii/iii or iii. |
#'  |away_team_points |integer |Current total points scored by the away team; NA before kickoff. |
#'  |away_team_line_scores_Q1 |integer |Away team points scored in the first quarter; NA before kickoff. |
#'  |away_team_line_scores_Q2 |integer |Away team points scored in the second quarter; present once any game in the result has reached it. |
#'  |away_team_line_scores_Q3 |integer |Away team points scored in the third quarter; present once any game in the result has reached it. |
#'  |away_team_line_scores_Q4 |integer |Away team points scored in the fourth quarter; present once any game in the result has reached it. |
#'  |away_team_win_probability |double |Away team win probability reported by CFBD; NA while the game is scheduled. |
#'  |weather_temperature |double |Temperature at kickoff, in degrees Fahrenheit. |
#'  |weather_description |character |Free-text weather description (e.g. Clear, Light rain). |
#'  |weather_wind_speed |double |Wind speed, in miles per hour. |
#'  |weather_wind_direction |integer |Wind direction, in degrees (0-360, 0 = north). |
#'  |betting_spread |double |Pre-game point spread relative to the home team (negative = home favored). |
#'  |betting_over_under |double |Pre-game over/under (total) line in points. |
#'  |betting_home_moneyline |integer |American-odds moneyline for the home team. |
#'  |betting_away_moneyline |integer |American-odds moneyline for the away team. |
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


#' @title
#' **Get the active or next game schedule slate**
#' @description
#' **Returns the active or next calendar slate, including completed games.**
#' Explicit windows require `year`, `season_type`, and `week` together; with none
#' of them CFBD picks the slate itself and says which in the `selection` attribute.
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Explicit windows require `year`, `season_type`, and `week` together.
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_game_schedule', 'min_year']`
#' @param season_type (*String* optional): Season type: regular or postseason.
#' @param week (*Integer* optional): Week.
#' @param division (*String* optional): Division of either participant: fbs or fcs. CFBD defaults to fbs. Sent to CFBD as `classification`.
#' @param conference (*String* optional): Conference abbreviation of either participant.
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables.
#' @return A data frame with one row per game in the slate. The slate-level fields of
#' the response are carried as attributes: `attr(x, "selection")` (active, next,
#' explicit or none), `attr(x, "window")` and `attr(x, "following_window")` (each a list
#' of `year`, `seasonType`, `week`, `startDate`, `endDate`), `attr(x, "filters")` and
#' `attr(x, "assembled_at")`. Nested blocks are flattened into prefixed columns; a block
#' that no game in the slate carries collapses to one all-NA column named after it
#' (`playoff` in a regular-season slate, and likewise `venue` or `odds_data`), so the
#' column count varies by slate (42 for 2025 regular week 1, 49 for 2024 postseason
#' week 1). An empty data frame is returned if the request fails.
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |game_id |integer |Unique CFBD game identifier. |
#'  |season |integer |Season of the game. |
#'  |week |integer |Game week (postseason games restart at week 1). |
#'  |season_type |character |Season type of the game: regular or postseason. |
#'  |status |character |Game status: scheduled, in_progress or completed. |
#'  |status_checked_at |character |When CFBD last checked the game status (ISO 8601, UTC). |
#'  |start_date |character |Game start date-time (ISO 8601, UTC). |
#'  |start_time_tbd |logical |TRUE if the start time is still to be determined. |
#'  |neutral_site |logical |TRUE if the game is at a neutral site. |
#'  |conference_game |logical |TRUE if the game is a conference game. |
#'  |playoff |logical |All-NA placeholder, present only when no game in the slate has playoff context; otherwise the eight `playoff_*` columns after `venue_state` replace it. |
#'  |home_team_id |integer |Home team id. |
#'  |home_team_name |character |Home team name. |
#'  |home_team_conference |character |Home team conference. |
#'  |home_team_conference_abbreviation |character |Home team conference abbreviation. |
#'  |home_team_classification |character |Home team division classification: fbs, fcs, ii, ii/iii or iii. |
#'  |home_team_points |integer |Home team points; NA until the game has a score. |
#'  |away_team_id |integer |Away team id. |
#'  |away_team_name |character |Away team name. |
#'  |away_team_conference |character |Away team conference. |
#'  |away_team_conference_abbreviation |character |Away team conference abbreviation. |
#'  |away_team_classification |character |Away team division classification: fbs, fcs, ii, ii/iii or iii. |
#'  |away_team_points |integer |Away team points; NA until the game has a score. |
#'  |venue_id |integer |Venue id. |
#'  |venue_name |character |Venue name. |
#'  |venue_city |character |Venue city. |
#'  |venue_state |character |Venue state abbreviation; empty for venues outside the US. |
#'  |playoff_competition |character |Playoff competition (cfp). Present only when at least one game in the slate has playoff context, as are the other `playoff_*` columns; NA for the other games. |
#'  |playoff_format |character |Playoff format (e.g. twelve_team_2024). |
#'  |playoff_round |character |Playoff round: first_round, quarterfinal, semifinal or championship. |
#'  |playoff_round_name |character |Display name of the round (e.g. First Round). |
#'  |playoff_bracket_slot |character |Bracket slot code (e.g. FR3). |
#'  |playoff_home_seed |integer |Home team playoff seed. |
#'  |playoff_away_seed |integer |Away team playoff seed. |
#'  |playoff_bowl_name |character |Name of the bowl hosting the game; NA when none. |
#'  |broadcasts_status |character |Broadcast section status: available, no_data or unavailable. |
#'  |broadcasts_reason |character |Why the broadcast section has no data: no_data, no_results_yet, source_error or invalid_data; NA when available. |
#'  |broadcasts_assembled_at |character |When CFBD assembled the broadcast section (ISO 8601, UTC). |
#'  |broadcasts_source_updated_at |character |Publication time of the broadcast snapshot, not a games-through cutoff (ISO 8601, UTC); NA when CFBD sends none. |
#'  |broadcasts_data |list |Broadcasts: one data frame per game of `mediaType` (tv, radio, web, ppv or mobile) and `outlet`; NULL or empty when the section has no data. |
#'  |odds_status |character |Odds section status: available, no_data or unavailable. |
#'  |odds_reason |character |Why the odds section has no data: no_data, no_results_yet, source_error or invalid_data; NA when available. |
#'  |odds_assembled_at |character |When CFBD assembled the odds section (ISO 8601, UTC). |
#'  |odds_source_updated_at |character |Publication time of the odds snapshot, not a games-through cutoff (ISO 8601, UTC); NA when CFBD sends none. |
#'  |odds_data_provider_id |integer |Sportsbook provider id; NA when the game has no odds. |
#'  |odds_data_provider |character |Sportsbook: DraftKings or Bovada. |
#'  |odds_data_spread |double |Home-relative point spread; negative favors home. |
#'  |odds_data_over_under |double |Total points line. |
#'  |odds_data_home_moneyline |integer |Home team moneyline (American odds). |
#'  |odds_data_away_moneyline |integer |Away team moneyline (American odds). |
#'
#' @keywords Game Schedule
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom dplyr rename any_of
#' @family CFBD Games
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_game_schedule(year = 2025, season_type = "regular", week = 1))
#' }
cfbd_game_schedule <- function(year = NULL,
                               season_type = NULL,
                               week = NULL,
                               division = NULL,
                               conference = NULL,
                               proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_list(season_type, c("regular", "postseason"))
  validate_list(division, c("fbs", "fcs"))
  window_args <- c(!is.null(year), !is.null(season_type), !is.null(week))
  if (any(window_args) && !all(window_args)) {
    cli::cli_abort("{.arg year}, {.arg season_type} and {.arg week} must be supplied together, or all left {.code NULL}.")
  }

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/games/schedule"
  query_params <- list(
    "year" = year,
    "seasonType" = season_type,
    "week" = week,
    "classification" = division,
    "conference" = conference
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url, proxy = proxy)
      check_status(res)

      # One object per slate: the games array plus slate-level scalars.
      parsed <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      df <- .cfbd_section_tbl(parsed$games) |>
        dplyr::rename(dplyr::any_of(c("game_id" = "id")))

      df <- df |>
        make_cfbfastR_data("Game schedule data from CollegeFootballData.com", Sys.time())

      attr(df, "selection") <- parsed$selection
      attr(df, "window") <- parsed$window
      attr(df, "following_window") <- parsed$followingWindow
      attr(df, "filters") <- parsed$filters
      attr(df, "assembled_at") <- parsed$assembledAt
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game schedule data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get a pregame preview for a game**
#' @description
#' **Returns pregame team comparisons and key players.**
#' Analysis remains available until the game is completed. Team statistics may
#' use the previous season; players and context stay in the game season.
#' @param game_id (*Integer* required): Game ID filter for querying a single game.
#' Can be found using the [cfbd_game_info()] or [cfbd_game_schedule()] functions.
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables.
#' @return A named list of data frames: `game`, `broadcasts`, `odds`, `teams`,
#' `key_players`, `recent_results`, `series`, `series_meetings`. The sections have
#' different row grains, so they are not joined. A section CFBD did not fill is a
#' 0-column tibble: once `availability` is `metadata_only` (for example a completed
#' game) every section except `game` is empty. Nested objects are flattened into
#' prefixed columns, and a nested object CFBD sends as null (`venue`, `playoff`,
#' `latest_meeting`, `streak`, a statistics block) becomes one all-NA column named
#' after it instead of its prefixed columns. An empty list is returned if the
#' request fails.
#'
#' **game** - one row:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |game_id |integer |Unique CFBD game identifier. |
#'  |season |integer |Season of the game. |
#'  |week |integer |Game week (postseason games restart at week 1). |
#'  |season_type |character |Season type of the game (e.g. regular, postseason). |
#'  |status |character |Game status: scheduled, in_progress or completed. |
#'  |status_checked_at |character |When CFBD last checked the game status (ISO 8601, UTC). |
#'  |start_date |character |Game start date-time (ISO 8601, UTC). |
#'  |start_time_tbd |logical |TRUE if the start time is still to be determined. |
#'  |neutral_site |logical |TRUE if the game is at a neutral site. |
#'  |conference_game |logical |TRUE if the game is a conference game. |
#'  |home_team_id |integer |Home team id. |
#'  |home_team_name |character |Home team name. |
#'  |home_team_conference |character |Home team conference. |
#'  |home_team_conference_abbreviation |character |Home team conference abbreviation. |
#'  |home_team_classification |character |Home team division classification: fbs, fcs, ii, ii/iii or iii. |
#'  |home_team_points |integer |Home team points; NA until the game has a score. |
#'  |away_team_id |integer |Away team id. |
#'  |away_team_name |character |Away team name. |
#'  |away_team_conference |character |Away team conference. |
#'  |away_team_conference_abbreviation |character |Away team conference abbreviation. |
#'  |away_team_classification |character |Away team division classification: fbs, fcs, ii, ii/iii or iii. |
#'  |away_team_points |integer |Away team points; NA until the game has a score. |
#'  |venue_id |integer |Venue id. |
#'  |venue_name |character |Venue name. |
#'  |venue_city |character |Venue city. |
#'  |venue_state |character |Venue state abbreviation. |
#'  |playoff |logical |All-NA placeholder, present only when the game is not a College Football Playoff game (the eight `playoff_*` columns replace it for CFP games). |
#'  |playoff_competition |character |Playoff competition (cfp); present only for CFP games. |
#'  |playoff_format |character |Playoff format (e.g. twelve_team_2025); present only for CFP games. |
#'  |playoff_round |character |Playoff round: first_round, quarterfinal, semifinal or championship; present only for CFP games. |
#'  |playoff_round_name |character |Display name of the round (e.g. Quarterfinal); present only for CFP games. |
#'  |playoff_bracket_slot |character |Bracket slot code (e.g. FR4, QF1); present only for CFP games. |
#'  |playoff_home_seed |integer |Home team playoff seed; present only for CFP games. |
#'  |playoff_away_seed |integer |Away team playoff seed; present only for CFP games. |
#'  |playoff_bowl_name |character |Name of the bowl hosting the game (e.g. Rose Bowl), NA when none; present only for CFP games. |
#'  |availability |character |pregame (analysis sections filled) or metadata_only (only `game` is filled). |
#'  |reason |character |Why analysis is not available: game_started, game_completed, kickoff_reached or kickoff_unknown; NA when `availability` is pregame. |
#'  |assembled_at |character |When CFBD assembled the preview (ISO 8601, UTC). |
#'
#' **broadcasts** - one row per broadcast:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |media_type |character |Broadcast medium: tv, radio, web, ppv or mobile. |
#'  |outlet |character |Broadcast outlet (e.g. ABC). |
#'
#' **odds** - one row, the line from the selected sportsbook:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |provider_id |integer |Sportsbook provider id. |
#'  |provider |character |Sportsbook: DraftKings or Bovada. |
#'  |spread |double |Home-relative point spread; negative favors home. A whole-number spread parses as integer. |
#'  |over_under |double |Total points line. |
#'  |home_moneyline |integer |Home team moneyline (American odds). |
#'  |away_moneyline |integer |Away team moneyline (American odds). |
#'
#' **teams** - one row per side (home, away). The rows `ppa` through
#' `field_position_average_predicted_points` (metrics) and `rank` through
#' `percentile` (stats) are base names: each metric appears as the columns
#' `statistics_data_stat_rankings_<side>_<metric>_<stat>`, for `<side>` `offense`
#' then `defense`, every metric in row order and every stat in row order (160
#' columns), except that a metric CFBD sends as null (in the sample,
#' `power_success`) is one all-NA `statistics_data_stat_rankings_<side>_<metric>`
#' column instead of four:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |side |character |home or away: which team of this game the row describes. |
#'  |team_id |integer |Team id. |
#'  |season |integer |Season of the game. |
#'  |statistics_status |character |Status of the team statistics section: available, no_data or unavailable. |
#'  |statistics_reason |character |Why the statistics section has no data: no_data, no_results_yet, source_error or invalid_data; NA when available. |
#'  |statistics_assembled_at |character |When CFBD assembled the statistics section (ISO 8601, UTC). |
#'  |statistics_source_updated_at |character |Publication time of the statistics snapshot, not a games-through cutoff (ISO 8601, UTC). |
#'  |statistics_data_season |integer |Season the team statistics come from. |
#'  |statistics_data_is_previous_season |logical |TRUE when the statistics come from the season before the game season. |
#'  |statistics_data_advanced_* |varies |The `advanced` section of [cfbd_team_season_overview()] for `statistics_data_season` (same columns and order), prefixed `statistics_data_advanced_`; each column is defined there. |
#'  |statistics_data_passing_* |varies |All columns of [cfbd_passing_teams_season()], including `season`, `team` and `conference`, in the order of the `passing` section of [cfbd_team_season_overview()], prefixed `statistics_data_passing_`; each column is defined there, see [cfbd_passing]. |
#'  |statistics_data_rushing_* |varies |All columns of [cfbd_rushing_teams_season()], including `season`, `team` and `conference`, in the order of the `rushing` section of [cfbd_team_season_overview()], prefixed `statistics_data_rushing_`; each column is defined there, see [cfbd_rushing]. |
#'  |statistics_data_stat_rankings_team_id |integer |Team id the stat rankings are for. |
#'  |statistics_data_stat_rankings_season |integer |Season the stat rankings are computed for. |
#'  |statistics_data_stat_rankings_division |character |Division the team is ranked within: fbs, fcs, ii, ii/iii or iii. |
#'  |statistics_data_stat_rankings_division_team_count |integer |Number of teams in that division. |
#'  |statistics_data_stat_rankings_calculated_at |character |When CFBD calculated the stat rankings (ISO 8601, UTC). |
#'  |statistics_data_stat_rankings_expires_at |character |When CFBD's cached stat rankings expire (ISO 8601, UTC). |
#'  |statistics_data_stat_rankings_source_updated_at |character |Publication time of the statistics the rankings are built from (ISO 8601, UTC). |
#'  |ppa |varies |Metric: predicted points added (EPA) per play, `statistics_data_advanced_<side>_ppa`. |
#'  |success_rate |varies |Metric: success rate (proportion of successful plays), `statistics_data_advanced_<side>_success_rate`. |
#'  |explosiveness |varies |Metric: explosiveness (average PPA on successful plays), `statistics_data_advanced_<side>_explosiveness`. |
#'  |standard_downs_success_rate |varies |Metric: success rate on standard downs, `statistics_data_advanced_<side>_standard_downs_success_rate`. |
#'  |passing_downs_success_rate |varies |Metric: success rate on passing downs, `statistics_data_advanced_<side>_passing_downs_success_rate`. |
#'  |passing_plays_ppa |varies |Metric: PPA per pass play, `statistics_data_advanced_<side>_passing_plays_ppa`. |
#'  |rushing_plays_ppa |varies |Metric: PPA per rush play, `statistics_data_advanced_<side>_rushing_plays_ppa`. |
#'  |passing_plays_explosiveness |varies |Metric: explosiveness of pass plays, `statistics_data_advanced_<side>_passing_plays_explosiveness`. |
#'  |rushing_plays_explosiveness |varies |Metric: explosiveness of rush plays, `statistics_data_advanced_<side>_rushing_plays_explosiveness`. |
#'  |line_yards |varies |Metric: offensive line yards per rush, `statistics_data_advanced_<side>_line_yards`. |
#'  |second_level_yards |varies |Metric: second-level yards per rush (5-10 yards past the line of scrimmage), `statistics_data_advanced_<side>_second_level_yards`. |
#'  |open_field_yards |varies |Metric: open-field yards per rush (10+ yards past the line of scrimmage), `statistics_data_advanced_<side>_open_field_yards`. |
#'  |stuff_rate |varies |Metric: proportion of rushes stopped at or behind the line of scrimmage, `statistics_data_advanced_<side>_stuff_rate`. |
#'  |power_success |varies |Metric: power success (proportion of short-yardage runs that convert), `statistics_data_advanced_<side>_power_success`. |
#'  |havoc_total |varies |Metric: havoc rate (share of plays with a tackle for loss, forced fumble, interception or pass breakup), `statistics_data_advanced_<side>_havoc_total`. |
#'  |havoc_front_seven |varies |Metric: havoc rate from front-seven players, `statistics_data_advanced_<side>_havoc_front_seven`. |
#'  |havoc_db |varies |Metric: havoc rate from defensive backs, `statistics_data_advanced_<side>_havoc_db`. |
#'  |points_per_opportunity |varies |Metric: points per scoring opportunity, `statistics_data_advanced_<side>_points_per_opportunity`. |
#'  |field_position_average_start |varies |Metric: average drive start in yards to the end zone, `statistics_data_advanced_<side>_field_position_average_start`. |
#'  |field_position_average_predicted_points |varies |Metric: average predicted points of the drive start, `statistics_data_advanced_<side>_field_position_average_predicted_points`. |
#'  |rank |integer |Stat: the team's rank on the metric within `statistics_data_stat_rankings_division`, 1 = best for that side of the ball. |
#'  |population |integer |Stat: number of teams ranked on the metric. |
#'  |tied |logical |Stat: TRUE when the rank is shared with another team. |
#'  |percentile |double |Stat: percentile of the rank within the division, 0-100 (higher is better). |
#'  |record_status |character |Status of the record section: available, no_data or unavailable. |
#'  |record_reason |character |Why the record section has no data: no_data, no_results_yet, source_error or invalid_data; NA when available. |
#'  |record_assembled_at |character |When CFBD assembled the record section (ISO 8601, UTC). |
#'  |record_source_updated_at |character |Publication time of the record snapshot (ISO 8601, UTC); NA when CFBD reports none. |
#'  |record_data_* |varies |The `record` section of [cfbd_team_season_overview()], prefixed `record_data_`; each column is defined there. |
#'  |ratings_status |character |Status of the ratings section: available, no_data or unavailable. |
#'  |ratings_reason |character |Why the ratings section has no data: no_data, no_results_yet, source_error or invalid_data; NA when available. |
#'  |ratings_assembled_at |character |When CFBD assembled the ratings section (ISO 8601, UTC). |
#'  |ratings_source_updated_at |character |Publication time of the ratings snapshot (ISO 8601, UTC); NA when CFBD reports none. |
#'  |ratings_data_* |varies |The `ratings` section of [cfbd_team_season_overview()] (the same padded, typed 25 columns), prefixed `ratings_data_`; each column is defined there. Absent when the ratings section has no data. |
#'
#' **key_players** - one row per key player, per side and category:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |side |character |home or away. |
#'  |category |character |passing, rushing or receiving. |
#'  |athlete_id |character |Player id. |
#'  |name |character |Player name. |
#'  |position |character |Player position. |
#'  |usage |double |Pass/rush involvement (proportion 0-1), not receiving target share. |
#'  |average_ppa |double |Average predicted points added per play. |
#'  |total_ppa |double |Total predicted points added. |
#'
#' **recent_results** - one row per recent game of each side:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |side |character |home or away: the team of this game the result belongs to. |
#'  |game_id |integer |Game id of the recent game. |
#'  |season |integer |Season of the recent game. |
#'  |start_date |character |Start date-time of the recent game (ISO 8601, UTC). |
#'  |home_away |character |Whether the side's team was home or away in that game. |
#'  |neutral_site |logical |TRUE if that game was at a neutral site. |
#'  |team_points |integer |Points scored by the side's team; NA when unknown. |
#'  |opponent_points |integer |Points scored by the opponent; NA when unknown. |
#'  |result |character |Result for the side's team: win, loss, tie or unknown. |
#'  |opponent_id |integer |Opponent team id. |
#'  |opponent_name |character |Opponent team name. |
#'  |venue_id |integer |Venue id. |
#'  |venue_name |character |Venue name. |
#'  |venue_city |character |Venue city. |
#'  |venue_state |character |Venue state abbreviation. |
#'
#' **series** - one row, the all-time series between the two teams:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |home_team_id |integer |Team id of this game's home team. |
#'  |away_team_id |integer |Team id of this game's away team. |
#'  |meetings |integer |Number of all-time meetings. |
#'  |known_results |integer |Meetings with a known result. |
#'  |unknown_results |integer |Meetings with an unknown result. |
#'  |home_wins |integer |Series wins by this game's home team, wherever played. |
#'  |away_wins |integer |Series wins by this game's away team, wherever played. |
#'  |ties |integer |Tied meetings. |
#'  |first_season |integer |Season of the first meeting; NA when the teams have not met. |
#'  |last_season |integer |Season of the most recent meeting; NA when the teams have not met. |
#'  |latest_meeting_game_id |integer |Game id of the most recent meeting. |
#'  |latest_meeting_season |integer |Season of the most recent meeting. |
#'  |latest_meeting_start_date |character |Start date-time of the most recent meeting (ISO 8601, UTC). |
#'  |latest_meeting_home_team_id |integer |Home team id in the most recent meeting. |
#'  |latest_meeting_home_team |character |Home team name in the most recent meeting. |
#'  |latest_meeting_away_team_id |integer |Away team id in the most recent meeting. |
#'  |latest_meeting_away_team |character |Away team name in the most recent meeting. |
#'  |latest_meeting_neutral_site |logical |TRUE if the most recent meeting was at a neutral site. |
#'  |latest_meeting_venue_id |integer |Venue id of the most recent meeting. |
#'  |latest_meeting_venue_name |character |Venue name of the most recent meeting. |
#'  |latest_meeting_venue_city |character |Venue city of the most recent meeting. |
#'  |latest_meeting_venue_state |character |Venue state abbreviation of the most recent meeting. |
#'  |latest_meeting_home_points |integer |Home team points in the most recent meeting. |
#'  |latest_meeting_away_points |integer |Away team points in the most recent meeting. |
#'  |latest_meeting_winner_team_id |integer |Winning team id in the most recent meeting; NA for a tie or unknown result. |
#'  |latest_meeting_result |character |Result of the most recent meeting: win (see winner id), tie or unknown. |
#'  |streak_team_id |integer |Team id holding the current series winning streak. |
#'  |streak_wins |integer |Length of that winning streak, in consecutive meetings won. |
#'
#' **series_meetings** - one row per recent meeting of the two teams:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |game_id |integer |Game id of the meeting. |
#'  |season |integer |Season of the meeting. |
#'  |start_date |character |Start date-time of the meeting (ISO 8601, UTC). |
#'  |home_team_id |integer |Home team id in the meeting. |
#'  |home_team |character |Home team name in the meeting. |
#'  |away_team_id |integer |Away team id in the meeting. |
#'  |away_team |character |Away team name in the meeting. |
#'  |neutral_site |logical |TRUE if the meeting was at a neutral site. |
#'  |home_points |integer |Home team points; NA when unknown. |
#'  |away_points |integer |Away team points; NA when unknown. |
#'  |winner_team_id |integer |Winning team id; NA for a tie or unknown result. |
#'  |result |character |Result of the meeting: win (see `winner_team_id`), tie or unknown. |
#'  |venue_id |integer |Venue id. |
#'  |venue_name |character |Venue name. |
#'  |venue_city |character |Venue city. |
#'  |venue_state |character |Venue state abbreviation. |
#'
#' @keywords Game Preview
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string
#' @importFrom glue glue
#' @importFrom dplyr rename any_of
#' @family CFBD Games
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_game_preview(game_id = 401114233))
#' }
cfbd_game_preview <- function(game_id, proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_id(game_id)

  # Query API ----
  full_url <- paste0("https://api.collegefootballdata.com/games/", game_id, "/preview")

  df <- list()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url, proxy = proxy)
      check_status(res)

      parsed <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      analysis <- parsed$analysis
      sides <- Filter(Negate(is.null), list(home = analysis$home, away = analysis$away))
      series <- analysis$series$data

      df <- list(
        game = .cfbd_section_tbl(c(
          parsed$game,
          list(
            availability = parsed$availability,
            reason = parsed$reason,
            assembledAt = parsed$assembledAt
          )
        )) |>
          dplyr::rename(dplyr::any_of(c("game_id" = "id"))),
        broadcasts = .cfbd_section_tbl(analysis$broadcasts$data),
        odds = .cfbd_section_tbl(analysis$odds$data),
        teams = .cfbd_bind_sides(lapply(sides, function(s) {
          # ratings.data goes through the same padding/typing as the overview's
          # ratings section, so ratings_data_* is a fixed, typed column set
          # whether or not CFBD has every system for that team.
          rest <- s[setdiff(names(s), c("keyPlayers", "recentResults", "ratings"))]
          ratings_meta <- s$ratings[setdiff(names(s$ratings), "data")]
          base <- .cfbd_section_tbl(c(rest, list(ratings = ratings_meta)))
          rt <- .cfbd_ratings_tbl(s$ratings$data)
          if (ncol(rt)) names(rt) <- paste0("ratings_data_", names(rt))
          dplyr::bind_cols(base, rt)
        })),
        key_players = .cfbd_bind_sides(lapply(sides, function(s) {
          kp <- s$keyPlayers
          .cfbd_section_tbl(list(
            passing = kp$passing$data,
            rushing = kp$rushing$data,
            receiving = kp$receiving$data
          ))
        })),
        recent_results = .cfbd_bind_sides(lapply(sides, function(s) {
          .cfbd_section_tbl(s$recentResults$data)
        })),
        series = .cfbd_section_tbl(series[setdiff(names(series), "recentMeetings")]),
        series_meetings = .cfbd_section_tbl(series$recentMeetings)
      )

      df <- lapply(df, make_cfbfastR_data,
                   type = "Game preview data from CollegeFootballData.com",
                   timestamp = Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game preview data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get an adjusted-metrics pregame preview for a game**
#' @description
#' **Returns stored adjusted team and player metrics until game completion.**
#' Requires a CFBD Patreon Tier 1 key; other keys receive an error and an empty
#' list. Team metrics may use the previous season; players remain current-season.
#' @param game_id (*Integer* required): Game ID filter for querying a single game.
#' Can be found using the [cfbd_game_info()] or [cfbd_game_schedule()] functions.
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables.
#' @return A named list of data frames: `game`, `team_metrics`, `passing`,
#' `rushing`, `kicking`. A section CFBD did not fill is a 0-column tibble: once
#' `availability` is `metadata_only` (for example a completed game) every section
#' except `game` is empty. Nested objects are flattened into prefixed columns, and
#' a nested object CFBD sends as null (`venue`, `playoff`, a metrics block) becomes one all-NA
#' column named after it instead of its prefixed columns. An empty list is
#' returned if the request fails, including for a key without CFBD Patreon Tier 1.
#'
#' **game** - one row, the same columns as the `game` section of [cfbd_game_preview()]:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |game_id |integer |Unique CFBD game identifier. |
#'  |season |integer |Season of the game. |
#'  |week |integer |Game week (postseason games restart at week 1). |
#'  |season_type |character |Season type of the game (e.g. regular, postseason). |
#'  |status |character |Game status: scheduled, in_progress or completed. |
#'  |status_checked_at |character |When CFBD last checked the game status (ISO 8601, UTC). |
#'  |start_date |character |Game start date-time (ISO 8601, UTC). |
#'  |start_time_tbd |logical |TRUE if the start time is still to be determined. |
#'  |neutral_site |logical |TRUE if the game is at a neutral site. |
#'  |conference_game |logical |TRUE if the game is a conference game. |
#'  |home_team_id |integer |Home team id. |
#'  |home_team_name |character |Home team name. |
#'  |home_team_conference |character |Home team conference. |
#'  |home_team_conference_abbreviation |character |Home team conference abbreviation. |
#'  |home_team_classification |character |Home team division classification: fbs, fcs, ii, ii/iii or iii. |
#'  |home_team_points |integer |Home team points; NA until the game has a score. |
#'  |away_team_id |integer |Away team id. |
#'  |away_team_name |character |Away team name. |
#'  |away_team_conference |character |Away team conference. |
#'  |away_team_conference_abbreviation |character |Away team conference abbreviation. |
#'  |away_team_classification |character |Away team division classification: fbs, fcs, ii, ii/iii or iii. |
#'  |away_team_points |integer |Away team points; NA until the game has a score. |
#'  |venue_id |integer |Venue id. |
#'  |venue_name |character |Venue name. |
#'  |venue_city |character |Venue city. |
#'  |venue_state |character |Venue state abbreviation. |
#'  |playoff |logical |All-NA placeholder, present only when the game is not a College Football Playoff game (the eight `playoff_*` columns replace it for CFP games). |
#'  |playoff_competition |character |Playoff competition (cfp); present only for CFP games. |
#'  |playoff_format |character |Playoff format (e.g. twelve_team_2025); present only for CFP games. |
#'  |playoff_round |character |Playoff round: first_round, quarterfinal, semifinal or championship; present only for CFP games. |
#'  |playoff_round_name |character |Display name of the round (e.g. Quarterfinal); present only for CFP games. |
#'  |playoff_bracket_slot |character |Bracket slot code (e.g. FR4, QF1); present only for CFP games. |
#'  |playoff_home_seed |integer |Home team playoff seed; present only for CFP games. |
#'  |playoff_away_seed |integer |Away team playoff seed; present only for CFP games. |
#'  |playoff_bowl_name |character |Name of the bowl hosting the game (e.g. Rose Bowl), NA when none; present only for CFP games. |
#'  |availability |character |pregame (analysis sections filled) or metadata_only (only `game` is filled). |
#'  |reason |character |Why analysis is not available: game_started, game_completed, kickoff_reached or kickoff_unknown; NA when `availability` is pregame. |
#'  |assembled_at |character |When CFBD assembled the preview (ISO 8601, UTC). |
#'
#' **team_metrics** - one row per side (home, away):
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |side |character |home or away: which team of this game the row describes. |
#'  |team_id |integer |Team id. |
#'  |season |integer |Season of the game. |
#'  |metrics_status |character |Status of the team metrics section: available, no_data or unavailable. |
#'  |metrics_reason |character |Why the team metrics section has no data: no_data, no_results_yet, source_error or invalid_data; NA when available. |
#'  |metrics_assembled_at |character |When CFBD assembled the team metrics section (ISO 8601, UTC). |
#'  |metrics_source_updated_at |character |Publication time of the team metrics snapshot (ISO 8601, UTC); NA when CFBD reports none. |
#'  |metrics_data_season |integer |Season the adjusted team metrics come from. |
#'  |metrics_data_is_previous_season |logical |TRUE when the metrics come from the season before the game season. |
#'  |metrics_data_metrics_year |integer |Four-digit season year of the metrics (e.g. 2026). |
#'  |metrics_data_metrics_team_id |integer |CFBD internal team identifier. |
#'  |metrics_data_metrics_team |character |Full team name (e.g. "Alabama"). |
#'  |metrics_data_metrics_conference |character |Team conference name (e.g. "SEC"). |
#'  |metrics_data_metrics_epa_total |double |Opponent-adjusted total offensive EPA per play (predicted points added). |
#'  |metrics_data_metrics_epa_passing |double |Opponent-adjusted offensive passing EPA per play. |
#'  |metrics_data_metrics_epa_rushing |double |Opponent-adjusted offensive rushing EPA per play. |
#'  |metrics_data_metrics_epa_allowed_total |double |Opponent-adjusted total defensive EPA per play allowed. |
#'  |metrics_data_metrics_epa_allowed_passing |double |Opponent-adjusted defensive passing EPA per play allowed. |
#'  |metrics_data_metrics_epa_allowed_rushing |double |Opponent-adjusted defensive rushing EPA per play allowed. |
#'  |metrics_data_metrics_success_rate_total |double |Opponent-adjusted offensive success rate across all plays (proportion 0-1). |
#'  |metrics_data_metrics_success_rate_standard_downs |double |Opponent-adjusted offensive success rate on standard downs (proportion 0-1). |
#'  |metrics_data_metrics_success_rate_passing_downs |double |Opponent-adjusted offensive success rate on passing downs (proportion 0-1). |
#'  |metrics_data_metrics_success_rate_allowed_total |double |Opponent-adjusted defensive success rate allowed across all plays (proportion 0-1). |
#'  |metrics_data_metrics_success_rate_allowed_standard_downs |double |Opponent-adjusted defensive success rate allowed on standard downs (proportion 0-1). |
#'  |metrics_data_metrics_success_rate_allowed_passing_downs |double |Opponent-adjusted defensive success rate allowed on passing downs (proportion 0-1). |
#'  |metrics_data_metrics_rushing_line_yards |double |Opponent-adjusted offensive line yards per rush (Football Outsiders methodology). |
#'  |metrics_data_metrics_rushing_second_level_yards |double |Opponent-adjusted offensive second-level yards per rush (5-10 yards past line of scrimmage). |
#'  |metrics_data_metrics_rushing_open_field_yards |double |Opponent-adjusted offensive open-field yards per rush (10+ yards past line of scrimmage). |
#'  |metrics_data_metrics_rushing_highlight_yards |double |Opponent-adjusted offensive highlight yards per opportunity rush. |
#'  |metrics_data_metrics_rushing_allowed_line_yards |double |Opponent-adjusted defensive line yards per rush allowed. |
#'  |metrics_data_metrics_rushing_allowed_second_level_yards |double |Opponent-adjusted defensive second-level yards per rush allowed. |
#'  |metrics_data_metrics_rushing_allowed_open_field_yards |double |Opponent-adjusted defensive open-field yards per rush allowed. |
#'  |metrics_data_metrics_rushing_allowed_highlight_yards |double |Opponent-adjusted defensive highlight yards per opportunity rush allowed. |
#'  |metrics_data_metrics_explosiveness |double |Opponent-adjusted offensive explosiveness (higher = more big plays). |
#'  |metrics_data_metrics_explosiveness_allowed |double |Opponent-adjusted defensive explosiveness allowed. |
#'
#' **passing** - one row per passing player listed for each side:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |side |character |home or away. |
#'  |year |integer |Four-digit season year of the player metrics (e.g. 2026). |
#'  |athlete_id |character |CFBD athlete identifier (use with [cfbd_player_info()]). |
#'  |athlete_name |character |Player full name. |
#'  |team |character |Full team name (e.g. "Alabama"). |
#'  |conference |character |Team conference name (e.g. "SEC"). |
#'  |position |character |Player position abbreviation (e.g. "QB", "RB"). |
#'  |wepa |double |Opponent-adjusted weighted EPA (WEPA) per passing play. |
#'  |plays |integer |Total qualifying passing plays included in the WEPA calculation. |
#'
#' **rushing** - one row per rushing player listed for each side:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |side |character |home or away. |
#'  |year |integer |Four-digit season year of the player metrics (e.g. 2026). |
#'  |athlete_id |character |CFBD athlete identifier (use with [cfbd_player_info()]). |
#'  |athlete_name |character |Player full name. |
#'  |team |character |Full team name (e.g. "Alabama"). |
#'  |conference |character |Team conference name (e.g. "SEC"). |
#'  |position |character |Player position abbreviation (e.g. "QB", "RB"). |
#'  |wepa |double |Opponent-adjusted weighted EPA (WEPA) per rushing play. |
#'  |plays |integer |Total qualifying rushing plays included in the WEPA calculation. |
#'
#' **kicking** - one row per kicker listed for each side:
#'
#'  |col_name |type |description |
#'  |:--------|:----|:-----------|
#'  |side |character |home or away. |
#'  |year |integer |Four-digit season year of the kicker metrics (e.g. 2026). |
#'  |athlete_id |character |CFBD athlete identifier (use with [cfbd_player_info()]). |
#'  |athlete_name |character |Kicker full name. |
#'  |team |character |Full team name (e.g. "Alabama"). |
#'  |conference |character |Team conference name (e.g. "SEC"). |
#'  |paar |double |Points Added Above Replacement on field goal attempts (kicker value vs baseline). |
#'  |attempts |integer |Total field goal attempts included in the PAAR calculation. |
#'
#' @keywords Game Preview
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string
#' @importFrom glue glue
#' @importFrom dplyr rename any_of
#' @family CFBD Games
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_game_preview_adjusted(game_id = 401114233))
#' }
cfbd_game_preview_adjusted <- function(game_id, proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_id(game_id)

  # Query API ----
  full_url <- paste0("https://api.collegefootballdata.com/games/", game_id, "/preview/adjusted")

  df <- list()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url, proxy = proxy)
      check_status(res)

      parsed <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      sides <- Filter(Negate(is.null), list(home = parsed$analysis$home, away = parsed$analysis$away))
      player_section <- function(name) {
        .cfbd_bind_sides(lapply(sides, function(s) .cfbd_section_tbl(s[[name]]$data)))
      }

      df <- list(
        game = .cfbd_section_tbl(c(
          parsed$game,
          list(
            availability = parsed$availability,
            reason = parsed$reason,
            assembledAt = parsed$assembledAt
          )
        )) |>
          dplyr::rename(dplyr::any_of(c("game_id" = "id"))),
        team_metrics = .cfbd_bind_sides(lapply(sides, function(s) {
          .cfbd_section_tbl(c(s[c("teamId", "season")], list(metrics = s$teamMetrics)))
        })),
        passing = player_section("passing"),
        rushing = player_section("rushing"),
        kicking = player_section("kicking")
      )

      df <- lapply(df, make_cfbfastR_data,
                   type = "Adjusted game preview data from CollegeFootballData.com",
                   timestamp = Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no adjusted game preview data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
