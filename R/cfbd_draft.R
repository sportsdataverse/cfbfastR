#' @name cfbd_draft
#' @aliases cfbd_draft draft nfl nfl_draft nfl_teams
#' @title
#' **CFBD NFL Draft Endpoint Overview**
#' @description
#' \describe{
#'   \item{`cfbd_draft_teams()`:}{ Get list of NFL teams.}
#'   \item{`cfbd_draft_positions()`:}{ Get list of NFL positions for mapping to college positions.}
#'   \item{`cfbd_draft_picks()`:}{ Get list of NFL Draft picks.}
#' }
#'
#' @details
#' ## **Get list of NFL teams**
#'
#' ```r
#' cfbd_draft_teams()
#' ```
#'
#' ## **Get list of NFL positions for mapping to collegiate**
#'
#' ```r
#' cfbd_draft_positions()
#'
#' ```
#'
#' ## **Get list of NFL Draft picks**
#'
#' ```r
#' cfbd_draft_picks(year = 2020, college = "Texas")
#'
#' cfbd_draft_picks(nfl_team = "Cincinatti")
#' ````
#'
NULL

#' @title
#' **Get list of NFL teams**
#' @return [cfbd_draft_teams()] - A data frame with 4 variables:
#' \describe{
#'   \item{`nfl_location`: character.}{NFL team location (city).}
#'   \item{`nfl_nickname`: integer}{NFL team nickname (mascot).}
#'   \item{`nfl_display_name`: integer}{NFL team display name (usually more neat/complete).}
#'   \item{`nfl_logo`: character}{URL for NFL team logo.}
#'  }
#' @keywords NFL Teams
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_draft_teams())
#' }
#'
cfbd_draft_teams <- function() {

  # Validation ----
  validate_api_key()

  # Query API ----
  full_url <- "https://api.collegefootballdata.com/draft/teams"

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten=TRUE) %>%
        janitor::clean_names() %>%
        as.data.frame() %>%
        dplyr::rename(
          "nfl_location" = "location",
          "nfl_nickname" = "nickname",
          "nfl_display_name" = "display_name",
          "nfl_logo" = "logo"
        )
      df <- df %>%
        make_cfbfastR_data("NFL teams data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no NFL teams data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
#' @title
#' **Get list of NFL positions**
#' @return [cfbd_draft_positions()] - A data frame with 2 variables:
#' \describe{
#'   \item{`position_name`: character.}{NFL Position group name.}
#'   \item{`position_abbreviation`: integer}{NFL position group abbreviation.}
#'  }
#' @keywords NFL Positions
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_draft_positions())
#' }
#'
cfbd_draft_positions <- function() {

  # Validation ----
  validate_api_key()

  # Query API ----
  full_url <- "https://api.collegefootballdata.com/draft/positions"

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten=TRUE) %>%
        janitor::clean_names() %>%
        as.data.frame() %>%
        dplyr::rename(
          "position_name" = "name",
          "position_abbreviation" = "abbreviation"
        )

      df <- df %>%
        make_cfbfastR_data("NFL positions data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no NFL positions data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get list of NFL draft picks**
#' @param year (*Integer* required): NFL draft class, 4 digit format (*YYYY*)
#' @param nfl_team (*String*): NFL drafting team, see [cfbd_draft_teams()] for valid selections.
#' @param college (*String*): NFL draftee college team, see [cfbd_team_info()] for valid selections.
#' @param conference (*String*): NFL draftee college team conference, see [cfbd_conferences()] for valid selections.
#' @param position (*String*): NFL position abbreviation, see [cfbd_draft_positions()] for valid selections.
#' @return [cfbd_draft_picks()] - A data frame with 23 variables:
#' \describe{
#'   \item{`college_athlete_id`: integer.}{College athlete referencing id.}
#'   \item{`nfl_athlete_id`: integer}{NFL athlete referencing id.}
#'   \item{`college_id`: integer}{College team referencing id.}
#'   \item{`college_team`: character}{College team name.}
#'   \item{`college_conference`: character}{Conference of college team.}
#'   \item{`nfl_team`: character}{NFL team name of drafted player.}
#'   \item{`year`: integer.}{NFL draft class year.}
#'   \item{`overall`: integer.}{Overall draft pick number.}
#'   \item{`round`: integer.}{Round of NFL draft the draftee was picked in.}
#'   \item{`pick`: integer.}{Pick number of the NFL draftee within the round they were picked in.}
#'   \item{`name`: character.}{NFL draftee name.}
#'   \item{`position`: character.}{NFL draftee position.}
#'   \item{`height`: double.}{NFL draftee height.}
#'   \item{`weight`: integer.}{NFL draftee weight.}
#'   \item{`pre_draft_ranking`: integer}{Pre-draft ranking (ESPN).}
#'   \item{`pre_draft_position_ranking`: integer.}{Pre-draft position ranking (ESPN).}
#'   \item{`pre_draft_grade`: double.}{Pre-draft scouts grade (ESPN).}
#'   \item{`hometown_info_city`: character.}{Hometown of the NFL draftee.}
#'   \item{`hometown_info_state_province`: character.}{Hometown state of the NFL draftee.}
#'   \item{`hometown_info_country`: character.}{Hometown country of the NFL draftee.}
#'   \item{`hometown_info_latitude`: character.}{Hometown latitude of the NFL draftee.}
#'   \item{`hometown_info_longitude`: character.}{Hometown longitude of the NFL draftee.}
#'   \item{`hometown_info_county_fips`: character.}{Hometown FIPS code of the NFL draftee.}
#' }
#' @keywords NFL Draft Picks
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_draft_picks(year = 2020))
#'
#'   try(cfbd_draft_picks(year = 2016, position = "PK"))
#' }

cfbd_draft_picks <- function(year = NULL,
                             nfl_team = NULL,
                             college = NULL,
                             conference = NULL,
                             position = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Team Name Handling ----
  college <- handle_accents(college)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/draft/picks"
  query_params <- list(
    "year" = year,
    "nflTeam" = nfl_team,
    "college" = college,
    "conference" = conference,
    "position" = position
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
        jsonlite::fromJSON(flatten=TRUE) %>%
        janitor::clean_names()

      df <- df %>%
        make_cfbfastR_data("NFL draft data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no NFL draft data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
