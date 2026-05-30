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
#' @return The modeled single-game frame.
#' @keywords internal
#' @noRd
.run_epa_wpa <- function(df,
                         ep_model,
                         fg_model,
                         wp_model,
                         clean_text = FALSE) {
  if (isTRUE(clean_text)) {
    df <- clean_play_text(df)
  }
  df |>
    penalty_detection() |>
    .pbp_add_play_counts() |>
    .pbp_clean_pbp_dat() |>
    .pbp_clean_drive_dat() |>
    add_yardage() |>
    add_player_cols() |>
    .pbp_prep_epa_df_after() |>
    .pbp_create_epa(ep_model = ep_model, fg_model = fg_model) |>
    .pbp_create_wpa_naive(wp_model = wp_model)
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
                                 min_plays = 20L) {
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
      ep_model   = ep_model,
      fg_model   = fg_model,
      wp_model   = wp_model,
      clean_text = clean_text
    )
    p(sprintf("game_id=%s", gid))
    modeled
  }))

  out
}
