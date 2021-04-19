#' @name cfbd_teams
#' @aliases cfbd_team_info cfbd_team_matchup_records cfbd_team_matchup cfbd_team_roster cfbd_team_talent
#' @title CFBD Teams Endpoint
#' @description 
#' \describe{
#' \item{`cfbd_team_info()`: Team Info Lookup}
#' \item{`cfbd_team_matchup_records()`: Get matchup history records between two teams.}
#' \item{`cfbd_team_matchup()`: Get matchup history between two teams.}
#' \item{`cfbd_team_talent()`: Get composite team talent rankings for all teams in a given year}
#' }
#' Team Info Lookup
#' Lists all teams in conference or all D-I teams if conference is left NULL
#' Currently, support is only provided for D-I
#'
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC,\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param only_fbs (\emph{Logical} default TRUE): Filter for only returning FBS teams for a given year.\cr
#' If year is left blank while only_fbs is TRUE, then will return values for most current year
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY}). Filter for getting a list of major division team for a given year
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return [cfbd_team_info()] - A data frame with 12 variables:
#' \describe{
#'   \item{`team_id`: integer.}
#'   \item{`school`: character.}
#'   \item{`mascot`: character.}
#'   \item{`abbreviation`: character.}
#'   \item{`alt_name1`: character.}
#'   \item{`alt_name2`: character.}
#'   \item{`alt_name3`: character.}
#'   \item{`conference`: character.}
#'   \item{`division`: character.}
#'   \item{`color`: character.}
#'   \item{`alt_color`: character.}
#'   \item{`logo_1`: character.}
#'   \item{`logo_2`: character.}
#'   \item{`venue_id`: character.}
#'   \item{`venue_name`: character.}
#'   \item{`city`: character.}
#'   \item{`state`: character.}
#'   \item{`zip`: character.}
#'   \item{`country_code`: character.}
#'   \item{`timezone`: character.}
#'   \item{`latitude`: character.}
#'   \item{`longitude`: character.}
#'   \item{`elevation`: character.}
#'   \item{`capacity`: character.}
#'   \item{`year_constructed`: character.}
#'   \item{`grass`: character.}
#'   \item{`dome`: character.}
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
#' \donttest{
#' cfbd_team_info(conference = "SEC")
#'
#' cfbd_team_info(conference = "Ind")
#'
#' cfbd_team_info(year = 2019)
#' }
#'
cfbd_team_info <- function(conference = NULL, only_fbs = TRUE, year = NULL,
                           verbose = FALSE) {
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #             msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
    
  
  
  base_url <- "https://api.collegefootballdata.com/teams?"

  full_url <- paste0(
    base_url,
    "conference=", conference
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

  # Get the content and return it as data.frame
  df <- res %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON() 
  locs <- df$location
  locs <- locs %>% 
    jsonlite::flatten()
  df <- df %>% select(-.data$location)
  # suppressWarnings(
  #   logos_list <- df %>% 
  #     dplyr::group_by(.data$id) %>% 
  #     tidyr::separate(.data$logos, c("logo_1","logo_2"), sep = ',') %>% 
  #     dplyr::mutate(
  #       logo_1 = stringr::str_remove(.data$logo_1, "c\\("),
  #       logo_1 = ifelse(.data$logo_1 == 'NULL', NA_character_, .data$logo_1),
  #       logo_2 = stringr::str_remove(.data$logo_2,"\\)"),
  #       logo_2 = ifelse(.data$logo_2 == 'NULL', NA_character_, .data$logo_2),
  #     )
  # 
  # )
  df <- dplyr::bind_cols(df, locs) %>% 
    dplyr::rename(
      team_id = .data$id,
      venue_name = .data$name) %>%
    as.data.frame()
    
    return(df)
  } else {
    if (!is.null(year)) {
      # Check if year is numeric, if not NULL
      assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
        msg = "Enter valid year as a number (YYYY)"
      )
    }

    base_url <- "https://api.collegefootballdata.com/teams/fbs?"

    # if they want all fbs
    full_url <- paste0(
      base_url,
      "year=", year
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


    # Get the content and return it as data.frame
    df <- res %>%
      httr::content(as = "text", encoding = "UTF-8") %>%
      jsonlite::fromJSON() 
    locs <- df$location
    locs <- locs %>% 
      jsonlite::flatten()
    df <- df %>% select(-.data$location)
    # suppressWarnings(
    #   logos_list <- df %>% 
    #     dplyr::group_by(.data$id) %>% 
    #     tidyr::separate(.data$logos, c("logo_1","logo_2"), sep = ',') %>% 
    #     dplyr::mutate(
    #       logo_1 = stringr::str_remove(.data$logo_1, "c\\("),
    #       logo_1 = ifelse(.data$logo_1 == 'NULL', NA_character_, .data$logo_1),
    #       logo_2 = stringr::str_remove(.data$logo_2,"\\)"),
    #       logo_2 = ifelse(.data$logo_2 == 'NULL', NA_character_, .data$logo_2),
    #     )
    #   
    # )
    df <- dplyr::bind_cols(df, locs) %>% 
      dplyr::rename(
        team_id = .data$id,
        venue_name = .data$name) %>%
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
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return [cfbd_team_matchup_records()] - A data frame with 7 variables:
#' \describe{
#'   \item{`start_year`: character.}
#'   \item{`end_year`: character.}
#'   \item{`team1`: character.}
#'   \item{`team1_wins`: character.}
#'   \item{`team2`: character.}
#'   \item{`team2_wins`: character.}
#'   \item{`ties`: character.}
#' }
#' @source \url{https://api.collegefootballdata.com/teams/matchup}
#' @keywords Team Matchup Records
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
#' \donttest{
#' cfbd_team_matchup_records("Texas", "Oklahoma")
#'
#' cfbd_team_matchup_records("Texas A&M", "TCU", min_year = 1975)
#' }
#'
cfbd_team_matchup_records <- function(team1, team2, min_year = NULL, max_year = NULL,
                                      verbose = FALSE) {

  if (!is.null(min_year)) {
    # Check if min_year is numeric, if not NULL
    assertthat::assert_that(is.numeric(min_year) & nchar(min_year) == 4,
      msg = "Enter valid min_year as a number (YYYY)"
    )
  }
  if (!is.null(max_year)) {
    # Check if max_year is numeric, if not NULL
    assert_that(is.numeric(max_year) & nchar(max_year) == 4,
      msg = "Enter valid max_year as a number (YYYY)"
    )
  }

  if (!is.null(team1)) {
    if (team1 == "San Jose State") {
      team1 <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team1 parameter for URL if not NULL
      team1 <- utils::URLencode(team1, reserved = TRUE)
    }
  }
  if (!is.null(team1)) {
    if (team2 == "San Jose State") {
      team2 <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team2 parameter for URL if not NULL
      team2 <- utils::URLencode(team2, reserved = TRUE)
    }
  }

  base_url <- "https://api.collegefootballdata.com/teams/matchup?"

  full_url <- paste0(
    base_url,
    "team1=", team1,
    "&team2=", team2,
    "&minYear=", min_year,
    "&maxYear=", max_year
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
        jsonlite::fromJSON()
      df1 <- tibble::enframe(unlist(df, use.names = TRUE))[1:7, ]
      df <- tidyr::pivot_wider(df1,
        names_from = .data$name,
        values_from = .data$value
      ) %>%
        dplyr::rename(
          start_year = .data$startYear,
          end_year = .data$endYear,
          team1_wins = .data$team1Wins,
          team2_wins = .data$team2Wins
        ) %>%
        dplyr::select(
          .data$start_year, .data$end_year,
          .data$team1, .data$team1_wins,
          .data$team2, .data$team2_wins,
          .data$ties
        )
      df <- as.data.frame(df)

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping team matchup records..."))
      }
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
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return [cfbd_team_matchup] - A data frame with 11 variables:
#' \describe{
#'   \item{`season`: integer.}
#'   \item{`week`: integer.}
#'   \item{`season_type`: character.}
#'   \item{`date`: character.}
#'   \item{`neutral_site`: logical.}
#'   \item{`venue`: character.}
#'   \item{`home_team`: character.}
#'   \item{`home_score`: integer.}
#'   \item{`away_team`: character.}
#'   \item{`away_score`: integer.}
#'   \item{`winner`: character.}
#' }
#' @source \url{https://api.collegefootballdata.com/teams/matchup}
#' @keywords Team Matchup
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#' cfbd_team_matchup("Texas", "Oklahoma")
#'
#' cfbd_team_matchup("Texas A&M", "TCU")
#'
#' cfbd_team_matchup("Texas A&M", "TCU", min_year = 1975)
#'
#' cfbd_team_matchup("Florida State", "Florida", min_year = 1975)
#' }
#'
cfbd_team_matchup <- function(team1, team2, min_year = NULL, max_year = NULL,
                              verbose = FALSE) {
  
  if (!is.null(min_year)) {
    # Check if min_year is numeric, if not NULL
    assertthat::assert_that(is.numeric(min_year) & nchar(min_year) == 4,
      msg = "Enter valid min_year as a number (YYYY)"
    )
  }
  if (!is.null(max_year)) {
    # Check if max_year is numeric, if not NULL
    assertthat::assert_that(is.numeric(max_year) & nchar(max_year) == 4,
      msg = "Enter valid max_year as a number (YYYY)"
    )
  }

  if (!is.null(team1)) {
    if (team1 == "San Jose State") {
      team1 <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team1 parameter for URL if not NULL
      team1 <- utils::URLencode(team1, reserved = TRUE)
    }
  }
  if (!is.null(team1)) {
    if (team2 == "San Jose State") {
      team2 <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team2 parameter for URL if not NULL
      team2 <- utils::URLencode(team2, reserved = TRUE)
    }
  }

  base_url <- "https://api.collegefootballdata.com/teams/matchup?"

  full_url <- paste0(
    base_url,
    "team1=", team1,
    "&team2=", team2,
    "&minYear=", min_year,
    "&maxYear=", max_year
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
        jsonlite::fromJSON()$games
      if (nrow(df) == 0) {
        if(verbose){ 
          warning("The data pulled from the API was empty.")
        }
        return(NULL)
      }
      df <- df %>%
        janitor::clean_names() %>%
        as.data.frame()

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping team matchup..."))
      }
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
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#'
#' @return [cfbd_team_roster()] - A data frame with 12 variables:
#' \describe{
#'   \item{`athlete_id`: character.}
#'   \item{`first_name`: character.}
#'   \item{`last_name`: character.}
#'   \item{`team`: character.}
#'   \item{`weight`: integer.}
#'   \item{`height`: integer.}
#'   \item{`jersey`: integer.}
#'   \item{`year`: integer.}
#'   \item{`position`: character.}
#'   \item{`home_city`: character.}
#'   \item{`home_state`: character.}
#'   \item{`home_country`: character.}
#'   \item{`home_latitude`: numeric.}
#'   \item{`home_longitude`: number.}
#'   \item{`home_county_fips`: integer.}
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
#' \donttest{
#' cfbd_team_roster(year = 2013, team = "Florida State")
#' }
#'
cfbd_team_roster <- function(year, team = NULL,
                             verbose = FALSE) {
  team2 <- team

  # check if year is numeric
  assert_that(is.numeric(year) & nchar(year) == 4,
    msg = "Enter valid year as a number (YYYY)"
  )


  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team1 parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  base_url <- "https://api.collegefootballdata.com/roster?"

  if (is.null(team)) {
    full_url <- paste0(
      base_url,
      "year=", year
    )
  } else {
    full_url <- paste0(
      base_url, "team=", team,
      "&year=", year
    )
  }

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
        dplyr::rename(athlete_id = .data$id) %>%
        # Is this okay to just comment out?
        # Changing to team = NULL deleted the column
        # dplyr::mutate(team = team2) %>%
        as.data.frame()

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping team roster..."))
      }
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
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return [cfbd_team_talent()] - A data frame with 3 variables:
#' \describe{
#'   \item{`year`: integer.}
#'   \item{`school`: character.}
#'   \item{`talent`: double.}
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
#' \donttest{
#' cfbd_team_talent()
#'
#' cfbd_team_talent(year = 2018)
#' }
#'
cfbd_team_talent <- function(year = NULL,
                             verbose = FALSE) {
  if (!is.null(year)) {
    ## check if year is numeric
    assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year as a number (YYYY)"
    )
  }

  base_url <- "https://api.collegefootballdata.com/talent?"

  full_url <- paste0(
    base_url,
    "year=", year
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
        as.data.frame() %>%
        mutate(talent = as.numeric(.data$talent))

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping team talent..."))
      }
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
