identity_cols <- c("game_id", "season", "week", "season_type",
                   "player_id", "player", "team", "conference", "opponent")

test_that("CFB Punting Players Games", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  x <- cfbd_punting_players_games(year = 2025, week = 5)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_s3_class(x, "data.frame")
  expect_in(identity_cols, colnames(x))
  expect_gte(length(grep("^punting_", colnames(x))), 15L)
  expect_gte(length(grep("^returning_", colnames(x))), 10L)
  expect_gte(ncol(x), 34L)
  expect_true(all(x$week == 5L))
})

test_that("CFB Punting Players Games requires a year", {
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  expect_error(cfbd_punting_players_games(week = 5), regexp = "Missing required field: year")
})
