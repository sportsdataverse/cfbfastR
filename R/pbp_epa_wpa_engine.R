#' Refuse to model a play-by-play feed that is obviously malformed
#'
#' @description Ported from sdv-py's `CFBPlayProcess.corrupt_pbp_check`. Three
#'   heuristics that historically mean ESPN delivered a broken payload: no plays
#'   at all, implausibly few plays for a game that has finished, or implausibly
#'   many.
#'
#' @details The value of this is entirely in *not* publishing. A game with 12
#'   plays still models cleanly -- it produces EPA, drive results and a box score
#'   that all look reasonable and are all wrong, because the feed was truncated.
#'   Downstream there is nothing to distinguish that from a real blowout with a
#'   short game script, so the check has to happen here or not at all.
#'
#'   `completed` gates the two count-based rules deliberately. A game in
#'   progress legitimately has few plays, and rejecting it would turn a live feed
#'   into an error. When the state is unknown (`NA`) only the zero-play rule
#'   applies -- the conservative reading, since that one is malformed at any
#'   point in a game.
#'
#' @param play_df (*data.frame* required): the parsed plays frame.
#' @param completed (*logical* optional): whether the game has finished. `NA`
#'   (default) means unknown.
#' @return `TRUE` when the feed looks corrupt and should not be modeled.
#' @keywords internal
#' @noRd
.pbp_corrupt_check <- function(play_df, completed = NA) {
  n <- if (is.data.frame(play_df)) nrow(play_df) else 0L
  if (n == 0L) return(TRUE)
  if (!isTRUE(completed)) return(FALSE)
  n < 50L || n > 500L
}

#' Modular PBP -- run the EPA/WPA pipeline for a single game
#'
#' The 10-stage chain extracted from the legacy entry points
#' (`cfbd_pbp_data()` per-game block; `espn_cfb_pbp()` and `espn_cfb_pbp_v2()`
#' `epa_wpa = TRUE` block). The reusable, taxonomy-centralized, bug-fixed
#' replacement for those inlined chains.
#'
#' The bug-free helpers (`penalty_detection`, `add_yardage`, `add_player_cols`,
#' `clean_play_text`) are reused directly; the five mutated stages are
#' invoked through their `.pbp_*` counterparts.
#'
#' @param df One game's worth of play rows in the modeling input contract
#'   (see `.cfbd_to_epa_input()` / `.espn_to_epa_input()`).
#' @param ep_model Expected Points model.
#' @param fg_model Field Goal model.
#' @param wp_model Win Probability model.
#' @param clean_text If `TRUE`, run `clean_play_text()` at the start of the
#'   chain (the CFBD path); the ESPN paths default to `FALSE` because the
#'   downstream `.pbp_add_yardage()` already guards on the missing
#'   `cleaned_text` column.
#' @param roster One game's roster (`athlete_id` / `display_name` / `team_id`),
#'   passed in rather than fetched here -- see the call-site comment below.
#' @param participants One row per play of ESPN `participants[]` names, as
#'   `espn_cfb_game_pbp(participants = "wide")` returns. Also passed in: the
#'   ESPN v2 path already has this frame in hand from the drives call, so
#'   threading it costs nothing while fetching it would double the requests.
#' @return The modeled single-game frame.
#' @keywords internal
#' @noRd
.run_epa_wpa <- function(df,
                         ep_model,
                         fg_model,
                         wp_model,
                         clean_text = FALSE,
                         roster = NULL,
                         participants = NULL) {
  if (isTRUE(clean_text)) {
    df <- clean_play_text(df)
  }
  df |>
    penalty_detection() |>
    # Enforcement resolution runs immediately after detection and before
    # anything reads the play's outcome: a nullified play must not be credited
    # with its yards or its touchdown downstream.
    .penalty_enforcement() |>
    .pbp_add_play_counts() |>
    .pbp_clean_pbp_dat() |>
    .pbp_clean_drive_dat() |>
    add_yardage() |>
    # Air yards needs the possessing/defending team ids to side the catch-point
    # abbreviation, so it sits after .pbp_add_play_counts() and before the name
    # extraction -- the same position it holds in sdv-py.
    .pbp_add_air_yards_cols() |>
    add_player_cols() |>
    .pbp_add_pass_direction_cols() |>
    # ESPN's own participants[] names overwrite the regex captures BEFORE the
    # ids are resolved, not after: the whole point is to hand the roster matcher
    # a clean key ("Rod Smith 3 Yd" -> "Rod Smith") instead of asking it to
    # fuzzy-match narration. Ordering these the other way round would resolve
    # the ids off the messy name and then relabel them.
    .pbp_join_participants(participants = participants) |>
    # Team attribution must precede id resolution, not follow it: the role ->
    # team map reads `kicking_team`, `return_team`, `punt_return_team` and
    # `fumble_recovery_team`, so before this stage existed every special-teams
    # role matched against a column that was not there.
    .pbp_add_attribution_cols() |>
    # Identity resolution needs the names add_player_cols() just extracted. The
    # roster is PASSED IN rather than fetched here: one game's play-by-play would
    # otherwise cost an extra roster request per call, and a season sweep would
    # re-request the same two rosters for every game those teams played.
    .pbp_attach_player_ids(roster = roster) |>
    .pbp_prep_epa_df_after() |>
    .pbp_create_epa(ep_model = ep_model, fg_model = fg_model) |>
    .pbp_create_wpa_naive(wp_model = wp_model) |>
    # Additive and self-contained: CP/CPOE lazily loads its own bundled model
    # and emits all-NA columns rather than raising when it or its inputs are
    # unavailable, matching sdv-py `__process_cpoe`.
    .pbp_add_cp_cpoe()
}

