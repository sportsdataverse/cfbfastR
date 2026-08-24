#' Fetch ESPN's play-by-play sidecar as a name + identity source
#'
#' @description One request to ESPN's CDN play-by-play payload, yielding the two
#'   things cfbfastR's own sources cannot supply. Ports the pair sdv-py reads
#'   from the same endpoint: `_download_athlete_lookup` (full athlete names) and
#'   `CFBPlayProcess.__boxscore_records` / `_parse_espn_player_box` (a second
#'   identity source).
#'
#' @details Why it is worth a request:
#'
#'   * **The core-v2 roster renders `displayName` in short form** (`"J.
#'     Mitchell"`), while ESPN's `participants[]` names -- and sdv-py -- use the
#'     full form (`"Jalen Mitchell"`). Matching short against full forces the id
#'     resolver onto its weaker initial+surname fallback tier, and leaves the
#'     emitted `*_player_name` columns diverged from the Python.
#'   * **The game roster resource 404s for a large share of games** -- 376 of 898
#'     in 2018, 142 of 706 in 2020. On those there is nothing to resolve against
#'     at all. The box score ships the same ESPN athlete-id namespace (measured:
#'     zero id conflicts on the overlap across 2004-2025), so the two compose.
#'
#'   The response carries them in two different places, which is easy to get
#'   wrong because the *archived* form of this payload (what `cfbfastR-cfb-raw`
#'   stores) is the unwrapped game package:
#'
#'   \describe{
#'     \item{`__gamepackage__$playerHash`}{athlete id -> full display name, for
#'       **every** athlete in the game including those with no stat line. This is
#'       the naming source.}
#'     \item{`gamepackageJSON$boxscore$players`}{per-team, per-category stat
#'       lines. Only athletes who recorded a stat, but it is the only one that
#'       carries `team_id`, which team-aware id matching needs.}
#'   }
#'
#'   Memoised by `game_id` (see `.espn_memoised_helpers` in `zzz.R`), so the two
#'   uses inside one `espn_cfb_pbp_v2()` call cost one request between them.
#'
#' @param game_id (*Integer* required): ESPN game identifier.
#' @return A list of two data frames, both possibly zero-row:
#' \describe{
#' \item{`names`}{`athlete_id` / `display_name` -- the naming lookup.}
#' \item{`records`}{`athlete_id` / `display_name` / `team_id` -- the identity
#'   records, shaped for `.pbp_attach_player_ids()`'s `roster` argument.}
#' }
#' Any failure degrades to two empty frames -- "no extra source", never an error.
#' @keywords internal
#' @importFrom rlang "%||%"
#' @importFrom httr2 request req_timeout req_retry req_perform resp_body_string
#' @noRd
.espn_cfb_pbp_sidecar <- function(game_id) {
  empty <- list(
    names   = data.frame(athlete_id = character(0), display_name = character(0),
                         stringsAsFactors = FALSE),
    records = data.frame(athlete_id = character(0), display_name = character(0),
                         team_id = character(0), stringsAsFactors = FALSE)
  )
  if (is.null(game_id)) return(empty)
  `%||%` <- rlang::`%||%`

  out <- empty
  tryCatch(
    expr = {
      url <- paste0(
        "https://cdn.espn.com/core/college-football/playbyplay?xhr=1&gameId=",
        game_id
      )
      # Through httr2, not `jsonlite::fromJSON(url)`: a bare URL connection has
      # no timeout and no retry, and espn_cfb_pbp_v2() issues this once per game
      # -- one stalled ESPN connection would hang a whole season sweep.
      #
      # Deliberately NO User-Agent. cdn.espn.com answers a spoofed browser UA
      # with HTTP 200 and a ZERO-BYTE body, which is worse than the 403
      # site.api returns: nothing raises and the parse silently yields nothing.
      # See tests/testthat/test-espn_http_headers.R.
      resp <- httr2::request(url) |>
        httr2::req_timeout(30) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform() |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        # simplifyVector = FALSE keeps the ragged statistics/athletes arrays as
        # lists; letting jsonlite simplify them collapses categories with
        # different key sets into a malformed frame.
        jsonlite::fromJSON(simplifyVector = FALSE)

      # --- naming: playerHash ---------------------------------------------
      ph <- (resp[["__gamepackage__"]] %||% list())[["playerHash"]] %||% list()
      if (length(ph)) {
        nm <- vapply(ph, function(e) {
          a <- (e[["json"]] %||% list())[["athlete"]] %||% list()
          as.character(a[["displayName"]] %||% a[["fullName"]] %||% NA)
        }, character(1))
        keep <- !is.na(nm) & nzchar(nm)
        if (any(keep)) {
          out$names <- data.frame(athlete_id = names(ph)[keep],
                                  display_name = unname(nm[keep]),
                                  row.names = NULL, stringsAsFactors = FALSE)
        }
      }

      # --- identity: boxscore ---------------------------------------------
      # Live responses nest the game package under `gamepackageJSON`; the
      # archived form in cfbfastR-cfb-raw is already unwrapped.
      pkg <- resp[["gamepackageJSON"]] %||% resp
      players <- (pkg[["boxscore"]] %||% list())[["players"]] %||% list()

      ids <- character(0); nms <- character(0); tids <- character(0)
      for (pg in players) {
        tid <- as.character((pg[["team"]] %||% list())[["id"]] %||% NA)
        for (cat in pg[["statistics"]] %||% list()) {
          for (a in cat[["athletes"]] %||% list()) {
            ath <- a[["athlete"]] %||% list()
            aid <- as.character(ath[["id"]] %||% NA)
            anm <- as.character(ath[["displayName"]] %||% NA)
            if (is.na(aid) || !nzchar(aid) || is.na(anm) || !nzchar(anm)) next
            ids <- c(ids, aid); nms <- c(nms, anm); tids <- c(tids, tid)
          }
        }
      }
      if (length(ids)) {
        # An athlete appears once per stat category (passing, rushing, ...).
        dup <- duplicated(ids)
        out$records <- data.frame(athlete_id = ids[!dup],
                                  display_name = nms[!dup],
                                  team_id = tids[!dup],
                                  row.names = NULL, stringsAsFactors = FALSE)
      }
    },
    error = function(e) {
      # Degrade, but say so. Silently returning empty frames here is how the
      # site.api 403 went unnoticed: every consumer just saw NA.
      cli::cli_alert_warning(
        "ESPN play-by-play sidecar unavailable for game {game_id}:
         {conditionMessage(e)}. Falling back to roster-only names and ids."
      )
    },
    warning = function(w) {}
  )
  out
}

