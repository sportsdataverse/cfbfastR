#' @title
#' **ESPN FPI Ratings**
#' @description Get FPI historical rating data (most recent of each year)
#' @details Adapted from sabinanalytic's fork of the cfbfastR repo
#' @param year Year
#' @return A data frame with 20 variables:
#' \describe{
#'   \item{`year`: integer.}{Season of the Football Power Index (FPI) Rating.}
#'   \item{`team_id`: integer.}{Unique ESPN team ID - `team_id`.}
#'   \item{`team_name`: character.}{Team Name.}
#'   \item{`team_abbreviation`: character.}{Team abbreviation.}
#'   \item{`fpi`: character.}{Football Power Index (FPI) Rating.}
#'   \item{`fpi_rk`: character.}{Football Power Index (FPI) Rank.}
#'   \item{`trend`: character.}{Football Power Index (FPI) ranking trend.}
#'   \item{`projected_wins`: character.}{Projected Win total for the season.}
#'   \item{`projected_losses`: character.}{Projected Loss total for the season.}
#'   \item{`win_out_pct`: double.}{Probability the team wins out.}
#'   \item{`win_6_pct`: double.}{Probability the team wins at least six games.}
#'   \item{`win_division_pct`: double.}{Probability the team wins at their division.}
#'   \item{`playoff_pct`: double.}{Probability the team reaches the playoff.}
#'   \item{`nc_game_pct`: double.}{Probability the team reaches the national championship game.}
#'   \item{`nc_win_pct`: double.}{Probability the team wins the national championship game.}
#'   \item{`win_conference_pct`: double.}{Probability the team wins their conference game.}
#'   \item{`w`: integer.}{Wins on the season.}
#'   \item{`l`: integer.}{Losses on the season.}
#'   \item{`t`: character.}{Ties on the season.}
#' }
#' @keywords Ratings FPI
#' @importFrom stringr str_remove
#' @importFrom tidyr unnest_wider
#' @importFrom dplyr as_tibble between select mutate mutate_at row_number everything
#' @importFrom jsonlite fromJSON
#' @importFrom utils data
#' @importFrom utils URLencode
#' @importFrom utils globalVariables
#' @importFrom purrr pluck set_names quietly map
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#'   try(espn_ratings_fpi(year=2019))
#' }
espn_ratings_fpi <- function(year = 2019) {
  current_year <- as.double(substr(Sys.Date(), 1, 4))

  # Small error handling to guide the limits on years
  if (!dplyr::between(as.numeric(year), 2004, current_year)) {
    stop(paste("Please choose year between 2004 and", current_year))
  }


  # Base URL
  fpi_full_url <- "https://site.web.api.espn.com/apis/fitt/v3/sports/football/college-football/powerindex?region=us&lang=en"

  url <- glue::glue("{fpi_full_url}&season={year}&sort=fpi.fpi%3Adesc")

  headers <- c(
    `authority` = 'site.web.api.espn.com',
    `User-Agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36',
    `Accept` = 'application/json, text/plain, */*',
    `Accept-Language` = 'en-US,en;q=0.9',
    `sec-fetch-site` = 'same-site',
    `sec-fetch-mode` = 'cors',
    `sec-fetch-dest` = 'empty',
    `Origin` = "https://www.espn.com",
    `Referer` = 'https://www.espn.com/',
    `Pragma` = 'no-cache',
    `Cache-Control` = 'no-cache'
  )

  df <- data.frame()
  tryCatch(
    expr = {

      res <-
        httr::RETRY("GET", url,
                    httr::add_headers(.headers = headers))

      # Check the result
      check_status(res)

      resp <- res %>%
        httr::content(as = "text", encoding = "UTF-8")
      raw_json_fpi <- jsonlite::fromJSON(resp)

      ## get team fpi stats
      get_fpi_data <- function(row_n) {
        purrr::pluck(raw_json_fpi, "teams", "categories", row_n, "totals", 1)
      }
      purrr::pluck(raw_json_fpi, "categories", "labels", 1)

      # tidyr::unnest_wider() name repair is noisy
      # Let's make it quiet with purrr::quietly()
      quiet_unnest_wider <- purrr::quietly(tidyr::unnest_wider)

      df <- purrr::pluck(raw_json_fpi, "teams", "team") %>%
        dplyr::as_tibble() %>%
        dplyr::select(
          "id",
          "nickname",
          "abbreviation",
          "logos",
          "links") %>%
        dplyr::mutate(row_n = dplyr::row_number()) %>%
        dplyr::mutate(data = purrr::map(.data$row_n, get_fpi_data))

      df <- df %>%
        tidyr::unnest_wider("data", names_sep = "_") %>%
        purrr::set_names(nm = c(
          "team_id", "team_name", "team_abbreviation", "logos", "links", "row_n",
          "fpi", "fpi_rk", "trend", "projected_wins", "projected_losses", "win_out_pct",
          "win_6_pct", "win_division_pct", "playoff_pct", "nc_game_pct", "nc_win_pct",
          "win_conference_pct", "w", "l", "t"
        )) %>%
        dplyr::select(-c("logos", "links")) %>%
        dplyr::mutate(
          year = year,
          t = ifelse(is.na(t), 0, t)) %>%
        dplyr::mutate_at(vars("win_out_pct":"win_conference_pct"), ~ as.double(stringr::str_remove(., "%")) / 100) %>%
        dplyr::select("year", dplyr::everything()) %>%
        dplyr::select(-"row_n") %>%
        dplyr::mutate(dplyr::across(dplyr::any_of(c(
          "year",
          "team_id",
          "w",
          "l"
        )), ~as.integer(.x))) %>%
        as.data.frame()

      df <- df %>%
        make_cfbfastR_data("FPI rating data from ESPN",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN FPI data available!"))
    },
    finally = {
    }
  )
  return(df)
}
