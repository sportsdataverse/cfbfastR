#' @name cfbd_metrics
#' @title
#' **CFBD Metrics Endpoint Overview**
#' @description
#' \describe{
#' \item{`cfbd_metrics_ppa_games()`:}{ Get team game averages for predicted points added (PPA).}
#' \item{`cfbd_metrics_ppa_players_games()`:}{ Get player game averages for predicted points added (PPA).}
#' \item{`cfbd_metrics_ppa_players_season()`:}{ Get player season averages for predicted points added (PPA).}
#' \item{`cfbd_metrics_ppa_predicted()`:}{ Calculate predicted points using Down and Distance.}
#' \item{`cfbd_metrics_ppa_teams()`:}{ Get team averages for predicted points added (PPA).}
#' \item{`cfbd_metrics_wp_pregame()`:}{ Get pre-game win probability data from CFBD API.}
#' \item{`cfbd_metrics_wp()`:}{ Get win probability chart data from CFBD API.}
#' \item{`cfbd_metrics_fg_ep()`:}{ Get FG expected points from CFBD API. }
#' }
#'
#' @details
#' ### **Get team game averages for predicted points added (PPA)**
#' ```r
#'   cfbd_metrics_ppa_games(year = 2019, team = "TCU")
#' ```
#' ### **Get player game averages for predicted points added (PPA)**
#' ```r
#'   cfbd_metrics_ppa_players_games(year = 2019, week = 3, team = "TCU")
#' ```
#' ### **Get player season averages for predicted points added (PPA)**
#' ```r
#'   cfbd_metrics_ppa_players_season(year = 2019, team = "TCU")
#' ```
#' ### **Get team averages for predicted points added (PPA)**
#' ```r
#'   cfbd_metrics_ppa_teams(year = 2019, team = "TCU")
#' ```
#' ### **Get pre-game and post-game win probability data from CFBD API**
#' ```r
#'   cfbd_metrics_wp_pregame(year = 2019, week = 9, team = "Texas A&M")
#'   cfbd_metrics_wp(game_id = 401012356)
#' ```
#' ### **Calculate predicted points using down and distance**
#' ```r
#' cfbd_metrics_ppa_predicted(down = 1, distance = 10)
#' ```
#' ### **Get FG expected points from CFBD API.**
#' ```r
#' cfbd_metrics_fg_ep()
#' ````
NULL
#' @title
#' **Get team game averages for predicted points added (PPA)**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE or FALSE)
#'
#' @return [cfbd_metrics_ppa_games()] - A data frame with 18 variables:
#' \describe{
#'   \item{`game_id`: integer.}{Referencing game id.}
#'   \item{`season`: integer.}{Season of the game.}
#'   \item{`week`: integer.}{Game week of the season.}
#'   \item{`conference`: character.}{Conference of the team.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`opponent`: character.}{Team Opponent.}
#'   \item{`off_overall`: character.}{Offense overall predicted points added (PPA).}
#'   \item{`off_passing`: character.}{Offense passing predicted points added (PPA).}
#'   \item{`off_rushing`: character.}{Offense rushing predicted points added (PPA).}
#'   \item{`off_first_down`: character.}{Offense 1st down predicted points added (PPA).}
#'   \item{`off_second_down`: character.}{Offense 2nd down predicted points added (PPA).}
#'   \item{`off_third_down`: character.}{Offense 3rd down predicted points added (PPA).}
#'   \item{`def_overall`: character.}{Defense overall predicted points added (PPA).}
#'   \item{`def_passing`: character.}{Defense passing predicted points added (PPA).}
#'   \item{`def_rushing`: character.}{Defense rushing predicted points added (PPA).}
#'   \item{`def_first_down`: character.}{Defense 1st down predicted points added (PPA).}
#'   \item{`def_second_down`: character.}{Defense 2nd down predicted points added (PPA).}
#'   \item{`def_third_down`: character.}{Defense 3rd down predicted points added (PPA).}
#' }
#' @keywords Teams Predicted Points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_ppa_games(year = 2019, team = "TCU"))
#' }