#' Rewrite participant names to their full form using an id -> name lookup
#'
#' @description ESPN's `participants[]` names on the core-v2 frame are resolved
#'   through the game roster, whose `displayName` is abbreviated. Every
#'   participant column ships alongside its `{type}_player_id`, so the full name
#'   can be substituted by id without another request.
#'
#' @param participants_df (*data.frame*): `play_id` plus `{type}_player_name`
#'   columns, and the matching `{type}_player_id` columns.
#' @param lookup (*data.frame*): `athlete_id` / `display_name`, from
#'   `.espn_cfb_pbp_sidecar()$names`.
#' @return `participants_df` with names replaced wherever the id resolves. An
#'   id the lookup misses keeps its short name rather than becoming `NA` -- a
#'   worse name still beats no name.
#' @keywords internal
#' @noRd
.espn_cfb_expand_participant_names <- function(participants_df, lookup) {
  if (!is.data.frame(lookup) || !nrow(lookup) ||
      !is.data.frame(participants_df) || !nrow(participants_df)) {
    return(participants_df)
  }
  full <- stats::setNames(as.character(lookup$display_name),
                          as.character(lookup$athlete_id))

  for (nm_col in grep("_player_name$", names(participants_df), value = TRUE)) {
    id_col <- sub("_player_name$", "_player_id", nm_col)
    if (!id_col %in% names(participants_df)) next
    hit <- unname(full[as.character(participants_df[[id_col]])])
    participants_df[[nm_col]] <- ifelse(
      is.na(hit), as.character(participants_df[[nm_col]]), hit
    )
  }
  participants_df
}
