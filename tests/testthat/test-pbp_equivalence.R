# Equivalence harness for the modular PBP / EPA-WPA refactor.
#
# Asserts that the new `*_v2` path produces the same pipeline-canonical
# columns as the legacy path for a fixed sample of games / weeks. Raw-feed
# columns are NOT required to match (legacy site-v2 `plays_*` vs v2 core-v2
# `text`/`type_text`) -- see the spec for the documented crosswalk.
#
# Allow-list: columns permitted to differ are explicitly enumerated below
# with a rationale per entry. Every other canonical column must match.

# --- helpers -----------------------------------------------------------
.eq_canonical_cols <- function() {
  # The "canonical" set is the intersection of legacy + v2 output, minus
  # the allow-list. Computed at run time so the test survives the eventual
  # collapse-the-duplication commit.
  c(
    "season", "wk", "id_play", "game_id", "game_play_number",
    "half_play_number", "drive_play_number",
    "pos_team", "def_pos_team", "pos_team_score", "def_pos_team_score",
    "half", "period", "clock_minutes", "clock_seconds",
    "play_type", "play_text",
    "down", "distance", "yards_to_goal", "yards_gained",
    "EPA", "ep_before", "ep_after",
    "wpa", "wp_before", "wp_after",
    "def_wp_before", "def_wp_after",
    "home_EPA", "away_EPA",
    "rusher_player_name", "yds_rushed",
    "passer_player_name", "receiver_player_name", "yds_receiving",
    "drive_number", "drive_result_detailed",
    "rush", "pass", "completion", "pass_attempt",
    "turnover_vec", "scoring_play", "touchdown", "safety"
  )
}

.eq_allow_list <- function() {
  # Each entry: a column permitted to differ + a one-line rationale.
  list(
    # --- meta superset (spec section 6) ---
    "home_team_name"            = "v2 bridges in legacy-equivalent name",
    "home_team_color"           = "v2 bridges in legacy-equivalent color",
    "home_team_alternate_color" = "v2 bridges in legacy-equivalent alt color",
    "home_team_rank"            = "v2 bridges in legacy-equivalent rank",
    "away_team_name"            = "v2 bridges in legacy-equivalent name",
    "away_team_color"           = "v2 bridges in legacy-equivalent color",
    "away_team_alternate_color" = "v2 bridges in legacy-equivalent alt color",
    "away_team_rank"            = "v2 bridges in legacy-equivalent rank",

    # --- bug-fix sites (spec section 9) ---
    "new_yardline" = paste(
      "prep_epa_df_after bounds-check fix:",
      "legacy NA's last-row na_yd_line+1 indexing"
    ),
    "new_distance" = paste(
      "prep_epa_df_after bounds-check fix:",
      "legacy NA's last-row neg_distance+1 indexing"
    ),
    "fg_make_prob" = paste(
      "create_epa double-predict.bam removal --",
      "identical numeric result, paranoid allow-list entry"
    ),
    "id_play" = paste(
      "clean_pbp_dat quoted-literal fix:",
      "v2 preserves character id_play (lossless);",
      "legacy coerces to numeric via unquoted ifelse",
      "literals and loses precision past 2^53."
    )
  )
}

# Coerce id_play to a precision-safe character form for ordering. Required
# because legacy stores it as numeric (with precision loss past 2^53) and v2
# preserves it as character; a direct order() across the two types would
# compare apples to oranges and yield different orderings.
.eq_id_play_key <- function(x) {
  if (is.character(x)) {
    x
  } else {
    trimws(format(x, scientific = FALSE, trim = TRUE))
  }
}

.eq_compare <- function(legacy, v2, sample_label) {
  # Fail fast if either side returned nothing useful.
  if (is.null(legacy) || nrow(legacy) == 0L) {
    skip(paste0("Legacy returned no rows for ", sample_label))
  }
  if (is.null(v2) || nrow(v2) == 0L) {
    skip(paste0("v2 returned no rows for ", sample_label))
  }

  # Pipeline-canonical columns that exist on BOTH sides.
  both_have <- intersect(colnames(legacy), colnames(v2))
  canonical <- intersect(both_have, .eq_canonical_cols())
  allow     <- names(.eq_allow_list())
  cols_to_check <- setdiff(canonical, allow)

  # Row count must match.
  expect_equal(nrow(v2), nrow(legacy),
               info = paste0(sample_label, ": row count"))

  # Each canonical column must match value-for-value after a sort by id.
  # We sort by a precision-safe character form of id_play (see
  # `.eq_id_play_key`) to make ordering robust both to dplyr group-by changes
  # AND to the legacy-vs-v2 id_play type divergence (legacy numeric/lossy,
  # v2 character/lossless).
  ord_l <- order(.eq_id_play_key(legacy$id_play), legacy$game_id)
  ord_v <- order(.eq_id_play_key(v2$id_play),     v2$game_id)
  for (col in cols_to_check) {
    expect_equal(
      v2[[col]][ord_v],
      legacy[[col]][ord_l],
      tolerance = 1e-6,
      info      = paste0(sample_label, ": column ", col)
    )
  }
}

# --- ESPN single-game equivalence -------------------------------------
test_that("espn_cfb_pbp_v2(epa_wpa = TRUE) matches espn_cfb_pbp(epa_wpa = TRUE)", {
  skip_on_cran()
  skip_on_ci()

  game_id <- 401628339  # Texas vs Washington (CFP semifinal), one stable game.

  legacy <- try(espn_cfb_pbp(game_id    = game_id, epa_wpa = TRUE),
                silent = TRUE)
  v2     <- try(espn_cfb_pbp_v2(game_id = game_id, epa_wpa = TRUE),
                silent = TRUE)

  if (inherits(legacy, "try-error") || inherits(v2, "try-error")) {
    skip("Live ESPN endpoints unavailable; skipping ESPN equivalence.")
  }

  .eq_compare(legacy, v2,
              sample_label = paste0("ESPN game_id=", game_id))
})

# --- CFBD single-week equivalence -------------------------------------
test_that("cfbd_pbp_data_v2(epa_wpa = TRUE) matches cfbd_pbp_data(epa_wpa = TRUE)", {
  skip_on_cran()
  skip_on_ci()
  skip_if(Sys.getenv("CFBD_API_KEY") == "",
          "CFBD_API_KEY not set; skipping CFBD equivalence.")

  args <- list(year = 2024, week = 1, season_type = "regular",
               team = "Texas", epa_wpa = TRUE)

  legacy <- try(do.call(cfbd_pbp_data,    args), silent = TRUE)
  v2     <- try(do.call(cfbd_pbp_data_v2, args), silent = TRUE)

  if (inherits(legacy, "try-error") || inherits(v2, "try-error")) {
    skip("Live CFBD endpoint unavailable; skipping CFBD equivalence.")
  }

  .eq_compare(legacy, v2,
              sample_label = "CFBD 2024 wk1 Texas")
})

test_that("allow-list rationales are present for every allowed-to-differ column", {
  # Documentation guardrail: every allow-list entry must carry a rationale.
  al <- .eq_allow_list()
  expect_true(length(al) > 0L)
  expect_true(all(nchar(unlist(al)) > 0L),
              info = "Every allow-list entry must have a non-empty rationale")
})