cfbd_metrics_ppa_games <- function(year,
                                   week = NULL,
                                   team = NULL,
                                   conference = NULL,
                                   excl_garbage_time = FALSE) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_list(excl_garbage_time, c(T,F))

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ppa/games"
  query_params <- list(
    "year" = year,
    "week" = week,
    "team" = team,
    "conference" = conference,
    "excludeGarbageTime" = excl_garbage_time
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content, flatten and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)
      colnames(df) <- gsub("offense.", "off_", colnames(df))
      colnames(df) <- gsub("defense.", "def_", colnames(df))
      colnames(df) <- gsub("Down", "_down", colnames(df))

      df <- df %>%
        dplyr::rename("game_id" = "gameId") %>%
        as.data.frame()

      df <- df %>%
        make_cfbfastR_data("PPA data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics PPA games data available!"))
    },
    finally = {
    }
  )
  return(df)
}




#' @title
#' **Get player game averages for predicted points added (PPA)**
#' @description
#' At least one of \code{week} or \code{team} must be supplied; when both are supplied, both are utilized 
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*).
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier. Required if team not provided.
#' @param team (*String* optional): D-I Team. Required if week not provided.
#' @param position (*string* optional): Position abbreviation of the player you are searching for.
#' Position Group  - options include:
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL
#'  * Special Teams: K, P, LS, PK
#' @param athlete_id (*Integer* optional): Athlete ID filter for querying a single athlete
#' Can be found using the [cfbd_player_info()] function.
#' @param threshold (*Integer* optional): Minimum threshold of plays.
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE or FALSE)
#'
#' @return [cfbd_metrics_ppa_players_games()] - A data frame with 9 variables:
#' \describe{
#'   \item{`season`: integer.}{Season of the game.}
#'   \item{`week`: integer.}{Game week of the season.}
#'   \item{`name`: character.}{Athlete name.}
#'   \item{`position`: character.}{Athlete position.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`opponent`: character.}{Team Opponent name.}
#'   \item{`avg_PPA_all`: double.}{Average overall predicted points added (PPA).}
#'   \item{`avg_PPA_pass`: double.}{Average passing predicted points added (PPA).}
#'   \item{`avg_PPA_rush`: double.}{Average rushing predicted points added (PPA).}
#' }
#' @keywords Players Predicted Points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_ppa_players_games(year = 2019, week = 3, team = "TCU"))
#' }

cfbd_metrics_ppa_players_games <- function(year = NULL,
                                           week = NULL,
                                           team = NULL,
                                           position = NULL,
                                           athlete_id = NULL,
                                           threshold = NULL,
                                           excl_garbage_time = FALSE) {

  # Validation Lists ----
  pos_groups <- c(
    "QB", "RB", "FB", "TE", "WR", "OL", "OT", "G", "OC",
    "DB", "CB", "S", "LB", "DE", "NT", "DL", "DT",
    "K", "P", "PK", "LS"
  )


  # Validation ----
  validate_api_key()
  validate_reqs(week, team)
  validate_year(year)
  validate_week(week)
  validate_list(position, pos_groups)
  validate_id(athlete_id)
  validate_id(threshold)
  validate_list(excl_garbage_time, c(T,F))

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ppa/players/games"
  query_params <- list(
    "year" = year,
    "week" = week,
    "team" = team,
    "position" = position,
    "playerId" = athlete_id,
    "threshold" = threshold,
    "excludeGarbageTime" = excl_garbage_time
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content, flatten and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)
      colnames(df) <- gsub("averagePPA.", "avg_PPA_", colnames(df))

      df <- df %>%
        make_cfbfastR_data("Player PPA data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics PPA game-level players data available!"))
    },
    finally = {
    }
  )
  return(df)
}



