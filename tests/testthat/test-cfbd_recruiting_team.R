
cols <- c("year", "rank", "team", "points")

test_that("CFB Recruiting Team", {
  skip_on_cran()
  x <- cfbd_recruiting_team(2018, team = "Texas")

  y <- cfbd_recruiting_team(2016, team = "Virginia")

  z <- cfbd_recruiting_team(2011)
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_setequal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
