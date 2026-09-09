#' @name cfbd_rushing
#' @title
#' **CFBD Rushing Endpoint Overview**
#' @description
#'
#' * `cfbd_rushing_players_season()`: Get player season rushing production, split by run direction.
#' * `cfbd_rushing_players_games()`: Get player game rushing production, split by run direction.
#' * `cfbd_rushing_teams_season()`: Get team season rushing production for and against, split by run direction.
#' * `cfbd_rushing_teams_games()`: Get team game rushing production for and against, split by run direction.
#' * `cfbd_rushing_plays()`: Get individual rushing plays with direction and attribution detail.
#'
#' @details
#' ### **Get player season rushing production**
#' ```r
#'   cfbd_rushing_players_season(year = 2025, team = "Texas")
#' ```
#' ### **Get player game rushing production**
#' ```r
#'   cfbd_rushing_players_games(year = 2025, week = 5)
#' ```
#' ### **Get team season rushing production**
#' ```r
#'   cfbd_rushing_teams_season(year = 2025, team = "Texas")
#' ```
#' ### **Get team game rushing production**
#' ```r
#'   cfbd_rushing_teams_games(year = 2025, week = 5)
#' ```
#' ### **Get individual rushing plays**
#' ```r
#'   cfbd_rushing_plays(year = 2025, week = 5, team = "Texas")
#' ```
#'
#' @section The rushing production block:
#'
#' Every rushing endpoint below shares one production block, documented once here
#' rather than repeated in each returns table. Player frames carry 24 of these
#' columns; team frames carry 26, adding `touchdown_status_available` and
#' `rushing_touchdowns`.
#'
#'  |col_name                     |types     |description                                                                       |
#'  |:----------------------------|:---------|:---------------------------------------------------------------------------------|
#'  |attempts                     |integer   |Rush attempts.                                                                     |
#'  |rushing_yards_available      |integer   |Attempts for which rushing yards were parsed (denominator for yardage means).       |
#'  |total_rushing_yards          |integer   |Sum of rushing yards over those attempts.                                          |
#'  |yards_per_carry              |numeric   |Mean rushing yards per carry.                                                      |
#'  |individual_attempts          |integer   |Attempts attributed to a single identified ball carrier.                           |
#'  |unattributed_attempts        |integer   |Attempts with no ball carrier resolved from the play text.                         |
#'  |sacks                        |integer   |Sacks counted within the rushing play set.                                         |
#'  |kneels                       |integer   |Quarterback kneel-downs.                                                           |
#'  |team_rushes                  |integer   |Attempts recorded as a team rush rather than an individual.                        |
#'  |multi_carrier_attempts       |integer   |Attempts where more than one carrier was identified.                               |
#'  |direction_eligible_attempts  |integer   |Attempts eligible for a direction split.                                           |
#'  |direction_available_attempts |integer   |Attempts for which a direction was actually parsed.                                |
#'  |success_rate                 |numeric   |Proportion of attempts meeting the success threshold (0-1).                        |
#'  |ppa                          |numeric   |Predicted points added per attempt.                                                |
#'  |total_ppa                    |numeric   |Sum of predicted points added.                                                     |
#'  |line_yards                   |numeric   |Line yards per carry (Football Outsiders methodology).                             |
#'  |line_yards_total             |numeric   |Sum of line yards.                                                                 |
#'  |second_level_yards           |numeric   |Second-level yards per carry (5-10 yards past the line of scrimmage).              |
#'  |second_level_yards_total     |numeric   |Sum of second-level yards.                                                         |
#'  |open_field_yards             |numeric   |Open-field yards per carry (10+ yards past the line of scrimmage).                 |
#'  |open_field_yards_total       |numeric   |Sum of open-field yards.                                                           |
#'  |stuff_rate                   |numeric   |Proportion of carries stopped at or behind the line of scrimmage (0-1).            |
#'  |power_success                |numeric   |Conversion rate on short-yardage power runs (0-1).                                 |
#'  |explosiveness                |numeric   |Mean PPA on successful carries.                                                    |
#'  |touchdown_status_available   |integer   |*Team frames only.* Attempts for which touchdown status was parsed.                |
#'  |rushing_touchdowns           |integer   |*Team frames only.* Rushing touchdowns over those attempts.                        |
#'
#' As with passing, the `*_available` columns are denominators, not statistics:
#' CFBD parses these fields out of play text, so an attempt can be counted while
#' its yardage or direction stays unknown. Dividing by `attempts` instead of the
#' matching `*_available` column understates every mean.
#'
#' @section Direction splits:
#'
#' A 15-column subset repeats for each of four run directions, prefixed
#' `directions_<bucket>_`: `left`, `middle`, `right` and `unknown` (direction
#' could not be parsed).
#'
#' Each bucket carries `carries`, `yards`, `yards_per_carry`, `success_rate`,
#' `ppa`, `total_ppa`, `line_yards`, `line_yards_total`, `second_level_yards`,
#' `second_level_yards_total`, `open_field_yards`, `open_field_yards_total`,
#' `stuff_rate`, `power_success` and `explosiveness`.
#'
#' So a player frame is 5 identity + 24 production + 4 x 15 direction =
#' **89 columns**, and a team frame is 3 identity + 2 x (26 + 4 x 15) = **175**,
#' split across `offense_` and `defense_`.
#'
#' @section Season coverage:
#'
#' These endpoints are **2025 onward**. Earlier seasons answer HTTP 200 with an
#' empty array rather than an error, so a request for 2024 returns an empty
#' data frame, not a failure.
#'
NULL

