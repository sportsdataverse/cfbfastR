
#' @title
#' **CFBD Drives Endpoint**
#' @description
#' **Get college football game drives**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param season_type (*String* default regular): Select Season Type: regular, postseason, or both
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
#' @return [cfbd_drives()] - A data frame with 23 variables as follows:
#' \describe{
#'   \item{`offense`:character.}{Drive offense.}
#'   \item{`offense_conference`:character.}{Drive offense's conference.}
#'   \item{`defense`:character.}{Drive defense.}
#'   \item{`defense_conference`:character.}{Drive defense's conference.}
#'   \item{`game_id`:integer.}{Unique game identifier - `game_id`.}
#'   \item{`drive_id`:character.}{Unique drive identifier - `drive_id`.}
#'   \item{`drive_number`:integer.}{Drive number in game.}
#'   \item{`scoring`:logical.}{Drive ends in a score.}
#'   \item{`start_period`:integer.}{Period (or Quarter) in which the drive starts.}
#'   \item{`start_yardline`:integer.}{Yard line at the drive start.}
#'   \item{`start_yards_to_goal`:integer.}{Yards-to-Goal at the drive start.}
#'   \item{`end_period`:integer.}{Period (or Quarter) in which the drive ends.}
#'   \item{`end_yardline`:integer.}{Yard line at drive end.}
#'   \item{`end_yards_to_goal`:integer.}{Yards-to-Goal at drive end.}
#'   \item{`plays`:integer.}{Number of drive plays.}
#'   \item{`yards`:integer.}{Total drive yards.}
#'   \item{`drive_result`:character.}{Result of the drive description.}
#'   \item{`is_home_offense`:logical.}{Flag for if the offense on the field is the home offense}
#'   \item{`start_offense_score`:numeric.}{Offense score at the start of the drive.}
#'   \item{`start_defense_score`:numeric.}{Defense score at the start of the drive.}
#'   \item{`end_offense_score`:numeric.}{Offense score at the end of the drive.}
#'   \item{`end_defense_score`:numeric.}{Defense score at the end of the drive.}
#'   \item{`time_minutes_start`:integer.}{Minutes at drive start.}
#'   \item{`time_seconds_start`:integer.}{Seconds at drive start.}
#'   \item{`time_minutes_end`:integer.}{Minutes at drive end.}
#'   \item{`time_seconds_end`:integer.}{Seconds at drive end.}
#'   \item{`time_minutes_elapsed`:double.}{DEPRECATED Minutes elapsed during drive.}
#'   \item{`time_seconds_elapsed`:integer.}{DEPRECATED Seconds elapsed during drive.}
#' }
#' @keywords Drives
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_drives(2018, week = 1, team = "TCU"))
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
  base_url <- "https://api.collegefootballdata.com/drives?"
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
          "time_seconds_end" = "endTime.seconds"
        ) %>%
        dplyr::mutate(time_minutes_elapsed = NA,
                      time_seconds_elapsed = NA) %>%
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
