#' @title
#' **CFBD Venues Endpoint Overview**
#' @description Pulls all college football venues and data on capacity, grass, city/state, location,
#' elevation, dome, timezone and construction year.
#' @details CFB Venue Information
#' ```r
#'  cfbd_venues()
#' ```
#' @return A data frame with 337 rows and 13 variables:
#' \describe{
#'   \item{`venue_id`:integer.}{Referencing venue ID.}
#'   \item{`name`:character.}{Venue name.}
#'   \item{`capacity`:integer.}{Stadium capacity.}
#'   \item{`grass`:logical.}{TRUE/FALSE response on whether the field is grass or not (oh, and there are so many others).}
#'   \item{`city`:character.}{Venue city.}
#'   \item{`state`:character.}{Venue state.}
#'   \item{`zip`:character.}{Venue zip.}
#'   \item{`country_code`:character.}{Venue country code.}
#'   \item{`location`:list.}{Venue location.}
#'   \item{`elevation`:character.}{Venue elevation.}
#'   \item{`year_constructed`:integer.}{Year in which the venue was constructed.}
#'   \item{`dome`:logical.}{TRUE/FALSE response to whether the venue has a dome or not.}
#'   \item{`timezone`:character.}{Time zone in which the venue resides (i.e. Eastern Time -> "America/New York").}
#' }
#' @keywords Venues
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom dplyr rename
#' @examples
#' \donttest{
#'   try(cfbd_venues())
#' }
#' @export

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


  df <- df %>%
    make_cfbfastR_data("Venue data from CollegeFootballData.com",Sys.time())

  return(df)
}
