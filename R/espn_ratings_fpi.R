#' ESPN Ratings
#' @name espn_ratings
NULL
#' Get FPI historical rating data (most recent of each year)
#' Adapted from sabinanalytic's fork of the cfbfastR repo 
#' @rdname espn_ratings
#' @source \url{https://github.com/sabinanalytics/cfbfastR/blob/master/R/cfbd_ratings_fpi.R}
#' @param year Year
#' @return A data frame with 20 variables:
#' \describe{
#'   \item{\code{year}}{double.}
#'   \item{\code{id}}{character.}
#'   \item{\code{name}}{character.}
#'   \item{\code{abbr}}{character.}
#'   \item{\code{row_n}}{integer.}
#'   \item{\code{fpi}}{character.}
#'   \item{\code{fpi_rk}}{character.}
#'   \item{\code{trend}}{character.}
#'   \item{\code{proj_w}}{character.}
#'   \item{\code{proj_l}}{character.}
#'   \item{\code{win_out}}{double.}
#'   \item{\code{win_6}}{double.}
#'   \item{\code{win_div}}{double.}
#'   \item{\code{playoff}}{double.}
#'   \item{\code{nc_game}}{double.}
#'   \item{\code{nc_win}}{double.}
#'   \item{\code{win_conf}}{double.}
#'   \item{\code{w}}{character.}
#'   \item{\code{l}}{character.}
#'   \item{\code{t}}{character.}
#' }
#' @keywords Ratings FPI
#' @importFrom stringr str_remove
#' @importFrom tidyr unnest_wider everything
#' @importFrom dplyr as_tibble between select mutate mutate_at row_number
#' @importFrom jsonlite fromJSON
#' @importFrom utils data
#' @importFrom utils URLencode
#' @importFrom utils globalVariables
#' @importFrom purrr pluck set_names quietly map
#' @importFrom glue glue
#' @export
#' @examples
#'
#' espn_ratings_fpi(year=2018)
#' 

espn_ratings_fpi <- function(year = 2019) {
  current_year <- as.double(substr(Sys.Date(), 1, 4))
  
  # Small error handling to guide the limits on years
  if (!dplyr::between(as.numeric(year), 2004, current_year)) {
    stop(paste("Please choose year between 2004 and", current_year))
  }
  
  # Add message according to totals or weeks
  message(
    glue::glue("Scraping FPI totals for {year}!")
  )
  # Base URL
  fpi_full_url <- "http://site.web.api.espn.com/apis/fitt/v3/sports/football/college-football/powerindex?region=us&lang=en"
  
  url <- glue::glue("{fpi_full_url}&season={year}&limit=200")
  

  raw_json_fpi = jsonlite::fromJSON(url)
  
  ## get team fpi stats
  get_fpi_data <- function(row_n){
    purrr::pluck(raw_json_fpi, "teams", "categories", row_n, "totals", 1)
  }
  purrr::pluck(raw_json_fpi, "categories", "labels", 1)
  
  # tidyr::unnest_wider() name repair is noisy
  # Let's make it quiet with purrr::quietly()
  quiet_unnest_wider <- purrr::quietly(tidyr::unnest_wider)
  
  df <- purrr::pluck(raw_json_fpi, "teams", "team") %>%
    dplyr::as_tibble() %>%
    dplyr::select(.data$id, .data$nickname, .data$abbreviation, .data$logos, .data$links) %>%
    dplyr::mutate(row_n = dplyr::row_number()) %>%
    dplyr::mutate(data = purrr::map(.data$row_n, get_fpi_data)) %>%
    # lots of name_repair here that I am silencing
    quiet_unnest_wider(data) %>%
    purrr::pluck("result") %>%
    purrr::set_names(nm = c(
      "id", "name", "abbr", "logos", "links", "row_n",
      "fpi", "fpi_rk", "trend", "proj_w", "proj_l", "win_out",
      "win_6", "win_div", "playoff", "nc_game", "nc_win",
      "win_conf", "w", "l", "t"
    )) %>%
    dplyr::select(-c("logos","links")) %>% 
    dplyr::mutate(year = year, t = ifelse(is.na(t), 0, t)) %>%
    dplyr::mutate_at(vars(.data$win_out:.data$win_conf), ~ as.double(stringr::str_remove(., "%"))/100 ) %>%
    dplyr::select(.data$year, tidyr::everything()) %>% 
    as.data.frame()

  return(df)
}
