#' Coach Information Search
#'
#' A coach search function which provides coaching records and school history for a given coach
#'
#' @param first (\emph{String} optional): First name for the coach you are trying to look up
#' @param last (\emph{String} optional): Last name for the coach you are trying to look up
#' @param team (\emph{String} optional): Team - Select a valid team, D1 football
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY}).
#' @param min_year (\emph{Integer} optional): Minimum Year filter (inclusive), 4 digit format (\emph{YYYY}).
#' @param max_year (\emph{Integer} optional): Maximum Year filter (inclusive), 4 digit format (\emph{YYYY})
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#' @return \code{\link[cfbfastR:cfbd_coaches]{cfbfastR::cfbd_coaches()}} - A data frame with coach information with the following columns:
#' \describe{
#'   \item{\code{first_name}}{character. First name of coach.}
#'   \item{\code{last_name}}{character. Last name of coach.}
#'   \item{\code{school}}{character. School of coach.}
#'   \item{\code{year}}{integer. Season of record.}
#'   \item{\code{games}}{integer. Games as coach.}
#'   \item{\code{wins}}{integer. Wins for the season.}
#'   \item{\code{losses}}{integer. Losses for the season.}
#'   \item{\code{ties}}{integer. Ties for the season.}
#'   \item{\code{preseason_rank}}{integer. Preseason rank for the school of coach.}
#'   \item{\code{postseason_rank}}{integer. Postseason rank for the school of coach.}
#'   \item{\code{srs}}{character. Simple Rating System adjustment for team.}
#'   \item{\code{sp_overall}}{character. Bill Connelly's SP+ overall for team.}
#'   \item{\code{sp_offense}}{character. Bill Connelly's SP+ offense for team.}
#'   \item{\code{sp_defense}}{character. Bill Connelly's SP+ defense for team.}
#' }
#' @source \url{https://api.collegefootballdata.com/coaches}
#' @keywords Recruiting
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
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
                         max_year = NULL,
                         verbose=FALSE) {
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
  if (!is.null(year)) {
    ## check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year as integer in 4 digit format (YYYY)"
    )
  }
  if (!is.null(min_year)) {
    ## check if min_year is numeric
    assertthat::assert_that(is.numeric(min_year) & nchar(min_year) == 4,
      msg = "Enter valid min_year as integer in 4 digit format (YYYY)"
    )
  }
  if (!is.null(max_year)) {
    ## check if max_year is numeric
    assertthat::assert_that(is.numeric(max_year) & nchar(max_year) == 4,
      msg = "Enter valid max_year as integer in 4 digit format (YYYY)"
    )
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
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        tidyr::unnest(.data$seasons) %>%
        as.data.frame() %>%
        dplyr::arrange(.data$year)
      
      if (verbose) {
        message(glue::glue("{Sys.time()}: Scraping coaches data..."))
      }
    },
    error = function(e) {
      if (verbose) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no coaches data available!"))
      }
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
