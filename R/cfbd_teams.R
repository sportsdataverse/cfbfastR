#' CFBD Teams Endpoint
#' @name cfbd_teams
NULL
#' Team Info Lookup
#' Lists all teams in conference or all D-I teams if conference is left NULL
#' Current support only for D-I
#'
#' @rdname cfbd_teams
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC,\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param only_fbs (\emph{Logical} default TRUE): Filter for only returning FBS teams for a given year.\cr
#' If year is left blank while only_fbs is TRUE, then will return values for most current year
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY}). Filter for getting a list of major division team for a given year
#'
#' @return A data frame with 12 variables:
#' \describe{
#'   \item{\code{team_id}}{integer.}
#'   \item{\code{school}}{character.}
#'   \item{\code{mascot}}{character.}
#'   \item{\code{abbreviation}}{character.}
#'   \item{\code{alt_name1}}{character.}
#'   \item{\code{alt_name2}}{character.}
#'   \item{\code{alt_name3}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{division}}{character.}
#'   \item{\code{color}}{character.}
#'   \item{\code{alt_color}}{character.}
#'   \item{\code{logos}}{list.}
#' }
#' @source \url{https://api.collegefootballdata.com/teams}
#' @keywords Teams
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom dplyr rename
#' @export
#' @examples
#' \dontrun{
#'   cfbd_team_info(conference = "SEC")
#'
#'   cfbd_team_info(conference = "Ind")
#'
#'   cfbd_team_info(year = 2019)
#' }

