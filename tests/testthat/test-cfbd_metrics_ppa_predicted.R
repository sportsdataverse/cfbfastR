
cols <- c("yard_line", "predicted_points")

test_that("CFB Metrics PPA Predicted", {

  skip_on_cran()
  x <- cfbd_metrics_ppa_predicted(down = 1, distance = 10)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  y <- cfbd_metrics_ppa_predicted(down = 3, distance = 10)
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
