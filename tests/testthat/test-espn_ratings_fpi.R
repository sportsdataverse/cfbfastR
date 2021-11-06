context("ESPN FPI Ratings")

cols <- c(
  "year", "team_id", "name", "abbr",
  "fpi", "fpi_rk", "trend", "proj_w", "proj_l", "win_out",
  "win_6", "win_div", "playoff", "nc_game", "nc_win",
  "win_conf", "w", "l", "t"
)

test_that("ESPN FPI Ratings", {
  skip_on_cran()
  x <- espn_ratings_fpi(2019)

  y <- espn_ratings_fpi(2018)

  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
