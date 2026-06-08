

test_that("ESPN CFB QBR", {
  skip_on_cran()

  cols <- c(
    "season", "season_type", "group_id", "athlete_id", "team_id",
    "qbpaa", "cwepa_total", "action_plays", "qbr",
    "avg_opp_dqbr", "sched_adj_qbr", "unqualified_rank",
    "athlete_ref", "team_ref"
  )

  # athlete_detail = TRUE -- name columns appended (one HTTP call per
  # quarterback); off by default.
  athlete_cols <- c(
    "athlete_display_name", "athlete_first_name", "athlete_last_name",
    "athlete_jersey", "athlete_position", "athlete_position_abbreviation"
  )

  x <- espn_cfb_qbr(year = 2024)

  y <- espn_cfb_qbr(year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN QBR data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_true(is.numeric(x$qbr))

  # athlete_detail = FALSE (default) -- name columns not present; base
  # schema unchanged.
  expect_false(any(athlete_cols %in% colnames(x)))

  # athlete_detail = TRUE -- name columns appended (one fetch per QB).
  z <- espn_cfb_qbr(year = 2024, athlete_detail = TRUE)
  if (is.data.frame(z) && nrow(z) > 0) {
    expect_in(cols, colnames(z))
    expect_in(athlete_cols, colnames(z))
  }
})
