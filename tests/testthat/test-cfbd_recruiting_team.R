
cols <- c("year", "rank", "team", "points")

test_that("CFB Recruiting Team", {
  skip_on_cran()
  x <- cfbd_recruiting_team(2018, team = "Texas")

  y <- cfbd_recruiting_team(2016, team = "Virginia")

  z <- cfbd_recruiting_team(2011)
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_equal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
