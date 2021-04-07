#' CFBD Players Endpoint
#' @name cfbd_players
NULL
#' Player Information Search
#' @rdname cfbd_players
#'
#' @param search_term (\emph{String} required): Search term for the player you are trying to look up
#' @param position (\emph{string} optional): Position of the player you are searching for.\cr
#' Position Group  - options include:\cr
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR\cr
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL\cr
#'  * Special Teams: K, P, LS, PK
#' @param team (\emph{String} optional): Team - Select a valid team, D1 football
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY}).\cr
#' If left NULL, API default will only provide results for most recent year of final rosters: 2020
#' @return \code{\link[cfbfastR:cfbd_player_info]{cfbfastR::cfbd_player_info()}} - A data frame with 12 variables:
#' \describe{
#'   \item{\code{athlete_id}}{character. Unique player identifier `athlete_id`.}
#'   \item{\code{team}}{character. Team of the player.}
#'   \item{\code{name}}{character. Player name.}
#'   \item{\code{first_name}}{character. Player first name.}
#'   \item{\code{last_name}}{character. Player last name.}
#'   \item{\code{weight}}{integer. Player weight.}
#'   \item{\code{height}}{integer. Player height.}
#'   \item{\code{jersey}}{integer. Player jersey number.}
#'   \item{\code{position}}{character. Player position.}
#'   \item{\code{home_town}}{character. Player home town.}
#'   \item{\code{team_color}}{character. Player team color.}
#'   \item{\code{team_color_secondary}}{character. Player team secondary color.}
#' }
#' @source \url{https://api.collegefootballdata.com/player/search}
#' @keywords Players
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \dontrun{
#' cfbd_player_info(search_term = "James", position = "DB", team = "Florida State", year = 2017)
#'
#' cfbd_player_info(search_term = "Lawrence", team = "Clemson")
#' }
#'
cfbd_player_info <- function(search_term,
                             position = NULL,
                             team = NULL,
                             year = NULL) {
  args <- list(search_term = search_term)

  # Check that at search_term input argument is not null
  attempt::stop_if_all(args, is.null,
    msg = "You need to specify at least one argument:\nsearch_term as a string for the player you are trying to look up"
  )

  # Encode search_term parameter for URL
  search_term <- utils::URLencode(search_term, reserved = TRUE)

  # Position Group vector to check input arguments against
  pos_groups <- c(
    "QB", "RB", "FB", "TE", "WR", "OL", "OT", "G", "OC",
    "DB", "CB", "S", "LB", "DE", "NT", "DL", "DT",
    "K", "P", "PK", "LS"
  )

  if (!is.null(position)) {
    ## check if position in position group set
    assertthat::assert_that(position %in% pos_groups,
      msg = "Enter valid position group\nOffense: QB, RB, FB, TE, WR,  OL, G, OT, C\nDefense: DB, CB, S, LB, DL, DE, DT, NT\nSpecial Teams: K, P, LS, PK"
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
  if (!is.null(year)) {
    ## check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year as integer in 4 digit format (YYYY)\n Min: 2000, Max: 2020"
    )
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

  # Check for internet
  check_internet()

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
          athlete_id = .data$id,
          home_town = .data$hometown
        ) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping player info data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player info data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Player Returning Production
#' @rdname cfbd_players
#' @param year (\emph{Integer} required, default 2019): Year, 4 digit format (\emph{YYYY}).
#' @param team (\emph{String} optional): Team - Select a valid team, D1 football
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @return \code{\link[cfbfastR:cfbd_player_returning]{cfbfastR::cfbd_player_returning()}} - A data frame with 15 variables:
#' \describe{
#'   \item{\code{season}}{integer.}
#'   \item{\code{team}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{total_ppa}}{double.}
#'   \item{\code{total_passing_ppa}}{double.}
#'   \item{\code{total_receiving_ppa}}{double.}
#'   \item{\code{total_rushing_ppa}}{double.}
#'   \item{\code{percent_ppa}}{double.}
#'   \item{\code{percent_passing_ppa}}{double.}
#'   \item{\code{percent_receiving_ppa}}{double.}
#'   \item{\code{percent_rushing_ppa}}{double.}
#'   \item{\code{usage}}{double.}
#'   \item{\code{passing_usage}}{double.}
#'   \item{\code{receiving_usage}}{double.}
#'   \item{\code{rushing_usage}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/player/returning}
#' @keywords Returning Production
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @export
#' @examples
#' \dontrun{
#' cfbd_player_returning(year = 2019, team = "Florida State")
#' }
#'
cfbd_player_returning <- function(year = 2019,
                                  team = NULL,
                                  conference = NULL) {
  args <- list(year = year)

  # Check that at search_term input argument is not null
  attempt::stop_if_all(args, is.null,
    msg = "You need to specify at least one argument:\nyear as an integer 4 digit format (YYYY)"
  )


  if (!is.null(year)) {
    ## check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year as integer in 4 digit format (YYYY)\n Min: 2000, Max: 2020"
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
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #             msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
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

  # Check for internet
  check_internet()

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
          total_ppa = .data$totalPPA,
          total_passing_ppa = .data$totalPassingPPA,
          total_receiving_ppa = .data$totalReceivingPPA,
          total_rushing_ppa = .data$totalRushingPPA,
          percent_ppa = .data$percentPPA,
          percent_passing_ppa = .data$percentPassingPPA,
          percent_receiving_ppa = .data$percentReceivingPPA,
          percent_rushing_ppa = .data$percentRushingPPA,
          passing_usage = .data$passingUsage,
          receiving_usage = .data$receivingUsage,
          rushing_usage = .data$rushingUsage
        ) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping returning player data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no returning player data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Player Usage
#' @rdname cfbd_players
#' @param year (\emph{Integer} required, default 2019): Year, 4 digit format (\emph{YYYY}).
#' @param team (\emph{String} optional): Team - Select a valid team, D1 football
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param position (\emph{string} optional): Position of the player you are searching for.\cr
#' Position Group  - options include:\cr
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR\cr
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL\cr
#'  * Special Teams: K, P, LS, PK
#' @param athlete_id (\emph{Integer} optional): Athlete ID filter for querying a single athlete\cr
#' Can be found using the \code{\link[cfbfastR:cfbd_player_info]{cfbfastR::cfbd_player_info()}} function.
#' @param excl_garbage_time (\emph{Logical} default FALSE): Select whether to exclude Garbage Time (TRUE/FALSE)
#' @return \code{\link[cfbfastR:cfbd_player_usage]{cfbfastR::cfbd_player_usage()}} - A data frame with 14 variables:
#' \describe{
#'   \item{\code{season}}{integer.}
#'   \item{\code{athlete_id}}{character.}
#'   \item{\code{name}}{character.}
#'   \item{\code{position}}{character.}
#'   \item{\code{team}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{usg_overall}}{double.}
#'   \item{\code{usg_pass}}{double.}
#'   \item{\code{usg_rush}}{double.}
#'   \item{\code{usg_1st_down}}{double.}
#'   \item{\code{usg_2nd_down}}{double.}
#'   \item{\code{usg_3rd_down}}{double.}
#'   \item{\code{usg_standard_downs}}{double.}
#'   \item{\code{usg_passing_downs}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/player/usage}
#' @keywords Player Usage
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @importFrom purrr map_if
#' @importFrom dplyr as_tibble rename
#' @export
#' @examples
#' \dontrun{
#' cfbd_player_usage(year = 2019, position = "WR", team = "Florida State")
#' }
#'
cfbd_player_usage <- function(year = 2019,
                              team = NULL,
                              conference = NULL,
                              position = NULL,
                              athlete_id = NULL,
                              excl_garbage_time = FALSE) {
  args <- list(year = year)

  # Check that at search_term input argument is not null
  attempt::stop_if_all(args, is.null,
    msg = "You need to specify at least one argument:\nyear as an integer 4 digit format (YYYY)"
  )

  # Position Group vector to check input arguments against
  pos_groups <- c(
    "QB", "RB", "FB", "TE", "WR", "OL", "OT", "G", "OC",
    "DB", "CB", "S", "LB", "DE", "NT", "DL", "DT",
    "K", "P", "PK", "LS"
  )
  if (!is.null(year)) {
    ## check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year as integer in 4 digit format (YYYY)\n Min: 2000, Max: 2020"
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
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #             msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  if (!is.null(position)) {
    ## check if position in position group set
    assertthat::assert_that(position %in% pos_groups,
      msg = "Enter valid position group\nOffense: QB, RB, FB, TE, WR,  OL, G, OT, C\nDefense: DB, CB, S, LB, DL, DE, DT, NT\nSpecial Teams: K, P, LS, PK"
    )
  }
  if (!is.null(athlete_id)) {
    # Check if athlete_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(athlete_id),
      msg = "Enter valid athlete_id value (Integer)\nCan be found using the `cfbd_player_info()` function"
    )
  }
  if (excl_garbage_time != FALSE) {
    # Check if excl_garbage_time is TRUE, if not FALSE
    assertthat::assert_that(excl_garbage_time == TRUE,
      msg = "Enter valid excl_garbage_time value (Logical) - TRUE or FALSE"
    )
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

  # Check for internet
  check_internet()

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
          athlete_id = .data$id,
          usg_overall = .data$usage.overall,
          usg_pass = .data$usage.pass,
          usg_rush = .data$usage.rush,
          usg_1st_down = .data$usage.firstDown,
          usg_2nd_down = .data$usage.secondDown,
          usg_3rd_down = .data$usage.thirdDown,
          usg_standard_downs = .data$usage.standardDowns,
          usg_passing_downs = .data$usage.passingDowns
        ) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping player usage data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player usage data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
