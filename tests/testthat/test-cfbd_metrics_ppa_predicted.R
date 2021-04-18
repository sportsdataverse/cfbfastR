context("CFB Metrics PPA Predicted")

cols <- c("yard_line", "predicted_points")

test_that("CFB Metrics PPA Predicted", {
  
  skip_on_cran()
  x <- cfbd_metrics_ppa_predicted(down = 1, distance = 10)
  y <- cfbd_metrics_ppa_predicted(down = 3, distance = 10)
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
