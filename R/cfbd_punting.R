#' @name cfbd_punting
#' @title
#' **CFBD Punting Endpoint Overview**
#' @description
#'
#' * `cfbd_punting_players_season()`: Get player season punting and punt return production.
#' * `cfbd_punting_players_games()`: Get player game punting and punt return production.
#' * `cfbd_punting_teams_season()`: Get team season punting production, kicking and receiving.
#' * `cfbd_punting_teams_games()`: Get team game punting production, kicking and receiving.
#' * `cfbd_punting_plays()`: Get individual punt plays with yardage, field position and outcome.
#'
#' @details
#' ### **Get player season punting production**
#' ```r
#'   cfbd_punting_players_season(year = 2025, team = "Texas")
#' ```
#' ### **Get player game punting production**
#' ```r
#'   cfbd_punting_players_games(year = 2025, week = 5)
#' ```
#' ### **Get team season punting production**
#' ```r
#'   cfbd_punting_teams_season(year = 2025, team = "Texas")
#' ```
#' ### **Get team game punting production**
#' ```r
#'   cfbd_punting_teams_games(year = 2025, week = 5)
#' ```
#' ### **Get individual punt plays**
#' ```r
#'   cfbd_punting_plays(year = 2025, week = 1, team = "Texas")
#' ```
#'
#' @section The player punting and return blocks:
#'
#' The two player endpoints carry a 15-column punting block, prefixed `punting_`
#' (e.g. `punting_net_yards_per_punt`), and a 10-column punt return block,
#' prefixed `returning_`. A player who only punted has `NA` return columns, and
#' the reverse.
#'
#' The punting block:
#'
#'  |col_name                  |type      |description                                                                     |
#'  |:-------------------------|:---------|:-------------------------------------------------------------------------------|
#'  |punts                     |integer   |Punts.                                                                           |
#'  |punt_yards_available      |integer   |Punts with known gross yards (the denominator for `yards_per_punt`).             |
#'  |punt_yards                |integer   |Gross punt yards over those punts.                                               |
#'  |yards_per_punt            |double    |Gross yards per punt.                                                            |
#'  |longest_punt              |integer   |Longest punt, in gross yards.                                                    |
#'  |punts50plus               |integer   |Punts of 50 or more gross yards.                                                 |
#'  |net_punt_yards_available  |integer   |Punts with known net yards (the denominator for `net_yards_per_punt`).           |
#'  |net_punt_yards            |integer   |Net punt yards over those punts: gross yards minus return yards, less 20 for a touchback. |
#'  |net_yards_per_punt        |double    |Net yards per punt.                                                              |
#'  |touchbacks                |integer   |Punts that ended in a touchback.                                                 |
#'  |fair_catches              |integer   |Punts fair caught.                                                               |
#'  |out_of_bounds             |integer   |Punts that went out of bounds.                                                   |
#'  |downed                    |integer   |Punts downed by the kicking team.                                                |
#'  |inside20                  |integer   |Punts after which the receiving team took possession inside its own 20, excluding touchbacks. |
#'  |blocked                   |integer   |Punts blocked.                                                                   |
#'
#' The return block:
#'
#'  |col_name                  |type      |description                                                                     |
#'  |:-------------------------|:---------|:-------------------------------------------------------------------------------|
#'  |returns                   |integer   |Punt returns.                                                                    |
#'  |return_yards_available    |integer   |Returns with known yards (the denominator for `yards_per_return`).               |
#'  |return_yards              |integer   |Return yards over those returns.                                                 |
#'  |yards_per_return          |double    |Yards per return.                                                                |
#'  |longest_return            |integer   |Longest return, in yards.                                                        |
#'  |returns20plus             |integer   |Returns of 20 or more yards.                                                     |
#'  |return_touchdowns         |integer   |Returns for a touchdown.                                                         |
#'  |fair_catches              |integer   |Fair catches made.                                                               |
#'  |muffs                     |integer   |Muffed punts.                                                                    |
#'  |blocks                    |integer   |Punts blocked by the player.                                                     |
#'
#' @section The team punting block:
#'
#' The two team endpoints carry one 24-column block twice: `punting_*` covers the
#' team's own punts (so `punting_return_yards` is what opponents returned against
#' it) and `returning_*` covers the punts it received (so `returning_punts` counts
#' opponent punts and `returning_return_yards` is the team's own return yardage).
#' In a game frame, one side's `punting_*` row matches its opponent's
#' `returning_*` row.
#'
#' The block is the first 15 columns of the player punting block above, then:
#'
#'  |col_name                  |type      |description                                                                     |
#'  |:-------------------------|:---------|:-------------------------------------------------------------------------------|
#'  |returns                   |integer   |Punt returns.                                                                    |
#'  |return_yards_available    |integer   |Returns with known yards (the denominator for `yards_per_return`).               |
#'  |return_yards              |integer   |Return yards over those returns.                                                 |
#'  |yards_per_return          |double    |Yards per return.                                                                |
#'  |longest_return            |integer   |Longest return, in yards.                                                        |
#'  |returns20plus             |integer   |Returns of 20 or more yards.                                                     |
#'  |return_touchdowns         |integer   |Returns for a touchdown.                                                         |
#'  |muffs                     |integer   |Muffed punts.                                                                    |
#'  |receiving_team_turnovers  |integer   |Punts on which the receiving team lost possession, such as on a muff or fumble.  |
#'
#' The `*_available` counts are denominators, not statistics. CFBD parses these
#' fields out of play text, so a punt can be counted while its yardage stays
#' unknown. Dividing by `punts` or `returns` instead of the matching
#' `*_available` column understates every mean.
#'
#' @section Season coverage:
#'
#' Unlike the passing and rushing families, these endpoints reach back to
#' **2015**. Earlier seasons answer HTTP 200 with an empty array rather than an
#' error, so a request for 2014 returns an empty data frame, not a failure.
#'
NULL

