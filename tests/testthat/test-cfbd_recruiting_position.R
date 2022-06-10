
cols <- c(
  "team", "conference", "position_group", "avg_rating",
  "total_rating", "commits", "avg_stars"
)

test_that("CFB Recruiting Position Groups", {
  skip_on_cran()
  x <- cfbd_recruiting_position(2018, team = "Texas")

  y <- cfbd_recruiting_position(2016, 2020, team = "Virginia")

  z <- cfbd_recruiting_position(2015, 2020, conference = "SEC")

  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_equal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
