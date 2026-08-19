#' @name cfbd_draft
#' @aliases cfbd_draft draft nfl nfl_draft nfl_teams
#' @title
#' **CFBD NFL Draft Endpoint Overview**
#' @description
#'
#' * `cfbd_draft_teams()`: Get list of NFL teams.
#' * `cfbd_draft_positions()`: Get list of NFL positions for mapping to college positions.
#' * `cfbd_draft_picks()`: Get list of NFL Draft picks.
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
#'
#'    |col_name         |types     |description                                          |
#'    |:----------------|:---------|:----------------------------------------------------|
#'    |nfl_location     |character |NFL team location (city).                            |
#'    |nfl_nickname     |character |NFL team nickname (mascot).                          |
#'    |nfl_display_name |character |NFL team display name (usually more neat/complete).  |
#'    |nfl_logo         |character |URL for NFL team logo.                               |
#'
#' @keywords NFL Teams
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @family CFBD Draft
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
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten=TRUE) |>
        janitor::clean_names() |>
        as.data.frame() |>
        dplyr::rename(
          "nfl_location" = "location",
          "nfl_nickname" = "nickname",
          "nfl_display_name" = "display_name",
          "nfl_logo" = "logo"
        )
      df <- df |>
        make_cfbfastR_data("NFL teams data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no NFL teams data available! {conditionMessage(e)}"))
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
#'
#'    |col_name              |types     |description                          |
#'    |:---------------------|:---------|:------------------------------------|
#'    |position_name         |character |NFL Position group name.             |
#'    |position_abbreviation |character |NFL position group abbreviation.     |
#'
#' @keywords NFL Positions
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @family CFBD Draft
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
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten=TRUE) |>
        janitor::clean_names() |>
        as.data.frame() |>
        dplyr::rename(
          "position_name" = "name",
          "position_abbreviation" = "abbreviation"
        )

      df <- df |>
        make_cfbfastR_data("NFL positions data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no NFL positions data available! {conditionMessage(e)}"))
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
#' @param year (*Integer* required): NFL draft class, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_draft_picks', 'min_year']`
#' @param nfl_team (*String*): NFL drafting team, see [cfbd_draft_teams()] for valid selections.
#' @param college (*String*): NFL draftee college team, see [cfbd_team_info()] for valid selections.
#' @param conference (*String*): NFL draftee college team conference, see [cfbd_conferences()] for valid selections.
#' @param position (*String*): NFL position abbreviation, see [cfbd_draft_positions()] for valid selections.
#' @return [cfbd_draft_picks()] - A data frame with 24 variables:
#'
#'    |col_name                     |types     |description                                                       |
#'    |:----------------------------|:---------|:-----------------------------------------------------------------|
#'    |college_athlete_id           |integer   |College athlete referencing id.                                   |
#'    |nfl_athlete_id               |integer   |NFL athlete referencing id.                                       |
#'    |college_id                   |integer   |College team referencing id.                                      |
#'    |college_team                 |character |College team name.                                                |
#'    |college_conference           |character |Conference of college team.                                       |
#'    |nfl_team_id                  |integer   |NFL team ID.                                                      |
#'    |nfl_team                     |character |NFL team name of drafted player.                                  |
#'    |year                         |integer   |NFL draft class year.                                             |
#'    |overall                      |integer   |Overall draft pick number.                                        |
#'    |round                        |integer   |Round of NFL draft the draftee was picked in.                     |
#'    |pick                         |integer   |Pick number of the NFL draftee within the round they were picked in.|
#'    |name                         |character |NFL draftee name.                                                 |
#'    |position                     |character |NFL draftee position.                                             |
#'    |height                       |numeric   |NFL draftee height.                                               |
#'    |weight                       |integer   |NFL draftee weight.                                               |
#'    |pre_draft_ranking            |integer   |Pre-draft ranking (ESPN).                                         |
#'    |pre_draft_position_ranking   |integer   |Pre-draft position ranking (ESPN).                                |
#'    |pre_draft_grade              |numeric   |Pre-draft scouts grade (ESPN).                                    |
#'    |hometown_info_city           |character |Hometown of the NFL draftee.                                      |
#'    |hometown_info_state_province |character |Hometown state of the NFL draftee.                                |
#'    |hometown_info_country        |character |Hometown country of the NFL draftee.                              |
#'    |hometown_info_latitude       |character |Hometown latitude of the NFL draftee.                             |
#'    |hometown_info_longitude      |character |Hometown longitude of the NFL draftee.                            |
#'    |hometown_info_county_fips    |character |Hometown FIPS code of the NFL draftee.                            |
#'
#' @keywords NFL Draft Picks
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @family CFBD Draft
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
    "conference" = conference,
    "position" = position,
    "team" = nfl_team,
    "school" = college
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten=TRUE) |>
        janitor::clean_names()

      df <- df |>
        make_cfbfastR_data("NFL draft data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no NFL draft data available! {conditionMessage(e)}"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
