#' @name cfbd_metrics
#' @title
#' **CFBD Metrics Endpoint Overview**
#' @description
#'
#' * `cfbd_metrics_fg_ep()`: Get field goal expected points values.
#' * `cfbd_metrics_wepa_team_season()`: Get opponent-adjusted team season statistics for predicted points added (PPA).
#' * `cfbd_metrics_wepa_players_passing()`: Get opponent-adjusted player passing statistics for predicted points added (PPA).
#' * `cfbd_metrics_wepa_players_rushing()`: Get opponent-adjusted player rushing statistics for predicted points added (PPA).
#' * `cfbd_metrics_wepa_players_kicking()`: Get Points Added Above Replacement (PAAR) ratings for kickers.
#' * `cfbd_metrics_ppa_games()`: Get team game averages for predicted points added (PPA).
#' * `cfbd_metrics_ppa_players_games()`: Get player game averages for predicted points added (PPA).
#' * `cfbd_metrics_ppa_players_season()`: Get player season averages for predicted points added (PPA).
#' * `cfbd_metrics_ppa_predicted()`: Calculate predicted points using Down and Distance.
#' * `cfbd_metrics_ppa_teams()`: Get team averages for predicted points added (PPA).
#' * `cfbd_metrics_wp_pregame()`: Get pre-game win probability data from CFBD API.
#' * `cfbd_metrics_wp()`: Get win probability chart data from CFBD API.
#'
#' @details
#' ### **Get expected points for field goals by yards to goal and distance**
#' ```r
#'   cfbd_metrics_fg_ep()
#' ```
#' ### **Get opponent-adjusted team season statistics for predicted points added (PPA)**
#' ```r
#'  cfbd_metrics_wepa_team_season(year = 2019, team = "TCU")
#' ```
#' ### **Get opponent-adjusted player passing statistics for predicted points added (PPA)**
#' ```r
#' cfbd_metrics_wepa_players_passing(year = 2019, team = "TCU")
#' ```
#' ### **Get opponent-adjusted player rushing statistics for predicted points added (PPA)**
#' ```r
#' cfbd_metrics_wepa_players_rushing(year = 2019, team = "TCU")
#' ```
#' ### **Get Points Added Above Replacement (PAAR) ratings for kickers**
#' ```r
#' cfbd_metrics_wepa_players_kicking(year = 2019, team = "TCU")
#' ```
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
NULL
#' @title
#' **Get FG expected points from CFBD API**
#' @return [cfbd_metrics_fg_ep()] - A data frame with 3 variables:
#'
#'  |col_name        |types     |description                                                                       |
#'  |:---------------|:---------|:---------------------------------------------------------------------------------|
#'  |yards_to_goal   |integer   |Yards to the goal line (0-100).                                                   |
#'  |distance        |integer   |Distance to goal posts from kicking location (17 yds further than yards to goal). |
#'  |expected_points |numeric   |Expected points given yards to goal / distance.                                   |
#'
#' @keywords FG expected points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY modify_url
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Metrics
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