#' @title
#' **Get player season averages for predicted points added (PPA)**
#' @description
#' At least one of \code{year} or \code{athlete_id} must be supplied; when both are supplied, both are utilized
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Required if athlete_id not provided
#' @param team (*String* optional): D-I Team.
#' @param conference (*String* optional): Conference abbreviation - S&P+ information by conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param position (*string* optional): Position abbreviation of the player you are searching for.
#' Position Group  - options include:
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL
#'  * Special Teams: K, P, LS, PK
#' @param athlete_id (*Integer* optional): Athlete ID filter for querying a single athlete. Required if year not provided
#' Can be found using the [cfbd_player_info()] function.
#' @param threshold (*Integer* optional): Minimum threshold of plays.
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE or FALSE)
#'
#' @return [cfbd_metrics_ppa_players_season()] - A data frame with 23 variables:
#' \describe{
#'   \item{`season`: integer.}{Season.}
#'   \item{`athlete_id`: character.}{Athlete referencing id.}
#'   \item{`name`: character.}{Athlete name.}
#'   \item{`position`: character.}{Athlete Position.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`conference`: character.}{Team conference.}
#'   \item{`countable_plays`: integer.}{DEPRECATED Number of plays which can be counted.}
#'   \item{`avg_PPA_all`: double.}{Average overall predicted points added (PPA).}
#'   \item{`avg_PPA_pass`: double.}{Average passing predicted points added (PPA).}
#'   \item{`avg_PPA_rush`: double.}{Average rushing predicted points added (PPA).}
#'   \item{`avg_PPA_first_down`: double.}{Average 1st down predicted points added (PPA).}
#'   \item{`avg_PPA_second_down`: double.}{Average 2nd down predicted points added (PPA).}
#'   \item{`avg_PPA_third_down`: double.}{Average 3rd down predicted points added (PPA).}
#'   \item{`avg_PPA_standard_downs`: double.}{Average standard down predicted points added (PPA).}
#'   \item{`avg_PPA_passing_downs`: double.}{Average passing down predicted points added (PPA).}
#'   \item{`total_PPA_all`: double.}{Total overall predicted points added (PPA).}
#'   \item{`total_PPA_pass`: double.}{Total passing predicted points added (PPA).}
#'   \item{`total_PPA_rush`: double.}{Total rushing predicted points added (PPA).}
#'   \item{`total_PPA_first_down`: double.}{Total 1st down predicted points added (PPA).}
#'   \item{`total_PPA_second_down`: double.}{Total 2nd down predicted points added (PPA).}
#'   \item{`total_PPA_third_down`: double.}{Total 3rd down predicted points added (PPA).}
#'   \item{`total_PPA_standard_downs`: double.}{Total standard down predicted points added (PPA).}
#'   \item{`total_PPA_passing_downs`: double.}{Total passing down predicted points added (PPA).}
#' }
#' @keywords Players Predicted Points Season Averages
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_ppa_players_season(year = 2019, team = "TCU"))
#' }
#'
cfbd_metrics_ppa_players_season <- function(year = NULL,
                                            team = NULL,
                                            conference = NULL,
                                            position = NULL,
                                            athlete_id = NULL,
                                            threshold = NULL,
                                            excl_garbage_time = FALSE) {

  # Validation Lists ----
  pos_groups <- c(
    "QB", "RB", "FB", "TE", "WR", "OL", "OT", "G", "OC",
    "DB", "CB", "S", "LB", "DE", "NT", "DL", "DT",
    "K", "P", "PK", "LS"
  )

  # Validation ----
  validate_api_key()
  validate_reqs(year, athlete_id)
  validate_year(year)
  validate_list(position, pos_groups)
  validate_id(athlete_id)
  validate_id(threshold)
  validate_list(excl_garbage_time, c(T,F))

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ppa/players/season"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference,
    "position" = position,
    "playerId" = athlete_id,
    "threshold" = threshold,
    "excludeGarbageTime" = excl_garbage_time
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content, flatten and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)
      colnames(df) <- gsub("averagePPA.", "avg_PPA_", colnames(df))
      colnames(df) <- gsub("totalPPA.", "total_PPA_", colnames(df))
      colnames(df) <- gsub("countablePlays", "countable_plays", colnames(df))
      colnames(df) <- gsub("Down", "_down", colnames(df))

      df <- df %>%
        dplyr::rename("athlete_id" = "id") %>%
        dplyr::mutate(countable_plays = NA_integer_)

      df <- df %>%
        make_cfbfastR_data("Player season PPA data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics PPA season-level players data available!"))
    },
    finally = {
    }
  )
  return(df)
}




#' @title
#' **Calculate predicted points using down and distance**
#' @param down (*Integer* required): Down filter
#' @param distance (*Integer* required): Distance filter
#'
#' @return [cfbd_metrics_ppa_predicted()] - A data frame with 2 variables:
#' \describe{
#'   \item{`yard_line`: integer.}{Yards to goal}
#'   \item{`predicted_points`: character.}{Predicted points at in that down-distance-yardline scenario}
#' }
#' @keywords Predicted Points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_ppa_predicted(down = 1, distance = 10))
#'
#'   try(cfbd_metrics_ppa_predicted(down = 3, distance = 10))
#' }

