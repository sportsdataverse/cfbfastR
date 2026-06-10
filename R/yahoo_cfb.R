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
  if (!is.null(ent[["playerId"]])) {
    list(player_id = .yahoo_or(ent[["playerId"]], NA_character_),
         display_name = .yahoo_or(ent[["displayName"]], NA_character_),
         team = .yahoo_or(ent[["team"]][["displayName"]], NA_character_),
         team_abbreviation = .yahoo_or(ent[["team"]][["abbreviation"]], NA_character_))
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
#' @param season (integer, required): Season year (e.g. `2024`). Defaults to `2024`.
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
#' @examples
#' \donttest{
#'   try(yahoo_cfb_player_season_stats(season = 2024))
#' }
yahoo_cfb_player_season_stats <- function(season = 2024,
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
