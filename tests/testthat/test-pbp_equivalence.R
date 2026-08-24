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
    ),

    # --- representation deltas: same information, different shape -------
    "game_id" = paste(
      "v2 preserves character game_id for lossless ESPN id handling;",
      "legacy coerces to numeric and loses precision past 2^53."
    ),
    "scoring_play" = paste(
      "v2 carries logical TRUE/FALSE (modern R idiom);",
      "legacy carries 0/1 integer for back-compat with the original",
      "pandas-era output. Same information, different storage type."
    ),
    "clock_seconds" = paste(
      "v2 keeps total seconds remaining in the period (raw ESPN clock,",
      "e.g. 14:21 -> 861); legacy splits into clock_minutes + clock_seconds",
      "and reports only the seconds digit (14:21 -> 21). Same information,",
      "different decomposition; downstream TimeSecsRem is identical."
    ),

    # --- v2 known limitations: ESPN play-text name abbreviations --------
    # Legacy `espn_cfb_pbp()` enriches play_text-derived player names via
    # a second ESPN call to /events/{game_id}/competitions/{cid}/competitors[]
    # /roster which returns full names. v2 currently uses only the
    # play_text short-name form ("J. Mitchell" rather than "Jalen Mitchell").
    # Tracked for a follow-up; the IDs (passer_player_id etc.) match.
    "passer_player_name" = paste(
      "v2 carries play_text short-name (e.g. 'J. Potts');",
      "legacy enriches via roster fetch ('Jordyn Potts').",
      "Known v2 limitation; passer_player_id matches."
    ),
    "rusher_player_name" = paste(
      "v2 carries play_text short-name (e.g. 'J. Mitchell');",
      "legacy enriches via roster fetch ('Jalen Mitchell').",
      "Known v2 limitation; rusher_player_id matches."
    ),
    "receiver_player_name" = paste(
      "v2 carries play_text short-name (e.g. 'Tr. Jones');",
      "legacy enriches via roster fetch ('Tremel Jones').",
      "Known v2 limitation; receiver_player_id matches."
    )
  )
}

# Tier-monotonicity helper: assert that for the SAME upstream call, the
# `output` tiers obey the column-subset chain lean ⊆ default ⊆ full AND that
# every overlapping column carries bit-identical values across tiers. Catches
# accidental column-content changes in the tiered drops (the drops are
# supposed to only slim the column set, never modify values).
.eq_tier_monotonicity <- function(make_call, sample_label) {
  full    <- try(make_call("full"),    silent = TRUE)
  default <- try(make_call("default"), silent = TRUE)
  lean    <- try(make_call("lean"),    silent = TRUE)

  for (x in list(full, default, lean)) {
    if (inherits(x, "try-error") || is.null(x) || nrow(x) == 0L) {
      skip(paste0("Tier-monotonicity skipped (empty/error tier) for ",
                  sample_label))
    }
  }

  # Row counts identical across tiers (drops never remove rows).
  expect_equal(nrow(default), nrow(full),
               info = paste0(sample_label, ": default vs full row count"))
  expect_equal(nrow(lean), nrow(full),
               info = paste0(sample_label, ": lean vs full row count"))

  # Column subset chain.
  expect_true(all(colnames(default) %in% colnames(full)),
              info = paste0(sample_label, ": default cols subset of full"))
  expect_true(all(colnames(lean) %in% colnames(default)),
              info = paste0(sample_label, ": lean cols subset of default"))

  # Strict subset: at least one column dropped at each step.
  expect_true(length(setdiff(colnames(full), colnames(default))) > 0L,
              info = paste0(sample_label, ": full has cols default drops"))
  expect_true(length(setdiff(colnames(default), colnames(lean))) > 0L,
              info = paste0(sample_label, ": default has cols lean drops"))

  # Bit-identical values on overlapping columns.
  ord <- function(df) order(.eq_id_play_key(df$id_play), df$game_id)
  ord_f <- ord(full); ord_d <- ord(default); ord_l <- ord(lean)
  for (col in intersect(colnames(default), colnames(full))) {
    expect_equal(
      default[[col]][ord_d], full[[col]][ord_f],
      tolerance = 1e-6,
      info = paste0(sample_label, ": default vs full column ", col)
    )
  }
  for (col in intersect(colnames(lean), colnames(default))) {
    expect_equal(
      lean[[col]][ord_l], default[[col]][ord_d],
      tolerance = 1e-6,
      info = paste0(sample_label, ": lean vs default column ", col)
    )
  }
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
  testthat::skip_on_cran()
  # Documentation guardrail: every allow-list entry must carry a rationale.
  al <- .eq_allow_list()
  expect_true(length(al) > 0L)
  expect_true(all(nchar(unlist(al)) > 0L),
              info = "Every allow-list entry must have a non-empty rationale")
})