# Shared request tail for the five punting wrappers: GET, status check, parse,
# and the empty-response guard. An out-of-coverage season answers HTTP 200 with
# `[]`, which parses to a zero-length list; janitor::clean_names() then aborts on
# the absent dimnames. These endpoints only carry 2015 onward, and a filtered
# request can match nothing -- see the same guard in cfbd_passing.R.
.cfbd_punting_fetch <- function(full_url, label, proxy = NULL) {
  df <- data.frame()
  tryCatch(
    expr = {
      res <- get_req(full_url, proxy = proxy)
      check_status(res)

      parsed <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      if (is.data.frame(parsed) && nrow(parsed) > 0) {
        df <- parsed |>
          janitor::clean_names() |>
          make_cfbfastR_data(glue::glue("{label} data from CollegeFootballData.com"), Sys.time())
      }
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no {tolower(label)} data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  df
}

#' @title
#' **Get player season punting and punt return production**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_punting_players_season', 'min_year']`
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param player_id (*String* optional): CFBD athlete id of the player to filter on.
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii. CFBD defaults to fbs.
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#'
#' @return [cfbd_punting_players_season()] - A data frame with 30 variables:
#'
#'  |col_name        |type      |description                                                     |
#'  |:---------------|:---------|:---------------------------------------------------------------|
#'  |season          |integer   |Four-digit season year (e.g. 2025).                             |
#'  |player_id       |character |CFBD athlete identifier (use with `cfbd_player_info()`).        |
#'  |player          |character |Player full name.                                               |
#'  |team            |character |Team name.                                                      |
#'  |conference      |character |Team conference name.                                           |
#'
#' plus the 15-column `punting_*` block and the 10-column `returning_*` block,
#' both described under **The player punting and return blocks** in
#' [cfbd_punting].
#'
#' @keywords Punting Players Season
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Punting
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_punting_players_season(year = 2025, team = "Texas"))
#' }

cfbd_punting_players_season <- function(year = NULL,
                                        season_type = NULL,
                                        team = NULL,
                                        conference = NULL,
                                        player_id = NULL,
                                        classification = NULL,
                                        proxy = NULL) {

  # Validation ----
  validate_api_key()
  # The API requires `year`; validate_year(NULL) is a no-op, so enforce it here.
  if (is.null(year) || anyNA(year)) cli::cli_abort("Missing required field: year")
  validate_year(year)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/punting/players/season"
  query_params <- list(
    "year" = year,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "playerId" = player_id,
    "classification" = classification
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  .cfbd_punting_fetch(full_url, "Player season punting", proxy = proxy)
}

#' @title
#' **Get player game punting and punt return production**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_punting_players_games', 'min_year']`
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' @param player_id (*String* optional): CFBD athlete id of the player to filter on.
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii. CFBD defaults to fbs.
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#'
#' @return [cfbd_punting_players_games()] - A data frame with 34 variables:
#'
#'  |col_name        |type      |description                                                     |
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
#' plus the 15-column `punting_*` block and the 10-column `returning_*` block --
#' see [cfbd_punting].
#'
#' @keywords Punting Players Games
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Punting
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_punting_players_games(year = 2025, week = 5))
#' }

cfbd_punting_players_games <- function(year = NULL,
                                       week = NULL,
                                       season_type = NULL,
                                       team = NULL,
                                       conference = NULL,
                                       player_id = NULL,
                                       classification = NULL,
                                       proxy = NULL) {

  # Validation ----
  validate_api_key()
  if (is.null(year) || anyNA(year)) cli::cli_abort("Missing required field: year")
  validate_year(year)
  validate_week(week)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/punting/players/games"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "playerId" = player_id,
    "classification" = classification
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  .cfbd_punting_fetch(full_url, "Player game punting", proxy = proxy)
}

#' @title
#' **Get team season punting production, kicking and receiving**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_punting_teams_season', 'min_year']`
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii. CFBD defaults to fbs.
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#'
#' @return [cfbd_punting_teams_season()] - A data frame with 51 variables:
#'
#'  |col_name        |type      |description                                                     |
#'  |:---------------|:---------|:---------------------------------------------------------------|
#'  |season          |integer   |Four-digit season year (e.g. 2025).                             |
#'  |team            |character |Team name.                                                      |
#'  |conference      |character |Team conference name.                                           |
#'
#' plus TWO copies of the 24-column team punting block: `punting_*` (the team's
#' own punts) and `returning_*` (the punts it received). That is 3 + 2 x 24 = 51.
#' See **The team punting block** in [cfbd_punting].
#'
#' @keywords Punting Teams Season
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Punting
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_punting_teams_season(year = 2025, team = "Texas"))
#' }