cfbd_team_info <- function(conference = NULL, only_fbs = TRUE, year = NULL) {

  if(!is.null(conference)){
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #             msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference = utils::URLencode(conference, reserved = TRUE)

    base_url <-"https://api.collegefootballdata.com/teams?"

    full_url <- paste0(base_url,
                       "conference=",  conference)
    # Check for internet
    check_internet()

    # Check for CFBD API key
    if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

    # Create the GET request and set response as res
    res <- httr::RETRY("GET", full_url,
                       httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

    # Check the result
    check_status(res)

    # Get the content and return it as data.frame
    df = res %>%
      httr::content(as = "text", encoding = "UTF-8") %>%
      jsonlite::fromJSON() %>%
      dplyr::rename(team_id = .data$id) %>%
      as.data.frame()

    return(df)
  }else{

    if(!is.null(year)){
      # Check if year is numeric, if not NULL
      assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
                              msg='Enter valid year as a number (YYYY)')
    }

    base_url <- "https://api.collegefootballdata.com/teams/fbs?"

    # if they want all fbs
    full_url = paste0(base_url,
                      "year=",year)

    # Check for internet
    check_internet()

    # Check for CFBD API key
    if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

    # Create the GET request and set response as res
    res <- httr::RETRY("GET", full_url,
                       httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

    # Check the result
    check_status(res)


    # Get the content and return it as data.frame
    df = res %>%
      httr::content(as = "text", encoding = "UTF-8") %>%
      jsonlite::fromJSON() %>%
      dplyr::rename(team_id = .data$id) %>%
      as.data.frame()

    return(df)
  }
}


#' Get matchup history records between two teams.
#' @rdname cfbd_teams
#'
#' @param team1 (\emph{String} required): D-I Team 1
#' @param team2 (\emph{String} required): D-I Team 2
#' @param min_year (\emph{Integer} optional): Minimum of year range, 4 digit format (\emph{YYYY})
#' @param max_year (\emph{Integer} optional): Maximum of year range, 4 digit format (\emph{YYYY})
#'
#' @return A data frame with 7 variables:
#' \describe{
#'   \item{\code{start_year}}{character.}
#'   \item{\code{end_year}}{character.}
#'   \item{\code{team1}}{character.}
#'   \item{\code{team1_wins}}{character.}
#'   \item{\code{team2}}{character.}
#'   \item{\code{team2_wins}}{character.}
#'   \item{\code{ties}}{character.}
#' }
#' @source \url{https://api.collegefootballdata.com/teams/matchup}
#' @keywords Team Matchup Records
#' @importFrom attempt stop_if_any
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @importFrom tibble enframe
#' @importFrom dplyr rename mutate select
#' @importFrom tidyr pivot_wider
#' @export
#' @examples
#' \dontrun{
#'   cfbd_team_matchup_records('Texas','Oklahoma')
#'
#'   cfbd_team_matchup_records('Texas A&M','TCU', min_year = 1975)
#' }
#'

cfbd_team_matchup_records <- function(team1, team2, min_year = NULL, max_year = NULL) {

  args <- list(team1 = team1, team2 = team2)

  # Check that any of the required arguments are not NULL
  stop_if_any(args, is.null,
              msg="You need to specify both arguments team1 and team2 in the cfbd_team_matchup function call")

  if(!is.null(min_year)){
    # Check if min_year is numeric, if not NULL
    assertthat::assert_that(is.numeric(min_year) & nchar(min_year) == 4,
                            msg='Enter valid min_year as a number (YYYY)')
  }
  if(!is.null(max_year)){
    # Check if max_year is numeric, if not NULL
    assert_that(is.numeric(max_year) & nchar(max_year) == 4,
                msg='Enter valid max_year as a number (YYYY)')
  }

  if(!is.null(team1)){
    if(team1 == "San Jose State"){
      team1 = utils::URLencode(paste0("San Jos","\u00e9", " State"), reserved = TRUE)
    } else{
      # Encode team1 parameter for URL if not NULL
      team1 = utils::URLencode(team1, reserved = TRUE)
    }
  }
  if(!is.null(team1)){
    if(team2 == "San Jose State"){
      team2 = utils::URLencode(paste0("San Jos","\u00e9", " State"), reserved = TRUE)
    } else{
      # Encode team2 parameter for URL if not NULL
      team2 = utils::URLencode(team2, reserved = TRUE)
    }
  }

  base_url <- "https://api.collegefootballdata.com/teams/matchup?"

  full_url <-paste0(base_url,
                    "team1=", team1,
                    "&team2=", team2,
                    "&minYear=", min_year,
                    "&maxYear=", max_year)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr ={
      # Get the content and return it as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()
      df1<- tibble::enframe(unlist(df,use.names = TRUE))[1:7,]
      df <- tidyr::pivot_wider(df1,
                               names_from = .data$name,
                               values_from = .data$value) %>%
        dplyr::rename(start_year = .data$startYear,
                      end_year = .data$endYear,
                      team1_wins = .data$team1Wins,
                      team2_wins = .data$team2Wins) %>%
        dplyr::select(.data$start_year,.data$end_year,
                      .data$team1,.data$team1_wins,
                      .data$team2,.data$team2_wins,
                      .data$ties)
      df <- as.data.frame(df)

      message(glue::glue("{Sys.time()}: Scraping team matchup records..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team matchup records data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Get matchup history between two teams.
#' @rdname cfbd_teams
#'
#' @param team1 (\emph{String} required): D-I Team 1
#' @param team2 (\emph{String} required): D-I Team 2
#' @param min_year (\emph{Integer} optional): Minimum of year range, 4 digit format (\emph{YYYY})
#' @param max_year (\emph{Integer} optional): Maximum of year range, 4 digit format (\emph{YYYY})
#'
#' @return A data frame with 11 variables:
#' \describe{
#'   \item{\code{season}}{integer.}
#'   \item{\code{week}}{integer.}
#'   \item{\code{season_type}}{character.}
#'   \item{\code{date}}{character.}
#'   \item{\code{neutral_site}}{logical.}
#'   \item{\code{venue}}{character.}
#'   \item{\code{home_team}}{character.}
#'   \item{\code{home_score}}{integer.}
#'   \item{\code{away_team}}{character.}
#'   \item{\code{away_score}}{integer.}
#'   \item{\code{winner}}{character.}
#' }
#' @source \url{https://api.collegefootballdata.com/teams/matchup}
#' @keywords Team Matchup
#' @importFrom attempt stop_if_any
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @export
#' @examples
#' \dontrun{
#'   cfbd_team_matchup('Texas','Oklahoma')
#'
#'   cfbd_team_matchup('Texas A&M','TCU')
#'
#'   cfbd_team_matchup('Texas A&M','TCU', min_year = 1975)
#'
#'   cfbd_team_matchup('Florida State', 'Florida', min_year = 1975)
#' }

cfbd_team_matchup <- function(team1, team2, min_year = NULL, max_year = NULL) {

  args <- list(team1 = team1, team2 = team2)

  # Check that any of the required arguments are not NULL
  stop_if_any(args, is.null,
              msg="You need to specify both arguments team1 and team2 in the cfbd_team_matchup function call")

  if(!is.null(min_year)){
    # Check if min_year is numeric, if not NULL
    assertthat::assert_that(is.numeric(min_year) & nchar(min_year) == 4,
                            msg='Enter valid min_year as a number (YYYY)')
  }
  if(!is.null(max_year)){
    # Check if max_year is numeric, if not NULL
    assertthat::assert_that(is.numeric(max_year) & nchar(max_year) == 4,
                            msg='Enter valid max_year as a number (YYYY)')
  }

  if(!is.null(team1)){
    if(team1 == "San Jose State"){
      team1 = utils::URLencode(paste0("San Jos","\u00e9", " State"), reserved = TRUE)
    } else{
      # Encode team1 parameter for URL if not NULL
      team1 = utils::URLencode(team1, reserved = TRUE)
    }
  }
  if(!is.null(team1)){
    if(team2 == "San Jose State"){
      team2 = utils::URLencode(paste0("San Jos","\u00e9", " State"), reserved = TRUE)
    } else{
      # Encode team2 parameter for URL if not NULL
      team2 = utils::URLencode(team2, reserved = TRUE)
    }
  }

  base_url <- "https://api.collegefootballdata.com/teams/matchup?"

  full_url <-paste0(base_url,
                    "team1=", team1,
                    "&team2=", team2,
                    "&minYear=", min_year,
                    "&maxYear=", max_year)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr ={
      # Get the content and return it as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()$games
      if(nrow(df)==0){
        warning("The data pulled from the API was empty.")
        return(NULL)
      }
      df <- df %>%
        janitor::clean_names() %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping team matchup..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team matchup data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Team Roster
#' Get a teams full roster by year. If team is not selected, API returns rosters for every team from the selected year.
#'
#' @rdname cfbd_teams
#' @param year (\emph{Integer} required): Year,  4 digit format (\emph{YYYY})
#' @param team (\emph{String} optional): Team, select a valid team in D-I football
#'
#'
#' @return A data frame with 12 variables:
#' \describe{
#'   \item{\code{athlete_id}}{character.}
#'   \item{\code{first_name}}{character.}
#'   \item{\code{last_name}}{character.}
#'   \item{\code{weight}}{integer.}
#'   \item{\code{height}}{integer.}
#'   \item{\code{jersey}}{integer.}
#'   \item{\code{year}}{integer.}
#'   \item{\code{position}}{character.}
#'   \item{\code{home_city}}{character.}
#'   \item{\code{home_state}}{character.}
#'   \item{\code{home_country}}{character.}
#'   \item{\code{team}}{character.}
#' }
#' @source \url{https://api.collegefootballdata.com/roster}
#' @keywords Team Roster
#' @importFrom dplyr rename mutate
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @export
#' @examples
#' \dontrun{
#'   cfbd_team_roster(year = 2013, team = "Florida State")
#' }

cfbd_team_roster <- function(year, team = NULL){
  team2 <- team

  # check if year is numeric
  assert_that(is.numeric(year) & nchar(year) == 4,
              msg='Enter valid year as a number (YYYY)')


  if(!is.null(team)){
    if(team == "San Jose State"){
      team = utils::URLencode(paste0("San Jos","\u00e9", " State"), reserved = TRUE)
    } else{
      # Encode team1 parameter for URL if not NULL
      team = utils::URLencode(team, reserved = TRUE)
    }
  }
  base_url <- "https://api.collegefootballdata.com/roster?"

  if(is.null(team)) {
    full_url <- paste0(base_url,
                       "year=", year)
  } else {
    full_url <- paste0(base_url,"team=", team,
                       "&year=", year)
  }

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr ={
      # Get the content and return it as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        dplyr::rename(athlete_id = .data$id) %>%
        # Is this okay to just comment out?
        # Changing to team = NULL deleted the column
        #dplyr::mutate(team = team2) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping team roster..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team roster data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

#' Get composite team talent rankings for all teams in a given year
#' Extracts team talent composite as sourced from 247 rankings
#' @rdname cfbd_teams
#'
#' @param year (\emph{Integer} optional): Year 4 digit format (\emph{YYYY})
#'
#' @return A data frame with 3 variables:
#' \describe{
#'   \item{\code{year}}{integer.}
#'   \item{\code{school}}{character.}
#'   \item{\code{talent}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/talent}
#' @keywords Team talent
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @export
#' @examples
#' \dontrun{
#'   cfbd_team_talent()
#'
#'   cfbd_team_talent(year = 2018)
#' }


cfbd_team_talent <- function(year = NULL) {
  if(!is.null(year)){
    ## check if year is numeric
    assert_that(is.numeric(year) & nchar(year) == 4,
                msg='Enter valid year as a number (YYYY)')
  }

  base_url <- "https://api.collegefootballdata.com/talent?"

  full_url <- paste0(base_url,
                     "year=", year)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr ={
      # Get the content and return it as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        as.data.frame() %>%
        mutate(talent = as.numeric(.data$talent))

      message(glue::glue("{Sys.time()}: Scraping team talent..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team talent data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

