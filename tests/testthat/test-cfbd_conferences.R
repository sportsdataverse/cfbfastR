

cols <- c("conference_id", "name", "long_name", "abbreviation", "classification")

test_that("CFB Conferences", {
  skip_on_cran()
  x <- cfbd_conferences()
  expect_equal(ncol(x), 5)
  expect_equal(colnames(x), cols)
  expect_error(cfbd_conferences("SEC"))
  expect_s3_class(x, "data.frame")
})
