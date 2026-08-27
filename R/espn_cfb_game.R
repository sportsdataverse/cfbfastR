#' @name espn_cfb_game
#' @aliases espn_cfb_game game plays leaders
#' @title
#' **ESPN College Football Game Endpoint Overview**
#' @description
#'
#' * `espn_cfb_pbp()`: Get ESPN college football PBP data (legacy site-v2).
#' * `espn_cfb_pbp_v2()`: Get ESPN College Football Play-by-Play (core-v2) -- core-v2-sourced successor to `espn_cfb_pbp()` with optional EPA/WPA modeling.
#' * `espn_cfb_unnest_plays()`: Turn an `espn_cfb_game_drives()` result with a `plays` list-column into a flat one-row-per-play table.
#' * `espn_cfb_game_broadcasts()`: Get the broadcast / streaming outlets carrying a single college football game.
#' * `espn_cfb_game_drive_plays()`: Get the play-by-play for a single drive of a college football game -- one row per play, scoped to one drive.
#' * `espn_cfb_game_drives()`: Get the per-game drive log for a single college football game -- one row per drive.
#' * `espn_cfb_game_leaders()`: Get the per-game statistical leaders for a single college football game -- one row per leader within each statistical category.
#' * `espn_cfb_game_odds()`: Get the sportsbook betting lines (spread, over/under, moneyline) for a single college football game -- one row per provider.
#' * `espn_cfb_game_pbp()`: Get the full core-v2 play-by-play feed for a single college football game -- one row per play.
#' * `espn_cfb_game_play()`: Get the full detail object for a single play of a college football game.
#' * `espn_cfb_game_player_box()`: Get the full per-player box score for both teams in a single college football game, in long format.
#' * `espn_cfb_game_player_statistics()`: Get one athlete's box-score line for a single college football game -- one row per stat, in long format.
#' * `espn_cfb_game_powerindex()`: Get ESPN's Football Power Index (FPI) matchup projections for both teams in a single college football game.
#' * `espn_cfb_game_predictor()`: Get ESPN's pre-game matchup predictor (FPI game projection) for a single college football game.
#' * `espn_cfb_game_probabilities()`: Get ESPN's play-by-play win-probability series for a single college football game.
#' * `espn_cfb_game_situation()`: Get the current (or final) game situation for a single college football game -- down, distance, yard line, red-zone flag, timeouts.
#' * `espn_cfb_game_status()`: Get the competition status for a single college football game -- clock, period, and the status type/state.
#' * `espn_cfb_game_team_leaders()`: Get each team's statistical leaders (passing, rushing, receiving, ...) for a single college football game.
#' * `espn_cfb_game_team_linescores()`: Get the quarter-by-quarter linescores for both teams in a single college football game.
#' * `espn_cfb_game_team_records()`: Get each team's win-loss records (overall, home, road, conference) as they stood at the time of a single college football game.
#' * `espn_cfb_game_team_roster()`: Get the game-day roster for both teams in a single college football game.
#' * `espn_cfb_game_team_statistics()`: Get the full team box-score statistics for both teams in a single college football game, in long format.
#' * `espn_cfb_game_teams()`: Get the two teams (home and away) for a single college football game.
#'
#' @details
#' ## **Get ESPN college football PBP data (legacy)**
#'
#' ```r
#' espn_cfb_pbp(game_id = 401282614, epa_wpa = TRUE)
#' ```
#'
#' ## **Get ESPN College Football Play-by-Play (core-v2)**
#'
#' ```r
#' espn_cfb_pbp_v2(game_id = 401628339, epa_wpa = TRUE)
#' ```
#'
#' ## **Unnest ESPN CFB drive plays into a flat play-by-play table**
#'
#' ```r
#' espn_cfb_unnest_plays(espn_cfb_game_drives(401628339, plays = "list"))
#' ```
#'
#' ## **ESPN College Football Game Broadcasts**
#'
#' ```r
#' espn_cfb_game_broadcasts(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Drive Plays**
#'
#' ```r
#' espn_cfb_game_drive_plays(game_id = 401628339, drive_id = 4016283391)
#' ```
#'
#' ## **ESPN College Football Game Drives**
#'
#' ```r
#' espn_cfb_game_drives(game_id = 401628339)
#' espn_cfb_game_drives(game_id = 401628339, plays = "expand")
#' ```
#'
#' ## **ESPN College Football Game Leaders**
#'
#' ```r
#' espn_cfb_game_leaders(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Odds**
#'
#' ```r
#' espn_cfb_game_odds(game_id = 401628339)
#' espn_cfb_game_odds(game_id = 401628339, line_history = TRUE)
#' ```
#'
#' ## **ESPN College Football Game Plays (Core-v2 Play-by-Play)**
#'
#' ```r
#' espn_cfb_game_pbp(game_id = 401628339)
#' espn_cfb_game_pbp(game_id = 401628339, participants = "wide")
#' ```
#'
#' ## **ESPN College Football Game Play (Single Play Detail)**
#'
#' ```r
#' espn_cfb_game_play(game_id = 401628339, play_id = "401628339101927401")
#' ```
#'
#' ## **ESPN College Football Game Player Box Score**
#'
#' ```r
#' espn_cfb_game_player_box(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Player Statistics (Single Athlete)**
#'
#' ```r
#' espn_cfb_game_player_statistics(game_id = 401628339, athlete_id = 4429105)
#' ```
#'
#' ## **ESPN College Football Game Power Index (Matchup FPI)**
#'
#' ```r
#' espn_cfb_game_powerindex(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Predictor (BPI Matchup Predictor)**
#'
#' ```r
#' espn_cfb_game_predictor(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Win Probabilities**
#'
#' ```r
#' espn_cfb_game_probabilities(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Situation**
#'
#' ```r
#' espn_cfb_game_situation(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Status**
#'
#' ```r
#' espn_cfb_game_status(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Team Leaders**
#'
#' ```r
#' espn_cfb_game_team_leaders(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Team Linescores**
#'
#' ```r
#' espn_cfb_game_team_linescores(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Team Records**
#'
#' ```r
#' espn_cfb_game_team_records(game_id = 401628339)
#' espn_cfb_game_team_records(game_id = 401628339, detail = TRUE)
#' ```
#'
#' ## **ESPN College Football Game Team Roster**
#'
#' ```r
#' espn_cfb_game_team_roster(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Team Statistics**
#'
#' ```r
#' espn_cfb_game_team_statistics(game_id = 401628339)
#' ```
#'
#' ## **ESPN College Football Game Teams**
#'
#' ```r
#' espn_cfb_game_teams(game_id = 401628339)
#' espn_cfb_game_teams(game_id = 401628339, format = "wide")
#' ```
#'
NULL


# espn_cfb_game.R -- ESPN college football game (event) detail wrappers
# Consolidated family file. Each function keeps its own
# roxygen block; edit the block above the function you want.

# Static ESPN catalog lookups (team, position) are fetched by the plain
# helpers below. Caching is applied externally in `.onLoad()` (R/zzz.R),
# which memoises these helpers with `cachem` + `memoise` -- mirroring the
# nflreadr caching mechanism. Users can force a refresh with
# `espn_cfb_clear_cache()`.

#' Build an ESPN CFB position-id detail lookup
#'
#' Internal helper. Calls [espn_cfb_positions()] once and folds the result
#' into a named list keyed by `position_id`, each element a list of `name`
#' / `display_name` / `abbreviation` / `leaf` / `parent_id`. A catalog
#' failure degrades gracefully to an empty list (callers resolve to `NA`),
#' so a transient ESPN outage never errors the wrapper that requested
#' position detail. Sharing this helper lets a single wrapper call enrich
#' its output with one catalog fetch.
#'
#' This is a plain fetch-and-return helper. Caching is layered on top in
#' `.onLoad()` (R/zzz.R), which memoises this function with `cachem` +
#' `memoise` (24h TTL) so the catalog is fetched once and reused for the
#' lifetime of the cache. Call [espn_cfb_clear_cache()] to force a refresh.
#'
#' @return A named list keyed by position id (possibly empty).
#' @keywords internal
#' @noRd
.espn_cfb_position_lookup <- function() {
  `%||%` <- rlang::`%||%`
  pos_lk <- list()
  tryCatch(
    expr = {
      pos <- espn_cfb_positions()
      if (is.data.frame(pos) && nrow(pos) > 0) {
        for (i in seq_len(nrow(pos))) {
          pid <- as.character(pos$position_id[i])
          if (is.na(pid) || pid == "NA" || pid == "") next
          pos_lk[[pid]] <- list(
            name         = as.character(pos$name[i] %||% NA),
            display_name = as.character(pos$display_name[i] %||% NA),
            abbreviation = as.character(pos$abbreviation[i] %||% NA),
            leaf         = pos$leaf[i],
            parent_id    = as.character(pos$parent_id[i] %||% NA)
          )
        }
      }
    },
    error = function(e) {},
    warning = function(w) {}
  )
  pos_lk
}


#' Join ESPN CFB position detail onto a frame carrying `position_id`
#'
#' Internal helper. Given a data frame with a `position_id` column and a
#' position lookup from `.espn_cfb_position_lookup()`, appends the five
#' position-detail columns -- `position_name`, `position_display_name`,
#' `position_abbreviation`, `position_leaf`, `position_parent_id`. Rows
#' whose `position_id` is missing or unmatched receive `NA`. If the lookup
#' is empty (catalog fetch failed), every appended column is `NA` and the
#' wrapper still returns its base output unharmed.
#'
#' @param df Data frame carrying a `position_id` column.
#' @param pos_lk Position lookup from `.espn_cfb_position_lookup()`.
#' @return `df` with the five `position_*` detail columns appended.
#' @keywords internal
#' @noRd
.espn_cfb_attach_position_detail <- function(df, pos_lk = list()) {
  if (!is.data.frame(df) || nrow(df) == 0 ||
      !("position_id" %in% colnames(df))) {
    return(df)
  }
  ids <- as.character(df[["position_id"]])
  pull <- function(field) {
    vapply(ids, function(pid) {
      if (is.null(pid) || is.na(pid) || pid == "" || pid == "NA") {
        return(NA_character_)
      }
      e <- pos_lk[[pid]]
      if (is.null(e)) return(NA_character_)
      v <- e[[field]]
      if (is.null(v)) NA_character_ else as.character(v)
    }, character(1), USE.NAMES = FALSE)
  }
  df[["position_name"]]         <- pull("name")
  df[["position_display_name"]] <- pull("display_name")
  df[["position_abbreviation"]] <- pull("abbreviation")
  leaf_chr <- pull("leaf")
  df[["position_leaf"]]         <- as.logical(leaf_chr)
  df[["position_parent_id"]]    <- pull("parent_id")
  df
}


#' Build an ESPN CFB team-id detail lookup
#'
#' Internal helper. Calls [espn_cfb_teams()] once and folds the result into
#' a named list keyed by `team_id`, each element a list of `name` /
#' `abbreviation` / `location` / `display_name` / `short_display_name` /
#' `nickname` / `color` / `alternate_color` / `logo_href` /
#' `logo_dark_href` -- every column [espn_cfb_teams()] returns except the
#' join key `team_id` and the intentionally-omitted `uid`, `slug`,
#' `is_active`, `is_all_star`. A catalog failure degrades gracefully to an
#' empty list (callers resolve to `NA`), so a transient ESPN outage never errors
#' the wrapper that requested team detail. Sharing this helper lets a single
#' wrapper call enrich its output with one catalog fetch -- mirroring the
#' position-detail pair `.espn_cfb_position_lookup()` /
#' `.espn_cfb_attach_position_detail()`.
#'
#' This is a plain fetch-and-return helper. Caching is layered on top in
#' `.onLoad()` (R/zzz.R), which memoises this function with `cachem` +
#' `memoise` (24h TTL) so the catalog is fetched once and reused for the
#' lifetime of the cache. Call [espn_cfb_clear_cache()] to force a refresh.
#'
#' @return A named list keyed by team id (possibly empty).
#' @keywords internal
#' @noRd
.espn_cfb_team_lookup <- function() {
  `%||%` <- rlang::`%||%`
  team_lk <- list()
  tryCatch(
    expr = {
      teams <- espn_cfb_teams()
      if (is.data.frame(teams) && nrow(teams) > 0) {
        for (i in seq_len(nrow(teams))) {
          tid <- as.character(teams$team_id[i])
          if (is.na(tid) || tid == "NA" || tid == "") next
          team_lk[[tid]] <- list(
            name               = as.character(teams$name[i] %||% NA),
            abbreviation       = as.character(teams$abbreviation[i] %||% NA),
            location           = as.character(teams$location[i] %||% NA),
            display_name       = as.character(teams$display_name[i] %||% NA),
            short_display_name = as.character(
              teams$short_display_name[i] %||% NA
            ),
            nickname           = as.character(teams$nickname[i] %||% NA),
            color              = as.character(teams$color[i] %||% NA),
            alternate_color    = as.character(
              teams$alternate_color[i] %||% NA
            ),
            logo_href          = as.character(teams$logo_href[i] %||% NA),
            logo_dark_href     = as.character(
              teams$logo_dark_href[i] %||% NA
            )
          )
        }
      }
    },
    error = function(e) {},
    warning = function(w) {}
  )
  team_lk
}


#' **Clear the cfbfastR ESPN catalog cache**
#'
#' @title
#' **Clear the cfbfastR ESPN catalog cache**
#' @description
#' The ESPN college football game wrappers enrich their output with team
#' and position detail drawn from two static catalogs --
#' [espn_cfb_teams()] (~750 teams) and [espn_cfb_positions()] (~74
#' positions). Because those catalogs do not change often, the internal
#' lookups built from them are memoised with `cachem` + `memoise`, so a
#' loop over many games does not re-hit ESPN for the catalogs on every
#' call.
#'
#' `espn_cfb_clear_cache()` forgets those memoised lookups. The next
#' wrapper call that needs a catalog will fetch a fresh copy from ESPN.
#' Use it when you want to force a refresh -- for example after a
#' long-running session, or when debugging.
#'
#' @details
#' Caching is configured at package load via two `options()`:
#'
#' * `cfbfastR.cache` -- cache backend. One of `"memory"` (default;
#'   in-memory `cachem::cache_mem()`, cleared when the session ends),
#'   `"filesystem"` (persistent on-disk `cachem::cache_disk()` under
#'   [tools::R_user_dir()]), or `"off"` (no memoisation -- every catalog
#'   fetch hits ESPN).
#' * `cfbfastR.cache_duration` -- cache time-to-live in seconds.
#'   Defaults to `86400` (24 hours).
#'
#'
#' Set these with [options()] *before* the package is loaded, e.g.
#' `options(cfbfastR.cache = "filesystem")`. When `cfbfastR.cache` is
#' `"off"`, the catalog helpers are never memoised and
#' `espn_cfb_clear_cache()` is a no-op (it still returns invisibly without
#' error).
#'
#' @return Invisibly returns `NULL`. Called for its side effect of
#'   forgetting the memoised catalog lookups.
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   # Force the team / position catalogs to be re-fetched on next use
#'   espn_cfb_clear_cache()
#' }
espn_cfb_clear_cache <- function() {
  # No-op when memoise isn't installed (Suggests) -- nothing was memoised.
  if (!requireNamespace("memoise", quietly = TRUE)) {
    return(invisible(NULL))
  }
  ns <- rlang::ns_env("cfbfastR")
  for (fn in .espn_memoised_helpers) {
    helper <- tryCatch(get(fn, envir = ns), error = function(e) NULL)
    # memoise::forget() errors on non-memoised functions (cache "off"),
    # so only forget helpers that are actually memoised.
    if (!is.null(helper) && memoise::is.memoised(helper)) {
      memoise::forget(helper)
    }
  }
  invisible(NULL)
}


#' Join ESPN CFB team detail onto every team-id column in a frame
#'
#' Internal helper. Scans `df` for every column that is a team identifier --
#' a column named exactly `team_id`, OR one ending in `_team_id` (e.g.
#' `home_team_id`, `away_team_id`, `start_team_id`, `end_team_id`,
#' `offense_team_id`, `defense_team_id`, `leader_team_id`,
#' `winner_team_id`, `{type}_player_team_id`), OR the `competitor_id`
#' column. For each such column `X_id` (or `X` for `competitor_id`) it
#' inserts the sibling columns `X_name`, `X_abbreviation`, `X_location`,
#' `X_display_name`, `X_short_display_name`, `X_nickname`, `X_color`,
#' `X_alternate_color`, `X_logo_href`, `X_logo_dark_href` -- the ten
#' friendly columns covering every [espn_cfb_teams()] field except the
#' join key `team_id` and the intentionally-omitted `uid`, `slug`,
#' `is_active`, `is_all_star` -- immediately after it, joined from the team
#' lookup built by
#' `.espn_cfb_team_lookup()`. Rows whose id is missing or unmatched receive
#' `NA`. If the lookup is empty (catalog fetch failed) every appended
#' column is `NA` and the wrapper still returns its base output unharmed.
#' List-columns and non-id columns are left untouched.
#'
#' @param df Data frame to enrich.
#' @param team_lookup Team lookup from `.espn_cfb_team_lookup()`.
#' @return `df` with friendly team columns inserted after each team-id
#'   column.
#' @keywords internal
#' @noRd
.espn_cfb_attach_team_detail <- function(df, team_lookup = list()) {
  if (!is.data.frame(df) || nrow(df) == 0 || ncol(df) == 0) {
    return(df)
  }

  cols <- colnames(df)
  # A column is a team-id column when its name is exactly `team_id`, ends in
  # `_team_id`, or is exactly `competitor_id`. It must also be an atomic
  # (non-list) column -- list-columns are never ids.
  is_team_id_col <- function(nm) {
    if (is.list(df[[nm]])) return(FALSE)
    nm == "team_id" || grepl("_team_id$", nm) || nm == "competitor_id"
  }
  id_cols <- cols[vapply(cols, is_team_id_col, logical(1))]
  if (length(id_cols) == 0L) {
    return(df)
  }

  # The friendly fields appended after each id column, in order.
  fields <- c("name", "abbreviation", "location", "display_name",
              "short_display_name", "nickname", "color",
              "alternate_color", "logo_href", "logo_dark_href")

  # Stem for the sibling column names: drop a trailing `_id` (so
  # `home_team_id` -> `home_team`, `competitor_id` -> `competitor`,
  # bare `team_id` -> `team`).
  stem_of <- function(nm) sub("_id$", "", nm)

  pull <- function(ids, field) {
    vapply(as.character(ids), function(tid) {
      if (is.null(tid) || is.na(tid) || tid == "" || tid == "NA") {
        return(NA_character_)
      }
      e <- team_lookup[[tid]]
      if (is.null(e)) return(NA_character_)
      v <- e[[field]]
      if (is.null(v)) NA_character_ else as.character(v)
    }, character(1), USE.NAMES = FALSE)
  }

  # Rebuild the frame column-by-column, inserting the friendly siblings
  # immediately after every team-id column. Building a fresh list and
  # re-assembling preserves column order deterministically.
  out <- list()
  for (nm in cols) {
    out[[nm]] <- df[[nm]]
    if (nm %in% id_cols) {
      stem <- stem_of(nm)
      ids  <- df[[nm]]
      for (field in fields) {
        out[[paste0(stem, "_", field)]] <- pull(ids, field)
      }
    }
  }
  dplyr::as_tibble(out)
}


#' Fetch the ESPN CFB game roster as an athlete-id lookup
#'
#' Internal helper. Calls [espn_cfb_game_team_roster()] once and folds the
#' result into a named list keyed by `athlete_id`, each element a list of
#' `name` / `jersey` / `position` / `team_id` / `position_abbreviation` /
#' `position_name`. A roster failure degrades gracefully to an empty list
#' (callers resolve to `NA`). Sharing this helper lets a single wrapper
#' call reuse one roster fetch across both the `participants` flattening
#' and the `participants_list` list-column. When `position_detail = TRUE`
#' the position catalog ([espn_cfb_positions()]) is fetched once and the
#' position abbreviation / name are joined onto every roster entry so
#' participants `"wide"` output can carry position detail.
#'
#' @param game_id ESPN game identifier.
#' @param position_detail When `TRUE`, enrich each entry with
#'   `position_abbreviation` / `position_name` from the position catalog.
#' @return A named list keyed by athlete id (possibly empty).
#' @keywords internal
#' @noRd
.espn_cfb_participant_roster <- function(game_id, position_detail = FALSE) {
  `%||%` <- rlang::`%||%`
  roster_lk <- list()
  pos_lk <- if (isTRUE(position_detail)) {
    .espn_cfb_position_lookup()
  } else {
    list()
  }
  tryCatch(
    expr = {
      # position_detail = FALSE here -- this helper does its own catalog
      # enrichment from pos_lk, so the roster wrapper's join is redundant.
      # team_detail = FALSE -- the roster wrapper's team-catalog join is
      # not needed for the athlete-id lookup this helper builds.
      ros <- espn_cfb_game_team_roster(game_id, position_detail = FALSE,
                                       team_detail = FALSE)
      if (is.data.frame(ros) && nrow(ros) > 0) {
        for (i in seq_len(nrow(ros))) {
          aid <- as.character(ros$athlete_id[i])
          if (is.na(aid) || aid == "NA" || aid == "") next
          pos_id <- as.character(ros$position_id[i] %||% NA)
          pos_e <- if (!is.na(pos_id) && pos_id != "" &&
                       pos_id != "NA") {
            pos_lk[[pos_id]]
          } else {
            NULL
          }
          roster_lk[[aid]] <- list(
            name                 = as.character(ros$display_name[i] %||% NA),
            jersey               = as.character(ros$jersey[i] %||% NA),
            position             = pos_id,
            team_id              = as.character(ros$team_id[i] %||% NA),
            position_abbreviation = if (is.null(pos_e)) {
              NA_character_
            } else {
              as.character(pos_e[["abbreviation"]] %||% NA)
            },
            position_name        = if (is.null(pos_e)) {
              NA_character_
            } else {
              as.character(pos_e[["name"]] %||% NA)
            }
          )
        }
      }
    },
    error = function(e) {},
    warning = function(w) {}
  )
  roster_lk
}

#' Reshape the participant roster lookup into an id-resolution frame
#'
#' @description `.pbp_attach_player_ids()` wants a roster as a data frame of
#'   `athlete_id` / `display_name` / `team_id`; `.espn_cfb_participant_roster()`
#'   holds the same three fields as an athlete-id-keyed list. This is the
#'   adapter between them, and it deliberately reuses that helper rather than
#'   calling [espn_cfb_game_team_roster()] again -- the helper is memoised, so
#'   going through it turns what would be a second roster request per game into
#'   a cache hit.
#'
#' @param game_id ESPN game identifier.
#' @param position_detail Passed straight through. It must match the value the
#'   surrounding wrapper already used for this `game_id`, or the memoise key
#'   misses and the saving is lost.
#' @return A data frame with `athlete_id`, `display_name` and `team_id`; zero
#'   rows when the roster is unavailable (ESPN 404s it for a large share of
#'   games), which the id resolver treats as "no roster".
#' @keywords internal
#' @noRd
.espn_cfb_roster_frame <- function(game_id, position_detail = FALSE) {
  lk <- .espn_cfb_participant_roster(game_id, position_detail = position_detail)
  if (!length(lk)) {
    return(data.frame(athlete_id = character(0), display_name = character(0),
                      team_id = character(0), stringsAsFactors = FALSE))
  }
  data.frame(
    athlete_id   = names(lk),
    display_name = vapply(lk, function(e) as.character(e$name %||% NA), character(1)),
    team_id      = vapply(lk, function(e) as.character(e$team_id %||% NA), character(1)),
    row.names    = NULL,
    stringsAsFactors = FALSE
  )
}


