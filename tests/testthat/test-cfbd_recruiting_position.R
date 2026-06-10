
cols <- c(
  "team", "conference", "position_group", "avg_rating",
  "total_rating", "commits", "avg_stars"
)

test_that("CFB Recruiting Position Groups", {
  skip_on_cran()
  x <- cfbd_recruiting_position(2024, team = "Texas")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_recruiting_position(2016, 2020, team = "Virginia")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  z <- cfbd_recruiting_position(2015, 2020, conference = "SEC")
  if (is.null(z) || !is.data.frame(z) || nrow(z) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_setequal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
