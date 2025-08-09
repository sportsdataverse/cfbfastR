
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

  # Validation Lists ----
  providers <- c(
    'teamrankings', 'numberfire', 'consensus', 'Caesars', 'Bovada',
    'SugarHouse', 'William Hill (New Jersey)', 'Caesars (Pennsylvania)',
    'Caesars Sportsbook (Colorado)', 'ESPN Bet', 'DraftKings'
  )

  # Validation ----
  validate_api_key()
  validate_reqs(game_id, year)
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)
  validate_id(game_id)
  validate_list(line_provider, providers)

  # Team Name Handling ----
  team <- handle_accents(team)
  home_team <- handle_accents(home_team)
  away_team <- handle_accents(away_team)

  # Query API ----
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

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        stringr::str_replace_all("NaN", 'null') %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        tidyr::unnest("lines")


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
