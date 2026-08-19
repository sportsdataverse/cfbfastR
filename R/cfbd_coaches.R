#' @name cfbd_coaches
#' @aliases cfbd_coaches
#' @title
#' **CFBD Coaches Endpoint Overview**
#' @description
#'
#' * `cfbd_coaches()`: A coach search function which provides coaching records and school history for a given coach.
#' * `cfbd_coaches_profile()`: Get a single coach's biographical profile.
#' * `cfbd_coaches_seasons()`: Get season-by-season coaching records.
#' * `cfbd_coaches_tenures()`: Get the start and end of each coaching tenure.
#'
#' @details
#' ## **Coach information search**
#'
#' ```r
#' cfbd_coaches(first = "Nick", last = "Saban", team = "alabama")
#' ```
#'
#'
#' ## **Get a coach profile**
#'
#' ```r
#' cfbd_coaches_profile(coach_id = 1)
#' ```
#'
#' ## **Get coaching seasons**
#'
#' ```r
#' cfbd_coaches_seasons(team = "Georgia")
#' ```
#'
#' ## **Get coaching tenures**
#'
#' ```r
#' cfbd_coaches_tenures(team = "Georgia")
#' ```

NULL

#' @title
#' **CFBD Coaches Endpoint Overview**
#' @description
#' **Coach information search**
#' A coach search function which provides coaching records and school history for a given coach
#'
#' @param first (*String* optional): First name for the coach you are trying to look up
#' @param last (*String* optional): Last name for the coach you are trying to look up
#' @param team (*String* optional): Team - Select a valid team, D1 football
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*).
#' @param min_year (*Integer* optional): Minimum Year filter (inclusive), 4 digit format (*YYYY*).
#' @param max_year (*Integer* optional): Maximum Year filter (inclusive), 4 digit format (*YYYY*)
#' @return Returns a tibble with 15 variables:
#'
#'    |col_name        |types     |description                                                       |
#'    |:---------------|:---------|:-----------------------------------------------------------------|
#'    |first_name      |character |First name of coach.                                              |
#'    |last_name       |character |Last name of coach.                                               |
#'    |hire_date       |character |Hire date of coach (ISO date string from CFBD).                   |
#'    |school          |character |School of coach for the listed season.                            |
#'    |year            |integer   |Four-digit season year of record.                                 |
#'    |games           |integer   |Games coached during the season.                                  |
#'    |wins            |integer   |Wins for the season.                                              |
#'    |losses          |integer   |Losses for the season.                                            |
#'    |ties            |integer   |Ties for the season.                                              |
#'    |preseason_rank  |integer   |Preseason AP rank for the school of coach (NA if unranked).       |
#'    |postseason_rank |integer   |Postseason AP rank for the school of coach (NA if unranked).      |
#'    |srs             |character |Simple Rating System adjustment for team.                         |
#'    |sp_overall      |character |Bill Connelly's SP+ overall rating for team.                      |
#'    |sp_offense      |character |Bill Connelly's SP+ offense rating for team.                      |
#'    |sp_defense      |character |Bill Connelly's SP+ defense rating for team.                      |
#'
#' @keywords Coaches
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_url_query resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @family CFBD Coaches Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_coaches(first = "Nick", last = "Saban", team = "alabama"))
#' }
cfbd_coaches <- function(first = NULL,
                         last = NULL,
                         team = NULL,
                         year = NULL,
                         min_year = NULL,
                         max_year = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_year(min_year)
  validate_year(max_year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/coaches"
  query_params <- list(
    "first" = first,
    "last" = last,
    "team" = team,
    "year" = year,
    "minYear" = min_year,
    "maxYear" = max_year
  )
  full_url <- httr2::request(base_url) |>
    httr2::req_url_query(!!!.compact(query_params)) |>
    purrr::pluck("url")

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
        purrr::map_if(is.data.frame, list) |>
        dplyr::as_tibble() |>
        tidyr::unnest("seasons") |>
        dplyr::arrange(.data$year) |>
        janitor::clean_names()

      df <- df |>
        make_cfbfastR_data("Coaches data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no coaches data available! {conditionMessage(e)}"))

    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get a coach profile**
#' @param coach_id (*Integer* required): Coach identifier.
#' @description
#' **Get a coach profile**
#' Biographical profile for a single coach.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#' @return [cfbd_coaches_profile()] - A tibble with 19 columns:
#'
#'    |col_name              |types     |description                          |
#'    |:--------------------|:--------|:-----------------------------------|
#'    |id                    |integer   |Record identifier.                   |
#'    |first_name            |character |First name.                          |
#'    |last_name             |character |Last name.                           |
#'    |display_name          |logical   |Display name.                        |
#'    |current_team          |logical   |Current team.                        |
#'    |birth_date            |logical   |Birth date and time (ISO 8601).      |
#'    |alma_mater            |logical   |Alma mater.                          |
#'    |graduation_year       |logical   |Graduation year.                     |
#'    |wikidata_id           |logical   |Wikidata identifier.                 |
#'    |hall_of_fame_year     |logical   |Hall of fame year.                   |
#'    |career_seasons        |integer   |Seasons coached across the career.   |
#'    |career_teams          |integer   |Distinct teams coached.              |
#'    |career_first_year     |integer   |First season of the coaching career. |
#'    |career_last_year      |integer   |Most recent season coached.          |
#'    |career_games          |integer   |Career games coached.                |
#'    |career_wins           |integer   |Career wins.                         |
#'    |career_losses         |integer   |Career losses.                       |
#'    |career_ties           |integer   |Career ties.                         |
#'    |career_win_percentage |numeric   |Career winning percentage.           |
#'
#' @keywords Coaches
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Coaches Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_coaches_profile(coach_id = 1))
#' }
cfbd_coaches_profile <- function(coach_id, proxy = NULL) {

  # Validation ----
  validate_api_key()

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/coaches/profile"
  query_params <- list(
    "coachId" = coach_id
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {
      res <- get_req(full_url, proxy = proxy)
      check_status(res)

      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      # A profile is one nested object: biographical scalars plus a `career`
      # block. CFBD ships that block two ways -- as a frame of per-stint rows
      # for a coach with several, or as a single set of career aggregates
      # (seasons/teams/firstYear/.../winPercentage) for a coach with one. Both
      # are handled: a frame unnests to one row per stint with the biography
      # recycled, and a scalar block flattens to `career_*` columns.
      #
      # The scalar case must NOT fall through to bio-only. Doing so drops all
      # nine career columns and still returns a clean rectangular frame, so
      # nothing downstream can tell the data went missing.
      career <- df[["career"]]
      bio <- as.data.frame(.cfbd_flatten_scalars(df[setdiff(names(df), "career")]),
                           stringsAsFactors = FALSE)
      df <- if (is.data.frame(career) && nrow(career)) {
        dplyr::as_tibble(cbind(career, bio[rep(1L, nrow(career)), , drop = FALSE]))
      } else if (length(career)) {
        car <- as.data.frame(.cfbd_flatten_scalars(career, "career"),
                             stringsAsFactors = FALSE)
        dplyr::as_tibble(cbind(bio, car))
      } else {
        dplyr::as_tibble(bio)
      }
      df <- janitor::clean_names(df)

      df <- df |>
        make_cfbfastR_data("Get a coach profile from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no coaches data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get coaching seasons**
#' @param coach_id (*Integer* optional): Coach identifier.
#' @param team (*String* optional): Team filter.
#' @param year (*Integer* optional): Season, 4 digits (YYYY).
#' @param min_year (*Integer* optional): Earliest season to include.
#' @param max_year (*Integer* optional): Latest season to include.
#' @description
#' **Get coaching seasons**
#' Season-by-season coaching records.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#' @return [cfbd_coaches_seasons()] - A tibble with 68 columns:
#'
#'    |col_name                                 |types     |description                               |
#'    |:---------------------------------------|:--------|:----------------------------------------|
#'    |year                                     |integer   |Four-digit season year.                   |
#'    |games                                    |integer   |Games played.                             |
#'    |wins                                     |integer   |Wins.                                     |
#'    |losses                                   |integer   |Losses.                                   |
#'    |ties                                     |integer   |Ties.                                     |
#'    |win_percentage                           |numeric   |Win percentage.                           |
#'    |preseason_rank                           |integer   |Preseason rank.                           |
#'    |postseason_rank                          |integer   |Postseason rank.                          |
#'    |srs                                      |numeric   |Srs.                                      |
#'    |sp_overall                               |numeric   |Sp overall.                               |
#'    |sp_offense                               |numeric   |Sp offense.                               |
#'    |sp_defense                               |numeric   |Sp defense.                               |
#'    |attribution_complete                     |logical   |Attribution complete.                     |
#'    |coach_id                                 |integer   |Coach identifier.                         |
#'    |coach_first_name                         |character |Coach first name.                         |
#'    |coach_last_name                          |character |Coach last name.                          |
#'    |team_id                                  |integer   |Referencing team id.                      |
#'    |team_school                              |character |School name of the team.                  |
#'    |team_conference                          |character |Conference the team belongs to.           |
#'    |team_metrics_sp_special_teams            |numeric   |Team metrics sp special teams.            |
#'    |team_metrics_strength_of_schedule        |numeric   |Team metrics strength of schedule.        |
#'    |team_metrics_second_order_wins           |numeric   |Team metrics second order wins.           |
#'    |team_metrics_fpi                         |numeric   |Team metrics fpi.                         |
#'    |team_metrics_year_over_year_wins         |integer   |Team metrics year over year wins.         |
#'    |team_metrics_year_over_year_srs          |numeric   |Team metrics year over year srs.          |
#'    |team_metrics_year_over_year_sp_overall   |numeric   |Team metrics year over year sp overall.   |
#'    |recruiting_rank                          |integer   |Recruiting rank.                          |
#'    |recruiting_points                        |numeric   |Recruiting points scored.                 |
#'    |recruiting_talent                        |numeric   |Recruiting talent.                        |
#'    |poll_resume_preseason_rank               |integer   |Poll resume preseason rank.               |
#'    |poll_resume_postseason_rank              |integer   |Poll resume postseason rank.              |
#'    |poll_resume_best_rank                    |integer   |Poll resume best rank.                    |
#'    |poll_resume_weeks_ranked                 |integer   |Poll resume weeks ranked.                 |
#'    |poll_resume_weeks_top_ten                |integer   |Poll resume weeks top ten.                |
#'    |record_splits_conference_games           |integer   |Record splits conference games.           |
#'    |record_splits_conference_wins            |integer   |Record splits conference wins.            |
#'    |record_splits_conference_losses          |integer   |Record splits conference losses.          |
#'    |record_splits_conference_ties            |integer   |Record splits conference ties.            |
#'    |record_splits_conference_win_percentage  |numeric   |Record splits conference win percentage.  |
#'    |record_splits_postseason_games           |integer   |Record splits postseason games.           |
#'    |record_splits_postseason_wins            |integer   |Record splits postseason wins.            |
#'    |record_splits_postseason_losses          |integer   |Record splits postseason losses.          |
#'    |record_splits_postseason_ties            |integer   |Record splits postseason ties.            |
#'    |record_splits_postseason_win_percentage  |numeric   |Record splits postseason win percentage.  |
#'    |record_splits_home_games                 |integer   |Record splits home games.                 |
#'    |record_splits_home_wins                  |integer   |Record splits home wins.                  |
#'    |record_splits_home_losses                |integer   |Record splits home losses.                |
#'    |record_splits_home_ties                  |integer   |Record splits home ties.                  |
#'    |record_splits_home_win_percentage        |numeric   |Record splits home win percentage.        |
#'    |record_splits_away_games                 |integer   |Record splits away games.                 |
#'    |record_splits_away_wins                  |integer   |Record splits away wins.                  |
#'    |record_splits_away_losses                |integer   |Record splits away losses.                |
#'    |record_splits_away_ties                  |integer   |Record splits away ties.                  |
#'    |record_splits_away_win_percentage        |numeric   |Record splits away win percentage.        |
#'    |record_splits_neutral_games              |integer   |Record splits neutral games.              |
#'    |record_splits_neutral_wins               |integer   |Record splits neutral wins.               |
#'    |record_splits_neutral_losses             |integer   |Record splits neutral losses.             |
#'    |record_splits_neutral_ties               |integer   |Record splits neutral ties.               |
#'    |record_splits_neutral_win_percentage     |numeric   |Record splits neutral win percentage.     |
#'    |scoring_points_for                       |integer   |Scoring points for.                       |
#'    |scoring_points_against                   |integer   |Scoring points against.                   |
#'    |scoring_average_point_differential       |numeric   |Scoring average point differential.       |
#'    |cfp_appeared                             |logical   |Cfp appeared.                             |
#'    |cfp_seed                                 |integer   |Cfp seed.                                 |
#'    |cfp_outcome                              |character |Cfp outcome.                              |
#'    |draft_following_season_year              |integer   |Draft following season year.              |
#'    |draft_following_season_total_picks       |integer   |Draft following season total picks.       |
#'    |draft_following_season_first_round_picks |integer   |Draft following season first round picks. |
#'
#' @keywords Coaches
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Coaches Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_coaches_seasons(team = "Georgia"))
#' }
cfbd_coaches_seasons <- function(coach_id = NULL, team = NULL, year = NULL, min_year = NULL, max_year = NULL, proxy = NULL) {

  # Validation ----
  validate_api_key()

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/coaches/seasons"
  query_params <- list(
    "coachId" = coach_id,
    "team" = team,
    "year" = year,
    "minYear" = min_year,
    "maxYear" = max_year
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

      df <- df |>
        make_cfbfastR_data("Get coaching seasons from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no coaches data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get coaching tenures**
#' @param coach_id (*Integer* optional): Coach identifier.
#' @param team (*String* optional): Team filter.
#' @param year (*Integer* optional): Season, 4 digits (YYYY).
#' @param active (*Logical* optional): Restrict to currently active tenures.
#' @description
#' **Get coaching tenures**
#' Start and end of each coaching tenure.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#' @return [cfbd_coaches_tenures()] - A tibble with 20 columns:
#'
#'    |col_name              |types     |description                               |
#'    |:--------------------|:--------|:----------------------------------------|
#'    |id                    |integer   |Record identifier.                        |
#'    |hire_date             |character |Hire date of the coach (ISO date string). |
#'    |start_year            |integer   |Start year.                               |
#'    |end_year              |integer   |End year.                                 |
#'    |effective_start       |logical   |Effective start.                          |
#'    |effective_end         |logical   |Effective end.                            |
#'    |is_interim            |logical   |Is interim.                               |
#'    |active                |logical   |Active.                                   |
#'    |seasons               |integer   |Seasons.                                  |
#'    |attribution_complete  |logical   |Attribution complete.                     |
#'    |coach_id              |integer   |Coach identifier.                         |
#'    |coach_first_name      |character |Coach first name.                         |
#'    |coach_last_name       |character |Coach last name.                          |
#'    |team_id               |integer   |Referencing team id.                      |
#'    |team_school           |character |School name of the team.                  |
#'    |record_games          |integer   |Record games.                             |
#'    |record_wins           |integer   |Record wins.                              |
#'    |record_losses         |integer   |Record losses.                            |
#'    |record_ties           |integer   |Record ties.                              |
#'    |record_win_percentage |numeric   |Record win percentage.                    |
#'
#' @keywords Coaches
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Coaches Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_coaches_tenures(team = "Georgia"))
#' }
cfbd_coaches_tenures <- function(coach_id = NULL, team = NULL, year = NULL, active = NULL, proxy = NULL) {

  # Validation ----
  validate_api_key()

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/coaches/tenures"
  query_params <- list(
    "coachId" = coach_id,
    "team" = team,
    "year" = year,
    "active" = active
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

      df <- df |>
        make_cfbfastR_data("Get coaching tenures from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no coaches data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
