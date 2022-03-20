#' @name cfbd_games
#' @aliases cfbd_games
#' @title
#' **CFBD Games Endpoint Overview**
#' @description Get results, statistics and information for games\cr
#' \describe{
#'   \item{`cfbd_game_box_advanced()`:}{ Get game advanced box score information.}
#'   \item{`cfbd_game_player_stats()`:}{ Get results information from games.}
#'   \item{`cfbd_game_team_stats()`:}{ Get team statistics by game.}
#'   \item{`cfbd_game_info()`:}{ Get results information from games.}
#'   \item{`cfbd_game_weather()`:}{ Get weather from games.}
#'   \item{`cfbd_game_records()`:}{ Get team records by year.}
#'   \item{`cfbd_calendar()`:}{ Get calendar of weeks by season.}
#'   \item{`cfbd_game_media()`:}{ Get game media information (TV, radio, etc).}
#' }
#' @details
#'
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

#' @title
#' **Get results information from games.**
#' @param year (*Integer* required): Year, 4 digit format(*YYYY*)
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* default regular): Select Season Type: regular, postseason, or both
#' @param team (*String* optional): D-I Team
#' @param home_team (*String* optional): Home D-I Team
#' @param away_team (*String* optional): Away D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param game_id (*Integer* optional): Game ID filter for querying a single game
#' @param quarter_scores (*Logical* default FALSE): This is a parameter to return the
#' list columns that give the score at each quarter: `home_line_scores` and `away_line_scores`.\cr
#' I have defaulted the parameter to false so that you will not have to go to the trouble of dropping it.
#'
#' @return [cfbd_game_info()] - A data frame with 22 variables:
#' \describe{
#'   \item{`game_id`: integer.}{Referencing game id.}
#'   \item{`season`: integer.}{Season of the game.}
#'   \item{`week`: integer.}{Game week.}
#'   \item{`season_type`: character.}{Season type of the game.}
#'   \item{`start_date`: character.}{Game date.}
#'   \item{`start_time_tbd`: logical.}{TRUE/FALSE flag for if the game's start time is to be determined.}
#'   \item{`neutral_site`: logical.}{TRUE/FALSE flag for the game taking place at a neutral site.}
#'   \item{`conference_game`: logical.}{TRUE/FALSE flag for this game qualifying as a conference game.}
#'   \item{`attendance`: integer.}{Reported attendance at the game.}
#'   \item{`venue_id`: integer.}{Referencing venue id.}
#'   \item{`venue`: character.}{Venue name.}
#'   \item{`home_id`: integer.}{Home team referencing id.}
#'   \item{`home_team`: character.}{Home team name.}
#'   \item{`home_conference`: character.}{Home team conference.}
#'   \item{`home_points`: integer.}{Home team points.}
#'   \item{`home_post_win_prob`: character.}{Home team post-game win probability.}
#'   \item{`home_pregame_elo`: character.}{Home team pre-game ELO rating.}
#'   \item{`home_postgame_elo`: character.}{Home team post-game ELO rating.}
#'   \item{`away_id`: integer.}{Away team referencing id.}
#'   \item{`away_team`: character.}{Away team name.}
#'   \item{`away_conference`: character.}{Away team conference.}
#'   \item{`away_points`: integer.}{Away team points.}
#'   \item{`away_post_win_prob`: character.}{Away team post-game win probability.}
#'   \item{`away_pregame_elo`: character.}{Away team pre-game ELO rating.}
#'   \item{`away_postgame_elo`: character.}{Away team post-game ELO rating.}
#'   \item{`excitement_index`: character.}{Game excitement index.}
#'   \item{`highlights`: character.}{Game highlight urls.}
#'   \item{`notes`: character.}{Game notes.}
#' }
#' @keywords Game Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   cfbd_game_info(2018, week = 1)
#'
#'   cfbd_game_info(2018, week = 7, conference = "Ind")
#'
#'   # 7 OTs LSU @ TAMU
#'   cfbd_game_info(2018, week = 13, team = "Texas A&M", quarter_scores = TRUE)
#' }

