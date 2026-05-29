#' @name cfbd_conferences
#' @aliases cfbd_conferences conferences
#' @title
#' **CFBD Conferences Endpoint Overview**
#' @description
#'
#' * `cfbd_conferences()`: Get college football conference information.
#'
#' @details
#' ## **Get college football conference information**
#'
#' ```r
#' cfbd_conferences()
#' ```
#'
NULL

#' @title
#' **Get college football conference information**
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
#' @importFrom httr GET
#' @import dplyr
#' @import tidyr
#' @family CFBD Conference Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_conferences())
#' }
cfbd_conferences <- function() {

  # Validation ----
  validate_api_key()

  # Query API ----
  full_url <- "https://api.collegefootballdata.com/conferences"

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
        janitor::clean_names()

      # Rename id as conference_id, short_name as long_name
      df <- df %>%
        dplyr::rename(
          "conference_id" = "id",
          "long_name" = "short_name"
        )

      df <- df %>%
        make_cfbfastR_data("Conference data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no Conference data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
