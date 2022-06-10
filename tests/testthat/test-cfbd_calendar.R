
cols <- c(
  "season", "week", "season_type",
  "first_game_start", "last_game_start"
)

test_that("CFB Calendar", {
  skip_on_cran()
  x <- cfbd_calendar(year = 2019)
  expect_equal(nrow(x), 16)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
