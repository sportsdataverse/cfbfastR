#' @name cfbd_stats
#' @title
#' **CFBD Stats Endpoint Overview**
#' @description
#'
#' * `cfbd_stats_categories()`: Get college football mapping for stats categories.
#' * `cfbd_stats_season_team()`: Get season statistics by team.
#' * `cfbd_stats_season_advanced()`: Get season advanced statistics by team.
#' * `cfbd_stats_game_advanced()`: Get game advanced stats.
#' * `cfbd_stats_season_player()`: Get season statistics by player.
#' * `cfbd_stats_player_success()`: Get player success rates by season.
#' * `cfbd_stats_player_success_game()`: Get player success rates by game.
#'
#' @details
#' ### **Get game advanced stats**
#' ```r
#' cfbd_stats_game_advanced(year = 2018, week = 12, team = "Texas A&M")
#'
#' cfbd_stats_game_advanced(2019, team = "LSU")
#'
#' cfbd_stats_game_advanced(2013, team = "Florida State")
#' ```
#'
#' ### **Get season advanced statistics by team**
#' ```r
#' cfbd_stats_season_advanced(2019, team = "LSU")
#' ```
#'
#' ### **Get season statistics by player**
#' ```r
#' cfbd_stats_season_player(year = 2018, conference = "B12", start_week = 1, end_week = 7)
#'
#' cfbd_stats_season_player(2019, team = "LSU", category = "passing")
#'
#' cfbd_stats_season_player(2013, team = "Florida State", category = "passing")
#' ```
#' ### **Get season statistics by team**
#' ```r
#' cfbd_stats_season_team(year = 2018, conference = "B12", start_week = 1, end_week = 8)
#'
#' cfbd_stats_season_team(2019, team = "LSU")
#'
#' cfbd_stats_season_team(2013, team = "Florida State")
#' ````
#'
#' ### **Get stats categories**
#'
#' This function identifies all Stats Categories identified in the regular stats endpoint.
#' ```r
#' cfbd_stats_categories()
#' ````
#'
#' ## **Get player success rates by season**
#'
#' ```r
#' cfbd_stats_player_success(year = 2024, team = "Georgia")
#' ```
#'
#' ## **Get player success rates by game**
#'
#' ```r
#' cfbd_stats_player_success_game(year = 2024, week = 5)
#' ```

NULL

