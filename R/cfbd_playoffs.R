#' @name cfbd_playoffs
#' @aliases cfbd_playoffs playoffs cfp
#' @title
#' **CFBD Playoffs Endpoint Overview**
#' @description
#'
#' * `cfbd_playoffs_cfp()`: College Football Playoff bracket.
#' * `cfbd_playoffs_cfp_games()`: College Football Playoff games.
#' * `cfbd_playoffs_cfp_participants()`: College Football Playoff participants.
#'
NULL

#' @title
#' **Get College Football Playoff bracket information**
#' @param year (*Integer* required): Season, 4 digits (YYYY).
#' @description
#' **Get College Football Playoff bracket information**
#' Returns the College Football Playoff bracket for a season.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#' @return [cfbd_playoffs_cfp()] - A tibble with 46 columns:
#'
#'    |col_name                  |types     |description                                                                      |
#'    |:------------------------|:--------|:-------------------------------------------------------------------------------|
#'    |round_code                |character |Playoff round code (`first_round`, `quarterfinal`, `semifinal`, `championship`). |
#'    |round_name                |character |Human-readable playoff round name.                                               |
#'    |round_order               |integer   |Ordinal position of the round in the bracket.                                    |
#'    |id                        |integer   |Record identifier.                                                               |
#'    |bracket_slot              |character |Bracket position code for the matchup (e.g. `FR1`, `QF2`).                       |
#'    |round                     |character |Playoff round code.                                                              |
#'    |round_name_2              |character |Round name 2.                                                                    |
#'    |round_order_2             |integer   |Round order 2.                                                                   |
#'    |matchup_order             |integer   |Ordinal position of the matchup within its round.                                |
#'    |start_date                |character |Scheduled start date and time (ISO 8601).                                        |
#'    |bowl_name                 |character |Bowl or site name hosting the matchup.                                           |
#'    |game_id                   |integer   |Referencing game id.                                                             |
#'    |game_start_date           |character |Game scheduled start date and time (ISO 8601).                                   |
#'    |game_completed            |logical   |Game completion flag.                                                            |
#'    |game_home_points          |integer   |Game home points.                                                                |
#'    |game_away_points          |integer   |Game away points.                                                                |
#'    |game_venue_id             |integer   |Game referencing venue id.                                                       |
#'    |game_venue                |character |Game venue name.                                                                 |
#'    |game_home_team_id         |integer   |Home team identifier.                                                            |
#'    |game_home_team_school     |character |Home team school name.                                                           |
#'    |game_home_team_conference |character |Home team conference.                                                            |
#'    |game_away_team_id         |integer   |Away team identifier.                                                            |
#'    |game_away_team_school     |character |Away team school name.                                                           |
#'    |game_away_team_conference |character |Away team conference.                                                            |
#'    |advances_to_matchup_id    |integer   |Next-matchup matchup id.                                                         |
#'    |advances_to_bracket_slot  |character |Next-matchup bracket position code for the matchup (e.g. `FR1`, `QF2`).          |
#'    |advances_to_position      |integer   |Next-matchup bracket position.                                                   |
#'    |slot1_position            |integer   |First bracket slot bracket position.                                             |
#'    |slot1_seed                |integer   |First bracket slot seed.                                                         |
#'    |slot1_team_id             |integer   |First bracket slot referencing team id.                                          |
#'    |slot1_school              |character |First bracket slot school name.                                                  |
#'    |slot1_conference          |character |First bracket slot conference.                                                   |
#'    |slot2_position            |integer   |Second bracket slot bracket position.                                            |
#'    |slot2_seed                |integer   |Second bracket slot seed.                                                        |
#'    |slot2_team_id             |integer   |Second bracket slot referencing team id.                                         |
#'    |slot2_school              |character |Second bracket slot school name.                                                 |
#'    |slot2_conference          |character |Second bracket slot conference.                                                  |
#'    |season                    |integer   |Four-digit season year.                                                          |
#'    |competition               |character |Competition identifier (e.g. `cfp`).                                             |
#'    |format                    |character |Bracket format descriptor.                                                       |
#'    |team_count                |integer   |Number of teams in the field.                                                    |
#'    |status                    |character |Status of the competition.                                                       |
#'    |champion_id               |integer   |Referencing team id of the champion.                                             |
#'    |champion_school           |character |School name of the champion.                                                     |
#'    |champion_conference       |character |Conference of the champion.                                                      |
#'    |advances_to               |logical   |Advances to.                                                                     |
#'
#' @keywords Playoffs
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Playoff Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_playoffs_cfp(year = 2024))
#' }
cfbd_playoffs_cfp <- function(year, proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/playoffs/cfp"
  query_params <- list(
    "year" = year
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

      # The endpoint returns ONE nested bracket object: season-level scalars, a
      # `rounds` frame whose `matchups` is itself a list of frames, and a
      # `champion` list. The rectangular unit is the MATCHUP -- 11 of them for a
      # 12-team field -- so rounds are unnested and the season scalars and
      # champion are recycled onto every row.
      rounds <- df[["rounds"]]
      champ  <- df[["champion"]] %||% list()
      season_cols <- list(
        season      = df[["season"]]      %||% NA_integer_,
        competition = df[["competition"]] %||% NA_character_,
        format      = df[["format"]]      %||% NA_character_,
        team_count  = df[["teamCount"]]   %||% NA_integer_,
        status      = df[["status"]]      %||% NA_character_,
        champion_id         = champ[["id"]]         %||% NA_integer_,
        champion_school     = champ[["school"]]     %||% NA_character_,
        champion_conference = champ[["conference"]] %||% NA_character_
      )

      out <- list()
      for (i in seq_len(NROW(rounds))) {
        mu <- rounds[["matchups"]][[i]]
        if (is.null(mu) || !NROW(mu)) next
        # `slots` is the seed -> participant pairing for the matchup (two rows).
        # Widened to slot1_*/slot2_* so the frame stays rectangular; the resolved
        # pairing also survives as game_home_team_* / game_away_team_*.
        slots <- mu[["slots"]]
        mu <- mu[setdiff(names(mu), "slots")]
        wide <- do.call(rbind, lapply(seq_len(NROW(mu)), function(k) {
          sl <- if (is.null(slots)) NULL else slots[[k]]
          one <- function(n, col) {
            if (is.null(sl) || NROW(sl) < n || !col %in% names(sl)) NA else sl[[col]][n]
          }
          data.frame(
            slot1_position = one(1, "position"), slot1_seed = one(1, "seed"),
            slot1_team_id = one(1, "participant.id"),
            slot1_school = one(1, "participant.school"),
            slot1_conference = one(1, "participant.conference"),
            slot2_position = one(2, "position"), slot2_seed = one(2, "seed"),
            slot2_team_id = one(2, "participant.id"),
            slot2_school = one(2, "participant.school"),
            slot2_conference = one(2, "participant.conference"),
            stringsAsFactors = FALSE
          )
        }))
        out[[length(out) + 1L]] <- cbind(
          data.frame(round_code = rounds[["code"]][i], round_name = rounds[["name"]][i],
                     round_order = rounds[["order"]][i], stringsAsFactors = FALSE),
          mu, wide, as.data.frame(season_cols, stringsAsFactors = FALSE)
        )
      }
      df <- if (length(out)) {
        dplyr::as_tibble(dplyr::bind_rows(out)) |> janitor::clean_names()
      } else {
        dplyr::as_tibble(as.data.frame(season_cols, stringsAsFactors = FALSE))
      }

      df <- df |>
        make_cfbfastR_data("Get College Football Playoff bracket information from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no playoffs data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get College Football Playoff games**
#' @param year (*Integer* required): Season, 4 digits (YYYY).
#' @param round (*String* optional): `first_round`, `quarterfinal`, `semifinal` or `championship`.
#' @description
#' **Get College Football Playoff games**
#' Returns the games played in the College Football Playoff for a season.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#' @return [cfbd_playoffs_cfp_games()] - A tibble with 34 columns:
#'
#'    |col_name                  |types     |description                                                             |
#'    |:------------------------|:--------|:----------------------------------------------------------------------|
#'    |id                        |integer   |Record identifier.                                                      |
#'    |bracket_slot              |character |Bracket position code for the matchup (e.g. `FR1`, `QF2`).              |
#'    |round                     |character |Playoff round code.                                                     |
#'    |round_name                |character |Human-readable playoff round name.                                      |
#'    |round_order               |integer   |Ordinal position of the round in the bracket.                           |
#'    |matchup_order             |integer   |Ordinal position of the matchup within its round.                       |
#'    |start_date                |character |Scheduled start date and time (ISO 8601).                               |
#'    |bowl_name                 |character |Bowl or site name hosting the matchup.                                  |
#'    |game_id                   |integer   |Referencing game id.                                                    |
#'    |game_start_date           |character |Game scheduled start date and time (ISO 8601).                          |
#'    |game_completed            |logical   |Game completion flag.                                                   |
#'    |game_home_points          |integer   |Game home points.                                                       |
#'    |game_away_points          |integer   |Game away points.                                                       |
#'    |game_venue_id             |integer   |Game referencing venue id.                                              |
#'    |game_venue                |character |Game venue name.                                                        |
#'    |game_home_team_id         |integer   |Home team identifier.                                                   |
#'    |game_home_team_school     |character |Home team school name.                                                  |
#'    |game_home_team_conference |character |Home team conference.                                                   |
#'    |game_away_team_id         |integer   |Away team identifier.                                                   |
#'    |game_away_team_school     |character |Away team school name.                                                  |
#'    |game_away_team_conference |character |Away team conference.                                                   |
#'    |advances_to_matchup_id    |integer   |Next-matchup matchup id.                                                |
#'    |advances_to_bracket_slot  |character |Next-matchup bracket position code for the matchup (e.g. `FR1`, `QF2`). |
#'    |advances_to_position      |integer   |Next-matchup bracket position.                                          |
#'    |slot1_position            |integer   |First bracket slot bracket position.                                    |
#'    |slot1_seed                |integer   |First bracket slot seed.                                                |
#'    |slot1_team_id             |integer   |First bracket slot referencing team id.                                 |
#'    |slot1_school              |character |First bracket slot school name.                                         |
#'    |slot1_conference          |character |First bracket slot conference.                                          |
#'    |slot2_position            |integer   |Second bracket slot bracket position.                                   |
#'    |slot2_seed                |integer   |Second bracket slot seed.                                               |
#'    |slot2_team_id             |integer   |Second bracket slot referencing team id.                                |
#'    |slot2_school              |character |Second bracket slot school name.                                        |
#'    |slot2_conference          |character |Second bracket slot conference.                                         |
#'
#' @keywords Playoffs
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Playoff Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_playoffs_cfp_games(year = 2024))
#' }
cfbd_playoffs_cfp_games <- function(year, round = NULL, proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  if (!is.null(round)) validate_list(round, c('first_round','quarterfinal','semifinal','championship'))

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/playoffs/cfp/games"
  query_params <- list(
    "year" = year,
    "round" = round
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

      # `slots` is the seed -> participant pairing for each matchup (two rows).
      # Widened to slot1_*/slot2_* for the same reason as cfbd_playoffs_cfp():
      # a nested frame in a list-column is not usable with dplyr verbs, and the
      # bracket is always two-sided so widening is lossless.
      slots <- df[["slots"]]
      df <- df[setdiff(names(df), "slots")]
      if (!is.null(slots)) {
        one <- function(k, n, col) {
          sl <- slots[[k]]
          if (is.null(sl) || NROW(sl) < n || !col %in% names(sl)) NA else sl[[col]][n]
        }
        wide <- do.call(rbind, lapply(seq_len(NROW(df)), function(k) data.frame(
          slot1_position = one(k, 1, "position"), slot1_seed = one(k, 1, "seed"),
          slot1_team_id = one(k, 1, "participant.id"),
          slot1_school = one(k, 1, "participant.school"),
          slot1_conference = one(k, 1, "participant.conference"),
          slot2_position = one(k, 2, "position"), slot2_seed = one(k, 2, "seed"),
          slot2_team_id = one(k, 2, "participant.id"),
          slot2_school = one(k, 2, "participant.school"),
          slot2_conference = one(k, 2, "participant.conference"),
          stringsAsFactors = FALSE)))
        df <- cbind(df, wide)
      }
      df <- dplyr::as_tibble(df) |>
        janitor::clean_names()

      df <- df |>
        make_cfbfastR_data("Get College Football Playoff games from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no playoffs data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get College Football Playoff participants**
#' @param year (*Integer* required): Season, 4 digits (YYYY).
#' @description
#' **Get College Football Playoff participants**
#' Returns the teams that participated in the College Football Playoff for a season.
#'
#' @param proxy (*List* optional): Per-call proxy override passed to
#'   `get_req()`. `NULL` (default) falls back to
#'   `getOption("cfbfastR.proxy")` and then the `http(s)_proxy` environment
#'   variables, so a caller can override the shared setting for one endpoint.
#' @return [cfbd_playoffs_cfp_participants()] - A tibble with 12 columns:
#'
#'    |col_name              |types     |description                                         |
#'    |:--------------------|:--------|:--------------------------------------------------|
#'    |committee_rank        |integer   |Selection-committee rank.                           |
#'    |seed                  |integer   |Seed in the bracket.                                |
#'    |bid_type              |character |How the team qualified (`automatic` or `at_large`). |
#'    |qualification_reason  |character |Stated reason the team qualified.                   |
#'    |conference_champion   |logical   |TRUE if the team won its conference.                |
#'    |qualifying_conference |character |Conference through which the team qualified.        |
#'    |first_round_bye       |logical   |TRUE if the team received a first-round bye.        |
#'    |outcome               |character |Outcome of the team's playoff run.                  |
#'    |eliminated_round      |character |Round in which the team was eliminated.             |
#'    |team_id               |integer   |Referencing team id.                                |
#'    |team_school           |character |School name of the team.                            |
#'    |team_conference       |character |Conference the team belongs to.                     |
#'
#' @keywords Playoffs
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Playoff Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_playoffs_cfp_participants(year = 2024))
#' }
cfbd_playoffs_cfp_participants <- function(year, proxy = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/playoffs/cfp/participants"
  query_params <- list(
    "year" = year
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
        make_cfbfastR_data("Get College Football Playoff participants from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no playoffs data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