cfbd_game_info <- function(year,
                           week = NULL,
                           season_type = "regular",
                           team = NULL,
                           home_team = NULL,
                           away_team = NULL,
                           conference = NULL,
                           game_id = NULL,
                           quarter_scores = FALSE) {
  # Check if year is numeric
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  if (!is.null(week) && !is.numeric(week) && nchar(week) > 2) {
    # Check if week is numeric, if not NULL
    cli::cli_abort("Enter valid week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }

  if (!(season_type %in% c("postseason", "both","regular"))) {
    # Check if season_type is appropriate, if not NULL
    cli::cli_abort("Enter valid season_type (String): regular, postseason, or both")
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(home_team)) {
    if (home_team == "San Jose State") {
      home_team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode home_team parameter for URL if not NULL
      home_team <- utils::URLencode(home_team, reserved = TRUE)
    }
  }
  if (!is.null(away_team)) {
    if (away_team == "San Jose State") {
      away_team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      away_team <- utils::URLencode(away_team, reserved = TRUE)
    }
  }
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  if (!is.null(game_id) && !is.numeric(game_id)) {
    # Check if game_id is numeric, if not NULL
    cli::cli_abort("Enter valid game_id (numeric value)")
  }

  base_url <- "https://api.collegefootballdata.com/games?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&seasonType=", season_type,
    "&team=", team,
    "&home=", home_team,
    "&away=", away_team,
    "&conference=", conference,
    "&id=", game_id
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()

      if (!quarter_scores) {
        df <- dplyr::select(df, -.data$home_line_scores, -.data$away_line_scores) %>%
          dplyr::rename(game_id = .data$id) %>%
          as.data.frame()
      } else {
        df <- df %>%
          tidyr::unnest_wider(.data$home_line_scores, names_sep = "_Q") %>%
          tidyr::unnest_wider(.data$away_line_scores, names_sep = "_Q")

        colnames(df) <- gsub("_line_scores", "_scores", colnames(df))
        df <- df %>%
          dplyr::rename(game_id = .data$id)

        df <- df %>%
          make_cfbfastR_data("game information from CollegeFootballData.com",Sys.time())
      }
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no game info data available!"))
    },
    warning = function(w) {
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
#' @param season_type (*String* default regular): Select Season Type: regular, postseason, or both
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#'
#' @return [cfbd_game_weather()] - A data frame with 23 variables:
#' \describe{
#'   \item{`game_id`: integer.}{Referencing game id.}
#'   \item{`season`: integer.}{Season of the game.}
#'   \item{`week`: integer.}{Game week.}
#'   \item{`season_type`: character.}{Season type of the game.}
#'   \item{`start_date`: character.}{Game date.}
#'   \item{`start_time_tbd`: logical.}{TRUE/FALSE flag for if the game's start time is to be determined.}
#'   \item{`game_indoors`: logical.}{TRUE/FALSE flag for if the game is indoors}
#'   \item{`home_team`: character.}{Home team name.}
#'   \item{`home_conference`: character.}{Home team conference.}
#'   \item{`away_team`: character.}{Away team name.}
#'   \item{`away_conference`: character.}{Away team conference.}
#'   \item{`venue_id`: integer.}{Referencing venue id.}
#'   \item{`venue`: character.}{Venue name.}
#'   \item{`temperature`: integer.}{Temperature.}
#'   \item{`dew_point`: integer.}{Dew Point.}
#'   \item{`humidity`: integer.}{Humidity.}
#'   \item{`precipitation`: integer.}{Precipitation.}
#'   \item{`snowfall`: integer.}{Snowfall.}
#'   \item{`wind_direction`: integer.}{Wind direction.}
#'   \item{`wind_speed`: integer.}{Wind Speed.}
#'   \item{`pressure`: integer.}{Pressure.}
#'   \item{`weather_condition_code`: integer.}{Weather condition code.}
#'   \item{`weather_condition`: character.}{Weather condition.}
#' }
#' @keywords Game Weather
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
cfbd_game_weather <- function(year,
                              week = NULL,
                              season_type = "regular",
                              team = NULL,
                              conference = NULL) {
  if (!is.null(year) && !(is.numeric(year) && nchar(year) == 4)) {
    # Check if year is numeric, if not NULL
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  if (!is.null(week) && !(is.numeric(week) && nchar(week) <= 2)) {
    # Check if week is numeric, if not NULL
    cli::cli_abort("Enter valid week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (season_type != "regular" && season_type != "postseason") {
    # Check if season_type is appropriate, if not regular
    cli::cli_abort("Enter valid season_type: regular or postseason")
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(conference)) {
    # Check conference parameter in conference abbreviations, if not NULL
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  base_url <- "https://api.collegefootballdata.com/games/weather?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&seasonType=", season_type,
    "&team=", team,
    "&conference=", conference
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        janitor::clean_names()

      df <- df %>%
        dplyr::rename(game_id = .data$id)


      df <- df %>%
        make_cfbfastR_data("game weather data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no game weather data available!"))
    },
    warning = function(w) {
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
#' \describe{
#'   \item{`season`: character.}{Calendar season.}
#'   \item{`week`: integer.}{Calendar game week.}
#'   \item{`season_type`: character}{Season type of calendar week.}
#'   \item{`first_game_start`: character.}{First game start time of the calendar week.}
#'   \item{`last_game_start`: character.}{Last game start time of the calendar week.}
#' }
#' @importFrom dplyr rename mutate
#' @importFrom janitor clean_names
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#'   cfbd_calendar(2019)
#' }

cfbd_calendar <- function(year) {

  # Check if year is numeric
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }

  base_url <- "https://api.collegefootballdata.com/calendar?"

  full_url <- paste0(
    base_url,
    "year=", year
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)

  df <- data.frame()

  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        janitor::clean_names()


      df <- df %>%
        make_cfbfastR_data("calendar data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}:Invalid arguments or no calendar data available!"))
    },
    warning = function(w) {
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
#' @param season_type (*String* default both): Select Season Type, regular, postseason, or both
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param media_type (*String* optional): Media type filter: tv, radio, web, ppv, or mobile
#'
#' @return [cfbd_game_media()] - A data frame with 13 variables:
#' \describe{
#'   \item{`game_id`: integer.}{Referencing game id.}
#'   \item{`season`: integer.}{Season of the game.}
#'   \item{`week`: integer.}{Game week.}
#'   \item{`season_type`: character.}{Season type of the game.}
#'   \item{`start_time`: character.}{Game start time.}
#'   \item{`is_start_time_tbd`: logical.}{TRUE/FALSE flag for if the start time is still to be determined.}
#'   \item{`home_team`: character.}{Home team of the game.}
#'   \item{`home_conference`: character.}{Conference of the home team.}
#'   \item{`away_team`: character.}{Away team of the game.}
#'   \item{`away_conference`: character.}{Conference of the away team.}
#'   \item{`tv`: list.}{TV broadcast networks.}
#'   \item{`radio`: logical.}{Radio broadcast networks.}
#'   \item{`web`: list.}{Web viewing platforms carrying the game.}
#' }
#' @keywords Game Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom dplyr rename select
#' @importFrom tidyr everything pivot_wider
#' @export
#' @examples
#' \donttest{
#'   cfbd_game_media(2019, week = 4, conference = "ACC")
#' }
cfbd_game_media <- function(year,
                            week = NULL,
                            season_type = "both",
                            team = NULL,
                            conference = NULL,
                            media_type = NULL) {


  # Check if year is numeric
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  if (!is.null(week) && !is.numeric(week) && nchar(week) > 2) {
    # Check if week is numeric, if not NULL
    cli::cli_abort("Enter valid week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (!(season_type %in% c("postseason", "both","regular"))) {
    # Check if season_type is appropriate, if not NULL
    cli::cli_abort("Enter valid season_type (String): regular, postseason, or both")
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(conference)) {
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }

  base_url <- "https://api.collegefootballdata.com/games/media?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&seasonType=", season_type,
    "&team=", team,
    "&conference=", conference,
    "&mediaType=", media_type
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)

  cols <- c(
    "game_id", "season", "week", "season_type", "start_time",
    "is_start_time_tbd", "home_team", "home_conference", "away_team",
    "away_conference", "tv", "radio", "web"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        tidyr::pivot_wider(
          names_from = .data$mediaType,
          values_from = .data$outlet,
          values_fn = list
        ) %>%
        janitor::clean_names() %>%
        dplyr::rename(game_id = .data$id)

      df[cols[!(cols %in% colnames(df))]] <- NA
      df <- df[!duplicated(df), ]

      df <- df %>%
        dplyr::select(cols, tidyr::everything())


      df <- df %>%
        make_cfbfastR_data("game media data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no game media data available!"))
    },
    warning = function(w) {
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
#' \describe{
#'   \item{`team`: character.}{Team name.}
#'   \item{`plays`: double.}{Number of plays.}
#'   \item{`ppa_overall_total`: double.}{Predicted points added (PPA) overall total.}
#'   \item{`ppa_overall_quarter1`: double.}{Predicted points added (PPA) overall Q1.}
#'   \item{`ppa_overall_quarter2`: double.}{Predicted points added (PPA) overall Q2.}
#'   \item{`ppa_overall_quarter3`: double.}{Predicted points added (PPA) overall Q3.}
#'   \item{`ppa_overall_quarter4`: double.}{Predicted points added (PPA) overall Q4.}
#'   \item{`ppa_passing_total`: double.}{Passing predicted points added (PPA) total.}
#'   \item{`ppa_passing_quarter1`: double.}{Passing predicted points added (PPA) Q1.}
#'   \item{`ppa_passing_quarter2`: double.}{Passing predicted points added (PPA) Q2.}
#'   \item{`ppa_passing_quarter3`: double.}{Passing predicted points added (PPA) Q3.}
#'   \item{`ppa_passing_quarter4`: double.}{Passing predicted points added (PPA) Q4.}
#'   \item{`ppa_rushing_total`: double.}{Rushing predicted points added (PPA) total.}
#'   \item{`ppa_rushing_quarter1`: double.}{Rushing predicted points added (PPA) Q1.}
#'   \item{`ppa_rushing_quarter2`: double.}{Rushing predicted points added (PPA) Q2.}
#'   \item{`ppa_rushing_quarter3`: double.}{Rushing predicted points added (PPA) Q3.}
#'   \item{`ppa_rushing_quarter4`: double.}{Rushing predicted points added (PPA) Q4.}
#'   \item{`cumulative_ppa_plays`: double.}{Cumulative predicted points added (PPA) added total.}
#'   \item{`cumulative_ppa_overall_total`: double.}{Cumulative predicted points added (PPA) total.}
#'   \item{`cumulative_ppa_overall_quarter1`: double.}{Cumulative predicted points added (PPA) Q1.}
#'   \item{`cumulative_ppa_overall_quarter2`: double.}{Cumulative predicted points added (PPA) Q2.}
#'   \item{`cumulative_ppa_overall_quarter3`: double.}{Cumulative predicted points added (PPA) Q3.}
#'   \item{`cumulative_ppa_overall_quarter4`: double.}{Cumulative predicted points added (PPA) Q4.}
#'   \item{`cumulative_ppa_passing_total`: double.}{Cumulative passing predicted points added (PPA) total.}
#'   \item{`cumulative_ppa_passing_quarter1`: double.}{Cumulative passing predicted points added (PPA) Q1.}
#'   \item{`cumulative_ppa_passing_quarter2`: double.}{Cumulative passing predicted points added (PPA) Q2.}
#'   \item{`cumulative_ppa_passing_quarter3`: double.}{Cumulative passing predicted points added (PPA) Q3.}
#'   \item{`cumulative_ppa_passing_quarter4`: double.}{Cumulative passing predicted points added (PPA) Q4.}
#'   \item{`cumulative_ppa_rushing_total`: double.}{Cumulative rushing predicted points added (PPA) total.}
#'   \item{`cumulative_ppa_rushing_quarter1`: double.}{Cumulative rushing predicted points added (PPA) Q1.}
#'   \item{`cumulative_ppa_rushing_quarter2`: double.}{Cumulative rushing predicted points added (PPA) Q2.}
#'   \item{`cumulative_ppa_rushing_quarter3`: double.}{Cumulative rushing predicted points added (PPA) Q3.}
#'   \item{`cumulative_ppa_rushing_quarter4`: double.}{Cumulative rushing predicted points added (PPA) Q4.}
#'   \item{`success_rates_overall_total`: double.}{Success rates overall total.}
#'   \item{`success_rates_overall_quarter1`: double.}{Success rates overall Q1.}
#'   \item{`success_rates_overall_quarter2`: double.}{Success rates overall Q2.}
#'   \item{`success_rates_overall_quarter3`: double.}{Success rates overall Q3.}
#'   \item{`success_rates_overall_quarter4`: double.}{Success rates overall Q4.}
#'   \item{`success_rates_standard_downs_total`: double.}{Success rates standard downs total.}
#'   \item{`success_rates_standard_downs_quarter1`: double.}{Success rates standard downs Q1.}
#'   \item{`success_rates_standard_downs_quarter2`: double.}{Success rates standard downs Q2.}
#'   \item{`success_rates_standard_downs_quarter3`: double.}{Success rates standard downs Q3.}
#'   \item{`success_rates_standard_downs_quarter4`: double.}{Success rates standard downs Q4.}
#'   \item{`success_rates_passing_downs_total`: double.}{Success rates passing downs total.}
#'   \item{`success_rates_passing_downs_quarter1`: double.}{Success rates passing downs Q1.}
#'   \item{`success_rates_passing_downs_quarter2`: double.}{Success rates passing downs Q2.}
#'   \item{`success_rates_passing_downs_quarter3`: double.}{Success rates passing downs Q3.}
#'   \item{`success_rates_passing_downs_quarter4`: double.}{Success rates passing downs Q4.}
#'   \item{`explosiveness_overall_total`: double.}{Explosiveness rates overall total.}
#'   \item{`explosiveness_overall_quarter1`: double.}{Explosiveness rates overall Q1.}
#'   \item{`explosiveness_overall_quarter2`: double.}{Explosiveness rates overall Q2.}
#'   \item{`explosiveness_overall_quarter3`: double.}{Explosiveness rates overall Q3.}
#'   \item{`explosiveness_overall_quarter4`: double.}{Explosiveness rates overall Q4.}
#'   \item{`rushing_power_success`: double.}{Rushing power success rate.}
#'   \item{`rushing_stuff_rate`: double.}{Rushing stuff rate.}
#'   \item{`rushing_line_yds`: double.}{Rushing offensive line yards.}
#'   \item{`rushing_line_yds_avg`: double.}{Rushing line yards average.}
#'   \item{`rushing_second_lvl_yds`: double.}{Rushing second-level yards.}
#'   \item{`rushing_second_lvl_yds_avg`: double.}{Average second level yards per rush.}
#'   \item{`rushing_open_field_yds`: double.}{Rushing open field yards.}
#'   \item{`rushing_open_field_yds_avg`: double.}{Average rushing open field yards average.}
#'   \item{`havoc_total`: double.}{Total havoc rate.}
#'   \item{`havoc_front_seven`: double.}{Front-7 players havoc rate.}
#'   \item{`havoc_db`: double.}{Defensive back players havoc rate.}
#'   \item{`scoring_opps_opportunities`: double.}{Number of scoring opportunities.}
#'   \item{`scoring_opps_points`: double.}{Points on scoring opportunity drives.}
#'   \item{`scoring_opps_pts_per_opp`: double.}{Points per scoring opportunity drives.}
#'   \item{`field_pos_avg_start`: double.}{Average starting field position.}
#'   \item{`field_pos_avg_starting_predicted_pts`: double.}{Average starting predicted points (PP) for the average starting field position.}
#' }
#' @keywords Game Advanced Box Score
#' @importFrom tibble enframe
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom stringr str_detect
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @export
#' @examples
#' \donttest{
#'  cfbd_game_box_advanced(game_id = 401114233)
#' }
#'

cfbd_game_box_advanced <- function(game_id, long = FALSE) {
  if (!is.null(game_id) && !is.numeric(game_id)) {
    # Check if game_id is numeric, if not NULL
    cli::cli_abort("Enter valid game_id (numeric value)")
  }

  base_url <- "https://api.collegefootballdata.com/game/box/advanced?"

  full_url <- paste0(
    base_url,
    "gameId=", game_id
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content, tidyr::unnest, and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        furrr::future_map_if(is.data.frame, list) %>%
        furrr::future_map_if(is.data.frame, list)

      df <- tibble::enframe(unlist(df$teams, use.names = TRUE))
      team1 <- seq(1, nrow(df) - 1, by = 2)
      df1 <- df[team1, ] %>%
        dplyr::rename(
          stat = .data$name,
          team1 = .data$value
        )

      team2 <- seq(2, nrow(df), by = 2)
      df2 <- df[team2, ] %>%
        dplyr::rename(team2 = .data$value) %>%
        dplyr::select(.data$team2)

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
        team <- df %>%
          dplyr::filter(.data$stat == "ppa_team") %>%
          tidyr::pivot_longer(cols = c(.data$team1, .data$team2)) %>%
          dplyr::transmute(team = .data$value)

        df <- df %>%
          dplyr::filter(!stringr::str_detect(.data$stat, "team")) %>%
          tidyr::pivot_longer(cols = c(.data$team1, .data$team2)) %>%
          tidyr::pivot_wider(names_from = .data$stat, values_from = .data$value) %>%
          dplyr::select(-.data$name) %>%
          dplyr::mutate_all(as.numeric) %>%
          dplyr::bind_cols(team)  %>%
          dplyr::select(.data$team, tidyr::everything())
        df <- df %>%
          dplyr::rename(
            rushing_line_yds_avg = .data$rushing_line_yd_avg,
            rushing_second_lvl_yds_avg = .data$rushing_second_lvl_yd_avg,
            rushing_open_field_yds_avg = .data$rushing_open_field_yd_avg)

        df <- df %>%
          make_cfbfastR_data("advanced box score data from CollegeFootballData.com",Sys.time())

      }
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: game_id '{game_id}' invalid or no game advanced box score data available!"))
    },
    warning = function(w) {
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
#' @param season_type (*String* default regular): Select Season Type: regular or postseason
#' @param team (*String* optional): D-I Team
#' @param category (*String* optional): Category filter (e.g defensive)\cr
#' Offense: passing, receiving, rushing\cr
#' Defense: defensive, fumbles, interceptions\cr
#' Special Teams: punting, puntReturns, kicking, kickReturns\cr
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param game_id (*Integer* optional): Game ID filter for querying a single game
#' Can be found using the [cfbd_game_info()] function
#'
#' @return [cfbd_game_player_stats()] - A data frame with 32 variables:
#' \describe{
#'   \item{`game_id`: integer.}{Referencing game id.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`conference`: character.}{Conference of the team.}
#'   \item{`home_away`: character.}{Flag for if the team was the home or away team.}
#'   \item{`points`: integer.}{Team points.}
#'   \item{`category`: character.}{Statistic category.}
#'   \item{`athlete_id`: character.}{Athlete referencing id.}
#'   \item{`name`: character.}{Player name.}
#'   \item{`c_att`: character.}{Completions - Pass attempts.}
#'   \item{`yds`: double.}{Statistic yardage.}
#'   \item{`avg`: double.}{Average per statistic.}
#'   \item{`td`: double.}{Touchdowns scored.}
#'   \item{`int`: double.}{Interceptions thrown.}
#'   \item{`qbr`: double.}{Quarterback rating.}
#'   \item{`car`: double.}{Number of rushing carries.}
#'   \item{`long`: double.}{Longest carry/reception of the game.}
#'   \item{`rec`: double.}{Number of pass receptions.}
#'   \item{`no`: double.}{Player number.}
#'   \item{`fg`: character.}{Field goal attempts in the game.}
#'   \item{`pct`: double.}{Field goal percentage in the game.}
#'   \item{`xp`: character.}{Extra points kicked in the game.}
#'   \item{`pts`: double.}{Total kicking points in the game.}
#'   \item{`tb`: double.}{Touchbacks (for kicking) in the game.}
#'   \item{`in_20`: double.}{Punts inside the 20 yardline in the game.}
#'   \item{`fum`: double.}{Player fumbles in the game.}
#'   \item{`lost`: double.}{Player fumbles lost in the game.}
#'   \item{`tot`: double.}{Total tackles in the game.}
#'   \item{`solo`: double.}{Solo tackles in the game.}
#'   \item{`sacks`: double.}{Total sacks in the game.}
#'   \item{`tfl`: double.}{Total tackles for loss in the game.}
#'   \item{`pd`: double.}{Total passes defensed in the game.}
#'   \item{`qb_hur`: double.}{Total quarterback hurries in the game.}
#' }
#' @keywords Game Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @export
#' @examples
#' \donttest{
#'   cfbd_game_player_stats(year = 2020, week = 15, team = "Alabama")
#'
#'   cfbd_game_player_stats(2013, week = 1, team = "Florida State", category = "passing")
#' }

cfbd_game_player_stats <- function(year,
                                   week = NULL,
                                   season_type = "regular",
                                   team = NULL,
                                   conference = NULL,
                                   category = NULL,
                                   game_id = NULL) {

  stat_categories <- c(
    "passing", "receiving", "rushing", "defensive", "fumbles",
    "interceptions", "punting", "puntReturns", "kicking", "kickReturns"
  )

  args <- list(year, week, season_type, team, conference, category, game_id)

  args <- args[lengths(args) != 0]

  # Check if year is numeric
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  if (!is.null(week) && !is.numeric(week) && nchar(week) > 2) {
    # Check if week is numeric, if not NULL
      cli::cli_abort("Enter valid week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }

  if (!(season_type %in% c("postseason", "both","regular"))) {
    # Check if season_type is appropriate, if not NULL
    cli::cli_abort("Enter valid season_type (String): regular, postseason, or both")
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  if (!is.null(category)) {
    if(!(category %in% stat_categories)){
      # Check category parameter in category if not NULL
      cli::cli_abort("Incorrect category, potential misspelling.\nOffense: passing, receiving, rushing\nDefense: defensive, fumbles, interceptions\nSpecial Teams: punting, puntReturns, kicking, kickReturns")
    }
    # Encode conference parameter for URL, if not NULL
    category <- utils::URLencode(category, reserved = TRUE)
  }
  if (!is.null(game_id) && !is.numeric(game_id)) {
    # Check if game_id is numeric, if not NULL
    cli::cli_abort("Enter valid game_id (numeric value)")
  }

  base_url <- "https://api.collegefootballdata.com/games/players?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&seasonType=", season_type,
    "&team=", team,
    "&conference=", conference,
    "&category=", category,
    "&gameId=", game_id
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )


  # Check the result
  check_status(res)

  cols <- c(
    "game_id", "team", "conference", "home_away", "points", "category",
    "athlete_id", "name", "c_att", "yds", "avg", "td", "int", "qbr",
    "car", "long", "rec", "no", "fg", "pct", "xp", "pts", "tb", "in_20",
    "fum", "lost", "tot", "solo", "sacks", "tfl", "pd", "qb_hur"
  )
  numeric_cols <- c(
    "yds", "avg", "td", "int", "qbr",
    "car", "long", "rec", "no", "pct", "pts", "tb", "in_20",
    "fum", "lost", "tot", "solo", "sacks", "tfl", "pd", "qb_hur"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content, tidyr::unnest, and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        furrr::future_map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        dplyr::rename(game_id = .data$id) %>%
        tidyr::unnest(.data$teams) %>%
        furrr::future_map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        tidyr::unnest(.data$categories) %>%
        furrr::future_map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        dplyr::rename(category = .data$name) %>%
        tidyr::unnest(.data$types) %>%
        furrr::future_map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        dplyr::rename(stat_category = .data$name) %>%
        tidyr::unnest(.data$athletes) %>%
        dplyr::rename(
          athlete_id = .data$id,
          team = .data$school,
          value = .data$stat
        ) %>%
        tidyr::pivot_wider(names_from = .data$stat_category, values_from = .data$value, values_fn = list) %>%
        janitor::clean_names()

      df[cols[!(cols %in% colnames(df))]] <- NA

      df <- df %>%
        dplyr::select(cols, dplyr::everything())


      df <- df %>%
        make_cfbfastR_data("game player stats data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no game player stats data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  # is_c_att_present <- any(grepl("C/ATT",colnames(df)))
  # if(is_c_att_present){
  #   df <- df %>%
  #    dplyr::mutate("C/ATT"="0/0")
  # }
  return(df)
}




#' @title
#' **Get team records by year**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*)
#' @param team (*String* optional): Team - Select a valid team, D1 football
#' @param conference (*String* optional): DI Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @return [cfbd_game_records()] - A data frame with 21 variables:
#' \describe{
#'   \item{`year`: integer.}{Season of the games.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`conference`: character.}{Conference of the team.}
#'   \item{`division`: character.}{Division in the conference of the team.}
#'   \item{`expected_wins`: numeric}{Expected number of wins based on post-game win probability.}
#'   \item{`total_games`: integer.}{Total number of games played.}
#'   \item{`total_wins`: integer.}{Total wins.}
#'   \item{`total_losses`: integer.}{Total losses.}
#'   \item{`total_ties`: integer.}{Total ties.}
#'   \item{`conference_games`: integer.}{Number of conference games.}
#'   \item{`conference_wins`: integer.}{Total conference wins.}
#'   \item{`conference_losses`: integer.}{Total conference losses.}
#'   \item{`conference_ties`: integer.}{Total conference ties.}
#'   \item{`home_games`: integer.}{Total home games.}
#'   \item{`home_wins`: integer.}{Total home wins.}
#'   \item{`home_losses`: integer.}{Total home losses.}
#'   \item{`home_ties`: integer.}{Total home ties.}
#'   \item{`away_games`: integer.}{Total away games.}
#'   \item{`away_wins`: integer.}{Total away wins.}
#'   \item{`away_losses`: integer.}{Total away losses.}
#'   \item{`away_ties`: integer.}{Total away ties.}
#' }
#' @keywords Team Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   cfbd_game_records(2018, team = "Notre Dame")
#'
#'   cfbd_game_records(2013, team = "Florida State")
#' }

cfbd_game_records <- function(year,
                              team = NULL,
                              conference = NULL) {


  ## check if year is numeric
  if(!is.numeric(year) && !nchar(year) == 4){
    cli::cli_abort("Enter valid year (Integer): 4 digits (YYYY)")
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(conference)) {
    # Check conference parameter in conference abbreviations, if not NULL
    # # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }

  base_url <- "https://api.collegefootballdata.com/records?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&team=", team,
    "&conference=", conference
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )


  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        dplyr::rename(
          expected_wins = .data$expectedWins,
          total_games = .data$total.games,
          total_wins = .data$total.wins,
          total_losses = .data$total.losses,
          total_ties = .data$total.ties,
          conference_games = .data$conferenceGames.games,
          conference_wins = .data$conferenceGames.wins,
          conference_losses = .data$conferenceGames.losses,
          conference_ties = .data$conferenceGames.ties,
          home_games = .data$homeGames.games,
          home_wins = .data$homeGames.wins,
          home_losses = .data$homeGames.losses,
          home_ties = .data$homeGames.ties,
          away_games = .data$awayGames.games,
          away_wins = .data$awayGames.wins,
          away_losses = .data$awayGames.losses,
          away_ties = .data$awayGames.ties
        )

      df <- df %>%
        make_cfbfastR_data("game records data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no game records data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}



#' @title
#' **Get team statistics by game**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param season_type (*String* default: regular): Select Season Type - regular, postseason, or both
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param game_id (*Integer* optional): Game ID filter for querying a single game\cr
#' Can be found using the [cfbd_game_info()] function
#' @param rows_per_team (*Integer* default 1): Both Teams for each game on one or two row(s), Options: 1 or 2
#'
#' @return [cfbd_game_team_stats()] - A data frame with 78 variables:
#' \describe{
#'   \item{`game_id`: integer.}{Referencing game id.}
#'   \item{`school`: character.}{Team name.}
#'   \item{`conference`: character.}{Conference of the team.}
#'   \item{`home_away`: character.}{Home/Away Flag.}
#'   \item{`opponent`: character.}{Opponent team name.}
#'   \item{`opponent_conference`: character.}{Conference of the opponent team.}
#'   \item{`points`: integer.}{Team points.}
#'   \item{`total_yards`: character.}{Team total yards.}
#'   \item{`net_passing_yards`: character.}{Team net passing yards.}
#'   \item{`completion_attempts`:character.}{Team completion attempts.}
#'   \item{`passing_tds`: character.}{Team passing touchdowns.}
#'   \item{`yards_per_pass`: character.}{Team game yards per pass.}
#'   \item{`passes_intercepted`: character.}{Team passes intercepted.}
#'   \item{`interception_yards`: character.}{Interception yards.}
#'   \item{`interception_tds`: character.}{Interceptions returned for a touchdown.}
#'   \item{`rushing_attempts`: character.}{Team rushing attempts. see also: ESTABLISH IT.}
#'   \item{`rushing_yards`: character.}{Team rushing yards.}
#'   \item{`rush_tds`: character.}{Team rushing touchdowns.}
#'   \item{`yards_per_rush_attempt`: character.}{Team yards per rush attempt.}
#'   \item{`first_downs`: character.}{First downs earned by the team.}
#'   \item{`third_down_eff`: character.}{Third down efficiency.}
#'   \item{`fourth_down_eff`: character.}{Fourth down efficiency.}
#'   \item{`punt_returns`: character.}{Team punt returns.}
#'   \item{`punt_return_yards`: character.}{Team punt return yards.}
#'   \item{`punt_return_tds`: character.}{Team punt return touchdowns.}
#'   \item{`kick_return_yards`: character.}{Team kick return yards.}
#'   \item{`kick_return_tds`: character.}{Team kick return touchdowns.}
#'   \item{`kick_returns`: character.}{Team kick returns.}
#'   \item{`kicking_points`: character.}{Team points from kicking the ball.}
#'   \item{`fumbles_recovered`: character.}{Team fumbles recovered.}
#'   \item{`fumbles_lost`: character.}{Team fumbles lost.}
#'   \item{`total_fumbles`: character.}{Team total fumbles.}
#'   \item{`tackles`: character.}{Team tackles.}
#'   \item{`tackles_for_loss`: character.}{Team tackles for a loss.}
#'   \item{`sacks`: character.}{Team sacks.}
#'   \item{`qb_hurries`: character.}{Team QB hurries.}
#'   \item{`interceptions`: character.}{Team interceptions.}
#'   \item{`passes_deflected`: character.}{Team passes deflected.}
#'   \item{`turnovers`: character.}{Team turnovers.}
#'   \item{`defensive_tds`: character.}{Team defensive touchdowns.}
#'   \item{`total_penalties_yards`: character.}{Team total penalty yards.}
#'   \item{`possession_time`: character.}{Team time of possession.}
#'   \item{`points_allowed`: integer.}{Points for the opponent.}
#'   \item{`total_yards_allowed`: character.}{Opponent total yards.}
#'   \item{`net_passing_yards_allowed`: character.}{Opponent net passing yards.}
#'   \item{`completion_attempts_allowed`: character.}{Oppponent completion attempts.}
#'   \item{`passing_tds_allowed`: character.}{Opponent passing TDs.}
#'   \item{`yards_per_pass_allowed`: character.}{Opponent yards per pass allowed.}
#'   \item{`passes_intercepted_allowed`: character.}{Opponent passes intercepted.}
#'   \item{`interception_yards_allowed`: character.}{Opponent interception yards.}
#'   \item{`interception_tds_allowed`: character.}{Opponent interception TDs.}
#'   \item{`rushing_attempts_allowed`: character.}{Opponent rushing attempts.}
#'   \item{`rushing_yards_allowed`: character.}{Opponent rushing yards.}
#'   \item{`rush_tds_allowed`: character.}{Opponent rushing touchdowns.}
#'   \item{`yards_per_rush_attempt_allowed`: character.}{Opponent rushing yards per attempt.}
#'   \item{`first_downs_allowed`: character.}{Opponent first downs.}
#'   \item{`third_down_eff_allowed`: character.}{Opponent third down efficiency.}
#'   \item{`fourth_down_eff_allowed`: character.}{Opponent fourth down efficiency.}
#'   \item{`punt_returns_allowed`: character.}{Opponent punt returns.}
#'   \item{`punt_return_yards_allowed`: character.}{Opponent punt return yards.}
#'   \item{`punt_return_tds_allowed`: character.}{Opponent punt return touchdowns.}
#'   \item{`kick_return_yards_allowed`: character.}{Opponent kick return yards.}
#'   \item{`kick_return_tds_allowed`: character.}{Opponent kick return touchdowns.}
#'   \item{`kick_returns_allowed`: character.}{Opponent kick returns.}
#'   \item{`kicking_points_allowed`: character.}{Opponent points from kicking.}
#'   \item{`fumbles_recovered_allowed`: character.}{Opponent fumbles recovered.}
#'   \item{`fumbles_lost_allowed`: character.}{Opponent fumbles lost.}
#'   \item{`total_fumbles_allowed`:character.}{Opponent total number of fumbles.}
#'   \item{`tackles_allowed`:character.}{Opponent tackles.}
#'   \item{`tackles_for_loss_allowed`: character.}{Opponent tackles for loss.}
#'   \item{`sacks_allowed`: character.}{Opponent sacks.}
#'   \item{`qb_hurries_allowed`: character.}{Opponent quarterback hurries.}
#'   \item{`interceptions_allowed`: character.}{Opponent interceptions.}
#'   \item{`passes_deflected_allowed`: character.}{Opponent passes deflected.}
#'   \item{`turnovers_allowed`: character.}{Opponent turnovers.}
#'   \item{`defensive_tds_allowed`: character.}{Opponent defensive touchdowns.}
#'   \item{`total_penalties_yards_allowed`: character.}{Opponent total penalty yards.}
#'   \item{`possession_time_allowed`: character.}{Opponent time of possession.}
#' }
#' @keywords Team Game Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @export
#' @examples
#' \donttest{
#'   cfbd_game_team_stats(2019, team = "LSU")
#'
#'   cfbd_game_team_stats(2013, team = "Florida State")
#' }

cfbd_game_team_stats <- function(year,
                                 week = NULL,
                                 season_type = "regular",
                                 team = NULL,
                                 conference = NULL,
                                 game_id = NULL,
                                 rows_per_team = 1) {

  # Check if year is numeric
  if(!is.numeric(year) && !nchar(year) == 4){
    cli::cli_abort("Enter valid year (Integer): 4-digit (YYYY)")
  }
  if (!is.null(week) && !is.numeric(week) && !nchar(week) <= 2) {
    # Check if week is numeric, if not NULL
    cli::cli_abort("Enter valid week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (!(season_type %in% c("postseason", "both","regular"))) {
    # Check if season_type is appropriate, if not NULL
    cli::cli_abort("Enter valid season_type (String): regular, postseason, or both")
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  if (!is.null(game_id) && !is.numeric(game_id)) {
    # Check if game_id is numeric, if not NULL

    cli::cli_abort("Enter valid game_id value (Integer)\nCan be found using the `cfbd_game_info()` function")
  }
  if (rows_per_team != 1 && rows_per_team != 2) {
    # Check if rows_per_team is 2, if not 1
    cli::cli_abort("Enter valid rows_per_team value (Integer): 1 or 2")
  }

  base_url <- "https://api.collegefootballdata.com/games/teams?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&seasonType=", season_type,
    "&team=", team,
    "&conference=", conference,
    "&gameId=", game_id
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)


  cols <- c(
    "id", "school", "conference", "home_away",
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
  df <- res %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(flatten = TRUE) %>%
    furrr::future_map_if(is.data.frame, list) %>%
    dplyr::as_tibble()

  if (nrow(df) == 0) {
      warning("Most likely a bye week, the data pulled from the API was empty. Returning nothing
              for this one week or team.")
    return(NULL)
  }
  df <- df %>%
    tidyr::unnest(.data$teams) %>%
    tidyr::unnest(.data$stats)

  # Pivot category columns to get stats for each team game on one row
  df <- tidyr::pivot_wider(df,
    names_from = .data$category,
    values_from = .data$stat
  )
  df <- df %>%
    janitor::clean_names()
  df[cols[!(cols %in% colnames(df))]] <- NA
  df <- df %>%
    dplyr::rename(
      game_id = .data$id,
      rush_tds = .data$rushing_t_ds,
      punt_return_tds = .data$punt_return_t_ds,
      passing_tds = .data$passing_t_ds,
      interception_tds = .data$interception_t_ds,
      defensive_tds = .data$defensive_t_ds,
      kick_return_tds = .data$kick_return_t_ds
    )

  if (rows_per_team == 1) {
    # Join pivoted data with itself to get ultra-wide row
    # containing all game stats on one row for both teams
    df <- df %>%
      dplyr::mutate(opponent_home_away = ifelse(.data$home_away == "home","away","home")) %>%
      dplyr::left_join(df,
        by = c("game_id", "opponent_home_away" = "home_away"),
        suffix = c("", "_allowed")
      ) %>%
      dplyr::rename(opponent = .data$school_allowed,
                    opponent_conference = .data$conference_allowed)

    cols1 <- c(
      "game_id", "school", "conference", "home_away","opponent","opponent_conference",
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

      df <- df %>%
        dplyr::filter(.data$school == team) %>%
        dplyr::select(cols1)


    } else if (!is.null(conference)) {
      confs <- cfbd_conferences()

      conference <- URLdecode(conference)

      conf_name <- confs[confs$abbreviation == conference, ]$name

      df <- df %>%
        dplyr::filter(conference == conf_name) %>%
        dplyr::select(cols1)


    } else {
      df <- df %>%
        dplyr::select(cols1)

    }
  } else {
    cols2 <- c(
      "game_id", "school", "conference", "home_away",
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
      team <- URLdecode(team <- team)

      df <- df %>%
        dplyr::filter(.data$school == team) %>%
        dplyr::select(cols2)

    } else if (!is.null(conference)) {
      confs <- cfbd_conferences()

      conference <- URLdecode(conference)

      conf_name <- confs[confs$abbreviation == conference, ]$name

      df <- df %>%
        dplyr::filter(conference == conf_name) %>%
        dplyr::select(cols2)


    } else {
      df <- df %>%
        dplyr::select(cols2)

    }
  }


  df <- df %>%
    make_cfbfastR_data("team stats data from CollegeFootballData.com",Sys.time())
  return(df)
}