#' Modular PBP -- per-game wrapper with min-plays skip and progress
#'
#' Replaces the inlined `purrr::map_dfr()` block in `cfbd_pbp_data()`
#' (lines 586-611). Per-game iteration, skip-short-games guard, and
#' `progressr` progress reporting in one place.
#'
#' @param df Multi-game play data frame (already in modeling input contract).
#' @param ep_model,fg_model,wp_model See `.run_epa_wpa()`.
#' @param clean_text See `.run_epa_wpa()`.
#' @param min_plays Skip games with fewer than this many rows (default 20,
#'   matching the legacy `cfbd_pbp_data()` guard).
#' @param rosters,participants Optional multi-game frames carrying a `game_id`
#'   column; each game is handed only its own slice. Supplying them once for the
#'   whole sweep is the point -- a per-game fetch inside the loop would re-request
#'   the same two rosters for every game those teams played.
#' @return Multi-game modeled frame, one bound row per surviving game.
#' @keywords internal
#' @noRd
#' @importFrom purrr map list_rbind
#' @importFrom cli cli_alert_warning
.run_epa_wpa_by_game <- function(df,
                                 ep_model,
                                 fg_model,
                                 wp_model,
                                 clean_text = FALSE,
                                 min_plays = 20L,
                                 rosters = NULL,
                                 participants = NULL) {
  # Slice a multi-game side frame down to one game, tolerating a frame that has
  # no game_id (a caller who already scoped it) and a game with no rows.
  warned_no_gid <- FALSE
  slice_for <- function(side, gid) {
    if (is.null(side) || !is.data.frame(side) || !nrow(side)) return(NULL)
    if (!"game_id" %in% names(side)) {
      # Handing an unscoped frame to every game is right for a single-game
      # caller and wrong for a sweep -- one game's roster would be applied to
      # all of them. Say so once rather than silently doing it N times.
      if (!warned_no_gid && length(g_ids) > 1L) {
        warned_no_gid <<- TRUE
        cli::cli_alert_warning(
          "A roster/participants frame has no {.field game_id}; applying it to
           all {length(g_ids)} games. Add {.field game_id} to scope it per game."
        )
      }
      return(side)
    }
    s <- side[as.character(side$game_id) == as.character(gid), , drop = FALSE]
    if (nrow(s)) s else NULL
  }
  g_ids <- sort(unique(df$game_id))
  if (length(g_ids) == 0L) return(df[0L, , drop = FALSE])

  p <- if (is_installed("progressr")) {
    progressr::progressor(along = g_ids)
  } else {
    function(...) NULL
  }

  out <- purrr::list_rbind(purrr::map(g_ids, function(gid) {
    game_plays <- df[df$game_id == gid, , drop = FALSE]
    if (nrow(game_plays) < min_plays) {
      cli::cli_alert_warning(
        "Skipping game_id {gid} with only {nrow(game_plays)} play{?s} (< {min_plays})."
      )
      return(NULL)
    }
    modeled <- .run_epa_wpa(
      game_plays,
      ep_model     = ep_model,
      fg_model     = fg_model,
      wp_model     = wp_model,
      clean_text   = clean_text,
      roster       = slice_for(rosters, gid),
      participants = slice_for(participants, gid)
    )
    p(sprintf("game_id=%s", gid))
    modeled
  }))

  out
}