cfbd_metrics_ppa_predicted <- function(down,
                                       distance) {

  # Validation ----
  validate_api_key()
  validate_range(down, 1, 4)
  validate_range(distance, 1, 99)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ppa/predicted"
  query_params <- list(
    "down" = down,
    "distance" = distance
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content, flatten and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()
      colnames(df) <- gsub("Line", "_line", colnames(df))
      colnames(df) <- gsub("Points", "_points", colnames(df))

      df <- df %>%
        make_cfbfastR_data("PPA data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics PPA predicted data available!"))
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **Get team averages for predicted points added (PPA)**
#' @description
#' At least one of \code{year} or \code{team} must be supplied; when both are supplied, both are utilized
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Required if team not provided
#' @param team (*String* optional): D-I Team. Required if year not provided
#' @param conference (*String* optional): Conference name - select a valid FBS conference
#' Conference names P5: ACC,  Big 12, Big Ten, SEC, Pac-12
#' Conference names G5 and FBS Independents: Conference USA, Mid-American, Mountain West, FBS Independents, American Athletic
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE or FALSE)
#'
#' @return [cfbd_metrics_ppa_teams()] - A data frame with 21 variables:
#' \describe{
#'   \item{`season`: integer.}{.}
#'   \item{`conference`: character.}{.}
#'   \item{`team`: character.}{.}
#'   \item{`off_overall`: character.}{Offense overall predicted points added (PPA).}
#'   \item{`off_passing`: character.}{Offense passing predicted points added (PPA).}
#'   \item{`off_rushing`: character.}{Offense rushing predicted points added (PPA).}
#'   \item{`off_first_down`: character.}{Offense 1st down predicted points added (PPA).}
#'   \item{`off_second_down`: character.}{Offense 2nd down predicted points added (PPA).}
#'   \item{`off_third_down`: character.}{Offense 3rd down predicted points added (PPA).}
#'   \item{`off_cumulative_total`: character.}{Offense cumulative total predicted points added (PPA).}
#'   \item{`off_cumulative_passing`: character.}{Offense cumulative total passing predicted points added (PPA).}
#'   \item{`off_cumulative_rushing`: character.}{Offense cumulative total rushing predicted points added (PPA).}
#'   \item{`def_overall`: character.}{Defense overall predicted points added (PPA).}
#'   \item{`def_passing`: character.}{Defense passing predicted points added (PPA).}
#'   \item{`def_rushing`: character.}{Defense rushing predicted points added (PPA).}
#'   \item{`def_first_down`: character.}{Defense 1st down predicted points added (PPA).}
#'   \item{`def_second_down`: character.}{Defense 2nd down predicted points added (PPA).}
#'   \item{`def_third_down`: character.}{Defense 3rd down predicted points added (PPA).}
#'   \item{`def_cumulative_total`: character.}{Defense cumulative total predicted points added (PPA).}
#'   \item{`def_cumulative_passing`: character.}{Defense cumulative total passing predicted points added (PPA).}
#'   \item{`def_cumulative_rushing`: character.}{Defense cumulative total rushing predicted points added (PPA).}
#' }
#' @keywords Teams Predicted Points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_ppa_teams(year = 2019, team = "TCU"))
#' }

cfbd_metrics_ppa_teams <- function(year = NULL,
                                   team = NULL,
                                   conference = NULL,
                                   excl_garbage_time = FALSE) {

  # Validation ----
  validate_api_key()
  validate_reqs(year, team)
  validate_year(year)
  validate_list(excl_garbage_time, c(T,F))

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ppa/teams"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference,
    "excludeGarbageTime" = excl_garbage_time
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content, flatten and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)
      colnames(df) <- gsub("offense.", "off_", colnames(df))
      colnames(df) <- gsub("defense.", "def_", colnames(df))
      colnames(df) <- gsub("cumulative.", "cumulative_", colnames(df))
      colnames(df) <- gsub("Down", "_down", colnames(df))

      df <- df %>%
        make_cfbfastR_data("Team PPA data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics PPA teams data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get pre-game win probability data from API**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*)
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (*String* optional): D-I Team
#' @param season_type (*String* default regular): Select Season Type: regular or postseason
#'
#' @return [cfbd_metrics_wp_pregame()] - A data frame with 9 variables:
#' \describe{
#'   \item{`season`: integer.}{Season of game.}
#'   \item{`season_type`: character.}{Season type of game.}
#'   \item{`week`: integer.}{Game week of the season.}
#'   \item{`game_id`: integer.}{Referencing game id.}
#'   \item{`home_team`: character.}{Home team name.}
#'   \item{`away_team`: character.}{Away team name.}
#'   \item{`spread`: integer.}{Betting line provider spread.}
#'   \item{`home_win_prob`: double.}{Home win probability - pre-game prediction.}
#'   \item{`away_win_prob`: double.}{Away win probability - pre-game prediction.}
#' }
#' @keywords Pre-game Win Probability Data
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_wp_pregame(year = 2019, week = 9, team = "Texas A&M"))
#' }

