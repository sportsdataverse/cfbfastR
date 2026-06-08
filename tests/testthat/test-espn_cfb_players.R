

test_that("ESPN CFB Players Index", {
  skip_on_cran()

  cols <- c(
    "season", "athlete_id", "athlete_ref", "page", "page_count", "count"
  )

  # athlete_detail = TRUE -- name columns appended (one HTTP call per
  # player); off by default.
  athlete_cols <- c(
    "athlete_display_name", "athlete_first_name", "athlete_last_name",
    "athlete_jersey", "athlete_position", "athlete_position_abbreviation"
  )

  x <- espn_cfb_players(year = 2024, page = 1, max_pages = 1, limit = 25)

  y <- espn_cfb_players(year = 2023, page = 1, max_pages = 1, limit = 25)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN players index data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_true(all(!is.na(x$athlete_id)))

  # athlete_detail = FALSE (default) -- name columns not present; base
  # schema unchanged.
  expect_false(any(athlete_cols %in% colnames(x)))

  # athlete_detail = TRUE -- name columns appended. A small limit keeps the
  # per-athlete HTTP cost low for the test.
  z <- espn_cfb_players(year = 2024, page = 1, max_pages = 1, limit = 5,
                        athlete_detail = TRUE)
  if (is.data.frame(z) && nrow(z) > 0) {
    expect_in(cols, colnames(z))
    expect_in(athlete_cols, colnames(z))
  }
})