#' @title
#' **Get opponent-adjusted team season statistics for predicted points added (PPA)**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#'
#' @return [cfbd_metrics_wepa_team_season()] - A data frame with 26 variables:
#'
#'   |col_name                            |types     |description                                                                                          |
#'   |:-----------------------------------|:---------|:----------------------------------------------------------------------------------------------------|
#'   |year                                |integer   |Four-digit season year (e.g. 2019).                                                                  |
#'   |team_id                             |integer   |CFBD internal team identifier.                                                                       |
#'   |team                                |character |Full team name (e.g. "TCU").                                                                         |
#'   |conference                          |character |Team conference name (e.g. "Big 12").                                                                |
#'   |explosiveness                       |numeric   |Offensive opponent-adjusted explosiveness rate (higher = more big plays).                            |
#'   |explosiveness_allowed               |numeric   |Defensive opponent-adjusted explosiveness rate allowed.                                              |
#'   |epa_total                           |numeric   |Opponent-adjusted total offensive EPA per play (predicted points added).                             |
#'   |epa_passing                         |numeric   |Opponent-adjusted offensive passing EPA per play.                                                    |
#'   |epa_rushing                         |numeric   |Opponent-adjusted offensive rushing EPA per play.                                                    |
#'   |epa_allowed_total                   |numeric   |Opponent-adjusted total defensive EPA per play allowed.                                              |
#'   |epa_allowed_passing                 |numeric   |Opponent-adjusted defensive passing EPA per play allowed.                                            |
#'   |epa_allowed_rushing                 |numeric   |Opponent-adjusted defensive rushing EPA per play allowed.                                            |
#'   |success_rate_total                  |numeric   |Opponent-adjusted offensive success rate across all plays (proportion 0-1).                          |
#'   |success_rate_standard_downs         |numeric   |Opponent-adjusted offensive success rate on standard downs (proportion 0-1).                         |
#'   |success_rate_passing_downs          |numeric   |Opponent-adjusted offensive success rate on passing downs (proportion 0-1).                          |
#'   |success_rate_allowed_total          |numeric   |Opponent-adjusted defensive success rate allowed across all plays (proportion 0-1).                  |
#'   |success_rate_allowed_standard_downs |numeric   |Opponent-adjusted defensive success rate allowed on standard downs (proportion 0-1).                 |
#'   |success_rate_allowed_passing_downs  |numeric   |Opponent-adjusted defensive success rate allowed on passing downs (proportion 0-1).                  |
#'   |rushing_line_yards                  |numeric   |Opponent-adjusted offensive line yards per rush (Football Outsiders methodology).                    |
#'   |rushing_second_level_yards          |numeric   |Opponent-adjusted offensive second-level yards per rush (5-10 yards past line of scrimmage).         |
#'   |rushing_open_field_yards            |numeric   |Opponent-adjusted offensive open-field yards per rush (10+ yards past line of scrimmage).            |
#'   |rushing_highlight_yards             |numeric   |Opponent-adjusted offensive highlight yards per opportunity rush.                                    |
#'   |rushing_allowed_line_yards          |numeric   |Opponent-adjusted defensive line yards per rush allowed.                                             |
#'   |rushing_allowed_second_level_yards  |numeric   |Opponent-adjusted defensive second-level yards per rush allowed.                                     |
#'   |rushing_allowed_open_field_yards    |numeric   |Opponent-adjusted defensive open-field yards per rush allowed.                                       |
#'   |rushing_allowed_highlight_yards     |numeric   |Opponent-adjusted defensive highlight yards per opportunity rush allowed.                            |
#'
#' @keywords Opponent Adjusted Team Predicted Points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Metrics
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_wepa_team_season(year = 2019, team = "TCU"))
#' }

