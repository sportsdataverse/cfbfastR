# yahoo_cfb.R -- Yahoo Sports college football wrappers.
#
# Read-only wrappers over Yahoo's shangrila stats graph
# (graphite-secure.sports.yahoo.com/v1/query/shangrila) and editorial feed
# (api-secure.sports.yahoo.com/v1/editorial/s). Reverse-engineering notes +
# per-host OpenAPI specs live in the sdv-internal-refs repo (_notes/ysportsapi/
# and yahoo/). NCAAF vertical slice. No auth: hosts only need Origin/Referer.

.YAHOO_SHANGRILA <- "https://graphite-secure.sports.yahoo.com/v1/query/shangrila/"
.YAHOO_EDITORIAL <- "https://api-secure.sports.yahoo.com/v1/editorial/s/"

# valid legacy categories (from the sdv-internal-refs catalog crawl, Pass A)
.YAHOO_LEGACY_PLAYER_CATS <- c("Passing", "Rushing", "Receiving", "Defense",
                               "Kicking", "Punting", "Returns")
.YAHOO_LEGACY_TEAM_CATS <- c(.YAHOO_LEGACY_PLAYER_CATS, "Kickoffs", "Offense")

.yahoo_or <- function(a, b) if (is.null(a) || length(a) == 0) b else a

#' @keywords internal
#' @importFrom httr2 request req_url_query req_headers req_retry req_perform resp_body_string
#' @importFrom jsonlite fromJSON
.yahoo_get <- function(base, path, query = list()) {
  query[["lang"]]   <- .yahoo_or(query[["lang"]], "en-US")
  query[["region"]] <- .yahoo_or(query[["region"]], "US")
  query[["tz"]]     <- .yahoo_or(query[["tz"]], "America/Chicago")
  httr2::request(paste0(base, path)) |>
    httr2::req_url_query(!!!query) |>
    httr2::req_headers(Origin = "https://sports.yahoo.com",
                       Referer = "https://sports.yahoo.com/") |>
    httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
    httr2::req_perform() |>
    httr2::resp_body_string(encoding = "UTF-8") |>
    jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)
}

# player|team header -> flat named list of id/name columns
#' @importFrom janitor make_clean_names
.yahoo_entity_cols <- function(row) {
  ent <- .yahoo_or(row[["player"]], row[["team"]])
  if (is.null(ent)) return(list())
  if (!is.null(ent[["playerId"]])) {
    team_node <- .yahoo_or(ent[["team"]], list())
    list(player_id = .yahoo_or(ent[["playerId"]], NA_character_),
         display_name = .yahoo_or(ent[["displayName"]], NA_character_),
         team = .yahoo_or(team_node[["displayName"]], NA_character_),
         team_abbreviation = .yahoo_or(team_node[["abbreviation"]], NA_character_))
  } else {
    list(team = .yahoo_or(ent[["displayName"]], NA_character_),
         team_abbreviation = .yahoo_or(ent[["abbreviation"]], NA_character_))
  }
}

# one row's stats list -> append statId=value pairs (cleaned names) to a record
.yahoo_add_stats <- function(rec, row) {
  for (s in .yahoo_or(row[["stats"]], list())) {
    sid <- s[["statId"]]
    if (!is.null(sid)) {
      rec[[janitor::make_clean_names(sid)]] <- .yahoo_or(s[["value"]], NA_character_)
    }
  }
  rec
}

# modern envelope: data.leagues[[1]][[sport_key]] -> list of wide records
.yahoo_modern_rows <- function(payload, sport_key) {
  leagues <- .yahoo_or(payload[["data"]][["leagues"]], list())
  if (!length(leagues)) return(list())
  rows_in <- .yahoo_or(leagues[[1]][[sport_key]], list())
  lapply(rows_in, function(row) .yahoo_add_stats(.yahoo_entity_cols(row), row))
}

# legacy envelope: data.leagues[[1]].leaders -> list of wide records
.yahoo_legacy_rows <- function(payload) {
  leagues <- .yahoo_or(payload[["data"]][["leagues"]], list())
  if (!length(leagues)) return(list())
  leaders <- .yahoo_or(leagues[[1]][["leaders"]], list())
  lapply(leaders, function(row) .yahoo_add_stats(.yahoo_entity_cols(row), row))
}

