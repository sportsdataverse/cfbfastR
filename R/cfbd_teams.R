#' @name cfbd_teams
#' @title
#' **CFBD Teams Endpoint Overview**
#' @description
#'
#' * `cfbd_team_info()`: Team Info Lookup.
#' * `cfbd_team_roster()`: Get a team's full roster by year.
#' * `cfbd_team_talent()`: Get composite team talent rankings for all teams in a given year.
#' * `cfbd_team_matchup_records()`: Get matchup history records between two teams.
#' * `cfbd_team_matchup()`: Get matchup history between two teams.
#' * `cfbd_teams_fbs()`: Get every FBS team for a season.
#'
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
#'
#' ## **Get FBS teams**
#'
#' ```r
#' cfbd_teams_fbs(year = 2024)
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
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Filter for getting a list of major division team for a given year. Required if conference not provided and the `year` parameter is only supported if `only_fbs` is TRUE.
#' @return [cfbd_team_info()] - A data frame with 27 variables:
#'
#'    |col_name         |types     |description                                                                  |
#'    |:----------------|:---------|:----------------------------------------------------------------------------|
#'    |team_id          |integer   |Referencing team id.                                                         |
#'    |school           |character |Team name.                                                                   |
#'    |mascot           |character |Team mascot.                                                                 |
#'    |abbreviation     |character |Team abbreviations.                                                          |
#'    |alt_name1        |character |Team alternate name 1 (as it appears in `play_text`).                        |
#'    |alt_name2        |character |Team alternate name 2 (as it appears in `play_text`).                        |
#'    |alt_name3        |character |Team alternate name 3 (as it appears in `play_text`).                        |
#'    |conference       |character |Conference of team.                                                          |
#'    |division         |character |Division of team within the conference.                                      |
#'    |classification   |character |Conference classification (fbs, fcs, ii, iii).                               |
#'    |color            |character |Team color (primary).                                                        |
#'    |alt_color        |character |Team color (alternate).                                                      |
#'    |logos            |character |Team logos.                                                                  |
#'    |venue_id         |character |Referencing venue id.                                                        |
#'    |venue_name       |character |Stadium name.                                                                |
#'    |city             |character |Team/venue city.                                                             |
#'    |state            |character |Team/venue state.                                                            |
#'    |zip              |character |Team/venue zip code.                                                         |
#'    |country_code     |character |Team/venue country code.                                                     |
#'    |timezone         |character |Team/venue timezone.                                                         |
#'    |latitude         |numeric   |Venue latitude.                                                              |
#'    |longitude        |numeric   |Venue longitude.                                                             |
#'    |elevation        |numeric   |Venue elevation.                                                             |
#'    |capacity         |integer   |Venue capacity.                                                              |
#'    |year_constructed |integer   |Year the venue was constructed.                                              |
#'    |grass            |logical   |TRUE/FALSE response on whether the field is grass or not.                    |
#'    |dome             |logical   |TRUE/FALSE flag for if the venue is a domed stadium.                         |
#'
#' @keywords Teams
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
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
    full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  } else {

    base_url <- "https://api.collegefootballdata.com/teams"
    if (only_fbs) base_url <- paste0(base_url,"/fbs")
    query_params <- list(
      "year" = year
    )
    full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  }

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <-get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON()
      locs <- df$location
      locs <- locs |>
        jsonlite::flatten() |>
        dplyr::rename("venue_id" = "id")
      df <- df |> dplyr::select(-"location")
      # suppressWarnings(
      #   logos_list <- df |>
      #     dplyr::group_by(.data$id) |>
      #     tidyr::separate(.data$logos, c("logo_1","logo_2"), sep = ',') |>
      #     dplyr::mutate(
      #       logo_1 = stringr::str_remove(.data$logo_1, "c\\("),
      #       logo_1 = ifelse(.data$logo_1 == 'NULL', NA_character_, .data$logo_1),
      #       logo_2 = stringr::str_remove(.data$logo_2,"\\)"),
      #       logo_2 = ifelse(.data$logo_2 == 'NULL', NA_character_, .data$logo_2),
      #     )
      #
      # )
      df <- df |>
        tidyr::unnest_wider("logos",names_sep = "_") |>
        dplyr::rename(
          "logo" = "logos_1",
          "logo_2" = "logos_2")
      df <- df |>
        dplyr::rename("alt_name" = "alternateNames") |>
        tidyr::unnest_wider("alt_name", names_sep = "")
      df <- dplyr::bind_cols(df, locs) |>
        dplyr::rename(
          "team_id" = "id",
          "venue_name" = "name",
          "alt_color" = "alternateColor",
          "year_constructed" = "constructionYear"
        ) |>
        janitor::clean_names() |>
        as.data.frame()



      df <- df |>
        make_cfbfastR_data("Team information from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team data available! {conditionMessage(e)}"))
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
#'
#'    |col_name   |types     |description                              |
#'    |:----------|:---------|:----------------------------------------|
#'    |start_year |integer   |Span starting year.                      |
#'    |end_year   |integer   |Span ending year.                        |
#'    |team1      |character |First team selected in query.            |
#'    |team1_wins |integer   |First team wins in series against team2. |
#'    |team2      |character |Second team selected in query.           |
#'    |team2_wins |integer   |Second team wins in series against team1.|
#'    |ties       |integer   |Number of ties in the series.            |
#'
#' @keywords Team Matchup Records
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
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
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON()
      if (purrr::is_empty(df$games)) stop(call. = F)
      min_season <- min(df$games$season)
      max_season <- max(df$games$season)
      df[['games']] <- NULL
      df <- df |>
        tibble::as_tibble() |>
        dplyr::mutate(
          startYear = ifelse(!is.null(min_year), .data$startYear, min_season),
          endYear = ifelse(!is.null(max_year), .data$endYear, max_season)
        ) |>
        dplyr::rename(
          "start_year" = "startYear",
          "end_year" = "endYear",
          "team1_wins" = "team1Wins",
          "team2_wins" = "team2Wins"
        ) |>
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


      df <- df |>
        make_cfbfastR_data("Team matchup record from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team matchup records data available! {conditionMessage(e)}"))
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
#'
#'    |col_name     |types     |description                                          |
#'    |:------------|:---------|:----------------------------------------------------|
#'    |season       |integer   |Season the game took place.                          |
#'    |week         |integer   |Game week of the season.                             |
#'    |season_type  |character |Season type of the game.                             |
#'    |date         |character |Game date.                                           |
#'    |neutral_site |logical   |TRUE/FALSE flag for if the game took place at a neutral site.|
#'    |venue        |character |Stadium name.                                        |
#'    |home_team    |character |Home team of the game.                               |
#'    |home_score   |integer   |Home score in the game.                              |
#'    |away_team    |character |Away team of the game.                               |
#'    |away_score   |integer   |Away score in the game.                              |
#'    |winner       |character |Winner of the matchup.                               |
#'
#' @keywords Team Matchup
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
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
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <-get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        purrr::pluck("games")
      if (is.null(df) || nrow(df) == 0) {
        warning("The data pulled from the API was empty.")
        return(NULL)
      }
      df <- df |>
        janitor::clean_names() |>
        as.data.frame()


      df <- df |>
        make_cfbfastR_data("Team matchup history from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team matchup data available! {conditionMessage(e)}"))
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
#' @param division (*String* optional): Division/classification filter -- one of `fbs`, `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.
#' @return [cfbd_team_roster()] - A data frame with 16 variables:
#'
#'    |col_name         |types     |description                       |
#'    |:----------------|:---------|:---------------------------------|
#'    |athlete_id       |character |Referencing athlete id.           |
#'    |first_name       |character |Athlete first name.               |
#'    |last_name        |character |Athlete last name.                |
#'    |team             |character |Team name.                        |
#'    |weight           |integer   |Athlete weight (lbs).             |
#'    |height           |integer   |Athlete height (inches).          |
#'    |jersey           |integer   |Athlete jersey number.            |
#'    |year             |integer   |Athlete year.                     |
#'    |position         |character |Athlete position.                 |
#'    |home_city        |character |Hometown of the athlete.          |
#'    |home_state       |character |Hometown state of the athlete.    |
#'    |home_country     |character |Hometown country of the athlete.  |
#'    |home_latitude    |numeric   |Hometown latitude.                |
#'    |home_longitude   |numeric   |Hometown longitude.               |
#'    |home_county_fips |integer   |Hometown FIPS code.               |
#'    |headshot_url     |character |Player ESPN headshot url.         |
#'
#' @keywords Team Roster
#' @importFrom dplyr rename mutate
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Teams
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_team_roster(year = 2013, team = "Florida State"))
#' }
#'
cfbd_team_roster <- function(year, team = NULL,
  division = NULL) {

  # Validation ----
  validate_api_key()
  validate_division(division)
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/roster"
  query_params <- list(
    "year" = year,
    "team" = team,
    "classification" = division
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        dplyr::rename("athlete_id" = "id") |>
        dplyr::mutate(
          headshot_url = paste0("https://a.espncdn.com/i/headshots/college-football/players/full/",.data$athlete_id,".png")) |>
        as.data.frame()
      df$recruitIds <- lapply(df$recruitIds, function(y){
        if(length(y) == 0) as.integer(0) else y
      })

      df <- df |>
        janitor::clean_names() |>
        make_cfbfastR_data("Team roster data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team roster data available! {conditionMessage(e)}"))
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
#'
#'    |col_name |types     |description                                                |
#'    |:--------|:---------|:----------------------------------------------------------|
#'    |year     |integer   |Season for the talent rating.                              |
#'    |school   |character |Team name.                                                 |
#'    |talent   |numeric   |Overall roster talent points (as determined by 247Sports). |
#'
#' @keywords Team talent
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
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
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        as.data.frame() |>
        dplyr::mutate(talent = as.numeric(.data$talent)) |>
        dplyr::rename("school" = "team")


      df <- df |>
        make_cfbfastR_data("247sports team talent ratings from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no team talent data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get FBS teams**
#' @param year (*Integer* optional): Season, 4 digits (YYYY).
#' @description
#' **Get FBS teams**
#' Every FBS team for a season.
#'
#' @return [cfbd_teams_fbs()] - A tibble with 43 columns:
#'
#'    |col_name                   |types     |description                                          |
#'    |:-------------------------|:--------|:---------------------------------------------------|
#'    |id                         |integer   |Record identifier.                                   |
#'    |school                     |character |School name.                                         |
#'    |mascot                     |character |Team mascot.                                         |
#'    |abbreviation               |character |Abbreviation.                                        |
#'    |alternate_names_1          |character |First alternate team name.                           |
#'    |alternate_names_2          |character |Second alternate team name.                          |
#'    |alternate_names_3          |character |Third alternate team name.                           |
#'    |conference                 |character |Conference name.                                     |
#'    |division                   |character |Division.                                            |
#'    |classification             |character |Division classification (fbs, fcs, ii, ii/iii, iii). |
#'    |color                      |character |Primary team color (hex).                            |
#'    |alternate_color            |character |Alternate color.                                     |
#'    |logos_1                    |character |Primary team logo URL.                               |
#'    |logos_2                    |character |Alternate (dark) team logo URL.                      |
#'    |logos_3                    |character |Logos 3.                                             |
#'    |logos_4                    |character |Logos 4.                                             |
#'    |logos_5                    |character |Logos 5.                                             |
#'    |logos_6                    |character |Logos 6.                                             |
#'    |logos_7                    |character |Logos 7.                                             |
#'    |logos_8                    |character |Logos 8.                                             |
#'    |logos_9                    |character |Logos 9.                                             |
#'    |logos_10                   |character |Logos 10.                                            |
#'    |logos_11                   |character |Logos 11.                                            |
#'    |logos_12                   |character |Logos 12.                                            |
#'    |logos_13                   |character |Logos 13.                                            |
#'    |logos_14                   |character |Logos 14.                                            |
#'    |logos_15                   |character |Logos 15.                                            |
#'    |logos_16                   |character |Logos 16.                                            |
#'    |twitter                    |character |Team Twitter/X handle.                               |
#'    |location_id                |integer   |Venue identifier.                                    |
#'    |location_name              |character |Venue name.                                          |
#'    |location_city              |character |Venue city.                                          |
#'    |location_state             |character |Venue state.                                         |
#'    |location_zip               |character |Venue zip.                                           |
#'    |location_country_code      |character |Venue country code.                                  |
#'    |location_timezone          |character |Venue timezone.                                      |
#'    |location_latitude          |numeric   |Venue latitude.                                      |
#'    |location_longitude         |numeric   |Venue longitude.                                     |
#'    |location_elevation         |character |Venue elevation.                                     |
#'    |location_capacity          |integer   |Venue capacity.                                      |
#'    |location_construction_year |integer   |Venue construction year.                             |
#'    |location_grass             |logical   |Venue grass.                                         |
#'    |location_dome              |logical   |Venue dome.                                          |
#'
#' @keywords Teams
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Teams Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_teams_fbs(year = 2024))
#' }
cfbd_teams_fbs <- function(year = NULL) {

  # Validation ----
  validate_api_key()

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/teams/fbs"
  query_params <- list(
    "year" = year
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {
      res <- get_req(full_url)
      check_status(res)

      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        janitor::clean_names()

      # `logos` and `alternate_names` arrive as variable-length character
      # vectors. cfbd_team_info() widens them rather than shipping list-columns,
      # and this endpoint returns the same fields, so it follows suit -- a
      # list-column here would break dplyr verbs and any write to csv/parquet.
      if ("logos" %in% names(df)) {
        df <- tidyr::unnest_wider(df, "logos", names_sep = "_")
      }
      if ("alternate_names" %in% names(df)) {
        df <- tidyr::unnest_wider(df, "alternate_names", names_sep = "_")
      }

      df <- df |>
        make_cfbfastR_data("Get FBS teams from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no teams data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
