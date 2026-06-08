

test_that("espn_cfb_clear_cache runs and returns invisibly", {
  skip_on_cran()

  # Returns NULL invisibly.
  expect_invisible(espn_cfb_clear_cache())
  expect_null(espn_cfb_clear_cache())

  # Idempotent -- safe to call whether or not the catalog helpers are
  # memoised (cache mode "off" leaves them un-memoised; forget() is then
  # skipped). Does not error in either case.
  expect_null(espn_cfb_clear_cache())
})
