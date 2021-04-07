#' CFB Conference Information
#'
#' Pulls all college football conferences and returns as data frame the following fields:
#' @return \code{\link[cfbfastR:cfbd_conferences]{cfbfastR::cfbd_conferences()}} - A data frame with 11 rows and 4 variables:
#' \describe{
#'   \item{conference_id}{Referencing conference id}
#'   \item{name}{Conference name}
#'   \item{long_name}{Long name for Conference}
#'   \item{abbreviation}{Conference abbreviation}
#'   ...
#' }
#' @source \url{https://api.collegefootballdata.com/conferences}
#' @keywords Conferences
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#'
#' cfbd_conferences()
cfbd_conferences <- function() {
  full_url <- "https://api.collegefootballdata.com/conferences"

  # Check for internet
  check_internet()

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
    jsonlite::fromJSON()

  # Rename id as conference_id, short_name as long_name
  df <- df %>%
    dplyr::rename(
      conference_id = .data$id,
      long_name = .data$short_name
    )

  return(df)
}