cfbd_metrics_wepa_team_season <- function(year = NULL,
                                   team = NULL,
                                   conference = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/wepa/team/season"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference
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
        jsonlite::fromJSON(flatten = TRUE) %>%
        janitor::clean_names()


      df <- df %>%
        make_cfbfastR_data("Opponent-adjusted team season PPA data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no opponent-adjusted team season PPA data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get opponent-adjusted player passing statistics for predicted points added (PPA)**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param position (*string* optional): Position abbreviation of the player you are searching for.
#' Position Group  - options include:
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL
#'  * Special Teams: K, P, LS, PK
#'
#' @return [cfbd_metrics_wepa_players_passing()] - A data frame with 8 variables:
#'
#'  |col_name     |types     |description                                                                       |
#'  |:------------|:---------|:---------------------------------------------------------------------------------|
#'  |year         |integer   |Four-digit season year (e.g. 2019).                                               |
#'  |athlete_id   |character |CFBD athlete identifier (use with `cfbd_player_info()`).                          |
#'  |athlete_name |character |Player full name.                                                                 |
#'  |position     |character |Player position abbreviation (e.g. "QB", "RB").                                   |
#'  |team         |character |Full team name (e.g. "TCU").                                                      |
#'  |conference   |character |Team conference name (e.g. "Big 12").                                             |
#'  |wepa         |numeric   |Opponent-adjusted weighted EPA (passing predicted points added).                  |
#'  |plays        |integer   |Total qualifying passing plays included in the WEPA calculation.                  |
#'
#' @keywords Opponent Adjusted Players Passing Predicted Points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Metrics
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_wepa_players_passing(year = 2019, team = "TCU"))
#' }

cfbd_metrics_wepa_players_passing <- function(year = NULL,
                                              team = NULL,
                                              conference = NULL,
                                              position = NULL) {

  # Validation Lists ----
  pos_groups <- c(
    "QB", "RB", "FB", "TE", "WR", "OL", "OT", "G", "OC",
    "DB", "CB", "S", "LB", "DE", "NT", "DL", "DT",
    "K", "P", "PK", "LS"
  )

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_list(position, pos_groups)
  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/wepa/players/passing"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference,
    "position" = position
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
        jsonlite::fromJSON(flatten = TRUE) %>%
        janitor::clean_names()


      df <- df %>%
        make_cfbfastR_data("Opponent-adjusted players passing PPA data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no opponent-adjusted players passing PPA data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get opponent-adjusted player rushing statistics for predicted points added (PPA)**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param position (*string* optional): Position abbreviation of the player you are searching for.
#' Position Group  - options include:
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL
#'  * Special Teams: K, P, LS, PK
#'
#' @return [cfbd_metrics_wepa_players_rushing()] - A data frame with 8 variables:
#'
#'  |col_name     |types     |description                                                                       |
#'  |:------------|:---------|:---------------------------------------------------------------------------------|
#'  |year         |integer   |Four-digit season year (e.g. 2019).                                               |
#'  |athlete_id   |character |CFBD athlete identifier (use with `cfbd_player_info()`).                          |
#'  |athlete_name |character |Player full name.                                                                 |
#'  |position     |character |Player position abbreviation (e.g. "RB", "QB").                                   |
#'  |team         |character |Full team name (e.g. "TCU").                                                      |
#'  |conference   |character |Team conference name (e.g. "Big 12").                                             |
#'  |wepa         |numeric   |Opponent-adjusted weighted EPA (rushing predicted points added).                  |
#'  |plays        |integer   |Total qualifying rushing plays included in the WEPA calculation.                  |
#'
#' @keywords Opponent Adjusted Players Rushing Predicted Points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Metrics
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_wepa_players_rushing(year = 2019, team = "TCU"))
#' }

cfbd_metrics_wepa_players_rushing <- function(year = NULL,
                                              team = NULL,
                                              conference = NULL,
                                              position = NULL) {

  # Validation Lists ----
  pos_groups <- c(
    "QB", "RB", "FB", "TE", "WR", "OL", "OT", "G", "OC",
    "DB", "CB", "S", "LB", "DE", "NT", "DL", "DT",
    "K", "P", "PK", "LS"
  )

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_list(position, pos_groups)
  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/wepa/players/rushing"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference,
    "position" = position
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
        jsonlite::fromJSON(flatten = TRUE) %>%
        janitor::clean_names()


      df <- df %>%
        make_cfbfastR_data("Opponent-adjusted players rushing PPA data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no opponent-adjusted players rushing PPA data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get Points Added Above Replacement (PAAR) ratings for kickers**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#'
#' @return [cfbd_metrics_wepa_players_kicking()] - A data frame with 7 variables:
#'
#'  |col_name     |types     |description                                                                       |
#'  |:------------|:---------|:---------------------------------------------------------------------------------|
#'  |year         |integer   |Four-digit season year (e.g. 2019).                                               |
#'  |athlete_id   |character |CFBD athlete identifier (use with `cfbd_player_info()`).                          |
#'  |athlete_name |character |Kicker full name.                                                                 |
#'  |team         |character |Full team name (e.g. "TCU").                                                      |
#'  |conference   |character |Team conference name (e.g. "Big 12").                                             |
#'  |paar         |numeric   |Points Added Above Replacement on field goal attempts (kicker value vs baseline). |
#'  |attempts     |integer   |Total field goal attempts included in the PAAR calculation.                       |
#'
#' @keywords Points Added Above Replacement (PAAR) ratings for kickers
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Metrics
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_wepa_players_kicking(year = 2019, team = "TCU"))
#' }

cfbd_metrics_wepa_players_kicking <- function(year = NULL,
                                              team = NULL,
                                              conference = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/wepa/players/kicking"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference
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
        jsonlite::fromJSON(flatten = TRUE) %>%
        janitor::clean_names()


      df <- df %>%
        make_cfbfastR_data("Points Added Above Replacement (PAAR) ratings for kicking data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no Points Added Above Replacement (PAAR) ratings for kicking data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get team game averages for predicted points added (PPA)**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param season_type (*String* default both): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE or FALSE)
#'
#' @return [cfbd_metrics_ppa_games()] - A data frame with 19 variables:
#'
#'  |col_name        |types     |description                                                                       |
#'  |:---------------|:---------|:---------------------------------------------------------------------------------|
#'  |game_id         |integer   |Referencing game id.                                                              |
#'  |season          |integer   |Season of the game.                                                               |
#'  |week            |integer   |Game week of the season.                                                          |
#'  |season_type     |character |Season type (regular, postseason, etc.).                                          |
#'  |conference      |character |Conference of the team.                                                           |
#'  |team            |character |Team name.                                                                        |
#'  |opponent        |character |Team opponent name.                                                               |
#'  |off_overall     |numeric   |Offense overall predicted points added (PPA).                                     |
#'  |off_passing     |numeric   |Offense passing predicted points added (PPA).                                     |
#'  |off_rushing     |numeric   |Offense rushing predicted points added (PPA).                                     |
#'  |off_first_down  |numeric   |Offense 1st down predicted points added (PPA).                                    |
#'  |off_second_down |numeric   |Offense 2nd down predicted points added (PPA).                                    |
#'  |off_third_down  |numeric   |Offense 3rd down predicted points added (PPA).                                    |
#'  |def_overall     |numeric   |Defense overall predicted points added (PPA).                                     |
#'  |def_passing     |numeric   |Defense passing predicted points added (PPA).                                     |
#'  |def_rushing     |numeric   |Defense rushing predicted points added (PPA).                                     |
#'  |def_first_down  |numeric   |Defense 1st down predicted points added (PPA).                                    |
#'  |def_second_down |numeric   |Defense 2nd down predicted points added (PPA).                                    |
#'  |def_third_down  |numeric   |Defense 3rd down predicted points added (PPA).                                    |
#'
#' @keywords Teams Predicted Points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Metrics
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_ppa_games(year = 2019, team = "TCU"))
#' }

cfbd_metrics_ppa_games <- function(year,
                                   week = NULL,
                                   season_type = "both",
                                   team = NULL,
                                   conference = NULL,
                                   excl_garbage_time = FALSE) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)
  validate_list(excl_garbage_time, c(T,F))

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ppa/games"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
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
        dplyr::rename(
          "game_id" = "gameId",
          "season_type" = "seasonType"
        ) %>%
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
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*).
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier. Required if team not provided.
#' @param season_type (*String* default both): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
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
#' @return [cfbd_metrics_ppa_players_games()] - A data frame with 10 variables:
#'
#'  |col_name     |types     |description                                                                       |
#'  |:------------|:---------|:---------------------------------------------------------------------------------|
#'  |season       |integer   |Season of the game.                                                               |
#'  |week         |integer   |Game week of the season.                                                          |
#'  |athlete_id   |character |Athlete referencing id.                                                           |
#'  |name         |character |Athlete name.                                                                     |
#'  |position     |character |Athlete position.                                                                 |
#'  |team         |character |Team name.                                                                        |
#'  |opponent     |character |Team opponent name.                                                               |
#'  |avg_PPA_all  |numeric   |Average overall predicted points added (PPA).                                     |
#'  |avg_PPA_pass |numeric   |Average passing predicted points added (PPA).                                     |
#'  |avg_PPA_rush |numeric   |Average rushing predicted points added (PPA).                                     |
#'
#' @keywords Players Predicted Points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Metrics
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_ppa_players_games(year = 2019, week = 3, team = "TCU"))
#' }

cfbd_metrics_ppa_players_games <- function(year = NULL,
                                           week = NULL,
                                           season_type = "both",
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
  validate_season_type(season_type)
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
    "seasonType" = season_type,
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
        jsonlite::fromJSON(flatten = TRUE) %>%
        dplyr::rename(
          "season_type" = "seasonType",
          "athlete_id" = "id"
        )
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
#'
#'  |col_name                 |types     |description                                                                       |
#'  |:------------------------|:---------|:---------------------------------------------------------------------------------|
#'  |season                   |integer   |Four-digit season year.                                                           |
#'  |athlete_id               |character |Athlete referencing id.                                                           |
#'  |name                     |character |Athlete name.                                                                     |
#'  |position                 |character |Athlete position abbreviation (e.g. "QB", "RB").                                  |
#'  |team                     |character |Team name.                                                                        |
#'  |conference               |character |Team conference name.                                                             |
#'  |countable_plays          |integer   |DEPRECATED Number of plays which can be counted.                                  |
#'  |avg_PPA_all              |numeric   |Average overall predicted points added (PPA).                                     |
#'  |avg_PPA_pass             |numeric   |Average passing predicted points added (PPA).                                     |
#'  |avg_PPA_rush             |numeric   |Average rushing predicted points added (PPA).                                     |
#'  |avg_PPA_first_down       |numeric   |Average 1st down predicted points added (PPA).                                    |
#'  |avg_PPA_second_down      |numeric   |Average 2nd down predicted points added (PPA).                                    |
#'  |avg_PPA_third_down       |numeric   |Average 3rd down predicted points added (PPA).                                    |
#'  |avg_PPA_standard_downs   |numeric   |Average standard down predicted points added (PPA).                               |
#'  |avg_PPA_passing_downs    |numeric   |Average passing down predicted points added (PPA).                                |
#'  |total_PPA_all            |numeric   |Total overall predicted points added (PPA).                                       |
#'  |total_PPA_pass           |numeric   |Total passing predicted points added (PPA).                                       |
#'  |total_PPA_rush           |numeric   |Total rushing predicted points added (PPA).                                       |
#'  |total_PPA_first_down     |numeric   |Total 1st down predicted points added (PPA).                                      |
#'  |total_PPA_second_down    |numeric   |Total 2nd down predicted points added (PPA).                                      |
#'  |total_PPA_third_down     |numeric   |Total 3rd down predicted points added (PPA).                                      |
#'  |total_PPA_standard_downs |numeric   |Total standard down predicted points added (PPA).                                 |
#'  |total_PPA_passing_downs  |numeric   |Total passing down predicted points added (PPA).                                  |
#'
#' @keywords Players Predicted Points Season Averages
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Metrics
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
#'
#'  |col_name         |types     |description                                                                       |
#'  |:----------------|:---------|:---------------------------------------------------------------------------------|
#'  |yard_line        |integer   |Yards to goal.                                                                    |
#'  |predicted_points |numeric   |Predicted points in that down-distance-yardline scenario.                         |
#'
#' @keywords Predicted Points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Metrics
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
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Required if team not provided
#' @param team (*String* optional): D-I Team. Required if year not provided
#' @param conference (*String* optional): Conference name - select a valid FBS conference
#' Conference names P5: ACC,  Big 12, Big Ten, SEC, Pac-12
#' Conference names G5 and FBS Independents: Conference USA, Mid-American, Mountain West, FBS Independents, American Athletic
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE or FALSE)
#'
#' @return [cfbd_metrics_ppa_teams()] - A data frame with 21 variables:
#'
#'  |col_name               |types     |description                                                                       |
#'  |:----------------------|:---------|:---------------------------------------------------------------------------------|
#'  |season                 |integer   |Four-digit season year.                                                           |
#'  |conference             |character |Team conference name.                                                             |
#'  |team                   |character |Team name.                                                                        |
#'  |off_overall            |numeric   |Offense overall predicted points added (PPA).                                     |
#'  |off_passing            |numeric   |Offense passing predicted points added (PPA).                                     |
#'  |off_rushing            |numeric   |Offense rushing predicted points added (PPA).                                     |
#'  |off_first_down         |numeric   |Offense 1st down predicted points added (PPA).                                    |
#'  |off_second_down        |numeric   |Offense 2nd down predicted points added (PPA).                                    |
#'  |off_third_down         |numeric   |Offense 3rd down predicted points added (PPA).                                    |
#'  |off_cumulative_total   |numeric   |Offense cumulative total predicted points added (PPA).                            |
#'  |off_cumulative_passing |numeric   |Offense cumulative total passing predicted points added (PPA).                    |
#'  |off_cumulative_rushing |numeric   |Offense cumulative total rushing predicted points added (PPA).                    |
#'  |def_overall            |numeric   |Defense overall predicted points added (PPA).                                     |
#'  |def_passing            |numeric   |Defense passing predicted points added (PPA).                                     |
#'  |def_rushing            |numeric   |Defense rushing predicted points added (PPA).                                     |
#'  |def_first_down         |numeric   |Defense 1st down predicted points added (PPA).                                    |
#'  |def_second_down        |numeric   |Defense 2nd down predicted points added (PPA).                                    |
#'  |def_third_down         |numeric   |Defense 3rd down predicted points added (PPA).                                    |
#'  |def_cumulative_total   |numeric   |Defense cumulative total predicted points added (PPA).                            |
#'  |def_cumulative_passing |numeric   |Defense cumulative total passing predicted points added (PPA).                    |
#'  |def_cumulative_rushing |numeric   |Defense cumulative total rushing predicted points added (PPA).                    |
#'
#' @keywords Teams Predicted Points
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @family CFBD Metrics
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
#' @param season_type (*String* default both): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#'
#' @return [cfbd_metrics_wp_pregame()] - A data frame with 9 variables:
#'
#'  |col_name      |types     |description                                                                       |
#'  |:-------------|:---------|:---------------------------------------------------------------------------------|
#'  |season        |integer   |Season of the game.                                                               |
#'  |season_type   |character |Season type of the game (regular, postseason, etc.).                              |
#'  |week          |integer   |Game week of the season.                                                          |
#'  |game_id       |integer   |Referencing game id.                                                              |
#'  |home_team     |character |Home team name.                                                                   |
#'  |away_team     |character |Away team name.                                                                   |
#'  |spread        |numeric   |Betting line provider spread.                                                     |
#'  |home_win_prob |numeric   |Home win probability - pre-game prediction (0-1).                                 |
#'  |away_win_prob |numeric   |Away win probability - pre-game prediction (0-1).                                 |
#'
#' @keywords Pre-game Win Probability Data
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Metrics
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_metrics_wp_pregame(year = 2019, week = 9, team = "Texas A&M"))
#' }

