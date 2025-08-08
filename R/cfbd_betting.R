
#' @title **CFBD Betting Lines Endpoint Overview**
#' @description **Get betting lines information for games**
#' @param game_id (*Integer* optional): Game ID filter for querying a single game \cr
#' Can be found using the [cfbd_game_info()] function
#' @param year (*Integer* required): Year, 4 digit format(*YYYY*)
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* default regular): Select Season Type: regular or postseason
#' @param team (*String* optional): D-I Team
#' @param home_team (*String* optional): Home D-I Team
#' @param away_team (*String* optional): Away D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference \cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC \cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC \cr
#' @param line_provider (*String* optional): Select Line Provider - Caesars, consensus, numberfire, or teamrankings
#' @return Betting information for games with the following columns:
#'
#' \describe{
#'   \item{game_id:integer.}{Unique game identifier - game_id.}
#'   \item{season:integer.}{Season parameter.}
#'   \item{season_type:character.)}{Season Type (regular, postseason, both}
#'   \item{week:integer.}{Week, values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier).}
#'   \item{start_date:character.}{Start Date}
#'   \item{home_team:character.}{Home D-I Team.}
#'   \item{home_conference:character.}{Home D-I Conference.}
#'   \item{home_score:integer.}{Home Score.}
#'   \item{away_team:character.}{Away D-I Team.}
#'   \item{away_conference:character.}{Away D-I Conference.}
#'   \item{away_score:integer.}{Away Score.}
#'   \item{provider:character.}{Line provider.}
#'   \item{spread:character.}{Spread for the game.}
#'   \item{formatted_spread:character.}{Formatted spread for the game.}
#'   \item{spread_open:character.}{Opening spread for the game.}
#'   \item{over_under:character.}{Over/Under for the game.}
#'   \item{over_under_open:character.}{Opening over/under for the game.}
#'   \item{home_moneyline:character.}{Home team moneyline.}
#'   \item{away_moneyline:character.}{Away team moneyline.}
#' }
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom purrr map_if
#' @importFrom dplyr filter as_tibble rename
#' @importFrom tidyr unnest
#' @importFrom stringr str_replace_all
#' @export
#' @examples
#' \donttest{
#'    try(cfbd_betting_lines(year = 2018, week = 12, team = "Florida State"))
#' }
cfbd_betting_lines <- function(game_id = NULL,
                               year = NULL,
                               week = NULL,
                               season_type = "regular",
                               team = NULL,
                               home_team = NULL,
                               away_team = NULL,
                               conference = NULL,
                               line_provider=NULL) {
  if (is.null(game_id) && is.null(year)){
    cli::cli_abort( "Must provide either game_id or year" )
  }
  if (!is.null(game_id) && !is.numeric(game_id)) {
    # Check if game_id is numeric, if not NULL
    cli::cli_abort( "Enter valid game_id (numeric value)")
  }
  if (!is.null(year) && !(is.numeric(year) && nchar(year) == 4)) {
    # Check if year is numeric, if not NULL
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  if (!is.null(week) && !(is.numeric(week) && nchar(week) <= 2)) {
    # Check if week is numeric, if not NULL
    cli::cli_abort("Enter valid week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (season_type != "regular" && season_type != "postseason") {
    # Check if season_type is appropriate, if not regular
    cli::cli_abort("Enter valid season_type: regular or postseason")
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(home_team)) {
    # Encode home_team parameter for URL, if not NULL
    home_team <- utils::URLencode(home_team, reserved = TRUE)
  }
  if (!is.null(away_team)) {
    # Encode away_team parameter for URL, if not NULL
    away_team <- utils::URLencode(away_team, reserved = TRUE)
  }
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  if (!is.null(line_provider) &&  is.character(line_provider) &&
      !(line_provider %in% c("Caesars", "consensus", "numberfire", "teamrankings"))) {
    # Check line_provider parameter is a valid entry
    cli::cli_abort("Enter valid line provider: Caesars, consensus, numberfire, or teamrankings")
  }
  # cfbfastR::cfbd_betting_lines(year = 2018, week = 12, team = "Florida State")
  base_url <- "https://api.collegefootballdata.com/lines?"



  query_params <- list(
    "gameId" = game_id,
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "home" = home_team,
    "away" = away_team,
    "conference" = conference,
    "provider" = line_provider
  )

  full_url <- httr::modify_url(base_url, query=query_params)

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  df <- data.frame()
  tryCatch(
    expr = {

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
        stringr::str_replace_all("NaN", 'null') %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        tidyr::unnest("lines") %>%
        dplyr::mutate(
            overUnder = dplyr::case_when(
                .data$overUnder == "null" ~ NA_real_,
                .default = .data$overUnder
            ),
            spread = dplyr::case_when(
                .data$spread == "null" ~ NA_real_,
                .default = .data$spread
            ),
            formattedSpread = dplyr::case_when(
                is.na(.data$spread) ~ NA_character_,
                .default = .data$formattedSpread
            )
        )



      if (!is.null(line_provider)) {
        if (is.list(df) & length(df) == 0) {
          df <- data.frame(game_id = game_id, spread = 0, formatted_spread = "home 0")
        } else if (!is.null(df$provider)) {
          df <- df %>%
            dplyr::filter(.data$provider == line_provider) %>%
            janitor::clean_names() %>%
            dplyr::rename("game_id" = "id") %>%
            as.data.frame()
        } else {
          df <- data.frame(game_id = game_id, spread = 0, formatted_spread = "home 0")
        }
      }
      if (is.list(df) & length(df) == 0) {
        df <- data.frame(game_id = game_id, spread = 0, formatted_spread = "home 0")
      } else {
        df <- df %>%
          janitor::clean_names() %>%
          dplyr::rename("game_id" = "id") %>%
          as.data.frame()
      }

      df <- df %>%
        make_cfbfastR_data("Betting lines data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no betting lines data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
