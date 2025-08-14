#' @name cfbd_games
#' @aliases cfbd_games
#' @title
#' **CFBD Games Endpoint Overview**
#' @description Get results, statistics and information for games
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

#' @title
#' **Get results information from games.**
#' @param year (*Integer* required): Year, 4 digit format(*YYYY*)
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* default regular): Select Season Type: regular, postseason, or both
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
#'   \item{`home_division`: character.}{Home team division.}
#'   \item{`home_points`: integer.}{Home team points.}
#'   \item{`home_post_win_prob`: character.}{Home team post-game win probability.}
#'   \item{`home_pregame_elo`: character.}{Home team pre-game ELO rating.}
#'   \item{`home_postgame_elo`: character.}{Home team post-game ELO rating.}
#'   \item{`away_id`: integer.}{Away team referencing id.}
#'   \item{`away_team`: character.}{Away team name.}
#'   \item{`away_conference`: character.}{Away team conference.}
#'   \item{`away_division`: character.}{Away team division.}
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
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_game_info(2018, week = 7, conference = "Ind"))
#' }

cfbd_game_info <- function(year,
                           week = NULL,
                           season_type = "regular",
                           team = NULL,
                           home_team = NULL,
                           away_team = NULL,
                           conference = NULL,
                           division = 'fbs',
                           game_id = NULL,
                           quarter_scores = FALSE) {

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
    "division" = division,
    "id" = game_id
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        janitor::clean_names()

      if (!quarter_scores) {
        df <- dplyr::select(df, -"home_line_scores", -"away_line_scores") %>%
          dplyr::rename("game_id" = "id") %>%
          as.data.frame()
      } else {
        df <- df %>%
          tidyr::unnest_wider("home_line_scores", names_sep = "_Q") %>%
          tidyr::unnest_wider("away_line_scores", names_sep = "_Q")

        colnames(df) <- gsub("_line_scores", "_scores", colnames(df))
        df <- df %>%
          dplyr::rename("game_id" = "id")
      }
      df <- df %>%
        make_cfbfastR_data("Game information from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game info data available!"))
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
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
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

  # Validation ----
  validate_api_key()
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
    "conference" = conference
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        janitor::clean_names()

      df <- df %>%
        dplyr::rename("game_id" = "id")


      df <- df %>%
        make_cfbfastR_data("Game weather data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no game weather data available!"))
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
#' @importFrom cli cli_abort
#' @importFrom glue glue
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
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        janitor::clean_names() %>% 
        dplyr::select(
          season,
          week,
          season_type,
          first_game_start = start_date,
          last_game_start = end_date
        )


      df <- df %>%
        make_cfbfastR_data("Calendar data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no calendar data available!"))
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
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param media_type (*String* optional): Media type filter: tv, radio, web, ppv, or mobile
#' @param division (*String* optional): Division abbreviation - Select a valid division: fbs/fcs/ii/iii
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
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom dplyr rename select
#' @importFrom tidyr everything pivot_wider
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
  full_url <- httr::modify_url(base_url, query=query_params)

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
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        tidyr::pivot_wider(
          names_from = "mediaType",
          values_from = "outlet",
          values_fn = list
        ) %>%
        janitor::clean_names() %>%
        dplyr::rename("game_id" = "id")

      df[cols[!(cols %in% colnames(df))]] <- NA
      df <- df[!duplicated(df), ]

      df <- df %>%
        dplyr::select(dplyr::all_of(cols), tidyr::everything())


      df <- df %>%
        make_cfbfastR_data("Game media data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game media data available!"))
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
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom stringr str_detect
#' @import dplyr
#' @import tidyr
#' @import purrr
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
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content, tidyr::unnest, and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        purrr::map_if(is.data.frame, list) %>%
        purrr::map_if(is.data.frame, list)

      df <- tibble::enframe(unlist(df$teams, use.names = TRUE))
      team1 <- seq(1, nrow(df) - 1, by = 2)
      df1 <- df[team1, ] %>%
        dplyr::rename(
          "stat" = "name",
          "team1" = "value"
        )

      team2 <- seq(2, nrow(df), by = 2)
      df2 <- df[team2, ] %>%
        dplyr::rename("team2" = "value") %>%
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
        team <- df %>%
          dplyr::filter(.data$stat == "ppa_team") %>%
          tidyr::pivot_longer(cols = c("team1", "team2")) %>%
          dplyr::transmute(team = .data$value)

        df <- df %>%
          dplyr::filter(!stringr::str_detect(.data$stat, "team")) %>%
          tidyr::pivot_longer(cols = c("team1", "team2")) %>%
          tidyr::pivot_wider(names_from = "stat", values_from = "value") %>%
          dplyr::select(-"name") %>%
          dplyr::mutate_all(as.numeric) %>%
          dplyr::bind_cols(team)  %>%
          dplyr::select("team", tidyr::everything())
        df <- df %>%
          dplyr::rename(
            "rushing_line_yds_avg" = "rushing_line_yd_avg",
            "rushing_second_lvl_yds_avg" = "rushing_second_lvl_yd_avg",
            "rushing_open_field_yds_avg" = "rushing_open_field_yd_avg")

        df <- df %>%
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
#' @param season_type (*String* default regular): Select Season Type: regular or postseason
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
#' @return [cfbd_game_player_stats()] - A data frame with 32 variables:
#'
#'   |col_name            |types     |
#'   |:-------------------|:---------|
#'   |game_id             |integer   |
#'   |team                |character |
#'   |conference          |character |
#'   |home_away           |character |
#'   |team_points         |integer   |
#'   |athlete_id          |integer   |
#'   |athlete_name        |character |
#'   |defensive_td        |numeric   |
#'   |defensive_qb_hur    |numeric   |
#'   |defensive_pd        |numeric   |
#'   |defensive_tfl       |numeric   |
#'   |defensive_sacks     |numeric   |
#'   |defensive_solo      |numeric   |
#'   |defensive_tot       |numeric   |
#'   |fumbles_rec         |numeric   |
#'   |fumbles_lost        |numeric   |
#'   |fumbles_fum         |numeric   |
#'   |punting_long        |numeric   |
#'   |punting_in_20       |numeric   |
#'   |punting_tb          |numeric   |
#'   |punting_avg         |numeric   |
#'   |punting_yds         |numeric   |
#'   |punting_no          |numeric   |
#'   |kicking_pts         |numeric   |
#'   |kicking_long        |numeric   |
#'   |kicking_pct         |numeric   |
#'   |punt_returns_td     |numeric   |
#'   |punt_returns_long   |numeric   |
#'   |punt_returns_avg    |numeric   |
#'   |punt_returns_yds    |numeric   |
#'   |punt_returns_no     |numeric   |
#'   |kick_returns_td     |numeric   |
#'   |kick_returns_long   |numeric   |
#'   |kick_returns_avg    |numeric   |
#'   |kick_returns_yds    |numeric   |
#'   |kick_returns_no     |numeric   |
#'   |interceptions_td    |numeric   |
#'   |interceptions_yds   |numeric   |
#'   |interceptions_int   |numeric   |
#'   |receiving_long      |numeric   |
#'   |receiving_td        |numeric   |
#'   |receiving_avg       |numeric   |
#'   |receiving_yds       |numeric   |
#'   |receiving_rec       |numeric   |
#'   |rushing_long        |numeric   |
#'   |rushing_td          |numeric   |
#'   |rushing_avg         |numeric   |
#'   |rushing_yds         |numeric   |
#'   |rushing_car         |numeric   |
#'   |passing_int         |numeric   |
#'   |passing_td          |numeric   |
#'   |passing_avg         |numeric   |
#'   |passing_yds         |numeric   |
#'   |passing_completions |numeric   |
#'   |passing_attempts    |numeric   |
#'   |passing_qbr         |numeric   |
#'   |kicking_xpm         |numeric   |
#'   |kicking_xpa         |numeric   |
#'   |kicking_fgm         |numeric   |
#'   |kicking_fga         |numeric   |
#'
#' @keywords Game Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @import purrr
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
                                   game_id = NULL) {

  stat_categories <- c(
    "passing", "receiving", "rushing", "defensive", "fumbles",
    "interceptions", "punting", "puntReturns", "kicking", "kickReturns"
  )

  args <- list(year, week, season_type, team, conference, category, game_id)

  args <- args[lengths(args) != 0]

  # Validation ----
  validate_api_key()
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
    "gameId" = game_id
  )
  full_url <- httr::modify_url(base_url, query=query_params)

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
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        dplyr::rename("game_id" = "id") %>%
        tidyr::unnest("teams") %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        tidyr::unnest("categories") %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        dplyr::rename("category" = "name") %>%
        tidyr::unnest("types") %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        dplyr::rename("stat_category" = "name") %>%
        dplyr::mutate(
          statType = paste0(.data$category, "_", .data$stat_category)) %>%
        tidyr::unnest("athletes") %>%
        dplyr::rename(
          "athlete_id" = "id",
          "athlete_name" = "name",
          "team_points" = "points",
          "value" = "stat"
        ) %>%
        dplyr::select(-dplyr::any_of(c("category", "stat_category"))) %>%
        dplyr::group_by(.data$game_id, .data$team, .data$conference, .data$athlete_id, .data$athlete_name,
                        .data$homeAway, .data$team_points) %>%
        tidyr::pivot_wider(names_from = "statType", values_from = "value", values_fn = first) %>%
        janitor::clean_names()

      df[cols[!(cols %in% colnames(df))]] <- NA

      suppressWarnings(
        df <- df %>%
          dplyr::select(dplyr::all_of(cols), tidyr::everything()) %>%
          tidyr::separate("passing_c_att",into = c("passing_completions","passing_attempts"), sep = "/") %>%
          tidyr::separate("kicking_xp",into = c("kicking_xpm","kicking_xpa"), sep = "/") %>%
          tidyr::separate("kicking_fg",into = c("kicking_fgm","kicking_fga"), sep = "/") %>%
          dplyr::mutate_at(numeric_cols, as.numeric) %>%
          dplyr::mutate(athlete_id = as.integer(.data$athlete_id)) %>%
          as.data.frame()
      )



      df <- df %>%
        dplyr::select(dplyr::any_of(cols), tidyr::everything()) %>%
        make_cfbfastR_data("Game player stats data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game player stats data available!"))
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
#' @param conference (*String* optional): DI Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @return [cfbd_game_records()] - A data frame with 22 variables:
#' \describe{
#'   \item{`year`: integer.}{Season of the games.}
#'   \item{`team_id`: integer.} {Referencing team id.}
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
#' @importFrom cli cli_abort
#' @import dplyr
#' @import tidyr
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
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
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
          "away_ties" = "awayGames.ties"
        )

      df <- df %>%
        make_cfbfastR_data("Game records data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game records data available!"))
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
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param division (*String* optional): Division abbreviation - Select a valid division: fbs/fcs/ii/iii
#' @param game_id (*Integer* optional): Game ID filter for querying a single game
#' Can be found using the [cfbd_game_info()] function
#' @param rows_per_team (*Integer* default 1): Both Teams for each game on one or two row(s), Options: 1 or 2
#'
#' @return [cfbd_game_team_stats()] - A data frame with 78 variables:
#' \describe{
#'   \item{`game_id`: integer.}{Referencing game id.}
#'   \item{`team`: character.}{Team name.}
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
#'
#' @keywords Team Game Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @import purrr
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
  full_url <- httr::modify_url(base_url, query=query_params)

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
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble()

      if (nrow(df) == 0) {
        warning("Most likely a bye week, the data pulled from the API was empty. Returning nothing
              for this one week or team.")
        return(NULL)
      }
      df <- df %>%
        tidyr::unnest("teams") %>%
        tidyr::unnest("stats") %>%
        # Occasionally CFBD will have duplicated stats that causes an error here
        #and the current long df is returned. Distinct removes duplicates.
        dplyr::distinct()

      # Pivot category columns to get stats for each team game on one row
      df <- tidyr::pivot_wider(df,
                               names_from = "category",
                               values_from = "stat"
      )
      df <- df %>%
        janitor::clean_names()
      df[cols[!(cols %in% colnames(df))]] <- NA
      df <- df %>%
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
        df <- df %>%
          dplyr::mutate(opponent_home_away = ifelse(.data$home_away == "home","away","home")) %>%
          dplyr::left_join(df,
                           by = c("game_id", "opponent_home_away" = "home_away"),
                           suffix = c("", "_allowed")
          ) %>%
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

          df <- df %>%
            dplyr::filter(.data$team == team) %>%
            dplyr::select(dplyr::all_of(cols1))


        } else if (!is.null(conference)) {
          confs <- cfbd_conferences()

          conference <- URLdecode(conference)

          conf_name <- confs[confs$abbreviation == conference, ]$name

          df <- df %>%
            dplyr::filter(conference == conf_name) %>%
            dplyr::select(dplyr::all_of(cols1))


        } else {
          df <- df %>%
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
          team <- URLdecode(team <- team)

          df <- df %>%
            dplyr::filter(.data$team == team) %>%
            dplyr::select(dplyr::all_of(cols2))

        } else if (!is.null(conference)) {
          confs <- cfbd_conferences()

          conference <- URLdecode(conference)

          conf_name <- confs[confs$abbreviation == conference, ]$name

          df <- df %>%
            dplyr::filter(conference == conf_name) %>%
            dplyr::select(dplyr::all_of(cols2))


        } else {
          df <- df %>%
            dplyr::select(dplyr::all_of(cols2))

        }
      }


      df <- df %>%
        make_cfbfastR_data("Team stats data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no team stats data available!"))
    },
    finally = {
    }
  )
  return(df)
}
