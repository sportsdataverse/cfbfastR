#' @name cfbd_players
#' @aliases cfbd_player
#' @title
#' **CFBD Players Endpoint Overview**
#' @description
#' \describe{
#' \item{`cfbd_player_info()`:}{ Player information search.}
#' \item{`cfbd_player_returning()`:}{ Player returning production.}
#' \item{`cfbd_player_usage()`:}{ Player usage.}
#' }
#' @details
#' ### **Player information lookup**
#' ```r
#'  cfbd_player_info(search_term = "James", position = "DB", team = "Florida State", year = 2017)
#'
#'  cfbd_player_info(search_term = "Lawrence", team = "Clemson")
#' ```
#' ### **Get player returning production**
#' ```r
#'  cfbd_player_returning(year = 2019, team = "Florida State")
#' ```
#' ### **Get player usage metrics**
#' ```r
#'  cfbd_player_usage(year = 2019, position = "WR", team = "Florida State")
#' ```
NULL

#' @title
#' **Player information lookup**
#' @param search_term (*String* required): Search term for the player you are trying to look up
#' @param position (*string* optional): Position of the player you are searching for.
#' Position Group  - options include:
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL
#'  * Special Teams: K, P, LS, PK
#' @param team (*String* optional): Team - Select a valid team, D1 football
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*).
#' If left NULL, API default will only provide results for most recent year of final rosters: 2020
#' @return [cfbd_player_info()] - A data frame with 12 variables:
#' \describe{
#'   \item{`athlete_id`:character.}{Unique player identifier `athlete_id`.}
#'   \item{`team`:character.}{Team of the player.}
#'   \item{`name`:character.}{Player name.}
#'   \item{`first_name`:character.}{Player first name.}
#'   \item{`last_name`:character.}{Player last name.}
#'   \item{`weight`:integer.}{Player weight.}
#'   \item{`height`:integer.}{Player height.}
#'   \item{`jersey`:integer.}{Player jersey number.}
#'   \item{`position`:character.}{Player position.}
#'   \item{`home_town`:character.}{Player home town.}
#'   \item{`team_color`:character.}{Player team color.}
#'   \item{`team_color_secondary`:character.}{Player team secondary color.}
#' }
#' @keywords Players
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_player_info(search_term = "James", position = "DB", team = "Florida State", year = 2017))
#'
#'   try(cfbd_player_info(search_term = "Lawrence", team = "Clemson"))
#' }
cfbd_player_info <- function(search_term,
                             position = NULL,
                             team = NULL,
                             year = NULL) {

  # Validation Lists ----
  pos_groups <- c(
    "QB", "RB", "FB", "TE", "WR", "OL", "OT", "G", "OC",
    "DB", "CB", "S", "LB", "DE", "NT", "DL", "DT",
    "K", "P", "PK", "LS"
  )

  # Validation ----
  validate_api_key()
  validate_list(position, pos_groups)
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/player/search?"
  query_params <- list(
    "searchTerm" = search_term,
    "position" = position,
    "team" = team,
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
        dplyr::rename(
          "athlete_id" = "id",
          "home_town" = "hometown"
        )


      df <- df %>%
        make_cfbfastR_data("Player information from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player info data available!"))
    },
    finally = {
    }
  )
  return(df)
}



