#' CFBD Recruiting Endpoint
#' @name cfbd_recruiting
NULL
#' CFB Recruiting
#'
#' Gets CFB recruiting information for a single year with filters available for team,
#' recruit type, state and position.
#'
#' At least one of \strong{year} or \strong{team} must be specified for the function to run
#'
#' If you would like CFB recruiting information for teams, please see the \code{\link[cfbfastR:cfbd_recruiting_team]{cfbfastR::cfbd_recruiting_team()}}  function
#'
#' If you would like to get cfb recruiting information based on position groups during a
#' time period for all FBS teams, please see the \code{\link[cfbfastR:cfbd_recruiting_position]{cfbfastR::cfbd_recruiting_position()}} function.
#'
#' @rdname cfbd_recruiting
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY}) - Minimum: 2000, Maximum: 2020 currently
#' @param team (\emph{String} optional): D-I Team
#' @param recruit_type (\emph{String} optional): default API return is 'HighSchool', other options include 'JUCO'
#' or 'PrepSchool'  - For position group information
#' @param state (\emph{String} optional): Two letter State abbreviation
#' @param position (\emph{String} optional): Position Group  - options include:\cr
#'  * Offense: 'PRO', 'DUAL', 'RB', 'FB', 'TE',  'OT', 'OG', 'OC', 'WR'\cr
#'  * Defense: 'CB', 'S', 'OLB', 'ILB', 'WDE', 'SDE', 'DT'\cr
#'  * Special Teams: 'K', 'P'
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return \code{\link[cfbfastR:cfbd_recruiting_player]{cfbfastR::cfbd_recruiting_player()}} - A data frame with 14 variables:
#' \describe{
#'   \item{\code{recruit_type}}{character.}
#'   \item{\code{year}}{integer.}
#'   \item{\code{ranking}}{integer.}
#'   \item{\code{name}}{character.}
#'   \item{\code{school}}{character.}
#'   \item{\code{committed_to}}{character.}
#'   \item{\code{position}}{character.}
#'   \item{\code{height}}{double.}
#'   \item{\code{weight}}{integer.}
#'   \item{\code{stars}}{integer.}
#'   \item{\code{rating}}{double.}
#'   \item{\code{city}}{character.}
#'   \item{\code{state_province}}{character.}
#'   \item{\code{country}}{character.}
#'   \item{\code{hometown_info_latitude}}{character.}
#'   \item{\code{hometown_info_longitude}}{character.}
#'   \item{\code{hometown_info_fips_code}}{character.}
#' }
#' @source \url{https://api.collegefootballdata.com/recruiting/players}
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @export
#' @examples
#' \donttest{
#'    cfbd_recruiting_player(2018, team = "Texas")
#'
#'    cfbd_recruiting_player(2016, recruit_type = "JUCO")
#'
#'    cfbd_recruiting_player(2020, recruit_type = "HighSchool", position = "OT", state = "FL")
#' }
#'
cfbd_recruiting_player <- function(year = NULL,
                                   team = NULL,
                                   recruit_type = "HighSchool",
                                   state = NULL,
                                   position = NULL,
                                   verbose = FALSE) {
  
  # Position Group vector to check arguments against
  pos_groups <- c(
    "PRO", "DUAL", "RB", "FB", "TE", "OT", "OG", "OC", "WR",
    "CB", "S", "OLB", "ILB", "WDE", "SDE", "DT", "K", "P"
  )
  if (!is.null(year)) {
    ## check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year as a number (YYYY) - Min: 2000, Max: 2020"
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
  if (recruit_type != "HighSchool") {
    # Check if recruit_type is appropriate, if not HighSchool
    assertthat::assert_that(recruit_type %in% c("PrepSchool", "JUCO"),
      msg = "Enter valid recruit_type (String): HighSchool, PrepSchool, or JUCO"
    )
  }
  if (!is.null(state)) {
    ## check if state is length 2
    assertthat::assert_that(nchar(state) == 2,
      msg = "Enter valid 2-letter State abbreviation"
    )
  }
  if (!is.null(position)) {
    ## check if position in position group set
    assertthat::assert_that(position %in% pos_groups,
      msg = "Enter valid position group \nOffense: PRO, DUAL, RB, FB, TE, OT, OG, OC, WR\nDefense: CB, S, OLB, ILB, WDE, SDE, DT\nSpecial Teams: K, P"
    )
  }

  base_url <- "https://api.collegefootballdata.com/recruiting/players?"

  # Create full url using base and input arguments
  full_url <- paste0(
    base_url,
    "year=", year,
    "&team=", team,
    "&classification=", recruit_type,
    "&position=", position,
    "&state=", state
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
        jsonlite::fromJSON(flatten=TRUE) %>%
        janitor::clean_names() %>% 
        as.data.frame()

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping player recruiting data..."))
      }
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no player recruiting data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

#' CFB Recruiting Information Position Groups
#'
#' If only start_year is provided, function will get CFB recruiting information based
#' on position groups during that year for all FBS teams.
#'
#' If you would like CFB recruiting information for players, please
#' see the \code{\link[cfbfastR:cfbd_recruiting_player]{cfbfastR::cfbd_recruiting_player()}} function
#'
#' If you would like CFB recruiting information for teams, please
#' see the \code{\link[cfbfastR:cfbd_recruiting_team]{cfbfastR::cfbd_recruiting_team()}} function
#'
#' @rdname cfbd_recruiting
#' @param start_year (\emph{Integer} optional): Start Year, 4 digit format (\emph{YYYY}). \emph{Note: 2000 is the minimum value}
#' @param end_year (\emph{Integer} optional): End Year,  4 digit format (\emph{YYYY}). \emph{Note: 2020 is the maximum value currently}
#' @param team (\emph{String} optional): Team - Select a valid team, D-I football
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return \code{\link[cfbfastR:cfbd_recruiting_position]{cfbfastR::cfbd_recruiting_position()}} - A data frame with 7 variables:
#' \describe{
#'   \item{\code{team}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{position_group}}{character.}
#'   \item{\code{avg_rating}}{double.}
#'   \item{\code{total_rating}}{double.}
#'   \item{\code{commits}}{integer.}
#'   \item{\code{avg_stars}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/recruiting/groups}
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @export
#' @examples
#' \donttest{
#'    cfbd_recruiting_position(2018, team = "Texas")
#'
#'    cfbd_recruiting_position(2016, 2020, team = "Virginia")
#'
#'    cfbd_recruiting_position(2015, 2020, conference = "SEC")
#' }
#'
cfbd_recruiting_position <- function(start_year = NULL, end_year = NULL,
                                     team = NULL, conference = NULL,
                                     verbose = FALSE) {
  if (!is.null(start_year)) {
    # check if start_year is numeric
    assertthat::assert_that(is.numeric(start_year) & nchar(start_year) == 4,
      msg = "Enter valid start_year as a number (YYYY) - Min: 2000, Max: 2020"
    )
  }
  if (!is.null(end_year)) {
    # check if end_year is numeric
    assertthat::assert_that(is.numeric(end_year) & nchar(end_year) == 4,
      msg = "Enter valid end_year as a number (YYYY) - Min: 2000, Max: 2020"
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
    #                         msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }

  base_url <- "https://api.collegefootballdata.com/recruiting/groups?"

  # Create full url using base and input arguments
  full_url <- paste0(
    base_url,
    "startYear=",
    start_year,
    "&endYear=",
    end_year,
    "&team=",
    team,
    "&conference=",
    conference
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
          position_group = .data$positionGroup,
          avg_rating = .data$averageRating,
          total_rating = .data$totalRating,
          avg_stars = .data$averageStars
        ) %>%
        as.data.frame()

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping position group recruiting data..."))
      }
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no position group recruiting data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

#' CFB Recruiting Information Team Rankings
#'
#' Gets CFB team recruiting ranks with filters available for year and team.
#' At least one of \strong{year} or \strong{team} must be specified for the function to run
#'
#' If you would like CFB recruiting information for players, please
#' see the \code{\link[cfbfastR:cfbd_recruiting_player]{cfbfastR::cfbd_recruiting_player()}} function
#'
#' If you would like to get CFB recruiting information based on position groups during a
#' time period for all FBS teams, please see the \code{\link[cfbfastR:cfbd_recruiting_position]{cfbfastR::cfbd_recruiting_position()}} function.
#'
#' @rdname cfbd_recruiting
#' @param year (\emph{Integer} optional): Recruiting Class Year, 4 digit format (\emph{YYYY}). \emph{Note: 2000 is the minimum value}
#' @param team (\emph{String} optional): Team - Select a valid team, D1 football
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return \code{\link[cfbfastR:cfbd_recruiting_team]{cfbfastR::cfbd_recruiting_team()}} - A data frame with 4 variables:
#' \describe{
#'   \item{\code{year}}{integer.}
#'   \item{\code{rank}}{integer.}
#'   \item{\code{team}}{character.}
#'   \item{\code{points}}{character.}
#' }
#' @source \url{https://api.collegefootballdata.com/recruiting/teams}
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#' cfbd_recruiting_team(2018, team = "Texas")
#'
#' cfbd_recruiting_team(2016, team = "Virginia")
#'
#' cfbd_recruiting_team(2016, team = "Texas A&M")
#'
#' cfbd_recruiting_team(2011)
#' }
#'
cfbd_recruiting_team <- function(year = NULL,
                                 team = NULL,
                                 verbose = FALSE) {
  
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

  base_url <- "https://api.collegefootballdata.com/recruiting/teams?"

  # Create full url using base and input arguments
  full_url <- paste0(
    base_url,
    "year=", year,
    "&team=", team
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
        as.data.frame()

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping team recruiting data..."))
      }
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no team recruiting data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
