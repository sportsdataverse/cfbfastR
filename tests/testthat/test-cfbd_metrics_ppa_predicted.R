
cols <- c("yard_line", "predicted_points")

test_that("CFB Metrics PPA Predicted", {

  skip_on_cran()
  x <- cfbd_metrics_ppa_predicted(down = 1, distance = 10)
  y <- cfbd_metrics_ppa_predicted(down = 3, distance = 10)
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
