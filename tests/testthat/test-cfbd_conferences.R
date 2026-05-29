

cols <- c("conference_id", "name", "long_name", "abbreviation", "classification")

test_that("CFB Conferences", {
  skip_on_cran()
  x <- cfbd_conferences()
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_equal(ncol(x), 5)
  expect_setequal(colnames(x), cols)
  expect_error(cfbd_conferences("SEC"))
  expect_s3_class(x, "data.frame")
})