# editorial dynamic-id map: service[[k1]][[k2]] -> list of its values (rows)
.yahoo_map_rows <- function(payload, k1, k2) {
  node <- .yahoo_or(payload[["service"]][[k1]][[k2]], list())
  unname(node)
}

# list-of-named-lists -> tibble (bind_rows fills missing cols with NA)
#' @importFrom dplyr bind_rows
#' @importFrom tibble as_tibble
.yahoo_bind <- function(rows) {
  if (!length(rows)) return(data.frame())
  dplyr::bind_rows(lapply(rows, function(r) as.data.frame(r, stringsAsFactors = FALSE)))
}

#' **Get Yahoo Sports college football player season stats (modern)**
#'
#' Flattens the shangrila `leagueStatsIndividual` response (all stat groups in
#' one call) into one wide tibble with one row per player. NCAAF data is
#' available 2013-present.
#'
#' @param season (integer): Season year (e.g. `2024`). Defaults to `most_recent_cfb_season()`.
#' @param league_structure (character): Division filter. Defaults to `"ncaaf.struct.div.1"` (FBS).
#' @param count (integer): Max players. Defaults to `200`.
#' @param qualified (logical): Restrict to qualified leaders. Defaults to `FALSE`.
#' @return A `cfbfastR`-tagged tibble with one row per player. Core columns:
#'
#' * `player_id`: character.: Yahoo player id (`ncaaf.p.*`).
#' * `display_name`: character.: Player name.
#' * `team`: character.: Team display name.
#' * `team_abbreviation`: character.: Team abbreviation.
#' * `season`: integer.: Season echoed back.
#'
#' Remaining columns are one per `statId` (e.g. `passing_yards`, `rushing_yards`,
#' `receptions`, ...), value as displayed (character). Column set grows over time.
#'
#' @keywords Stats Data
#' @importFrom janitor clean_names
#' @importFrom tibble as_tibble
#' @export
#' @family Yahoo CFB Functions
#' @examples
#' \donttest{
#'   try(yahoo_cfb_player_season_stats(season = 2024))
#' }
yahoo_cfb_player_season_stats <- function(season = most_recent_cfb_season(),
                                          league_structure = "ncaaf.struct.div.1",
                                          count = 200, qualified = FALSE) {
  out <- data.frame()
  tryCatch(
    expr = {
      raw <- .yahoo_get(.YAHOO_SHANGRILA, "leagueStatsIndividual",
                        query = list(leagues = "ncaaf", season = season, count = count,
                                     leagueStructureId = league_structure,
                                     qualified = tolower(as.character(qualified))))
      out <- .yahoo_bind(.yahoo_modern_rows(raw, "footballStats")) |>
        tibble::as_tibble() |>
        janitor::clean_names()
      if (nrow(out)) out[["season"]] <- season
      out <- make_cfbfastR_data(out, "Player season stats from Yahoo Sports (shangrila)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid arguments or no Yahoo player stats available!"))
    }
  )
  return(.attach_query_meta_auto(out))
}

#' **Get Yahoo Sports college football team season stats (modern)**
#'
#' Flattens the shangrila `leagueStatsByTeam` response into one wide tibble with
#' one row per team (all stat groups in one call).
#'
#' @param season (integer): Season year. Defaults to `most_recent_cfb_season()`.
#' @param league_structure (character): Division filter. Defaults to `"ncaaf.struct.div.1"`.
#' @param count (integer): Max teams. Defaults to `200`.
#' @return A `cfbfastR`-tagged tibble with one row per team: `team`,
#'   `team_abbreviation`, `season`, plus one column per `statId`.
#'
#' @keywords Stats Data
#' @importFrom janitor clean_names
#' @importFrom tibble as_tibble
#' @export
#' @family Yahoo CFB Functions
#' @examples
#' \donttest{
#'   try(yahoo_cfb_team_season_stats(season = 2024))
#' }
yahoo_cfb_team_season_stats <- function(season = most_recent_cfb_season(),
                                        league_structure = "ncaaf.struct.div.1",
                                        count = 200) {
  out <- data.frame()
  tryCatch(
    expr = {
      raw <- .yahoo_get(.YAHOO_SHANGRILA, "leagueStatsByTeam",
                        query = list(leagues = "ncaaf", season = season, count = count,
                                     leagueStructureId = league_structure))
      out <- .yahoo_bind(.yahoo_modern_rows(raw, "footballStats")) |>
        tibble::as_tibble() |>
        janitor::clean_names()
      if (nrow(out)) out[["season"]] <- season
      out <- make_cfbfastR_data(out, "Team season stats from Yahoo Sports (shangrila)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid arguments or no Yahoo team stats available!"))
    }
  )
  return(.attach_query_meta_auto(out))
}

