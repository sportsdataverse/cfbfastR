

cols <- c("conference_id", "name", "long_name", "abbreviation", "classification")

test_that("CFB Conferences", {
  skip_on_cran()
  x <- cfbd_conferences()
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  # Subset direction (expected subset of actual), per the repo convention:
  # CFBD adds columns over time and an exact set/count assertion turns that
  # into a red build for a change that broke nothing.
  expect_gte(ncol(x), 5)
  expect_in(cols, colnames(x))
  expect_error(cfbd_conferences("SEC"))
  expect_s3_class(x, "data.frame")
})
