
test_that("ESPN FPI Ratings", {
  skip_on_cran()

  cols <- c(
    "year",
    "team_id",
    "team_name",
    "team_abbreviation",
    "fpi",
    "fpi_rk",
    "trend",
    "projected_wins",
    "projected_losses",
    "win_out_pct",
    "win_6_pct",
    "win_division_pct",
    "playoff_pct",
    "nc_game_pct",
    "nc_win_pct",
    "win_conference_pct",
    "w",
    "l",
    "t"
  )

  x <- espn_ratings_fpi(2019)

  y <- espn_ratings_fpi(2018)

  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
