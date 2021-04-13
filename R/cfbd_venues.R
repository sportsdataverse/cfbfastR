#' CFB Venue Information
#'
#' Pulls all college football venues and data on capacity, grass, city/state, location,
#' elevation, dome, timezone and construction year
#'
#' @return A data frame with 335 rows and 13 variables:
#' \describe{
#'   \item{\code{venue_id}}{integer.}
#'   \item{\code{name}}{character.}
#'   \item{\code{capacity}}{integer.}
#'   \item{\code{grass}}{logical.}
#'   \item{\code{city}}{character.}
#'   \item{\code{state}}{character.}
#'   \item{\code{zip}}{character.}
#'   \item{\code{country_code}}{character.}
#'   \item{\code{location}}{list.}
#'   \item{\code{elevation}}{character.}
#'   \item{\code{year_constructed}}{integer.}
#'   \item{\code{dome}}{logical.}
#'   \item{\code{timezone}}{character.}
#' }
#' @source \url{https://api.collegefootballdata.com/venues}
#' @keywords Venues
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom dplyr rename
#' @export
#' @examples
#' \donttest{
#' cfbd_venues()
#' }
#'
cfbd_venues <- function() {
  full_url <- "https://api.collegefootballdata.com/venues"

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
    jsonlite::fromJSON() %>%
    dplyr::rename(venue_id = .data$id) %>%
    as.data.frame()

  return(df)
}