cfbd_punting_teams_season <- function(year = NULL,
                                      season_type = NULL,
                                      team = NULL,
                                      conference = NULL,
                                      classification = NULL,
                                      proxy = NULL) {

  # Validation ----
  validate_api_key()
  if (is.null(year) || anyNA(year)) cli::cli_abort("Missing required field: year")
  validate_year(year)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/punting/teams/season"
  query_params <- list(
    "year" = year,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "classification" = classification
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  .cfbd_punting_fetch(full_url, "Team season punting", proxy = proxy)
}

#' @title
#' **Get team game punting production, kicking and receiving**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_punting_teams_games', 'min_year']`
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii. CFBD defaults to fbs.
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#'
#' @return [cfbd_punting_teams_games()] - A data frame with 55 variables:
#'
#'  |col_name        |type      |description                                                     |
#'  |:---------------|:---------|:---------------------------------------------------------------|
#'  |game_id         |integer   |Unique game identifier - `game_id`.                             |
#'  |season          |integer   |Four-digit season year (e.g. 2025).                             |
#'  |week            |integer   |Week of the season.                                             |
#'  |season_type     |character |Season type (regular, postseason, ...).                         |
#'  |team            |character |Team name.                                                      |
#'  |conference      |character |Team conference name.                                           |
#'  |opponent        |character |Opposing team name.                                             |
#'
#' plus TWO copies of the 24-column team punting block, `punting_*` and
#' `returning_*`: 7 + 2 x 24 = 55. See [cfbd_punting].
#'
#' @keywords Punting Teams Games
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Punting
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_punting_teams_games(year = 2025, week = 5))
#' }

