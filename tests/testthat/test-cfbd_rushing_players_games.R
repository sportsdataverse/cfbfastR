
identity_cols <- c("game_id", "season", "week", "season_type",
                   "player_id", "player", "team", "conference", "opponent")

test_that("CFB Rushing Players Games", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  x <- cfbd_rushing_players_games(year = 2025, week = 5)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_s3_class(x, "data.frame")
  expect_true(all(identity_cols %in% colnames(x)))
  expect_equal(length(grep("^directions_", colnames(x))), 4L * 15L)
  expect_equal(ncol(x), 93L)
  expect_true(all(x$week == 5L))
})
