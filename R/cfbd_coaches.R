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
#' @return
#' \describe{
#'   \item{first_name:character.}{First name of coach.}
#'   \item{last_name:character.}{Last name of coach.}
#'   \item{hire_date:character.}{Hire date of coach.}
#'   \item{school:character.}{School of coach.}
#'   \item{year:integer.}{Season of record.}
#'   \item{games:integer.}{Games as coach.}
#'   \item{wins:integer.}{Wins for the season.}
#'   \item{losses:integer.}{ Losses for the season.}
#'   \item{ties:integer.}{Ties for the season.}
#'   \item{preseason_rank:integer.}{Preseason rank for the school of coach.}
#'   \item{postseason_rank:integer.}{Postseason rank for the school of coach.}
#'   \item{srs:character.}{Simple Rating System adjustment for team.}
#'   \item{sp_overall:character.}{Bill Connelly's SP+ overall for team.}
#'   \item{sp_offense:character.}{Bill Connelly's SP+ offense for team.}
#'   \item{sp_defense:character.}{Bill Connelly's SP+ defense for team.}
#' }
#' @keywords Coaches
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
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
