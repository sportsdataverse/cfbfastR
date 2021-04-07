context("CFB Play Types")

x <- cfbd_play_types()

cols <- c("play_type_id", "text", "abbreviation")

test_that("CFB Play Types", {
  expect_equal(nrow(x), 48)
  expect_equal(ncol(x), 3)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
