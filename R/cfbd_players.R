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
#' @importFrom utils URLencode
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

  # Encode search_term parameter for URL
  search_term <- utils::URLencode(search_term, reserved = TRUE)

  # Position Group vector to check input arguments against
  pos_groups <- c(
    "QB", "RB", "FB", "TE", "WR", "OL", "OT", "G", "OC",
    "DB", "CB", "S", "LB", "DE", "NT", "DL", "DT",
    "K", "P", "PK", "LS"
  )

  if (!is.null(position)&&!(position %in% pos_groups)) {
    ## check if position in position group set
    cli::cli_abort("Enter valid position group\nOffense: QB, RB, FB, TE, WR,  OL, G, OT, C\nDefense: DB, CB, S, LB, DL, DE, DT, NT\nSpecial Teams: K, P, LS, PK")
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }

  # Check if year is numeric
  if(!is.null(year) && !is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  base_url <- "https://api.collegefootballdata.com/player/search?"

  # Create full url using base and input arguments
  full_url <- paste0(
    base_url,
    "searchTerm=", search_term,
    "&position=", position,
    "&team=", team,
    "&year=", year
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
#' @param year (*Integer* required, default 2019): Year, 4 digit format (*YYYY*).
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
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @export
#' @examples
#' \donttest{
#'    try(cfbd_player_returning(year = 2019, team = "Florida State"))
#' }
#'
cfbd_player_returning <- function(year = 2019,
                                  team = NULL,
                                  conference = NULL) {

  # Check if year is numeric
  if(!is.null(year) && !is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
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

  base_url <- "https://api.collegefootballdata.com/player/returning?"

  # Create full url using base and input arguments
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
#' @param year (*Integer* required, default 2019): Year, 4 digit format (*YYYY*).
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
#' @importFrom utils URLencode
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
cfbd_player_usage <- function(year = 2019,
                              team = NULL,
                              conference = NULL,
                              position = NULL,
                              athlete_id = NULL,
                              excl_garbage_time = FALSE) {

  # Position Group vector to check input arguments against
  pos_groups <- c(
    "QB", "RB", "FB", "TE", "WR", "OL", "OT", "G", "OC",
    "DB", "CB", "S", "LB", "DE", "NT", "DL", "DT",
    "K", "P", "PK", "LS"
  )
  # Check if year is numeric
  if(!is.null(year) && !is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
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
  if (!is.null(position)&&!(position %in% pos_groups)) {
    ## check if position in position group set
    cli::cli_abort("Enter valid position group\nOffense: QB, RB, FB, TE, WR,  OL, G, OT, C\nDefense: DB, CB, S, LB, DL, DE, DT, NT\nSpecial Teams: K, P, LS, PK")
  }
  if (!is.null(athlete_id) && !is.numeric(athlete_id)) {
    # Check if athlete_id is numeric, if not NULL
    cli::cli_abort("Enter valid athlete_id value (Integer)\nCan be found using the `cfbd_player_info()` function")
  }
  if (excl_garbage_time != FALSE && excl_garbage_time!=TRUE) {
    # Check if excl_garbage_time is TRUE, if not FALSE
    cli::cli_abort("Enter valid excl_garbage_time value (Logical) - TRUE or FALSE")
  }

  base_url <- "https://api.collegefootballdata.com/player/usage?"

  # Create full url using base and input arguments
  full_url <- paste0(
    base_url,
    "year=", year,
    "&team=", team,
    "&conference=", conference,
    "&position=", position,
    "&athleteID=", athlete_id,
    "&excludeGarbageTime=", excl_garbage_time
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
