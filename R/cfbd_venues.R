#' @name cfbd_venues
#' @aliases venues cfbd_venues
#' @title CFBD Venues Endpoint
#' @description 
#' Pulls all college football venues and data on capacity, grass, city/state, location,
#' elevation, dome, timezone and construction year. See Details below.
#' @details CFB Venue Information
#' ```r
#'  cfbd_venues()
#' ```
#' @return A data frame with 337 rows and 13 variables:
#' \describe{
#'   \item{`venue_id`:integer.}
#'   \item{`name`:character.}
#'   \item{`capacity`:integer.}
#'   \item{`grass`:logical.}
#'   \item{`city`:character.}
#'   \item{`state`:character.}
#'   \item{`zip`:character.}
#'   \item{`country_code`:character.}
#'   \item{`location`:list.}
#'   \item{`elevation`:character.}
#'   \item{`year_constructed`:integer.}
#'   \item{`dome`:logical.}
#'   \item{`timezone`:character.}
#' }
#' @source \url{https://api.collegefootballdata.com/venues}
#' @keywords Venues
NULL

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
