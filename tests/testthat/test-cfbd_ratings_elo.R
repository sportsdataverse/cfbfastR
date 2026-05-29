cols <- c("year", "team", "conference", "elo")

test_that("CFB Elo ratings", {
  skip_on_cran()
  x <- cfbd_ratings_elo(year = 2019)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_ratings_elo(year = 2012, conference = "SEC")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  z <- cfbd_ratings_elo(year = 2016, conference = "ACC")
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
