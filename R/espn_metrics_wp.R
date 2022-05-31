#' **ESPN Metrics**
#' @name espn_metrics
NULL
#' Get win probability chart data from ESPN
#' Graciously contributed by MrCaseB:
#' @rdname espn_metrics
#'
#' @param game_id (*Integer* required): Game ID filter for querying a single game\cr
#' Can be found using the [cfbd_game_info()] function
#'
#' @return [espn_metrics_wp()] - A data frame with 5 variables:
#' \describe{
#'   \item{`game_id`: character.}{Referencing game ID (should be same as `game_id` from other functions).}
#'   \item{`play_id`: character.}{Referencing play ID.}
#'   \item{`seconds_left`: integer.}{Seconds left in the game.}
#'   \item{`home_win_percentage`: double.}{The probability of the home team winning the game.}
#'   \item{`away_win_percentage`: double.}{The probability of the away team winning the game (calculated as 1 - `home_win_percentage` - `tie_percentage`).}
#'   \item{`tie_percentage`: double.}{The probability of the game ending the final period in a tie.}
#' }
#' @keywords Win Probability Chart Data
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom stringr str_sub str_length
#' @import dplyr
#' @export
#' @examples
#' \donttest{
#'   try(espn_metrics_wp(game_id = 401114164))
#' }
#'
espn_metrics_wp <- function(game_id) {

  if (!is.null(game_id) && !is.numeric(game_id)) {
    # Check if game_id is numeric, if not NULL
    cli::cli_abort("Enter valid game_id value (Integer)\nCan be found using the `cfbd_game_info()` function")
  }

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
          play_id = .data$play_id,
          game_id = .data$espn_game_id
        ) %>%
        dplyr::mutate(
          away_win_percentage = 1 - .data$home_win_percentage - .data$tie_percentage
        ) %>%
        dplyr::select(
          .data$game_id, .data$play_id, .data$seconds_left,
          .data$home_win_percentage, .data$away_win_percentage, .data$tie_percentage
        )

      espn_wp <- espn_wp %>%
        make_cfbfastR_data("Win probability chart data from ESPN",Sys.time())
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
