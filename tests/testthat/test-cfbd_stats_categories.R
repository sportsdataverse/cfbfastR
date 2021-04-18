context("CFB Stats Categories")


cols <- c("category")

test_that("CFB Stats Categories", {
  skip_on_cran()
  x <- cfbd_stats_categories()
  expect_equal(nrow(x), 38)
  expect_equal(ncol(x), 1)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
