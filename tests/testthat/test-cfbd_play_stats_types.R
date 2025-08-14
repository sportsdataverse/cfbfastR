

cols <- c("play_stat_type_id", "name")

test_that("CFB Play Stats Types", {
  skip_on_cran()
  x <- cfbd_play_stats_types()
  expect_equal(nrow(x), 25)
  expect_equal(ncol(x), 2)
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
