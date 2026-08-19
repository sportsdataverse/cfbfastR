#' @name cfbd_players
#' @aliases cfbd_player
#' @title
#' **CFBD Players Endpoint Overview**
#' @description
#'
#' * `cfbd_player_info()`: Player information search.
#' * `cfbd_player_returning()`: Player returning production.
#' * `cfbd_player_usage()`: Player usage.
#' * `cfbd_player_season_overview()`: Get a season overview for a single player.
#'
#' @details
#' ### **Player information lookup**
#' ```r
#'  cfbd_player_info(search_term = "James", position = "DB", team = "Florida State", year = 2017)
#'
#'  cfbd_player_info(search_term = "Lawrence", team = "Clemson")
#' ```
#' ### **Get player returning production**
#' ```r
#'  cfbd_player_returning(year = 2019, team = "Florida State")
#' ```
#' ### **Get player usage metrics**
#' ```r
#'  cfbd_player_usage(year = 2019, position = "WR", team = "Florida State")
#' ```
#'
#' ## **Get a player season overview**
#'
#' ```r
#' cfbd_player_season_overview(year = 2024, athlete_id = 4429105)
#' ```

NULL

#' @title
#' **Player information lookup**
#' @param search_term (*String* required): Search term for the player you are trying to look up
#' @param position (*string* optional): Position of the player you are searching for.
#' Position Group  - options include:
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL
#'  * Special Teams: K, P, LS, PK
#' @param team (*String* optional): Team - Select a valid team, D1 football
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*).
#' If left NULL, API default will only provide results for most recent year of final rosters: 2020 \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_player_info', 'min_year']`
#' @return [cfbd_player_info()] - A data frame with 12 variables:
#'
#'    |col_name             |types     |description                                            |
#'    |:--------------------|:---------|:------------------------------------------------------|
#'    |athlete_id           |character |Unique CFBD player identifier.                         |
#'    |team                 |character |Team of the player.                                    |
#'    |name                 |character |Player full name.                                      |
#'    |first_name           |character |Player first name.                                     |
#'    |last_name            |character |Player last name.                                      |
#'    |weight               |integer   |Player weight in pounds.                               |
#'    |height               |integer   |Player height in inches.                               |
#'    |jersey               |integer   |Player jersey number.                                  |
#'    |position             |character |Player position abbreviation (e.g. QB, RB, WR).        |
#'    |home_town            |character |Player home town.                                      |
#'    |team_color           |character |Player team primary color (hex code).                  |
#'    |team_color_secondary |character |Player team secondary color (hex code).                |
#'
#' @keywords Players
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @family CFBD Players
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_player_info(search_term = "James", position = "DB", team = "Florida State", year = 2017))
#'
#'   try(cfbd_player_info(search_term = "Lawrence", team = "Clemson"))
#' }
cfbd_player_info <- function(search_term,
                             position = NULL,
                             team = NULL,
                             year = NULL) {

  # Validation Lists ----
  pos_groups <- c(
    "QB", "RB", "FB", "TE", "WR", "OL", "OT", "G", "OC",
    "DB", "CB", "S", "LB", "DE", "NT", "DL", "DT",
    "K", "P", "PK", "LS"
  )

  # Validation ----
  validate_api_key()
  validate_list(position, pos_groups)
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/player/search"
  query_params <- list(
    "searchTerm" = search_term,
    "position" = position,
    "team" = team,
    "year" = year
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)
      # Get the content and return it as data.frame

      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        janitor::clean_names() |>
        dplyr::rename(
          "athlete_id" = "id",
          "home_town" = "hometown"
        )


      df <- df |>
        make_cfbfastR_data("Player information from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player info data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}



#' @title
#' **Get player returning production**
#' @param year (*Integer* required, default most recent season): Year, 4 digit format (*YYYY*). \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_player_returning', 'min_year']`
#' @param team (*String* optional): Team - Select a valid team, D1 football
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @return [cfbd_player_returning()] - A data frame with 15 variables:
#'
#'    |col_name              |types     |description                                                            |
#'    |:---------------------|:---------|:----------------------------------------------------------------------|
#'    |season                |integer   |Four-digit season year for returning production.                       |
#'    |team                  |character |Team name.                                                             |
#'    |conference            |character |Conference of team.                                                    |
#'    |total_ppa             |numeric   |Total predicted points added (PPA) returning.                          |
#'    |total_passing_ppa     |numeric   |Total passing predicted points added returning.                        |
#'    |total_receiving_ppa   |numeric   |Total receiving predicted points added returning.                      |
#'    |total_rushing_ppa     |numeric   |Total rushing predicted points added returning.                        |
#'    |percent_ppa           |numeric   |Percentage of prior year's predicted points added returning.           |
#'    |percent_passing_ppa   |numeric   |Percentage of prior year's passing predicted points added returning.   |
#'    |percent_receiving_ppa |numeric   |Percentage of prior year's receiving predicted points added returning. |
#'    |percent_rushing_ppa   |numeric   |Percentage of prior year's rushing predicted points added returning.   |
#'    |usage                 |numeric   |Share of prior year's overall offensive usage returning.               |
#'    |passing_usage         |numeric   |Share of prior year's passing usage returning.                         |
#'    |receiving_usage       |numeric   |Share of prior year's receiving usage returning.                       |
#'    |rushing_usage         |numeric   |Share of prior year's rushing usage returning.                         |
#'
#' @keywords Returning Production
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @family CFBD Players
#' @export
#' @examples
#' \donttest{
#'    try(cfbd_player_returning(year = 2019, team = "Florida State"))
#' }
#'
cfbd_player_returning <- function(year = most_recent_cfb_season(),
                                  team = NULL,
                                  conference = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/player/returning"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {
      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        dplyr::rename(
          "total_ppa" = "totalPPA",
          "total_passing_ppa" = "totalPassingPPA",
          "total_receiving_ppa" = "totalReceivingPPA",
          "total_rushing_ppa" = "totalRushingPPA",
          "percent_ppa" = "percentPPA",
          "percent_passing_ppa" = "percentPassingPPA",
          "percent_receiving_ppa" = "percentReceivingPPA",
          "percent_rushing_ppa" = "percentRushingPPA",
          "passing_usage" = "passingUsage",
          "receiving_usage" = "receivingUsage",
          "rushing_usage" = "rushingUsage"
        )


      df <- df |>
        make_cfbfastR_data("Returning production data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no returning player data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get player usage metrics**
#' @param year (*Integer* required, default most recent season): Year, 4 digit format (*YYYY*). \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_player_usage', 'min_year']`
#' @param team (*String* optional): Team - Select a valid team, D1 football
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param position (*string* optional): Position of the player you are searching for.
#' Position Group  - options include:
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL
#'  * Special Teams: K, P, LS, PK
#' @param athlete_id (*Integer* optional): Athlete ID filter for querying a single athlete
#' Can be found using the [cfbd_player_info()] function.
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE/FALSE)
#' @return [cfbd_player_usage()] - A data frame with 14 variables:
#'
#'    |col_name           |types     |description                                            |
#'    |:------------------|:---------|:------------------------------------------------------|
#'    |season             |integer   |Four-digit season year for player usage.               |
#'    |athlete_id         |character |Unique CFBD athlete identifier.                        |
#'    |name               |character |Athlete full name.                                     |
#'    |position           |character |Athlete position abbreviation (e.g. QB, RB, WR).       |
#'    |team               |character |Team name.                                             |
#'    |conference         |character |Conference of team.                                    |
#'    |usg_overall        |numeric   |Player share of overall offensive usage.               |
#'    |usg_pass           |numeric   |Player share of team passing usage.                    |
#'    |usg_rush           |numeric   |Player share of team rushing usage.                    |
#'    |usg_1st_down       |numeric   |Player share of team usage on first downs.             |
#'    |usg_2nd_down       |numeric   |Player share of team usage on second downs.            |
#'    |usg_3rd_down       |numeric   |Player share of team usage on third downs.             |
#'    |usg_standard_downs |numeric   |Player share of team usage on standard downs.          |
#'    |usg_passing_downs  |numeric   |Player share of team usage on passing downs.           |
#'
#' @keywords Player Usage
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify_query resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom purrr map_if
#' @importFrom dplyr as_tibble rename
#' @family CFBD Players
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_player_usage(year = 2019, position = "WR", team = "Florida State"))
#' }
#'
cfbd_player_usage <- function(year = most_recent_cfb_season(),
                              team = NULL,
                              conference = NULL,
                              position = NULL,
                              athlete_id = NULL,
                              excl_garbage_time = FALSE) {

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
  validate_id(athlete_id)
  validate_list(excl_garbage_time, c(T,F))

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/player/usage"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference,
    "position" = position,
    "playerId" = athlete_id,
    "excludeGarbageTime" = excl_garbage_time
  )
  full_url <- httr2::url_modify_query(base_url, !!!.compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        purrr::map_if(is.data.frame, list) |>
        dplyr::as_tibble() |>
        dplyr::rename(
          "athlete_id" = "id",
          "usg_overall" = "usage.overall",
          "usg_pass" = "usage.pass",
          "usg_rush" = "usage.rush",
          "usg_1st_down" = "usage.firstDown",
          "usg_2nd_down" = "usage.secondDown",
          "usg_3rd_down" = "usage.thirdDown",
          "usg_standard_downs" = "usage.standardDowns",
          "usg_passing_downs" = "usage.passingDowns"
        )


      df <- df |>
        make_cfbfastR_data("Player usage data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no player usage data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get a player season overview**
#' @param year (*Integer* required): Season, 4 digits (YYYY).
#' @param athlete_id (*Integer* required): Player identifier.
#' @description
#' **Get a player season overview**
#' Season overview for a single player.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#' @return [cfbd_player_season_overview()] - A tibble with 31 columns:
#'
#'    |col_name                   |types     |description                                     |
#'    |:-------------------------|:--------|:----------------------------------------------|
#'    |season                     |integer   |Four-digit season year.                         |
#'    |id                         |character |Record identifier.                              |
#'    |name                       |character |Display name.                                   |
#'    |position                   |character |Listed position.                                |
#'    |team                       |character |Team name.                                      |
#'    |conference                 |character |Conference name.                                |
#'    |games                      |integer   |Games played in the season.                     |
#'    |usage_overall              |numeric   |Share of team plays the player was involved in. |
#'    |usage_pass                 |numeric   |Share of team pass plays involving the player.  |
#'    |usage_rush                 |numeric   |Share of team rush plays involving the player.  |
#'    |usage_first_down           |numeric   |Usage share on first down.                      |
#'    |usage_second_down          |numeric   |Usage share on second down.                     |
#'    |usage_third_down           |numeric   |Usage share on third down.                      |
#'    |usage_standard_downs       |numeric   |Usage share on standard downs.                  |
#'    |usage_passing_downs        |numeric   |Usage share on passing downs.                   |
#'    |ppa_average_all            |numeric   |Ppa average all.                                |
#'    |ppa_average_pass           |numeric   |Ppa average pass.                               |
#'    |ppa_average_rush           |numeric   |Ppa average rush.                               |
#'    |ppa_average_first_down     |numeric   |Ppa average first down.                         |
#'    |ppa_average_second_down    |numeric   |Ppa average second down.                        |
#'    |ppa_average_third_down     |numeric   |Ppa average third down.                         |
#'    |ppa_average_standard_downs |numeric   |Ppa average standard downs.                     |
#'    |ppa_average_passing_downs  |numeric   |Ppa average passing downs.                      |
#'    |ppa_total_all              |numeric   |Ppa total all.                                  |
#'    |ppa_total_pass             |numeric   |Ppa total pass.                                 |
#'    |ppa_total_rush             |numeric   |Ppa total rush.                                 |
#'    |ppa_total_first_down       |numeric   |Ppa total first down.                           |
#'    |ppa_total_second_down      |numeric   |Ppa total second down.                          |
#'    |ppa_total_third_down       |numeric   |Ppa total third down.                           |
#'    |ppa_total_standard_downs   |numeric   |Ppa total standard downs.                       |
#'    |ppa_total_passing_downs    |numeric   |Ppa total passing downs.                        |
#'
#' @keywords Players
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Players Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_player_season_overview(year = 2024, athlete_id = 4429105))
#' }
cfbd_player_season_overview <- function(year, athlete_id, proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/player/season/overview"
  query_params <- list(
    "year" = year,
    "playerId" = athlete_id
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {
      res <- get_req(full_url, proxy = proxy)
      check_status(res)

      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      # One nested object per player-season: scalars plus `usage`, `ppa` and
      # `boxScoreStats` blocks whose members are themselves scalars of differing
      # lengths -- which is why a plain as_tibble() fails with "columns must
      # have compatible sizes". Flattening lifts each into its own prefixed
      # column, giving a single rectangular row.
      df <- dplyr::as_tibble(as.data.frame(.cfbd_flatten_scalars(df),
                                           stringsAsFactors = FALSE)) |>
        janitor::clean_names()

      df <- df |>
        make_cfbfastR_data("Get a player season overview from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no players data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
