context("CFB Conferences")

x <- cfbd_conferences()

cols <- c("conference_id", "name", "long_name", "abbreviation")

test_that("CFB Conferences", {
  expect_equal(nrow(x), 34)
  expect_equal(ncol(x), 4)
  expect_equal(colnames(x), cols)
  expect_error(cfbd_conferences("SEC"))
  expect_s3_class(x, "data.frame")
})