#' @title
#' **Get stats categories**
#' @description
#' This function identifies all Stats Categories identified in the regular stats endpoint.
#' @examples
#' \donttest{
#'    try(cfbd_stats_categories())
#' }
#' @return [cfbd_stats_categories()] A data frame with 1 variable:
#'
#'    |col_name |types     |description                                                       |
#'    |:--------|:---------|:-----------------------------------------------------------------|
#'    |category |character |CFBD stats category name (e.g. passing, rushing, defensive).      |
#'
#' @keywords Stats Categories
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @family CFBD Stats
#' @export
#'
cfbd_stats_categories <- function() {

  # Validation ----
  validate_api_key()

  # Query API ----
  full_url <- "https://api.collegefootballdata.com/stats/categories"

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as list
      list <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON()
      df <- as.data.frame(matrix(unlist(list), nrow = length(list), byrow = TRUE)) |>
        dplyr::rename("category" = "V1")


      df <- df |>
        make_cfbfastR_data("Stat categories for CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no stats categories data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get game advanced stats**
#' @param year (*Integer* required): Year, 4 digit format(*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_stats_game_advanced', 'min_year']`
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param team (*String* optional): D-I Team
#' @param opponent (*String* optional): Opponent D-I Team
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE/FALSE)
#' @param season_type (*String* default both): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#'
#' @return [cfbd_stats_game_advanced()] - A data frame with 60 variables:
#'
#'    |col_name                          |types     |description                                                      |
#'    |:---------------------------------|:---------|:----------------------------------------------------------------|
#'    |game_id                           |integer   |Referencing game id.                                             |
#'    |season                            |integer   |Season of the game.                                              |
#'    |week                              |integer   |Game week of the season.                                         |
#'    |team                              |character |Team name.                                                       |
#'    |opponent                          |character |Opponent team name.                                              |
#'    |off_plays                         |integer   |Offense plays in the game.                                       |
#'    |off_drives                        |integer   |Offense drives in the game.                                      |
#'    |off_ppa                           |double    |Offense predicted points added (PPA).                            |
#'    |off_total_ppa                     |double    |Offense total predicted points added (PPA).                      |
#'    |off_success_rate                  |double    |Offense success rate.                                            |
#'    |off_explosiveness                 |double    |Offense explosiveness rate.                                      |
#'    |off_power_success                 |double    |Offense power success rate.                                      |
#'    |off_stuff_rate                    |double    |Opponent stuff rate.                                             |
#'    |off_line_yds                      |double    |Offensive line yards.                                            |
#'    |off_line_yds_total                |integer   |Offensive line yards total.                                      |
#'    |off_second_lvl_yds                |double    |Offense second-level yards.                                      |
#'    |off_second_lvl_yds_total          |integer   |Offense second-level yards total.                                |
#'    |off_open_field_yds                |integer   |Offense open field yards.                                        |
#'    |off_open_field_yds_total          |integer   |Offense open field yards total.                                  |
#'    |off_standard_downs_ppa            |double    |Offense standard downs predicted points added (PPA).             |
#'    |off_standard_downs_success_rate   |double    |Offense standard downs success rate.                             |
#'    |off_standard_downs_explosiveness  |double    |Offense standard downs explosiveness rate.                       |
#'    |off_passing_downs_ppa             |double    |Offense passing downs predicted points added (PPA).              |
#'    |off_passing_downs_success_rate    |double    |Offense passing downs success rate.                              |
#'    |off_passing_downs_explosiveness   |double    |Offense passing downs explosiveness rate.                        |
#'    |off_rushing_plays_ppa             |double    |Offense rushing plays predicted points added (PPA).              |
#'    |off_rushing_plays_total_ppa       |double    |Offense rushing plays total predicted points added (PPA).        |
#'    |off_rushing_plays_success_rate    |double    |Offense rushing plays success rate.                              |
#'    |off_rushing_plays_explosiveness   |double    |Offense rushing plays explosiveness rate.                        |
#'    |off_passing_plays_ppa             |double    |Offense passing plays predicted points added (PPA).              |
#'    |off_passing_plays_total_ppa       |double    |Offense passing plays total predicted points added (PPA).        |
#'    |off_passing_plays_success_rate    |double    |Offense passing plays success rate.                              |
#'    |off_passing_plays_explosiveness   |double    |Offense passing plays explosiveness rate.                        |
#'    |def_plays                         |integer   |Defense plays in the game.                                       |
#'    |def_drives                        |integer   |Defense drives in the game.                                      |
#'    |def_ppa                           |double    |Defense predicted points added (PPA).                            |
#'    |def_total_ppa                     |double    |Defense total predicted points added (PPA).                      |
#'    |def_success_rate                  |double    |Defense success rate.                                            |
#'    |def_explosiveness                 |double    |Defense explosiveness rate.                                      |
#'    |def_power_success                 |double    |Defense power success rate.                                      |
#'    |def_stuff_rate                    |double    |Opponent stuff rate.                                             |
#'    |def_line_yds                      |double    |Offensive line yards.                                            |
#'    |def_line_yds_total                |integer   |Offensive line yards total.                                      |
#'    |def_second_lvl_yds                |double    |Defense second-level yards.                                      |
#'    |def_second_lvl_yds_total          |integer   |Defense second-level yards total.                                |
#'    |def_open_field_yds                |integer   |Defense open field yards.                                        |
#'    |def_open_field_yds_total          |integer   |Defense open field yards total.                                  |
#'    |def_standard_downs_ppa            |double    |Defense standard downs predicted points added (PPA).             |
#'    |def_standard_downs_success_rate   |double    |Defense standard downs success rate.                             |
#'    |def_standard_downs_explosiveness  |double    |Defense standard downs explosiveness rate.                       |
#'    |def_passing_downs_ppa             |double    |Defense passing downs predicted points added (PPA).              |
#'    |def_passing_downs_success_rate    |double    |Defense passing downs success rate.                              |
#'    |def_passing_downs_explosiveness   |double    |Defense passing downs explosiveness rate.                        |
#'    |def_rushing_plays_ppa             |double    |Defense rushing plays predicted points added (PPA).              |
#'    |def_rushing_plays_total_ppa       |double    |Defense rushing plays total predicted points added (PPA).        |
#'    |def_rushing_plays_success_rate    |double    |Defense rushing plays success rate.                              |
#'    |def_rushing_plays_explosiveness   |double    |Defense rushing plays explosiveness rate.                        |
#'    |def_passing_plays_ppa             |double    |Defense passing plays predicted points added (PPA).              |
#'    |def_passing_plays_total_ppa       |double    |Defense passing plays total predicted points added (PPA).        |
#'    |def_passing_plays_success_rate    |double    |Defense passing plays success rate.                              |
#'    |def_passing_plays_explosiveness   |double    |Defense passing plays explosiveness rate.                        |
#'
#' @keywords Game Advanced Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Stats
#' @export
#' @examples
#' \donttest{
#'    try(cfbd_stats_game_advanced(year = 2018, week = 12, team = "Texas A&M"))
#'
#'    try(cfbd_stats_game_advanced(2019, team = "LSU"))
#'
#'    try(cfbd_stats_game_advanced(2013, team = "Florida State"))
#' }
#'
cfbd_stats_game_advanced <- function(year,
                                     week = NULL,
                                     team = NULL,
                                     opponent = NULL,
                                     excl_garbage_time = FALSE,
                                     season_type = "both") {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_list(excl_garbage_time, c(T,F))
  validate_season_type(season_type)

  # Team Name Handling ----
  team <- handle_accents(team)
  opponent <- handle_accents(opponent)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/stats/game/advanced"
  query_params <- list(
    "year" = year,
    "week" = week,
    "team" = team,
    "opponent" = opponent,
    "excludeGarbageTime" = excl_garbage_time,
    "seasonType" = season_type
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content, flatten and return result as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        as.data.frame()

      # Column renaming for the 76 returned columns
      colnames(df) <- gsub("offense.", "off_", colnames(df))
      colnames(df) <- gsub("defense.", "def_", colnames(df))
      colnames(df) <- gsub("Rate", "_rate", colnames(df))
      colnames(df) <- gsub("Total", "_total", colnames(df))
      colnames(df) <- gsub("Downs", "_downs", colnames(df))
      colnames(df) <- gsub("lineYards", "line_yds", colnames(df))
      colnames(df) <- gsub("secondLevelYards", "second_lvl_yds", colnames(df))
      colnames(df) <- gsub("openFieldYards", "open_field_yds", colnames(df))
      colnames(df) <- gsub("Success", "_success", colnames(df))
      colnames(df) <- gsub("fieldPosition", "field_pos", colnames(df))
      colnames(df) <- gsub("pointsPerOpportunity", "pts_per_opp", colnames(df))
      colnames(df) <- gsub("average", "avg_", colnames(df))
      colnames(df) <- gsub("Plays", "_plays", colnames(df))
      colnames(df) <- gsub("PPA", "_ppa", colnames(df))
      colnames(df) <- gsub("PredictedPoints", "predicted_points", colnames(df))
      colnames(df) <- gsub("Seven", "_seven", colnames(df))
      colnames(df) <- gsub(".avg", "_avg", colnames(df))
      colnames(df) <- gsub(".rate", "_rate", colnames(df))
      colnames(df) <- gsub(".explosiveness", "_explosiveness", colnames(df))
      colnames(df) <- gsub(".ppa", "_ppa", colnames(df))
      colnames(df) <- gsub(".total", "_total", colnames(df))
      colnames(df) <- gsub(".success", "_success", colnames(df))
      colnames(df) <- gsub(".front", "_front", colnames(df))
      colnames(df) <- gsub("_Start", "_start", colnames(df))
      colnames(df) <- gsub(".db", "_db", colnames(df))
      colnames(df) <- gsub("Id", "_id", colnames(df))
      colnames(df) <- gsub("seasonType", "season_type", colnames(df))



      df <- df |>
        make_cfbfastR_data("Advanced game stats from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no game advanced stats data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get season advanced statistics by team**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_stats_season_advanced', 'min_year']`
#' @param team (*String* optional): D-I Team
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE/FALSE)
#' @param start_week (*Integer* optional): Starting Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param end_week (*Integer* optional): Ending Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#'
#' @param division (*String* optional): Division/classification filter -- one of `fbs`, `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.
#' @return [cfbd_stats_season_advanced()] - A data frame with 82 variables:
#'
#'    |col_name                            |types     |description                                                       |
#'    |:-----------------------------------|:---------|:-----------------------------------------------------------------|
#'    |season                              |integer   |Season of the statistics.                                         |
#'    |team                                |character |Team name.                                                        |
#'    |conference                          |character |Conference of the team.                                           |
#'    |off_plays                           |integer   |Offense plays in the game.                                        |
#'    |off_drives                          |integer   |Offense drives in the game.                                       |
#'    |off_ppa                             |double    |Offense predicted points added (PPA).                             |
#'    |off_total_ppa                       |double    |Offense total predicted points added (PPA).                       |
#'    |off_success_rate                    |double    |Offense success rate.                                             |
#'    |off_explosiveness                   |double    |Offense explosiveness rate.                                       |
#'    |off_power_success                   |double    |Offense power success rate.                                       |
#'    |off_stuff_rate                      |double    |Offense rushing stuff rate.                                       |
#'    |off_line_yds                        |double    |Offensive line yards.                                             |
#'    |off_line_yds_total                  |integer   |Offensive line yards total.                                       |
#'    |off_second_lvl_yds                  |double    |Offense second-level yards.                                       |
#'    |off_second_lvl_yds_total            |integer   |Offense second-level yards total.                                 |
#'    |off_open_field_yds                  |integer   |Offense open field yards.                                         |
#'    |off_open_field_yds_total            |integer   |Offense open field yards total.                                   |
#'    |off_total_opportunities             |integer   |Offense opportunities.                                            |
#'    |off_pts_per_opp                     |double    |Offense points per scoring opportunity.                           |
#'    |off_field_pos_avg_start             |double    |Offense starting average field position.                          |
#'    |off_field_pos_avg_predicted_points  |double    |Offense starting average field position predicted points (PP).    |
#'    |off_havoc_total                     |double    |Offense havoc rate total.                                         |
#'    |off_havoc_front_seven               |double    |Offense front-7 havoc rate.                                       |
#'    |off_havoc_db                        |double    |Offense defensive back havoc rate.                                |
#'    |off_standard_downs_rate             |double    |Offense standard downs rate.                                      |
#'    |off_standard_downs_ppa              |double    |Offense standard downs predicted points added (PPA).              |
#'    |off_standard_downs_success_rate     |double    |Offense standard downs success rate.                              |
#'    |off_standard_downs_explosiveness    |double    |Offense standard downs explosiveness rate.                        |
#'    |off_passing_downs_rate              |double    |Offense passing downs rate.                                       |
#'    |off_passing_downs_ppa               |double    |Offense passing downs predicted points added (PPA).               |
#'    |off_passing_downs_success_rate      |double    |Offense passing downs success rate.                               |
#'    |off_passing_downs_explosiveness     |double    |Offense passing downs explosiveness rate.                         |
#'    |off_rushing_plays_rate              |double    |Offense rushing plays rate.                                       |
#'    |off_rushing_plays_ppa               |double    |Offense rushing plays predicted points added (PPA).               |
#'    |off_rushing_plays_total_ppa         |double    |Offense rushing plays total predicted points added (PPA).         |
#'    |off_rushing_plays_success_rate      |double    |Offense rushing plays success rate.                               |
#'    |off_rushing_plays_explosiveness     |double    |Offense rushing plays explosiveness rate.                         |
#'    |off_passing_plays_rate              |double    |Offense passing plays rate.                                       |
#'    |off_passing_plays_ppa               |double    |Offense passing plays predicted points added (PPA).               |
#'    |off_passing_plays_total_ppa         |double    |Offense passing plays total predicted points added (PPA).         |
#'    |off_passing_plays_success_rate      |double    |Offense passing plays success rate.                               |
#'    |off_passing_plays_explosiveness     |double    |Offense passing plays explosiveness rate.                         |
#'    |def_plays                           |integer   |Defense plays in the game.                                        |
#'    |def_drives                          |integer   |Defense drives in the game.                                       |
#'    |def_ppa                             |double    |Defense predicted points added (PPA).                             |
#'    |def_total_ppa                       |double    |Defense total predicted points added (PPA).                       |
#'    |def_success_rate                    |double    |Defense success rate.                                             |
#'    |def_explosiveness                   |double    |Defense explosiveness rate.                                       |
#'    |def_power_success                   |double    |Defense power success rate.                                       |
#'    |def_stuff_rate                      |double    |Defense rushing stuff rate.                                       |
#'    |def_line_yds                        |double    |Defense Offensive line yards allowed.                             |
#'    |def_line_yds_total                  |integer   |Defense Offensive line yards total allowed.                       |
#'    |def_second_lvl_yds                  |double    |Defense second-level yards.                                       |
#'    |def_second_lvl_yds_total            |integer   |Defense second-level yards total.                                 |
#'    |def_open_field_yds                  |integer   |Defense open field yards.                                         |
#'    |def_open_field_yds_total            |integer   |Defense open field yards total.                                   |
#'    |def_total_opportunities             |integer   |Defense opportunities.                                            |
#'    |def_pts_per_opp                     |double    |Defense points per scoring opportunity.                           |
#'    |def_field_pos_avg_start             |double    |Defense starting average field position.                          |
#'    |def_field_pos_avg_predicted_points  |double    |Defense starting average field position predicted points (PP).    |
#'    |def_havoc_total                     |double    |Defense havoc rate total.                                         |
#'    |def_havoc_front_seven               |double    |Defense front-7 havoc rate.                                       |
#'    |def_havoc_db                        |double    |Defense defensive back havoc rate.                                |
#'    |def_standard_downs_rate             |double    |Defense standard downs rate.                                      |
#'    |def_standard_downs_ppa              |double    |Defense standard downs predicted points added (PPA).              |
#'    |def_standard_downs_success_rate     |double    |Defense standard downs success rate.                              |
#'    |def_standard_downs_explosiveness    |double    |Defense standard downs explosiveness rate.                        |
#'    |def_passing_downs_rate              |double    |Defense passing downs rate.                                       |
#'    |def_passing_downs_ppa               |double    |Defense passing downs predicted points added (PPA).               |
#'    |def_passing_downs_success_rate      |double    |Defense passing downs success rate.                               |
#'    |def_passing_downs_explosiveness     |double    |Defense passing downs explosiveness rate.                         |
#'    |def_rushing_plays_rate              |double    |Defense rushing plays rate.                                       |
#'    |def_rushing_plays_ppa               |double    |Defense rushing plays predicted points added (PPA).               |
#'    |def_rushing_plays_total_ppa         |double    |Defense rushing plays total predicted points added (PPA).         |
#'    |def_rushing_plays_success_rate      |double    |Defense rushing plays success rate.                               |
#'    |def_rushing_plays_explosiveness     |double    |Defense rushing plays explosiveness rate.                         |
#'    |def_passing_plays_rate              |double    |Defense passing plays rate.                                       |
#'    |def_passing_plays_ppa               |double    |Defense passing plays predicted points added (PPA).               |
#'    |def_passing_plays_total_ppa         |double    |Defense passing plays total predicted points added (PPA).         |
#'    |def_passing_plays_success_rate      |double    |Defense passing plays success rate.                               |
#'    |def_passing_plays_explosiveness     |double    |Defense passing plays explosiveness rate.                         |
#'
#' @keywords Team Season Advanced Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Stats
#' @export
#' @examples
#' \donttest{
#'    try(cfbd_stats_season_advanced(2019, team = "LSU"))
#' }

cfbd_stats_season_advanced <- function(year,
                                       team = NULL,
                                       excl_garbage_time = FALSE,
                                       start_week = NULL,
                                       end_week = NULL,
                                       division = NULL) {

  # Validation ----
  validate_api_key()
  validate_division(division)
  validate_year(year)
  validate_list(excl_garbage_time, c(T,F))
  validate_week(start_week)
  validate_week(end_week)
  validate_range(end_week - start_week, 0)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/stats/season/advanced"
  query_params <- list(
    "year" = year,
    "team" = team,
    "excludeGarbageTime" = excl_garbage_time,
    "startWeek" = start_week,
    "endWeek" = end_week,
    "classification" = division
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return result as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      colnames(df) <- gsub("offense.", "off_", colnames(df))
      colnames(df) <- gsub("defense.", "def_", colnames(df))
      colnames(df) <- gsub("Rate", "_rate", colnames(df))
      colnames(df) <- gsub("Total", "_total", colnames(df))
      colnames(df) <- gsub("Downs", "_downs", colnames(df))
      colnames(df) <- gsub("lineYards", "line_yds", colnames(df))
      colnames(df) <- gsub("secondLevelYards", "second_lvl_yds", colnames(df))
      colnames(df) <- gsub("openFieldYards", "open_field_yds", colnames(df))
      colnames(df) <- gsub("Success", "_success", colnames(df))
      colnames(df) <- gsub("fieldPosition", "field_pos", colnames(df))
      colnames(df) <- gsub("pointsPerOpportunity", "pts_per_opp", colnames(df))
      colnames(df) <- gsub("average", "avg_", colnames(df))
      colnames(df) <- gsub("Plays", "_plays", colnames(df))
      colnames(df) <- gsub("PPA", "_ppa", colnames(df))
      colnames(df) <- gsub("PredictedPoints", "predicted_points", colnames(df))
      colnames(df) <- gsub("Seven", "_seven", colnames(df))
      colnames(df) <- gsub(".avg", "_avg", colnames(df))
      colnames(df) <- gsub(".rate", "_rate", colnames(df))
      colnames(df) <- gsub(".explosiveness", "_explosiveness", colnames(df))
      colnames(df) <- gsub(".ppa", "_ppa", colnames(df))
      colnames(df) <- gsub(".total", "_total", colnames(df))
      colnames(df) <- gsub(".success", "_success", colnames(df))
      colnames(df) <- gsub(".front", "_front", colnames(df))
      colnames(df) <- gsub("_Start", "_start", colnames(df))
      colnames(df) <- gsub(".db", "_db", colnames(df))
      colnames(df) <- gsub("Opportunies", "_opportunities", colnames(df))


      df <- df |>
        make_cfbfastR_data("Advanced season stats from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no season advanced stats data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **Get season statistics by player**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_stats_season_player', 'min_year']`
#' @param season_type (*String* default both): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param start_week (*Integer* optional): Starting Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param end_week (*Integer* optional): Ending Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param category (*String* optional): Category filter (e.g defensive)
#' Offense: passing, receiving, rushing
#' Defense: defensive, fumbles, interceptions
#' Special Teams: punting, puntReturns, kicking, kickReturns
#'
#' @return [cfbd_stats_season_player()] - A data frame with 59 variables:
#'
#'    |col_name             |types     |description                                            |
#'    |:--------------------|:---------|:------------------------------------------------------|
#'    |year                 |integer   |Season of the player stats.                            |
#'    |team                 |character |Team name.                                             |
#'    |conference           |character |Conference of the team.                                |
#'    |athlete_id           |character |Athlete referencing id.                                |
#'    |player               |character |Player name.                                           |
#'    |position             |character |Player position.                                       |
#'    |passing_completions  |double    |Passing completions.                                   |
#'    |passing_att          |double    |Passing attempts.                                      |
#'    |passing_pct          |double    |Passing completion percentage.                         |
#'    |passing_yds          |double    |Passing yardage.                                       |
#'    |passing_td           |double    |Passing touchdowns.                                    |
#'    |passing_int          |double    |Passing interceptions.                                 |
#'    |passing_ypa          |double    |Passing yards per attempt.                             |
#'    |rushing_car          |double    |Rushing yards per carry.                               |
#'    |rushing_yds          |double    |Rushing yards total.                                   |
#'    |rushing_td           |double    |Rushing touchdowns.                                    |
#'    |rushing_ypc          |double    |Rushing yards per carry.                               |
#'    |rushing_long         |double    |Rushing longest yardage attempt.                       |
#'    |receiving_rec        |double    |Receiving - pass receptions.                           |
#'    |receiving_yds        |double    |Receiving - pass reception yards.                      |
#'    |receiving_td         |double    |Receiving - passing reception touchdowns.              |
#'    |receiving_ypr        |double    |Receiving - passing yards per reception.               |
#'    |receiving_long       |double    |Receiving - longest pass reception yardage.            |
#'    |fumbles_fum          |double    |Fumbles.                                               |
#'    |fumbles_rec          |double    |Fumbles recovered.                                     |
#'    |fumbles_lost         |double    |Fumbles lost.                                          |
#'    |defensive_solo       |double    |Defensive solo tackles.                                |
#'    |defensive_tot        |double    |Defensive total tackles.                               |
#'    |defensive_tfl        |double    |Defensive tackles for loss.                            |
#'    |defensive_sacks      |double    |Defensive sacks.                                       |
#'    |defensive_qb_hur     |double    |Defensive quarterback hurries.                         |
#'    |interceptions_int    |double    |Interceptions total.                                   |
#'    |interceptions_yds    |double    |Interception return yards.                             |
#'    |interceptions_avg    |double    |Interception return yards average.                     |
#'    |interceptions_td     |double    |Interception return touchdowns.                        |
#'    |defensive_pd         |double    |Defense - passes defensed.                             |
#'    |defensive_td         |double    |Defense - defensive touchdowns.                        |
#'    |kicking_fgm          |double    |Kicking - field goals made.                            |
#'    |kicking_fga          |double    |Kicking - field goals attempted.                       |
#'    |kicking_pct          |double    |Kicking - field goal percentage.                       |
#'    |kicking_xpa          |double    |Kicking - extra points attempted.                      |
#'    |kicking_xpm          |double    |Kicking - extra points made.                           |
#'    |kicking_pts          |double    |Kicking - total points.                                |
#'    |kicking_long         |double    |Kicking - longest successful field goal attempt.       |
#'    |kick_returns_no      |double    |Kick Returns - number of kick returns.                 |
#'    |kick_returns_yds     |double    |Kick Returns - kick return yards.                      |
#'    |kick_returns_avg     |double    |Kick Returns - kick return average yards per return.   |
#'    |kick_returns_td      |double    |Kick Returns - kick return touchdowns.                 |
#'    |kick_returns_long    |double    |Kick Returns - longest kick return yardage.            |
#'    |punting_no           |double    |Punting - number of punts.                             |
#'    |punting_yds          |double    |Punting - punting yardage.                             |
#'    |punting_ypp          |double    |Punting - yards per punt.                              |
#'    |punting_long         |double    |Punting - longest punt yardage.                        |
#'    |punting_in_20        |double    |Punting - punt downed inside the 20 yard line.         |
#'    |punting_tb           |double    |Punting - punt caused a touchback.                     |
#'    |punt_returns_no      |double    |Punt Returns - number of punt returns.                 |
#'    |punt_returns_yds     |double    |Punt Returns - punt return yardage total.              |
#'    |punt_returns_avg     |double    |Punt Returns - punt return average yards per return.   |
#'    |punt_returns_td      |double    |Punt Returns - punt return touchdowns.                 |
#'    |punt_returns_long    |double    |Punt Returns - longest punt return yardage.            |
#'
#' @keywords Player Season Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom dplyr mutate mutate_at rename select everything
#' @importFrom tidyr pivot_wider
#' @family CFBD Stats
#' @export
#'
#' @examples
#' \donttest{
#'    try(cfbd_stats_season_player(year = 2018, conference = "B12", start_week = 1, end_week = 7))
#'
#'    try(cfbd_stats_season_player(2019, team = "LSU", category = "passing"))
#'
#'    try(cfbd_stats_season_player(2013, team = "Florida State", category = "passing"))
#'
#' }

cfbd_stats_season_player <- function(year,
                                     season_type = "both",
                                     team = NULL,
                                     conference = NULL,
                                     start_week = NULL,
                                     end_week = NULL,
                                     category = NULL) {

  # Validation Lists ----
  stat_categories <- c(
    "passing", "receiving", "rushing", "defensive", "fumbles",
    "interceptions", "punting", "puntReturns", "kicking", "kickReturns"
  )

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(start_week)
  validate_week(end_week)
  validate_range(end_week - start_week, 0)
  validate_season_type(season_type)
  validate_list(category, stat_categories)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/stats/player/season"
  query_params = list(
    "year" = year,
    "team" = team,
    "conference" = conference,
    "startWeek" = start_week,
    "endWeek" = end_week,
    "seasonType" = season_type,
    "category" = category
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  cols <- c(
    "team", "conference", "athlete_id", "player", "position", "category",
    "passing_completions", "passing_att", "passing_pct", "passing_yds",
    "passing_td", "passing_int", "passing_ypa",
    "rushing_car", "rushing_yds", "rushing_td", "rushing_ypc", "rushing_long",
    "receiving_rec", "receiving_yds", "receiving_td", "receiving_ypr", "receiving_long",
    "fumbles_fum", "fumbles_rec", "fumbles_lost",
    "defensive_solo", "defensive_tot", "defensive_tfl", "defensive_sacks",
    "defensive_qb_hur", "interceptions_int", "interceptions_yds",
    "interceptions_avg", "interceptions_td", "defensive_pd", "defensive_td",
    "kicking_fgm", "kicking_fga", "kicking_pct",
    "kicking_xpa", "kicking_xpm", "kicking_pts", "kicking_long",
    "kick_returns_no", "kick_returns_yds", "kick_returns_avg",
    "kick_returns_td", "kick_returns_long",
    "punting_no", "punting_yds", "punting_ypp",
    "punting_long", "punting_in_20", "punting_tb",
    "punt_returns_no", "punt_returns_yds", "punt_returns_avg",
    "punt_returns_td", "punt_returns_long"
  )

  numeric_cols <- c(
    "passing_completions", "passing_att", "passing_pct", "passing_yds",
    "passing_td", "passing_int", "passing_ypa",
    "rushing_car", "rushing_yds", "rushing_td", "rushing_ypc", "rushing_long",
    "receiving_rec", "receiving_yds", "receiving_td", "receiving_ypr", "receiving_long",
    "fumbles_fum", "fumbles_rec", "fumbles_lost",
    "defensive_solo", "defensive_tot", "defensive_tfl", "defensive_sacks",
    "defensive_qb_hur", "interceptions_int", "interceptions_yds",
    "interceptions_avg", "interceptions_td", "defensive_pd", "defensive_td",
    "kicking_fgm", "kicking_fga", "kicking_pct",
    "kicking_xpa", "kicking_xpm", "kicking_pts", "kicking_long",
    "kick_returns_no", "kick_returns_yds", "kick_returns_avg",
    "kick_returns_td", "kick_returns_long",
    "punting_no", "punting_yds", "punting_ypp",
    "punting_long", "punting_in_20", "punting_tb",
    "punt_returns_no", "punt_returns_yds", "punt_returns_avg",
    "punt_returns_td", "punt_returns_long"
  )

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return result as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        dplyr::mutate(
          statType = paste0(.data$category, "_", .data$statType)
        ) |>
        tidyr::pivot_wider(
          names_from = "statType",
          values_from = "stat"
        ) |>
        dplyr::rename("athlete_id" = "playerId") |>
        janitor::clean_names()

      df[cols[!(cols %in% colnames(df))]] <- NA
      suppressWarnings(
      df <- df |>
        dplyr::select(dplyr::all_of(cols), dplyr::everything()) |>
        dplyr::mutate_at(numeric_cols, as.numeric) |>
        as.data.frame() |>
        dplyr::mutate(year = year))

      # Check if Category is Null
      if (is.null(category)) {
        suppressWarnings(
        df <- df |>
          dplyr::select(-dplyr::any_of(c("category"))) |>
          dplyr::group_by(.data$team, .data$conference, .data$athlete_id, .data$player, .data$position, .data$year) |>
          dplyr::summarise_all(function(x) mean(x, na.rm = TRUE)) |>
          dplyr::arrange(.data$year, .data$athlete_id) |>
          dplyr::ungroup() |>
          dplyr::mutate_all(function(x) replace(x, is.nan(x), NA)))
      }


      df <- df  |>
        dplyr::select(-dplyr::any_of(c("category"))) |>
        dplyr::select(
          "year", "team", "conference", "athlete_id", "player", "position",
          dplyr::everything(),
          -dplyr::any_of("season")
        ) |>
        make_cfbfastR_data("Advanced player season stats from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no season stats - player data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get season statistics by team**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_stats_season_team', 'min_year']`
#' @param season_type (*String* default: both): Select Season Type - regular, postseason, or both
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param start_week (*Integer* optional): Starting Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param end_week (*Integer* optional): Ending Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#'
#' @param division (*String* optional): Division/classification filter -- one of `fbs`, `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.
#' @return [cfbd_stats_season_team()] - A data frame with 32 variables:
#'
#'    |col_name                |types     |description                                      |
#'    |:-----------------------|:---------|:------------------------------------------------|
#'    |season                  |integer   |Season for stats.                                |
#'    |team                    |character |Team name.                                       |
#'    |conference              |character |Conference of team.                              |
#'    |games                   |integer   |Number of games.                                 |
#'    |time_of_poss_total      |integer   |Time of possession total.                        |
#'    |time_of_poss_pg         |double    |Time of possession per game.                     |
#'    |pass_comps              |integer   |Total number of pass completions.                |
#'    |pass_atts               |integer   |Total number of pass attempts.                   |
#'    |completion_pct          |double    |Passing completion percentage.                   |
#'    |net_pass_yds            |integer   |Net passing yards.                               |
#'    |pass_ypa                |double    |Passing yards per attempt.                       |
#'    |pass_ypr                |double    |Passing yards per reception.                     |
#'    |pass_TDs                |integer   |Passing touchdowns.                              |
#'    |interceptions           |integer   |Passing interceptions.                           |
#'    |int_pct                 |double    |Interception percentage (of attempts).           |
#'    |rush_atts               |integer   |Rushing attempts.                                |
#'    |rush_yds                |integer   |Rushing yards.                                   |
#'    |rush_TDs                |integer   |Rushing touchdowns.                              |
#'    |rush_ypc                |double    |Rushing yards per carry.                         |
#'    |total_yds               |integer   |Rushing total yards.                             |
#'    |fumbles_lost            |integer   |Fumbles lost.                                    |
#'    |turnovers               |integer   |Turnovers total.                                 |
#'    |turnovers_pg            |double    |Turnovers per game.                              |
#'    |first_downs             |integer   |Number of first downs.                           |
#'    |third_downs             |integer   |Number of third downs.                           |
#'    |third_down_convs        |integer   |Number of third down conversions.                |
#'    |third_conv_rate         |double    |Third down conversion rate.                      |
#'    |fourth_down_convs       |integer   |Fourth down conversions.                         |
#'    |fourth_downs            |integer   |Fourth downs.                                    |
#'    |fourth_conv_rate        |double    |Fourth down conversion rate.                     |
#'    |penalties               |integer   |Total number of penalties.                       |
#'    |penalty_yds             |integer   |Penalty yards total.                             |
#'    |penalties_pg            |double    |Penalties per game.                              |
#'    |penalty_yds_pg          |double    |Penalty yardage per game.                        |
#'    |yards_per_penalty       |double    |Average yards per penalty.                       |
#'    |kick_returns            |integer   |Number of kick returns.                          |
#'    |kick_return_yds         |integer   |Total kick return yards.                         |
#'    |kick_return_TDs         |integer   |Total kick return touchdowns.                    |
#'    |kick_return_avg         |double    |Kick return yards average.                       |
#'    |punt_returns            |integer   |Number of punt returns.                          |
#'    |punt_return_yds         |integer   |Punt return total yards.                         |
#'    |punt_return_TDs         |integer   |Punt return total touchdowns.                    |
#'    |punt_return_avg         |double    |Punt return yards average.                       |
#'    |passes_intercepted      |integer   |Passes intercepted.                              |
#'    |passes_intercepted_yds  |integer   |Pass interception return yards.                  |
#'    |passes_intercepted_TDs  |integer   |Pass interception return touchdowns.             |
#'
#' @keywords Team Season Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr select mutate rename
#' @importFrom tidyr pivot_wider
#' @family CFBD Stats
#' @export
#'
#' @examples
#' \donttest{
#'    try(cfbd_stats_season_team(year = 2018, conference = "B12", start_week = 1, end_week = 8))
#'
#'    try(cfbd_stats_season_team(2019, team = "LSU"))
#'
#'    try(cfbd_stats_season_team(2013, team = "Florida State"))
#' }

cfbd_stats_season_team <- function(year,
                                   season_type = "both",
                                   team = NULL,
                                   conference = NULL,
                                   start_week = NULL,
                                   end_week = NULL,
                                   division = NULL) {

  # Validation ----
  validate_api_key()
  validate_division(division)
  validate_year(year)
  validate_season_type(season_type)
  validate_week(start_week)
  validate_week(end_week)
  validate_range(end_week - start_week, 0)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/stats/season"
  query_params <- list(
    "year" = year,
    "seasonType" = season_type,
    "startWeek" = start_week,
    "endWeek" = end_week,
    "team" = team,
    "conference" = conference,
    "classification" = division
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  # Expected column names for full season data
  expected_colnames <- c(
    "season", "team", "conference", "passesIntercepted", "turnovers",
    "interceptionYards", "fumblesRecovered", "passCompletions", "rushingTDs", "puntReturnYards",
    "games", "fourthDowns", "puntReturns", "rushingYards", "totalYards",
    "kickReturnYards", "passingTDs", "rushingAttempts", "netPassingYards", "kickReturns",
    "possessionTime", "fourthDownConversions", "penalties", "puntReturnTDs", "firstDowns",
    "interceptionTDs", "penaltyYards", "passAttempts", "kickReturnTDs", "interceptions",
    "thirdDownConversions", "thirdDowns", "fumblesLost"
  )
  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return result as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON()

      # Pivot category columns to get stats for each team game on one row
      df <- tidyr::pivot_wider(df,
        names_from = "statName",
        values_from = "statValue"
      )

      # Find missing columns, if any, and add them to found data
      missing <- setdiff(expected_colnames, colnames(df))
      df[missing] <- NA_real_

      df <- df |>
        # dplyr::mutate(
        #   time_of_poss_pg = ifelse(is.na(.data$games), NA_real_, .data$possessionTime / .data$games),
        #   completion_pct = ifelse(is.na(.data$passAttempts), NA_real_, .data$passCompletions / .data$passAttempts),
        #   pass_ypa = ifelse(is.na(.data$passAttempts), NA_real_, .data$netPassingYards / .data$passAttempts),
        #   pass_ypr = ifelse(is.na(.data$passCompletions), NA_real_, .data$netPassingYards / .data$passCompletions),
        #   int_pct = ifelse(is.na(.data$passAttempts), NA_real_, .data$interceptions / .data$passAttempts),
        #   rush_ypc = ifelse(is.na(.data$rushingAttempts), NA_real_, .data$rushingYards / .data$rushingAttempts),
        #   third_conv_rate = ifelse(is.na(.data$thirdDowns), NA_real_, .data$thirdDownConversions / .data$thirdDowns),
        #   fourth_conv_rate = ifelse(is.na(.data$fourthDowns), NA_real_, .data$fourthDownConversions / .data$fourthDowns),
        #   penalties_pg = ifelse(is.na(.data$games), NA_real_, .data$penalties / .data$games),
        #   penalty_yds_pg = ifelse(is.na(.data$games), NA_real_, .data$penaltyYards / .data$games),
        #   yards_per_penalty = ifelse(is.na(.data$penalties), NA_real_, .data$penaltyYards / .data$penalties),
        #   turnovers_pg = ifelse(is.na(.data$games), NA_real_, .data$turnovers / .data$games),
        #   kick_return_avg = ifelse(is.na(.data$kickReturns), NA_real_, .data$kickReturnYards / .data$kickReturns),
        #   punt_return_avg = ifelse(is.na(.data$puntReturns), NA_real_, .data$puntReturnYards / .data$puntReturns)
        # ) |>
        dplyr::select(
          "season",
          "team",
          "conference",
          "games",
          "possessionTime",
          "passCompletions",
          "passAttempts",
          "netPassingYards",
          "passingTDs",
          "interceptions",
          "rushingAttempts",
          "rushingYards",
          "rushingTDs",
          "totalYards",
          "fumblesLost",
          "turnovers",
          "firstDowns",
          "thirdDowns",
          "thirdDownConversions",
          "fourthDownConversions",
          "fourthDowns",
          "penalties",
          "penaltyYards",
          "kickReturns",
          "kickReturnYards",
          "kickReturnTDs",
          "puntReturns",
          "puntReturnYards",
          "puntReturnTDs",
          "passesIntercepted",
          "interceptionYards",
          "interceptionTDs"
        ) |>
        dplyr::rename(
          "time_of_poss_total" = "possessionTime",
          "pass_comps" = "passCompletions",
          "pass_atts" = "passAttempts",
          "net_pass_yds" = "netPassingYards",
          "pass_TDs" = "passingTDs",
          "rush_atts" = "rushingAttempts",
          "rush_yds" = "rushingYards",
          "rush_TDs" = "rushingTDs",
          "total_yds" = "totalYards",
          "fumbles_lost" = "fumblesLost",
          "first_downs" = "firstDowns",
          "third_downs" = "thirdDowns",
          "third_down_convs" = "thirdDownConversions",
          "fourth_downs" = "fourthDowns",
          "fourth_down_convs" = "fourthDownConversions",
          "penalty_yds" = "penaltyYards",
          "kick_returns" = "kickReturns",
          "kick_return_yds" = "kickReturnYards",
          "kick_return_TDs" = "kickReturnTDs",
          "punt_returns" = "puntReturns",
          "punt_return_yds" = "puntReturnYards",
          "punt_return_TDs" = "puntReturnTDs",
          "passes_intercepted" = "passesIntercepted",
          "passes_intercepted_yds" = "interceptionYards",
          "passes_intercepted_TDs" = "interceptionTDs"
        )


      df <- df |>
        make_cfbfastR_data("Season stats from CollegeFootballData.com",Sys.time())

    },
    error = function(e) {
        message(glue::glue("{Sys.time()}:Invalid arguments or no season team stats data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get game havoc statistics**
#' @description
#' Get havoc-rate statistics aggregated by game. Havoc measures defensive
#' disruption -- the share of plays that end in a tackle for loss, a forced
#' fumble, a pass defensed, or an interception -- split into front-seven and
#' defensive-back contributions. Each row carries both the team's own
#' defensive havoc (`def_*`) and the havoc the team's offense allowed
#' (`off_*`) in that game.
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Required if `team` is not specified. \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_stats_game_havoc', 'min_year']`
#' @param team (*String* optional): D-I Team. Required if `year` is not
#' specified.
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for
#' seasons pre-playoff (i.e. 2013 or earlier).
#' @param opponent (*String* optional): Opponent D-I Team.
#' @param season_type (*String* optional): Season type - regular,
#' postseason, both, allstar, spring_regular, spring_postseason.
#'
#' @return [cfbd_stats_game_havoc()] - A data frame with 22 variables:
#'
#'    |col_name                      |types     |description                                            |
#'    |:-----------------------------|:---------|:------------------------------------------------------|
#'    |game_id                       |integer   |Referencing game id.                                   |
#'    |season                        |integer   |Season of the game.                                    |
#'    |season_type                   |character |Season type of the game.                               |
#'    |week                          |integer   |Game week of the season.                               |
#'    |team                          |character |Team name.                                             |
#'    |conference                    |character |Conference of the team.                                |
#'    |opponent                      |character |Opponent team name.                                    |
#'    |opponent_conference           |character |Conference of the opponent.                            |
#'    |off_total_plays               |integer   |Offense plays in the game.                             |
#'    |off_total_havoc_events        |integer   |Total havoc events allowed by the offense.             |
#'    |off_front_seven_havoc_events  |integer   |Front-seven havoc events allowed by the offense.       |
#'    |off_db_havoc_events           |integer   |Defensive-back havoc events allowed by the offense.    |
#'    |off_havoc_rate                |double    |Total havoc rate allowed by the offense.               |
#'    |off_front_seven_havoc_rate    |double    |Front-seven havoc rate allowed by the offense.         |
#'    |off_db_havoc_rate             |double    |Defensive-back havoc rate allowed by the offense.      |
#'    |def_total_plays               |integer   |Defense plays in the game.                             |
#'    |def_total_havoc_events        |integer   |Total havoc events created by the defense.             |
#'    |def_front_seven_havoc_events  |integer   |Front-seven havoc events created by the defense.       |
#'    |def_db_havoc_events           |integer   |Defensive-back havoc events created by the defense.    |
#'    |def_havoc_rate                |double    |Total havoc rate created by the defense.               |
#'    |def_front_seven_havoc_rate    |double    |Front-seven havoc rate created by the defense.         |
#'    |def_db_havoc_rate             |double    |Defensive-back havoc rate created by the defense.      |
#'
#' @keywords Game Havoc Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom utils URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom dplyr as_tibble
#' @importFrom glue glue
#' @family CFBD Stats
#' @export
#' @examples
#' \donttest{
#'    try(cfbd_stats_game_havoc(year = 2023, team = "Georgia"))
#'
#'    try(cfbd_stats_game_havoc(2022, week = 1))
#' }
#'
cfbd_stats_game_havoc <- function(year = NULL,
                                  team = NULL,
                                  week = NULL,
                                  opponent = NULL,
                                  season_type = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  if (!is.null(season_type)) validate_season_type(season_type)

  # Team Name Handling ----
  team <- handle_accents(team)
  opponent <- handle_accents(opponent)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/stats/game/havoc"
  query_params <- list(
    "year" = year,
    "team" = team,
    "week" = week,
    "opponent" = opponent,
    "seasonType" = season_type
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content, flatten and return result as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        as.data.frame()

      # Column renaming for the nested offense./defense. blocks
      colnames(df) <- gsub("offense.", "off_", colnames(df))
      colnames(df) <- gsub("defense.", "def_", colnames(df))

      df <- df |>
        janitor::clean_names() |>
        dplyr::as_tibble() |>
        make_cfbfastR_data("Game havoc stats from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game havoc stats data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get player success rates by season**
#' @param year (*Integer* optional): Season, 4 digits (YYYY).
#' @param conference (*String* optional): Conference abbreviation filter.
#' @param team (*String* optional): Team filter.
#' @param athlete_id (*Integer* optional): Player identifier.
#' @param season_type (*String* optional): Season type -- `regular`, `postseason`, `both`, `allstar`, `spring_regular` or `spring_postseason`.
#' @param start_week (*Integer* optional): First week to include.
#' @param end_week (*Integer* optional): Last week to include.
#' @param threshold (*Numeric* optional): Minimum success-rate threshold.
#' @param excl_garbage_time (*Logical* optional): Exclude garbage-time plays.
#' @description
#' **Get player success rates by season**
#' Season-level player success-rate metrics.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#' @return [cfbd_stats_player_success()] - A tibble with 12 columns:
#'
#'    |col_name             |types     |description             |
#'    |:-------------------|:--------|:----------------------|
#'    |season               |integer   |Four-digit season year. |
#'    |id                   |character |Record identifier.      |
#'    |name                 |character |Display name.           |
#'    |position             |character |Position.               |
#'    |team                 |character |Team name.              |
#'    |conference           |character |Conference name.        |
#'    |passing_plays        |integer   |Passing plays.          |
#'    |passing_successes    |integer   |Passing successes.      |
#'    |passing_success_rate |numeric   |Passing success rate.   |
#'    |rushing_plays        |integer   |Rushing plays.          |
#'    |rushing_successes    |integer   |Rushing successes.      |
#'    |rushing_success_rate |numeric   |Rushing success rate.   |
#'
#' @keywords Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Stats Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_stats_player_success(year = 2024, team = "Georgia"))
#' }
cfbd_stats_player_success <- function(year = NULL, conference = NULL, team = NULL, athlete_id = NULL, season_type = 'regular', start_week = NULL, end_week = NULL, threshold = NULL, excl_garbage_time = NULL, proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_season_type(season_type)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/stats/player/success"
  query_params <- list(
    "year" = year,
    "conference" = conference,
    "team" = team,
    "playerId" = athlete_id,
    "seasonType" = season_type,
    "startWeek" = start_week,
    "endWeek" = end_week,
    "threshold" = threshold,
    "excludeGarbageTime" = excl_garbage_time
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {
      res <- get_req(full_url, proxy = proxy)
      check_status(res)

      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        janitor::clean_names()

      df <- df |>
        make_cfbfastR_data("Get player success rates by season from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no stats data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get player success rates by game**
#' @param year (*Integer* required): Season, 4 digits (YYYY).
#' @param week (*Integer* optional): Week filter.
#' @param season_type (*String* optional): Season type -- `regular`, `postseason`, `both`, `allstar`, `spring_regular` or `spring_postseason`.
#' @param conference (*String* optional): Conference abbreviation filter.
#' @param team (*String* optional): Team filter.
#' @param athlete_id (*Integer* optional): Player identifier.
#' @param threshold (*Numeric* optional): Minimum success-rate threshold.
#' @param excl_garbage_time (*Logical* optional): Exclude garbage-time plays.
#' @description
#' **Get player success rates by game**
#' Game-level player success-rate metrics.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#' @return [cfbd_stats_player_success_game()] - A tibble with 16 columns:
#'
#'    |col_name             |types     |description                                                                          |
#'    |:-------------------|:--------|:-----------------------------------------------------------------------------------|
#'    |season               |integer   |Four-digit season year.                                                              |
#'    |season_type          |character |Season type (regular, postseason, both, allstar, spring_regular, spring_postseason). |
#'    |week                 |integer   |Week of the season.                                                                  |
#'    |game_id              |integer   |Referencing game id.                                                                 |
#'    |id                   |character |Record identifier.                                                                   |
#'    |name                 |character |Display name.                                                                        |
#'    |position             |character |Position.                                                                            |
#'    |team                 |character |Team name.                                                                           |
#'    |conference           |character |Conference name.                                                                     |
#'    |opponent             |character |Opponent.                                                                            |
#'    |passing_plays        |integer   |Passing plays.                                                                       |
#'    |passing_successes    |integer   |Passing successes.                                                                   |
#'    |passing_success_rate |numeric   |Passing success rate.                                                                |
#'    |rushing_plays        |integer   |Rushing plays.                                                                       |
#'    |rushing_successes    |integer   |Rushing successes.                                                                   |
#'    |rushing_success_rate |numeric   |Rushing success rate.                                                                |
#'
#' @keywords Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Stats Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_stats_player_success_game(year = 2024, week = 5))
#' }
cfbd_stats_player_success_game <- function(year, week = NULL, season_type = 'regular', conference = NULL, team = NULL, athlete_id = NULL, threshold = NULL, excl_garbage_time = NULL, proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/stats/player/success/game"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "conference" = conference,
    "team" = team,
    "playerId" = athlete_id,
    "threshold" = threshold,
    "excludeGarbageTime" = excl_garbage_time
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {
      res <- get_req(full_url, proxy = proxy)
      check_status(res)

      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        janitor::clean_names()

      df <- df |>
        make_cfbfastR_data("Get player success rates by game from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no stats data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
