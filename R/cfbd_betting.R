#' @name cfbd_betting
#' @aliases betting cfbd_betting cfbd_betting_lines
#' @title CFBD Betting Lines Endpoint
#' @description Get betting lines information from games
#' ```r
#'  cfbd_betting_lines(year = 2018, week = 12, team = "Florida State")
#'
#'  # 7 OTs LSU at TAMU
#'  cfbd_betting_lines(year = 2018, week = 13, team = "Texas A&M", conference = "SEC")
#' ```
#' @examples
#' \donttest{
#'    cfbd_betting_lines(year = 2018, week = 12, team = "Florida State")
#'
#'    # 7 OTs LSU at TAMU
#'    cfbd_betting_lines(year = 2018, week = 13, team = "Texas A&M", conference = "SEC")
#' }
#' @param game_id (\emph{Integer} optional): Game ID filter for querying a single game
#' Can be found using the [cfbd_game_info()] function
#' @param year (\emph{Integer} required): Year, 4 digit format(\emph{YYYY})
#' @param week (\emph{Integer} optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (\emph{String} default regular): Select Season Type: regular or postseason
#' @param team (\emph{String} optional): D-I Team
#' @param home_team (\emph{String} optional): Home D-I Team
#' @param away_team (\emph{String} optional): Away D-I Team
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param line_provider (\emph{String} optional): Select Line Provider - Caesars, consensus, numberfire, or teamrankings
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#' @return Betting information for games with the following columns:
#' \describe{
#'   \item{`game_id`:integer.}{Unique game identifier - `game_id`.}
#'   \item{`season`:integer.}{Season parameter.}
#'   \item{`season_type`:character.)}{Season Type (regular, postseason, both}
#'   \item{`week`:integer.}{Week, values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier).}
#'   \item{`home_team`:character.}{Home D-I Team.}
#'   \item{`home_conference`:character.}{Home D-I Conference.}
#'   \item{`home_score`:integer.}{Home Score.}
#'   \item{`away_team`:character.}{Away D-I Team.}
#'   \item{`away_conference`:character.}{Away D-I Conference.}
#'   \item{`away_score`:integer.}{Away Score.}
#'   \item{`provider`:character.}{Line provider.}
#'   \item{`spread`:character.}{Spread for the game.}
#'   \item{`formatted_spread`:character.}{Formatted spread for the game.}
#'   \item{`over_under`:character.}{Over/Under for the game.}
#' }
#' @source \url{https://api.collegefootballdata.com/lines}
#' @keywords Betting Lines
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom purrr map_if
#' @importFrom dplyr filter as_tibble rename
#' @importFrom tidyr unnest
#' @export
#'
cfbd_betting_lines <- function(game_id = NULL,
                               year = NULL,
                               week = NULL,
                               season_type = "regular",
                               team = NULL,
                               home_team = NULL,
                               away_team = NULL,
                               conference = NULL,
                               line_provider=NULL,
                               verbose = FALSE) {
  if (!is.null(game_id) & !is.numeric(game_id)) {
    # Check if game_id is numeric, if not NULL
    usethis::ui_stop( "Enter valid game_id (numeric value)")
  }
  if (!is.null(year) & !(is.numeric(year) & nchar(year) == 4)) {
    # Check if year is numeric, if not NULL
    usethis::ui_stop("Enter valid year as a number (YYYY)")
  }
  if (!is.null(week) & !(is.numeric(week) & nchar(week) <= 2)) {
    # Check if week is numeric, if not NULL
    usethis::ui_stop("Enter valid week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (season_type != "regular" & season_type != "postseason") {
    # Check if season_type is appropriate, if not regular
    usethis::ui_stop("Enter valid season_type: regular or postseason")
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
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #             msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  if (!is.null(line_provider) &&  is.character(line_provider) &&
      !(line_provider %in% c("Caesars", "consensus", "numberfire", "teamrankings"))) {
    # Check line_provider parameter is a valid entry
    usethis::ui_stop("Enter valid line provider: Caesars, consensus, numberfire, or teamrankings")
  }
  # cfbfastR::cfbd_betting_lines(year = 2018, week = 12, team = "Florida State")
  base_url <- "https://api.collegefootballdata.com/lines?"

  full_url <- paste0(
    base_url,
    "gameId=", game_id,
    "&year=", year,
    "&week=", week,
    "&seasonType=", season_type,
    "&team=", team,
    "&home=", home_team,
    "&away=", away_team,
    "&conference=", conference
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        furrr::future_map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        tidyr::unnest(.data$lines)

      if (!is.null(line_provider)) {
        if (is.list(df) & length(df) == 0) {
          df <- data.frame(game_id = game_id, spread = 0, formatted_spread = "home 0")
        }
        else if (!is.null(df$provider)) {
          df <- df %>%
            dplyr::filter(.data$provider == line_provider) %>%
            janitor::clean_names() %>%
            dplyr::rename(game_id = .data$id) %>%
            as.data.frame()
        }
        else {
          df <- data.frame(game_id = game_id, spread = 0, formatted_spread = "home 0")
        }
      }
      if (is.list(df) & length(df) == 0) {
        df <- data.frame(game_id = game_id, spread = 0, formatted_spread = "home 0")
      } else {
        df <- df %>%
          janitor::clean_names() %>%
          dplyr::rename(game_id = .data$id) %>%
          as.data.frame()
      }
    },
    error = function(e) {
      if (verbose) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no betting lines data available!"))
      }
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
