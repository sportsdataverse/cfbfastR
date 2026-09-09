#' @name cfbd_passing
#' @title
#' **CFBD Passing Endpoint Overview**
#' @description
#'
#' * `cfbd_passing_players_season()`: Get player season passing production, split by pass location.
#' * `cfbd_passing_players_games()`: Get player game passing production, split by pass location.
#' * `cfbd_passing_teams_season()`: Get team season passing production for and against, split by pass location.
#' * `cfbd_passing_teams_games()`: Get team game passing production for and against, split by pass location.
#' * `cfbd_passing_plays()`: Get individual passing plays with air yards, YAC and location detail.
#'
#' @details
#' ### **Get player season passing production**
#' ```r
#'   cfbd_passing_players_season(year = 2025, team = "Texas")
#' ```
#' ### **Get player game passing production**
#' ```r
#'   cfbd_passing_players_games(year = 2025, week = 5)
#' ```
#' ### **Get team season passing production**
#' ```r
#'   cfbd_passing_teams_season(year = 2025, team = "Texas")
#' ```
#' ### **Get team game passing production**
#' ```r
#'   cfbd_passing_teams_games(year = 2025, week = 5)
#' ```
#' ### **Get individual passing plays**
#' ```r
#'   cfbd_passing_plays(year = 2025, week = 5, team = "Texas")
#' ```
#'
#' @section The passing production block:
#'
#' Every passing endpoint below shares one 23-column production block. It is
#' documented once here rather than repeated in each returns table, because the
#' team endpoints carry it sixteen times over (see *Location splits*).
#'
#'  |col_name                             |types     |description                                                                     |
#'  |:------------------------------------|:---------|:-------------------------------------------------------------------------------|
#'  |attempts                             |integer   |Pass attempts.                                                                   |
#'  |completions                          |integer   |Completed passes.                                                                |
#'  |incompletions                        |integer   |Incomplete passes.                                                               |
#'  |interceptions                        |integer   |Passes intercepted.                                                              |
#'  |completion_rate                      |numeric   |Completions divided by attempts (proportion 0-1).                                |
#'  |air_yards_attempts_available         |integer   |Attempts for which air yards were parsed (the denominator for air-yard means).   |
#'  |total_air_yards                      |integer   |Sum of air yards over `air_yards_attempts_available` attempts.                   |
#'  |average_depth_of_target              |numeric   |Mean air yards per attempt (aDOT).                                               |
#'  |total_yards_attempts_available       |integer   |Attempts for which total yards were parsed.                                      |
#'  |total_yards                          |integer   |Sum of passing yards over those attempts.                                        |
#'  |yards_after_catch_attempts_available |integer   |Attempts for which yards after catch were parsed.                                |
#'  |total_yards_after_catch              |integer   |Sum of yards after catch over those attempts.                                    |
#'  |average_yards_after_catch            |numeric   |Mean yards after catch per completion.                                           |
#'  |success_rate                         |numeric   |Successful attempts divided by `success_attempts_available` (proportion 0-1).    |
#'  |ppa                                  |numeric   |Predicted points added per attempt.                                              |
#'  |total_ppa                            |numeric   |Sum of predicted points added.                                                   |
#'  |explosiveness                        |numeric   |Mean PPA on successful attempts.                                                 |
#'  |ppa_attempts_available               |integer   |Attempts carrying a PPA value (the denominator for `ppa`).                       |
#'  |success_attempts_available           |integer   |Attempts eligible for the success calculation.                                   |
#'  |successful_attempts                  |integer   |Attempts meeting the success threshold.                                          |
#'  |successful_ppa_attempts_available    |integer   |Successful attempts carrying a PPA value (the denominator for `explosiveness`).  |
#'  |location_eligible_attempts           |integer   |Attempts eligible for a location split.                                          |
#'  |location_available_attempts          |integer   |Attempts for which a location was actually parsed.                               |
#'
#' The `*_available` counts are denominators, not statistics. CFBD parses these
#' fields out of play text, so an attempt can be counted while its air yards,
#' YAC or location stay unknown. Dividing by `attempts` instead of the matching
#' `*_available` column understates every mean.
#'
#' @section Location splits:
#'
#' The same block repeats for each of seven pass locations, prefixed
#' `locations_<bucket>_`:
#'
#' * `short_left`, `short_middle`, `short_right`
#' * `deep_left`, `deep_middle`, `deep_right`
#' * `unknown` -- location could not be parsed from the play text
#'
#' All seven buckets are always present, including empty ones. So a player frame
#' is 5 identity columns + 23 production + 7 x 23 location = **189 columns**, and a
#' team frame doubles the production and location blocks across `offense_` and
#' `defense_` for **371**.
#'
#' @section Season coverage:
#'
#' These endpoints are **2025 onward**. Earlier seasons answer HTTP 200 with an
#' empty array rather than an error, so a request for 2024 returns an empty
#' data frame, not a failure.
#'
NULL

