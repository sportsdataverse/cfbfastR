#' @name cfbd_drives
#' @aliases drives cfbd_drives
#' @title 
#' **CFBD Drives Endpoint**
#' @description 
#' **Get college football game drives**
#' ```r
#' cfbd_drives(2018, week = 1, team = "TCU")
#'
#' cfbd_drives(2018, team = "Texas A&M", defense_conference = "SEC")
#' ````
#' @examples
#' \donttest{
#' cfbd_drives(2018, week = 1, team = "TCU")
#'
#' cfbd_drives(2018, team = "Texas A&M", defense_conference = "SEC")
#' }
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param season_type (*String* default regular): Select Season Type: regular, postseason, or both
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (*String* optional): D-I Team
#' @param offense_team (*String* optional): Offense D-I Team
#' @param defense_team (*String* optional): Defense D-I Team
#' @param conference (*String* optional): DI Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param offense_conference (*String* optional): Offense DI Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param defense_conference (*String* optional): Defense DI Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
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
#'   \item{`time_minutes_elapsed`:double.}{Minutes elapsed during drive.}
#'   \item{`time_seconds_elapsed`:integer.}{Seconds elapsed during drive.}
#' }
#' @source <https://api.collegefootballdata.com/drives>
#' @keywords Drives
NULL

#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
cfbd_drives <- function(year,
                        season_type = "regular",
                        week = NULL,
                        team = NULL,
                        offense_team = NULL,
                        defense_team = NULL,
                        conference = NULL,
                        offense_conference = NULL,
                        defense_conference = NULL,
                        verbose = FALSE) {

  # Check if year is numeric
  assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
    msg = "Enter valid year as a number (YYYY)"
  )

  if (season_type != "regular") {
    # Check if season_type is appropriate, if not regular
    assertthat::assert_that(season_type %in% c("postseason", "both"),
      msg = "Enter valid season_type: regular, postseason, or both"
    )
  }
  if (!is.null(week)) {
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2,
      msg = "Enter valid week 1-15 \n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(offense_team)) {
    if (offense_team == "San Jose State") {
      offense_team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      offense_team <- utils::URLencode(offense_team, reserved = TRUE)
    }
  }
  if (!is.null(defense_team)) {
    if (defense_team == "San Jose State") {
      defense_team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      defense_team <- utils::URLencode(defense_team, reserved = TRUE)
    }
  }
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #                         msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  if (!is.null(offense_conference)) {
    # # Check offense_conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(offense_conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #                         msg = "Incorrect offense_conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode offense_conference parameter for URL, if not NULL
    offense_conference <- utils::URLencode(offense_conference, reserved = TRUE)
  }
  if (!is.null(defense_conference)) {
    # # Check defense_conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(defense_conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #                         msg = "Incorrect defense_conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode defense_conference parameter for URL, if not NULL
    defense_conference <- utils::URLencode(defense_conference, reserved = TRUE)
  }

  base_url <- "https://api.collegefootballdata.com/drives?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&seasonType=", season_type,
    "&week=", week,
    "&team=", team,
    "&offense=", offense_team,
    "&defense=", defense_team,
    "&conference=", conference,
    "&offenseConference=", offense_conference,
    "&defenseConference=", defense_conference
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

  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        dplyr::rename(
          drive_id = .data$id,
          time_minutes_start = .data$start_time.minutes,
          time_seconds_start = .data$start_time.seconds,
          time_minutes_end = .data$end_time.minutes,
          time_seconds_end = .data$end_time.seconds,
          time_minutes_elapsed = .data$elapsed.minutes,
          time_seconds_elapsed = .data$elapsed.seconds
        ) %>%
        dplyr::mutate(
          time_minutes_elapsed = ifelse(is.na(.data$time_minutes_elapsed), 0, .data$time_minutes_elapsed),
          time_seconds_elapsed = ifelse(is.na(.data$time_seconds_elapsed), 0, .data$time_seconds_elapsed)
        ) %>%
        as.data.frame()
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no drives data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )

  return(df)
}
