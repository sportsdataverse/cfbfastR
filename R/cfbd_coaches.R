#' @name cfbd_coaches
#' @aliases coaches cfbd_coaches
#' @title 
#' **CFBD Coaches Endpoint Overview**
#' @description 
#' **Coach information search**
#' A coach search function which provides coaching records and school history for a given coach
#' ```
#' cfbd_coaches(first = "Nick", last = "Saban", team = "alabama")  
#' ````
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
#' @source <https://api.collegefootballdata.com/coaches>
#' @keywords Coaches
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @export
#' @examples
#'\donttest{
#'   cfbd_coaches(first = "Nick", last = "Saban", team = "alabama")
#' }
cfbd_coaches <- function(first = NULL,
                         last = NULL,
                         team = NULL,
                         year = NULL,
                         min_year = NULL,
                         max_year = NULL) {
  if (!is.null(first)) {
    # Encode first parameter for URL if not NULL
    first <- utils::URLencode(first, reserved = TRUE)
  }
  if (!is.null(last)) {
    # Encode last parameter for URL if not NULL
    last <- utils::URLencode(last, reserved = TRUE)
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(year) && !(is.numeric(year) && nchar(year) == 4)) {
    # Check if year is numeric, if not NULL
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  if (!is.null(min_year) && !(is.numeric(min_year) && nchar(min_year) == 4)) {
    ## check if min_year is numeric
    cli::cli_abort("Enter valid min_year as integer in 4 digit format (YYYY)")
  }
  if (!is.null(max_year) && !(is.numeric(max_year) && nchar(max_year) == 4)) {
    ## check if max_year is numeric
    cli::cli_abort("Enter valid max_year as integer in 4 digit format (YYYY)")
  }

  base_url <- "https://api.collegefootballdata.com/coaches?"

  # Create full url using base and input arguments
  full_url <- paste0(
    base_url,
    "first=", first,
    "&last=", last,
    "&team=", team,
    "&year=", year,
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
        furrr::future_map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        tidyr::unnest(.data$seasons) %>%
        as.data.frame() %>%
        dplyr::arrange(.data$year)
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
