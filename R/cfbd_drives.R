#' Get results information from games
#'
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param season_type (\emph{String} default regular): Select Season Type: regular, postseason, or both
#' @param week (\emph{Integer} optional): Week - values from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (\emph{String} optional): D-I Team
#' @param offense_team (\emph{String} optional): Offense D-I Team
#' @param defense_team (\emph{String} optional): Defense D-I Team
#' @param conference (\emph{String} optional): DI Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param offense_conference (\emph{String} optional): Offense DI Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param defense_conference (\emph{String} optional): Defense DI Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#'
#' @return \code{\link[cfbfastR:cfbd_drives]{cfbfastR::cfbd_drives()}} - A data frame with 23 variables as follows:
#' \describe{
#'   \item{\code{offense}}{character. Drive offense.}
#'   \item{\code{offense_conference}}{character. Drive offense's conference.}
#'   \item{\code{defense}}{character. Drive defense.}
#'   \item{\code{defense_conference}}{character. Drive defense's conference.}
#'   \item{\code{game_id}}{integer. Unique game identifier - `game_id`.}
#'   \item{\code{drive_id}}{character. Unique drive identifier - `drive_id`.}
#'   \item{\code{drive_number}}{integer. Drive number in game.}
#'   \item{\code{scoring}}{logical. Drive ends in a score.}
#'   \item{\code{start_period}}{integer. Period (or Quarter) in which the drive starts.}
#'   \item{\code{start_yardline}}{integer.  Yard line at the drive start.}
#'   \item{\code{start_yards_to_goal}}{integer. Yards-to-Goal at the drive start.}
#'   \item{\code{end_period}}{integer. Period (or Quarter) in which the drive ends.}
#'   \item{\code{end_yardline}}{integer. Yard line at drive end.}
#'   \item{\code{end_yards_to_goal}}{integer. Yards-to-Goal at drive end.}
#'   \item{\code{plays}}{integer. Number of drive plays.}
#'   \item{\code{yards}}{integer. Total drive yards.}
#'   \item{\code{drive_result}}{character. Result of the drive description.}
#'   \item{\code{time_minutes_start}}{integer. Minutes at drive start.}
#'   \item{\code{time_seconds_start}}{integer. Seconds at drive start.}
#'   \item{\code{time_minutes_end}}{integer. Minutes at drive end.}
#'   \item{\code{time_seconds_end}}{integer. Seconds at drive end.}
#'   \item{\code{time_minutes_elapsed}}{double. Minutes elapsed during drive.}
#'   \item{\code{time_seconds_elapsed}}{integer. Seconds elapsed during drive.}
#' }
#' @source \url{https://api.collegefootballdata.com/drives}
#' @keywords Drives
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \dontrun{
#' cfbd_drives(2018, week = 1, team = "TCU")
#'
#' cfbd_drives(2018, team = "Texas A&M", defense_conference = "SEC")
#' }
#'
cfbd_drives <- function(year,
                        season_type = "regular",
                        week = NULL,
                        team = NULL,
                        offense_team = NULL,
                        defense_team = NULL,
                        conference = NULL,
                        offense_conference = NULL,
                        defense_conference = NULL) {

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

  return(df)
}
