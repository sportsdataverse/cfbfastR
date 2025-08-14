
cols <- c(
  "team", "conference", "position_group", "avg_rating",
  "total_rating", "commits", "avg_stars"
)

test_that("CFB Recruiting Position Groups", {
  skip_on_cran()
  x <- cfbd_recruiting_position(2018, team = "Arkansas")

  y <- cfbd_recruiting_position(2016, 2020, team = "Virginia")

  z <- cfbd_recruiting_position(2015, 2020, conference = "SEC")

  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_setequal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