#' @title
#' **Get player season passing production, split by pass location**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_passing_players_season', 'min_year']`
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param passer_id (*String* optional): CFBD athlete id of the passer to filter on.
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii
#'
#' @return [cfbd_passing_players_season()] - A data frame with 189 variables:
#'
#'  |col_name        |types     |description                                                     |
#'  |:---------------|:---------|:---------------------------------------------------------------|
#'  |season          |integer   |Four-digit season year (e.g. 2025).                             |
#'  |player_id       |character |CFBD athlete identifier (use with `cfbd_player_info()`).        |
#'  |player          |character |Player full name.                                               |
#'  |team            |character |Team name.                                                      |
#'  |conference      |character |Team conference name.                                           |
#'
#' plus the 23-column passing production block and its seven `locations_*`
#' repeats -- both described under **The passing production block** and
#' **Location splits** in [cfbd_passing].
#'
#' @keywords Passing Players Season
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Passing
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_passing_players_season(year = 2025, team = "Texas"))
#' }

cfbd_passing_players_season <- function(year = NULL,
                                        season_type = NULL,
                                        team = NULL,
                                        conference = NULL,
                                        passer_id = NULL,
                                        classification = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/passing/players/season"
  query_params <- list(
    "year" = year,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "passerId" = passer_id,
    "classification" = classification
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content, flatten and return result as data.frame
      parsed <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      # An out-of-coverage season answers HTTP 200 with `[]`, which parses to a
      # zero-length list; janitor::clean_names() then aborts on the absent
      # dimnames and the user sees a parse error instead of "no rows". These
      # endpoints only carry 2025 onward, so that is the common case, not a rare
      # one -- see the empty-response guard in cfbd_betting_lines().
      if (is.data.frame(parsed) && nrow(parsed) > 0) {
        df <- parsed |>
          janitor::clean_names()
      }

      if (nrow(df) > 0) df <- df |>
        make_cfbfastR_data("Player season passing data from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player season passing data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get player game passing production, split by pass location**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_passing_players_games', 'min_year']`
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' @param passer_id (*String* optional): CFBD athlete id of the passer to filter on.
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii
#'
#' @return [cfbd_passing_players_games()] - A data frame with 193 variables:
#'
#'  |col_name        |types     |description                                                     |
#'  |:---------------|:---------|:---------------------------------------------------------------|
#'  |game_id         |integer   |Unique game identifier - `game_id`.                             |
#'  |season          |integer   |Four-digit season year (e.g. 2025).                             |
#'  |week            |integer   |Week of the season.                                             |
#'  |season_type     |character |Season type (regular, postseason, ...).                         |
#'  |player_id       |character |CFBD athlete identifier.                                        |
#'  |player          |character |Player full name.                                               |
#'  |team            |character |Team name.                                                      |
#'  |conference      |character |Team conference name.                                           |
#'  |opponent        |character |Opposing team name.                                             |
#'
#' plus the 23-column passing production block and its seven `locations_*`
#' repeats -- see [cfbd_passing].
#'
#' @keywords Passing Players Games
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Passing
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_passing_players_games(year = 2025, week = 5))
#' }

cfbd_passing_players_games <- function(year = NULL,
                                       week = NULL,
                                       season_type = NULL,
                                       team = NULL,
                                       conference = NULL,
                                       passer_id = NULL,
                                       classification = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/passing/players/games"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "passerId" = passer_id,
    "classification" = classification
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {
      res <- get_req(full_url)
      check_status(res)

      parsed <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      # An out-of-coverage season answers HTTP 200 with `[]`, which parses to a
      # zero-length list; janitor::clean_names() then aborts on the absent
      # dimnames and the user sees a parse error instead of "no rows". These
      # endpoints only carry 2025 onward, so that is the common case, not a rare
      # one -- see the empty-response guard in cfbd_betting_lines().
      if (is.data.frame(parsed) && nrow(parsed) > 0) {
        df <- parsed |>
          janitor::clean_names()
      }

      if (nrow(df) > 0) df <- df |>
        make_cfbfastR_data("Player game passing data from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player game passing data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get team season passing production for and against, split by pass location**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_passing_teams_season', 'min_year']`
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii
#'
#' @return [cfbd_passing_teams_season()] - A data frame with 371 variables:
#'
#'  |col_name        |types     |description                                                     |
#'  |:---------------|:---------|:---------------------------------------------------------------|
#'  |season          |integer   |Four-digit season year (e.g. 2025).                             |
#'  |team            |character |Team name.                                                      |
#'  |conference      |character |Team conference name.                                           |
#'
#' plus TWO copies of the 23-column production block and its seven `locations_*`
#' repeats: `offense_*` (the team's own passing) and `defense_*` (passing allowed).
#' See [cfbd_passing]. So `offense_ppa` is PPA per attempt thrown and
#' `defense_ppa` is PPA per attempt allowed -- a *lower* `defense_ppa` is better.
#'
#' @keywords Passing Teams Season
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Passing
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_passing_teams_season(year = 2025, team = "Texas"))
#' }

cfbd_passing_teams_season <- function(year = NULL,
                                      season_type = NULL,
                                      team = NULL,
                                      conference = NULL,
                                      classification = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/passing/teams/season"
  query_params <- list(
    "year" = year,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "classification" = classification
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {
      res <- get_req(full_url)
      check_status(res)

      parsed <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      # An out-of-coverage season answers HTTP 200 with `[]`, which parses to a
      # zero-length list; janitor::clean_names() then aborts on the absent
      # dimnames and the user sees a parse error instead of "no rows". These
      # endpoints only carry 2025 onward, so that is the common case, not a rare
      # one -- see the empty-response guard in cfbd_betting_lines().
      if (is.data.frame(parsed) && nrow(parsed) > 0) {
        df <- parsed |>
          janitor::clean_names()
      }

      if (nrow(df) > 0) df <- df |>
        make_cfbfastR_data("Team season passing data from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no team season passing data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get team game passing production for and against, split by pass location**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_passing_teams_games', 'min_year']`
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii
#'
#' @return [cfbd_passing_teams_games()] - A data frame with 375 variables:
#'
#'  |col_name        |types     |description                                                     |
#'  |:---------------|:---------|:---------------------------------------------------------------|
#'  |game_id         |integer   |Unique game identifier - `game_id`.                             |
#'  |season          |integer   |Four-digit season year (e.g. 2025).                             |
#'  |week            |integer   |Week of the season.                                             |
#'  |season_type     |character |Season type (regular, postseason, ...).                         |
#'  |team            |character |Team name.                                                      |
#'  |conference      |character |Team conference name.                                           |
#'  |opponent        |character |Opposing team name.                                             |
#'
#' plus the `offense_*` and `defense_*` production and `locations_*` blocks -- see
#' [cfbd_passing] and [cfbd_passing_teams_season].
#'
#' @keywords Passing Teams Games
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Passing
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_passing_teams_games(year = 2025, week = 5))
#' }

cfbd_passing_teams_games <- function(year = NULL,
                                     week = NULL,
                                     season_type = NULL,
                                     team = NULL,
                                     conference = NULL,
                                     classification = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/passing/teams/games"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "classification" = classification
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {
      res <- get_req(full_url)
      check_status(res)

      parsed <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      # An out-of-coverage season answers HTTP 200 with `[]`, which parses to a
      # zero-length list; janitor::clean_names() then aborts on the absent
      # dimnames and the user sees a parse error instead of "no rows". These
      # endpoints only carry 2025 onward, so that is the common case, not a rare
      # one -- see the empty-response guard in cfbd_betting_lines().
      if (is.data.frame(parsed) && nrow(parsed) > 0) {
        df <- parsed |>
          janitor::clean_names()
      }

      if (nrow(df) > 0) df <- df |>
        make_cfbfastR_data("Team game passing data from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no team game passing data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get individual passing plays with air yards, YAC and location detail**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_passing_plays', 'min_year']`
#' @param team (*String* optional): D-I Team
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param game_id (*Integer* optional): Game ID filter for querying a single game
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param offense (*String* optional): Offensive team filter
#' @param defense (*String* optional): Defensive team filter
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' @param passer_id (*String* optional): CFBD athlete id of the passer to filter on.
#' @param target_id (*String* optional): CFBD athlete id of the targeted receiver to filter on.
#' @param outcome (*String* optional): Pass outcome - completion, incompletion, interception
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii
#'
#' @return [cfbd_passing_plays()] - A data frame with 39 variables:
#'
#'  |col_name                   |types     |description                                                                              |
#'  |:--------------------------|:---------|:----------------------------------------------------------------------------------------|
#'  |game_id                    |integer   |Unique game identifier - `game_id`.                                                      |
#'  |play_id                    |character |Unique play identifier - `play_id`.                                                      |
#'  |drive_id                   |character |Unique drive identifier - `drive_id`.                                                    |
#'  |season                     |integer   |Four-digit season year (e.g. 2025).                                                      |
#'  |week                       |integer   |Week of the season.                                                                      |
#'  |season_type                |character |Season type (regular, postseason, ...).                                                  |
#'  |offense_id                 |integer   |Offensive team id.                                                                       |
#'  |offense                    |character |Offensive team name.                                                                     |
#'  |offense_conference         |character |Offensive team conference name.                                                          |
#'  |defense_id                 |integer   |Defensive team id.                                                                       |
#'  |defense                    |character |Defensive team name.                                                                     |
#'  |defense_conference         |character |Defensive team conference name.                                                          |
#'  |period                     |integer   |Quarter of the play.                                                                     |
#'  |clock_minutes              |integer   |Minutes remaining on the game clock at the snap.                                         |
#'  |clock_seconds              |integer   |Seconds remaining on the game clock at the snap.                                         |
#'  |down                       |integer   |Down of the play (1-4).                                                                  |
#'  |distance                   |integer   |Yards to gain for a first down.                                                          |
#'  |play_text                  |character |Play description text as published by the source.                                        |
#'  |passer_id                  |character |CFBD athlete id of the passer.                                                           |
#'  |passer                     |character |Passer full name.                                                                        |
#'  |target_id                  |character |CFBD athlete id of the targeted receiver (`NA` when unparsed).                            |
#'  |target                     |character |Targeted receiver full name (`NA` when unparsed).                                        |
#'  |outcome                    |character |Pass outcome - completion, incompletion or interception.                                 |
#'  |air_yards                  |integer   |Yards the ball travelled past the line of scrimmage.                                     |
#'  |pass_depth                 |character |Depth bucket - short or deep (`NA` when unparsed).                                        |
#'  |pass_direction             |character |Direction bucket - left, middle or right (`NA` when unparsed).                            |
#'  |pass_location              |character |Combined depth + direction bucket, matching the `locations_*` split (`NA` when unparsed). |
#'  |total_yards                |integer   |Total yards gained on the play.                                                          |
#'  |yards_after_catch          |integer   |Yards gained after the catch (`NA` when unparsed or incomplete).                          |
#'  |start_yardline             |integer   |Yard line the play started from, in the offense's frame of reference.                     |
#'  |start_yards_to_goal        |integer   |Yards from the opponent's end zone at the snap.                                          |
#'  |target_yards_to_goal       |integer   |Yards from the opponent's end zone at the target point.                                  |
#'  |is_spike                   |logical   |TRUE when the pass was a clock-stopping spike.                                           |
#'  |is_throwaway               |logical   |TRUE when the pass was a deliberate throwaway.                                           |
#'  |is_intentional_grounding   |logical   |TRUE when the play was flagged intentional grounding.                                    |
#'  |parse_status               |character |How completely CFBD parsed the play text for this row.                                   |
#'  |ppa                        |numeric   |Predicted points added on the play.                                                      |
#'  |success                    |logical   |TRUE when the play met the success threshold for its down and distance.                  |
#'  |location_analysis_eligible |logical   |TRUE when the play is eligible to be counted in a location split.                        |
#'
#' Check a column before building on it. As of this writing CFBD has **not**
#' populated play-level `air_yards`, `yards_after_catch`, `pass_depth`,
#' `pass_direction` or `pass_location` at all -- every value is `NA`, so R types
#' those columns `logical` -- while `target` is populated (1,976 of 2,003 week-5
#' 2025 completions) and the SEASON aggregates in
#' [cfbd_passing_players_season()] do carry air yards. Filter on
#' `location_analysis_eligible` or `parse_status` rather than assuming a column
#' holds values.
#'
#' @keywords Passing Plays
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Passing
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_passing_plays(year = 2025, week = 5, team = "Texas"))
#' }

cfbd_passing_plays <- function(year = NULL,
                               team = NULL,
                               week = NULL,
                               game_id = NULL,
                               season_type = NULL,
                               offense = NULL,
                               defense = NULL,
                               conference = NULL,
                               passer_id = NULL,
                               target_id = NULL,
                               outcome = NULL,
                               classification = NULL) {

  # Validation Lists ----
  outcomes <- c("completion", "incompletion", "interception")

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_id(game_id)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_list(outcome, outcomes)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)
  offense <- handle_accents(offense)
  defense <- handle_accents(defense)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/passing/plays"
  query_params <- list(
    "year" = year,
    "team" = team,
    "week" = week,
    "gameId" = game_id,
    "seasonType" = season_type,
    "offense" = offense,
    "defense" = defense,
    "conference" = conference,
    "passerId" = passer_id,
    "targetId" = target_id,
    "outcome" = outcome,
    "classification" = classification
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {
      res <- get_req(full_url)
      check_status(res)

      parsed <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      # An out-of-coverage season answers HTTP 200 with `[]`, which parses to a
      # zero-length list; janitor::clean_names() then aborts on the absent
      # dimnames and the user sees a parse error instead of "no rows". These
      # endpoints only carry 2025 onward, so that is the common case, not a rare
      # one -- see the empty-response guard in cfbd_betting_lines().
      if (is.data.frame(parsed) && nrow(parsed) > 0) {
        df <- parsed |>
          janitor::clean_names()
      }

      if (nrow(df) > 0) df <- df |>
        make_cfbfastR_data("Passing plays data from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no passing plays data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
