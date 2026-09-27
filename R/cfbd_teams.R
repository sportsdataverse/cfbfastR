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
#' * `cfbd_team_season_overview()`: Get a full-season team overview.
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
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Filter for getting a list of major division team for a given year. Required if conference not provided and the `year` parameter is only supported if `only_fbs` is TRUE. \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_team_info', 'min_year']`
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
#' @param year (*Integer* required): Year,  4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_team_roster', 'min_year']`
#' @param team (*String* optional): Team, select a valid team in D-I football
#'
#' @param division (*String* optional): Division/classification filter -- one of `fbs`, `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.
#' @return [cfbd_team_roster()] - A data frame with 18 variables:
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
#'    |year             |integer   |Athlete class year (0-8; 0 = unknown). `NA` where CFBD returned the season instead of a class year (all pre-2014 rosters, most 2014-2019); use `season` for the roster year. |
#'    |position         |character |Athlete position.                 |
#'    |home_city        |character |Hometown of the athlete.          |
#'    |home_state       |character |Hometown state of the athlete.    |
#'    |home_country     |character |Hometown country of the athlete.  |
#'    |home_latitude    |numeric   |Hometown latitude.                |
#'    |home_longitude   |numeric   |Hometown longitude.               |
#'    |home_county_fips |integer   |Hometown FIPS code.               |
#'    |recruit_ids      |list      |247Sports recruit ids as character strings; a scalar `0L` when the athlete has none. |
#'    |headshot_url     |character |Player ESPN headshot url.         |
#'    |season           |integer   |Season the roster was requested for (the `year` argument). |
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
  requested_season <- as.integer(year)

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
          headshot_url = paste0("https://a.espncdn.com/i/headshots/college-football/players/full/",.data$athlete_id,".png"),
          # CFBD fills `year` with the SEASON (e.g. 2013) instead of the class year for
          # older rosters (100% of 2004-2013 rows, tapering to <5% by 2020). A class
          # year is 0-8 (0 = unknown; redshirts, waivers); anything larger is the season leaking
          # through, so it is nulled here rather than passed to callers (#14 in
          # cfbfastR-data). Use `season` for the year the roster was observed.
          season = requested_season,
          year = dplyr::if_else(as.integer(.data$year) > 8L, NA_integer_, as.integer(.data$year))) |>
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
#' @param year (*Integer* optional): Year 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_team_talent', 'min_year']`
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
#' @param year (*Integer* optional): Season, 4 digits (YYYY). \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_teams_fbs', 'min_year']`
#' @description
#' **Get FBS teams**
#' Every FBS team for a season.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
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
cfbd_teams_fbs <- function(year = NULL, proxy = NULL) {

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
      res <- get_req(full_url, proxy = proxy)
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

#' @title
#' **Get a full-season team overview**
#' @description
#' **Returns a stored full-season team overview, including postseason and garbage time.**
#' @param year (*Integer* required): Season year, 4 digit format (*YYYY*).
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_team_season_overview', 'min_year']`
#' @param team (*String* required): Team name.
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables.
#' @return [cfbd_team_season_overview()] - A named list of tibbles:
#' `overview`, `record`, `ratings`, `advanced`, `passing`, `rushing`,
#' `players`. Nested objects are flattened into prefixed columns. A section CFBD
#' did not fill (`passing` and `rushing` start in 2025) is a 0-column tibble.
#'
#' **overview** - one row: `season` (integer), `team_id` (integer), `team` (character).
#'
#' **record** - one row: completed games for the requested season, including
#' postseason: `games`, `wins`, `losses`, `ties` (integer).
#'
#' **ratings** - one row: current available ratings for the requested season;
#' unavailable systems are `NA`. `elo` (numeric, latest postgame Elo from a
#' completed game this season), then a `<system>_<unit>_rating` (numeric,
#' rounded to two decimals) and `<system>_<unit>_rank` (integer, rank within
#' the season and division) pair for `srs` (no unit), `sp_*` and `fpi_*`
#' (`overall`, `offense`, `defense`, `special_teams`; FPI values are
#' efficiencies, higher is better) and `core_*` (`overall`, `offense`, `defense`).
#'
#' **advanced** - one row: `season` (integer), `team`, `conference`
#' (character), then for each of `offense_` and `defense_`:
#'
#'   |col_name (after the side prefix)          |types   |
#'   |:-----------------------------------------|:-------|
#'   |plays, drives                             |integer |
#'   |ppa, total_ppa, success_rate, explosiveness |numeric |
#'   |power_success, stuff_rate                 |numeric |
#'   |line_yards, line_yards_total              |numeric, integer |
#'   |second_level_yards, second_level_yards_total |numeric, integer |
#'   |open_field_yards, open_field_yards_total  |numeric, integer |
#'   |total_opportunies, points_per_opportunity |integer, numeric (upstream spelling kept) |
#'   |field_position_average_start, field_position_average_predicted_points |numeric |
#'   |havoc_total, havoc_front_seven, havoc_db  |numeric |
#'   |`standard_downs_*`, `passing_downs_*` |numeric: `rate`, `ppa`, `success_rate`, `explosiveness` (`total_ppa` too on defense passing downs) |
#'   |`passing_plays_*`, `rushing_plays_*` |numeric: `rate`, `ppa`, `total_ppa`, `success_rate`, `explosiveness` |
#'
#' **passing** - one row: `season` (integer), `team`, `conference`
#' (character), then `offense_*` and `defense_*`, each the passing production
#' block (with `locations_<bucket>_*`) documented in [cfbd_passing_teams_season()].
#'
#' **rushing** - one row: `season` (integer), `team`, `conference`
#' (character), then `offense_*` and `defense_*`, each the rushing production
#' block (with `directions_<direction>_*`) documented in [cfbd_rushing_teams_season()].
#'
#' **players** - one row per player per `category` (`usage` or `ppa`):
#'
#'   |col_name       |types     |description                                                          |
#'   |:--------------|:---------|:--------------------------------------------------------------------|
#'   |category       |character |usage or ppa: which player list the row comes from.                  |
#'   |season         |integer   |Season.                                                              |
#'   |id             |character |Player id.                                                           |
#'   |name           |character |Player name.                                                         |
#'   |position       |character |Player position.                                                     |
#'   |team           |character |Team name.                                                           |
#'   |conference     |character |Conference.                                                          |
#'   |usage_*        |numeric   |Usage rows: `overall`, `pass`, `rush`, `first_down`, `second_down`, `third_down`, `standard_downs`, `passing_downs`. |
#'   |average_ppa_*  |numeric   |PPA rows: average PPA for `all`, `pass`, `rush`, `first_down`, `second_down`, `third_down`, `standard_downs`, `passing_downs`. |
#'   |total_ppa_*    |numeric   |PPA rows: total PPA for the same splits.                             |
#'
#' @keywords Team Season Overview
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom glue glue
#' @family CFBD Teams
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_team_season_overview(year = 2024, team = "Texas"))
#' }
cfbd_team_season_overview <- function(year, team, proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/teams/season/overview"
  query_params <- list(
    "year" = year,
    "team" = team
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- list()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url, proxy = proxy)
      check_status(res)

      parsed <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      df <- list(
        overview = .cfbd_section_tbl(parsed[c("season", "teamId", "team")]),
        record = .cfbd_section_tbl(parsed$record),
        ratings = .cfbd_ratings_tbl(parsed$ratings),
        advanced = .cfbd_section_tbl(parsed$advanced),
        passing = .cfbd_section_tbl(parsed$passing),
        rushing = .cfbd_section_tbl(parsed$rushing),
        players = .cfbd_section_tbl(parsed$players)
      )

      df <- lapply(df, make_cfbfastR_data,
                   type = "Team season overview data from CollegeFootballData.com",
                   timestamp = Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no team season overview data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' Ratings section of a team season overview, with a stable column set
#'
#' @description CFBD sends `null` for a rating system it has no value for, and
#'   flattening turns that into a single `NA` placeholder column (`sp`) instead
#'   of the documented `sp_<unit>_rating` / `sp_<unit>_rank` pair. This drops
#'   the placeholders and adds every documented column that is absent as a
#'   typed `NA`, so the same columns can be selected in every season.
#' @param x The parsed `ratings` object.
#' @return A tibble; 0 columns when `x` is empty.
#' @keywords internal
#' @noRd
.cfbd_ratings_tbl <- function(x) {
  if (is.null(x) || !length(x)) {
    return(dplyr::tibble())
  }
  # Always one record: `.cfbd_section_tbl()` would read an object whose
  # systems are all `null` as an empty group of arrays and return 0 columns.
  df <- janitor::clean_names(dplyr::as_tibble(
    as.data.frame(.cfbd_flatten_scalars(x), stringsAsFactors = FALSE)
  ))
  units <- list(
    srs = "",
    sp = c("overall", "offense", "defense", "special_teams"),
    fpi = c("overall", "offense", "defense", "special_teams"),
    core = c("overall", "offense", "defense")
  )
  prefixes <- unlist(lapply(names(units), function(s) {
    u <- units[[s]]
    c(s, paste(s, u[nzchar(u)], sep = "_"))
  }))
  stems <- unlist(lapply(names(units), function(s) {
    u <- units[[s]]
    ifelse(nzchar(u), paste(s, u, sep = "_"), s)
  }))
  expected <- c("elo", as.vector(rbind(paste0(stems, "_rating"), paste0(stems, "_rank"))))
  df <- df[, !names(df) %in% setdiff(prefixes, expected), drop = FALSE]
  for (col in expected) {
    if (!col %in% names(df) || (is.logical(df[[col]]) && all(is.na(df[[col]])))) {
      df[[col]] <- if (endsWith(col, "_rank")) NA_integer_ else NA_real_
    }
  }
  df
}
