context("CFB Team Talent")

x <- cfbd_team_talent(year = 2019)

cols <- c("year", "school", "talent")

test_that("CFB Team Talent", {
  expect_equal(nrow(x), 231)
  expect_equal(ncol(x), 3)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
