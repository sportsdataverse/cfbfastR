context("CFB Play Stats Types")

x <- cfbd_play_stats_types()

cols <- c("play_stat_type_id", "name")

test_that("CFB Play Stats Types", {
  expect_equal(nrow(x), 22)
  expect_equal(ncol(x), 2)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
