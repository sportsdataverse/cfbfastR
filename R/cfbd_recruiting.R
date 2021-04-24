
#' @name cfbd_recruiting
#' @aliases cfbd_recruiting recruiting cfbd_recruiting_player cfbd_recruiting_position cfbd_recruiting_team
#' @title CFB Recruiting Endpoint
#' @description
#' \describe{
#'   \item{`cfbd_recruiting_player()`:}{Gets CFB recruiting information for a single year with filters available for team, recruit type, state and position.}
#'   
#'   \item{`cfbd_recruiting_position()`:}{CFB Recruiting Information Position Groups.}
#'   
#'   \item{`cfbd_recruiting_team()`:}{CFB Recruiting Information Team Rankings.}
#' }
#' 
#' ```r
#' cfbd_recruiting_player(2018, team = "Texas")
#'
#' cfbd_recruiting_player(2016, recruit_type = "JUCO")
#'
#' cfbd_recruiting_player(2020, recruit_type = "HighSchool", position = "OT", state = "FL")
#' ```
#' 
#' ```r
#' cfbd_recruiting_position(2018, team = "Texas")
#'
#' cfbd_recruiting_position(2016, 2020, team = "Virginia")
#'
#' cfbd_recruiting_position(2015, 2020, conference = "SEC")
#' ```
#' 
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
#' At least one of \strong{year} or \strong{team} must be specified for the function to run
#'
#' If you would like CFB recruiting information for players, please
#' see the [cfbd_recruiting_player()] function
#'
#' If you would like to get CFB recruiting information based on position groups during a
#' time period for all FBS teams, please see the [cfbd_recruiting_position()] function.
#'
#' [cfbd_recruiting_player()] - At least one of \strong{year} or \strong{team} must be specified for the function to run
#'
#' [cfbd_recruiting_position()] - If only start_year is provided, function will get CFB recruiting information based
#' on position groups during that year for all FBS teams.
#'
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
#' @return [cfbd_recruiting_player()] - A data frame with 14 variables:
#' \describe{
#'   \item{`recruit_type`: character.}{High School, Prep School, or Junior College.}
#'   \item{`year`: integer.}{Recruit class year.}
#'   \item{`ranking`: integer.}{Recruit Ranking.}
#'   \item{`name`: character.}{Recruit Name.}
#'   \item{`school`: character.}{School recruit attended.}
#'   \item{`committed_to`: character.}{School the recruit is committed to.}
#'   \item{`position`: character.}{Recruit position.}
#'   \item{`height`: double.}{Recruit height.}
#'   \item{`weight`: integer.}{Recruit weight.}
#'   \item{`stars`: integer.}{Recruit stars.}
#'   \item{`rating`: double.}{247 composite rating.}
#'   \item{`city`: character.}{Hometown of the recruit.}
#'   \item{`state_province`: character.}{Hometown state of the recruit.}
#'   \item{`country`: character.}{Hometown country of the recruit.}
#'   \item{`hometown_info_latitude`: character.}{Hometown latitude.}
#'   \item{`hometown_info_longitude`: character.}{Hometown longitude.}
#'   \item{`hometown_info_fips_code`: character.}{Hometown FIPS code.}
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

#' @rdname cfbd_recruiting
#' @param start_year (\emph{Integer} optional): Start Year, 4 digit format (\emph{YYYY}). \emph{Note: 2000 is the minimum value}
#' @param end_year (\emph{Integer} optional): End Year,  4 digit format (\emph{YYYY}). \emph{Note: 2020 is the maximum value currently}
#' @param team (\emph{String} optional): Team - Select a valid team, D-I football
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return [cfbd_recruiting_position()] - A data frame with 7 variables:
#' \describe{
#'   \item{`team`: character.}{Recruiting team.}
#'   \item{`conference`: character.}{Recruiting team conference.}
#'   \item{`position_group`: character.}{Position group of the recruits.}
#'   \item{`avg_rating`: double.}{Average rating of the recruits in the position group.}
#'   \item{`total_rating`: double.}{Sum of the ratings of the recruits in the position group.}
#'   \item{`commits`: integer.}{Number of commits in the position group.}
#'   \item{`avg_stars`: double.}{Average stars of the recruits in the position group.}
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

#' @rdname cfbd_recruiting
#' @param year (\emph{Integer} optional): Recruiting Class Year, 4 digit format (\emph{YYYY}). \emph{Note: 2000 is the minimum value}
#' @param team (\emph{String} optional): Team - Select a valid team, D1 football
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return [cfbd_recruiting_team()] - A data frame with 4 variables:
#' \describe{
#'   \item{`year`: integer.}{Recruiting class year.}
#'   \item{`rank`: integer.}{Team Recruiting rank.}
#'   \item{`team`: character.}{Recruiting Team.}
#'   \item{`points`: character.}{Team talent points.}
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
