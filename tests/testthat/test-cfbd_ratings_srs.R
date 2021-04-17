context("CFB Conference Ratings - Bill C.'s SP+")

cols <- c("year", "team", "conference", "division", "rating", "ranking")

test_that("CFB Conference Ratings - Bill C.'s SP+", {
  skip_on_cran()
  x <- cfbd_ratings_srs(year = 2019)
  
  y <- cfbd_ratings_srs(year = 2012, conference = "SEC")
  
  z <- cfbd_ratings_srs(year = 2016, conference = "ACC")
  
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_equal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
