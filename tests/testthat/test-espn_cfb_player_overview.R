

test_that("ESPN CFB Player Statistics Overview", {
  skip_on_cran()

  cols <- c("athlete_id", "season", "stat_season")

  # athlete_detail = TRUE (default) -- friendly athlete name columns
  # appended from one cheap athlete fetch.
  athlete_cols <- c(
    "athlete_display_name", "athlete_first_name", "athlete_last_name",
    "athlete_jersey", "athlete_position", "athlete_position_abbreviation"
  )

  x <- espn_cfb_player_overview(athlete_id = 102597, year = 2024)

  y <- espn_cfb_player_overview(athlete_id = 102597, year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN player overview data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_in(athlete_cols, colnames(x))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_true(all(!is.na(x$stat_season)))

  # athlete_detail = FALSE -- the name columns and the fetch are skipped;
  # the base schema is unchanged.
  z <- espn_cfb_player_overview(athlete_id = 102597, year = 2024,
                                athlete_detail = FALSE)
  if (is.data.frame(z) && nrow(z) > 0) {
    expect_in(cols, colnames(z))
    expect_false(any(athlete_cols %in% colnames(z)))
  }
})
