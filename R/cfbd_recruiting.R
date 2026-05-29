
#' @name cfbd_recruiting
#' @aliases cfbd_recruiting recruiting
#' @title
#' **CFB Recruiting Endpoint Overview**
#' @description
#'
#' * `cfbd_recruiting_player()`: Get college football player recruiting information for a single year with filters available for team, recruit type, state and position.
#' * `cfbd_recruiting_position()`: Get college football position group recruiting information .
#' * `cfbd_recruiting_team()`: Get college football recruiting team rankings information.
#'
#' ## **Get player recruiting rankings**
#'
#' Get college football player recruiting information for a single year with filters available
#' for team, recruit type, state and position.
#' ```r
#' cfbd_recruiting_player(2018, team = "Texas")
#'
#' cfbd_recruiting_player(2016, recruit_type = "JUCO")
#'
#' cfbd_recruiting_player(2020, recruit_type = "HighSchool", position = "OT", state = "FL")
#' ```
#' ## **Get college football position group recruiting information.**
#' ```r
#' cfbd_recruiting_position(2018, team = "Texas")
#'
#' cfbd_recruiting_position(2016, 2020, team = "Virginia")
#'
#' cfbd_recruiting_position(2015, 2020, conference = "SEC")
#' ```
#' ## **Get college football recruiting team rankings information.**
#' ```r
#' cfbd_recruiting_team(2018, team = "Texas")
#'
#' cfbd_recruiting_team(2016, team = "Virginia")
#'
#' cfbd_recruiting_team(2016, team = "Texas A&M")
#'
#' cfbd_recruiting_team(2011)
#' ```
#'
#' @details
#'
#' Gets CFB team recruiting ranks with filters available for year and team.
#' At least one of **year** or **team** must be specified for the function to run
#'
#' If you would like CFB recruiting information for players, please
#' see the [cfbd_recruiting_player()] function
#'
#' If you would like to get CFB recruiting information based on position groups during a
#' time period for all FBS teams, please see the [cfbd_recruiting_position()] function.
#'
#' [cfbd_recruiting_player()] - At least one of **year** or **team** must be specified for the function to run
#'
#' [cfbd_recruiting_position()] - If only start_year is provided, function will get CFB recruiting information based
#' on position groups during that year for all FBS teams.
NULL
#' @title
#' **Get player recruiting rankings**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*) - Minimum: 2000. Required if team not provided
#' @param team (*String* optional): D-I Team. Required if year not provided
#' @param recruit_type (*String* optional): default API return is 'HighSchool', other options include 'JUCO'
#' or 'PrepSchool'  - For position group information
#' @param state (*String* optional): Two letter State abbreviation
#' @param position (*String* optional): Position Group  - options include:
#'  * Offense: 'PRO', 'DUAL', 'RB', 'FB', 'TE',  'OT', 'OG', 'OC', 'WR'
#'  * Defense: 'CB', 'S', 'OLB', 'ILB', 'WDE', 'SDE', 'DT'
#'  * Special Teams: 'K', 'P'
#'
#' @return [cfbd_recruiting_player()] - A data frame with 19 variables:
#'
#'    |col_name                |types     |description                                                              |
#'    |:-----------------------|:---------|:------------------------------------------------------------------------|
#'    |id                      |integer   |247Sports referencing id for the recruit.                                |
#'    |athlete_id              |integer   |CFBD athlete referencing id linking to player tables.                    |
#'    |recruit_type            |character |Recruit class: High School, Prep School, or Junior College.              |
#'    |year                    |integer   |Recruiting class year (four-digit season).                               |
#'    |ranking                 |integer   |Recruit national ranking within the class.                               |
#'    |name                    |character |Recruit full name.                                                       |
#'    |school                  |character |High school, prep school, or JUCO program the recruit attended.          |
#'    |committed_to            |character |College program the recruit is committed to.                             |
#'    |position                |character |Recruit position abbreviation (e.g. QB, WR, OT).                         |
#'    |height                  |numeric   |Recruit height in inches.                                                |
#'    |weight                  |integer   |Recruit weight in pounds.                                                |
#'    |stars                   |integer   |Recruit star rating on the 247Sports scale (2-5).                        |
#'    |rating                  |numeric   |247Sports composite rating for the recruit.                              |
#'    |city                    |character |Hometown city of the recruit.                                            |
#'    |state_province          |character |Hometown state or province of the recruit.                               |
#'    |country                 |character |Hometown country of the recruit.                                         |
#'    |hometown_info_latitude  |character |Latitude of the recruit's hometown.                                      |
#'    |hometown_info_longitude |character |Longitude of the recruit's hometown.                                     |
#'    |hometown_info_fips_code |character |FIPS code of the recruit's hometown.                                     |
#'
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @family CFBD Recruiting
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_recruiting_player(2018, team = "Texas"))
#'
#'   try(cfbd_recruiting_player(2016, recruit_type = "JUCO"))
#'
#'   try(cfbd_recruiting_player(2020, recruit_type = "HighSchool", position = "OT", state = "FL"))
#' }
#'
cfbd_recruiting_player <- function(year = NULL,
                                   team = NULL,
                                   recruit_type = "HighSchool",
                                   state = NULL,
                                   position = NULL) {

  # Validation Lists ----
  pos_groups <- c(
    "PRO", "DUAL", "RB", "FB", "TE", "OT", "OG", "OC", "WR",
    "CB", "S", "OLB", "ILB", "WDE", "SDE", "DT", "K", "P"
  )

  # Validation ----
  validate_api_key()
  validate_reqs(year, team)
  validate_year(year)
  validate_range(year, 2000)
  validate_list(recruit_type, c("HighSchool","PrepSchool", "JUCO"))
  validate_list(state, datasets::state.abb)
  validate_list(position, pos_groups)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/recruiting/players"
  query_params <- list(
    "year" = year,
    "team" = team,
    "classification" = recruit_type,
    "position" = position,
    "state" = state
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
        janitor::clean_names() %>%
        as.data.frame()


      df <- df %>%
        make_cfbfastR_data("Player recruiting info from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player recruiting data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get college football position group recruiting information.**
#' @param start_year (*Integer* optional): Start Year, 4 digit format (*YYYY*). *Note: 2000 is the minimum value*
#' @param end_year (*Integer* optional): End Year,  4 digit format (*YYYY*). *Note: 2020 is the maximum value currently*
#' @param team (*String* optional): Team - Select a valid team, D-I football
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#'
#' @return [cfbd_recruiting_position()] - A data frame with 7 variables:
#'
#'    |col_name       |types     |description                                                          |
#'    |:--------------|:---------|:--------------------------------------------------------------------|
#'    |team           |character |Recruiting team (school) name.                                       |
#'    |conference     |character |Conference affiliation of the recruiting team.                       |
#'    |position_group |character |Position group of the recruits (e.g. Offensive Line, Defensive Back).|
#'    |avg_rating     |numeric   |Average 247Sports composite rating of recruits in the position group.|
#'    |total_rating   |numeric   |Sum of the 247Sports composite ratings of recruits in the group.     |
#'    |commits        |integer   |Number of commits in the position group.                             |
#'    |avg_stars      |numeric   |Average star rating of recruits in the position group.               |
#'
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @family CFBD Recruiting
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_recruiting_position(2018, team = "Texas"))
#'
#'   try(cfbd_recruiting_position(2016, 2020, team = "Virginia"))
#'
#'   try(cfbd_recruiting_position(2015, 2020, conference = "SEC"))
#' }
#'
cfbd_recruiting_position <- function(start_year = NULL, end_year = NULL,
                                     team = NULL, conference = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(start_year)
  validate_year(end_year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/recruiting/groups"
  query_params <- list(
    "startYear" = start_year,
    "endYear" = end_year,
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
        dplyr::rename(
          "position_group" = "positionGroup",
          "avg_rating" = "averageRating",
          "total_rating" = "totalRating",
          "avg_stars" = "averageStars"
        )


      df <- df %>%
        make_cfbfastR_data("Recruiting position group info from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no position group recruiting data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get college football recruiting team rankings information.**
#' @param year (*Integer* optional): Recruiting Class Year, 4 digit format (*YYYY*) - Minimum: 2000. Required if team not provided.
#' @param team (*String* optional): Team - Select a valid team, D1 football. Required if year not provided.
#'
#' @return [cfbd_recruiting_team()] - A data frame with 4 variables:
#'
#'    |col_name |types     |description                                                |
#'    |:--------|:---------|:----------------------------------------------------------|
#'    |year     |integer   |Recruiting class year (four-digit season).                 |
#'    |rank     |integer   |National team recruiting rank for the class.               |
#'    |team     |character |Recruiting team (school) name.                             |
#'    |points   |character |Team talent points totaled across the recruiting class.    |
#'
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Recruiting
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_recruiting_team(2018, team = "Texas"))
#'
#'   try(cfbd_recruiting_team(2016, team = "Virginia"))
#'
#'   try(cfbd_recruiting_team(2016, team = "Texas A&M"))
#'
#'   try(cfbd_recruiting_team(2011))
#' }
#'
cfbd_recruiting_team <- function(year = NULL,
                                 team = NULL) {

  # Validation ----
  validate_api_key()
  validate_reqs(year, team)
  validate_year(year)
  validate_range(year, 2000)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/recruiting/teams"
  query_params <- list(
    "year" = year,
    "team" = team
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
        as.data.frame()


      df <- df %>%
        make_cfbfastR_data("Recruiting team rankings from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no team recruiting data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get Transfer Portal Data**
#' @param year (*Integer* required): Year of the offseason (2021 would return transfer portal data starting from the end of the 2020 season), 4 digit format (*YYYY*).
#' @return [cfbd_recruiting_transfer_portal()] - A data frame with 10 variables:
#'
#'    |col_name      |types     |description                                                          |
#'    |:-------------|:---------|:--------------------------------------------------------------------|
#'    |season        |integer   |Season of the transfer (four-digit year).                            |
#'    |first_name    |character |Player's first name.                                                 |
#'    |last_name     |character |Player's last name.                                                  |
#'    |position      |character |Player position abbreviation (e.g. QB, WR, OT).                      |
#'    |origin        |character |Original (transferring-from) team.                                   |
#'    |destination   |character |New (transferring-to) team.                                          |
#'    |transfer_date |character |Date the transfer was reported (parsed downstream to POSIXct).       |
#'    |rating        |character |Player's 247Sports transfer rating.                                  |
#'    |stars         |integer   |Player's 247Sports star rating (2-5).                                |
#'    |eligibilty    |character |Player's eligibility status at time of transfer.                     |
#'
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Recruiting
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_recruiting_transfer_portal(year = 2021))
#' }
cfbd_recruiting_transfer_portal <- function(year) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/player/portal"
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
        jsonlite::fromJSON(flatten = TRUE) %>%
        janitor::clean_names() %>%
        dplyr::mutate(
          transfer_date = as.POSIXct(.data$transfer_date)
        )


      df <- df %>%
        make_cfbfastR_data("Transfer portal data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no transfer portal data available!"))
    },
    finally = {
    }
  )
  return(df)
}
