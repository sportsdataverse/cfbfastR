
#' @name cfbd_recruiting
#' @aliases cfbd_recruiting recruiting
#' @title
#' **CFB Recruiting Endpoint Overview**
#' @description
#' \describe{
#'   \item{`cfbd_recruiting_player()`:}{ Get college football player recruiting information for a single year with filters available for team, recruit type, state and position.}
#'
#'   \item{`cfbd_recruiting_position()`:}{ Get college football position group recruiting information .}
#'
#'   \item{`cfbd_recruiting_team()`:}{ Get college football recruiting team rankings information.}
#' }
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
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*) - Minimum: 2000, Maximum: 2020 currently
#' @param team (*String* optional): D-I Team
#' @param recruit_type (*String* optional): default API return is 'HighSchool', other options include 'JUCO'
#' or 'PrepSchool'  - For position group information
#' @param state (*String* optional): Two letter State abbreviation
#' @param position (*String* optional): Position Group  - options include:
#'  * Offense: 'PRO', 'DUAL', 'RB', 'FB', 'TE',  'OT', 'OG', 'OC', 'WR'
#'  * Defense: 'CB', 'S', 'OLB', 'ILB', 'WDE', 'SDE', 'DT'
#'  * Special Teams: 'K', 'P'
#'
#' @return [cfbd_recruiting_player()] - A data frame with 14 variables:
#' \describe{
#'   \item{`id`: integer.}{Referencing id - 247Sports.}
#'   \item{`athlete_id`}{Athlete referencing id.}
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
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom janitor clean_names
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

  # Position Group vector to check arguments against
  pos_groups <- c(
    "PRO", "DUAL", "RB", "FB", "TE", "OT", "OG", "OC", "WR",
    "CB", "S", "OLB", "ILB", "WDE", "SDE", "DT", "K", "P"
  )
  # Check if year is numeric
  if(!is.numeric(year) && nchar(year) != 4){
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
  if (!(recruit_type %in% c("HighSchool","PrepSchool", "JUCO"))) {
    # Check if recruit_type is appropriate, if not HighSchool
    cli::cli_abort("Enter valid recruit_type (String): HighSchool, PrepSchool, or JUCO")
  }
  if (!is.null(state) && nchar(state) != 2) {
    ## check if state is length 2
    cli::cli_abort("Enter valid 2-letter State abbreviation")
  }
  if (!is.null(position) && !(position %in% pos_groups)) {
    ## check if position in position group set
    cli::cli_abort("Enter valid position group \nOffense: PRO, DUAL, RB, FB, TE, OT, OG, OC, WR\nDefense: CB, S, OLB, ILB, WDE, SDE, DT\nSpecial Teams: K, P")
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

  df <- data.frame()
  tryCatch(
    expr = {

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
#' \describe{
#'   \item{`team`: character.}{Recruiting team.}
#'   \item{`conference`: character.}{Recruiting team conference.}
#'   \item{`position_group`: character.}{Position group of the recruits.}
#'   \item{`avg_rating`: double.}{Average rating of the recruits in the position group.}
#'   \item{`total_rating`: double.}{Sum of the ratings of the recruits in the position group.}
#'   \item{`commits`: integer.}{Number of commits in the position group.}
#'   \item{`avg_stars`: double.}{Average stars of the recruits in the position group.}
#' }
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr rename
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
  if(!is.null(start_year)&& !is.numeric(start_year) && nchar(start_year) != 4){
    cli::cli_abort("Enter valid start_year as a number (YYYY)")
  }
  if(!is.null(end_year)&& !is.numeric(end_year) && nchar(end_year) != 4){
    cli::cli_abort("Enter valid end_year as a number (YYYY)")
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

  df <- data.frame()
  tryCatch(
    expr = {

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
#' @param year (*Integer* optional): Recruiting Class Year, 4 digit format (*YYYY*). *Note: 2000 is the minimum value*
#' @param team (*String* optional): Team - Select a valid team, D1 football
#'
#' @return [cfbd_recruiting_team()] - A data frame with 4 variables:
#' \describe{
#'   \item{`year`: integer.}{Recruiting class year.}
#'   \item{`rank`: integer.}{Team Recruiting rank.}
#'   \item{`team`: character.}{Recruiting Team.}
#'   \item{`points`: character.}{Team talent points.}
#' }
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
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

  # Check if year is numeric
  if(!is.numeric(year) && nchar(year) != 4){
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
#' @return [cfbd_recruiting_transfer_portal()] - A data frame with 11 variables:
#' \describe{
#'   \item{`season`:integer}{Season of transfer.}
#'   \item{`first_name`:character.}{Player's first name.}
#'   \item{`last_name`:character.}{Player's last name.}
#'   \item{`position`:character.}{Player position.}
#'   \item{`origin`:character.}{original team.}
#'   \item{`destination`:character.}{new team.}
#'   \item{`transfer_date`:character.}{Date of transfer.}
#'   \item{`rating`:character.}{Player's 247 transfer rating.}
#'   \item{`stars`:integer}{Player's star rating.}
#'   \item{`eligibilty`:character.}{Player's eligibilty status.}
#' }
#' @keywords Recruiting
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
#'   try(cfbd_recruiting_transfer_portal(year = 2021))
#' }
cfbd_recruiting_transfer_portal <- function(year) {

  # Check if year is numeric
  if(!is.null(year) && !is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  base_url <- "https://api.collegefootballdata.com/player/portal?"

  # Create full url using base and input arguments
  full_url <- paste0(
    base_url,
    "year=", year
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  df <- data.frame()
  tryCatch(
    expr = {

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
