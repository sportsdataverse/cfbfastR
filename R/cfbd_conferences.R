#' @name cfbd_conferences
#' @aliases cfbd_conferences conferences
#' @title
#' **CFBD Conferences Endpoint Overview**
#' @description
#'
#' * `cfbd_conferences()`: Get college football conference information.
#' * `cfbd_conference_affiliations()`: Get conference affiliations by team and season.
#' * `cfbd_conference_changes()`: Get conference realignment changes for a season.
#'
#' @details
#' ## **Get college football conference information**
#'
#' ```r
#' cfbd_conferences()
#' ```
#'
#'
#' ## **Get conference affiliations by team and season**
#'
#' ```r
#' cfbd_conference_affiliations(team = "Georgia")
#' ```
#'
#' ## **Get conference realignment changes**
#'
#' ```r
#' cfbd_conference_changes(year = 2024)
#' ```

NULL

#' @title
#' **Get college football conference information**
#' @param year (*Integer* optional): Season filter, 4 digits (YYYY). \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_conferences', 'min_year']`
#' @param division (*String* optional): Division/classification filter -- one of `fbs`, `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.
#' @description
#' **Get college football conference information**
#' Pulls all college football conferences and returns as data frame
#'
#' @return [cfbd_conferences()] - A data frame with 94 rows and 5 variables:
#'
#'    |col_name       |types     |description                                                         |
#'    |:--------------|:---------|:-------------------------------------------------------------------|
#'    |conference_id  |integer   |Referencing conference id.                                          |
#'    |name           |character |Conference name.                                                    |
#'    |long_name      |character |Long name for Conference.                                           |
#'    |abbreviation   |character |Conference abbreviation.                                            |
#'    |classification |character |Conference classification (fbs, fcs, ii, iii).                      |
#'
#' @keywords Conferences
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string
#' @import dplyr
#' @import tidyr
#' @family CFBD Conference Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_conferences())
#' }
cfbd_conferences <- function(year = NULL, division = NULL) {

  # Validation ----
  validate_api_key()
  if (!is.null(year)) validate_year(year)
  validate_division(division)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/conferences"
  query_params <- list(
    "year" = year,
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
        janitor::clean_names()

      # Rename id as conference_id, short_name as long_name
      df <- df |>
        dplyr::rename(
          "conference_id" = "id",
          "long_name" = "short_name"
        )

      df <- df |>
        make_cfbfastR_data("Conference data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no Conference data available! {conditionMessage(e)}"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get conference affiliations by team and season**
#' @param team (*String* optional): Team filter.
#' @param conference (*String* optional): Conference abbreviation filter.
#' @param year (*Integer* optional): Season, 4 digits (YYYY). \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_conference_affiliations', 'min_year']`
#' @param min_year (*Integer* optional): Earliest season to include.
#' @param max_year (*Integer* optional): Latest season to include.
#' @param division (*String* optional): Division/classification filter -- `fbs`, `fcs`, `ii`, `ii/iii`, `iii`.
#' @description
#' **Get conference affiliations by team and season**
#' Which conference each team belonged to, by season.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#' @return [cfbd_conference_affiliations()] - A tibble with 9 columns:
#'
#'    |col_name                |types     |description                                          |
#'    |:----------------------|:--------|:---------------------------------------------------|
#'    |team_id                 |integer   |Referencing team id.                                 |
#'    |team                    |character |Team name.                                           |
#'    |conference_id           |integer   |Referencing conference id.                           |
#'    |conference              |character |Conference name.                                     |
#'    |conference_abbreviation |character |Conference abbreviation.                             |
#'    |classification          |character |Division classification (fbs, fcs, ii, ii/iii, iii). |
#'    |conference_division     |character |Conference division.                                 |
#'    |start_year              |integer   |Start year.                                          |
#'    |end_year                |integer   |End year.                                            |
#'
#' @keywords Conferences
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Conference Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_conference_affiliations(team = "Georgia"))
#' }
cfbd_conference_affiliations <- function(team = NULL, conference = NULL, year = NULL, min_year = NULL, max_year = NULL, division = NULL, proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_division(division)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/conferences/affiliations"
  query_params <- list(
    "team" = team,
    "conference" = conference,
    "year" = year,
    "minYear" = min_year,
    "maxYear" = max_year,
    "classification" = division
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
        make_cfbfastR_data("Get conference affiliations by team and season from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no conferences data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get conference realignment changes**
#' @param year (*Integer* required): Season, 4 digits (YYYY). \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_conference_changes', 'min_year']`
#' @description
#' **Get conference realignment changes**
#' Teams that changed conference in a given season.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#' @return [cfbd_conference_changes()] - A tibble with 11 columns:
#'
#'    |col_name                     |types     |description                                |
#'    |:---------------------------|:--------|:-----------------------------------------|
#'    |team_id                      |integer   |Referencing team id.                       |
#'    |team                         |character |Team name.                                 |
#'    |from_conference_id           |integer   |Prior referencing conference id.           |
#'    |from_conference              |character |Prior conference.                          |
#'    |from_conference_abbreviation |character |Prior conference abbreviation.             |
#'    |from_classification          |character |Prior division classification.             |
#'    |to_conference_id             |integer   |New referencing conference id.             |
#'    |to_conference                |character |New conference.                            |
#'    |to_conference_abbreviation   |character |New conference abbreviation.               |
#'    |to_classification            |character |New division classification.               |
#'    |effective_year               |integer   |Season the conference change takes effect. |
#'
#' @keywords Conferences
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Conference Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_conference_changes(year = 2024))
#' }
cfbd_conference_changes <- function(year, proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/conferences/changes"
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

      df <- df |>
        make_cfbfastR_data("Get conference realignment changes from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no conferences data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
