cols <- c("yards_to_goal", "distance", "expected_points")

test_that("CFB Metrics FG EP", {
  skip_on_cran()
  x <- cfbd_metrics_fg_ep()
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})