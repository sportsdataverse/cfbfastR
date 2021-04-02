context("CFB Stats Categories")

x <- cfbd_stats_categories()

cols <- c("category")

test_that("CFB Stats Categories", {
  expect_equal(nrow(x), 38)
  expect_equal(ncol(x), 1)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
