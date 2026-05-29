
cols <- c(
  "season", "week", "season_type",
  "first_game_start", "last_game_start"
)

test_that("CFB Calendar", {
  skip_on_cran()
  x <- cfbd_calendar(year = 2019)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_equal(nrow(x), 17)
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
