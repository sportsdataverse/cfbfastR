

cols <- c("play_stat_type_id", "name")

test_that("CFB Play Stats Types", {
  skip_on_cran()
  x <- cfbd_play_stats_types()
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  # CFBD grows this lookup (ids 27-31, the punt stat types, arrived in October
  # 2026), so assert the known ids survive rather than pinning the row count.
  expect_true(all(1:31 %in% x$play_stat_type_id))
  expect_equal(ncol(x), 2)
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