#' @title
#' **Get player season rushing production, split by run direction**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_rushing_players_season', 'min_year']`
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param rusher_id (*String* optional): CFBD athlete id of the rusher to filter on.
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii
#'
#' @return [cfbd_rushing_players_season()] - A data frame with 89 variables:
#'
#'  |col_name        |types     |description                                                     |
#'  |:---------------|:---------|:---------------------------------------------------------------|
#'  |season          |integer   |Four-digit season year (e.g. 2025).                             |
#'  |player_id       |character |CFBD athlete identifier (use with `cfbd_player_info()`).        |
#'  |player          |character |Player full name.                                               |
#'  |team            |character |Team name.                                                      |
#'  |conference      |character |Team conference name.                                           |
#'
#' plus the 24-column rushing production block and its four `directions_*` repeats -- both described under **The rushing production block** and
#' **Direction splits** in [cfbd_rushing].
#'
#' @keywords Rushing Players Season
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Rushing
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_rushing_players_season(year = 2025, team = "Texas"))
#' }

cfbd_rushing_players_season <- function(year = NULL,
                                        season_type = NULL,
                                        team = NULL,
                                        conference = NULL,
                                        rusher_id = NULL,
                                        classification = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/rushing/players/season"
  query_params <- list(
    "year" = year,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "rusherId" = rusher_id,
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
        make_cfbfastR_data("Player season rushing data from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player season rushing data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get player game rushing production, split by run direction**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_rushing_players_games', 'min_year']`
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' @param rusher_id (*String* optional): CFBD athlete id of the rusher to filter on.
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii
#'
#' @return [cfbd_rushing_players_games()] - A data frame with 93 variables:
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
#' plus the 24-column rushing production block and its four `directions_*` repeats -- see [cfbd_rushing].
#'
#' @keywords Rushing Players Games
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Rushing
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_rushing_players_games(year = 2025, week = 5))
#' }

cfbd_rushing_players_games <- function(year = NULL,
                                       week = NULL,
                                       season_type = NULL,
                                       team = NULL,
                                       conference = NULL,
                                       rusher_id = NULL,
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
  base_url <- "https://api.collegefootballdata.com/rushing/players/games"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "rusherId" = rusher_id,
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
        make_cfbfastR_data("Player game rushing data from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player game rushing data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get team season rushing production for and against, split by run direction**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_rushing_teams_season', 'min_year']`
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii
#'
#' @return [cfbd_rushing_teams_season()] - A data frame with 175 variables:
#'
#'  |col_name        |types     |description                                                     |
#'  |:---------------|:---------|:---------------------------------------------------------------|
#'  |season          |integer   |Four-digit season year (e.g. 2025).                             |
#'  |team            |character |Team name.                                                      |
#'  |conference      |character |Team conference name.                                           |
#'
#' plus TWO copies of the 26-column production block and its four `directions_*` repeats: `offense_*` (the team's own rushing) and `defense_*` (rushing allowed).
#' See [cfbd_rushing]. So `offense_ppa` is PPA per carry run and
#' `defense_ppa` is PPA per carry allowed -- a *lower* `defense_ppa` is better.
#'
#' @keywords Rushing Teams Season
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Rushing
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_rushing_teams_season(year = 2025, team = "Texas"))
#' }

cfbd_rushing_teams_season <- function(year = NULL,
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
  base_url <- "https://api.collegefootballdata.com/rushing/teams/season"
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
        make_cfbfastR_data("Team season rushing data from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no team season rushing data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get team game rushing production for and against, split by run direction**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_rushing_teams_games', 'min_year']`
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii
#'
#' @return [cfbd_rushing_teams_games()] - A data frame with 179 variables:
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
#' plus the `offense_*` and `defense_*` production and `directions_*` blocks -- see
#' [cfbd_rushing] and [cfbd_rushing_teams_season].
#'
#' @keywords Rushing Teams Games
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Rushing
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_rushing_teams_games(year = 2025, week = 5))
#' }

cfbd_rushing_teams_games <- function(year = NULL,
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
  base_url <- "https://api.collegefootballdata.com/rushing/teams/games"
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
        make_cfbfastR_data("Team game rushing data from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no team game rushing data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get individual rushing plays with direction and attribution detail**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_rushing_plays', 'min_year']`
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param game_id (*Integer* optional): Game ID filter for querying a single game
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param offense (*String* optional): Offensive team filter
#' @param defense (*String* optional): Defensive team filter
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' @param rusher_id (*String* optional): CFBD athlete id of the ball carrier to filter on.
#' @param rush_direction (*String* optional): Run direction - left, middle, right
#' @param direction_analysis_eligible (*Logical* optional): Filter to plays eligible for the direction split.
#' @param attribution_status (*String* optional): How the carrier was resolved - individual, team,
#' multi_carrier, unmatched, ambiguous, conflict, unlinked
#' @param is_rushing_touchdown (*Logical* optional): Filter to plays that scored a rushing touchdown.
#' @param is_sack (*Logical* optional): Filter to plays recorded as sacks.
#' @param is_kneel (*Logical* optional): Filter to quarterback kneel-downs.
#' @param is_team_rush (*Logical* optional): Filter to plays recorded as a team rush.
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii
#'
#' @return [cfbd_rushing_plays()] - A data frame with 34 variables:
#'
#'  |col_name                    |types     |description                                                                    |
#'  |:---------------------------|:---------|:-------------------------------------------------------------------------------|
#'  |game_id                     |integer   |Unique game identifier - `game_id`.                                            |
#'  |play_id                     |character |Unique play identifier - `play_id`.                                            |
#'  |drive_id                    |character |Unique drive identifier - `drive_id`.                                          |
#'  |season                      |integer   |Four-digit season year (e.g. 2025).                                            |
#'  |week                        |integer   |Week of the season.                                                            |
#'  |season_type                 |character |Season type (regular, postseason, ...).                                        |
#'  |offense_id                  |integer   |Offensive team id.                                                             |
#'  |offense                     |character |Offensive team name.                                                           |
#'  |offense_conference          |character |Offensive team conference name.                                                |
#'  |defense_id                  |integer   |Defensive team id.                                                             |
#'  |defense                     |character |Defensive team name.                                                           |
#'  |defense_conference          |character |Defensive team conference name.                                                |
#'  |period                      |integer   |Quarter of the play.                                                           |
#'  |clock_minutes               |integer   |Minutes remaining on the game clock at the snap.                               |
#'  |clock_seconds               |integer   |Seconds remaining on the game clock at the snap.                               |
#'  |down                        |integer   |Down of the play (1-4).                                                        |
#'  |distance                    |integer   |Yards to gain for a first down.                                                |
#'  |play_text                   |character |Play description text as published by the source.                              |
#'  |start_yardline              |integer   |Yard line the play started from, in the offense's frame of reference.           |
#'  |start_yards_to_goal         |integer   |Yards from the opponent's end zone at the snap.                                |
#'  |rusher_id                   |character |CFBD athlete id of the ball carrier (`NA` when unattributed).                   |
#'  |rusher                      |character |Ball carrier full name (`NA` when unattributed).                               |
#'  |rush_direction              |character |Run direction - left, middle or right (`NA` when unparsed).                     |
#'  |rushing_yards               |integer   |Yards gained on the play.                                                      |
#'  |rusher_yards                |integer   |Yards credited to the identified carrier.                                      |
#'  |is_rushing_touchdown        |logical   |TRUE when the play scored a rushing touchdown.                                 |
#'  |is_sack                     |logical   |TRUE when the play was recorded as a sack.                                     |
#'  |is_kneel                    |logical   |TRUE when the play was a quarterback kneel-down.                               |
#'  |is_team_rush                |logical   |TRUE when the play was recorded as a team rush rather than an individual.       |
#'  |attribution_status          |character |How the carrier was resolved - individual, team, multi_carrier, unmatched, ...  |
#'  |direction_analysis_eligible |logical   |TRUE when the play is eligible to be counted in a direction split.             |
#'  |parse_status                |character |How completely CFBD parsed the play text for this row.                         |
#'  |ppa                         |numeric   |Predicted points added on the play.                                            |
#'  |success                     |logical   |TRUE when the play met the success threshold for its down and distance.        |
#'
#' `rush_direction` comes back all-`NA` for any request whose plays were not
#' direction-parsed, in which case R types the column `logical`. Filter on
#' `direction_analysis_eligible` (or `parse_status`) rather than assuming it is
#' populated, and use `attribution_status` before trusting `rusher_id`.
#'
#' @keywords Rushing Plays
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Rushing
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_rushing_plays(year = 2025, week = 5, team = "Texas"))
#' }

cfbd_rushing_plays <- function(year = NULL,
                               week = NULL,
                               game_id = NULL,
                               season_type = NULL,
                               team = NULL,
                               offense = NULL,
                               defense = NULL,
                               conference = NULL,
                               rusher_id = NULL,
                               rush_direction = NULL,
                               direction_analysis_eligible = NULL,
                               attribution_status = NULL,
                               is_rushing_touchdown = NULL,
                               is_sack = NULL,
                               is_kneel = NULL,
                               is_team_rush = NULL,
                               classification = NULL) {

  # Validation Lists ----
  directions <- c("left", "middle", "right")
  attributions <- c(
    "individual", "team", "multi_carrier",
    "unmatched", "ambiguous", "conflict", "unlinked"
  )

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_id(game_id)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_list(rush_direction, directions)
  validate_list(attribution_status, attributions)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)
  offense <- handle_accents(offense)
  defense <- handle_accents(defense)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/rushing/plays"
  query_params <- list(
    "gameId" = game_id,
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "offense" = offense,
    "defense" = defense,
    "conference" = conference,
    "rusherId" = rusher_id,
    "rushDirection" = rush_direction,
    "directionAnalysisEligible" = direction_analysis_eligible,
    "attributionStatus" = attribution_status,
    "isRushingTouchdown" = is_rushing_touchdown,
    "isSack" = is_sack,
    "isKneel" = is_kneel,
    "isTeamRush" = is_team_rush,
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

      if (is.data.frame(parsed) && nrow(parsed) > 0) {
        df <- parsed |>
          janitor::clean_names()
      }

      if (nrow(df) > 0) df <- df |>
        make_cfbfastR_data("Rushing plays data from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no rushing plays data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
