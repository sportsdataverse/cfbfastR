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
  drop_set <- c("punt_return_player", "kickoff_return_player",
                "rush_player_name", "punt_return_player_name",
                "kickoff_return_player_name")
  expect_false(any(drop_set %in% colnames(out)))
})