cfbd_metrics_wp_pregame <- function(year = NULL,
                                    week = NULL,
                                    team = NULL,
                                    season_type = "both") {

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
        dplyr::rename("home_win_prob" = "home_win_probability") %>%
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
#'
#'  |col_name      |types     |description                                                                       |
#'  |:-------------|:---------|:---------------------------------------------------------------------------------|
#'  |play_id       |character |Play referencing id.                                                              |
#'  |play_text     |character |A text description of the play.                                                   |
#'  |home_id       |integer   |Home team referencing id.                                                         |
#'  |home          |character |Home team name.                                                                   |
#'  |away_id       |integer   |Away team referencing id.                                                         |
#'  |away          |character |Away team name.                                                                   |
#'  |spread        |numeric   |Betting lines provider spread.                                                    |
#'  |home_ball     |logical   |Home team has the ball.                                                           |
#'  |home_score    |integer   |Home team score.                                                                  |
#'  |away_score    |integer   |Away team score.                                                                  |
#'  |down          |integer   |Down of the play.                                                                 |
#'  |distance      |integer   |Distance to the sticks (to 1st down marker or goal-line in goal-to-go situations).|
#'  |home_win_prob |numeric   |Home team win probability (0-1).                                                  |
#'  |away_win_prob |numeric   |Away team win probability (0-1).                                                  |
#'  |play_number   |integer   |Game play number.                                                                 |
#'  |yard_line     |integer   |Yard line of the play (0-100 yards).                                              |
#'
#' @keywords Win Probability Chart Data
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Metrics
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
        dplyr::rename("home_win_prob" = "home_win_probability") %>%
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
