#' Calendar
#' Returns calendar of weeks by season
#'
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#'
#' @return A data frame with 5 variables:
#' @source \url{https://api.collegefootballdata.com/calendar}
#' @importFrom dplyr rename mutate
#' @importFrom janitor clean_names
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @export
#' @examples
#' \dontrun{
#'   cfbd_calendar(2019)
#' }

cfbd_calendar <- function(year) {

  # check if year is numeric
  assert_that(is.numeric(year) & nchar(year) == 4,
              msg='Enter valid year as a number (YYYY)')


  base_url <- "https://api.collegefootballdata.com/calendar?"
  full_url <- paste0(base_url,
                     "year=", year)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  df <- data.frame()

  tryCatch(
    expr ={
      # Get the content and return it as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        janitor::clean_names() %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping calendar..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no calendar data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)


}