cfbd_punting_teams_games <- function(year = NULL,
                                     week = NULL,
                                     season_type = NULL,
                                     team = NULL,
                                     conference = NULL,
                                     classification = NULL,
                                     proxy = NULL) {

  # Validation ----
  validate_api_key()
  if (is.null(year) || anyNA(year)) cli::cli_abort("Missing required field: year")
  validate_year(year)
  validate_week(week)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/punting/teams/games"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference,
    "classification" = classification
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  .cfbd_punting_fetch(full_url, "Team game punting", proxy = proxy)
}

#' @title
#' **Get individual punt plays with yardage, field position and outcome**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Required unless `game_id` is given. \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_punting_plays', 'min_year']`
#' @param game_id (*Integer* optional): Game ID filter for querying a single game
#' @param week (*Integer* optional): Week - values range from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier).
#' With `year`, CFBD also needs one of `week`, a team filter, `punter_id` or `returner_id`.
#' @param season_type (*String* optional): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): Team on either side of the punt
#' @param punting_team (*String* optional): Punting team filter
#' @param receiving_team (*String* optional): Receiving team filter
#' @param conference (*String* optional): Conference name or abbreviation on either side of the punt
#' @param punter_id (*String* optional): CFBD athlete id of the punter to filter on.
#' @param returner_id (*String* optional): CFBD athlete id of the returner to filter on.
#' @param classification (*String* optional): Division classification - fbs, fcs, ii, ii/iii, iii. CFBD defaults to fbs.
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#'
#' @return [cfbd_punting_plays()] - A data frame with 46 variables:
#'
#'  |col_name                   |type      |description                                                                              |
#'  |:--------------------------|:---------|:----------------------------------------------------------------------------------------|
#'  |game_id                    |integer   |Unique game identifier - `game_id`.                                                      |
#'  |play_id                    |character |Unique play identifier - `play_id`.                                                      |
#'  |drive_id                   |character |Unique drive identifier - `drive_id`.                                                    |
#'  |season                     |integer   |Four-digit season year (e.g. 2025).                                                      |
#'  |week                       |integer   |Week of the season.                                                                      |
#'  |season_type                |character |Season type (regular, postseason, ...).                                                  |
#'  |punting_team_id            |integer   |Punting team id.                                                                         |
#'  |punting_team               |character |Punting team name.                                                                       |
#'  |punting_conference         |character |Punting team conference name.                                                            |
#'  |receiving_team_id          |integer   |Receiving team id.                                                                       |
#'  |receiving_team             |character |Receiving team name.                                                                     |
#'  |receiving_conference       |character |Receiving team conference name.                                                          |
#'  |period                     |integer   |Quarter of the play.                                                                     |
#'  |down                       |integer   |Down of the play.                                                                        |
#'  |distance                   |integer   |Yards to gain for a first down.                                                          |
#'  |play_type                  |character |CFBD play type (e.g. Punt, Blocked Punt, Punt Return Touchdown).                         |
#'  |play_text                  |character |Play description text as published by the source.                                        |
#'  |punter_id                  |character |CFBD athlete id of the punter.                                                           |
#'  |punter                     |character |Punter full name.                                                                        |
#'  |receiver_id                |character |CFBD athlete id of the player who fielded the punt.                                      |
#'  |receiver                   |character |Full name of the player who fielded the punt.                                            |
#'  |returner_id                |character |CFBD athlete id of the returner.                                                         |
#'  |returner                   |character |Returner full name.                                                                      |
#'  |blocker_id                 |character |CFBD athlete id of the player who blocked the punt.                                      |
#'  |blocker                    |character |Full name of the player who blocked the punt.                                            |
#'  |counts_as_punt             |logical   |TRUE when the play counts as a punt (`NA` when unknown).                                 |
#'  |counts_as_return           |logical   |TRUE when the play counts as a punt return (`NA` when unknown).                          |
#'  |start_yards_to_goal        |integer   |Punting team's yards from the opponent's end zone at the snap.                           |
#'  |punt_yards                 |integer   |Gross punt yards.                                                                        |
#'  |return_yards               |integer   |Return yards for the receiving team.                                                     |
#'  |returner_yards             |integer   |Return yards credited to the returner (`NA` when not credited individually).            |
#'  |net_punt_yards             |integer   |Gross punt yards minus return yards, less 20 yards for a touchback.                      |
#'  |kick_end_yardline          |integer   |Where the kick ended, from the punting team's goal line (0) to the receiving team's (100). |
#'  |end_yardline               |integer   |Where the play ended, on the same scale as `kick_end_yardline`.                          |
#'  |is_touchback               |logical   |TRUE when the punt ended in a touchback.                                                 |
#'  |is_fair_catch              |logical   |TRUE when the punt was fair caught.                                                      |
#'  |is_out_of_bounds           |logical   |TRUE when the punt went out of bounds.                                                   |
#'  |is_downed                  |logical   |TRUE when the punt was downed by the kicking team.                                       |
#'  |is_blocked                 |logical   |TRUE when the punt was blocked.                                                          |
#'  |is_muffed                  |logical   |TRUE when the receiving team muffed the punt.                                            |
#'  |is_return_touchdown        |logical   |TRUE when the return went for a touchdown.                                               |
#'  |is_receiving_team_turnover |logical   |TRUE when the receiving team lost possession, such as on a muff or fumble.               |
#'  |has_penalty                |logical   |TRUE when a penalty was called on the play.                                              |
#'  |parse_status               |character |How completely CFBD parsed the play text - complete or partial.                          |
#'  |clock_minutes              |integer   |Minutes remaining on the game clock at the snap.                                         |
#'  |clock_seconds              |integer   |Seconds remaining on the game clock at the snap.                                         |
#'
#' Columns that are `NA` on every row of a response are typed `logical` by R:
#' `blocker_id` and `blocker` are `NA` in any slate without a blocked punt
#' (2025 week 5 has one blocked punt and no named blocker). Return yardage is
#' `NA`, not 0, on a punt with no return.
#'
#' @keywords Punting Plays
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Punting
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_punting_plays(year = 2025, week = 1, team = "Texas"))
#' }