#' **Get Yahoo Sports CFB legacy per-category player leaders**
#'
#' Flattens a legacy `seasonStatsFootball{Category}Ncaaf` query (one category per
#' call) into a wide player tibble.
#'
#' @param season (integer): Season year. Defaults to `most_recent_cfb_season()`.
#' @param category (character): One of `Passing`, `Rushing`, `Receiving`,
#'   `Defense`, `Kicking`, `Punting`, `Returns`. Defaults to `"Passing"`.
#' @param sort_stat (character): Required sort stat id (a `FootballStatId`, e.g.
#'   `"PASSING_YARDS"`). Defaults to `"PASSING_YARDS"`.
#' @param league_structure (character): Defaults to `"ncaaf.struct.div.1"`.
#' @param count (integer): Defaults to `200`.
#' @return A `cfbfastR`-tagged tibble: `player_id`, `display_name`, `team`,
#'   `team_abbreviation`, `season`, `category`, plus one column per `statId`.
#'
#' @keywords Stats Data
#' @importFrom janitor clean_names
#' @importFrom tibble as_tibble
#' @export
#' @family Yahoo CFB Functions
#' @examples
#' \donttest{
#'   try(yahoo_cfb_player_season_stats_legacy(season = 2024, category = "Rushing",
#'                                            sort_stat = "RUSHING_YARDS"))
#' }
yahoo_cfb_player_season_stats_legacy <- function(season = most_recent_cfb_season(), category = "Passing",
                                                 sort_stat = "PASSING_YARDS",
                                                 league_structure = "ncaaf.struct.div.1",
                                                 count = 200) {
  if (!category %in% .YAHOO_LEGACY_PLAYER_CATS) {
    stop(glue::glue("category must be one of: {paste(.YAHOO_LEGACY_PLAYER_CATS, collapse = ', ')}"))
  }
  out <- data.frame()
  tryCatch(
    expr = {
      raw <- .yahoo_get(.YAHOO_SHANGRILA, paste0("seasonStatsFootball", category, "Ncaaf"),
                        query = list(season = season, league = "ncaaf",
                                     leagueStructure = league_structure,
                                     count = count, sortStatId = sort_stat))
      out <- .yahoo_bind(.yahoo_legacy_rows(raw)) |>
        tibble::as_tibble() |>
        janitor::clean_names()
      if (nrow(out)) { out[["season"]] <- season; out[["category"]] <- category }
      out <- make_cfbfastR_data(out, "Legacy player season stats from Yahoo Sports (shangrila)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid arguments or no Yahoo legacy player stats available!"))
    }
  )
  return(.attach_query_meta_auto(out))
}

#' **Get Yahoo Sports CFB legacy per-category team stats**
#'
#' Flattens a legacy `seasonTeamStatsFootball{Category}` query into a wide team tibble.
#'
#' @param season (integer): Season year. Defaults to `most_recent_cfb_season()`.
#' @param category (character): One of `Passing`, `Rushing`, `Receiving`,
#'   `Defense`, `Kicking`, `Punting`, `Returns`, `Kickoffs`, `Offense`.
#'   Defaults to `"Passing"`.
#' @param sort_stat (character): Required sort stat id. Defaults to `"PASSING_YARDS"`.
#' @param league_structure (character): Defaults to `"ncaaf.struct.div.1"`.
#' @param count (integer): Defaults to `200`.
#' @return A `cfbfastR`-tagged tibble: `team`, `team_abbreviation`, `season`,
#'   `category`, plus one column per `statId`.
#'
#' @keywords Stats Data
#' @importFrom janitor clean_names
#' @importFrom tibble as_tibble
#' @export
#' @family Yahoo CFB Functions
#' @examples
#' \donttest{
#'   try(yahoo_cfb_team_season_stats_legacy(season = 2024, category = "Rushing",
#'                                          sort_stat = "RUSHING_YARDS"))
#' }
yahoo_cfb_team_season_stats_legacy <- function(season = most_recent_cfb_season(), category = "Passing",
                                               sort_stat = "PASSING_YARDS",
                                               league_structure = "ncaaf.struct.div.1",
                                               count = 200) {
  if (!category %in% .YAHOO_LEGACY_TEAM_CATS) {
    stop(glue::glue("category must be one of: {paste(.YAHOO_LEGACY_TEAM_CATS, collapse = ', ')}"))
  }
  out <- data.frame()
  tryCatch(
    expr = {
      raw <- .yahoo_get(.YAHOO_SHANGRILA, paste0("seasonTeamStatsFootball", category),
                        query = list(season = season, league = "ncaaf",
                                     leagueStructure = league_structure,
                                     count = count, sortStatId = sort_stat))
      out <- .yahoo_bind(.yahoo_legacy_rows(raw)) |>
        tibble::as_tibble() |>
        janitor::clean_names()
      if (nrow(out)) { out[["season"]] <- season; out[["category"]] <- category }
      out <- make_cfbfastR_data(out, "Legacy team season stats from Yahoo Sports (shangrila)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid arguments or no Yahoo legacy team stats available!"))
    }
  )
  return(.attach_query_meta_auto(out))
}

