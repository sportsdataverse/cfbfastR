#' @name cfbd_coaches
#' @aliases cfbd_coaches
#' @title
#' **CFBD Coaches Endpoint Overview**
#' @description
#'
#' * `cfbd_coaches()`: A coach search function which provides coaching records and school history for a given coach.
#'
#' @details
#' ## **Coach information search**
#'
#' ```r
#' cfbd_coaches(first = "Nick", last = "Saban", team = "alabama")
#' ```
#'
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
  full_url <- httr2::request(base_url) %>%
    httr2::req_url_query(!!!query_params) %>%
    `[[`("url")

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr2::resp_body_string() %>%
        jsonlite::fromJSON() %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        tidyr::unnest("seasons") %>%
        dplyr::arrange(.data$year) %>%
        janitor::clean_names()

      df <- df %>%
        make_cfbfastR_data("Coaches data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no coaches data available!"))

    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
