#' Modular PBP -- adapt the CFBD raw plays frame into the modeling input contract
#'
#' Extracts the season/week assignment from the legacy `cfbd_pbp_data()`. The
#' heavier CFBD-side adapter work (join with `clean_drive_df`, `clean_names()`,
#' rename block, `rm_cols` select) stays inline in `cfbd_pbp_data_v2()`
#' because it depends on the betting + drives fetches done there. This adapter
#' exists for symmetry with `.espn_to_epa_input()` and as the single place
#' future CFBD-to-modeling-input drift should land.
#'
#' @param raw_play_df CFBD raw plays + clean_drive joined frame, with
#'   `janitor::clean_names()` already applied (i.e. the `play_df` value as it
#'   exists in `cfbd_pbp_data()` just before the `if (epa_wpa) { ... }` block).
#' @param year Numeric season year (assigned into the `season` column).
#' @param week Numeric week (assigned into the `wk` column).
#' @return `raw_play_df` with `season` and `wk` assigned.
#' @keywords internal
#' @noRd
#' @importFrom rlang .data
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
.cfbd_to_epa_input <- function(raw_play_df, year, week) {
  raw_play_df %>%
    dplyr::mutate(
      season = year,
      wk     = week
    )
}
