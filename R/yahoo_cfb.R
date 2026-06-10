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
