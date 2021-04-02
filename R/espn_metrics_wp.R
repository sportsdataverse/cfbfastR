#' Get win probability chart data from ESPN
#' Graciously contributed by MrCaseB:
#' @source \url{https://gist.github.com/mrcaseb/0f868193affb4be152e8e82c43a4dc07}
#'
#' @param game_id (\emph{Integer} required): Game ID filter for querying a single game\cr
#' Can be found using the \code{\link[cfbfastR:cfbd_game_info]{cfbfastR::cfbd_game_info()}} function
#'
#' @return A data frame with 5 variables:
#' \describe{
#'   \item{\code{espn_game_id}}{character.}
#'   \item{\code{play_id}}{character.}
#'   \item{\code{seconds_left}}{integer.}
#'   \item{\code{home_win_percentage}}{double.}
#'   \item{\code{away_win_percentage}}{double.}
#' }
#' @keywords Win Probability Chart Data
#' @importFrom jsonlite fromJSON
#' @importFrom attempt stop_if_all
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom stringr str_sub str_length
#' @import dplyr
#' @export
#' @examples
#' \dontrun{
#'   cfbd_metrics_espn_wp(game_id = 401114164)
#' }

cfbd_metrics_espn_wp <- function(game_id) {

  args <- list(game_id = game_id)

  # Check that at search_term input argument is not null
  attempt::stop_if_all(args, is.null,
              msg = "You need to specify at least one argument: game_id\n Can be found using the `cfbd_game_info()` function")

  if(!is.null(game_id)){
    # Check if game_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(game_id),
                msg = 'Enter valid game_id value (Integer)\nCan be found using the `cfbd_game_info()` function')
  }

  # Check for internet
  check_internet()

  espn_game_id <- game_id

  espn_wp <- data.frame()

  tryCatch(
    expr = {
      espn_wp <-
        httr::GET(url = glue::glue("http://site.api.espn.com/apis/site/v2/sports/football/college-football/summary?event={espn_game_id}")) %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        purrr::pluck("winprobability") %>%
        janitor::clean_names() %>%
        dplyr::mutate(
          espn_game_id = stringr::str_sub(.data$play_id, end = stringr::str_length(espn_game_id))
        ) %>%
        dplyr::rename(
          home_win_percentage = .data$home_win_percentage,
          seconds_left = .data$seconds_left,
          play_id = .data$play_id
        ) %>%
        dplyr::mutate(
          away_win_percentage = 1 - .data$home_win_percentage
        )%>%
        dplyr::select(.data$espn_game_id, .data$play_id, .data$seconds_left,
                      .data$home_win_percentage, .data$away_win_percentage)
      message(glue::glue("{Sys.time()}: Scraping ESPN win probability data for game_id '{espn_game_id}'..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: game_id '{espn_game_id}' invalid or no ESPN win probability data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(espn_wp)
}
