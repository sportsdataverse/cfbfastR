
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

  # Subset direction: the hard-coded `cols` list is the contract we
  # expect to appear in the response. The 2.3.0 wrappers prepend
  # `season` (and similar query-context columns) so strict set
  # equality breaks the moment the helper adds a column.
  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