cfbd_metrics_wp_pregame <- function(year = NULL,
                                    week = NULL,
                                    team = NULL,
                                    season_type = "regular") {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/metrics/wp/pregame"
  query_params <- list(
    "year" = year,
    "week" = week,
    "team" = team,
    "seasonType" = season_type
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  cols <- c(
    "season", "season_type", "week", "game_id",
    "home_team", "away_team", "spread", "home_win_prob", "away_win_prob"
  )

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
        janitor::clean_names() %>%
        dplyr::rename(home_win_prob = home_win_probability) %>%
        dplyr::mutate(away_win_prob = 1 - as.numeric(.data$home_win_prob)) %>%
        dplyr::select(all_of(cols))

      df <- df %>%
        make_cfbfastR_data("pre-game WP data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no pre-game win probability data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get win probability chart data from API**
#' @param game_id (*Integer* required): Game ID filter for querying a single game
#' Can be found using the [cfbd_game_info()] function
#'
#' @return [cfbd_metrics_wp()] - A data frame with 16 variables:
#' \describe{
#'   \item{`play_id`: character.}{Play referencing id.}
#'   \item{`play_text`: character.}{A text description of the play.}
#'   \item{`home_id`: integer.}{Home team referencing id.}
#'   \item{`home`: character.}{Home team name.}
#'   \item{`away_id`: integer.}{Away team referencing id.}
#'   \item{`away`: character.}{Away team name.}
#'   \item{`spread`: character.}{Betting lines provider spread.}
#'   \item{`home_ball`: logical.}{Home team has the ball.}
#'   \item{`home_score`: integer.}{Home team score.}
#'   \item{`away_score`: integer.}{Away team score.}
#'   \item{`down`: integer.}{Down of the play.}
#'   \item{`distance`: integer.}{Distance to the sticks (to 1st down marker of goal-line in goal-to-go situations).}
#'   \item{`home_win_prob`: character.}{Home team win probability.}
#'   \item{`away_win_prob`: double.}{Away team win probability.}
#'   \item{`play_number`: integer.}{Game play number.}
#'   \item{`yard_line`: integer.}{Yard line of the play (0-100 yards).}
#' }
#' @keywords Win Probability Chart Data
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_wp(game_id = 401012356))
#' }

cfbd_metrics_wp <- function(game_id) {

  # Validation ----
  validate_api_key()
  validate_id(game_id)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/metrics/wp"
  query_params <- list(
    "gameId" = game_id
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  cols <- c(
    "play_id", "play_text", "home_id", "home", "away_id", "away",
    "spread", "home_ball", "home_score", "away_score", "down",
    "distance", "home_win_prob", "away_win_prob", "play_number", "yard_line"
  )

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
        janitor::clean_names() %>%
        dplyr::rename(home_win_prob = home_win_probability) %>%
        dplyr::mutate(away_win_prob = 1 - as.numeric(.data$home_win_prob)) %>%
        dplyr::select(all_of(cols))

      df <- df %>%
        make_cfbfastR_data("WP data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics win probability data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get FG expected points from CFBD API**
#' @return [cfbd_metrics_fg_ep()] - A data frame with 3 variables:
#' \describe{
#'   \item{`yards_to_goal`: integer.}{Yards to the goal line (0-100).}
#'   \item{`distance`: integer.}{Distance to goal posts from kicking location (17 yds further than yards to goal).}
#'   \item{`expected_points`: double.}{Expected points given yards to goal / distance.}
#' }
#' @keywords FG expected points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY modify_url
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_fg_ep())
#' }
cfbd_metrics_fg_ep <- function(){

  # Validation ----
  validate_api_key()

  # Query API ----
  ## Build URL ----
  base_url <- 'https://api.collegefootballdata.com'
  endpoint_path <- "metrics/fg/ep"
  full_url <- httr::modify_url(base_url, path = endpoint_path)

  df <- data.frame()
  tryCatch(
    expr = {
      ## Create GET request ----
      res <- get_req(full_url)
      check_status(res)

      ## Get Content ----
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        janitor::clean_names()

      df <- df %>%
        make_cfbfastR_data("FG expected points data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics FG expected points data available!"))
    },
    finally = {
    }
  )
  return(df)
}
