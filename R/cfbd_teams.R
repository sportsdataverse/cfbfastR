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
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC,
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' Required if year not provided
#' @param only_fbs (*Logical* default TRUE): Filter for only returning FBS teams for a given year.
#' If year is left blank while only_fbs is TRUE, then will return values for most current year
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Filter for getting a list of major division team for a given year. Required if conference not provided
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
#'   \item{`classification`: character.}{Conference classification (fbs,fcs,ii,iii)}
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
#' @importFrom cli cli_abort
#' @importFrom dplyr rename
#' @family CFBD Teams
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_team_info(conference = "SEC"))
#'
#'   try(cfbd_team_info(conference = "Ind"))
#'
#'   try(cfbd_team_info(year = 2019))
#' }
cfbd_team_info <- function(conference = NULL, only_fbs = TRUE, year = most_recent_cfb_season()) {

  # Validation ----
  validate_api_key()
  validate_reqs(conference, year)
  validate_year(year)

  # Query API ----
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL

    base_url <- "https://api.collegefootballdata.com/teams"
    query_params <- list(
      "conference" = conference,
      "year" = year
    )
    full_url <- httr::modify_url(base_url, query=query_params)

  } else {

    base_url <- "https://api.collegefootballdata.com/teams"
    if (only_fbs) base_url <- paste0(base_url,"/fbs")
    query_params <- list(
      "year" = year
    )
    full_url <- httr::modify_url(base_url, query=query_params)

  }

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <-get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()
      locs <- df$location
      locs <- locs %>%
        jsonlite::flatten() %>%
        dplyr::rename("venue_id" = "id")
      df <- df %>% dplyr::select(-"location")
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
        tidyr::unnest_wider("logos",names_sep = "_") %>%
        dplyr::rename(
          "logo" = "logos_1",
          "logo_2" = "logos_2")
      df <- df %>%
        dplyr::rename("alt_name" = "alternateNames") %>%
        tidyr::unnest_wider("alt_name", names_sep = "")
      df <- dplyr::bind_cols(df, locs) %>%
        dplyr::rename(
          "team_id" = "id",
          "venue_name" = "name",
          "alt_color" = "alternateColor",
          "year_constructed" = "constructionYear"
        ) %>%
        janitor::clean_names() %>%
        as.data.frame()



      df <- df %>%
        make_cfbfastR_data("Team information from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team data available!"))
    },
    finally = {
    }
  )
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
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr rename mutate select
#' @importFrom tibble enframe
#' @family CFBD Teams
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_team_matchup_records("Texas", "Oklahoma"))
#'
#'   try(cfbd_team_matchup_records("Texas A&M", "TCU", min_year = 1975))
#' }
#'
cfbd_team_matchup_records <- function(team1, team2, min_year = NULL, max_year = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(min_year)
  validate_year(max_year)

  # Team Name Handling ----
  team1 <- handle_accents(team1)
  team2 <- handle_accents(team2)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/teams/matchup"
  query_params <- list(
    "team1" = team1,
    "team2" = team2,
    "minYear" = min_year,
    "maxYear" = max_year
  )
  full_url <- httr::modify_url(base_url, query = query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()
      if (purrr::is_empty(df$games)) stop(call. = F)
      min_season <- min(df$games$season)
      max_season <- max(df$games$season)
      df[['games']] <- NULL
      df <- df %>%
        tibble::as_tibble() %>%
        dplyr::mutate(
          startYear = ifelse(!is.null(min_year), .data$startYear, min_season),
          endYear = ifelse(!is.null(max_year), .data$endYear, max_season)
        ) %>%
        dplyr::rename(
          "start_year" = "startYear",
          "end_year" = "endYear",
          "team1_wins" = "team1Wins",
          "team2_wins" = "team2Wins"
        ) %>%
        dplyr::select(
          "start_year",
          "end_year",
          "team1",
          "team1_wins",
          "team2",
          "team2_wins",
          "ties"
        )
      df <- as.data.frame(df)


      df <- df %>%
        make_cfbfastR_data("Team matchup record from CollegeFootballData.com",Sys.time())
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
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @family CFBD Teams
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_team_matchup("Texas", "Oklahoma"))
#'
#'   try(cfbd_team_matchup("Texas A&M", "TCU"))
#'
#'   try(cfbd_team_matchup("Texas A&M", "TCU", min_year = 1975))
#'
#'   try(cfbd_team_matchup("Florida State", "Florida", min_year = 1975))
#' }
#'
cfbd_team_matchup <- function(team1, team2, min_year = NULL, max_year = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(min_year)
  validate_year(max_year)

  # Team Name Handling ----
  team1 <- handle_accents(team1)
  team2 <- handle_accents(team2)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/teams/matchup"
  query_params <- list(
    "team1" = team1,
    "team2" = team2,
    "minYear" = min_year,
    "maxYear" = max_year
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <-get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        purrr::pluck("games")
      if (is.null(df) || nrow(df) == 0) {
        warning("The data pulled from the API was empty.")
        return(NULL)
      }
      df <- df %>%
        janitor::clean_names() %>%
        as.data.frame()


      df <- df %>%
        make_cfbfastR_data("Team matchup history from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team matchup data available!"))
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
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Teams
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_team_roster(year = 2013, team = "Florida State"))
#' }
#'
cfbd_team_roster <- function(year, team = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/roster"
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
        dplyr::rename("athlete_id" = "id") %>%
        dplyr::mutate(
          headshot_url = paste0("https://a.espncdn.com/i/headshots/college-football/players/full/",.data$athlete_id,".png")) %>%
        as.data.frame()
      df$recruitIds <- lapply(df$recruitIds, function(y){
        if(length(y) == 0) as.integer(0) else y
      })

      df <- df %>%
        janitor::clean_names() %>%
        make_cfbfastR_data("Team roster data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team roster data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get composite team talent rankings for all teams in a given year**
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
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Teams
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_team_talent())
#'
#'   try(cfbd_team_talent(year = 2018))
#' }
#'
cfbd_team_talent <- function(year = most_recent_cfb_season()) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/talent"
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
        jsonlite::fromJSON() %>%
        as.data.frame() %>%
        dplyr::mutate(talent = as.numeric(.data$talent)) %>%
        dplyr::rename("school" = "team")


      df <- df %>%
        make_cfbfastR_data("247sports team talent ratings from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team talent data available!"))
    },
    finally = {
    }
  )
  return(df)
}
