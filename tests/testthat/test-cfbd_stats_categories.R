

cols <- c("category")

test_that("CFB Stats Categories", {
  skip_on_cran()
  x <- cfbd_stats_categories()
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_equal(nrow(x), 38)
  expect_equal(ncol(x), 1)
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
