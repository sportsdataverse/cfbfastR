cols <- c("year", "team", "conference", "elo")

test_that("CFB Elo ratings", {
  skip_on_cran()
  x <- cfbd_ratings_elo(year = 2019)

  y <- cfbd_ratings_elo(year = 2012, conference = "SEC")

  z <- cfbd_ratings_elo(year = 2016, conference = "ACC")

  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_equal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
