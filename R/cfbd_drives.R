
#' @name cfbd_drives
#' @aliases cfbd_drives
#' @title
#' **CFBD Drives Endpoint Overview**
#' @description
#'
#' * `cfbd_drives()`: Get college football game drives.
#'
#' @details
#' ## **Get college football game drives**
#'
#' ```r
#' cfbd_drives(year = 2018, week = 1, team = "TCU")
#'
#' cfbd_drives(2018, team = "Texas A&M", defense_conference = "SEC")
#' ```
#'
NULL

#' @title
#' **CFBD Drives Endpoint**
#' @description
#' **Get college football game drives**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param season_type (*String* default regular): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (*String* optional): D-I Team
#' @param offense_team (*String* optional): Offense D-I Team
#' @param defense_team (*String* optional): Defense D-I Team
#' @param conference (*String* optional): DI Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param offense_conference (*String* optional): Offense DI Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param defense_conference (*String* optional): Defense DI Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param division (*String* optional): Division abbreviation - Select a valid division: fbs/fcs/ii/iii
#' @return [cfbd_drives()] - A data frame with 28 variables:
#'
#'    |col_name             |types     |description                                                              |
#'    |:--------------------|:---------|:------------------------------------------------------------------------|
#'    |offense              |character |Drive offense team name.                                                 |
#'    |offense_conference   |character |Drive offense team's conference.                                         |
#'    |defense              |character |Drive defense team name.                                                 |
#'    |defense_conference   |character |Drive defense team's conference.                                         |
#'    |game_id              |integer   |Unique CFBD game identifier.                                             |
#'    |drive_id             |character |Unique CFBD drive identifier.                                            |
#'    |drive_number         |integer   |Drive number within the game.                                            |
#'    |scoring              |logical   |Flag indicating whether the drive ended in a score.                      |
#'    |start_period         |integer   |Period (quarter) in which the drive starts.                              |
#'    |start_yardline       |integer   |Yard line at the drive start.                                            |
#'    |start_yards_to_goal  |integer   |Yards-to-goal at the drive start.                                        |
#'    |end_period           |integer   |Period (quarter) in which the drive ends.                                |
#'    |end_yardline         |integer   |Yard line at drive end.                                                  |
#'    |end_yards_to_goal    |integer   |Yards-to-goal at drive end.                                              |
#'    |plays                |integer   |Number of plays in the drive.                                            |
#'    |yards                |integer   |Total yards gained on the drive.                                         |
#'    |drive_result         |character |Result of the drive (e.g. TD, FG, PUNT).                                 |
#'    |is_home_offense      |logical   |Flag indicating whether the offense on the field is the home team.       |
#'    |start_offense_score  |numeric   |Offense score at the start of the drive.                                 |
#'    |start_defense_score  |numeric   |Defense score at the start of the drive.                                 |
#'    |end_offense_score    |numeric   |Offense score at the end of the drive.                                   |
#'    |end_defense_score    |numeric   |Defense score at the end of the drive.                                   |
#'    |time_minutes_start   |integer   |Game clock minutes at drive start.                                       |
#'    |time_seconds_start   |integer   |Game clock seconds at drive start.                                       |
#'    |time_minutes_end     |integer   |Game clock minutes at drive end.                                         |
#'    |time_seconds_end     |integer   |Game clock seconds at drive end.                                         |
#'    |time_minutes_elapsed |numeric   |Minutes elapsed during the drive.                                        |
#'    |time_seconds_elapsed |integer   |Seconds elapsed during the drive.                                        |
#'
#' @keywords Drives
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Drives
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_drives(year=2018, week = 1, team = "TCU"))
#'
#'   try(cfbd_drives(2018, team = "Texas A&M", defense_conference = "SEC"))
#' }
cfbd_drives <- function(year,
                        season_type = "regular",
                        week = NULL,
                        team = NULL,
                        offense_team = NULL,
                        defense_team = NULL,
                        conference = NULL,
                        offense_conference = NULL,
                        defense_conference = NULL,
                        division = 'fbs') {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)

  # Team Name Handling ----
  team <- handle_accents(team)
  offense_team <- handle_accents(offense_team)
  defense_team <- handle_accents(defense_team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/drives"
  query_params <- list(
    "year" = year,
    "seasonType" = season_type,
    "week" = week,
    "team" = team,
    "offense" = offense_team,
    "defense" = defense_team,
    "conference" = conference,
    "offenseConference" = offense_conference,
    "defenseConference" = defense_conference,
    "classification" = division
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
          "drive_id" = "id",
          "time_minutes_start" = "startTime.minutes",
          "time_seconds_start" = "startTime.seconds",
          "time_minutes_end" = "endTime.minutes",
          "time_seconds_end" = "endTime.seconds",
          "time_minutes_elapsed" = "elapsed.minutes",
          "time_seconds_elapsed" = "elapsed.seconds"
        ) %>%
        janitor::clean_names()

      # 2021 games with pbp data from another (non-ESPN) source include extra unclear columns for hours.
      # Minutes and seconds from these games are also suspect
      if ("start_time.hours" %in% names(df)) {
        df <- df %>%
          dplyr::select(-"start_time.hours")
      }
      if ("end_time.hours" %in% names(df)) {
        df <- df %>%
          dplyr::select(-"end_time.hours")
      }

      df <- df %>%
        make_cfbfastR_data("Drives data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no drives data available!"))
    },
    finally = {
    }
  )
  return(df)
}
