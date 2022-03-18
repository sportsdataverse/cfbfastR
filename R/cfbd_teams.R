#' @name cfbd_teams
#' @title
#' **CFBD Teams Endpoint Overview**
#' @description
#' \describe{
#' \item{`cfbd_team_info()`:}{ Team Info Lookup.}
#' \item{`cfbd_team_roster()`:}{ Get a team's full roster by year.}
#' \item{`cfbd_team_talent()`:}{ Get composite team talent rankings for all teams in a given year.}
#' \item{`cfbd_team_matchup_records()`:}{ Get matchup history records between two teams.}
#' \item{`cfbd_team_matchup()`:}{ Get matchup history between two teams.}
#' }
#' ## **Team info lookup**
#'
#' Lists all teams in conference or all D-I teams if conference is left NULL
#' Currently, support is only provided for D-I
#'
#' ```r
#' cfbd_team_info(conference = "SEC")
#'
#' cfbd_team_info(conference = "Ind")
#'
#' cfbd_team_info(year = 2019)
#' ```
#' ## **Get team rosters**
#'
#' ### **It is now possible to access yearly rosters**
#' ```r
#' cfbd_team_roster(year = 2020)
#' ```
#'
#' ### Get a teams full roster by year. If team is not selected, API returns rosters for every team from the selected year.
#' ```r
#' cfbd_team_roster(year = 2013, team = "Florida State")
#' ```
#'
#' ### Get composite team talent rankings
#'
#' Extracts team talent composite for all teams in a given year as sourced from 247 rankings
#' ```r
#' cfbd_team_talent()
#'
#' cfbd_team_talent(year = 2018)
#'
#' ```
#' ### **Get matchup history between two teams.**
#' ```r
#' cfbd_team_matchup("Texas A&M", "TCU")
#'
#' cfbd_team_matchup("Texas A&M", "TCU", min_year = 1975)
#'
#' cfbd_team_matchup("Florida State", "Florida", min_year = 1975)
#' ```
#' ### **Get matchup history records between two teams.**
#' ```r
#' cfbd_team_matchup_records("Texas", "Oklahoma")
#'
#' cfbd_team_matchup_records("Texas A&M", "TCU", min_year = 1975)
#' ```
NULL
#' @title
#' **Team info lookup**
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC,\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param only_fbs (*Logical* default TRUE): Filter for only returning FBS teams for a given year.\cr
#' If year is left blank while only_fbs is TRUE, then will return values for most current year
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Filter for getting a list of major division team for a given year
#' @return [cfbd_team_info()] - A data frame with 12 variables:
#' \describe{
#'   \item{`team_id`: integer.}{Referencing team id.}
#'   \item{`school`: character.}{Team name.}
#'   \item{`mascot`: character.}{Team mascot.}
#'   \item{`abbreviation`: character.}{Team abbreviations.}
#'   \item{`alt_name1`: character.}{Team alternate name 1 (as it appears in `play_text`).}
#'   \item{`alt_name2`: character.}{Team alternate name 2 (as it appears in `play_text`).}
#'   \item{`alt_name3`: character.}{Team alternate name 3 (as it appears in `play_text`).}
#'   \item{`conference`: character.}{Conference of team.}
#'   \item{`division`: character.}{Division of team within the conference.}
#'   \item{`color`: character.}{Team color (primary).}
#'   \item{`alt_color`: character.}{Team color (alternate).}
#'   \item{`logos`: character.}{Team logos.}
#'   \item{`venue_id`: character.}{Referencing venue id.}
#'   \item{`venue_name`: character.}{Stadium name.}
#'   \item{`city`: character.}{Team/venue city.}
#'   \item{`state`: character.}{Team/venue state.}
#'   \item{`zip`: character.}{Team/venue zip code (someone double check Miami (FL) on if they're in the same zip code).}
#'   \item{`country_code`: character.}{Team/venue country code.}
#'   \item{`timezone`: character.}{Team/venue timezone.}
#'   \item{`latitude`: character.}{Venue latitude.}
#'   \item{`longitude`: character.}{Venue longitude.}
#'   \item{`elevation`: character.}{Venue elevation.}
#'   \item{`capacity`: character.}{Venue capacity.}
#'   \item{`year_constructed`: character.}{Year the venue was constructed.}
#'   \item{`grass`: character.}{TRUE/FALSE response on whether the field is grass or not (oh, and there are so many others).}
#'   \item{`dome`: character.}{TRUE/FALSE flag for if the venue is a domed stadium.}
#' }
#' @keywords Teams
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
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
cfbd_team_info <- function(conference = NULL, only_fbs = TRUE, year = NULL) {
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)



    base_url <- "https://api.collegefootballdata.com/teams?"

    full_url <- paste0(
      base_url,
      "conference=", conference
    )

  } else {
    if(!is.null(year) && !is.numeric(year) && nchar(year) != 4){
      cli::cli_abort("Enter valid year as a number (YYYY)")
    }

    base_url <- "https://api.collegefootballdata.com/teams"


    # if they want all fbs
    if (only_fbs) {
      base_url <- paste0(
        base_url,
        "/fbs"
      )
    }
    full_url <- paste0(
      base_url,
      "?year=", year
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
  df <- df %>%
    tidyr::unnest_wider(.data$logos,names_sep = "_") %>%
    dplyr::rename(logo = .data$logos_1,logo_2 = .data$logos_2)
  df <- dplyr::bind_cols(df, locs) %>%
    dplyr::rename(
      team_id = .data$id,
      venue_name = .data$name) %>%
    as.data.frame()



  df <- df %>%
    make_cfbfastR_data("team information from CollegeFootballData.com",Sys.time())
  return(df)
}


#' @title
#' **Get matchup history records between two teams.**
#' @param team1 (*String* required): D-I Team 1
#' @param team2 (*String* required): D-I Team 2
#' @param min_year (*Integer* optional): Minimum of year range, 4 digit format (*YYYY*)
#' @param max_year (*Integer* optional): Maximum of year range, 4 digit format (*YYYY*)
#'
#' @return [cfbd_team_matchup_records()] - A data frame with 7 variables:
#' \describe{
#'   \item{`start_year`: character.}{Span starting year.}
#'   \item{`end_year`: character.}{Span ending year.}
#'   \item{`team1`: character.}{First team selected in query.}
#'   \item{`team1_wins`: character.}{First team wins in series against `team2`.}
#'   \item{`team2`: character.}{Second team selected in query.}
#'   \item{`team2_wins`: character.}{Second team wins in series against `team1`.}
#'   \item{`ties`: character.}{Number of ties in the series.}
#' }
#' @keywords Team Matchup Records
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
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
cfbd_team_matchup_records <- function(team1, team2, min_year = NULL, max_year = NULL) {

  if(!is.null(min_year)&& !is.numeric(min_year) && nchar(min_year) != 4){
    cli::cli_abort("Enter valid min_year as a number (YYYY)")
  }
  if(!is.null(max_year)&& !is.numeric(max_year) && nchar(max_year) != 4){
    cli::cli_abort("Enter valid max_year as a number (YYYY)")
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


      df <- df %>%
        make_cfbfastR_data("matchup record from CollegeFootballData.com",Sys.time())
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


#' @title
#' **Get matchup history between two teams.**
#' @param team1 (*String* required): D-I Team 1
#' @param team2 (*String* required): D-I Team 2
#' @param min_year (*Integer* optional): Minimum of year range, 4 digit format (*YYYY*)
#' @param max_year (*Integer* optional): Maximum of year range, 4 digit format (*YYYY*)
#' @return [cfbd_team_matchup] - A data frame with 11 variables:
#' \describe{
#'   \item{`season`: integer.}{Season the game took place.}
#'   \item{`week`: integer.}{Game week of the season.}
#'   \item{`season_type`: character.}{Season type of the game.}
#'   \item{`date`: character.}{Game date.}
#'   \item{`neutral_site`: logical.}{TRUE/FALSE flag for if the game took place at a neutral site.}
#'   \item{`venue`: character.}{Stadium name.}
#'   \item{`home_team`: character.}{Home team of the game.}
#'   \item{`home_score`: integer.}{Home score in the game.}
#'   \item{`away_team`: character.}{Away team of the game.}
#'   \item{`away_score`: integer.}{Away score in the game.}
#'   \item{`winner`: character.}{Winner of the matchup.}
#' }
#' @keywords Team Matchup
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
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
cfbd_team_matchup <- function(team1, team2, min_year = NULL, max_year = NULL) {

  if(!is.null(min_year)&& !is.numeric(min_year) && nchar(min_year) != 4){
    cli::cli_abort("Enter valid min_year as a number (YYYY)")
  }
  if(!is.null(max_year)&& !is.numeric(max_year) && nchar(max_year) != 4){
    cli::cli_abort("Enter valid max_year as a number (YYYY)")
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
        jsonlite::fromJSON() %>%
        .data$games
      if (nrow(df) == 0) {
          warning("The data pulled from the API was empty.")
        return(NULL)
      }
      df <- df %>%
        janitor::clean_names() %>%
        as.data.frame()


      df <- df %>%
        make_cfbfastR_data("matchup history from CollegeFootballData.com",Sys.time())
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



#' @title
#' **Get team rosters**
#' @description
#' Get a teams full roster by year. If team is not selected, API returns rosters for every team from the selected year.
#'
#' @param year (*Integer* required): Year,  4 digit format (*YYYY*)
#' @param team (*String* optional): Team, select a valid team in D-I football
#'
#' @return [cfbd_team_roster()] - A data frame with 12 variables:
#' \describe{
#'   \item{`athlete_id`: character.}{Referencing athlete id.}
#'   \item{`first_name`: character.}{Athlete first name.}
#'   \item{`last_name`: character.}{Athlete last name.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`weight`: integer.}{Athlete weight.}
#'   \item{`height`: integer.}{Athlete height.}
#'   \item{`jersey`: integer.}{Athlete jersey number.}
#'   \item{`year`: integer.}{Athlete year.}
#'   \item{`position`: character.}{Athlete position.}
#'   \item{`home_city`: character.}{Hometown of the athlete.}
#'   \item{`home_state`: character.}{Hometown state of the athlete.}
#'   \item{`home_country`: character.}{Hometown country of the athlete.}
#'   \item{`home_latitude`: numeric.}{Hometown latitude.}
#'   \item{`home_longitude`: number.}{Hometown longitude.}
#'   \item{`home_county_fips`: integer.}{Hometown FIPS code.}
#'   \item{`headshot_url`: character}{Player ESPN headshot url.}
#' }
#' @keywords Team Roster
#' @importFrom dplyr rename mutate
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#' cfbd_team_roster(year = 2013, team = "Florida State")
#' }
#'
cfbd_team_roster <- function(year, team = NULL) {
  team2 <- team

  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }


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
        dplyr::mutate(headshot_url = paste0("https://a.espncdn.com/i/headshots/college-football/players/full/",.data$athlete_id,".png")) %>%
        as.data.frame()


      df <- df %>%
        make_cfbfastR_data("team roster data from CollegeFootballData.com",Sys.time())
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

#' @title
#' **Get composite team talent rankings for all teams in a given year**\cr
#'
#' @description
#' Extracts team talent composite as sourced from 247 rankings
#' @param year (*Integer* optional): Year 4 digit format (*YYYY*)
#'
#' @return [cfbd_team_talent()] - A data frame with 3 variables:
#' \describe{
#'   \item{`year`: integer.}{Season for the talent rating.}
#'   \item{`school`: character.}{Team name.}
#'   \item{`talent`: double.}{Overall roster talent points (as determined by 247Sports).}
#' }
#' @keywords Team talent
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#' cfbd_team_talent()
#'
#' cfbd_team_talent(year = 2018)
#' }
#'
cfbd_team_talent <- function(year = NULL) {
  if(!is.null(year) && !is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
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


      df <- df %>%
        make_cfbfastR_data("247sports team talent ratings from CollegeFootballData.com",Sys.time())
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