cfbd_punting_plays <- function(year = NULL,
                               game_id = NULL,
                               week = NULL,
                               season_type = NULL,
                               team = NULL,
                               punting_team = NULL,
                               receiving_team = NULL,
                               conference = NULL,
                               punter_id = NULL,
                               returner_id = NULL,
                               classification = NULL,
                               proxy = NULL) {

  # Validation ----
  validate_api_key()
  # CFBD needs `year` unless `gameId` is given.
  if (is.null(game_id) && (is.null(year) || anyNA(year))) {
    cli::cli_abort("Missing required field: year (or game_id)")
  }
  validate_year(year)
  validate_id(game_id)
  validate_week(week)
  if (!is.null(season_type)) validate_season_type(season_type)
  validate_division(classification)

  # Team Name Handling ----
  team <- handle_accents(team)
  punting_team <- handle_accents(punting_team)
  receiving_team <- handle_accents(receiving_team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/punting/plays"
  query_params <- list(
    "gameId" = game_id,
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "puntingTeam" = punting_team,
    "receivingTeam" = receiving_team,
    "conference" = conference,
    "punterId" = punter_id,
    "returnerId" = returner_id,
    "classification" = classification
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  .cfbd_punting_fetch(full_url, "Punting plays", proxy = proxy)
}