#' **Get Yahoo Sports college football scoreboard**
#'
#' Flattens the editorial `scoreboard` games map into one tibble (one row per
#' game). The full payload also embeds teams/leagues/odds maps.
#'
#' @param season (integer): Season year. Defaults to `most_recent_cfb_season()`.
#' @param week (integer): Schedule week. Defaults to `1`.
#' @param count (integer): Max games. Defaults to `500`.
#' @return A `cfbfastR`-tagged tibble with one row per game; columns are the
#'   Yahoo game fields (`gameid`, `home_team_id`, `away_team_id`,
#'   `total_home_points`, `total_away_points`, `status_type`, ...) plus `season`
#'   and `week`. Column set varies with game state.
#'
#' @keywords Schedule Data
#' @importFrom janitor clean_names
#' @importFrom tibble as_tibble
#' @export
#' @family Yahoo CFB Functions
#' @examples
#' \donttest{
#'   try(yahoo_cfb_scoreboard(season = 2024, week = 1))
#' }
yahoo_cfb_scoreboard <- function(season = most_recent_cfb_season(), week = 1, count = 500) {
  out <- data.frame()
  tryCatch(
    expr = {
      raw <- .yahoo_get(.YAHOO_EDITORIAL, "scoreboard",
                        query = list(leagues = "ncaaf", week = week, season = season,
                                     count = count, v = 2))
      out <- .yahoo_bind(.yahoo_map_rows(raw, "scoreboard", "games")) |>
        tibble::as_tibble() |>
        janitor::clean_names()
      if (nrow(out)) { out[["season"]] <- season; out[["week"]] <- week }
      out <- make_cfbfastR_data(out, "Scoreboard from Yahoo Sports (editorial)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid arguments or no Yahoo scoreboard available!"))
    }
  )
  return(.attach_query_meta_auto(out))
}

#' **Get Yahoo Sports college football boxscore (SCAFFOLD)**
#'
#' Returns the raw editorial `boxscore/{game_id}` JSON (as a nested list). The
#' boxscore uses a normalized decoder-dictionary schema
#' (`player_stats[playerId][variation][stat_type]` joined against `stat_types` /
#' `stat_categories`); full decoding is a follow-up.
#'
#' @param game_id (character, required): Dotted game id (e.g. `"ncaaf.g.202509200023"`).
#' @return The raw parsed JSON list (`service$boxscore`). TODO: decode to tibbles.
#'
#' @keywords Boxscore Data
#' @export
#' @family Yahoo CFB Functions
#' @examples
#' \donttest{
#'   try(yahoo_cfb_boxscore(game_id = "ncaaf.g.202509200023"))
#' }
yahoo_cfb_boxscore <- function(game_id) {
  raw <- NULL
  tryCatch(
    expr = {
      raw <- .yahoo_get(.YAHOO_EDITORIAL, paste0("boxscore/", game_id), query = list(v = 4))
      # TODO(scaffold): decode service$boxscore$player_stats via stat_types into tibbles.
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid game_id or no Yahoo boxscore available!"))
    }
  )
  return(raw)
}