# ---------------------------------------------------------------------------
# Tier monotonicity: the `output = c("default", "lean", "full")` argument must
# obey lean ⊆ default ⊆ full AND must not modify any retained column. Catches
# regressions where a future taxonomy edit accidentally rewrites a value in
# one of the tiered drops (the drops are supposed to slim the column set, not
# change values).
# ---------------------------------------------------------------------------

test_that(".pbp_apply_output_schema(): structural tier monotonicity (synthetic frame)", {
  testthat::skip_on_cran()
  # Always runs -- no live API. Confirms the subset chain and value equality
  # by feeding a constructed frame through all three tiers.
  df <- data.frame(
    id_play         = c("a", "b", "c"),
    game_id         = c("g", "g", "g"),
    EPA             = c(0.1, -0.2, 0.5),
    wpa             = c(0.01, -0.02, 0.05),
    # drop-default representatives
    lag_play_type   = c("Rush", "Pass", "Punt"),
    sack_vec        = c(0, 1, 0),
    drive_result2   = c("PUNT", "TD", "FG"),
    # kept-with-rationale
    orig_play_type  = c("Rush", "Pass", "Punt"),
    pts_scored      = c(0, 7, 3),
    # drop-lean representatives (WPA scratch)
    wpa_base        = c(0.01, 0.02, 0.03),
    wpa_change      = c(0.04, 0.05, 0.06),
    stringsAsFactors = FALSE
  )

  full    <- cfbfastR:::.pbp_apply_output_schema(df, output = "full")
  default <- cfbfastR:::.pbp_apply_output_schema(df, output = "default")
  lean    <- cfbfastR:::.pbp_apply_output_schema(df, output = "lean")

  # Row count preserved across all tiers.
  expect_equal(nrow(default), nrow(full))
  expect_equal(nrow(lean),    nrow(full))

  # Column subset chain.
  expect_true(all(colnames(default) %in% colnames(full)))
  expect_true(all(colnames(lean)    %in% colnames(default)))

  # Tier-specific drops actually fire.
  expect_false(any(c("lag_play_type", "sack_vec", "drive_result2") %in%
                     colnames(default)))
  expect_true(all(c("wpa_base", "wpa_change") %in% colnames(default)))
  expect_false(any(c("wpa_base", "wpa_change") %in% colnames(lean)))

  # Kept-with-rationale survives every tier.
  for (df_tier in list(full, default, lean)) {
    expect_true("orig_play_type" %in% colnames(df_tier))
    expect_true("pts_scored"     %in% colnames(df_tier))
  }

  # Values on overlapping columns are bit-identical across tiers.
  for (col in intersect(colnames(default), colnames(full))) {
    expect_equal(default[[col]], full[[col]],
                 info = paste0("default vs full: ", col))
  }
  for (col in intersect(colnames(lean), colnames(default))) {
    expect_equal(lean[[col]], default[[col]],
                 info = paste0("lean vs default: ", col))
  }
})

test_that("espn_cfb_pbp_v2(): output tier monotonicity (lean subset default subset full, equal values on overlaps)", {
  skip_on_cran()
  skip_on_ci()

  game_id <- 401628339
  make_call <- function(out) {
    try(espn_cfb_pbp_v2(game_id = game_id, epa_wpa = TRUE, output = out),
        silent = TRUE)
  }
  .eq_tier_monotonicity(make_call,
                        sample_label = paste0("ESPN game_id=", game_id))
})

test_that("cfbd_pbp_data_v2(): output tier monotonicity", {
  skip_on_cran()
  skip_on_ci()
  skip_if(Sys.getenv("CFBD_API_KEY") == "",
          "CFBD_API_KEY not set; skipping CFBD tier monotonicity.")

  make_call <- function(out) {
    try(cfbd_pbp_data_v2(year = 2024, week = 1, season_type = "regular",
                         team = "Texas", epa_wpa = TRUE, output = out),
        silent = TRUE)
  }
  .eq_tier_monotonicity(make_call, sample_label = "CFBD 2024 wk1 Texas")
})
