identity_cols <- c("game_id", "season", "week", "season_type",
                   "team", "conference", "opponent")

test_that("CFB Punting Teams Games", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  x <- cfbd_punting_teams_games(year = 2025, week = 5)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_s3_class(x, "data.frame")
  expect_in(identity_cols, colnames(x))
  expect_equal(length(grep("^punting_", colnames(x))), 24L)
  expect_equal(length(grep("^returning_", colnames(x))), 24L)
  expect_equal(ncol(x), 55L)

  # One side's punting_* is its opponent's returning_* for the same game.
  d <- as.data.frame(x)
  i <- match(paste(d$game_id, d$team), paste(d$game_id, d$opponent))
  if (all(is.na(i))) skip("No game with both sides in the response")
  ok <- !is.na(i)
  expect_equal(d$punting_punts[ok], d$returning_punts[i[ok]])
})

test_that("CFB Punting Teams Games requires a year", {
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  expect_error(cfbd_punting_teams_games(week = 5), regexp = "Missing required field: year")
})
