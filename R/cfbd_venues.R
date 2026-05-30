#' @name cfbd_venues
#' @aliases cfbd_venues stadiums
#' @title
#' **CFBD Venues Endpoint Overview**
#' @description
#'
#' * `cfbd_venues()`: Pulls all college football venues and data on capacity, grass, city/state, location, elevation, dome, timezone and construction year.
#'
#' @details
#' ## **CFB Venue Information**
#'
#' ```r
#' cfbd_venues()
#' ```
#'
NULL

#' @title
#' **CFBD Venues Endpoint Overview**
#' @description Pulls all college football venues and data on capacity, grass, city/state, location,
#' elevation, dome, timezone and construction year.
#' @details CFB Venue Information
#' ```r
#'  cfbd_venues()
#' ```
#' @return A data frame with 337 rows and 14 variables:
#'
#'    |col_name         |types     |description                                                                       |
#'    |:----------------|:---------|:---------------------------------------------------------------------------------|
#'    |venue_id         |integer   |Referencing venue ID.                                                             |
#'    |name             |character |Venue name.                                                                       |
#'    |capacity         |integer   |Stadium capacity.                                                                 |
#'    |grass            |logical   |TRUE/FALSE response on whether the field is grass or not.                         |
#'    |city             |character |Venue city.                                                                       |
#'    |state            |character |Venue state.                                                                      |
#'    |zip              |character |Venue zip code.                                                                   |
#'    |country_code     |character |Venue country code.                                                               |
#'    |latitude         |numeric   |Venue latitude in decimal degrees.                                                |
#'    |longitude        |numeric   |Venue longitude in decimal degrees.                                               |
#'    |elevation        |character |Venue elevation above sea level.                                                  |
#'    |year_constructed |integer   |Year in which the venue was constructed.                                          |
#'    |dome             |logical   |TRUE/FALSE response to whether the venue has a dome or not.                       |
#'    |timezone         |character |Time zone in which the venue resides (i.e. Eastern Time -> "America/New_York").   |
#'
#' @keywords Venues
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string
#' @importFrom dplyr rename
#' @family CFBD Venues
#' @examples
#' \donttest{
#'   try(cfbd_venues())
#' }
#' @export

cfbd_venues <- function() {

  # Validation ----
  validate_api_key()

  # Query API ----
  full_url <- "https://api.collegefootballdata.com/venues"

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        dplyr::rename(
          "venue_id" = "id",
          "year_constructed" = "constructionYear",
          "country_code" = "countryCode"
        ) |>
        as.data.frame()

      df <- df |>
        make_cfbfastR_data("Venue data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no venue data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
