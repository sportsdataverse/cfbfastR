

cols <- c("play_type_id", "text", "abbreviation")

test_that("CFB Play Types", {
  skip_on_cran()
  x <- cfbd_play_types()
  expect_equal(nrow(x), 48)
  expect_equal(ncol(x), 3)
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
