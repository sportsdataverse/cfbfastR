
identity_cols <- c("game_id", "season", "week", "season_type",
                   "player_id", "player", "team", "conference", "opponent")

test_that("CFB Passing Players Games", {
  skip_on_cran()
  x <- cfbd_passing_players_games(year = 2025, week = 5)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_s3_class(x, "data.frame")
  expect_true(all(identity_cols %in% colnames(x)))
  expect_equal(length(grep("^locations_", colnames(x))), 7L * 23L)
  expect_equal(ncol(x), 193L)
  expect_true(all(x$week == 5L))
})
