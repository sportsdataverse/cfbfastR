test_that(".pbp_output_order is a non-empty unique character vector", {
  cols <- cfbfastR:::.pbp_output_order

  expect_type(cols, "character")
  expect_gt(length(cols), 200L)
  expect_equal(length(unique(cols)), length(cols))

  # Spot-check a few canonical names from each section
  expect_true(all(c("season", "wk", "id_play", "game_id") %in% cols))
  expect_true(all(c("EPA", "ep_before", "ep_after", "wpa", "wp_before") %in% cols))
  expect_true(all(c("rusher_player_name", "passer_player_name") %in% cols))
})

test_that(".pbp_apply_output_schema() reorders known cols and trails unknowns", {
  df <- data.frame(
    extra_col_a  = 1,
    EPA          = 0.1,
    extra_col_b  = "z",
    season       = 2024,
    id_play      = "abc",
    stringsAsFactors = FALSE
  )

  out <- cfbfastR:::.pbp_apply_output_schema(df)

  # Known cols come first in canonical order
  known <- intersect(cfbfastR:::.pbp_output_order, colnames(df))
  expect_equal(colnames(out)[seq_along(known)], known)

  # Unknown cols are trailed, never dropped
  expect_true(all(c("extra_col_a", "extra_col_b") %in% colnames(out)))
})

test_that(".pbp_apply_output_schema() drops the documented player-name aliases", {
  df <- data.frame(
    id_play                       = "x",
    punt_return_player            = NA,
    kickoff_return_player         = NA,
    rush_player_name              = NA,
    punt_return_player_name       = NA,
    kickoff_return_player_name    = NA,
    stringsAsFactors              = FALSE
  )
  out <- cfbfastR:::.pbp_apply_output_schema(df)
  # Genuine aliases: the raw regex intermediates and the rusher_player_name
  # duplicate.
  drop_set <- c("punt_return_player", "kickoff_return_player",
                "rush_player_name")
  expect_false(any(drop_set %in% colnames(out)))

  # The returner NAME columns are retained: the released pbp ships
  # punt_return_player_id / kickoff_return_player_id, so dropping the name twin
  # made a returner the only credited role identifiable by id alone.
  expect_true(all(c("punt_return_player_name",
                    "kickoff_return_player_name") %in% colnames(out)))
})

test_that(".pbp_apply_output_schema(output = 'default') drops the tier-1 sets", {
  df <- data.frame(
    id_play              = "x",
    # lag/lead representative
    lag_play_type        = NA,
    lead_play_type       = NA,
    lag_ep_before        = NA_real_,
    # redundant alternates
    sack_vec             = 0,
    turnover_indicator   = 0,
    kick_play            = 0,
    missing_yard_flag    = FALSE,
    # drive aliases
    drive_result2        = NA,
    drive_result_detailed_flag = NA,
    # kept-with-rationale
    orig_play_type       = "Pass",
    pts_scored           = 0,
    # wpa scratch (KEPT in default)
    wpa_base             = 0.01,
    wpa_change           = 0.02,
    stringsAsFactors     = FALSE
  )
  out <- cfbfastR:::.pbp_apply_output_schema(df, output = "default")

  # Default drops
  default_drops <- c("lag_play_type", "lead_play_type", "lag_ep_before",
                     "sack_vec", "turnover_indicator", "kick_play",
                     "missing_yard_flag",
                     "drive_result2", "drive_result_detailed_flag")
  expect_false(any(default_drops %in% colnames(out)))

  # Kept-with-rationale -- must survive default
  expect_true("orig_play_type" %in% colnames(out))
  expect_true("pts_scored"     %in% colnames(out))

  # WPA scratchpad -- kept in default
  expect_true("wpa_base"   %in% colnames(out))
  expect_true("wpa_change" %in% colnames(out))
})

test_that(".pbp_apply_output_schema(output = 'lean') also drops the WPA scratchpad", {
  df <- data.frame(
    id_play     = "x",
    wpa_base    = 0.01,
    wpa_change  = 0.02,
    wpa_half_end = 0.0,
    lead_wp_before = 0.5,
    lead_pos_team2 = NA_character_,
    # canonical wpa column -- must survive
    wpa         = 0.03,
    stringsAsFactors = FALSE
  )
  out <- cfbfastR:::.pbp_apply_output_schema(df, output = "lean")

  lean_drops <- c("wpa_base", "wpa_change", "wpa_half_end",
                  "lead_wp_before", "lead_pos_team2")
  expect_false(any(lean_drops %in% colnames(out)))
  # Canonical wpa stays
  expect_true("wpa" %in% colnames(out))
})

test_that(".pbp_apply_output_schema(output = 'full') drops only player aliases", {
  df <- data.frame(
    id_play              = "x",
    lag_play_type        = NA,
    sack_vec             = 0,
    drive_result2        = NA,
    wpa_base             = 0.01,
    punt_return_player   = NA,
    stringsAsFactors     = FALSE
  )
  out <- cfbfastR:::.pbp_apply_output_schema(df, output = "full")

  # Player alias still dropped (always)
  expect_false("punt_return_player" %in% colnames(out))
  # All tiered drops survive in full
  expect_true(all(c("lag_play_type", "sack_vec", "drive_result2", "wpa_base")
                  %in% colnames(out)))
})

test_that(".pbp_apply_output_schema() defaults to 'default' and rejects unknown values", {
  df <- data.frame(id_play = "x", sack_vec = 0, stringsAsFactors = FALSE)

  # Default of `output` is "default"
  out_default <- cfbfastR:::.pbp_apply_output_schema(df)
  expect_false("sack_vec" %in% colnames(out_default))

  # match.arg rejects unknowns
  expect_error(cfbfastR:::.pbp_apply_output_schema(df, output = "bogus"))
})

test_that("kept-with-rationale columns are absent from the drop vectors", {
  # Documentation guardrail: orig_play_type and pts_scored are intentionally
  # NOT dropped in default/lean. Make sure they never sneak into the vectors.
  expect_false("orig_play_type" %in% cfbfastR:::.pbp_drop_redundant)
  expect_false("pts_scored"     %in% cfbfastR:::.pbp_drop_drive_aliases)
})