#' Attach a per-play `participants` list-column to an ESPN CFB plays frame
#'
#' Internal helper shared by [espn_cfb_game_pbp()],
#' [espn_cfb_game_drive_plays()], and [espn_cfb_game_play()]. Given the
#' already-parsed plays frame and the matching list of raw play objects, it
#' appends a single list-column named `participants`: each cell holds that
#' play's full participant detail as a tibble, one row per participant,
#' with `participant_index`, `type` (snake_cased), `athlete_id`,
#' `athlete_name` (roster-joined), `order`, `position_id`, and the
#' participant's `stats[]` flattened into named columns. A play with no
#' participants gets an empty (0-row) tibble, never `NULL`. This composes
#' with -- and is independent of -- the `participants` flattening done by
#' `.espn_cfb_attach_participants()`.
#'
#' @param plays_df Parsed plays data frame (one row per play).
#' @param raw_plays List of raw play objects, parallel to `plays_df` rows.
#' @param roster_lk Pre-fetched roster lookup from
#'   `.espn_cfb_participant_roster()`.
#' @return `plays_df` with a `participants` list-column appended.
#' @keywords internal
#' @noRd
.espn_cfb_attach_participants_list <- function(plays_df, raw_plays,
                                               roster_lk = list()) {
  `%||%` <- rlang::`%||%`

  lk_name <- function(aid) {
    if (is.null(aid) || is.na(aid)) return(NA_character_)
    e <- roster_lk[[as.character(aid)]]
    if (is.null(e)) return(NA_character_)
    e[["name"]] %||% NA_character_
  }

  snake <- function(x) {
    if (is.null(x) || is.na(x) || x == "") return(NA_character_)
    janitor::make_clean_names(x)
  }

  # Build one 0+-row tibble of participant detail for a single raw play.
  build_cell <- function(it) {
    parts <- it[["participants"]] %||% list()
    if (length(parts) == 0L) {
      return(dplyr::tibble(
        participant_index = integer(0),
        type              = character(0),
        athlete_id        = character(0),
        athlete_name      = character(0),
        order             = integer(0),
        position_id       = character(0)
      ))
    }
    prows <- list()
    for (idx in seq_along(parts)) {
      pp <- parts[[idx]]
      a_ref <- if (is.list(pp[["athlete"]])) {
        pp[["athlete"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      a_id <- if (!is.na(a_ref)) {
        sub(".*/athletes/([0-9]+).*", "\\1", a_ref)
      } else {
        NA_character_
      }
      p_ref <- if (is.list(pp[["position"]])) {
        pp[["position"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      p_id <- if (!is.na(p_ref)) {
        sub(".*/positions/([0-9]+).*", "\\1", p_ref)
      } else {
        NA_character_
      }
      prow <- data.frame(
        participant_index = as.integer(idx),
        type              = snake(as.character(pp[["type"]] %||% NA)),
        athlete_id        = a_id,
        athlete_name      = lk_name(a_id),
        order             = suppressWarnings(as.integer(pp[["order"]] %||% NA)),
        position_id       = p_id,
        stringsAsFactors  = FALSE
      )
      for (s in pp[["stats"]] %||% list()) {
        nm <- s[["name"]]
        if (is.null(nm) || is.na(nm) || nm == "") next
        prow[[as.character(nm)]] <-
          suppressWarnings(as.numeric(s[["value"]] %||% NA))
      }
      prows[[length(prows) + 1L]] <- prow
    }
    # bind_rows NA-fills participants whose stat sets differ.
    dplyr::as_tibble(dplyr::bind_rows(prows))
  }

  cells <- lapply(raw_plays, build_cell)
  plays_df[["participants"]] <- cells
  plays_df
}


#' Attach a per-play `team_participants` list-column to an ESPN CFB plays frame
#'
#' Internal helper shared by [espn_cfb_game_pbp()],
#' [espn_cfb_game_drive_plays()], and [espn_cfb_game_play()]. ESPN ships a
#' `teamParticipants[]` array on every play -- the team(s) credited on the
#' play, each carrying an `id`, an `order`, a `type` (e.g. `offense` /
#' `defense`), and a `team{$ref}`. Variable-length, so it is preserved as a
#' single list-column named `team_participants`: each cell holds that play's
#' team-participant detail as a tibble, one row per team participant, with
#' `team_participant_index`, `team_id`, `team_ref`, `order`, and `type`. A
#' play with no team participants gets an empty (0-row) tibble, never `NULL`.
#'
#' @param plays_df Parsed plays data frame (one row per play).
#' @param raw_plays List of raw play objects, parallel to `plays_df` rows.
#' @return `plays_df` with a `team_participants` list-column appended.
#' @keywords internal
#' @noRd
.espn_cfb_attach_team_participants_list <- function(plays_df, raw_plays) {
  `%||%` <- rlang::`%||%`

  build_cell <- function(it) {
    parts <- it[["teamParticipants"]] %||% list()
    if (length(parts) == 0L) {
      return(dplyr::tibble(
        team_participant_index = integer(0),
        team_id                = character(0),
        team_ref               = character(0),
        order                  = integer(0),
        type                   = character(0)
      ))
    }
    prows <- list()
    for (idx in seq_along(parts)) {
      tp <- parts[[idx]]
      t_ref <- if (is.list(tp[["team"]])) {
        tp[["team"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      t_id <- if (!is.na(t_ref)) {
        sub(".*/teams/([0-9]+).*", "\\1", t_ref)
      } else {
        as.character(tp[["id"]] %||% NA)
      }
      prows[[length(prows) + 1L]] <- data.frame(
        team_participant_index = as.integer(idx),
        team_id                = t_id,
        team_ref               = t_ref,
        order                  = suppressWarnings(as.integer(tp[["order"]] %||% NA)),
        type                   = as.character(tp[["type"]] %||% NA),
        stringsAsFactors       = FALSE
      )
    }
    dplyr::as_tibble(dplyr::bind_rows(prows))
  }

  plays_df[["team_participants"]] <- lapply(raw_plays, build_cell)
  plays_df
}


#' Attach type-keyed `teamParticipants[]` columns to an ESPN CFB plays frame
#'
#' Internal helper shared by [espn_cfb_game_pbp()],
#' [espn_cfb_game_drive_plays()], and [espn_cfb_game_play()]. Given the
#' already-parsed plays frame and the matching list of raw play objects,
#' it appends type-keyed columns -- one set per `teamParticipants[]` `type`
#' that appears anywhere in the game. ESPN's `teamParticipants[]` entries
#' each carry a `type` (e.g. `offense` / `defense`), an `order`, and a
#' `team{$ref}`. For every type the appended columns are
#' `{type}_team_id`, `{type}_team_order`, and `{type}_team_ref` -- the
#' first occurrence of that type on the play. `type` is snake_cased
#' (ESPN ships camelCase). This is the wide counterpart of
#' `.espn_cfb_attach_team_participants_list()` and composes with it.
#'
#' @param plays_df Parsed plays data frame (one row per play).
#' @param raw_plays List of raw play objects, parallel to `plays_df` rows.
#' @return `plays_df` with type-keyed `{type}_team_*` columns appended.
#' @keywords internal
#' @noRd
.espn_cfb_attach_team_participants <- function(plays_df, raw_plays) {
  `%||%` <- rlang::`%||%`

  snake <- function(x) {
    if (is.null(x) || is.na(x) || x == "") return(NA_character_)
    janitor::make_clean_names(x)
  }

  # Normalise one play's teamParticipants[] into a list of typed rows.
  parse_tp <- function(it) {
    parts <- it[["teamParticipants"]] %||% list()
    out <- list()
    for (idx in seq_along(parts)) {
      tp <- parts[[idx]]
      t_ref <- if (is.list(tp[["team"]])) {
        tp[["team"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      t_id <- if (!is.na(t_ref)) {
        sub(".*/teams/([0-9]+).*", "\\1", t_ref)
      } else {
        as.character(tp[["id"]] %||% NA)
      }
      out[[length(out) + 1L]] <- list(
        type     = snake(as.character(tp[["type"]] %||% NA)),
        team_id  = t_id,
        team_ref = t_ref,
        order    = suppressWarnings(as.integer(tp[["order"]] %||% NA))
      )
    }
    out
  }

  parsed <- lapply(raw_plays, parse_tp)

  # Discover every team-participant type present, in first-seen order.
  type_order <- character(0)
  for (pl in parsed) {
    for (tp in pl) {
      ty <- tp$type
      if (!is.na(ty) && !(ty %in% type_order)) {
        type_order <- c(type_order, ty)
      }
    }
  }

  if (length(type_order) == 0L) return(plays_df)

  n <- nrow(plays_df)
  add <- list()
  for (ty in type_order) {
    add[[paste0(ty, "_team_id")]]    <- rep(NA_character_, n)
    add[[paste0(ty, "_team_order")]] <- rep(NA_integer_, n)
    add[[paste0(ty, "_team_ref")]]   <- rep(NA_character_, n)
  }

  for (r in seq_len(n)) {
    pl <- parsed[[r]]
    if (length(pl) == 0L) next
    seen <- character(0)
    for (tp in pl) {
      ty <- tp$type
      if (is.na(ty) || ty %in% seen) next
      seen <- c(seen, ty)
      add[[paste0(ty, "_team_id")]][r]    <- tp$team_id
      add[[paste0(ty, "_team_order")]][r] <- tp$order
      add[[paste0(ty, "_team_ref")]][r]   <- tp$team_ref
    }
  }

  dplyr::bind_cols(plays_df, dplyr::as_tibble(add))
}


#' Flatten one raw ESPN CFB play object into a single-row data frame
#'
#' Internal helper shared by [espn_cfb_game_pbp()],
#' [espn_cfb_game_drive_plays()], and [espn_cfb_game_play()]. Given one raw
#' play object (as returned by `jsonlite::fromJSON(simplifyVector = FALSE)`)
#' it exhaustively flattens every scalar and nested-object scalar in the
#' core-v2 play schema into one data-frame row -- the play type
#' (`type{id,text,abbreviation}`), period, clock, score, the
#' `start{}` / `end{}` down-distance blocks (including the
#' `downDistanceText` / `shortDownDistanceText` / `possessionText` and the
#' `team{$ref}` inside each), the conditional scoring blocks
#' (`scoringType{}`, `pointAfterAttempt{}`), and every `$ref`
#' (`drive`, `probability`, the play self-`$ref`). `$ref` URLs are kept as
#' `*_ref` columns and the embedded ids parsed alongside. `game_id` (and
#' optionally `drive_id`) are supplied by the caller and prepended.
#'
#' @param it One raw play object.
#' @param game_id ESPN game identifier (prepended as the first column).
#' @param drive_id Optional ESPN drive id (prepended after `game_id` when
#'   not `NULL` -- used by [espn_cfb_game_drive_plays()]).
#' @return A one-row `data.frame` of the fully flattened play.
#' @keywords internal
#' @noRd
.espn_cfb_play_row <- function(it, game_id, drive_id = NULL) {
  `%||%` <- rlang::`%||%`

  ref_of <- function(obj) {
    if (is.list(obj)) obj[["$ref"]] %||% NA_character_ else NA_character_
  }
  id_from <- function(ref, what) {
    if (is.na(ref)) return(NA_character_)
    sub(paste0(".*/", what, "/([0-9]+).*"), "\\1", ref)
  }

  tp  <- it[["type"]]
  per <- it[["period"]]
  clk <- it[["clock"]]
  st  <- it[["start"]]
  en  <- it[["end"]]
  sct <- it[["scoringType"]]
  pat <- it[["pointAfterAttempt"]]

  team_ref       <- ref_of(it[["team"]])
  drive_ref      <- ref_of(it[["drive"]])
  prob_ref       <- ref_of(it[["probability"]])
  start_team_ref <- if (is.list(st)) ref_of(st[["team"]]) else NA_character_
  end_team_ref   <- if (is.list(en)) ref_of(en[["team"]]) else NA_character_

  row <- data.frame(
    game_id = as.character(game_id),
    stringsAsFactors = FALSE
  )
  if (!is.null(drive_id)) {
    row[["drive_id"]] <- as.character(drive_id)
  }

  rest <- data.frame(
    play_id                      = as.character(it[["id"]] %||% NA),
    sequence_number              = as.character(it[["sequenceNumber"]] %||% NA),
    type_id                      = if (is.list(tp)) as.character(tp[["id"]] %||% NA) else NA_character_,
    type_text                    = if (is.list(tp)) as.character(tp[["text"]] %||% NA) else NA_character_,
    type_abbreviation            = if (is.list(tp)) as.character(tp[["abbreviation"]] %||% NA) else NA_character_,
    text                         = as.character(it[["text"]] %||% NA),
    short_text                   = as.character(it[["shortText"]] %||% NA),
    alternative_text             = as.character(it[["alternativeText"]] %||% NA),
    short_alternative_text       = as.character(it[["shortAlternativeText"]] %||% NA),
    period                       = if (is.list(per)) suppressWarnings(as.integer(per[["number"]] %||% NA)) else NA_integer_,
    clock                        = if (is.list(clk)) as.character(clk[["displayValue"]] %||% NA) else NA_character_,
    clock_seconds                = if (is.list(clk)) suppressWarnings(as.numeric(clk[["value"]] %||% NA)) else NA_real_,
    home_score                   = suppressWarnings(as.integer(it[["homeScore"]] %||% NA)),
    away_score                   = suppressWarnings(as.integer(it[["awayScore"]] %||% NA)),
    scoring_play                 = as.logical(it[["scoringPlay"]] %||% NA),
    score_value                  = suppressWarnings(as.integer(it[["scoreValue"]] %||% NA)),
    priority                     = as.logical(it[["priority"]] %||% NA),
    is_penalty                   = as.logical(it[["isPenalty"]] %||% NA),
    is_turnover                  = as.logical(it[["isTurnover"]] %||% NA),
    stat_yardage                 = suppressWarnings(as.integer(it[["statYardage"]] %||% NA)),
    scoring_type_name            = if (is.list(sct)) as.character(sct[["name"]] %||% NA) else NA_character_,
    scoring_type_display_name    = if (is.list(sct)) as.character(sct[["displayName"]] %||% NA) else NA_character_,
    scoring_type_abbreviation    = if (is.list(sct)) as.character(sct[["abbreviation"]] %||% NA) else NA_character_,
    point_after_attempt_id       = if (is.list(pat)) suppressWarnings(as.integer(pat[["id"]] %||% NA)) else NA_integer_,
    point_after_attempt_text     = if (is.list(pat)) as.character(pat[["text"]] %||% NA) else NA_character_,
    point_after_attempt_abbreviation = if (is.list(pat)) as.character(pat[["abbreviation"]] %||% NA) else NA_character_,
    point_after_attempt_value    = if (is.list(pat)) suppressWarnings(as.integer(pat[["value"]] %||% NA)) else NA_integer_,
    start_down                   = if (is.list(st)) suppressWarnings(as.integer(st[["down"]] %||% NA)) else NA_integer_,
    start_distance               = if (is.list(st)) suppressWarnings(as.integer(st[["distance"]] %||% NA)) else NA_integer_,
    start_yard_line              = if (is.list(st)) suppressWarnings(as.integer(st[["yardLine"]] %||% NA)) else NA_integer_,
    start_yards_to_endzone       = if (is.list(st)) suppressWarnings(as.integer(st[["yardsToEndzone"]] %||% NA)) else NA_integer_,
    start_down_distance_text     = if (is.list(st)) as.character(st[["downDistanceText"]] %||% NA) else NA_character_,
    start_short_down_distance_text = if (is.list(st)) as.character(st[["shortDownDistanceText"]] %||% NA) else NA_character_,
    start_possession_text        = if (is.list(st)) as.character(st[["possessionText"]] %||% NA) else NA_character_,
    start_team_id                = id_from(start_team_ref, "teams"),
    end_down                     = if (is.list(en)) suppressWarnings(as.integer(en[["down"]] %||% NA)) else NA_integer_,
    end_distance                 = if (is.list(en)) suppressWarnings(as.integer(en[["distance"]] %||% NA)) else NA_integer_,
    end_yard_line                = if (is.list(en)) suppressWarnings(as.integer(en[["yardLine"]] %||% NA)) else NA_integer_,
    end_yards_to_endzone         = if (is.list(en)) suppressWarnings(as.integer(en[["yardsToEndzone"]] %||% NA)) else NA_integer_,
    end_down_distance_text       = if (is.list(en)) as.character(en[["downDistanceText"]] %||% NA) else NA_character_,
    end_short_down_distance_text = if (is.list(en)) as.character(en[["shortDownDistanceText"]] %||% NA) else NA_character_,
    end_possession_text          = if (is.list(en)) as.character(en[["possessionText"]] %||% NA) else NA_character_,
    end_team_id                  = id_from(end_team_ref, "teams"),
    team_id                      = id_from(team_ref, "teams"),
    drive_play_id                = id_from(drive_ref, "drives"),
    wallclock                    = as.character(it[["wallclock"]] %||% NA),
    modified                     = as.character(it[["modified"]] %||% NA),
    play_ref                     = ref_of(it),
    team_ref                     = team_ref,
    start_team_ref               = start_team_ref,
    end_team_ref                 = end_team_ref,
    drive_ref                    = drive_ref,
    probability_ref              = prob_ref,
    stringsAsFactors             = FALSE
  )
  cbind(row, rest)
}


#' Attach play `participants[]` data to an ESPN CFB plays frame
#'
#' Internal helper shared by [espn_cfb_game_pbp()],
#' [espn_cfb_game_drive_plays()], and [espn_cfb_game_play()]. Given the
#' already-parsed plays frame and the matching list of raw play objects
#' (each carrying a `participants[]` array), it joins per-play participant
#' rows and returns either a `wide` (type-keyed `{type}_player_*` columns)
#' or `long` (one row per play x participant) frame. The roster lookup is
#' supplied pre-fetched via `.espn_cfb_participant_roster()` so a single
#' wrapper call reuses one roster fetch; a roster failure degrades
#' gracefully to `NA` joins.
#'
#' @param plays_df Parsed plays data frame (one row per play).
#' @param raw_plays List of raw play objects, parallel to `plays_df` rows.
#' @param roster_lk Pre-fetched roster lookup from
#'   `.espn_cfb_participant_roster()`.
#' @param mode One of `"wide"` or `"long"`.
#' @return A data frame with participant columns appended (`wide`) or
#'   expanded to play x participant rows (`long`).
#' @keywords internal
#' @noRd
.espn_cfb_attach_participants <- function(plays_df, raw_plays,
                                          roster_lk = list(),
                                          mode = c("wide", "long")) {
  mode <- match.arg(mode)
  `%||%` <- rlang::`%||%`

  lk <- function(aid, field) {
    if (is.null(aid) || is.na(aid)) return(NA_character_)
    e <- roster_lk[[as.character(aid)]]
    if (is.null(e)) return(NA_character_)
    e[[field]] %||% NA_character_
  }

  # --- normalise one play's participants[] into a list of rows ----------
  parse_parts <- function(it) {
    parts <- it[["participants"]] %||% list()
    out <- list()
    for (idx in seq_along(parts)) {
      pp <- parts[[idx]]
      a_ref <- if (is.list(pp[["athlete"]])) {
        pp[["athlete"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      a_id <- if (!is.na(a_ref)) {
        sub(".*/athletes/([0-9]+).*", "\\1", a_ref)
      } else {
        NA_character_
      }
      stats <- pp[["stats"]] %||% list()
      stat_rows <- list()
      for (s in stats) {
        stat_rows[[length(stat_rows) + 1L]] <- list(
          name          = as.character(s[["name"]] %||% NA),
          value         = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
          display_value = as.character(s[["displayValue"]] %||% NA)
        )
      }
      out[[length(out) + 1L]] <- list(
        index      = idx,
        athlete_id = a_id,
        type       = as.character(pp[["type"]] %||% NA),
        order      = suppressWarnings(as.integer(pp[["order"]] %||% NA)),
        stats      = stat_rows
      )
    }
    out
  }

  parsed <- lapply(raw_plays, parse_parts)

  # ---------------------------------------------------------------- WIDE
  # Type-keyed scheme mirroring sportsdataverse's cfb_play_participants.py:
  # for every participant `type` that appears anywhere in the game, emit
  #   {type}_player_id            -- scalar, first occurrence of that type
  #   {type}_player_name          -- scalar, that athlete's roster-joined name
  #   {type}_player_position      -- scalar, that athlete's position
  #                                  abbreviation (roster + catalog join)
  #   {type}_player_position_name -- scalar, that athlete's position name
  #   {type}_player_ids           -- list-column, every athlete id of type
  #   {type}_player_names         -- list-column, parallel vector of names
  # `type` is snake_cased (ESPN ships camelCase: sackedBy -> sacked_by).
  # Participant stats[] are intentionally dropped in wide mode -- the wide
  # frame is the who-played-what-role table; stats stay in long mode.
  if (mode == "wide") {
    # snake_case helper: camelCase / PascalCase -> snake_case.
    snake <- function(x) {
      if (is.null(x) || is.na(x) || x == "") return(NA_character_)
      janitor::make_clean_names(x)
    }

    # Discover every participant type present in the game, in first-seen
    # order, so the appended column set is stable and deterministic.
    type_order <- character(0)
    parsed_typed <- vector("list", length(parsed))
    for (r in seq_along(parsed)) {
      pl <- parsed[[r]]
      typed <- vector("list", length(pl))
      for (i in seq_along(pl)) {
        pp <- pl[[i]]
        ty <- snake(pp$type)
        typed[[i]] <- list(type = ty, athlete_id = pp$athlete_id)
        if (!is.na(ty) && !(ty %in% type_order)) {
          type_order <- c(type_order, ty)
        }
      }
      parsed_typed[[r]] <- typed
    }

    if (length(type_order) == 0L) return(plays_df)

    n <- nrow(plays_df)
    add <- list()
    for (ty in type_order) {
      add[[paste0(ty, "_player_id")]]            <- rep(NA_character_, n)
      add[[paste0(ty, "_player_name")]]          <- rep(NA_character_, n)
      add[[paste0(ty, "_player_position")]]      <- rep(NA_character_, n)
      add[[paste0(ty, "_player_position_name")]] <- rep(NA_character_, n)
      add[[paste0(ty, "_player_ids")]]   <- replicate(n, character(0), simplify = FALSE)
      add[[paste0(ty, "_player_names")]] <- replicate(n, character(0), simplify = FALSE)
    }

    for (r in seq_len(n)) {
      typed <- parsed_typed[[r]]
      if (length(typed) == 0L) next
      # Collect ids per type for this play, in ESPN order.
      ids_by_type <- list()
      for (pp in typed) {
        ty <- pp$type
        if (is.na(ty)) next
        ids_by_type[[ty]] <- c(ids_by_type[[ty]], pp$athlete_id)
      }
      for (ty in names(ids_by_type)) {
        ids   <- ids_by_type[[ty]]
        ids   <- ids[!is.na(ids)]
        if (length(ids) == 0L) next
        names_vec <- vapply(ids, function(a) lk(a, "name"), character(1),
                            USE.NAMES = FALSE)
        add[[paste0(ty, "_player_id")]][r]      <- ids[1]
        add[[paste0(ty, "_player_name")]][r]    <- names_vec[1]
        # Position detail of the first occurrence of that type -- carried
        # only when the roster lookup was built with position_detail; an
        # un-enriched lookup yields NA, matching position_detail = FALSE.
        add[[paste0(ty, "_player_position")]][r] <-
          lk(ids[1], "position_abbreviation")
        add[[paste0(ty, "_player_position_name")]][r] <-
          lk(ids[1], "position_name")
        add[[paste0(ty, "_player_ids")]][[r]]   <- ids
        add[[paste0(ty, "_player_names")]][[r]] <- names_vec
      }
    }

    return(dplyr::bind_cols(plays_df, dplyr::as_tibble(add)))
  }

  # ---------------------------------------------------------------- LONG
  rows <- list()
  for (r in seq_len(nrow(plays_df))) {
    base_row <- plays_df[r, , drop = FALSE]
    pl <- parsed[[r]]
    if (length(pl) == 0) {
      rows[[length(rows) + 1L]] <- dplyr::bind_cols(
        base_row,
        data.frame(
          participant_index        = NA_integer_,
          participant_athlete_id   = NA_character_,
          participant_type         = NA_character_,
          participant_order        = NA_integer_,
          participant_athlete_name = NA_character_,
          participant_position     = NA_character_,
          participant_jersey       = NA_character_,
          participant_team_id      = NA_character_,
          stringsAsFactors = FALSE
        )
      )
      next
    }
    for (pp in pl) {
      prow <- data.frame(
        participant_index        = pp$index,
        participant_athlete_id   = pp$athlete_id,
        participant_type         = pp$type,
        participant_order        = pp$order,
        participant_athlete_name = lk(pp$athlete_id, "name"),
        participant_position     = lk(pp$athlete_id, "position"),
        participant_jersey       = lk(pp$athlete_id, "jersey"),
        participant_team_id      = lk(pp$athlete_id, "team_id"),
        stringsAsFactors = FALSE
      )
      for (s in pp$stats) {
        nm <- s$name
        if (is.null(nm) || is.na(nm) || nm == "") next
        prow[[paste0("pstat_", nm)]] <- s$value
      }
      rows[[length(rows) + 1L]] <- dplyr::bind_cols(base_row, prow)
    }
  }
  if (length(rows) == 0) return(plays_df)
  dplyr::bind_rows(rows)
}


#' @title
#' **ESPN College Football Game Broadcasts**
#' @description Get the broadcast / streaming outlets carrying a single
#' college football game.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/broadcasts`. Returns one row
#' per broadcast outlet -- a television network, streaming service, or radio
#' station. `type_name` distinguishes TV / streaming / radio; `market_type`
#' is the geographic market (e.g. `National`); `priority` is ESPN's display
#' ordering of the outlets.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @return A data frame with one row per broadcast outlet:
#'
#'    |col_name           |types     |description                                            |
#'    |:------------------|:---------|:------------------------------------------------------|
#'    |game_id            |character |ESPN game identifier.                                  |
#'    |type_id            |character |Broadcast-type id.                                     |
#'    |type_name          |character |Broadcast-type name (e.g. `TV`, `Streaming`, `Radio`). |
#'    |type_slug          |character |Broadcast-type slug (e.g. `streaming`, `tv`).          |
#'    |station            |character |Broadcast station / network name (e.g. `ESPN+`).       |
#'    |slug               |character |Broadcast outlet slug.                                 |
#'    |channel            |character |Channel number, when published.                        |
#'    |priority           |integer   |ESPN display priority of the outlet (1 = first).       |
#'    |partnered          |logical   |`TRUE` if the outlet is an ESPN broadcast partner.     |
#'    |market_id          |character |Geographic market id.                                  |
#'    |market_type        |character |Geographic market type (e.g. `National`).              |
#'    |lang               |character |Broadcast language code.                               |
#'    |region             |character |Broadcast region code.                                 |
#'    |media_id           |character |ESPN media id for the outlet.                          |
#'    |media_name         |character |ESPN media name for the outlet.                        |
#'    |media_short_name   |character |Short ESPN media name for the outlet.                  |
#'    |media_call_letters |character |Broadcast call letters for the outlet.                 |
#'    |media_slug         |character |ESPN media slug for the outlet.                        |
#'    |media_group_id     |character |ESPN media-group id (e.g. corporate parent).           |
#'    |media_group_name   |character |ESPN media-group name (e.g. `Disney`).                 |
#'    |media_group_slug   |character |ESPN media-group slug.                                 |
#'    |competition_ref    |character |`$ref` URL to the competition resource.                |
#'    |media_ref          |character |`$ref` URL to the media resource.                      |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Broadcasts
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_broadcasts(game_id = 401628339))
#' }
espn_cfb_game_broadcasts <- function(game_id = NULL) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game broadcasts endpoint.")
  }

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/events/{game_id}/competitions/{game_id}/broadcasts",
    "?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)

      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]]
      if (is.null(items) || length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        tp <- it[["type"]]
        mk <- it[["market"]]
        md <- it[["media"]]
        mg <- if (is.list(md)) md[["group"]] else NULL
        comp <- it[["competition"]]

        rows[[length(rows) + 1L]] <- data.frame(
          game_id            = as.character(game_id),
          type_id            = if (is.list(tp)) as.character(tp[["id"]] %||% NA) else NA_character_,
          type_name          = if (is.list(tp)) as.character(tp[["longName"]] %||% tp[["shortName"]] %||% NA) else NA_character_,
          type_slug          = if (is.list(tp)) as.character(tp[["slug"]] %||% NA) else NA_character_,
          station            = as.character(it[["station"]] %||% NA),
          slug               = as.character(it[["slug"]] %||% NA),
          channel            = as.character(it[["channel"]] %||% NA),
          priority           = suppressWarnings(as.integer(it[["priority"]] %||% NA)),
          partnered          = as.logical(it[["partnered"]] %||% NA),
          market_id          = if (is.list(mk)) as.character(mk[["id"]] %||% NA) else NA_character_,
          market_type        = if (is.list(mk)) as.character(mk[["type"]] %||% NA) else NA_character_,
          lang               = as.character(it[["lang"]] %||% NA),
          region             = as.character(it[["region"]] %||% NA),
          media_id           = if (is.list(md)) as.character(md[["id"]] %||% NA) else NA_character_,
          media_name         = if (is.list(md)) as.character(md[["name"]] %||% NA) else NA_character_,
          media_short_name   = if (is.list(md)) as.character(md[["shortName"]] %||% NA) else NA_character_,
          media_call_letters = if (is.list(md)) as.character(md[["callLetters"]] %||% NA) else NA_character_,
          media_slug         = if (is.list(md)) as.character(md[["slug"]] %||% NA) else NA_character_,
          media_group_id     = if (is.list(mg)) as.character(mg[["id"]] %||% NA) else NA_character_,
          media_group_name   = if (is.list(mg)) as.character(mg[["name"]] %||% NA) else NA_character_,
          media_group_slug   = if (is.list(mg)) as.character(mg[["slug"]] %||% NA) else NA_character_,
          competition_ref    = if (is.list(comp)) as.character(comp[["$ref"]] %||% NA) else NA_character_,
          media_ref          = if (is.list(md)) as.character(md[["$ref"]] %||% NA) else NA_character_,
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble() |>
        make_cfbfastR_data("Game broadcasts data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game broadcasts data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Drive Plays**
#' @description Get the play-by-play for a single drive of a college football
#' game -- one row per play, scoped to one drive.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/drives/{drive_id}/plays`. The
#' competition id always equals the game id. Returns the same play schema as
#' the competition-level [espn_cfb_game_pbp()] feed, but partitioned to a
#' single drive (typically 5-11 plays). Harvest the `drive_id` from
#' [espn_cfb_game_drives()] -- its `drive_id` column lists every drive in the
#' game.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param drive_id (*Integer* required): ESPN drive id (from
#' [espn_cfb_game_drives()]).
#' @param participants (*Character*): controls whether each play's nested
#' `participants[]` array (the athletes credited on the play) is attached.
#' One of:
#'
#'   * `"none"` (default) -- the play frame is returned unchanged; no
#'     extra HTTP call is made.
#'   * `"wide"` -- one row per play, with type-keyed
#'     `{type}_player_*` columns appended (see *Details*).
#'   * `"long"` -- one row per play x participant (see *Details*).
#'
#' @param participants_list (*Logical*): when `TRUE`, append a single
#' list-column named `participants` holding each play's full participant
#' detail -- including the per-participant `stats[]` that `"wide"` mode
#' drops. Defaults to `FALSE`. This is **independent of and combinable
#' with** the `participants` argument (see *Details*).
#' @param team_participants (*Character*): controls whether each play's
#' nested `teamParticipants[]` array (the team(s) credited on the play) is
#' attached as type-keyed columns. One of:
#'
#'   * `"none"` (default) -- no team-participant columns are added.
#'   * `"wide"` -- one row per play, with type-keyed `{type}_team_*`
#'     columns appended (see *Details*).
#'
#' @param team_participants_list (*Logical*): when `TRUE`, append a single
#' list-column named `team_participants` holding each play's full
#' `teamParticipants[]` detail as a nested tibble. Defaults to `FALSE`.
#' This is **independent of and combinable with** the `team_participants`
#' argument (see *Details*).
#' @param team_detail (*Logical*): when `TRUE` (default), the ESPN team
#' catalog ([espn_cfb_teams()]) is fetched once and friendly team fields
#' are joined in next to every team-id column in the output (`team_id`,
#' `start_team_id`, `end_team_id`, plus any optional `{type}_team_id` /
#' `{type}_player_team_id` columns). For each id column `X_id` the sibling
#' columns `X_name`, `X_abbreviation`, `X_location`, `X_display_name`,
#' `X_short_display_name`, `X_nickname`, `X_color`, `X_alternate_color`,
#' `X_logo_href`, `X_logo_dark_href` are inserted immediately
#' after it. A catalog failure degrades to `NA` rather than erroring the
#' wrapper. Set `FALSE` to skip the catalog fetch and the join.
#' @return A data frame with one row per play in the drive:
#'
#'    |col_name                        |types     |description                                            |
#'    |:-------------------------------|:---------|:------------------------------------------------------|
#'    |game_id                         |character |ESPN game identifier.                                  |
#'    |drive_id                        |character |ESPN drive id (the requested drive).                   |
#'    |play_id                         |character |ESPN play id.                                          |
#'    |sequence_number                 |character |Play sequence number within the game.                  |
#'    |type_id                         |character |Play-type id.                                          |
#'    |type_text                       |character |Play-type text (e.g. `Pass Reception`).                |
#'    |type_abbreviation               |character |Play-type abbreviation (e.g. `RUSH`, `TD`).            |
#'    |text                            |character |Full play description.                                 |
#'    |short_text                      |character |Short play description.                                |
#'    |alternative_text                |character |Alternative play description.                          |
#'    |short_alternative_text          |character |Short alternative play description.                    |
#'    |period                          |integer   |Period (quarter) number.                               |
#'    |clock                           |character |Game clock display value at the play (`MM:SS`).        |
#'    |clock_seconds                   |numeric   |Game clock value in seconds at the play.               |
#'    |home_score                      |integer   |Home-team score after the play.                        |
#'    |away_score                      |integer   |Away-team score after the play.                        |
#'    |scoring_play                    |logical   |`TRUE` if the play resulted in a score.                |
#'    |score_value                     |integer   |Points scored on the play.                             |
#'    |priority                        |logical   |`TRUE` if ESPN flags the play as a priority highlight. |
#'    |is_penalty                      |logical   |`TRUE` if the play was a penalty.                      |
#'    |is_turnover                     |logical   |`TRUE` if the play was a turnover.                     |
#'    |stat_yardage                    |integer   |Yards gained or lost on the play.                      |
#'    |scoring_type_name               |character |Scoring-type key on a scoring play (e.g. `touchdown`). |
#'    |scoring_type_display_name       |character |Human-readable scoring-type name.                      |
#'    |scoring_type_abbreviation       |character |Scoring-type abbreviation (e.g. `TD`, `FG`).           |
#'    |point_after_attempt_id          |integer   |Point-after-attempt id on a scoring play.              |
#'    |point_after_attempt_text        |character |Point-after-attempt text (e.g. `Extra Point Good`).    |
#'    |point_after_attempt_abbreviation|character |Point-after-attempt abbreviation.                      |
#'    |point_after_attempt_value       |integer   |Points added by the point-after attempt.               |
#'    |start_down                      |integer   |Down at the start of the play.                         |
#'    |start_distance                  |integer   |Yards to go at the start of the play.                  |
#'    |start_yard_line                 |integer   |Yard line at the start of the play.                    |
#'    |start_yards_to_endzone          |integer   |Yards to the end zone at the start of the play.        |
#'    |start_down_distance_text        |character |Down-and-distance text at the start of the play.       |
#'    |start_short_down_distance_text  |character |Short down-and-distance text at the start of the play. |
#'    |start_possession_text           |character |Field-position text at the start of the play.          |
#'    |start_team_id                   |character |ESPN team id in possession at the start of the play.   |
#'    |end_down                        |integer   |Down at the end of the play.                           |
#'    |end_distance                    |integer   |Yards to go at the end of the play.                    |
#'    |end_yard_line                   |integer   |Yard line at the end of the play.                      |
#'    |end_yards_to_endzone            |integer   |Yards to the end zone at the end of the play.          |
#'    |end_down_distance_text          |character |Down-and-distance text at the end of the play.         |
#'    |end_short_down_distance_text    |character |Short down-and-distance text at the end of the play.   |
#'    |end_possession_text             |character |Field-position text at the end of the play.            |
#'    |end_team_id                     |character |ESPN team id in possession at the end of the play.     |
#'    |team_id                         |character |ESPN team id of the offensive team (parsed from `team_ref`). |
#'    |drive_play_id                   |character |ESPN drive id the play belongs to (parsed from `drive_ref`). |
#'    |wallclock                       |character |Real-world ISO timestamp of the play.                  |
#'    |modified                        |character |ISO timestamp the play record was last modified.       |
#'    |play_ref                        |character |`$ref` URL to the play resource itself.                |
#'    |team_ref                        |character |`$ref` URL to the offensive team resource.             |
#'    |start_team_ref                  |character |`$ref` URL to the team in possession at the play start.|
#'    |end_team_ref                    |character |`$ref` URL to the team in possession at the play end.  |
#'    |drive_ref                       |character |`$ref` URL to the play's drive resource.               |
#'    |probability_ref                 |character |`$ref` URL to the play's win-probability resource.     |
#'
#' The optional participant and team-participant columns are described in
#' *Details* -- they are added only when the corresponding argument
#' requests them.
#'
#' @details
#' When `participants = "wide"`, the base play schema is kept intact and
#' six columns are appended for every participant `type` that appears
#' anywhere in the drive. The column names are **dynamic** -- one set per
#' participant type present (e.g. `passer`, `rusher`, `receiver`,
#' `tackler`, `sacked_by`, `pass_defender`, `kicker`, `returner`). ESPN's
#' camelCase types are snake-cased (`sackedBy` -> `sacked_by`). For each
#' type the appended columns are:
#'
#'   * `{type}_player_id` -- scalar character, the **first**
#'     occurrence of that type on the play (`NA` if none).
#'   * `{type}_player_name` -- scalar character, that athlete's
#'     roster-joined name (`NA` if none or unmatched).
#'   * `{type}_player_position` -- scalar character, the first
#'     athlete's position abbreviation (joined from the ESPN position
#'     catalog; `NA` if unmatched).
#'   * `{type}_player_position_name` -- scalar character, the first
#'     athlete's position name.
#'   * `{type}_player_ids` -- a **list-column**: a character vector
#'     of **every** athlete id of that type on the play, in ESPN order.
#'     Plays with none carry `character(0)`.
#'   * `{type}_player_names` -- a **list-column**: the parallel
#'     vector of roster-joined names.
#'
#' Participant `stats[]` are not carried in wide mode -- use `"long"` for
#' the per-participant stat lines.
#'
#' When `participants = "long"`, the frame is expanded to one row per
#' play x participant with `participant_index`, `participant_athlete_id`,
#' `participant_type`, `participant_order`, the roster-joined
#' `participant_athlete_name` / `participant_position` /
#' `participant_jersey` / `participant_team_id`, and the participant's
#' stats pivoted to named `pstat_<statname>` columns. Plays with zero
#' participants still yield one row (participant fields `NA`).
#'
#' When `participants_list = TRUE`, a single list-column named
#' `participants` is appended. Each cell is a tibble with one row per
#' participant on that play and columns `participant_index` (1-based, ESPN
#' order), `type` (snake_cased, e.g. `sacked_by`, `pass_defender`),
#' `athlete_id`, `athlete_name` (roster-joined), `order`, `position_id`,
#' plus one column per participant `stat[]` name (`dplyr::bind_rows`
#' NA-fills participants whose stat sets differ). Plays with no
#' participants carry an empty 0-row tibble, never `NULL`. This option is
#' independent of `participants` and composes with any of its modes -- e.g.
#' `participants = "wide", participants_list = TRUE` yields the type-keyed
#' `{type}_player_*` columns **and** the `participants` list-column, while
#' `participants = "none", participants_list = TRUE` adds only the
#' list-column. With `participants = "long"` the list-column repeats per
#' play x participant row. The raw plays are fetched only once even when
#' both options are active.
#'
#' When `team_participants = "wide"`, three columns are appended for every
#' `teamParticipants[]` `type` present anywhere in the drive (ESPN ships
#' `offense` / `defense`). The column names are **dynamic** -- one set per
#' type, snake-cased: `{type}_team_id` (scalar character, the first
#' occurrence of that type on the play), `{type}_team_order` (scalar
#' integer, ESPN's display order), and `{type}_team_ref` (scalar
#' character, the `$ref` URL to that team resource). Plays with none of a
#' type carry `NA`.
#'
#' When `team_participants_list = TRUE`, a single list-column named
#' `team_participants` is appended. Each cell is a tibble with one row per
#' team credited on the play and columns `team_participant_index`
#' (1-based, ESPN order), `team_id`, `team_ref`, `order`, and `type`
#' (e.g. `offense`, `defense`). A play with no team participants carries
#' an empty 0-row tibble, never `NULL`. This option is independent of
#' `team_participants` and composes with it -- e.g.
#' `team_participants = "wide", team_participants_list = TRUE` yields both
#' the type-keyed `{type}_team_*` columns **and** the `team_participants`
#' list-column, while `team_participants = "none"` adds neither.
#'
#' When `team_detail = TRUE` (the default), the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and joined onto **every** team-id
#' column the output carries -- the base `team_id` / `start_team_id` /
#' `end_team_id`, plus any optional `{type}_team_id` (from
#' `team_participants = "wide"`) and `{type}_player_team_id` (from
#' `participants = "long"`) columns. For each id column `X_id` the friendly
#' siblings `X_name`, `X_abbreviation`, `X_location`, `X_display_name`,
#' `X_short_display_name`, `X_nickname`, `X_color`, `X_alternate_color`,
#' `X_logo_href`, and `X_logo_dark_href` are inserted
#' immediately after it (e.g. `team_id` -> `team_name`,
#' `team_abbreviation`, ...; `start_team_id` -> `start_team_name`, ...).
#' Rows whose id is missing or unmatched receive `NA`, and a catalog-fetch
#' failure degrades the whole set to `NA` rather than erroring the wrapper.
#' With `team_detail = FALSE` the friendly columns (and the catalog fetch)
#' are skipped.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows bind_cols tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Drive Plays PBP
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_drive_plays(game_id = 401628339,
#'                                 drive_id = 4016283391))
#'   try(espn_cfb_game_drive_plays(game_id = 401628339,
#'                                 drive_id = 4016283391,
#'                                 participants = "long"))
#'   try(espn_cfb_game_drive_plays(game_id = 401628339,
#'                                 drive_id = 4016283391,
#'                                 participants = "wide",
#'                                 participants_list = TRUE))
#'   try(espn_cfb_game_drive_plays(game_id = 401628339,
#'                                 drive_id = 4016283391,
#'                                 team_participants = "wide",
#'                                 team_participants_list = TRUE))
#'   try(espn_cfb_game_drive_plays(game_id = 401628339,
#'                                 drive_id = 4016283391,
#'                                 team_detail = FALSE))
#' }
espn_cfb_game_drive_plays <- function(game_id = NULL, drive_id = NULL,
                                      participants = c("none", "wide", "long"),
                                      participants_list = FALSE,
                                      team_participants = c("none", "wide"),
                                      team_participants_list = FALSE,
                                      team_detail = TRUE) {
  participants <- match.arg(participants)
  team_participants <- match.arg(team_participants)

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game drive plays endpoint.")
  }
  if (is.null(drive_id)) {
    cli::cli_abort("{.arg drive_id} is required for the ESPN game drive plays endpoint.")
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      base_url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}/competitions/{game_id}/",
        "drives/{drive_id}/plays?limit=300&lang=en&region=us"
      )
      first <- get_json(paste0(base_url, "&page=1"))
      page_count <- suppressWarnings(as.integer(first[["pageCount"]] %||% 1L))
      if (is.na(page_count) || page_count < 1L) page_count <- 1L

      rows <- list()
      raw_plays <- list()
      add_items <- function(items) {
        for (it in items %||% list()) {
          raw_plays[[length(raw_plays) + 1L]] <<- it
          rows[[length(rows) + 1L]] <<- .espn_cfb_play_row(
            it, game_id = game_id, drive_id = drive_id
          )
        }
      }

      add_items(first[["items"]])
      if (page_count > 1L) {
        for (p in 2:page_count) {
          pg <- get_json(paste0(base_url, "&page=", p))
          add_items(pg[["items"]])
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      plays_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # teamParticipants[] -- opt-in, mirroring participants. "wide" emits
      # type-keyed {type}_team_* columns; team_participants_list = TRUE
      # appends the nested team_participants list-column. The two compose.
      if (team_participants != "none") {
        plays_df <- .espn_cfb_attach_team_participants(plays_df, raw_plays)
      }
      if (isTRUE(team_participants_list)) {
        plays_df <- .espn_cfb_attach_team_participants_list(
          plays_df, raw_plays
        )
      }

      # Fetch the game roster at most once, reused by both the participants
      # flattening and the participants list-column. The roster lookup is
      # enriched with the position catalog (position_detail = TRUE) so the
      # wide participants output carries {type}_player_position detail.
      roster_lk <- list()
      if (participants != "none" || isTRUE(participants_list)) {
        roster_lk <- .espn_cfb_participant_roster(
          game_id, position_detail = (participants == "wide")
        )
      }

      if (isTRUE(participants_list)) {
        plays_df <- .espn_cfb_attach_participants_list(
          plays_df, raw_plays, roster_lk = roster_lk
        )
      }

      if (participants != "none") {
        plays_df <- .espn_cfb_attach_participants(
          plays_df, raw_plays, roster_lk = roster_lk, mode = participants
        )
      }

      # Join the ESPN team catalog onto every team-id column when requested
      # -- adds the friendly {col}_name / _abbreviation / _location / ...
      # siblings. team_detail = FALSE skips the fetch and the join.
      if (isTRUE(team_detail)) {
        team_lk <- .espn_cfb_team_lookup()
        plays_df <- .espn_cfb_attach_team_detail(plays_df, team_lk)
      }

      df <- plays_df |>
        make_cfbfastR_data("Game drive plays data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game drive plays data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Build a full-schema ESPN CFB plays tibble from a list of raw play objects
#'
#' Internal helper. Given a list of raw play objects (as returned by
#' `jsonlite::fromJSON(simplifyVector = FALSE)`) belonging to a single
#' game, it flattens each through `.espn_cfb_play_row()` and applies the
#' same participant / team-participant / position attach helpers that
#' [espn_cfb_game_pbp()] uses -- producing a tibble in the **identical**
#' `espn_cfb_game_pbp` schema (~54 base columns plus the optional
#' participant columns). An empty `raw_plays` yields a 0-row tibble in the
#' base schema, never `NULL`. This lets [espn_cfb_game_drives()] embed
#' full-schema plays without re-implementing the play pipeline.
#'
#' @param raw_plays List of raw play objects for one game.
#' @param game_id ESPN game identifier (prepended as the first column).
#' @param participants One of `"none"` / `"wide"` / `"long"` -- the
#'   participant-flattening mode (see [espn_cfb_game_pbp()]).
#' @param participants_list When `TRUE`, append the `participants`
#'   list-column.
#' @param team_participants One of `"none"` / `"wide"` -- the
#'   team-participant-flattening mode.
#' @param team_participants_list When `TRUE`, append the
#'   `team_participants` list-column.
#' @param roster_lk Pre-fetched roster lookup from
#'   `.espn_cfb_participant_roster()` (reused so a single fetch covers
#'   every drive).
#' @return A tibble in the `espn_cfb_game_pbp` schema (possibly 0-row).
#' @keywords internal
#' @noRd
.espn_cfb_build_plays_tbl <- function(raw_plays, game_id,
                                      participants = "none",
                                      participants_list = FALSE,
                                      team_participants = "none",
                                      team_participants_list = FALSE,
                                      roster_lk = list()) {
  if (length(raw_plays) == 0L) {
    # 0-row frame in the base pbp schema -- one row built then sliced empty
    # is fragile, so build directly from a synthetic empty play.
    empty <- .espn_cfb_play_row(list(), game_id = game_id)
    return(dplyr::as_tibble(empty[0, , drop = FALSE]))
  }

  rows <- lapply(raw_plays, function(it) {
    .espn_cfb_play_row(it, game_id = game_id)
  })
  plays_df <- dplyr::as_tibble(dplyr::bind_rows(rows))

  if (team_participants != "none") {
    plays_df <- .espn_cfb_attach_team_participants(plays_df, raw_plays)
  }
  if (isTRUE(team_participants_list)) {
    plays_df <- .espn_cfb_attach_team_participants_list(plays_df, raw_plays)
  }
  if (isTRUE(participants_list)) {
    plays_df <- .espn_cfb_attach_participants_list(
      plays_df, raw_plays, roster_lk = roster_lk
    )
  }
  if (participants != "none") {
    plays_df <- .espn_cfb_attach_participants(
      plays_df, raw_plays, roster_lk = roster_lk, mode = participants
    )
  }
  plays_df
}


#' @title
#' **ESPN College Football Game Drives**
#' @description Get the per-game drive log for a single college football game
#' -- one row per drive, with start/end field position, yardage, play count,
#' result, and a `$ref` to that drive's plays. Optionally embed each drive's
#' full-schema play-by-play as a nested list-column or as a flat
#' one-row-per-play table.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/drives`. The competition id always
#' equals the game id. Returns one row per drive (typically 18-24 drives per
#' game). Each drive carries the offensive team, the start and end
#' period/clock/yard-line, total yards, offensive play count, the drive
#' result, and a scoring flag. The `plays_ref` column is the `$ref` URL to
#' that drive's plays -- pass the `drive_id` to [espn_cfb_game_drive_plays()]
#' to fetch the play-by-play partitioned to a single drive. This is the
#' richest drive resource ESPN exposes; the site-v2 summary feed only carries
#' a flattened subset.
#'
#' The `plays` argument controls whether each drive's plays are embedded:
#'
#'   * `"none"` (default) -- the drives output is returned unchanged,
#'     one row per drive, with no embedded plays.
#'   * `"list"` -- a `plays` **list-column** is appended; each cell is
#'     that drive's plays as a tibble in the **full**
#'     [espn_cfb_game_pbp()] schema (~54 base columns plus any optional
#'     participant columns). A drive with no matched plays gets an empty
#'     0-row tibble, never `NULL`.
#'   * `"expand"` -- the **flat one-row-per-play** table is returned:
#'     every play in the full [espn_cfb_game_pbp()] schema, with that
#'     play's drive-level columns carried alongside, prefixed `drive_`
#'     (e.g. `drive_id`, `drive_result`, `drive_yards`,
#'     `drive_start_yard_line`) to avoid collision with the play's own
#'     columns. This is the [espn_cfb_game_pbp()] expanded form enriched
#'     with drive context.
#'
#'
#' The `participants`, `participants_list`, `team_participants`,
#' `team_participants_list`, and `position_detail` arguments shape the
#' embedded plays and are consulted **only** when `plays != "none"`. They
#' have the same meaning as the identically named arguments on
#' [espn_cfb_game_pbp()] -- e.g. `participants = "wide"` appends the
#' type-keyed `{type}_player_*` columns to every embedded play tibble. See
#' [espn_cfb_game_pbp()] for the full description of each.
#'
#' To get the plays efficiently the wrapper first probes the drives
#' endpoint for inline plays (`items[].plays.items[]`); when ESPN embeds
#' them, no extra request is made. When only a `plays.$ref` is present, the
#' competition-level `/plays` feed is fetched **once** and the plays are
#' partitioned into drives by matching each play's drive id. Per-drive
#' `plays_ref` URLs are never dereferenced individually.
#'
#' [espn_cfb_unnest_plays()] turns a `plays = "list"` result into the same
#' flat table as `plays = "expand"` without any further HTTP.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param plays (*Character*): controls whether each drive's plays are
#' embedded. One of `"none"` (default), `"list"`, or `"expand"` -- see
#' *Details*.
#' @param participants (*Character*): participant-flattening mode for the
#' embedded plays -- one of `"none"` (default), `"wide"`, or `"long"`.
#' Consulted only when `plays != "none"`. See [espn_cfb_game_pbp()].
#' @param participants_list (*Logical*): when `TRUE`, append the
#' `participants` list-column to each embedded play. Defaults to `FALSE`.
#' Consulted only when `plays != "none"`.
#' @param team_participants (*Character*): team-participant-flattening mode
#' for the embedded plays -- one of `"none"` (default) or `"wide"`.
#' Consulted only when `plays != "none"`.
#' @param team_participants_list (*Logical*): when `TRUE`, append the
#' `team_participants` list-column to each embedded play. Defaults to
#' `FALSE`. Consulted only when `plays != "none"`.
#' @param position_detail (*Logical*): when `TRUE` (default), the embedded
#' plays' `participants = "wide"` output carries position detail joined
#' from the ESPN position catalog. Consulted only when `plays != "none"`
#' and `participants = "wide"`.
#' @param team_detail (*Logical*): when `TRUE` (default), the ESPN team
#' catalog ([espn_cfb_teams()]) is fetched once and friendly team fields
#' are joined in next to the drive-level team-id columns -- `team_id` and
#' `end_team_id` (which become `drive_team_id` / `drive_end_team_id` in
#' `plays = "expand"` mode). For each id column `X_id` the sibling columns
#' `X_name`, `X_abbreviation`, `X_location`, `X_display_name`,
#' `X_short_display_name`, `X_nickname`, `X_color`, `X_alternate_color`,
#' `X_logo_href`, `X_logo_dark_href` are inserted immediately
#' after it. The embedded play tibbles keep the base
#' [espn_cfb_game_pbp()] schema (not team-enriched), so a `plays =
#' "expand"` result matches `espn_cfb_unnest_plays()` of a `plays = "list"`
#' result. A catalog failure degrades to `NA` rather than erroring the
#' wrapper. Set `FALSE` to skip the catalog fetch and the join.
#' @return A data frame with one row per drive:
#'
#'    |col_name             |types     |description                                            |
#'    |:--------------------|:---------|:------------------------------------------------------|
#'    |game_id              |character |ESPN game identifier.                                  |
#'    |drive_id             |character |ESPN drive id.                                         |
#'    |sequence_number      |character |Drive sequence number within the game.                 |
#'    |description          |character |Drive summary text (e.g. `9 plays, 75 yards, 4:12`).   |
#'    |team_id              |character |ESPN team id of the offensive team (parsed from `team_ref`). |
#'    |end_team_id          |character |ESPN team id of the team in possession at drive end.   |
#'    |start_period         |integer   |Period (quarter) at the start of the drive.            |
#'    |start_period_type    |character |Period type at the start of the drive (e.g. `quarter`).|
#'    |start_clock          |character |Game clock display value at the start of the drive.    |
#'    |start_clock_seconds  |numeric   |Game clock value in seconds at the start of the drive. |
#'    |start_yard_line      |integer   |Yard line at the start of the drive.                   |
#'    |start_text           |character |Field-position text at the start of the drive.         |
#'    |end_period           |integer   |Period (quarter) at the end of the drive.              |
#'    |end_period_type      |character |Period type at the end of the drive (e.g. `quarter`).  |
#'    |end_clock            |character |Game clock display value at the end of the drive.      |
#'    |end_clock_seconds    |numeric   |Game clock value in seconds at the end of the drive.   |
#'    |end_yard_line        |integer   |Yard line at the end of the drive.                     |
#'    |end_text             |character |Field-position text at the end of the drive.           |
#'    |time_elapsed         |character |Elapsed game time for the drive (`MM:SS`).             |
#'    |time_elapsed_seconds |numeric   |Elapsed game time for the drive, in seconds.           |
#'    |yards                |integer   |Total yards gained on the drive.                       |
#'    |offensive_plays      |integer   |Number of offensive plays on the drive.                |
#'    |is_score             |logical   |`TRUE` if the drive resulted in a score.               |
#'    |result               |character |Drive result code (e.g. `PUNT`, `TD`).                 |
#'    |short_display_result |character |Short drive-result label.                              |
#'    |display_result       |character |Drive-result label (e.g. `Punt`, `Touchdown`).         |
#'    |source_id            |character |ESPN data-source id for the drive.                     |
#'    |source_description   |character |ESPN data-source description (e.g. `Feed`).            |
#'    |drive_ref            |character |`$ref` URL to the drive resource itself.               |
#'    |team_ref             |character |`$ref` URL to the offensive team resource.             |
#'    |end_team_ref         |character |`$ref` URL to the team in possession at drive end.     |
#'    |plays_ref            |character |`$ref` URL to the drive's plays resource.              |
#'
#' When `plays = "list"`, an additional `plays` list-column is appended --
#' each cell a tibble in the full [espn_cfb_game_pbp()] schema. When
#' `plays = "expand"`, the flat one-row-per-play table is returned instead:
#' every column of [espn_cfb_game_pbp()] plus the drive-level columns above
#' carried alongside each play with a `drive_` prefix.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows bind_cols tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Drives
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_drives(game_id = 401628339))
#'   try(espn_cfb_game_drives(game_id = 401628339, plays = "list"))
#'   try(espn_cfb_game_drives(game_id = 401628339, plays = "expand"))
#'   try(espn_cfb_game_drives(game_id = 401628339, team_detail = FALSE))
#' }
espn_cfb_game_drives <- function(game_id = NULL,
                                 plays = c("none", "list", "expand"),
                                 participants = c("none", "wide", "long"),
                                 participants_list = FALSE,
                                 team_participants = c("none", "wide"),
                                 team_participants_list = FALSE,
                                 position_detail = TRUE,
                                 team_detail = TRUE) {
  plays <- match.arg(plays)
  participants <- match.arg(participants)
  team_participants <- match.arg(team_participants)

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game drives endpoint.")
  }

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/events/{game_id}/competitions/{game_id}/drives",
    "?limit=300&lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      raw <- get_json(url)

      items <- raw[["items"]]
      if (is.null(items) || length(items) == 0) {
        return(df)
      }

      ref_id <- function(ref, what) {
        if (is.na(ref)) return(NA_character_)
        sub(paste0(".*/", what, "/([0-9]+).*"), "\\1", ref)
      }
      sub_ref <- function(x) {
        if (is.list(x)) x[["$ref"]] %||% NA_character_ else NA_character_
      }

      # Null-safe nested-object accessor: obj$a$b -> value or NA.
      nest <- function(obj, ...) {
        keys <- c(...)
        cur <- obj
        for (k in keys) {
          if (!is.list(cur) || is.null(cur[[k]])) return(NULL)
          cur <- cur[[k]]
        }
        cur
      }

      rows <- list()
      for (it in items) {
        team_ref  <- sub_ref(it[["team"]])
        end_team  <- sub_ref(it[["endTeam"]])
        plays_ref <- sub_ref(it[["plays"]])
        st <- it[["start"]]
        en <- it[["end"]]
        te <- it[["timeElapsed"]]
        src <- it[["source"]]

        rows[[length(rows) + 1L]] <- data.frame(
          game_id              = as.character(game_id),
          drive_id             = as.character(it[["id"]] %||% NA),
          sequence_number      = as.character(it[["sequenceNumber"]] %||% NA),
          description          = as.character(it[["description"]] %||% NA),
          team_id              = ref_id(team_ref, "teams"),
          end_team_id          = ref_id(end_team, "teams"),
          start_period         = suppressWarnings(as.integer(nest(st, "period", "number") %||% NA)),
          start_period_type    = as.character(nest(st, "period", "type") %||% NA),
          start_clock          = as.character(nest(st, "clock", "displayValue") %||% NA),
          start_clock_seconds  = suppressWarnings(as.numeric(nest(st, "clock", "value") %||% NA)),
          start_yard_line      = if (is.list(st)) suppressWarnings(as.integer(st[["yardLine"]] %||% NA)) else NA_integer_,
          start_text           = if (is.list(st)) as.character(st[["text"]] %||% NA) else NA_character_,
          end_period           = suppressWarnings(as.integer(nest(en, "period", "number") %||% NA)),
          end_period_type      = as.character(nest(en, "period", "type") %||% NA),
          end_clock            = as.character(nest(en, "clock", "displayValue") %||% NA),
          end_clock_seconds    = suppressWarnings(as.numeric(nest(en, "clock", "value") %||% NA)),
          end_yard_line        = if (is.list(en)) suppressWarnings(as.integer(en[["yardLine"]] %||% NA)) else NA_integer_,
          end_text             = if (is.list(en)) as.character(en[["text"]] %||% NA) else NA_character_,
          time_elapsed         = if (is.list(te)) as.character(te[["displayValue"]] %||% NA) else NA_character_,
          time_elapsed_seconds = if (is.list(te)) suppressWarnings(as.numeric(te[["value"]] %||% NA)) else NA_real_,
          yards                = suppressWarnings(as.integer(it[["yards"]] %||% NA)),
          offensive_plays      = suppressWarnings(as.integer(it[["offensivePlays"]] %||% NA)),
          is_score             = as.logical(it[["isScore"]] %||% NA),
          result               = as.character(it[["result"]] %||% NA),
          short_display_result = as.character(it[["shortDisplayResult"]] %||% NA),
          display_result       = as.character(it[["displayResult"]] %||% NA),
          source_id            = if (is.list(src)) as.character(src[["id"]] %||% NA) else NA_character_,
          source_description   = if (is.list(src)) as.character(src[["description"]] %||% NA) else NA_character_,
          drive_ref            = sub_ref(it),
          team_ref             = team_ref,
          end_team_ref         = end_team,
          plays_ref            = plays_ref,
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the drive-level team-id columns
      # (team_id / end_team_id) once, before the optional plays embedding.
      # Doing it here means: in plays = "expand" mode the drive columns are
      # already enriched before they are `drive_`-prefixed, so the expanded
      # output matches espn_cfb_unnest_plays() of a plays = "list" result.
      # The embedded play tibbles themselves are not team-enriched -- they
      # carry the base espn_cfb_game_pbp schema, identical in both modes.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      # --- optional embedded plays ------------------------------------
      if (plays != "none") {
        drive_ids <- as.character(df[["drive_id"]])

        # Step 1 -- probe the drives payload for inline plays. ESPN often
        # embeds each drive's plays at items[].plays.items[]; when present
        # no further request is needed.
        inline_by_drive <- vector("list", length(items))
        inline_ok <- FALSE
        for (i in seq_along(items)) {
          pl <- items[[i]][["plays"]]
          its <- if (is.list(pl)) pl[["items"]] else NULL
          if (!is.null(its) && length(its) > 0) {
            inline_by_drive[[i]] <- its
            inline_ok <- TRUE
          } else {
            inline_by_drive[[i]] <- list()
          }
        }

        plays_by_drive <- vector("list", length(items))
        names(plays_by_drive) <- drive_ids

        if (inline_ok) {
          # Inline plays present -- use them directly, keyed by drive order.
          for (i in seq_along(items)) {
            plays_by_drive[[i]] <- inline_by_drive[[i]]
          }
        } else {
          # Step 2 -- single competition-level /plays fetch, then partition
          # each play into its drive by the drive id parsed from the play.
          plays_url <- glue::glue(
            "https://sports.core.api.espn.com/v2/sports/football/leagues/",
            "college-football/events/{game_id}/competitions/{game_id}/",
            "plays?limit=300&lang=en&region=us"
          )
          all_plays <- list()
          first_p <- get_json(paste0(plays_url, "&page=1"))
          pc <- suppressWarnings(as.integer(first_p[["pageCount"]] %||% 1L))
          if (is.na(pc) || pc < 1L) pc <- 1L
          for (it in first_p[["items"]] %||% list()) {
            all_plays[[length(all_plays) + 1L]] <- it
          }
          if (pc > 1L) {
            for (p in 2:pc) {
              pg <- get_json(paste0(plays_url, "&page=", p))
              for (it in pg[["items"]] %||% list()) {
                all_plays[[length(all_plays) + 1L]] <- it
              }
            }
          }

          # Each play carries a drive {$ref}; parse the drive id and bucket.
          for (i in seq_along(items)) plays_by_drive[[i]] <- list()
          for (it in all_plays) {
            dref <- if (is.list(it[["drive"]])) {
              it[["drive"]][["$ref"]] %||% NA_character_
            } else {
              NA_character_
            }
            did <- if (!is.na(dref)) {
              sub(".*/drives/([0-9]+).*", "\\1", dref)
            } else {
              NA_character_
            }
            idx <- match(did, drive_ids)
            if (!is.na(idx)) {
              plays_by_drive[[idx]] <-
                c(plays_by_drive[[idx]], list(it))
            }
          }
        }

        # Fetch the roster once -- reused across every drive's plays.
        need_roster <- participants != "none" || isTRUE(participants_list)
        roster_lk <- list()
        if (need_roster) {
          roster_lk <- .espn_cfb_participant_roster(
            game_id,
            position_detail = isTRUE(position_detail) &&
              participants == "wide"
          )
        }

        # Build one full-schema play tibble per drive.
        drive_play_tbls <- lapply(seq_along(items), function(i) {
          .espn_cfb_build_plays_tbl(
            raw_plays              = plays_by_drive[[i]] %||% list(),
            game_id                = game_id,
            participants           = participants,
            participants_list      = participants_list,
            team_participants      = team_participants,
            team_participants_list = team_participants_list,
            roster_lk              = roster_lk
          )
        })

        if (plays == "list") {
          # The drive-level columns are already team-enriched above; the
          # `plays` list-column is appended as-is.
          df[["plays"]] <- drive_play_tbls
          df <- df |>
            make_cfbfastR_data("Game drives data from ESPN", Sys.time())
        } else {
          # plays == "expand" -- flat one-row-per-play table with the
          # (already team-enriched) drive-level columns carried alongside,
          # prefixed `drive_`.
          drive_cols <- df
          colnames(drive_cols) <- paste0("drive_", colnames(drive_cols))
          flat_rows <- list()
          for (i in seq_along(drive_play_tbls)) {
            ptbl <- drive_play_tbls[[i]]
            if (is.null(ptbl) || nrow(ptbl) == 0) next
            dctx <- drive_cols[rep(i, nrow(ptbl)), , drop = FALSE]
            flat_rows[[length(flat_rows) + 1L]] <-
              dplyr::bind_cols(dctx, ptbl)
          }
          if (length(flat_rows) == 0) {
            return(df)
          }
          df <- dplyr::bind_rows(flat_rows) |>
            dplyr::as_tibble() |>
            make_cfbfastR_data("Game drive plays (expanded) data from ESPN",
                               Sys.time())
        }
      } else {
        df <- df |>
          make_cfbfastR_data("Game drives data from ESPN", Sys.time())
      }
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game drives data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **Unnest ESPN CFB drive plays into a flat play-by-play table**
#' @description Turn a [espn_cfb_game_drives()] result carrying a `plays`
#' list-column (produced with `plays = "list"`) into the flat
#' one-row-per-play table -- every play in the full [espn_cfb_game_pbp()]
#' schema with its drive-level columns carried alongside, prefixed `drive_`.
#' @details Pure transform -- no HTTP. `espn_cfb_unnest_plays()` unnests the
#' `plays` list-column appended by `espn_cfb_game_drives(..., plays = "list")`
#' and carries every drive-level column alongside each play, prefixed
#' `drive_` (e.g. `drive_id`, `drive_result`, `drive_yards`,
#' `drive_start_yard_line`) so it never collides with the play's own
#' columns. The result is identical in shape to
#' `espn_cfb_game_drives(..., plays = "expand")` -- the same flat table, one
#' route via the `plays` argument, the other via this auxiliary function.
#'
#' If `drives` does not carry a `plays` list-column the function aborts with
#' a message telling the caller to run
#' `espn_cfb_game_drives(..., plays = "list")` first.
#' @param drives (*data.frame* required): a data frame produced by
#' `espn_cfb_game_drives(..., plays = "list")` -- i.e. carrying a `plays`
#' list-column of full-schema play tibbles.
#' @return A data frame with one row per play:
#'
#'    |col_name      |types     |description                                                |
#'    |:-------------|:---------|:----------------------------------------------------------|
#'    |drive_game_id |character |ESPN game identifier (drive-level column, `drive_`-prefixed). |
#'    |drive_id      |character |ESPN drive id the play belongs to (`drive_`-prefixed).     |
#'    |drive_result  |character |Drive result code (`drive_`-prefixed; every drive-level column is carried with this prefix). |
#'    |game_id       |character |ESPN game identifier (play-level column).                  |
#'    |play_id       |character |ESPN play id.                                              |
#'    |...           |          |Every remaining [espn_cfb_game_pbp()] play column, plus any optional participant columns present in the embedded tibbles. |
#'
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows bind_cols
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Drives Plays Unnest
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_unnest_plays(espn_cfb_game_drives(401628339,
#'                                                  plays = "list")))
#' }
espn_cfb_unnest_plays <- function(drives) {
  if (missing(drives) || is.null(drives) || !is.data.frame(drives) ||
      !("plays" %in% colnames(drives)) || !is.list(drives[["plays"]])) {
    cli::cli_abort(c(
      "{.arg drives} must carry a {.code plays} list-column.",
      "i" = paste0(
        "Run {.code espn_cfb_game_drives(..., plays = \"list\")} first, ",
        "then pass its result to {.fn espn_cfb_unnest_plays}."
      )
    ))
  }

  play_tbls <- drives[["plays"]]
  drive_cols <- drives[, setdiff(colnames(drives), "plays"), drop = FALSE]
  colnames(drive_cols) <- paste0("drive_", colnames(drive_cols))

  flat_rows <- list()
  for (i in seq_len(nrow(drives))) {
    ptbl <- play_tbls[[i]]
    if (is.null(ptbl) || !is.data.frame(ptbl) || nrow(ptbl) == 0) next
    dctx <- drive_cols[rep(i, nrow(ptbl)), , drop = FALSE]
    flat_rows[[length(flat_rows) + 1L]] <- dplyr::bind_cols(dctx, ptbl)
  }

  if (length(flat_rows) == 0) {
    # No plays anywhere -- return an empty flat frame in a stable shape.
    empty <- if (nrow(drives) > 0 && is.data.frame(play_tbls[[1]])) {
      dplyr::bind_cols(
        drive_cols[0, , drop = FALSE],
        play_tbls[[1]][0, , drop = FALSE]
      )
    } else {
      drive_cols[0, , drop = FALSE]
    }
    return(dplyr::as_tibble(empty))
  }

  dplyr::bind_rows(flat_rows) |>
    dplyr::as_tibble() |>
    make_cfbfastR_data("Game drive plays (unnested) data from ESPN",
                       Sys.time())
}


#' @title
#' **ESPN College Football Game Leaders**
#' @description Get the per-game statistical leaders for a single college
#' football game -- one row per leader within each statistical category,
#' both teams combined.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/leaders`. The competition id
#' always equals the game id. Returns one row per leader within each
#' leader category (passing, rushing, receiving, ...). ESPN publishes
#' roughly 22 categories per game; each category lists a small number of
#' leading athletes. This is the game-wide leaders resource -- distinct from
#' [espn_cfb_game_team_leaders()], which returns the leaders for a single
#' competitor (team).
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`, inserted immediately after
#' `team_id`.
#' A catalog failure degrades to `NA` rather than erroring the wrapper. Set
#' `team_detail = FALSE` to skip the catalog fetch and the join.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per leader-in-category:
#'
#'    |col_name                   |types     |description                                            |
#'    |:--------------------------|:---------|:------------------------------------------------------|
#'    |game_id                    |character |ESPN game identifier.                                  |
#'    |category_name              |character |Leader-category key (e.g. `passingLeader`).            |
#'    |category_display_name      |character |Human-readable leader-category name.                   |
#'    |category_short_display_name|character |Short human-readable leader-category name.             |
#'    |category_abbreviation      |character |Leader-category abbreviation.                          |
#'    |leader_rank                |integer   |Rank of the athlete within the category (1 = top).     |
#'    |athlete_id                 |character |ESPN athlete id (parsed from `athlete_ref`).           |
#'    |team_id                    |character |ESPN team id of the athlete's team (parsed from `team_ref`). |
#'    |team_name                  |character |Team nickname; `team_detail = TRUE` only.              |
#'    |team_abbreviation          |character |Team abbreviation; `team_detail = TRUE` only.          |
#'    |team_location              |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name          |character |Full team display name; `team_detail = TRUE` only.     |
#'    |team_short_display_name    |character |Short team display name; `team_detail = TRUE` only.    |
#'    |team_nickname              |character |Team nickname label; `team_detail = TRUE` only.        |
#'    |team_color                 |character |Primary team color; `team_detail = TRUE` only.         |
#'    |team_alternate_color       |character |Alternate team color; `team_detail = TRUE` only.       |
#'    |team_logo_href             |character |Default team logo URL; `team_detail = TRUE` only.      |
#'    |team_logo_dark_href        |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |display_value              |character |Display-formatted stat line for the leader.            |
#'    |value                      |numeric   |Numeric leading-stat value.                            |
#'    |athlete_ref                |character |`$ref` URL to the athlete resource.                    |
#'    |team_ref                   |character |`$ref` URL to the team resource.                       |
#'    |statistics_ref             |character |`$ref` URL to the athlete's game-statistics resource.  |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Leaders
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_leaders(game_id = 401628339))
#'   try(espn_cfb_game_leaders(game_id = 401628339, team_detail = FALSE))
#' }
espn_cfb_game_leaders <- function(game_id = NULL, team_detail = TRUE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game leaders endpoint.")
  }

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/events/{game_id}/competitions/{game_id}/leaders",
    "?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)

      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      categories <- raw[["categories"]]
      if (is.null(categories) || length(categories) == 0) {
        return(df)
      }

      sub_ref <- function(x) {
        if (is.list(x)) x[["$ref"]] %||% NA_character_ else NA_character_
      }
      ref_id <- function(ref, what) {
        if (is.na(ref)) return(NA_character_)
        sub(paste0(".*/", what, "/([0-9]+).*"), "\\1", ref)
      }

      rows <- list()
      for (cat in categories) {
        leaders <- cat[["leaders"]]
        if (is.null(leaders) || length(leaders) == 0) next
        rank <- 0L
        for (ld in leaders) {
          rank <- rank + 1L
          athlete_ref <- sub_ref(ld[["athlete"]])
          team_ref    <- sub_ref(ld[["team"]])

          rows[[length(rows) + 1L]] <- data.frame(
            game_id                     = as.character(game_id),
            category_name               = as.character(cat[["name"]] %||% NA),
            category_display_name       = as.character(cat[["displayName"]] %||% NA),
            category_short_display_name = as.character(cat[["shortDisplayName"]] %||% NA),
            category_abbreviation       = as.character(cat[["abbreviation"]] %||% NA),
            leader_rank                 = rank,
            athlete_id                  = ref_id(athlete_ref, "athletes"),
            team_id                     = ref_id(team_ref, "teams"),
            display_value               = as.character(ld[["displayValue"]] %||% NA),
            value                       = suppressWarnings(as.numeric(ld[["value"]] %||% NA)),
            athlete_ref                 = athlete_ref,
            team_ref                    = team_ref,
            statistics_ref              = sub_ref(ld[["statistics"]]),
            stringsAsFactors            = FALSE
          )
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      leaders_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        leaders_df <- .espn_cfb_attach_team_detail(
          leaders_df, .espn_cfb_team_lookup()
        )
      }

      df <- leaders_df |>
        make_cfbfastR_data("Game leaders data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game leaders data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Odds**
#' @description Get the sportsbook betting lines (spread, over/under,
#' moneyline) for a single college football game -- one row per provider.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/odds`. Returns one row per
#' odds provider (sportsbook). `details` is ESPN's headline line string
#' (e.g. `"UGA -54.5"`); `spread` and `over_under` are the numeric spread
#' and total. Home/away spread odds and moneylines are pulled from the
#' nested `homeTeamOdds` / `awayTeamOdds` blocks. The `over_odds` and
#' `under_odds` are the American-odds prices on the game total. With
#' `line_history = TRUE` the per-provider `open` / `close` / `current`
#' line snapshots are expanded instead (see *Details*).
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param line_history (*Logical*): controls the output shape. One of:
#'
#'   * `FALSE` (default) -- the summary output, one row per odds
#'     provider, with the columns shown in the *Value* table below.
#'   * `TRUE` -- a long frame capturing the `open` / `close` /
#'     `current` line snapshots, one row per
#'     (provider x snapshot x market) (see *Details*).
#'
#' @return A data frame with one row per odds provider (when
#' `line_history = FALSE`):
#'
#'    |col_name           |types     |description                                            |
#'    |:------------------|:---------|:------------------------------------------------------|
#'    |game_id            |character |ESPN game identifier.                                  |
#'    |provider_id        |character |ESPN odds-provider (sportsbook) id.                    |
#'    |provider_name      |character |Odds-provider name (e.g. `ESPN BET`).                  |
#'    |provider_priority  |integer   |ESPN display priority of the odds provider.            |
#'    |details            |character |ESPN's headline line string (e.g. `UGA -54.5`).        |
#'    |over_under         |numeric   |Game total (over/under) points line.                   |
#'    |spread             |numeric   |Point spread (negative favors the home team).          |
#'    |over_odds          |numeric   |American odds price on the over.                       |
#'    |under_odds         |numeric   |American odds price on the under.                      |
#'    |home_favorite      |logical   |`TRUE` if the home team is the favorite.               |
#'    |home_underdog      |logical   |`TRUE` if the home team is the underdog.               |
#'    |away_favorite      |logical   |`TRUE` if the away team is the favorite.               |
#'    |away_underdog      |logical   |`TRUE` if the away team is the underdog.               |
#'    |home_spread_odds   |numeric   |American odds price on the home-team spread.           |
#'    |away_spread_odds   |numeric   |American odds price on the away-team spread.           |
#'    |home_money_line    |character |Home-team moneyline (American odds).                   |
#'    |away_money_line    |character |Away-team moneyline (American odds).                   |
#'    |moneyline_winner   |logical   |`TRUE` if the moneyline favorite won.                  |
#'    |spread_winner      |logical   |`TRUE` if the spread favorite covered.                 |
#'
#' @details
#' When `line_history = TRUE` the returned frame is in long format, one row
#' per (provider x snapshot x market), with columns: `game_id`,
#' `provider_id`, `provider_name`, `snapshot` (one of `open`, `close`,
#' `current`), `market` (e.g. `over`, `under`, `total`, `pointSpread`,
#' `spread`, `moneyLine`), `side` (`game`, `home`, or `away`), `american`
#' (the American-odds string), `value` (the numeric/decimal value), and
#' `display_value`.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Odds Betting
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_odds(game_id = 401628339))
#'   try(espn_cfb_game_odds(game_id = 401628339, line_history = TRUE))
#' }
espn_cfb_game_odds <- function(game_id = NULL, line_history = FALSE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game odds endpoint.")
  }

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/events/{game_id}/competitions/{game_id}/odds",
    "?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)

      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]]
      if (is.null(items) || length(items) == 0) {
        return(df)
      }

      # Moneyline lives either as a top-level `moneyLine` numeric on the
      # team-odds block, or nested under `current$moneyLine$american`.
      # Some games (heavy favorites) carry no moneyline at all.
      money_line <- function(side_odds) {
        if (!is.list(side_odds)) return(NA_character_)
        top <- side_odds[["moneyLine"]]
        if (!is.null(top)) return(as.character(top))
        cur <- side_odds[["current"]]
        if (is.list(cur) && is.list(cur[["moneyLine"]])) {
          return(as.character(cur[["moneyLine"]][["american"]] %||% NA))
        }
        NA_character_
      }

      rows <- list()

      if (isTRUE(line_history)) {
        # One row per (provider x snapshot x market) for the open/close/
        # current line snapshots. `side` = game (game-total snapshots) /
        # home / away (per-team spread + moneyline snapshots).
        add_market <- function(prov_id, prov_nm, snap, side, market, m) {
          if (!is.list(m)) return(invisible(NULL))
          rows[[length(rows) + 1L]] <<- data.frame(
            game_id       = as.character(game_id),
            provider_id   = prov_id,
            provider_name = prov_nm,
            snapshot      = snap,
            market        = market,
            side          = side,
            american      = as.character(m[["american"]] %||% NA),
            value         = suppressWarnings(as.numeric(m[["value"]] %||% NA)),
            display_value = as.character(m[["displayValue"]] %||% NA),
            stringsAsFactors = FALSE
          )
        }
        for (it in items) {
          prov <- it[["provider"]]
          prov_id <- if (is.list(prov)) as.character(prov[["id"]] %||% NA) else NA_character_
          prov_nm <- if (is.list(prov)) as.character(prov[["name"]] %||% NA) else NA_character_

          for (snap in c("open", "close", "current")) {
            # game-total snapshot block: over / under / total markets
            blk <- it[[snap]]
            if (is.list(blk)) {
              for (mk in names(blk)) {
                add_market(prov_id, prov_nm, snap, "game", mk, blk[[mk]])
              }
            }
            # per-team snapshot blocks: pointSpread / spread / moneyLine
            for (side in c("home", "away")) {
              side_blk <- it[[paste0(side, "TeamOdds")]]
              if (!is.list(side_blk)) next
              s <- side_blk[[snap]]
              if (!is.list(s)) next
              for (mk in names(s)) {
                if (mk == "favorite") next
                add_market(prov_id, prov_nm, snap, side, mk, s[[mk]])
              }
            }
          }
        }

        if (length(rows) == 0) {
          return(df)
        }

        df <- dplyr::bind_rows(rows) |>
          dplyr::as_tibble() |>
          make_cfbfastR_data("Game odds line history data from ESPN", Sys.time())
        return(df)
      }

      for (it in items) {
        prov <- it[["provider"]]
        prov_id <- if (is.list(prov)) as.character(prov[["id"]] %||% NA) else NA_character_
        prov_nm <- if (is.list(prov)) prov[["name"]] %||% NA_character_ else NA_character_
        prov_pr <- if (is.list(prov)) suppressWarnings(as.integer(prov[["priority"]] %||% NA)) else NA_integer_

        hto <- it[["homeTeamOdds"]]
        ato <- it[["awayTeamOdds"]]
        home_fav <- if (is.list(hto)) as.logical(hto[["favorite"]] %||% NA) else NA
        home_dog <- if (is.list(hto)) as.logical(hto[["underdog"]] %||% NA) else NA
        away_fav <- if (is.list(ato)) as.logical(ato[["favorite"]] %||% NA) else NA
        away_dog <- if (is.list(ato)) as.logical(ato[["underdog"]] %||% NA) else NA
        home_so  <- if (is.list(hto)) suppressWarnings(as.numeric(hto[["spreadOdds"]] %||% NA)) else NA_real_
        away_so  <- if (is.list(ato)) suppressWarnings(as.numeric(ato[["spreadOdds"]] %||% NA)) else NA_real_

        rows[[length(rows) + 1L]] <- data.frame(
          game_id           = as.character(game_id),
          provider_id       = prov_id,
          provider_name     = prov_nm,
          provider_priority = prov_pr,
          details           = it[["details"]] %||% NA_character_,
          over_under        = suppressWarnings(as.numeric(it[["overUnder"]] %||% NA)),
          spread            = suppressWarnings(as.numeric(it[["spread"]] %||% NA)),
          over_odds         = suppressWarnings(as.numeric(it[["overOdds"]] %||% NA)),
          under_odds        = suppressWarnings(as.numeric(it[["underOdds"]] %||% NA)),
          home_favorite     = home_fav,
          home_underdog     = home_dog,
          away_favorite     = away_fav,
          away_underdog     = away_dog,
          home_spread_odds  = home_so,
          away_spread_odds  = away_so,
          home_money_line   = money_line(hto),
          away_money_line   = money_line(ato),
          moneyline_winner  = as.logical(it[["moneylineWinner"]] %||% NA),
          spread_winner     = as.logical(it[["spreadWinner"]] %||% NA),
          stringsAsFactors  = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble() |>
        make_cfbfastR_data("Game odds data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game odds data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Plays (Core-v2 Play-by-Play)**
#' @description Get the full core-v2 play-by-play feed for a single college
#' football game -- one row per play, with down/distance, clock, score, and
#' yardage.
#' @details Wraps the paginated ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/plays`. The endpoint is
#' paginated; this wrapper loops every page and stacks the results into one
#' frame -- one row per play. Each play carries the start and end
#' down/distance/yard-line, the play type, period and game clock, the
#' running score, and the offensive team.
#'
#' This is the core-v2 play feed, distinct from [espn_cfb_pbp()], which
#' parses the site-v2 game-summary feed and (optionally) computes EPA/WPA.
#' Use this wrapper when you want the raw core-v2 play schema with stable
#' `$ref`-derived ids; use [espn_cfb_pbp()] for the modeled play-by-play.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param participants (*Character*): controls whether each play's nested
#' `participants[]` array (the athletes credited on the play) is attached.
#' One of:
#'
#'   * `"none"` (default) -- the play frame is returned unchanged; no
#'     extra HTTP call is made.
#'   * `"wide"` -- one row per play, with type-keyed
#'     `{type}_player_*` columns appended (see *Details*).
#'   * `"long"` -- one row per play x participant (see *Details*).
#'
#' @param participants_list (*Logical*): when `TRUE`, append a single
#' list-column named `participants` holding each play's full participant
#' detail -- including the per-participant `stats[]` that `"wide"` mode
#' drops. Defaults to `FALSE`. This is **independent of and combinable
#' with** the `participants` argument (see *Details*).
#' @param team_participants (*Character*): controls whether each play's
#' nested `teamParticipants[]` array (the team(s) credited on the play) is
#' attached as type-keyed columns. One of:
#'
#'   * `"none"` (default) -- no team-participant columns are added.
#'   * `"wide"` -- one row per play, with type-keyed `{type}_team_*`
#'     columns appended (see *Details*).
#'
#' @param team_participants_list (*Logical*): when `TRUE`, append a single
#' list-column named `team_participants` holding each play's full
#' `teamParticipants[]` detail as a nested tibble. Defaults to `FALSE`.
#' This is **independent of and combinable with** the `team_participants`
#' argument (see *Details*).
#' @param team_detail (*Logical*): when `TRUE` (default), the ESPN team
#' catalog ([espn_cfb_teams()]) is fetched once and friendly team fields
#' are joined in next to every team-id column in the output (`team_id`,
#' `start_team_id`, `end_team_id`, plus any optional `{type}_team_id` /
#' `{type}_player_team_id` columns). For each id column `X_id` the sibling
#' columns `X_name`, `X_abbreviation`, `X_location`, `X_display_name`,
#' `X_short_display_name`, `X_nickname`, `X_color`, `X_alternate_color`,
#' `X_logo_href`, `X_logo_dark_href` are inserted immediately
#' after it. A catalog failure degrades to `NA` rather than erroring the
#' wrapper. Set `FALSE` to skip the catalog fetch and the join.
#' @return A data frame with one row per play:
#'
#'    |col_name                        |types     |description                                            |
#'    |:-------------------------------|:---------|:------------------------------------------------------|
#'    |game_id                         |character |ESPN game identifier.                                  |
#'    |play_id                         |character |ESPN play id.                                          |
#'    |sequence_number                 |character |Play sequence number within the game.                  |
#'    |type_id                         |character |Play-type id.                                          |
#'    |type_text                       |character |Play-type text (e.g. `Pass Reception`).                |
#'    |type_abbreviation               |character |Play-type abbreviation (e.g. `RUSH`, `TD`).            |
#'    |text                            |character |Full play description.                                 |
#'    |short_text                      |character |Short play description.                                |
#'    |alternative_text                |character |Alternative play description.                          |
#'    |short_alternative_text          |character |Short alternative play description.                    |
#'    |period                          |integer   |Period (quarter) number.                               |
#'    |clock                           |character |Game clock display value at the play (`MM:SS`).        |
#'    |clock_seconds                   |numeric   |Game clock value in seconds at the play.               |
#'    |home_score                      |integer   |Home-team score after the play.                        |
#'    |away_score                      |integer   |Away-team score after the play.                        |
#'    |scoring_play                    |logical   |`TRUE` if the play resulted in a score.                |
#'    |score_value                     |integer   |Points scored on the play.                             |
#'    |priority                        |logical   |`TRUE` if ESPN flags the play as a priority highlight. |
#'    |is_penalty                      |logical   |`TRUE` if the play was a penalty.                      |
#'    |is_turnover                     |logical   |`TRUE` if the play was a turnover.                     |
#'    |stat_yardage                    |integer   |Yards gained or lost on the play.                      |
#'    |scoring_type_name               |character |Scoring-type key on a scoring play (e.g. `touchdown`). |
#'    |scoring_type_display_name       |character |Human-readable scoring-type name.                      |
#'    |scoring_type_abbreviation       |character |Scoring-type abbreviation (e.g. `TD`, `FG`).           |
#'    |point_after_attempt_id          |integer   |Point-after-attempt id on a scoring play.              |
#'    |point_after_attempt_text        |character |Point-after-attempt text (e.g. `Extra Point Good`).    |
#'    |point_after_attempt_abbreviation|character |Point-after-attempt abbreviation.                      |
#'    |point_after_attempt_value       |integer   |Points added by the point-after attempt.               |
#'    |start_down                      |integer   |Down at the start of the play.                         |
#'    |start_distance                  |integer   |Yards to go at the start of the play.                  |
#'    |start_yard_line                 |integer   |Yard line at the start of the play.                    |
#'    |start_yards_to_endzone          |integer   |Yards to the end zone at the start of the play.        |
#'    |start_down_distance_text        |character |Down-and-distance text at the start of the play.       |
#'    |start_short_down_distance_text  |character |Short down-and-distance text at the start of the play. |
#'    |start_possession_text           |character |Field-position text at the start of the play.          |
#'    |start_team_id                   |character |ESPN team id in possession at the start of the play.   |
#'    |end_down                        |integer   |Down at the end of the play.                           |
#'    |end_distance                    |integer   |Yards to go at the end of the play.                    |
#'    |end_yard_line                   |integer   |Yard line at the end of the play.                      |
#'    |end_yards_to_endzone            |integer   |Yards to the end zone at the end of the play.          |
#'    |end_down_distance_text          |character |Down-and-distance text at the end of the play.         |
#'    |end_short_down_distance_text    |character |Short down-and-distance text at the end of the play.   |
#'    |end_possession_text             |character |Field-position text at the end of the play.            |
#'    |end_team_id                     |character |ESPN team id in possession at the end of the play.     |
#'    |team_id                         |character |ESPN team id of the offensive team (parsed from `team_ref`). |
#'    |drive_play_id                   |character |ESPN drive id the play belongs to (parsed from `drive_ref`). |
#'    |wallclock                       |character |Real-world ISO timestamp of the play.                  |
#'    |modified                        |character |ISO timestamp the play record was last modified.       |
#'    |play_ref                        |character |`$ref` URL to the play resource itself.                |
#'    |team_ref                        |character |`$ref` URL to the offensive team resource.             |
#'    |start_team_ref                  |character |`$ref` URL to the team in possession at the play start.|
#'    |end_team_ref                    |character |`$ref` URL to the team in possession at the play end.  |
#'    |drive_ref                       |character |`$ref` URL to the play's drive resource.               |
#'    |probability_ref                 |character |`$ref` URL to the play's win-probability resource.     |
#'
#' The optional participant and team-participant columns are described in
#' *Details* -- they are added only when the corresponding argument
#' requests them.
#'
#' @details
#' When `participants = "wide"`, the base play schema is kept intact and
#' six columns are appended for every participant `type` that appears
#' anywhere in the game. The column names are **dynamic** -- one set per
#' participant type present (e.g. `passer`, `rusher`, `receiver`,
#' `tackler`, `sacked_by`, `pass_defender`, `kicker`, `returner`). ESPN's
#' camelCase types are snake-cased (`sackedBy` -> `sacked_by`). For each
#' type the appended columns are:
#'
#'   * `{type}_player_id` -- scalar character, the **first**
#'     occurrence of that type on the play (`NA` if none).
#'   * `{type}_player_name` -- scalar character, that athlete's
#'     roster-joined name (`NA` if none or unmatched).
#'   * `{type}_player_position` -- scalar character, the first
#'     athlete's position abbreviation (joined from the ESPN position
#'     catalog; `NA` if unmatched).
#'   * `{type}_player_position_name` -- scalar character, the first
#'     athlete's position name.
#'   * `{type}_player_ids` -- a **list-column**: a character vector
#'     of **every** athlete id of that type on the play, in ESPN order.
#'     Plays with none carry `character(0)`.
#'   * `{type}_player_names` -- a **list-column**: the parallel
#'     vector of roster-joined names.
#'
#' Participant `stats[]` are not carried in wide mode -- use `"long"` for
#' the per-participant stat lines.
#'
#' When `participants = "long"`, the frame is expanded to one row per
#' play x participant with `participant_index`, `participant_athlete_id`,
#' `participant_type`, `participant_order`, the roster-joined
#' `participant_athlete_name` / `participant_position` /
#' `participant_jersey` / `participant_team_id`, and the participant's
#' stats pivoted to named `pstat_<statname>` columns. Plays with zero
#' participants still yield one row (participant fields `NA`).
#'
#' When `participants_list = TRUE`, a single list-column named
#' `participants` is appended. Each cell is a tibble with one row per
#' participant on that play and columns `participant_index` (1-based, ESPN
#' order), `type` (snake_cased, e.g. `sacked_by`, `pass_defender`),
#' `athlete_id`, `athlete_name` (roster-joined), `order`, `position_id`,
#' plus one column per participant `stat[]` name (`dplyr::bind_rows`
#' NA-fills participants whose stat sets differ). Plays with no
#' participants carry an empty 0-row tibble, never `NULL`. This option is
#' independent of `participants` and composes with any of its modes -- e.g.
#' `participants = "wide", participants_list = TRUE` yields the type-keyed
#' `{type}_player_*` columns **and** the `participants` list-column, while
#' `participants = "none", participants_list = TRUE` adds only the
#' list-column. With `participants = "long"` the list-column repeats per
#' play x participant row. The raw plays are fetched only once even when
#' both options are active.
#'
#' When `team_participants = "wide"`, three columns are appended for every
#' `teamParticipants[]` `type` present anywhere in the game (ESPN ships
#' `offense` / `defense`). The column names are **dynamic** -- one set per
#' type, snake-cased: `{type}_team_id` (scalar character, the first
#' occurrence of that type on the play), `{type}_team_order` (scalar
#' integer, ESPN's display order), and `{type}_team_ref` (scalar
#' character, the `$ref` URL to that team resource). Plays with none of a
#' type carry `NA`.
#'
#' When `team_participants_list = TRUE`, a single list-column named
#' `team_participants` is appended. Each cell is a tibble with one row per
#' team credited on the play and columns `team_participant_index`
#' (1-based, ESPN order), `team_id`, `team_ref`, `order`, and `type`
#' (e.g. `offense`, `defense`). A play with no team participants carries
#' an empty 0-row tibble, never `NULL`. This option is independent of
#' `team_participants` and composes with it -- e.g.
#' `team_participants = "wide", team_participants_list = TRUE` yields both
#' the type-keyed `{type}_team_*` columns **and** the `team_participants`
#' list-column, while `team_participants = "none"` adds neither.
#'
#' When `team_detail = TRUE` (the default), the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and joined onto **every** team-id
#' column the output carries -- the base `team_id` / `start_team_id` /
#' `end_team_id`, plus any optional `{type}_team_id` (from
#' `team_participants = "wide"`) and `{type}_player_team_id` (from
#' `participants = "long"`) columns. For each id column `X_id` the friendly
#' siblings `X_name`, `X_abbreviation`, `X_location`, `X_display_name`,
#' `X_short_display_name`, `X_nickname`, `X_color`, `X_alternate_color`,
#' `X_logo_href`, and `X_logo_dark_href` are inserted
#' immediately after it (e.g. `team_id` -> `team_name`,
#' `team_abbreviation`, ...; `start_team_id` -> `start_team_name`, ...).
#' Rows whose id is missing or unmatched receive `NA`, and a catalog-fetch
#' failure degrades the whole set to `NA` rather than erroring the wrapper.
#' With `team_detail = FALSE` the friendly columns (and the catalog fetch)
#' are skipped.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows bind_cols tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Plays PBP
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_pbp(game_id = 401628339))
#'   try(espn_cfb_game_pbp(game_id = 401628339, participants = "wide"))
#'   try(espn_cfb_game_pbp(game_id = 401628339, participants = "wide",
#'                         participants_list = TRUE))
#'   try(espn_cfb_game_pbp(game_id = 401628339, team_participants = "wide",
#'                         team_participants_list = TRUE))
#'   try(espn_cfb_game_pbp(game_id = 401628339, team_detail = FALSE))
#' }
espn_cfb_game_pbp <- function(game_id = NULL,
                              participants = c("none", "wide", "long"),
                              participants_list = FALSE,
                              team_participants = c("none", "wide"),
                              team_participants_list = FALSE,
                              team_detail = TRUE) {
  participants <- match.arg(participants)
  team_participants <- match.arg(team_participants)

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game plays endpoint.")
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      base_url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}/competitions/{game_id}/",
        "plays?limit=300&lang=en&region=us"
      )
      first <- get_json(paste0(base_url, "&page=1"))
      page_count <- suppressWarnings(as.integer(first[["pageCount"]] %||% 1L))
      if (is.na(page_count) || page_count < 1L) page_count <- 1L

      rows <- list()
      raw_plays <- list()
      add_items <- function(items) {
        for (it in items %||% list()) {
          raw_plays[[length(raw_plays) + 1L]] <<- it
          rows[[length(rows) + 1L]] <<- .espn_cfb_play_row(it, game_id = game_id)
        }
      }

      add_items(first[["items"]])
      if (page_count > 1L) {
        for (p in 2:page_count) {
          pg <- get_json(paste0(base_url, "&page=", p))
          add_items(pg[["items"]])
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      plays_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # teamParticipants[] -- opt-in, mirroring participants. "wide" emits
      # type-keyed {type}_team_* columns; team_participants_list = TRUE
      # appends the nested team_participants list-column. The two compose.
      if (team_participants != "none") {
        plays_df <- .espn_cfb_attach_team_participants(plays_df, raw_plays)
      }
      if (isTRUE(team_participants_list)) {
        plays_df <- .espn_cfb_attach_team_participants_list(
          plays_df, raw_plays
        )
      }

      # Fetch the game roster at most once, reused by both the participants
      # flattening and the participants list-column. The roster lookup is
      # enriched with the position catalog (position_detail = TRUE) so the
      # wide participants output carries {type}_player_position detail.
      roster_lk <- list()
      if (participants != "none" || isTRUE(participants_list)) {
        roster_lk <- .espn_cfb_participant_roster(
          game_id, position_detail = (participants == "wide")
        )
      }

      if (isTRUE(participants_list)) {
        plays_df <- .espn_cfb_attach_participants_list(
          plays_df, raw_plays, roster_lk = roster_lk
        )
      }

      if (participants != "none") {
        plays_df <- .espn_cfb_attach_participants(
          plays_df, raw_plays, roster_lk = roster_lk, mode = participants
        )
      }

      # Join the ESPN team catalog onto every team-id column when requested
      # -- adds the friendly {col}_name / _abbreviation / _location / ...
      # siblings. team_detail = FALSE skips the fetch and the join.
      if (isTRUE(team_detail)) {
        team_lk <- .espn_cfb_team_lookup()
        plays_df <- .espn_cfb_attach_team_detail(plays_df, team_lk)
      }

      df <- plays_df |>
        make_cfbfastR_data("Game plays data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game plays data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Play (Single Play Detail)**
#' @description Get the full detail object for a single play of a college
#' football game -- one row with the play type, text, score, clock,
#' down/distance, and win-probability delta.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/plays/{play_id}`. The competition
#' id always equals the game id. Returns a single-row data frame describing
#' one play in full. Harvest the `play_id` from the competition-level
#' [espn_cfb_game_pbp()] feed (its `play_id` column) or from
#' [espn_cfb_game_drive_plays()]. Use this wrapper for play drill-down when
#' you need a single play's complete object rather than the whole game feed.
#'
#' ESPN play ids are 18-digit integers that exceed R's exact
#' double-precision range -- **pass `play_id` as a character string** (e.g.
#' `"401628339101927401"`) so no precision is lost. A bare numeric literal
#' will be silently rounded and the lookup will 404.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param play_id (*Character* required): ESPN play id (from
#' [espn_cfb_game_pbp()]). Supply as a character string -- the id is too
#' large for an exact numeric.
#' @param participants (*Character*): controls whether the play's nested
#' `participants[]` array (the athletes credited on the play) is attached.
#' One of:
#'
#'   * `"none"` (default) -- the single-row play frame is returned
#'     unchanged; no extra HTTP call is made.
#'   * `"wide"` -- the single row gains type-keyed `{type}_player_*`
#'     columns (see *Details*).
#'   * `"long"` -- the frame is expanded to one row per participant
#'     (see *Details*).
#'
#' @param participants_list (*Logical*): when `TRUE`, append a single
#' list-column named `participants` holding the play's full participant
#' detail -- including the per-participant `stats[]` that `"wide"` mode
#' drops. Defaults to `FALSE`. This is **independent of and combinable
#' with** the `participants` argument (see *Details*).
#' @param team_participants (*Character*): controls whether the play's
#' nested `teamParticipants[]` array (the team(s) credited on the play) is
#' attached as type-keyed columns. One of:
#'
#'   * `"none"` (default) -- no team-participant columns are added.
#'   * `"wide"` -- the single row gains type-keyed `{type}_team_*`
#'     columns (see *Details*).
#'
#' @param team_participants_list (*Logical*): when `TRUE`, append a single
#' list-column named `team_participants` holding the play's full
#' `teamParticipants[]` detail as a nested tibble. Defaults to `FALSE`.
#' This is **independent of and combinable with** the `team_participants`
#' argument (see *Details*).
#' @param team_detail (*Logical*): when `TRUE` (default), the ESPN team
#' catalog ([espn_cfb_teams()]) is fetched once and friendly team fields
#' are joined in next to every team-id column in the output (`team_id`,
#' `start_team_id`, `end_team_id`, plus any optional `{type}_team_id` /
#' `{type}_player_team_id` columns). For each id column `X_id` the sibling
#' columns `X_name`, `X_abbreviation`, `X_location`, `X_display_name`,
#' `X_short_display_name`, `X_nickname`, `X_color`, `X_alternate_color`,
#' `X_logo_href`, `X_logo_dark_href` are inserted immediately
#' after it. A catalog failure degrades to `NA` rather than erroring the
#' wrapper. Set `FALSE` to skip the catalog fetch and the join.
#' @return A data frame with one row describing the play:
#'
#'    |col_name                        |types     |description                                            |
#'    |:-------------------------------|:---------|:------------------------------------------------------|
#'    |game_id                         |character |ESPN game identifier.                                  |
#'    |play_id                         |character |ESPN play id.                                          |
#'    |sequence_number                 |character |Play sequence number within the game.                  |
#'    |type_id                         |character |Play-type id.                                          |
#'    |type_text                       |character |Play-type text (e.g. `Pass Reception`).                |
#'    |type_abbreviation               |character |Play-type abbreviation (e.g. `RUSH`, `TD`).            |
#'    |text                            |character |Full play description.                                 |
#'    |short_text                      |character |Short play description.                                |
#'    |alternative_text                |character |Alternative play description.                          |
#'    |short_alternative_text          |character |Short alternative play description.                    |
#'    |period                          |integer   |Period (quarter) number.                               |
#'    |clock                           |character |Game clock display value at the play (`MM:SS`).        |
#'    |clock_seconds                   |numeric   |Game clock value in seconds at the play.               |
#'    |home_score                      |integer   |Home-team score after the play.                        |
#'    |away_score                      |integer   |Away-team score after the play.                        |
#'    |scoring_play                    |logical   |`TRUE` if the play resulted in a score.                |
#'    |score_value                     |integer   |Points scored on the play.                             |
#'    |priority                        |logical   |`TRUE` if ESPN flags the play as a priority highlight. |
#'    |is_penalty                      |logical   |`TRUE` if the play was a penalty.                      |
#'    |is_turnover                     |logical   |`TRUE` if the play was a turnover.                     |
#'    |stat_yardage                    |integer   |Yards gained or lost on the play.                      |
#'    |scoring_type_name               |character |Scoring-type key on a scoring play (e.g. `touchdown`). |
#'    |scoring_type_display_name       |character |Human-readable scoring-type name.                      |
#'    |scoring_type_abbreviation       |character |Scoring-type abbreviation (e.g. `TD`, `FG`).           |
#'    |point_after_attempt_id          |integer   |Point-after-attempt id on a scoring play.              |
#'    |point_after_attempt_text        |character |Point-after-attempt text (e.g. `Extra Point Good`).    |
#'    |point_after_attempt_abbreviation|character |Point-after-attempt abbreviation.                      |
#'    |point_after_attempt_value       |integer   |Points added by the point-after attempt.               |
#'    |start_down                      |integer   |Down at the start of the play.                         |
#'    |start_distance                  |integer   |Yards to go at the start of the play.                  |
#'    |start_yard_line                 |integer   |Yard line at the start of the play.                    |
#'    |start_yards_to_endzone          |integer   |Yards to the end zone at the start of the play.        |
#'    |start_down_distance_text        |character |Down-and-distance text at the start of the play.       |
#'    |start_short_down_distance_text  |character |Short down-and-distance text at the start of the play. |
#'    |start_possession_text           |character |Field-position text at the start of the play.          |
#'    |start_team_id                   |character |ESPN team id in possession at the start of the play.   |
#'    |end_down                        |integer   |Down at the end of the play.                           |
#'    |end_distance                    |integer   |Yards to go at the end of the play.                    |
#'    |end_yard_line                   |integer   |Yard line at the end of the play.                      |
#'    |end_yards_to_endzone            |integer   |Yards to the end zone at the end of the play.          |
#'    |end_down_distance_text          |character |Down-and-distance text at the end of the play.         |
#'    |end_short_down_distance_text    |character |Short down-and-distance text at the end of the play.   |
#'    |end_possession_text             |character |Field-position text at the end of the play.            |
#'    |end_team_id                     |character |ESPN team id in possession at the end of the play.     |
#'    |team_id                         |character |ESPN team id of the offensive team (parsed from `team_ref`). |
#'    |drive_play_id                   |character |ESPN drive id the play belongs to (parsed from `drive_ref`). |
#'    |wallclock                       |character |Real-world ISO timestamp of the play.                  |
#'    |modified                        |character |ISO timestamp the play record was last modified.       |
#'    |play_ref                        |character |`$ref` URL to the play resource itself.                |
#'    |team_ref                        |character |`$ref` URL to the offensive team resource.             |
#'    |start_team_ref                  |character |`$ref` URL to the team in possession at the play start.|
#'    |end_team_ref                    |character |`$ref` URL to the team in possession at the play end.  |
#'    |drive_ref                       |character |`$ref` URL to the play's drive resource.               |
#'    |probability_ref                 |character |`$ref` URL to the play's win-probability resource.     |
#'
#' The optional participant and team-participant columns are described in
#' *Details* -- they are added only when the corresponding argument
#' requests them.
#'
#' @details
#' When `participants = "wide"`, the base play schema is kept intact and
#' six columns are appended for every participant `type` on the play. The
#' column names are **dynamic** -- one set per participant type present
#' (e.g. `passer`, `rusher`, `receiver`, `tackler`, `sacked_by`,
#' `pass_defender`). ESPN's camelCase types are snake-cased (`sackedBy` ->
#' `sacked_by`). For each type the appended columns are
#' `{type}_player_id` (scalar character, the first occurrence of that type
#' on the play), `{type}_player_name` (scalar character, that athlete's
#' roster-joined name), `{type}_player_position` (scalar character, that
#' athlete's position abbreviation from the ESPN position catalog),
#' `{type}_player_position_name` (scalar character, that athlete's
#' position name), `{type}_player_ids` (a **list-column**: a character
#' vector of every athlete id of that type, in ESPN order; `character(0)`
#' if none), and `{type}_player_names` (a **list-column**: the parallel
#' vector of roster-joined names). Participant `stats[]` are not carried
#' in wide mode -- use `"long"` for the per-participant stats.
#'
#' When `participants = "long"`, the frame is expanded to one row per
#' participant with `participant_index`, `participant_athlete_id`,
#' `participant_type`, `participant_order`, the roster-joined
#' `participant_athlete_name` / `participant_position` /
#' `participant_jersey` / `participant_team_id`, and the participant's
#' stats pivoted to named `pstat_<statname>` columns. A play with zero
#' participants still yields one row (participant fields `NA`).
#'
#' When `participants_list = TRUE`, a single list-column named
#' `participants` is appended. Its one cell is a tibble with one row per
#' participant on the play and columns `participant_index` (1-based, ESPN
#' order), `type` (snake_cased, e.g. `sacked_by`, `pass_defender`),
#' `athlete_id`, `athlete_name` (roster-joined), `order`, `position_id`,
#' plus one column per participant `stat[]` name (`dplyr::bind_rows`
#' NA-fills participants whose stat sets differ). A play with no
#' participants carries an empty 0-row tibble, never `NULL`. This option is
#' independent of `participants` and composes with any of its modes -- e.g.
#' `participants = "wide", participants_list = TRUE` yields the type-keyed
#' `{type}_player_*` columns **and** the `participants` list-column. With
#' `participants = "long"` the list-column repeats per participant row.
#'
#' When `team_participants = "wide"`, three columns are appended for every
#' `teamParticipants[]` `type` on the play (ESPN ships `offense` /
#' `defense`). The column names are **dynamic** -- one set per type,
#' snake-cased: `{type}_team_id` (scalar character, the first occurrence
#' of that type on the play), `{type}_team_order` (scalar integer, ESPN's
#' display order), and `{type}_team_ref` (scalar character, the `$ref`
#' URL to that team resource). A play with none of a type carries `NA`.
#'
#' When `team_participants_list = TRUE`, a single list-column named
#' `team_participants` is appended. Its one cell is a tibble with one row
#' per team credited on the play and columns `team_participant_index`
#' (1-based, ESPN order), `team_id`, `team_ref`, `order`, and `type`
#' (e.g. `offense`, `defense`). A play with no team participants carries
#' an empty 0-row tibble, never `NULL`. This option is independent of
#' `team_participants` and composes with it -- e.g.
#' `team_participants = "wide", team_participants_list = TRUE` yields both
#' the type-keyed `{type}_team_*` columns **and** the `team_participants`
#' list-column, while `team_participants = "none"` adds neither.
#'
#' When `team_detail = TRUE` (the default), the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and joined onto **every** team-id
#' column the output carries -- the base `team_id` / `start_team_id` /
#' `end_team_id`, plus any optional `{type}_team_id` (from
#' `team_participants = "wide"`) and `{type}_player_team_id` (from
#' `participants = "long"`) columns. For each id column `X_id` the friendly
#' siblings `X_name`, `X_abbreviation`, `X_location`, `X_display_name`,
#' `X_short_display_name`, `X_nickname`, `X_color`, `X_alternate_color`,
#' `X_logo_href`, and `X_logo_dark_href` are inserted
#' immediately after it (e.g. `team_id` -> `team_name`,
#' `team_abbreviation`, ...; `start_team_id` -> `start_team_name`, ...).
#' Rows whose id is missing or unmatched receive `NA`, and a catalog-fetch
#' failure degrades the whole set to `NA` rather than erroring the wrapper.
#' With `team_detail = FALSE` the friendly columns (and the catalog fetch)
#' are skipped.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_cols bind_rows tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Play
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_play(game_id = 401628339,
#'                          play_id = "401628339101927401"))
#'   try(espn_cfb_game_play(game_id = 401628339,
#'                          play_id = "401628339101927401",
#'                          participants = "long"))
#'   try(espn_cfb_game_play(game_id = 401628339,
#'                          play_id = "401628339101927401",
#'                          participants = "wide",
#'                          participants_list = TRUE))
#'   try(espn_cfb_game_play(game_id = 401628339,
#'                          play_id = "401628339101927401",
#'                          team_participants = "wide",
#'                          team_participants_list = TRUE))
#'   try(espn_cfb_game_play(game_id = 401628339,
#'                          play_id = "401628339101927401",
#'                          team_detail = FALSE))
#' }
espn_cfb_game_play <- function(game_id = NULL, play_id = NULL,
                               participants = c("none", "wide", "long"),
                               participants_list = FALSE,
                               team_participants = c("none", "wide"),
                               team_participants_list = FALSE,
                               team_detail = TRUE) {
  participants <- match.arg(participants)
  team_participants <- match.arg(team_participants)

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game play endpoint.")
  }
  if (is.null(play_id)) {
    cli::cli_abort("{.arg play_id} is required for the ESPN game play endpoint.")
  }

  # ESPN play ids are 18-digit integers -- coerce to a non-scientific
  # character string so glue does not interpolate a rounded double.
  play_id <- format(play_id, scientific = FALSE, trim = TRUE)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/events/{game_id}/competitions/{game_id}/plays/{play_id}",
    "?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)

      it <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      if (is.null(it) || is.null(it[["id"]])) {
        return(df)
      }

      df <- .espn_cfb_play_row(it, game_id = game_id) |>
        dplyr::as_tibble()

      # teamParticipants[] -- opt-in, mirroring participants. "wide" emits
      # type-keyed {type}_team_* columns; team_participants_list = TRUE
      # appends the nested team_participants list-column. The two compose.
      if (team_participants != "none") {
        df <- .espn_cfb_attach_team_participants(df, list(it))
      }
      if (isTRUE(team_participants_list)) {
        df <- .espn_cfb_attach_team_participants_list(df, list(it))
      }

      # Fetch the game roster at most once, reused by both the participants
      # flattening and the participants list-column. The roster lookup is
      # enriched with the position catalog (position_detail = TRUE) so the
      # wide participants output carries {type}_player_position detail.
      roster_lk <- list()
      if (participants != "none" || isTRUE(participants_list)) {
        roster_lk <- .espn_cfb_participant_roster(
          game_id, position_detail = (participants == "wide")
        )
      }

      if (isTRUE(participants_list)) {
        df <- .espn_cfb_attach_participants_list(
          df, list(it), roster_lk = roster_lk
        )
      }

      if (participants != "none") {
        df <- .espn_cfb_attach_participants(
          df, list(it), roster_lk = roster_lk, mode = participants
        )
      }

      # Join the ESPN team catalog onto every team-id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df |>
        make_cfbfastR_data("Game play data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game play data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Player Statistics (Single Athlete)**
#' @description Get one athlete's box-score line for a single college football
#' game -- one row per stat, in long format.
#' @details Wraps the ESPN core-v2 per-game, per-player statistics resource
#' `events/{game_id}/competitions/{game_id}/competitors/{t}/roster/{a}/statistics/{s}`.
#' The competition id always equals the game id.
#'
#' ESPN reaches per-player game stats through the competitor roster tree --
#' dereferencing all ~250 athletes on the two rosters per game is
#' impractical, so this wrapper is **scoped to one athlete**. It fetches the
#' two competitor rosters, finds the entry whose `athlete_id` matches the
#' supplied `athlete_id`, follows that athlete's `statistics` `$ref`, and
#' returns that player's stat line in long format -- one row per stat, with
#' the stat category, name, value, and display value.
#'
#' For a full all-players game box score, the **site-v2 game-summary feed is
#' the better source** -- it returns every player's box line in one call.
#' Use this core-v2 wrapper when you need a single athlete's stats in the
#' core-v2 id space, e.g. drilling down from [espn_cfb_game_leaders()].
#'
#' If the athlete is not found on either roster, or did not record stats for
#' the game (no `statistics` `$ref`), an empty data frame is returned.
#'
#' When `position_detail = TRUE` (the default) the ESPN position catalog
#' ([espn_cfb_positions()]) is fetched once and joined onto the athlete's
#' `position_id`, so the output carries the full position name /
#' abbreviation (see *Details*).
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param athlete_id (*Integer* required): ESPN athlete id (from
#' [espn_cfb_game_leaders()] or a roster wrapper).
#' @param position_detail (*Logical*): when `TRUE` (default), fetch the
#' ESPN position catalog once and join it onto `position_id`, appending the
#' five `position_*` detail columns shown in the *Value* table. A catalog
#' failure degrades to `NA` rather than erroring the wrapper. Set `FALSE`
#' to skip the extra fetch and the join.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog ([espn_cfb_teams()]) once and join friendly team fields
#' next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`, inserted immediately after
#' `team_id`.
#' A catalog failure degrades to `NA` rather than erroring the wrapper. Set
#' `FALSE` to skip the catalog fetch and the join.
#' @return A data frame with one row per stat for the athlete:
#'
#'    |col_name                   |types     |description                                            |
#'    |:--------------------------|:---------|:------------------------------------------------------|
#'    |game_id                    |character |ESPN game identifier.                                  |
#'    |athlete_id                 |character |ESPN athlete id.                                       |
#'    |team_id                    |character |ESPN team id of the athlete's team (competitor id).    |
#'    |team_name                  |character |Team nickname; `team_detail = TRUE` only.              |
#'    |team_abbreviation          |character |Team abbreviation; `team_detail = TRUE` only.          |
#'    |team_location              |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name          |character |Full team display name; `team_detail = TRUE` only.     |
#'    |team_short_display_name    |character |Short team display name; `team_detail = TRUE` only.    |
#'    |team_nickname              |character |Team nickname label; `team_detail = TRUE` only.        |
#'    |team_color                 |character |Primary team color; `team_detail = TRUE` only.         |
#'    |team_alternate_color       |character |Alternate team color; `team_detail = TRUE` only.       |
#'    |team_logo_href             |character |Default team logo URL; `team_detail = TRUE` only.      |
#'    |team_logo_dark_href        |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |athlete_display_name       |character |Athlete display name (from the roster entry).          |
#'    |jersey                     |character |Athlete jersey number (from the roster entry).         |
#'    |starter                    |logical   |`TRUE` if the athlete started the game.                |
#'    |did_not_play               |logical   |`TRUE` if the athlete did not play.                    |
#'    |position_id                |character |ESPN position id (from the roster entry; `NA` if none).|
#'    |category_name              |character |Stat-category key (e.g. `passing`, `rushing`).         |
#'    |category_display_name      |character |Human-readable stat-category name.                     |
#'    |category_short_display_name|character |Short human-readable stat-category name.               |
#'    |category_summary           |character |ESPN's summary string for the category.                |
#'    |stat_name                  |character |Stat key (e.g. `completions`, `rushingYards`).         |
#'    |stat_display_name          |character |Human-readable stat name.                              |
#'    |stat_short_display_name    |character |Short human-readable stat name.                        |
#'    |abbreviation               |character |Stat abbreviation.                                     |
#'    |value                      |numeric   |Numeric stat value.                                    |
#'    |display_value              |character |Display-formatted stat value.                          |
#'    |description                |character |ESPN's description of the stat.                        |
#'    |position_name              |character |Position name (e.g. `Quarterback`); `position_detail = TRUE` only. |
#'    |position_display_name      |character |Human-readable position name; `position_detail = TRUE` only. |
#'    |position_abbreviation      |character |Position abbreviation (e.g. `QB`); `position_detail = TRUE` only. |
#'    |position_leaf              |logical   |`TRUE` for a most-specific (leaf) position; `position_detail = TRUE` only. |
#'    |position_parent_id         |character |ESPN id of the parent position; `position_detail = TRUE` only. |
#'
#' @details
#' When `position_detail = TRUE` (the default), the athlete's
#' `position_id` (read from the roster entry) is enriched with five
#' columns from the ESPN position catalog ([espn_cfb_positions()]):
#' `position_name`, `position_display_name`, `position_abbreviation`,
#' `position_leaf`, and `position_parent_id`. The catalog is fetched once
#' per call. If the athlete carries no `position_id` or it is unmatched,
#' all five are `NA`, and a catalog-fetch failure degrades the whole set
#' to `NA` rather than erroring the wrapper. With `position_detail = FALSE`
#' the five columns (and the catalog fetch) are skipped.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Player Statistics Box Score
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_player_statistics(game_id = 401628339,
#'                                       athlete_id = 4429105))
#'   try(espn_cfb_game_player_statistics(game_id = 401628339,
#'                                       athlete_id = 4429105,
#'                                       position_detail = FALSE))
#'   try(espn_cfb_game_player_statistics(game_id = 401628339,
#'                                       athlete_id = 4429105,
#'                                       team_detail = FALSE))
#' }
espn_cfb_game_player_statistics <- function(game_id = NULL,
                                            athlete_id = NULL,
                                            position_detail = TRUE,
                                            team_detail = TRUE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game player statistics endpoint.")
  }
  if (is.null(athlete_id)) {
    cli::cli_abort("{.arg athlete_id} is required for the ESPN game player statistics endpoint.")
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      base <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}/competitions/{game_id}"
      )

      competitors <- get_json(glue::glue("{base}/competitors?lang=en&region=us"))
      comp_items <- competitors[["items"]]
      if (is.null(comp_items) || length(comp_items) == 0) {
        return(df)
      }

      target <- as.character(athlete_id)
      stat_ref <- NA_character_
      team_id <- NA_character_
      entry_name <- NA_character_
      entry_jersey <- NA_character_
      entry_starter <- NA
      entry_dnp <- NA
      entry_position_id <- NA_character_

      for (comp in comp_items) {
        roster_ref <- if (is.list(comp[["roster"]])) {
          comp[["roster"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        if (is.na(roster_ref)) next
        roster <- get_json(roster_ref)
        entries <- roster[["entries"]]
        if (is.null(entries) || length(entries) == 0) next

        for (e in entries) {
          ath_ref <- if (is.list(e[["athlete"]])) {
            e[["athlete"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          eid <- if (!is.na(ath_ref)) {
            sub(".*/athletes/([0-9]+).*", "\\1", ath_ref)
          } else {
            as.character(e[["playerId"]] %||% NA)
          }
          if (!identical(eid, target)) next

          team_id       <- as.character(comp[["id"]] %||% NA)
          entry_name    <- as.character(e[["displayName"]] %||% NA)
          entry_jersey  <- as.character(e[["jersey"]] %||% NA)
          entry_starter <- as.logical(e[["starter"]] %||% NA)
          entry_dnp     <- as.logical(e[["didNotPlay"]] %||% NA)
          pos_ref <- if (is.list(e[["position"]])) {
            e[["position"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          entry_position_id <- if (!is.na(pos_ref)) {
            sub(".*/positions/([0-9]+).*", "\\1", pos_ref)
          } else {
            NA_character_
          }
          stat_ref <- if (is.list(e[["statistics"]])) {
            e[["statistics"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          break
        }
        if (!is.na(stat_ref) || !is.na(team_id)) break
      }

      if (is.na(stat_ref)) {
        message(glue::glue(
          "{Sys.time()}: No statistics available for athlete {athlete_id} ",
          "in game {game_id}!"
        ))
        return(df)
      }

      stats <- get_json(stat_ref)
      splits <- stats[["splits"]]
      categories <- if (is.list(splits)) splits[["categories"]] else NULL
      if (is.null(categories) || length(categories) == 0) {
        return(df)
      }

      rows <- list()
      for (cat in categories) {
        cat_stats <- cat[["stats"]]
        if (is.null(cat_stats) || length(cat_stats) == 0) next
        for (s in cat_stats) {
          rows[[length(rows) + 1L]] <- data.frame(
            game_id                     = as.character(game_id),
            athlete_id                  = target,
            team_id                     = team_id,
            athlete_display_name        = entry_name,
            jersey                      = entry_jersey,
            starter                     = entry_starter,
            did_not_play                = entry_dnp,
            position_id                 = entry_position_id,
            category_name               = as.character(cat[["name"]] %||% NA),
            category_display_name       = as.character(cat[["displayName"]] %||% NA),
            category_short_display_name = as.character(cat[["shortDisplayName"]] %||% NA),
            category_summary            = as.character(cat[["summary"]] %||% NA),
            stat_name                   = as.character(s[["name"]] %||% NA),
            stat_display_name           = as.character(s[["displayName"]] %||% NA),
            stat_short_display_name     = as.character(s[["shortDisplayName"]] %||% NA),
            abbreviation                = as.character(s[["abbreviation"]] %||% NA),
            value                       = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
            display_value               = as.character(s[["displayValue"]] %||% NA),
            description                 = as.character(s[["description"]] %||% NA),
            stringsAsFactors            = FALSE
          )
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      stats_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN position catalog onto position_id when requested --
      # adds position_name / _display_name / _abbreviation / _leaf /
      # _parent_id. position_detail = FALSE leaves the frame untouched.
      if (isTRUE(position_detail)) {
        pos_lk <- .espn_cfb_position_lookup()
        stats_df <- .espn_cfb_attach_position_detail(stats_df, pos_lk)
      }

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        stats_df <- .espn_cfb_attach_team_detail(
          stats_df, .espn_cfb_team_lookup()
        )
      }

      df <- stats_df |>
        make_cfbfastR_data("Game player statistics data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game player statistics data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Player Box Score**
#' @description Get the full per-player box score for both teams in a single
#' college football game -- one row per (team x athlete x category x stat),
#' in long format.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/competitors/{team_id}/statistics`.
#' This wrapper reads the teams list for the game, fetches the team
#' statistics resource for **both** teams, and walks the per-category
#' `splits -> categories -> athletes` arrays -- the per-player box-score
#' tree that the team-level [espn_cfb_game_team_statistics()] wrapper
#' (which walks `categories -> stats`) drops entirely.
#'
#' Each athlete entry under a category carries only a `$ref` to that
#' athlete's per-game statistics resource; this wrapper dereferences each
#' unique athlete statistics `$ref` and flattens the nested
#' `splits -> categories -> stats` tree into one long frame: one row per
#' (team x athlete x category x stat). Athlete display names and position
#' ids are joined from [espn_cfb_game_team_roster()]; a roster failure
#' degrades to `NA` names rather than erroring. The long shape absorbs
#' ESPN's habit of adding and retiring stat keys across seasons.
#'
#' When `position_detail = TRUE` (the default) the ESPN position catalog
#' ([espn_cfb_positions()]) is fetched once and joined onto `position_id`,
#' so the output carries the full position name / abbreviation (see
#' *Details*).
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param position_detail (*Logical*): when `TRUE` (default), fetch the
#' ESPN position catalog once and join it onto `position_id`, appending the
#' five `position_*` detail columns shown in the *Value* table. A catalog
#' failure degrades to `NA` rather than erroring the wrapper. Set `FALSE`
#' to skip the extra fetch and the join.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog ([espn_cfb_teams()]) once and join friendly team fields
#' next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`, inserted immediately after
#' `team_id`.
#' A catalog failure degrades to `NA` rather than erroring the wrapper. Set
#' `FALSE` to skip the catalog fetch and the join.
#' @return A data frame with one row per team-athlete-category-stat:
#'
#'    |col_name               |types     |description                                            |
#'    |:----------------------|:---------|:------------------------------------------------------|
#'    |game_id                |character |ESPN game identifier.                                  |
#'    |team_id                |character |ESPN team id (competitor id) for the team.             |
#'    |team_name              |character |Team nickname; `team_detail = TRUE` only.              |
#'    |team_abbreviation      |character |Team abbreviation; `team_detail = TRUE` only.          |
#'    |team_location          |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name      |character |Full team display name; `team_detail = TRUE` only.     |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.    |
#'    |team_nickname          |character |Team nickname label; `team_detail = TRUE` only.        |
#'    |team_color             |character |Primary team color; `team_detail = TRUE` only.         |
#'    |team_alternate_color   |character |Alternate team color; `team_detail = TRUE` only.       |
#'    |team_logo_href         |character |Default team logo URL; `team_detail = TRUE` only.      |
#'    |team_logo_dark_href    |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |home_away              |character |`home` or `away`.                                      |
#'    |athlete_id             |character |ESPN athlete id (parsed from the athlete `$ref`).      |
#'    |athlete_name           |character |Athlete display name (roster-joined).                  |
#'    |position_id            |character |ESPN position id (roster-joined; `NA` if unmatched).   |
#'    |category_name          |character |Stat category key (e.g. `passing`, `rushing`).         |
#'    |category_display       |character |Human-readable category name.                          |
#'    |category_short_display |character |Short human-readable category name.                    |
#'    |category_summary       |character |ESPN's summary string for the category.                |
#'    |stat_name              |character |Internal stat key (e.g. `passingYards`).               |
#'    |abbreviation           |character |Stat abbreviation.                                     |
#'    |display_name           |character |Human-readable stat name.                              |
#'    |short_display_name     |character |Short human-readable stat name.                        |
#'    |description            |character |ESPN's description of the stat.                        |
#'    |value                  |numeric   |Stat value.                                            |
#'    |display_value          |character |Display-formatted stat value as shown on ESPN.         |
#'    |statistics_ref         |character |`$ref` URL to the athlete's game-statistics resource.  |
#'    |position_name          |character |Position name (e.g. `Quarterback`); `position_detail = TRUE` only. |
#'    |position_display_name  |character |Human-readable position name; `position_detail = TRUE` only. |
#'    |position_abbreviation  |character |Position abbreviation (e.g. `QB`); `position_detail = TRUE` only. |
#'    |position_leaf          |logical   |`TRUE` for a most-specific (leaf) position; `position_detail = TRUE` only. |
#'    |position_parent_id     |character |ESPN id of the parent position; `position_detail = TRUE` only. |
#'
#' @details
#' When `position_detail = TRUE` (the default), the `position_id` column
#' (roster-joined per athlete) is enriched with five columns from the ESPN
#' position catalog ([espn_cfb_positions()]): `position_name`,
#' `position_display_name`, `position_abbreviation`, `position_leaf`, and
#' `position_parent_id`. The catalog is fetched once per call. A row whose
#' `position_id` is missing or unmatched receives `NA` for all five, and a
#' catalog-fetch failure degrades the whole set to `NA` rather than
#' erroring the wrapper. With `position_detail = FALSE` the five columns
#' (and the catalog fetch) are skipped.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Player Box Score
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_player_box(game_id = 401628339))
#'   try(espn_cfb_game_player_box(game_id = 401628339,
#'                                position_detail = FALSE))
#'   try(espn_cfb_game_player_box(game_id = 401628339,
#'                                team_detail = FALSE))
#' }
espn_cfb_game_player_box <- function(game_id = NULL,
                                     position_detail = TRUE,
                                     team_detail = TRUE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game player box endpoint.")
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      # Position catalog fetched once when position_detail = TRUE -- the
      # lookup degrades to empty on any catalog failure (NA join, never
      # an error).
      pos_lk <- if (isTRUE(position_detail)) {
        .espn_cfb_position_lookup()
      } else {
        list()
      }

      # Roster lookup for athlete display names and position ids. Each
      # entry is a list of `name` / `position_id`; a roster failure
      # degrades to NA names / positions rather than erroring.
      roster_lk <- list()
      tryCatch(
        expr = {
          ros <- espn_cfb_game_team_roster(game_id, position_detail = FALSE,
                                           team_detail = FALSE)
          if (is.data.frame(ros) && nrow(ros) > 0) {
            for (i in seq_len(nrow(ros))) {
              aid <- as.character(ros$athlete_id[i])
              if (is.na(aid) || aid == "NA" || aid == "") next
              roster_lk[[aid]] <- list(
                name        = as.character(ros$display_name[i] %||% NA),
                position_id = as.character(ros$position_id[i] %||% NA)
              )
            }
          }
        },
        error = function(e) {},
        warning = function(w) {}
      )

      comp_url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}/competitions/{game_id}/competitors",
        "?lang=en&region=us"
      )
      comp_raw <- get_json(comp_url)
      competitors <- comp_raw[["items"]]
      if (is.null(competitors) || length(competitors) == 0) {
        return(df)
      }

      rows <- list()
      for (c in competitors) {
        team_ref <- if (is.list(c[["team"]])) {
          c[["team"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          as.character(c[["id"]] %||% NA)
        }
        home_away <- c[["homeAway"]] %||% NA_character_

        st_url <- glue::glue(
          "https://sports.core.api.espn.com/v2/sports/football/leagues/",
          "college-football/events/{game_id}/competitions/{game_id}/",
          "competitors/{team_id}/statistics?lang=en&region=us"
        )
        st_raw <- get_json(st_url)
        splits <- st_raw[["splits"]]
        cats <- if (is.list(splits)) splits[["categories"]] %||% list() else list()

        # Collect every unique athlete statistics $ref across categories.
        seen <- list()
        for (cat in cats) {
          for (a in cat[["athletes"]] %||% list()) {
            a_ref <- if (is.list(a[["athlete"]])) {
              a[["athlete"]][["$ref"]] %||% NA_character_
            } else {
              NA_character_
            }
            s_ref <- if (is.list(a[["statistics"]])) {
              a[["statistics"]][["$ref"]] %||% NA_character_
            } else {
              NA_character_
            }
            if (is.na(s_ref)) next
            a_id <- if (!is.na(a_ref)) {
              sub(".*/athletes/([0-9]+).*", "\\1", a_ref)
            } else {
              NA_character_
            }
            if (is.null(seen[[s_ref]])) {
              seen[[s_ref]] <- a_id
            }
          }
        }

        for (s_ref in names(seen)) {
          a_id <- seen[[s_ref]]
          ath_stats <- tryCatch(get_json(s_ref), error = function(e) NULL)
          if (is.null(ath_stats)) next
          a_splits <- ath_stats[["splits"]]
          a_cats <- if (is.list(a_splits)) a_splits[["categories"]] %||% list() else list()
          r_entry <- if (!is.na(a_id)) roster_lk[[as.character(a_id)]] else NULL
          a_name <- if (is.null(r_entry)) {
            NA_character_
          } else {
            as.character(r_entry[["name"]] %||% NA)
          }
          a_pos_id <- if (is.null(r_entry)) {
            NA_character_
          } else {
            as.character(r_entry[["position_id"]] %||% NA)
          }

          for (cat in a_cats) {
            cat_name  <- cat[["name"]] %||% NA_character_
            cat_disp  <- cat[["displayName"]] %||% NA_character_
            cat_sdisp <- cat[["shortDisplayName"]] %||% NA_character_
            cat_summ  <- cat[["summary"]] %||% NA_character_
            for (s in cat[["stats"]] %||% list()) {
              rows[[length(rows) + 1L]] <- data.frame(
                game_id                = as.character(game_id),
                team_id                = as.character(team_id),
                home_away              = home_away,
                athlete_id             = a_id,
                athlete_name           = a_name,
                position_id            = a_pos_id,
                category_name          = cat_name,
                category_display       = cat_disp,
                category_short_display = cat_sdisp,
                category_summary       = cat_summ,
                stat_name              = s[["name"]] %||% NA_character_,
                abbreviation           = s[["abbreviation"]] %||% NA_character_,
                display_name           = s[["displayName"]] %||% NA_character_,
                short_display_name     = s[["shortDisplayName"]] %||% NA_character_,
                description            = s[["description"]] %||% NA_character_,
                value                  = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
                display_value          = as.character(s[["displayValue"]] %||% NA),
                statistics_ref         = as.character(s_ref),
                stringsAsFactors       = FALSE
              )
            }
          }
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      box_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN position catalog onto position_id when requested --
      # adds position_name / _display_name / _abbreviation / _leaf /
      # _parent_id. position_detail = FALSE leaves the frame untouched.
      if (isTRUE(position_detail)) {
        box_df <- .espn_cfb_attach_position_detail(box_df, pos_lk)
      }

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        box_df <- .espn_cfb_attach_team_detail(box_df, .espn_cfb_team_lookup())
      }

      df <- box_df |>
        make_cfbfastR_data("Game player box score data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game player box data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Power Index (Matchup FPI)**
#' @description Get ESPN's Football Power Index (FPI) matchup projections
#' for both teams in a single college football game, in long format.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/powerindex`. The endpoint
#' returns one `$ref` per team; this wrapper dereferences each and flattens
#' the per-team `stats` array into one long frame -- one row per
#' (team x FPI metric). Metrics include the predicted point differential,
#' matchup quality, and game-projection components ESPN derives from FPI for
#' that specific game. The long shape absorbs ESPN's habit of adding and
#' retiring metrics across seasons.
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`. A catalog failure degrades
#' to `NA`
#' rather than erroring the wrapper. Set `team_detail = FALSE` to skip the
#' catalog fetch and the join.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per team-metric:
#'
#'    |col_name           |types     |description                                            |
#'    |:------------------|:---------|:------------------------------------------------------|
#'    |game_id            |character |ESPN game identifier.                                  |
#'    |season             |integer   |Season (4-digit year) of the game.                     |
#'    |team_id            |character |ESPN team id (parsed from `team_ref`).                 |
#'    |team_name          |character |Team nickname; `team_detail = TRUE` only.              |
#'    |team_abbreviation  |character |Team abbreviation; `team_detail = TRUE` only.          |
#'    |team_location      |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name  |character |Full team display name; `team_detail = TRUE` only.     |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only. |
#'    |team_nickname      |character |Team nickname label; `team_detail = TRUE` only.        |
#'    |team_color         |character |Primary team color; `team_detail = TRUE` only.         |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.      |
#'    |team_logo_href     |character |Default team logo URL; `team_detail = TRUE` only.      |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |stat_name          |character |FPI metric key (e.g. `teampredptdiff`).                |
#'    |abbreviation       |character |Metric abbreviation.                                   |
#'    |display_name       |character |Human-readable metric name.                            |
#'    |short_display_name |character |Short human-readable metric name.                      |
#'    |value              |numeric   |Metric value.                                          |
#'    |display_value      |character |Display-formatted metric value as shown on ESPN.       |
#'    |description        |character |ESPN's description of the metric.                      |
#'    |powerindex_ref     |character |`$ref` URL to the per-team power-index resource.       |
#'    |team_ref           |character |`$ref` URL to the team-in-season resource.             |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Power Index FPI
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_powerindex(game_id = 401628339))
#'   try(espn_cfb_game_powerindex(game_id = 401628339, team_detail = FALSE))
#' }
espn_cfb_game_powerindex <- function(game_id = NULL, team_detail = TRUE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game power index endpoint.")
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}/competitions/{game_id}/",
        "powerindex?lang=en&region=us"
      )
      raw <- get_json(url)
      items <- raw[["items"]]
      if (is.null(items) || length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        # Each item is a {$ref} pointing to a per-team powerindex resource.
        pi <- if (!is.null(it[["$ref"]])) get_json(it[["$ref"]]) else it
        powerindex_ref <- if (is.list(pi[["$ref"]]) || !is.null(pi[["$ref"]])) {
          as.character(pi[["$ref"]] %||% NA)
        } else {
          NA_character_
        }
        team_ref <- if (is.list(pi[["team"]])) {
          pi[["team"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          NA_character_
        }
        season <- suppressWarnings(as.integer(pi[["season"]] %||% NA))

        for (s in pi[["stats"]] %||% list()) {
          rows[[length(rows) + 1L]] <- data.frame(
            game_id            = as.character(game_id),
            season             = season,
            team_id            = team_id,
            stat_name          = s[["name"]] %||% NA_character_,
            abbreviation       = s[["abbreviation"]] %||% NA_character_,
            display_name       = s[["displayName"]] %||% NA_character_,
            short_display_name = s[["shortDisplayName"]] %||% NA_character_,
            value              = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
            display_value      = as.character(s[["displayValue"]] %||% NA),
            description        = s[["description"]] %||% NA_character_,
            powerindex_ref     = powerindex_ref,
            team_ref           = team_ref,
            stringsAsFactors   = FALSE
          )
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      pi_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        pi_df <- .espn_cfb_attach_team_detail(pi_df, .espn_cfb_team_lookup())
      }

      df <- pi_df |>
        make_cfbfastR_data("Game power index data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game power index data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Predictor (BPI Matchup Predictor)**
#' @description Get ESPN's pre-game matchup predictor (Football Power Index
#' game projection) for a single college football game.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/predictor`. ESPN's predictor
#' resource carries one statistics block per team (home and away); this
#' wrapper flattens both into one long frame -- one row per (team x predictor
#' metric). Metrics include each team's projected win probability
#' (`gameProjection`), predicted point total, and matchup-quality scores.
#'
#' This endpoint responds `HTTP 400` for future / not-yet-scheduled games
#' and is only reliably populated for **completed** games. The `@examples`
#' use a finished game; pass `game_id` values for completed games.
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`. A catalog failure degrades
#' to `NA`
#' rather than erroring the wrapper. Set `team_detail = FALSE` to skip the
#' catalog fetch and the join.
#' @param game_id (*Integer* required): ESPN game identifier for a
#' completed game.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per team-predictor metric:
#'
#'    |col_name           |types     |description                                            |
#'    |:------------------|:---------|:------------------------------------------------------|
#'    |game_id            |character |ESPN game identifier.                                  |
#'    |matchup_name       |character |Predictor matchup name (e.g. `TNTC at Georgia`).       |
#'    |matchup_short_name |character |Short predictor matchup name (e.g. `TNTC @ UGA`).      |
#'    |last_modified      |character |ISO timestamp the predictor was last run.              |
#'    |team_side          |character |`home` or `away`.                                      |
#'    |team_id            |character |ESPN team id (parsed from `team_ref`).                 |
#'    |team_name          |character |Team nickname; `team_detail = TRUE` only.              |
#'    |team_abbreviation  |character |Team abbreviation; `team_detail = TRUE` only.          |
#'    |team_location      |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name  |character |Full team display name; `team_detail = TRUE` only.     |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only. |
#'    |team_nickname      |character |Team nickname label; `team_detail = TRUE` only.        |
#'    |team_color         |character |Primary team color; `team_detail = TRUE` only.         |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.      |
#'    |team_logo_href     |character |Default team logo URL; `team_detail = TRUE` only.      |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |stat_name          |character |Predictor metric key (e.g. `gameProjection`).          |
#'    |abbreviation       |character |Metric abbreviation.                                   |
#'    |display_name       |character |Human-readable metric name.                            |
#'    |short_display_name |character |Short human-readable metric name.                      |
#'    |value              |numeric   |Metric value.                                          |
#'    |display_value      |character |Display-formatted metric value as shown on ESPN.       |
#'    |description        |character |ESPN's description of the metric.                      |
#'    |team_ref           |character |`$ref` URL to the team-in-season resource.             |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Predictor
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_predictor(game_id = 401628339))
#'   try(espn_cfb_game_predictor(game_id = 401628339, team_detail = FALSE))
#' }
espn_cfb_game_predictor <- function(game_id = NULL, team_detail = TRUE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game predictor endpoint.")
  }

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/events/{game_id}/competitions/{game_id}/predictor",
    "?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)

      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      matchup_name       <- as.character(raw[["name"]] %||% NA)
      matchup_short_name <- as.character(raw[["shortName"]] %||% NA)
      last_modified      <- as.character(raw[["lastModified"]] %||% NA)

      sides <- list(home = raw[["homeTeam"]], away = raw[["awayTeam"]])
      rows <- list()
      for (side in names(sides)) {
        block <- sides[[side]]
        if (!is.list(block)) next
        team_ref <- if (is.list(block[["team"]])) {
          block[["team"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          NA_character_
        }
        for (s in block[["statistics"]] %||% list()) {
          rows[[length(rows) + 1L]] <- data.frame(
            game_id            = as.character(game_id),
            matchup_name       = matchup_name,
            matchup_short_name = matchup_short_name,
            last_modified      = last_modified,
            team_side          = side,
            team_id            = team_id,
            stat_name          = s[["name"]] %||% NA_character_,
            abbreviation       = s[["abbreviation"]] %||% NA_character_,
            display_name       = s[["displayName"]] %||% NA_character_,
            short_display_name = s[["shortDisplayName"]] %||% NA_character_,
            value              = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
            display_value      = as.character(s[["displayValue"]] %||% NA),
            description        = s[["description"]] %||% NA_character_,
            team_ref           = team_ref,
            stringsAsFactors   = FALSE
          )
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      pred_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        pred_df <- .espn_cfb_attach_team_detail(
          pred_df, .espn_cfb_team_lookup()
        )
      }

      df <- pred_df |>
        make_cfbfastR_data("Game predictor data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game predictor data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Win Probabilities**
#' @description Get ESPN's play-by-play win-probability series for a single
#' college football game -- one row per play.
#' @details Wraps the paginated ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/probabilities`. The endpoint
#' is paginated; this wrapper loops every page and stacks the results into
#' one frame -- one row per play, each carrying the home / away / tie win
#' percentages at that point in the game, plus spread-cover and total
#' (over/under) probabilities. `play_id` is parsed from each row's play
#' `$ref` so the series can be joined to [espn_cfb_game_pbp()].
#'
#' This endpoint responds `HTTP 400` for future / not-yet-played games and
#' is only populated for **completed** games. The `@examples` use a finished
#' game; pass `game_id` values for completed games.
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to both the `home_team_id` and `away_team_id` columns -- e.g.
#' `home_team_name`, `home_team_abbreviation`, ..., `away_team_name`,
#' `away_team_abbreviation`, .... A catalog failure degrades to `NA` rather
#' than erroring the wrapper. Set `team_detail = FALSE` to skip the catalog
#' fetch and the join.
#' @param game_id (*Integer* required): ESPN game identifier for a
#' completed game.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the
#' `home_team_id` / `away_team_id` columns (see *Details*). Set `FALSE` to
#' skip the catalog fetch and the join.
#' @return A data frame with one row per play:
#'
#'    |col_name                |types     |description                                            |
#'    |:-----------------------|:---------|:------------------------------------------------------|
#'    |game_id                 |character |ESPN game identifier.                                  |
#'    |play_id                 |character |ESPN play id (parsed from the play `$ref`).            |
#'    |sequence_number         |character |Play sequence number within the game.                  |
#'    |home_team_id            |character |ESPN home team id (parsed from `home_team_ref`).       |
#'    |home_team_name          |character |Home team nickname; `team_detail = TRUE` only.         |
#'    |home_team_abbreviation  |character |Home team abbreviation; `team_detail = TRUE` only.     |
#'    |home_team_location      |character |Home team location / school; `team_detail = TRUE` only.|
#'    |home_team_display_name  |character |Home team full display name; `team_detail = TRUE` only.|
#'    |home_team_short_display_name|character |Home team short display name; `team_detail = TRUE` only.|
#'    |home_team_nickname      |character |Home team nickname label; `team_detail = TRUE` only.   |
#'    |home_team_color         |character |Home team primary color; `team_detail = TRUE` only.    |
#'    |home_team_alternate_color|character |Home team alternate color; `team_detail = TRUE` only. |
#'    |home_team_logo_href     |character |Home team default logo URL; `team_detail = TRUE` only. |
#'    |home_team_logo_dark_href|character |Home team dark logo URL; `team_detail = TRUE` only.    |
#'    |away_team_id            |character |ESPN away team id (parsed from `away_team_ref`).       |
#'    |away_team_name          |character |Away team nickname; `team_detail = TRUE` only.         |
#'    |away_team_abbreviation  |character |Away team abbreviation; `team_detail = TRUE` only.     |
#'    |away_team_location      |character |Away team location / school; `team_detail = TRUE` only.|
#'    |away_team_display_name  |character |Away team full display name; `team_detail = TRUE` only.|
#'    |away_team_short_display_name|character |Away team short display name; `team_detail = TRUE` only.|
#'    |away_team_nickname      |character |Away team nickname label; `team_detail = TRUE` only.   |
#'    |away_team_color         |character |Away team primary color; `team_detail = TRUE` only.    |
#'    |away_team_alternate_color|character |Away team alternate color; `team_detail = TRUE` only. |
#'    |away_team_logo_href     |character |Away team default logo URL; `team_detail = TRUE` only. |
#'    |away_team_logo_dark_href|character |Away team dark logo URL; `team_detail = TRUE` only.    |
#'    |home_win_percentage     |numeric   |Home-team win probability after the play (0-1).        |
#'    |away_win_percentage     |numeric   |Away-team win probability after the play (0-1).        |
#'    |tie_percentage          |numeric   |Tie probability after the play (0-1).                  |
#'    |seconds_left            |integer   |Seconds left in the game at the play.                  |
#'    |spread_cover_prob_home  |numeric   |Probability the home team covers the spread.           |
#'    |spread_push_prob        |numeric   |Probability of a spread push.                          |
#'    |total_over_prob         |numeric   |Probability the game total goes over.                  |
#'    |total_push_prob         |numeric   |Probability of a total push.                           |
#'    |source_id               |character |ESPN data-source id for the probability row.           |
#'    |source_description      |character |ESPN data-source description (e.g. `feed`).            |
#'    |source_state            |character |ESPN data-source state (e.g. `full`).                  |
#'    |last_modified           |character |ISO timestamp the probability row was last modified.   |
#'    |play_ref                |character |`$ref` URL to the play resource for the row.           |
#'    |competition_ref         |character |`$ref` URL to the competition resource.                |
#'    |home_team_ref           |character |`$ref` URL to the home team resource.                  |
#'    |away_team_ref           |character |`$ref` URL to the away team resource.                  |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Probabilities Win Probability
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_probabilities(game_id = 401628339))
#'   try(espn_cfb_game_probabilities(game_id = 401628339,
#'                                   team_detail = FALSE))
#' }
espn_cfb_game_probabilities <- function(game_id = NULL, team_detail = TRUE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game probabilities endpoint.")
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  parse_id <- function(ref, pattern) {
    if (is.na(ref)) return(NA_character_)
    sub(pattern, "\\1", ref)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      base_url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}/competitions/{game_id}/",
        "probabilities?limit=25&lang=en&region=us"
      )
      first <- get_json(paste0(base_url, "&page=1"))
      page_count <- suppressWarnings(as.integer(first[["pageCount"]] %||% 1L))
      if (is.na(page_count) || page_count < 1L) page_count <- 1L

      rows <- list()
      add_items <- function(items) {
        for (it in items %||% list()) {
          play_ref <- if (is.list(it[["play"]])) {
            it[["play"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          home_ref <- if (is.list(it[["homeTeam"]])) {
            it[["homeTeam"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          away_ref <- if (is.list(it[["awayTeam"]])) {
            it[["awayTeam"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          comp_ref <- if (is.list(it[["competition"]])) {
            it[["competition"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          src <- it[["source"]]

          rows[[length(rows) + 1L]] <<- data.frame(
            game_id                = as.character(game_id),
            play_id                = parse_id(play_ref, ".*/plays/([0-9]+).*"),
            sequence_number        = as.character(it[["sequenceNumber"]] %||% NA),
            home_team_id           = parse_id(home_ref, ".*/teams/([0-9]+).*"),
            away_team_id           = parse_id(away_ref, ".*/teams/([0-9]+).*"),
            home_win_percentage    = suppressWarnings(as.numeric(it[["homeWinPercentage"]] %||% NA)),
            away_win_percentage    = suppressWarnings(as.numeric(it[["awayWinPercentage"]] %||% NA)),
            tie_percentage         = suppressWarnings(as.numeric(it[["tiePercentage"]] %||% NA)),
            seconds_left           = suppressWarnings(as.integer(it[["secondsLeft"]] %||% NA)),
            spread_cover_prob_home = suppressWarnings(as.numeric(it[["spreadCoverProbHome"]] %||% NA)),
            spread_push_prob       = suppressWarnings(as.numeric(it[["spreadPushProb"]] %||% NA)),
            total_over_prob        = suppressWarnings(as.numeric(it[["totalOverProb"]] %||% NA)),
            total_push_prob        = suppressWarnings(as.numeric(it[["totalPushProb"]] %||% NA)),
            source_id              = if (is.list(src)) as.character(src[["id"]] %||% NA) else NA_character_,
            source_description     = if (is.list(src)) as.character(src[["description"]] %||% NA) else NA_character_,
            source_state           = if (is.list(src)) as.character(src[["state"]] %||% NA) else NA_character_,
            last_modified          = as.character(it[["lastModified"]] %||% NA),
            play_ref               = play_ref,
            competition_ref        = comp_ref,
            home_team_ref          = home_ref,
            away_team_ref          = away_ref,
            stringsAsFactors = FALSE
          )
        }
      }

      add_items(first[["items"]])
      if (page_count > 1L) {
        for (p in 2:page_count) {
          pg <- get_json(paste0(base_url, "&page=", p))
          add_items(pg[["items"]])
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      prob_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto home_team_id / away_team_id when
      # requested -- both columns end in `_team_id` so the helper enriches
      # them with home_team_* / away_team_* friendly siblings.
      if (isTRUE(team_detail)) {
        prob_df <- .espn_cfb_attach_team_detail(
          prob_df, .espn_cfb_team_lookup()
        )
      }

      df <- prob_df |>
        make_cfbfastR_data("Game win probabilities data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game probabilities data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Situation**
#' @description Get the current (or final) game situation for a single
#' college football game -- down, distance, yard line, red-zone flag,
#' timeouts, and a `$ref` to the last play.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/situation`. The competition id
#' always equals the game id. Returns a single-row data frame describing the
#' live game situation. For an in-progress game this is the current state;
#' for a completed game it is static -- the final play state. The
#' `last_play_ref` column is the `$ref` URL to the last play; parse its id
#' and pass it to [espn_cfb_game_play()] for the full play detail.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @return A data frame with one row describing the game situation:
#'
#'    |col_name      |types     |description                                            |
#'    |:-------------|:---------|:------------------------------------------------------|
#'    |game_id       |character |ESPN game identifier.                                  |
#'    |down          |integer   |Current down.                                          |
#'    |distance      |integer   |Yards to go for a first down.                          |
#'    |yard_line     |integer   |Current yard line.                                     |
#'    |is_red_zone   |logical   |`TRUE` if the offense is in the red zone.              |
#'    |home_timeouts |integer   |Home-team timeouts remaining.                          |
#'    |away_timeouts |integer   |Away-team timeouts remaining.                          |
#'    |last_play_id  |character |ESPN play id of the last play (parsed from `last_play_ref`). |
#'    |situation_ref |character |`$ref` URL to the situation resource itself.           |
#'    |last_play_ref |character |`$ref` URL to the last-play resource.                  |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Situation
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_situation(game_id = 401628339))
#' }
espn_cfb_game_situation <- function(game_id = NULL) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game situation endpoint.")
  }

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/events/{game_id}/competitions/{game_id}/situation",
    "?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)

      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      if (is.null(raw) || length(raw) == 0) {
        return(df)
      }

      last_play_ref <- if (is.list(raw[["lastPlay"]])) {
        raw[["lastPlay"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      last_play_id <- if (!is.na(last_play_ref)) {
        sub(".*/plays/([0-9]+).*", "\\1", last_play_ref)
      } else {
        NA_character_
      }

      df <- data.frame(
        game_id       = as.character(game_id),
        down          = suppressWarnings(as.integer(raw[["down"]] %||% NA)),
        distance      = suppressWarnings(as.integer(raw[["distance"]] %||% NA)),
        yard_line     = suppressWarnings(as.integer(raw[["yardLine"]] %||% NA)),
        is_red_zone   = as.logical(raw[["isRedZone"]] %||% NA),
        home_timeouts = suppressWarnings(as.integer(raw[["homeTimeouts"]] %||% NA)),
        away_timeouts = suppressWarnings(as.integer(raw[["awayTimeouts"]] %||% NA)),
        last_play_id  = last_play_id,
        situation_ref = as.character(raw[["$ref"]] %||% NA),
        last_play_ref = last_play_ref,
        stringsAsFactors = FALSE
      ) |>
        dplyr::as_tibble() |>
        make_cfbfastR_data("Game situation data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game situation data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Status**
#' @description Get the competition status for a single college football game
#' -- clock, period, and the status type/state (scheduled, in-progress,
#' final).
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/status`. The competition id always
#' equals the game id. Returns a single-row data frame describing the game's
#' status. For a completed game `state` is `post` and `completed` is `TRUE`;
#' for an in-progress game the `clock` and `period` reflect live game time.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @return A data frame with one row describing the game status:
#'
#'    |col_name      |types     |description                                            |
#'    |:-------------|:---------|:------------------------------------------------------|
#'    |game_id       |character |ESPN game identifier.                                  |
#'    |clock         |numeric   |Game clock value in seconds.                           |
#'    |display_clock |character |Game clock display value (`MM:SS`).                    |
#'    |period        |integer   |Period (quarter) number.                               |
#'    |status_id     |character |ESPN status-type id.                                   |
#'    |status_name   |character |Status-type key (e.g. `STATUS_FINAL`).                 |
#'    |status_state  |character |Status state (`pre`, `in`, or `post`).                 |
#'    |completed     |logical   |`TRUE` if the game is complete.                        |
#'    |description   |character |Status description (e.g. `Final`).                     |
#'    |detail        |character |Detailed status text.                                  |
#'    |short_detail  |character |Short status text.                                     |
#'    |status_ref    |character |`$ref` URL to the status resource itself.              |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Status
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_status(game_id = 401628339))
#' }
espn_cfb_game_status <- function(game_id = NULL) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game status endpoint.")
  }

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/events/{game_id}/competitions/{game_id}/status",
    "?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)

      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      if (is.null(raw) || length(raw) == 0) {
        return(df)
      }

      tp <- raw[["type"]]

      df <- data.frame(
        game_id       = as.character(game_id),
        clock         = suppressWarnings(as.numeric(raw[["clock"]] %||% NA)),
        display_clock = as.character(raw[["displayClock"]] %||% NA),
        period        = suppressWarnings(as.integer(raw[["period"]] %||% NA)),
        status_id     = if (is.list(tp)) as.character(tp[["id"]] %||% NA) else NA_character_,
        status_name   = if (is.list(tp)) as.character(tp[["name"]] %||% NA) else NA_character_,
        status_state  = if (is.list(tp)) as.character(tp[["state"]] %||% NA) else NA_character_,
        completed     = if (is.list(tp)) as.logical(tp[["completed"]] %||% NA) else NA,
        description   = if (is.list(tp)) as.character(tp[["description"]] %||% NA) else NA_character_,
        detail        = if (is.list(tp)) as.character(tp[["detail"]] %||% NA) else NA_character_,
        short_detail  = if (is.list(tp)) as.character(tp[["shortDetail"]] %||% NA) else NA_character_,
        status_ref    = as.character(raw[["$ref"]] %||% NA),
        stringsAsFactors = FALSE
      ) |>
        dplyr::as_tibble() |>
        make_cfbfastR_data("Game status data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game status data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Team Leaders**
#' @description Get each team's statistical leaders (passing, rushing,
#' receiving, ...) for a single college football game.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/competitors/{team_id}/leaders`.
#' This wrapper reads the teams list for the game and fetches the
#' leaders resource for **both** teams, flattening the nested
#' `categories -> leaders` tree into one long frame: one row per
#' (team x category x leader). `rank` is the leader's position within the
#' category (1 = top performer). `display_value` is ESPN's pre-formatted
#' stat line (e.g. `"18/25, 242 YDS, 5 TD"`).
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to both team-id columns -- `team_id` gains `team_name`,
#' `team_abbreviation`, ..., and `leader_team_id` gains `leader_team_name`,
#' `leader_team_abbreviation`, .... A catalog failure degrades to `NA`
#' rather than erroring the wrapper. Set `team_detail = FALSE` to skip the
#' catalog fetch and the join.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' and `leader_team_id` columns (see *Details*). Set `FALSE` to skip the
#' catalog fetch and the join.
#' @return A data frame with one row per team-category-leader:
#'
#'    |col_name              |types     |description                                            |
#'    |:---------------------|:---------|:------------------------------------------------------|
#'    |game_id               |character |ESPN game identifier.                                  |
#'    |team_id               |character |ESPN team id for the team.                             |
#'    |team_name             |character |Team nickname; `team_detail = TRUE` only.              |
#'    |team_abbreviation     |character |Team abbreviation; `team_detail = TRUE` only.          |
#'    |team_location         |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name     |character |Full team display name; `team_detail = TRUE` only.     |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.   |
#'    |team_nickname         |character |Team nickname label; `team_detail = TRUE` only.        |
#'    |team_color            |character |Primary team color; `team_detail = TRUE` only.         |
#'    |team_alternate_color  |character |Alternate team color; `team_detail = TRUE` only.       |
#'    |team_logo_href        |character |Default team logo URL; `team_detail = TRUE` only.      |
#'    |team_logo_dark_href   |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |home_away             |character |`home` or `away`.                                      |
#'    |category_name         |character |Leader category key (e.g. `passingLeader`).            |
#'    |category_display      |character |Human-readable category name.                          |
#'    |category_short_display|character |Short human-readable category name.                    |
#'    |category_abbrev       |character |Category abbreviation.                                 |
#'    |rank                  |integer   |Leader rank within the category (1 = top performer).   |
#'    |athlete_id            |character |ESPN athlete id (parsed from `athlete_ref`).           |
#'    |leader_team_id        |character |ESPN team id of the leader (parsed from `leader_team_ref`). |
#'    |leader_team_name      |character |Leader's team nickname; `team_detail = TRUE` only.     |
#'    |leader_team_abbreviation|character |Leader's team abbreviation; `team_detail = TRUE` only.|
#'    |leader_team_location  |character |Leader's team location; `team_detail = TRUE` only.     |
#'    |leader_team_display_name|character |Leader's team full display name; `team_detail = TRUE` only.|
#'    |leader_team_short_display_name|character |Leader's team short display name; `team_detail = TRUE` only.|
#'    |leader_team_nickname  |character |Leader's team nickname label; `team_detail = TRUE` only.|
#'    |leader_team_color     |character |Leader's team primary color; `team_detail = TRUE` only.|
#'    |leader_team_alternate_color|character |Leader's team alternate color; `team_detail = TRUE` only.|
#'    |leader_team_logo_href |character |Leader's team default logo URL; `team_detail = TRUE` only.|
#'    |leader_team_logo_dark_href|character |Leader's team dark logo URL; `team_detail = TRUE` only.|
#'    |value                 |numeric   |Leading statistic value.                               |
#'    |display_value         |character |ESPN's pre-formatted stat line for the leader.         |
#'    |athlete_ref           |character |`$ref` URL to the athlete-in-event resource.           |
#'    |leader_team_ref       |character |`$ref` URL to the leader's team resource.              |
#'    |statistics_ref        |character |`$ref` URL to the leader's game-statistics resource.   |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Team Leaders
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_team_leaders(game_id = 401628339))
#'   try(espn_cfb_game_team_leaders(game_id = 401628339,
#'                                  team_detail = FALSE))
#' }
espn_cfb_game_team_leaders <- function(game_id = NULL, team_detail = TRUE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game team leaders endpoint.")
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      comp_url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}/competitions/{game_id}/competitors",
        "?lang=en&region=us"
      )
      comp_raw <- get_json(comp_url)
      competitors <- comp_raw[["items"]]
      if (is.null(competitors) || length(competitors) == 0) {
        return(df)
      }

      rows <- list()
      for (c in competitors) {
        team_ref <- if (is.list(c[["team"]])) {
          c[["team"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          as.character(c[["id"]] %||% NA)
        }
        home_away <- c[["homeAway"]] %||% NA_character_

        ld_url <- glue::glue(
          "https://sports.core.api.espn.com/v2/sports/football/leagues/",
          "college-football/events/{game_id}/competitions/{game_id}/",
          "competitors/{team_id}/leaders?lang=en&region=us"
        )
        ld_raw <- get_json(ld_url)
        for (cat in ld_raw[["categories"]] %||% list()) {
          cat_name  <- cat[["name"]] %||% NA_character_
          cat_disp  <- cat[["displayName"]] %||% NA_character_
          cat_sdisp <- cat[["shortDisplayName"]] %||% NA_character_
          cat_abbr  <- cat[["abbreviation"]] %||% NA_character_
          leaders <- cat[["leaders"]] %||% list()
          for (i in seq_along(leaders)) {
            l <- leaders[[i]]
            a_ref <- if (is.list(l[["athlete"]])) {
              l[["athlete"]][["$ref"]] %||% NA_character_
            } else {
              NA_character_
            }
            a_id <- if (!is.na(a_ref)) {
              sub(".*/athletes/([0-9]+).*", "\\1", a_ref)
            } else {
              NA_character_
            }
            lt_ref <- if (is.list(l[["team"]])) {
              l[["team"]][["$ref"]] %||% NA_character_
            } else {
              NA_character_
            }
            lt_id <- if (!is.na(lt_ref)) {
              sub(".*/teams/([0-9]+).*", "\\1", lt_ref)
            } else {
              NA_character_
            }
            st_ref <- if (is.list(l[["statistics"]])) {
              l[["statistics"]][["$ref"]] %||% NA_character_
            } else {
              NA_character_
            }

            rows[[length(rows) + 1L]] <- data.frame(
              game_id                = as.character(game_id),
              team_id                = as.character(team_id),
              home_away              = home_away,
              category_name          = cat_name,
              category_display       = cat_disp,
              category_short_display = cat_sdisp,
              category_abbrev        = cat_abbr,
              rank                   = as.integer(i),
              athlete_id             = a_id,
              leader_team_id         = lt_id,
              value                  = suppressWarnings(as.numeric(l[["value"]] %||% NA)),
              display_value          = as.character(l[["displayValue"]] %||% NA),
              athlete_ref            = a_ref,
              leader_team_ref        = lt_ref,
              statistics_ref         = st_ref,
              stringsAsFactors       = FALSE
            )
          }
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      tl_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto team_id / leader_team_id when
      # requested.
      if (isTRUE(team_detail)) {
        tl_df <- .espn_cfb_attach_team_detail(tl_df, .espn_cfb_team_lookup())
      }

      df <- tl_df |>
        make_cfbfastR_data("Game team leaders data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game team leaders data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Team Linescores**
#' @description Get the quarter-by-quarter linescores for both teams in a
#' single college football game.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/competitors/{team_id}/linescores`.
#' This wrapper first reads the teams list for the game and then
#' fetches the linescores resource for **both** teams, stacking the
#' results into one long frame -- one row per (team x period). `home_away`
#' identifies which team a row belongs to. Periods 1-4 are quarters;
#' periods 5+ are overtime sessions.
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`. A catalog failure degrades
#' to `NA`
#' rather than erroring the wrapper. Set `team_detail = FALSE` to skip the
#' catalog fetch and the join.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per team-period:
#'
#'    |col_name           |types     |description                                        |
#'    |:------------------|:---------|:--------------------------------------------------|
#'    |game_id            |character |ESPN game identifier.                              |
#'    |team_id            |character |ESPN team id for the team.                         |
#'    |team_name          |character |Team nickname; `team_detail = TRUE` only.          |
#'    |team_abbreviation  |character |Team abbreviation; `team_detail = TRUE` only.      |
#'    |team_location      |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name  |character |Full team display name; `team_detail = TRUE` only. |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname      |character |Team nickname label; `team_detail = TRUE` only.    |
#'    |team_color         |character |Primary team color; `team_detail = TRUE` only.     |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.  |
#'    |team_logo_href     |character |Default team logo URL; `team_detail = TRUE` only.  |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |home_away          |character |`home` or `away`.                                  |
#'    |period             |integer   |Period number (1-4 quarters; 5+ overtime).         |
#'    |value              |numeric   |Points scored by the team in that period.          |
#'    |display_value      |character |Display-formatted period score.                    |
#'    |source_id          |character |ESPN data-source id for the linescore.             |
#'    |source_state       |character |ESPN data-source state (e.g. `full`).              |
#'    |source_description |character |ESPN data-source description (e.g. `Basic/Manual`).|
#'    |linescore_ref      |character |`$ref` URL to the per-period linescore resource.   |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Team Linescores
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_team_linescores(game_id = 401628339))
#'   try(espn_cfb_game_team_linescores(game_id = 401628339,
#'                                     team_detail = FALSE))
#' }
espn_cfb_game_team_linescores <- function(game_id = NULL,
                                          team_detail = TRUE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game team linescores endpoint.")
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      comp_url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}/competitions/{game_id}/competitors",
        "?lang=en&region=us"
      )
      comp_raw <- get_json(comp_url)
      competitors <- comp_raw[["items"]]
      if (is.null(competitors) || length(competitors) == 0) {
        return(df)
      }

      rows <- list()
      for (c in competitors) {
        team_ref <- if (is.list(c[["team"]])) {
          c[["team"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          as.character(c[["id"]] %||% NA)
        }
        home_away <- c[["homeAway"]] %||% NA_character_

        ls_url <- glue::glue(
          "https://sports.core.api.espn.com/v2/sports/football/leagues/",
          "college-football/events/{game_id}/competitions/{game_id}/",
          "competitors/{team_id}/linescores?lang=en&region=us"
        )
        ls_raw <- get_json(ls_url)
        for (it in ls_raw[["items"]] %||% list()) {
          src <- it[["source"]]
          rows[[length(rows) + 1L]] <- data.frame(
            game_id            = as.character(game_id),
            team_id            = as.character(team_id),
            home_away          = home_away,
            period             = suppressWarnings(as.integer(it[["period"]] %||% NA)),
            value              = suppressWarnings(as.numeric(it[["value"]] %||% NA)),
            display_value      = as.character(it[["displayValue"]] %||% NA),
            source_id          = if (is.list(src)) as.character(src[["id"]] %||% NA) else NA_character_,
            source_state       = if (is.list(src)) as.character(src[["state"]] %||% NA) else NA_character_,
            source_description = if (is.list(src)) as.character(src[["description"]] %||% NA) else NA_character_,
            linescore_ref      = as.character(it[["$ref"]] %||% NA),
            stringsAsFactors   = FALSE
          )
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      ls_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        ls_df <- .espn_cfb_attach_team_detail(ls_df, .espn_cfb_team_lookup())
      }

      df <- ls_df |>
        make_cfbfastR_data("Game team linescores data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game team linescores data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Team Records**
#' @description Get each team's win-loss records (overall, home, road,
#' conference) as they stood at the time of a single college football game.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/competitors/{team_id}/records`.
#' This wrapper reads the teams list for the game and fetches the
#' records resource for **both** teams, stacking the `items` arrays into one
#' long frame -- one row per (team x record type). Each record type carries
#' a `summary` string (e.g. `"2-0"`). With `detail = TRUE` the per-record
#' statistic breakdown (points-per-game, streak, ...) nested under each
#' record is also expanded. `home_away` identifies which team a row belongs
#' to.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param detail (*Logical*): controls the output shape. One of:
#'
#'   * `FALSE` (default) -- the summary output, one row per
#'     (team x record type), with the columns shown in the *Value*
#'     table below.
#'   * `TRUE` -- a long frame, one row per (team x record x stat)
#'     expanding each record's nested `stats[]` array (see *Details*).
#'
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog ([espn_cfb_teams()]) once and join friendly team fields
#' next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`, inserted immediately after
#' `team_id`.
#' Composes with `detail` -- both output shapes carry `team_id`. A catalog
#' failure degrades to `NA` rather than erroring the wrapper. Set `FALSE`
#' to skip the catalog fetch and the join.
#' @return A data frame with one row per team-record type (when
#' `detail = FALSE`):
#'
#'    |col_name           |types     |description                                            |
#'    |:------------------|:---------|:------------------------------------------------------|
#'    |game_id            |character |ESPN game identifier.                                  |
#'    |team_id            |character |ESPN team id for the team.                             |
#'    |team_name          |character |Team nickname; `team_detail = TRUE` only.              |
#'    |team_abbreviation  |character |Team abbreviation; `team_detail = TRUE` only.          |
#'    |team_location      |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name  |character |Full team display name; `team_detail = TRUE` only.     |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only. |
#'    |team_nickname      |character |Team nickname label; `team_detail = TRUE` only.        |
#'    |team_color         |character |Primary team color; `team_detail = TRUE` only.         |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.      |
#'    |team_logo_href     |character |Default team logo URL; `team_detail = TRUE` only.      |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |home_away          |character |`home` or `away`.                                      |
#'    |record_id          |character |ESPN record-type id.                                   |
#'    |name               |character |Record-type key (e.g. `overall`, `Home`, `Road`).      |
#'    |abbreviation       |character |Record-type abbreviation.                              |
#'    |display_name       |character |Human-readable record-type name.                       |
#'    |short_display_name |character |Short human-readable record-type name.                 |
#'    |description        |character |ESPN's description of the record type.                 |
#'    |type               |character |Record-type category (e.g. `total`, `home`, `road`).   |
#'    |summary            |character |Win-loss summary string (e.g. `2-0`).                  |
#'    |display_value      |character |Display-formatted record value.                        |
#'    |value              |numeric   |Numeric record value.                                  |
#'    |record_ref         |character |`$ref` URL to the record resource.                     |
#'
#' @details
#' When `detail = TRUE` the returned frame is in long format with one row
#' per (team x record x stat), with columns: `game_id`, `team_id`,
#' `home_away`, `record_type` (the record-type key, e.g. `overall`),
#' `record_summary` (the record's win-loss summary string), `stat_name`,
#' `stat_type` (the stat-type key, e.g. `wins`), `abbreviation`,
#' `display_name`, `short_display_name`, `description` (ESPN's description
#' of the stat), `value`, and `display_value`.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Team Records
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_team_records(game_id = 401628339))
#'   try(espn_cfb_game_team_records(game_id = 401628339, detail = TRUE))
#'   try(espn_cfb_game_team_records(game_id = 401628339,
#'                                  team_detail = FALSE))
#' }
espn_cfb_game_team_records <- function(game_id = NULL, detail = FALSE,
                                       team_detail = TRUE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game team records endpoint.")
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      comp_url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}/competitions/{game_id}/competitors",
        "?lang=en&region=us"
      )
      comp_raw <- get_json(comp_url)
      competitors <- comp_raw[["items"]]
      if (is.null(competitors) || length(competitors) == 0) {
        return(df)
      }

      rows <- list()
      for (c in competitors) {
        team_ref <- if (is.list(c[["team"]])) {
          c[["team"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          as.character(c[["id"]] %||% NA)
        }
        home_away <- c[["homeAway"]] %||% NA_character_

        rec_url <- glue::glue(
          "https://sports.core.api.espn.com/v2/sports/football/leagues/",
          "college-football/events/{game_id}/competitions/{game_id}/",
          "competitors/{team_id}/records?lang=en&region=us"
        )
        rec_raw <- get_json(rec_url)
        for (it in rec_raw[["items"]] %||% list()) {
          if (isTRUE(detail)) {
            rec_type <- as.character(it[["name"]] %||% NA)
            rec_summary <- as.character(it[["summary"]] %||% NA)
            for (s in it[["stats"]] %||% list()) {
              rows[[length(rows) + 1L]] <- data.frame(
                game_id            = as.character(game_id),
                team_id            = as.character(team_id),
                home_away          = home_away,
                record_type        = rec_type,
                record_summary     = rec_summary,
                stat_name          = as.character(s[["name"]] %||% NA),
                stat_type          = as.character(s[["type"]] %||% NA),
                abbreviation       = as.character(s[["abbreviation"]] %||% NA),
                display_name       = as.character(s[["displayName"]] %||% NA),
                short_display_name = as.character(s[["shortDisplayName"]] %||% NA),
                description        = as.character(s[["description"]] %||% NA),
                value              = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
                display_value      = as.character(s[["displayValue"]] %||% NA),
                stringsAsFactors   = FALSE
              )
            }
          } else {
            rows[[length(rows) + 1L]] <- data.frame(
              game_id            = as.character(game_id),
              team_id            = as.character(team_id),
              home_away          = home_away,
              record_id          = as.character(it[["id"]] %||% NA),
              name               = it[["name"]] %||% NA_character_,
              abbreviation       = it[["abbreviation"]] %||% NA_character_,
              display_name       = it[["displayName"]] %||% NA_character_,
              short_display_name = it[["shortDisplayName"]] %||% NA_character_,
              description        = it[["description"]] %||% NA_character_,
              type               = it[["type"]] %||% NA_character_,
              summary            = it[["summary"]] %||% NA_character_,
              display_value      = as.character(it[["displayValue"]] %||% NA),
              value              = suppressWarnings(as.numeric(it[["value"]] %||% NA)),
              record_ref         = as.character(it[["$ref"]] %||% NA),
              stringsAsFactors   = FALSE
            )
          }
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      rec_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested --
      # both `detail` shapes carry team_id.
      if (isTRUE(team_detail)) {
        rec_df <- .espn_cfb_attach_team_detail(rec_df, .espn_cfb_team_lookup())
      }

      df <- rec_df |>
        make_cfbfastR_data("Game team records data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game team records data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Team Roster**
#' @description Get the game-day roster for both teams in a single college
#' football game, including each player's jersey number, starter flag, and
#' active/did-not-play status.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/competitors/{team_id}/roster`.
#' This wrapper reads the teams list for the game and fetches the
#' roster resource for **both** teams, stacking the `entries` arrays into
#' one long frame -- one row per (team x rostered player). `home_away`
#' identifies which team a row belongs to. Players are returned as ESPN
#' athlete ids; join to another athlete source for names.
#'
#' When `position_detail = TRUE` (the default) the ESPN position catalog
#' ([espn_cfb_positions()]) is fetched once and joined onto `position_id`,
#' so the output carries the full position name / abbreviation rather than
#' the bare id (see *Details*).
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param position_detail (*Logical*): when `TRUE` (default), fetch the
#' ESPN position catalog once and join it onto `position_id`, appending the
#' five `position_*` detail columns shown in the *Value* table. A catalog
#' failure degrades to `NA` rather than erroring the wrapper. Set `FALSE`
#' to skip the extra fetch and return the original column set.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog ([espn_cfb_teams()]) once and join friendly team fields
#' next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`, inserted immediately after
#' `team_id`.
#' A catalog failure degrades to `NA` rather than erroring the wrapper. Set
#' `FALSE` to skip the catalog fetch and the join.
#' @return A data frame with one row per rostered player:
#'
#'    |col_name              |types     |description                                            |
#'    |:---------------------|:---------|:------------------------------------------------------|
#'    |game_id               |character |ESPN game identifier.                                  |
#'    |team_id               |character |ESPN team id for the team.                             |
#'    |team_name             |character |Team nickname; `team_detail = TRUE` only.              |
#'    |team_abbreviation     |character |Team abbreviation; `team_detail = TRUE` only.          |
#'    |team_location         |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name     |character |Full team display name; `team_detail = TRUE` only.     |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.   |
#'    |team_nickname         |character |Team nickname label; `team_detail = TRUE` only.        |
#'    |team_color            |character |Primary team color; `team_detail = TRUE` only.         |
#'    |team_alternate_color  |character |Alternate team color; `team_detail = TRUE` only.       |
#'    |team_logo_href        |character |Default team logo URL; `team_detail = TRUE` only.      |
#'    |team_logo_dark_href   |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |home_away             |character |`home` or `away`.                                      |
#'    |athlete_id            |character |ESPN athlete id (parsed from `athlete_ref`).           |
#'    |player_id             |character |ESPN player id from the roster entry.                  |
#'    |display_name          |character |Player display name as shown by ESPN.                  |
#'    |jersey                |character |Jersey number.                                         |
#'    |position_id           |character |ESPN position id (parsed from `position_ref`).         |
#'    |period                |integer   |Period the player entered the game (0 if none).        |
#'    |starter               |logical   |`TRUE` if the player started the game.                 |
#'    |active                |logical   |`TRUE` if the player was active for the game.          |
#'    |did_not_play          |logical   |`TRUE` if the player did not play.                     |
#'    |valid                 |logical   |`TRUE` if the roster entry is flagged valid by ESPN.   |
#'    |athlete_ref           |character |`$ref` URL to the athlete-in-season resource.          |
#'    |position_ref          |character |`$ref` URL to the position resource.                   |
#'    |position_name         |character |Position name (e.g. `Quarterback`); `position_detail = TRUE` only. |
#'    |position_display_name |character |Human-readable position name; `position_detail = TRUE` only. |
#'    |position_abbreviation |character |Position abbreviation (e.g. `QB`); `position_detail = TRUE` only. |
#'    |position_leaf         |logical   |`TRUE` for a most-specific (leaf) position; `position_detail = TRUE` only. |
#'    |position_parent_id    |character |ESPN id of the parent position; `position_detail = TRUE` only. |
#'
#' @details
#' When `position_detail = TRUE` (the default), five columns are appended
#' by joining the ESPN position catalog ([espn_cfb_positions()]) on
#' `position_id`: `position_name`, `position_display_name`,
#' `position_abbreviation`, `position_leaf`, and `position_parent_id`.
#' The catalog is fetched once per call. A roster entry whose
#' `position_id` is missing or unmatched receives `NA` for all five, and a
#' catalog-fetch failure degrades the whole set to `NA` rather than
#' erroring the wrapper. With `position_detail = FALSE` the five columns
#' are omitted and the original roster schema is returned unchanged.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Team Roster
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_team_roster(game_id = 401628339))
#'   try(espn_cfb_game_team_roster(game_id = 401628339,
#'                                 position_detail = FALSE))
#'   try(espn_cfb_game_team_roster(game_id = 401628339,
#'                                 team_detail = FALSE))
#' }
espn_cfb_game_team_roster <- function(game_id = NULL,
                                      position_detail = TRUE,
                                      team_detail = TRUE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game team roster endpoint.")
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      # Position catalog fetched once per call when position_detail = TRUE
      # -- the lookup degrades to empty on any catalog failure, so the
      # join NA-fills rather than erroring the wrapper.
      pos_lk <- if (isTRUE(position_detail)) {
        .espn_cfb_position_lookup()
      } else {
        list()
      }

      comp_url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}/competitions/{game_id}/competitors",
        "?lang=en&region=us"
      )
      comp_raw <- get_json(comp_url)
      competitors <- comp_raw[["items"]]
      if (is.null(competitors) || length(competitors) == 0) {
        return(df)
      }

      rows <- list()
      for (c in competitors) {
        team_ref <- if (is.list(c[["team"]])) {
          c[["team"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          as.character(c[["id"]] %||% NA)
        }
        home_away <- c[["homeAway"]] %||% NA_character_

        rs_url <- glue::glue(
          "https://sports.core.api.espn.com/v2/sports/football/leagues/",
          "college-football/events/{game_id}/competitions/{game_id}/",
          "competitors/{team_id}/roster?lang=en&region=us"
        )
        rs_raw <- get_json(rs_url)
        for (e in rs_raw[["entries"]] %||% list()) {
          a_ref <- if (is.list(e[["athlete"]])) {
            e[["athlete"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          a_id <- if (!is.na(a_ref)) {
            sub(".*/athletes/([0-9]+).*", "\\1", a_ref)
          } else {
            NA_character_
          }
          p_ref <- if (is.list(e[["position"]])) {
            e[["position"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          p_id <- if (!is.na(p_ref)) {
            sub(".*/positions/([0-9]+).*", "\\1", p_ref)
          } else {
            NA_character_
          }

          rows[[length(rows) + 1L]] <- data.frame(
            game_id      = as.character(game_id),
            team_id      = as.character(team_id),
            home_away    = home_away,
            athlete_id   = a_id,
            player_id    = as.character(e[["playerId"]] %||% NA),
            display_name = as.character(e[["displayName"]] %||% NA),
            jersey       = as.character(e[["jersey"]] %||% NA),
            position_id  = p_id,
            period       = suppressWarnings(as.integer(e[["period"]] %||% NA)),
            starter      = as.logical(e[["starter"]] %||% NA),
            active       = as.logical(e[["active"]] %||% NA),
            did_not_play = as.logical(e[["didNotPlay"]] %||% NA),
            valid        = as.logical(e[["valid"]] %||% NA),
            athlete_ref  = a_ref,
            position_ref = p_ref,
            stringsAsFactors = FALSE
          )
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      roster_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN position catalog onto position_id when requested --
      # adds position_name / _display_name / _abbreviation / _leaf /
      # _parent_id. position_detail = FALSE leaves the frame untouched.
      if (isTRUE(position_detail)) {
        roster_df <- .espn_cfb_attach_position_detail(roster_df, pos_lk)
      }

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        roster_df <- .espn_cfb_attach_team_detail(
          roster_df, .espn_cfb_team_lookup()
        )
      }

      df <- roster_df |>
        make_cfbfastR_data("Game team roster data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game team roster data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Team Statistics**
#' @description Get the full team box-score statistics for both teams in a
#' single college football game, in long format.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/competitors/{team_id}/statistics`.
#' This wrapper reads the teams list for the game and fetches the
#' statistics resource for **both** teams, flattening the nested
#' `splits -> categories -> stats` tree into one long frame: one row per
#' (team x category x stat). The long shape absorbs ESPN's habit of adding
#' and retiring stat keys across seasons. Pivot wider with
#' [tidyr::pivot_wider()] keyed on `stat_name` when a wide team box is wanted.
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`. A catalog failure degrades
#' to `NA`
#' rather than erroring the wrapper. Set `team_detail = FALSE` to skip the
#' catalog fetch and the join.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per team-category-stat:
#'
#'    |col_name               |types     |description                                            |
#'    |:----------------------|:---------|:------------------------------------------------------|
#'    |game_id                |character |ESPN game identifier.                                  |
#'    |team_id                |character |ESPN team id for the team.                             |
#'    |team_name              |character |Team nickname; `team_detail = TRUE` only.              |
#'    |team_abbreviation      |character |Team abbreviation; `team_detail = TRUE` only.          |
#'    |team_location          |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name      |character |Full team display name; `team_detail = TRUE` only.     |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.    |
#'    |team_nickname          |character |Team nickname label; `team_detail = TRUE` only.        |
#'    |team_color             |character |Primary team color; `team_detail = TRUE` only.         |
#'    |team_alternate_color   |character |Alternate team color; `team_detail = TRUE` only.       |
#'    |team_logo_href         |character |Default team logo URL; `team_detail = TRUE` only.      |
#'    |team_logo_dark_href    |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |home_away              |character |`home` or `away`.                                      |
#'    |split_id               |character |ESPN statistics-split id.                              |
#'    |split_name             |character |ESPN statistics-split name (e.g. `Total`).             |
#'    |split_abbreviation     |character |ESPN statistics-split abbreviation.                    |
#'    |category_name          |character |Stat category key (e.g. `general`, `passing`).         |
#'    |category_display       |character |Human-readable category name.                          |
#'    |category_short_display |character |Short human-readable category name.                    |
#'    |category_abbreviation  |character |Stat-category abbreviation.                            |
#'    |category_summary       |character |ESPN's summary string for the category.                |
#'    |stat_name              |character |Internal stat key (e.g. `passingYards`).               |
#'    |abbreviation           |character |Stat abbreviation.                                     |
#'    |display_name           |character |Human-readable stat name.                              |
#'    |short_display_name     |character |Short human-readable stat name.                        |
#'    |value                  |numeric   |Stat value.                                            |
#'    |display_value          |character |Display-formatted stat value as shown on ESPN.         |
#'    |description            |character |ESPN's description of the stat.                        |
#'    |statistics_ref         |character |`$ref` URL to the team's statistics resource.          |
#'    |team_ref               |character |`$ref` URL to the team-in-season resource.             |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Team Statistics
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_team_statistics(game_id = 401628339))
#'   try(espn_cfb_game_team_statistics(game_id = 401628339,
#'                                     team_detail = FALSE))
#' }
espn_cfb_game_team_statistics <- function(game_id = NULL,
                                          team_detail = TRUE) {

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game team statistics endpoint.")
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    res <- httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform()
    check_status(res)
    res |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      comp_url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}/competitions/{game_id}/competitors",
        "?lang=en&region=us"
      )
      comp_raw <- get_json(comp_url)
      competitors <- comp_raw[["items"]]
      if (is.null(competitors) || length(competitors) == 0) {
        return(df)
      }

      rows <- list()
      for (c in competitors) {
        team_ref <- if (is.list(c[["team"]])) {
          c[["team"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          as.character(c[["id"]] %||% NA)
        }
        home_away <- c[["homeAway"]] %||% NA_character_

        st_url <- glue::glue(
          "https://sports.core.api.espn.com/v2/sports/football/leagues/",
          "college-football/events/{game_id}/competitions/{game_id}/",
          "competitors/{team_id}/statistics?lang=en&region=us"
        )
        st_raw <- get_json(st_url)
        statistics_ref <- as.character(st_raw[["$ref"]] %||% NA)
        st_team_ref <- if (is.list(st_raw[["team"]])) {
          as.character(st_raw[["team"]][["$ref"]] %||% NA)
        } else {
          NA_character_
        }
        splits <- st_raw[["splits"]]
        split_id   <- if (is.list(splits)) as.character(splits[["id"]] %||% NA) else NA_character_
        split_name <- if (is.list(splits)) as.character(splits[["name"]] %||% NA) else NA_character_
        split_abbr <- if (is.list(splits)) as.character(splits[["abbreviation"]] %||% NA) else NA_character_
        cats <- if (is.list(splits)) splits[["categories"]] %||% list() else list()
        for (cat in cats) {
          cat_name  <- cat[["name"]] %||% NA_character_
          cat_disp  <- cat[["displayName"]] %||% NA_character_
          cat_sdisp <- cat[["shortDisplayName"]] %||% NA_character_
          cat_abbr  <- cat[["abbreviation"]] %||% NA_character_
          cat_summ  <- cat[["summary"]] %||% NA_character_
          for (s in cat[["stats"]] %||% list()) {
            rows[[length(rows) + 1L]] <- data.frame(
              game_id                = as.character(game_id),
              team_id                = as.character(team_id),
              home_away              = home_away,
              split_id               = split_id,
              split_name             = split_name,
              split_abbreviation     = split_abbr,
              category_name          = cat_name,
              category_display       = cat_disp,
              category_short_display = cat_sdisp,
              category_abbreviation  = cat_abbr,
              category_summary       = cat_summ,
              stat_name              = s[["name"]] %||% NA_character_,
              abbreviation           = s[["abbreviation"]] %||% NA_character_,
              display_name           = s[["displayName"]] %||% NA_character_,
              short_display_name     = s[["shortDisplayName"]] %||% NA_character_,
              value                  = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
              display_value          = as.character(s[["displayValue"]] %||% NA),
              description            = s[["description"]] %||% NA_character_,
              statistics_ref         = statistics_ref,
              team_ref               = st_team_ref,
              stringsAsFactors       = FALSE
            )
          }
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      ts_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        ts_df <- .espn_cfb_attach_team_detail(ts_df, .espn_cfb_team_lookup())
      }

      df <- ts_df |>
        make_cfbfastR_data("Game team statistics data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game team statistics data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Game Teams**
#' @description Get the two teams (home and away teams) for a single
#' college football game, with team identifiers, home/away designation,
#' winner flag, and the `$ref` URLs to every per-team sub-resource.
#' @details Wraps the ESPN core-v2 endpoint
#' `events/{game_id}/competitions/{game_id}/competitors`. The competition
#' id always equals the game id. By default returns one row per team (two
#' rows per game). Each row carries the `$ref` URLs ESPN publishes for that
#' team's score, linescores, roster, statistics, leaders, and record
#' resources -- the dedicated `espn_cfb_game_team_*()` wrappers fetch
#' and flatten those resources for you. `curated_rank` is the AP/Coaches-poll
#' style rank ESPN attaches to the team at game time.
#'
#' The `format` argument controls the output shape:
#'
#'   * `"long"` (default) -- one row per competitor (two rows per
#'     game), with the `home_away` column, as shown in the *Value* table.
#'   * `"wide"` -- **one row per game**: every per-competitor column
#'     is pivoted to a `home_*` / `away_*` column keyed off the
#'     `home_away` value (e.g. `home_team_id`, `home_winner`,
#'     `home_curated_rank`, `away_team_id`, `away_winner`, ...).
#'     `game_id` stays a single key column, so a `"wide"` result is
#'     directly joinable onto any one-row-per-game table.
#'
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to every team-id column -- `team_id` and `competitor_id`. For
#' `team_id` the siblings are `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`, `team_logo_href`,
#' `team_logo_dark_href`; `competitor_id` gains the parallel
#' `competitor_name`, `competitor_abbreviation`, .... `team_detail`
#' composes with `format` -- in `"wide"` mode the `home_team_id` /
#' `away_team_id` columns get `home_team_name` / `away_team_name` / etc.
#' too. A catalog failure degrades to `NA` rather than erroring the
#' wrapper. Set `team_detail = FALSE` to skip the catalog fetch and the
#' join.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to every team-id
#' column (`team_id`, `competitor_id`; see *Details*). Set `FALSE` to skip
#' the catalog fetch and the join.
#' @param format (*Character*): output shape, one of `"long"` (default,
#' one row per competitor) or `"wide"` (one row per game with `home_*` /
#' `away_*` columns). See *Details*.
#' @return A data frame. When `format = "long"` (default), one row per team
#' (two per game):
#'
#'    |col_name        |types     |description                                            |
#'    |:---------------|:---------|:------------------------------------------------------|
#'    |game_id         |character |ESPN game identifier.                                  |
#'    |competitor_id   |character |ESPN competitor id (equals the team id).               |
#'    |competitor_name |character |Team nickname; `team_detail = TRUE` only.              |
#'    |competitor_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.   |
#'    |competitor_location|character |Team location / school; `team_detail = TRUE` only.  |
#'    |competitor_display_name|character |Full team display name; `team_detail = TRUE` only.|
#'    |competitor_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |competitor_nickname|character |Team nickname label; `team_detail = TRUE` only.     |
#'    |competitor_color|character |Primary team color; `team_detail = TRUE` only.         |
#'    |competitor_alternate_color|character |Alternate team color; `team_detail = TRUE` only.   |
#'    |competitor_logo_href|character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |competitor_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |team_id         |character |ESPN team id (parsed from `team_ref`).                 |
#'    |team_name       |character |Team nickname; `team_detail = TRUE` only.              |
#'    |team_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.         |
#'    |team_location   |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name|character |Full team display name; `team_detail = TRUE` only.    |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname   |character |Team nickname label; `team_detail = TRUE` only.        |
#'    |team_color      |character |Primary team color; `team_detail = TRUE` only.         |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.     |
#'    |team_logo_href  |character |Default team logo URL; `team_detail = TRUE` only.      |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |order           |integer   |Team order within the competition (0 = first).         |
#'    |home_away       |character |`home` or `away`.                                      |
#'    |winner          |logical   |`TRUE` if this team won the game.                      |
#'    |competitor_type |character |Competitor type (e.g. `team`).                         |
#'    |curated_rank    |integer   |Curated poll rank at game time (`99` if unranked).     |
#'    |uid             |character |ESPN universal identifier for the team.                |
#'    |team_ref        |character |`$ref` URL to the team-in-season resource.             |
#'    |score_ref       |character |`$ref` URL to the team score resource.                 |
#'    |linescores_ref  |character |`$ref` URL to the team linescores resource.            |
#'    |roster_ref      |character |`$ref` URL to the team roster resource.                |
#'    |statistics_ref  |character |`$ref` URL to the team statistics resource.            |
#'    |leaders_ref     |character |`$ref` URL to the team leaders resource.               |
#'    |record_ref      |character |`$ref` URL to the team record resource.                |
#'    |ranks_ref       |character |`$ref` URL to the team week-ranks resource.            |
#'    |competitor_ref  |character |`$ref` URL to the competitor resource itself.          |
#'
#' When `format = "wide"` the result is a single row per game: `game_id`
#' stays one key column and every other column above is emitted twice,
#' prefixed `home_` and `away_` (e.g. `home_team_id`, `home_team_name`,
#' `home_winner`, `home_curated_rank`, `away_team_id`, `away_team_name`,
#' ...).
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Game Teams
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_game_teams(game_id = 401628339))
#'   try(espn_cfb_game_teams(game_id = 401628339, format = "wide"))
#'   try(espn_cfb_game_teams(game_id = 401628339, team_detail = FALSE))
#' }
espn_cfb_game_teams <- function(game_id = NULL,
                                team_detail = TRUE,
                                format = c("long", "wide")) {
  format <- match.arg(format)

  # Validation ----
  if (is.null(game_id)) {
    cli::cli_abort("{.arg game_id} is required for the ESPN game teams endpoint.")
  }

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/events/{game_id}/competitions/{game_id}/competitors",
    "?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)

      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]]
      if (is.null(items) || length(items) == 0) {
        return(df)
      }

      sub_ref <- function(x) {
        if (is.list(x)) x[["$ref"]] %||% NA_character_ else NA_character_
      }

      rows <- list()
      for (it in items) {
        team_ref <- sub_ref(it[["team"]])
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          NA_character_
        }
        curated <- it[["curatedRank"]]
        curated_rank <- if (is.list(curated)) {
          suppressWarnings(as.integer(curated[["current"]] %||% NA))
        } else {
          NA_integer_
        }

        rows[[length(rows) + 1L]] <- data.frame(
          game_id         = as.character(game_id),
          competitor_id   = as.character(it[["id"]] %||% NA),
          team_id         = team_id,
          order           = suppressWarnings(as.integer(it[["order"]] %||% NA)),
          home_away       = it[["homeAway"]] %||% NA_character_,
          winner          = as.logical(it[["winner"]] %||% NA),
          competitor_type = it[["type"]] %||% NA_character_,
          curated_rank    = curated_rank,
          uid             = it[["uid"]] %||% NA_character_,
          team_ref        = team_ref,
          score_ref       = sub_ref(it[["score"]]),
          linescores_ref  = sub_ref(it[["linescores"]]),
          roster_ref      = sub_ref(it[["roster"]]),
          statistics_ref  = sub_ref(it[["statistics"]]),
          leaders_ref     = sub_ref(it[["leaders"]]),
          record_ref      = sub_ref(it[["record"]]),
          ranks_ref       = sub_ref(it[["ranks"]]),
          competitor_ref  = as.character(it[["$ref"]] %||% NA),
          stringsAsFactors = FALSE
        )
      }

      teams_df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto team_id / competitor_id when
      # requested -- done before the optional wide pivot so the friendly
      # columns get pivoted too.
      if (isTRUE(team_detail)) {
        teams_df <- .espn_cfb_attach_team_detail(
          teams_df, .espn_cfb_team_lookup()
        )
      }

      if (format == "wide") {
        # Collapse to one row per game: every per-competitor column is
        # pivoted to a home_* / away_* column keyed off `home_away`.
        # `game_id` stays a single key column.
        per_team_cols <- setdiff(colnames(teams_df),
                                 c("game_id", "home_away"))
        # The game_id value is identical across both rows.
        gid <- if (nrow(teams_df) > 0) teams_df[["game_id"]][1] else
          as.character(game_id)
        wide <- list(game_id = gid)
        for (side in c("home", "away")) {
          side_df <- teams_df[teams_df[["home_away"]] == side, , drop = FALSE]
          for (cn in per_team_cols) {
            val <- if (nrow(side_df) > 0) side_df[[cn]][1] else NA
            wide[[paste0(side, "_", cn)]] <- val
          }
        }
        teams_df <- dplyr::as_tibble(wide)
      }

      df <- teams_df |>
        make_cfbfastR_data("Game teams data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN game teams data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Get ESPN college football PBP data
#' @author Saiem Gilani
#' @param game_id Game ID
#' @param epa_wpa Logical parameter (TRUE/FALSE) to return the Expected Points Added/Win Probability Added variables
#' @return A data frame with college football play-by-play data
#' @keywords CFB PBP
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows
#' @importFrom tidyr unnest unnest_wider everything
#' @param engine (*Character* optional): which play-by-play engine to run.
#' One of `"v2"`, `"legacy"` or `"auto"`; `NULL` (default) resolves from
#' `getOption("cfbfastR.pbp_engine")`, which itself defaults to `"v2"` as of
#' this release. `"legacy"` is the escape hatch that reproduces the pre-2.3.0
#' frame; `"auto"` means whatever this version of the package considers current,
#' so it is carried forward by future default flips.
#' @param output (*Character*): modeled-output column set, one of `"default"`,
#' `"lean"` or `"full"`. Only meaningful when the call reaches the v2 engine; it
#' is accepted here so a delegating caller can reach the tier selector without
#' switching to the `espn_cfb_pbp_v2()` name.
#' @export
#'
#' @examples
#'  \donttest{
#'    try(espn_cfb_pbp(game_id = 401282614, epa_wpa = TRUE))
#'  }
#'
espn_cfb_pbp <- function(game_id, epa_wpa = FALSE, engine = NULL, output = "default"){
  # See .pbp_engine(): per-call `engine=` beats the session option, which beats
  # the default -- and that default is now "v2". `output` is accepted here so a
  # delegating caller can
  # reach the tier selector without switching to the v2 name.
  if (identical(.pbp_engine(engine), "v2")) {
    return(espn_cfb_pbp_v2(game_id = game_id, epa_wpa = epa_wpa, output = output))
  }
  .pbp_engine_nudge("espn_cfb_pbp", "espn_cfb_pbp_v2")

  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old))

  play_base_url <- "http://site.api.espn.com/apis/site/v2/sports/football/college-football/summary"

  ## Inputs
  ## game_id
  full_url <- paste0(play_base_url,
                     "?event=", game_id)

  plays_df <- data.frame()

  tryCatch(
    expr = {

      res <- httr2::request(full_url) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()

      # Check the result
      check_status(res)

      resp <- res |>
        httr2::resp_body_string(encoding = "UTF-8")

      raw_df <- jsonlite::fromJSON(resp)
      playByPlaySource = raw_df[["header"]][["competitions"]][["playByPlaySource"]]
      raw_play_df <- jsonlite::fromJSON(jsonlite::toJSON(raw_df), flatten = TRUE)
      plays_df <- data.frame()
      #---- Play-by-Play ------
      if (playByPlaySource == 'full') {
        drives <- raw_play_df[["drives"]]
        plays_prev <- data.frame()
        plays_curr <- data.frame()
        if ("previous" %in% names(drives)) {
          drives_previous <- drives[["previous"]]

          colnames(drives_previous)[1:8] <- paste0("drive_", colnames(drives_previous)[1:8])
          colnames(drives_previous)[10:25] <- paste0("drive_", colnames(drives_previous)[10:25])
          drive_nums <- c(1:nrow(drives_previous))

          drives_prev <- purrr::map_df(drive_nums, function(x){
            drives_previous[x,"drive_team.logo"] <- drives_previous$drive_team.logos[[x]]$href[1]
            drives_previous[x,"drive_team.logo_dark"] <- drives_previous$drive_team.logos[[x]]$href[2]
            df <- drives_previous[x,] |>
              tidyr::unnest_longer('plays')
            return(df)
          })
          plays_prev <- jsonlite::fromJSON(jsonlite::toJSON(drives_prev), flatten = TRUE)
        }
        if ("current" %in% names(drives)) {
          drives_current <- drives[["current"]]

          colnames(drives_current)[1:8] <- paste0("drive_", colnames(drives_current)[1:8])
          colnames(drives_current)[10:25] <- paste0("drive_", colnames(drives_current)[10:25])
          drive_nums_cur <- c(1:nrow(drives_current))
          drives_curr <- purrr::map_df(drive_nums_cur, function(x){
            drives_current[x,"drive_team.logo"] <- drives_current$drive_team.logos[[x]]$href[1]
            drives_current[x,"drive_team.logo_dark"] <- drives_current$drive_team.logos[[x]]$href[2]
            df <- drives_current[x,] |>
              tidyr::unnest_longer('plays')
            return(df)
          })
          plays_curr <- jsonlite::fromJSON(jsonlite::toJSON(drives_curr), flatten = TRUE)
        }

        plays_df <- plays_curr |>
          dplyr::bind_rows(plays_prev) |>
          janitor::clean_names() |>
          dplyr::select(-"drive_team_logos")

      }
      plays_df$season <- raw_df[['header']][['season']][['year']]
      plays_df$season_type <- raw_df[['header']][['season']][['type']]
      plays_df$week <- raw_df[['header']][['week']]
      plays_df$neutral_site <- raw_df[['header']][['competitions']][['neutralSite']]
      plays_df$conference_competition <- raw_df[['header']][['competitions']][['conferenceCompetition']]
      plays_df$game_date <- raw_df[['header']][['competitions']][['date']]
      competitors <- jsonlite::fromJSON(jsonlite::toJSON(raw_df[['header']][['competitions']][['competitors']][[1]]), flatten = TRUE)
      plays_df$home_team_id <- (competitors |> dplyr::filter(.data$homeAway == 'home'))[['id']]
      plays_df$home_team_name <- (competitors |> dplyr::filter(.data$homeAway == 'home'))[['team.name']]
      plays_df$home_team <- (competitors |> dplyr::filter(.data$homeAway == 'home'))[['team.location']]
      plays_df$home_team_abbreviation <- (competitors |> dplyr::filter(.data$homeAway == 'home'))[['team.abbreviation']]
      plays_df$home_team_color <- (competitors |> dplyr::filter(.data$homeAway == 'home'))[['team.color']]
      plays_df$home_team_alternate_color <- (competitors |> dplyr::filter(.data$homeAway == 'home'))[['team.alternateColor']]
      plays_df$home_team_rank <- (competitors |> dplyr::filter(.data$homeAway == 'home'))[['rank']]
      plays_df$away_team_id <- (competitors |> dplyr::filter(.data$homeAway == 'away'))[['id']]
      plays_df$away_team_name <- (competitors |> dplyr::filter(.data$homeAway == 'away'))[['team.name']]
      plays_df$away_team <- (competitors |> dplyr::filter(.data$homeAway == 'away'))[['team.location']]
      plays_df$away_team_abbreviation <- (competitors |> dplyr::filter(.data$homeAway == 'away'))[['team.abbreviation']]
      plays_df$away_team_color <- (competitors |> dplyr::filter(.data$homeAway == 'away'))[['team.color']]
      plays_df$away_team_alternate_color <- (competitors |> dplyr::filter(.data$homeAway == 'away'))[['team.alternateColor']]
      plays_df$away_team_rank <- (competitors |> dplyr::filter(.data$homeAway == 'away'))[['rank']]

      # #---- Pickcenter ------
      # pickcenter <- raw_df[['pickcenter']]

      if (isTRUE(epa_wpa)) {
        plays_df <- plays_df |>
          dplyr::rename(
            "play_text" = "plays_text",
            "play_type" = "plays_type_text",
            "down" = "plays_start_down",
            "distance" = "plays_start_distance",
            "period" = "plays_period_number",
            "id_play" = "plays_id",
            "home" = "home_team",
            "away" = "away_team",
            "yards_to_goal" = "plays_start_yards_to_endzone",
            "yards_gained" = "plays_stat_yardage",
            "yard_line" = "plays_start_yard_line"
          ) |>
          dplyr::mutate(
            game_id = game_id,
            clock_minutes = as.numeric(stringr::str_extract(.data$plays_clock_display_value,".*(?=:)")),
            clock_seconds = as.numeric(stringr::str_extract(.data$plays_clock_display_value,"(?<=:).*")),
            offense_play = dplyr::case_when(.data$plays_start_team_id == .data$home_team_id ~ .data$home,
                                     TRUE ~ .data$away),
            defense_play = dplyr::case_when(.data$plays_start_team_id == .data$home_team_id ~ .data$home,
                                     TRUE ~ .data$away),
            offense_score = dplyr::case_when(.data$offense_play == .data$home ~ .data$plays_home_score,
                                             TRUE ~ .data$plays_away_score),
            defense_score = dplyr::case_when(.data$offense_play == .data$home ~ .data$plays_away_score,
                                             TRUE ~ .data$plays_home_score),
            half = dplyr::case_when(period <= 2 ~ 1,
                                    period <= 4 ~ 2,
                                    TRUE ~ period - 2),
            drive_start_field_side = stringr::str_remove(.data$drive_start_text," [0-9]{1,2}"),
            drive_start_yards_to_goal = ifelse(.data$drive_start_field_side == .data$home_team_abbreviation,
                                               100 - .data$drive_start_yard_line,
                                               .data$drive_start_yard_line),
            drive_end_field_side = stringr::str_remove(.data$drive_end_text," [0-9]{1,2}"),
            drive_end_yards_to_goal = ifelse(.data$drive_end_field_side == .data$home_team_abbreviation,
                                             100 - .data$drive_end_yard_line,
                                             .data$drive_end_yard_line),
            drive_number = cumsum(!duplicated(.data$drive_id)),
            ppa = NA_real_ #ppa is from CFBD but is coded into a select in the EPA functions so needs a placeholder
          ) |>
          #Timeout handling
          dplyr::group_by(.data$half) |>
          dplyr::mutate(
            timeout_team = stringr::str_extract(.data$play_text,"(?<=Timeout ).{1,10}(?=,)"),
            home_timeouts = 3 - cumsum(dplyr::case_when(.data$timeout_team == .data$home_team_abbreviation ~ 1,TRUE ~0)),
            away_timeouts = 3 - cumsum(dplyr::case_when(.data$timeout_team == .data$away_team_abbreviation ~ 1,TRUE ~0)),
            offense_timeouts = dplyr::case_when(.data$offense_play == .data$home ~ .data$home_timeouts,
                                                TRUE ~ .data$away_timeouts),
            defense_timeouts = dplyr::case_when(.data$offense_play == .data$home ~ .data$away_timeouts,
                                                TRUE ~ .data$home_timeouts)
          ) |>
          dplyr::ungroup() |>
          penalty_detection() |>
          add_play_counts() |>
          clean_pbp_dat() |>
          clean_drive_dat() |>
          add_yardage() |>
          add_player_cols() |>
          prep_epa_df_after() |>
          create_epa(ep_model = ep_model, fg_model = fg_model) |>
          # create_wpa_betting() |>
          create_wpa_naive(wp_model = wp_model) |>
          dplyr::select(-"ppa") #drop placeholder column

      }
      plays_df <- plays_df |>
        make_cfbfastR_data("Play-by-play data from ESPN.com",Sys.time())

    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no play-by-play data for {game_id} available!"))
    },
    finally = {
    }
  )

  return(plays_df)
}


#' Fetch ESPN CFB core-v2 game-level metadata (season / week / site)
#'
#' Internal helper for [espn_cfb_pbp_v2()]. Hits the ESPN core-v2 event
#' resource `events/{game_id}` once and returns a one-row list with the
#' game-level metadata the legacy [espn_cfb_pbp()] attaches: `season`,
#' `season_type`, `week`, `neutral_site`, `conference_competition`,
#' `game_date`. The `season` / `season_type` / `week` block is exposed by
#' ESPN only as `$ref` URLs of the shape
#' `.../seasons/{year}/types/{type}/weeks/{number}` -- the three integers
#' are parsed directly out of the `week` `$ref` path, so no extra
#' dereference is needed. `neutral_site`, `conference_competition` and
#' `game_date` are read straight off `competitions[[1]]`. A fetch failure
#' degrades every field to `NA` rather than erroring the caller.
#'
#' @param game_id ESPN game identifier.
#' @return A named list of length 6 (possibly all `NA`).
#' @keywords internal
#' @noRd
.espn_cfb_game_meta <- function(game_id) {
  `%||%` <- rlang::`%||%`
  meta <- list(
    season                 = NA_integer_,
    season_type            = NA_integer_,
    week                   = NA_integer_,
    neutral_site           = NA,
    conference_competition = NA,
    game_date              = NA_character_
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  tryCatch(
    expr = {
      url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}?lang=en&region=us"
      )
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)
      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      # season / season_type / week parsed from the week $ref path, which
      # has the shape .../seasons/{year}/types/{type}/weeks/{number}.
      week_ref <- if (is.list(raw[["week"]])) {
        raw[["week"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      if (!is.na(week_ref)) {
        yr <- suppressWarnings(as.integer(
          sub(".*/seasons/([0-9]+)/.*", "\\1", week_ref)
        ))
        ty <- suppressWarnings(as.integer(
          sub(".*/types/([0-9]+)/.*", "\\1", week_ref)
        ))
        wk <- suppressWarnings(as.integer(
          sub(".*/weeks/([0-9]+).*", "\\1", week_ref)
        ))
        if (!is.na(yr)) meta$season <- yr
        if (!is.na(ty)) meta$season_type <- ty
        if (!is.na(wk)) meta$week <- wk
      }
      # season year fallback from the top-level season $ref.
      if (is.na(meta$season) && is.list(raw[["season"]])) {
        sref <- raw[["season"]][["$ref"]] %||% NA_character_
        if (!is.na(sref)) {
          meta$season <- suppressWarnings(as.integer(
            sub(".*/seasons/([0-9]+).*", "\\1", sref)
          ))
        }
      }

      comp <- raw[["competitions"]]
      comp1 <- if (is.list(comp) && length(comp) > 0) comp[[1]] else NULL
      if (is.list(comp1)) {
        meta$neutral_site <- as.logical(comp1[["neutralSite"]] %||% NA)
        meta$conference_competition <-
          as.logical(comp1[["conferenceCompetition"]] %||% NA)
        meta$game_date <- as.character(
          comp1[["date"]] %||% raw[["date"]] %||% NA
        )
      } else {
        meta$game_date <- as.character(raw[["date"]] %||% NA)
      }
    },
    error = function(e) {},
    warning = function(w) {}
  )
  meta
}


#' @title
#' **Get ESPN College Football Play-by-Play (core-v2)**
#' @description The core-v2-sourced successor to [espn_cfb_pbp()]. Returns
#' one tidy row per play for a single college football game, optionally with
#' the full Expected Points Added (EPA) / Win Probability Added (WPA)
#' modeling attached. It supersedes the legacy site-v2 [espn_cfb_pbp()]:
#' instead of parsing the deeply-nested site-v2 `summary` feed, it sources
#' the play-by-play from the structured ESPN core-v2 drives endpoint in a
#' single request via [espn_cfb_game_drives()] -- one structured call rather
#' than a sprawling summary parse, so it is faster and more robust to the
#' site-v2 feed's column drift.
#' @details
#' **Play-by-play assembly (always).** The play rows come from
#' `espn_cfb_game_drives(game_id, plays = "expand", team_detail = TRUE)` --
#' one row per play, in the full [espn_cfb_game_pbp()] schema, with each
#' play's drive-level context carried alongside (`drive_*` columns) and the
#' ESPN team catalog joined onto every team-id column. Game-level metadata
#' matching the legacy [espn_cfb_pbp()] output -- `season`, `season_type`,
#' `week`, `neutral_site`, `conference_competition`, `game_date`, and the
#' `home_team_id` / `home_team` / `away_team_id` / `away_team` (plus
#' abbreviations) -- is attached from the core-v2 event resource and
#' [espn_cfb_game_teams()].
#'
#' **Game-meta bridge.** Season / season_type / week / neutral_site /
#' conference_competition / game_date and the full home/away block --
#' including `*_team_name`, `*_team_color`, `*_team_alternate_color`, and
#' the week-specific `*_team_rank` -- are sourced via
#' `.espn_pbp_game_meta()`, which queries the core-v2 event resource. This
#' makes `espn_cfb_pbp_v2()` a strict meta-column superset of legacy
#' [espn_cfb_pbp()].
#'
#' **Native participant columns.** This wrapper requests
#' `participants = "wide"` and `team_participants = "wide"` from
#' [espn_cfb_game_drives()], so the play frame carries type-keyed
#' `{type}_player_id` / `{type}_player_name` / `{type}_player_position`
#' columns (e.g. `passer_player_id`, `rusher_player_id`, `tackler_player_id`)
#' and `{type}_team_*` columns. Wide mode also emits the
#' `{type}_player_ids` / `{type}_player_names` list-columns; downstream
#' parquet/CSV writers must drop or stringify these before serialization.
#' One additional roster fetch + position-catalog fetch per game.
#'
#' **`epa_wpa` behaviour.** When `epa_wpa = FALSE` (default) the assembled
#' core-v2 frame is returned as-is. When `epa_wpa = TRUE` the core-v2
#' columns are mapped into the exact column schema the legacy
#' [espn_cfb_pbp()] hands to its EPA/WPA pipeline, and the **same** modeling
#' stack is run verbatim -- `penalty_detection()`, `add_play_counts()`,
#' `clean_pbp_dat()`, `clean_drive_dat()`, `add_yardage()`,
#' `add_player_cols()`, `prep_epa_df_after()`, `create_epa()` and
#' `create_wpa_naive()`. The statistical models (the `mgcv` GAMs, the
#' multinomial EP model, the FG model and the WP model shipped with the
#' package) are reused unchanged; this wrapper only supplies the column
#' adapter between the core-v2 play schema and the modeling input contract.
#' The modeled EPA/WPA columns the pipeline emits -- `ep_before`,
#' `ep_after`, `EPA`, `wp_before`, `wp_after`, `wpa`, and the supporting
#' probability and cumulative columns -- are then joined back onto the
#' **full** `epa_wpa = FALSE` context frame by `play_id`. The
#' `epa_wpa = TRUE` output is therefore a strict **superset** of the
#' `epa_wpa = FALSE` output: every game-metadata and drive-context column
#' the default path produces, plus the EPA/WPA model columns. The join is a
#' left join from the context frame, so no play row is dropped and the row
#' count is identical to the `epa_wpa = FALSE` result.
#' @param game_id (*Integer* required): ESPN game identifier.
#' @param epa_wpa (*Logical*): when `TRUE`, run the full EPA/WPA modeling
#' pipeline and return the modeled frame; when `FALSE` (default) return the
#' assembled core-v2 play-by-play frame.
#' @param output (*Character*): controls the modeled-output column set when
#' `epa_wpa = TRUE`. Ignored when `epa_wpa = FALSE`. Defaults to `"default"`.
#' Must be one of:
#'
#' * `"default"` (recommended) -- drops pipeline lag/lead intermediates,
#'   redundant alternates (`sack_vec`, `turnover_indicator`, `kick_play`,
#'   `missing_yard_flag`), and drive-result aliases (`drive_result2`,
#'   `drive_result_detailed_flag`, `lag_drive_result_detailed`,
#'   `lead_drive_result_detailed`, `lag_new_drive_pts`). Keeps
#'   `orig_play_type` and `pts_scored` (they carry useful per-play
#'   information distinct from the canonical columns) and the per-branch
#'   WPA scratchpad. ~75 columns lighter than `"full"`.
#' * `"lean"` -- everything `"default"` drops, plus the WPA
#'   computation scratchpad. For dashboards / game logs.
#' * `"full"` -- legacy behavior, drops only the player-name aliases.
#'
#' @param resolve_names (*Logical*): when `TRUE` (default) and
#' `epa_wpa = TRUE`, spend **one extra request per game** on ESPN's play-by-play
#' sidecar to (a) render participant names in full (`"Jalen Mitchell"` rather
#' than the core-v2 roster's `"J. Mitchell"`) and (b) add the per-player box
#' score as a second identity source, which is the only one available on the
#' large share of games where ESPN 404s the roster resource. Memoised per
#' `game_id`, so the two uses cost one request between them. Set `FALSE` for a
#' bulk sweep that would rather have the short names than the requests. Ignored
#' when `epa_wpa = FALSE`.
#'
#' @return A data frame with one row per play. When `epa_wpa = FALSE`, the
#' assembled core-v2 play-by-play frame:
#'
#'    |col_name               |types     |description                          |
#'    |:----------------------|:---------|:------------------------------------|
#'    |game_id                |character |ESPN game identifier.                |
#'    |play_id                |character |ESPN play id.                        |
#'    |type_text              |character |Play type label (e.g. `Rush`, `Pass Reception`). |
#'
#' (plus the full [espn_cfb_game_drives()] `plays = "expand"` column set --
#' play start/end down, distance, yard line, clock, scores, the `drive_*`
#' drive context, team detail -- and the attached game-metadata columns
#' `season`, `season_type`, `week`, `neutral_site`,
#' `conference_competition`, `game_date`, `home_team_id`, `home_team`,
#' `away_team_id`, `away_team`).
#'
#' When `epa_wpa = TRUE`, every column from the `epa_wpa = FALSE` frame
#' above (game metadata, `drive_*` context, team detail and the full
#' [espn_cfb_game_drives()] play schema) **plus** the modeled EPA/WPA
#' columns produced by the existing pipeline -- `ep_before`, `ep_after`,
#' `EPA`, `wp_before`, `wp_after`, `wpa` and the supporting probability and
#' cumulative columns. The `epa_wpa = TRUE` columns are a strict superset
#' of the `epa_wpa = FALSE` columns, and the row count is unchanged.
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom dplyr filter select rename mutate bind_cols bind_rows group_by ungroup case_when
#' @importFrom stringr str_extract str_remove
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords CFB PBP
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_pbp_v2(game_id = 401628339, epa_wpa = TRUE))
#' }
espn_cfb_pbp_v2 <- function(game_id,
                            epa_wpa       = FALSE,
                            output        = "default",
                            resolve_names = TRUE) {
  if (!is.logical(resolve_names) || length(resolve_names) != 1L ||
      is.na(resolve_names)) {
    cli::cli_abort(c(
      "{.arg resolve_names} must be a single {.code TRUE} or {.code FALSE}.",
      x = "You supplied {.val {resolve_names}}."
    ))
  }
  if (!is.character(output) || length(output) != 1L ||
      !output %in% c("default", "lean", "full")) {
    cli::cli_abort(c(
      "{.arg output} must be one of {.val default}, {.val lean}, or {.val full}.",
      x = "You supplied {.val {output}}."
    ))
  }
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old))

  `%||%` <- rlang::`%||%`

  plays_df <- data.frame()

  tryCatch(
    expr = {
      # --- core-v2 plays + drives + participants + team detail in one call
      expand_df <- espn_cfb_game_drives(
        game_id                = game_id,
        plays                  = "expand",
        participants           = "wide",
        team_participants      = "wide",
        team_detail            = TRUE
      )
      if (!is.data.frame(expand_df) || nrow(expand_df) == 0) {
        cli::cli_alert_warning(
          "No core-v2 play-by-play data available for game {game_id}."
        )
        return(plays_df)
      }

      # --- meta bridge: full reconciled meta union (name/color/rank/...)
      meta <- .espn_pbp_game_meta(game_id)

      plays_df <- expand_df |>
        dplyr::mutate(
          season                    = meta$season,
          season_type               = meta$season_type,
          week                      = meta$week,
          neutral_site              = meta$neutral_site,
          conference_competition    = meta$conference_competition,
          game_date                 = meta$game_date,
          home_team_id              = meta$home_team_id,
          home_team                 = meta$home_team,
          home_team_name            = meta$home_team_name,
          home_team_abbreviation    = meta$home_team_abbreviation,
          home_team_color           = meta$home_team_color,
          home_team_alternate_color = meta$home_team_alternate_color,
          home_team_rank            = meta$home_team_rank,
          away_team_id              = meta$away_team_id,
          away_team                 = meta$away_team,
          away_team_name            = meta$away_team_name,
          away_team_abbreviation    = meta$away_team_abbreviation,
          away_team_color           = meta$away_team_color,
          away_team_alternate_color = meta$away_team_alternate_color,
          away_team_rank            = meta$away_team_rank,
          id_play                   = as.character(.data$play_id)
        )

      if (!isTRUE(epa_wpa)) {
        plays_df <- plays_df |>
          make_cfbfastR_data(
            "Play-by-play data from ESPN (core-v2)", Sys.time()
          )
        return(plays_df)
      }

      # --- epa_wpa = TRUE: adapter -> shared engine ----------------------
      # Refuse to model an obviously malformed feed. A truncated game still
      # models cleanly -- it produces EPA, drive results and a box score that
      # all look reasonable and are all wrong -- and nothing downstream can tell
      # that from a real blowout with a short game script, so the check belongs
      # here or nowhere. `completed` is inferred from the frame rather than
      # fetched: a feed that reached the end of the game contains the play that
      # says so.
      completed <- any(grepl("^End of Game$",
                             plays_df$type_text %||% character(0)))
      if (.pbp_corrupt_check(plays_df, completed = completed)) {
        cli::cli_alert_warning(
          "Play-by-play for game {game_id} looks incomplete
           ({nrow(plays_df)} play{?s}); skipping EPA/WPA modeling."
        )
        return(plays_df |> make_cfbfastR_data(
          "Play-by-play data from ESPN (core-v2)", Sys.time()
        ))
      }

      # The one deliberate extra request, and only when asked for. One payload
      # buys two things: ESPN's FULL athlete names (the core-v2 roster renders
      # them short -- "J. Mitchell" -- which is both a parity divergence and a
      # weaker key for id resolution) and the box-score identity records that
      # cover the games where ESPN 404s the roster resource.
      #
      # It runs BEFORE `context_df` is taken because the participant name
      # columns live on the context frame, and the join below keeps the context
      # copy of any column the engine also produces. Expanding after the split
      # would improve the modeled frame and then discard it.
      sidecar <- if (isTRUE(resolve_names)) {
        .espn_cfb_pbp_sidecar(game_id)
      } else {
        NULL
      }
      if (!is.null(sidecar)) {
        plays_df <- .espn_cfb_expand_participant_names(plays_df, sidecar$names)
      }

      # ESPN's core-v2 play feed carries its OWN `is_turnover` flag, and the
      # join below keeps the context copy of any column the engine also
      # produces -- so ESPN's would silently mask the derived one and leave it
      # disagreeing with `turnover_team`, which is derived. The two are *known*
      # to differ: the derived flag counts giveaways only (interceptions and
      # fumbles lost) so it reconciles against ESPN's official box, while
      # ESPN's per-play flag also fires on blocked kicks. Both are kept, under
      # names that say which is which.
      if ("is_turnover" %in% names(plays_df)) {
        names(plays_df)[names(plays_df) == "is_turnover"] <- "espn_is_turnover"
      }

      context_df <- plays_df

      adapter <- plays_df |>
        dplyr::transmute(
          plays_text                   = .data$text,
          plays_type_text              = .data$type_text,
          plays_start_down             = .data$start_down,
          plays_start_distance         = .data$start_distance,
          plays_period_number          = .data$period,
          plays_id                     = .data$play_id,
          plays_start_yards_to_endzone = .data$start_yards_to_endzone,
          plays_stat_yardage           = .data$stat_yardage,
          plays_start_yard_line        = .data$start_yard_line,
          plays_clock_display_value    = .data$clock,
          plays_start_team_id          = .data$start_team_id,
          plays_home_score             = .data$home_score,
          plays_away_score             = .data$away_score,
          drive_id                     = .data$drive_drive_id,
          drive_start_text             = .data$drive_start_text,
          drive_start_yard_line        = .data$drive_start_yard_line,
          drive_end_text               = .data$drive_end_text,
          drive_end_yard_line          = .data$drive_end_yard_line,
          drive_yards                  = .data$drive_yards,
          home_team                    = .data$home_team,
          away_team                    = .data$away_team,
          home_team_id                 = .data$home_team_id,
          away_team_id                 = .data$away_team_id,
          home_team_abbreviation       = .data$home_team_abbreviation,
          away_team_abbreviation       = .data$away_team_abbreviation
        ) |>
        .espn_to_epa_input(game_id = game_id)

      # ESPN's participants[] names are ALREADY on `plays_df` -- the drives call
      # above asked for `participants = "wide"`. Reshaping that in place costs
      # zero extra requests; fetching a participants feed here would double them.
      part_cols <- intersect(.participant_name_cols, names(plays_df))
      part_id_cols <- intersect(sub("_player_name$", "_player_id", part_cols),
                                names(plays_df))
      participants_df <- if (length(part_cols)) {
        plays_df[, c("play_id", part_cols, part_id_cols), drop = FALSE]
      } else {
        NULL
      }

      # Same story for the roster: `.espn_cfb_participant_roster()` is memoised
      # (see zzz.R) and the drives call already warmed it for this game_id with
      # `position_detail = TRUE`, so this is a cache hit, not a request. The
      # argument must match that call or the memoise key misses.
      roster_df <- .espn_cfb_roster_frame(game_id, position_detail = TRUE)

      # Roster first, box score second -- they agree on ids, so order only
      # decides which source seeds a name. A name that genuinely maps to two
      # ids is dropped as ambiguous, which is the intended conservative
      # behaviour. The box score is the only identity source on the games where
      # ESPN 404s the roster.
      if (!is.null(sidecar) && nrow(sidecar$records)) {
        roster_df <- rbind(roster_df, sidecar$records)
      }

      epa_df <- .run_epa_wpa(
        adapter,
        ep_model     = ep_model,
        fg_model     = fg_model,
        wp_model     = wp_model,
        roster       = roster_df,
        participants = participants_df,
        # The era-aware FG model needs the season; meta$season is resolved
        # from the event's week/season $ref above.
        season       = meta$season
      ) |>
        dplyr::select(-dplyr::any_of("ppa"))   # drop the placeholder

      # --- join modeled columns onto the full context frame by play_id ---
      model_cols <- setdiff(colnames(epa_df),
                            c(colnames(context_df), "id_play"))
      epa_join <- epa_df |>
        dplyr::select(dplyr::all_of(c("id_play", model_cols))) |>
        dplyr::mutate(id_play = as.character(.data$id_play))

      plays_df <- context_df |>
        dplyr::mutate(play_id = as.character(.data$play_id)) |>
        dplyr::left_join(epa_join, by = c("play_id" = "id_play")) |>
        .pbp_apply_output_schema(output = output) |>
        make_cfbfastR_data(
          "Play-by-play data from ESPN (core-v2)", Sys.time()
        )
    },
    error = function(e) {
      cli::cli_alert_warning(
        "ESPN core-v2 PBP unavailable for game {game_id}: {conditionMessage(e)}"
      )
    },
    finally = {}
  )

  return(plays_df)
}