#' @title
#' **Get player returning production**
#' @param year (*Integer* required, default most recent season): Year, 4 digit format (*YYYY*).
#' @param team (*String* optional): Team - Select a valid team, D1 football
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @return [cfbd_player_returning()] - A data frame with 15 variables:
#' \describe{
#'   \item{`season`:integer.}{Returning player season.}
#'   \item{`team`:character.}{Team name.}
#'   \item{`conference`:character.}{Conference of team.}
#'   \item{`total_ppa`:double.}{Total predicted points added returning.}
#'   \item{`total_passing_ppa`:double.}{Total passing predicted points added returning.}
#'   \item{`total_receiving_ppa`:double.}{Total receiving predicted points added returning.}
#'   \item{`total_rushing_ppa`:double.}{Total rushing predicted points added returning.}
#'   \item{`percent_ppa`:double.}{Percentage of prior year's predicted points added returning.}
#'   \item{`percent_passing_ppa`:double.}{Percentage of prior year's passing predicted points added returning.}
#'   \item{`percent_receiving_ppa`:double.}{Percentage of prior year's receiving predicted points added returning.}
#'   \item{`percent_rushing_ppa`:double.}{Percentage of prior year's rushing predicted points added returning.}
#'   \item{`usage`:double.}{.}
#'   \item{`passing_usage`:double.}{.}
#'   \item{`receiving_usage`:double.}{.}
#'   \item{`rushing_usage`:double.}{.}
#' }
#' @keywords Returning Production
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @export
#' @examples
#' \donttest{
#'    try(cfbd_player_returning(year = 2019, team = "Florida State"))
#' }
#'
cfbd_player_returning <- function(year = most_recent_cfb_season(),
                                  team = NULL,
                                  conference = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/player/returning?"
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
        jsonlite::fromJSON() %>%
        dplyr::rename(
          "total_ppa" = "totalPPA",
          "total_passing_ppa" = "totalPassingPPA",
          "total_receiving_ppa" = "totalReceivingPPA",
          "total_rushing_ppa" = "totalRushingPPA",
          "percent_ppa" = "percentPPA",
          "percent_passing_ppa" = "percentPassingPPA",
          "percent_receiving_ppa" = "percentReceivingPPA",
          "percent_rushing_ppa" = "percentRushingPPA",
          "passing_usage" = "passingUsage",
          "receiving_usage" = "receivingUsage",
          "rushing_usage" = "rushingUsage"
        )


      df <- df %>%
        make_cfbfastR_data("Returning production data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no returning player data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get player usage metrics**
#' @param year (*Integer* required, default most recent season): Year, 4 digit format (*YYYY*).
#' @param team (*String* optional): Team - Select a valid team, D1 football
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param position (*string* optional): Position of the player you are searching for.
#' Position Group  - options include:
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL
#'  * Special Teams: K, P, LS, PK
#' @param athlete_id (*Integer* optional): Athlete ID filter for querying a single athlete
#' Can be found using the [cfbd_player_info()] function.
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE/FALSE)
#' @return [cfbd_player_usage()] - A data frame with 14 variables:
#' \describe{
#'   \item{`season`: integer.}{Player usage season.}
#'   \item{`athlete_id`: character.}{Referencing athlete id.}
#'   \item{`name`: character.}{Athlete name.}
#'   \item{`position`: character.}{Athlete position.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`conference`: character.}{Conference of team.}
#'   \item{`usg_overall`: double.}{Player usage of overall offense.}
#'   \item{`usg_pass`: double.}{Player passing usage percentage.}
#'   \item{`usg_rush`: double.}{Player rushing usage percentage.}
#'   \item{`usg_1st_down`: double.}{Player first down usage percentage.}
#'   \item{`usg_2nd_down`: double.}{Player second down usage percentage.}
#'   \item{`usg_3rd_down`: double.}{Player third down usage percentage.}
#'   \item{`usg_standard_downs`: double.}{Player standard down usage percentage.}
#'   \item{`usg_passing_downs`: double.}{Player passing down usage percentage.}
#' }
#' @keywords Player Usage
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom purrr map_if
#' @importFrom dplyr as_tibble rename
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_player_usage(year = 2019, position = "WR", team = "Florida State"))
#' }
#'
cfbd_player_usage <- function(year = most_recent_cfb_season(),
                              team = NULL,
                              conference = NULL,
                              position = NULL,
                              athlete_id = NULL,
                              excl_garbage_time = FALSE) {

  # Validation Lists ----
  pos_groups <- c(
    "QB", "RB", "FB", "TE", "WR", "OL", "OT", "G", "OC",
    "DB", "CB", "S", "LB", "DE", "NT", "DL", "DT",
    "K", "P", "PK", "LS"
  )

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_list(position, pos_groups)
  validate_id(athlete_id)
  validate_list(excl_garbage_time, c(T,F))

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/player/usage?"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference,
    "position" = position,
    "athleteID" = athlete_id,
    "excludeGarbageTime" = excl_garbage_time
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
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        dplyr::rename(
          "athlete_id" = "id",
          "usg_overall" = "usage.overall",
          "usg_pass" = "usage.pass",
          "usg_rush" = "usage.rush",
          "usg_1st_down" = "usage.firstDown",
          "usg_2nd_down" = "usage.secondDown",
          "usg_3rd_down" = "usage.thirdDown",
          "usg_standard_downs" = "usage.standardDowns",
          "usg_passing_downs" = "usage.passingDowns"
        )


      df <- df %>%
        make_cfbfastR_data("Player usage data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player usage data available!"))
    },
    finally = {
    }
  )
  return(df)
}
