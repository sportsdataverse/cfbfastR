identity_cols <- c("season", "player_id", "player", "team", "conference")

test_that("CFB Punting Players Season", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  x <- cfbd_punting_players_season(year = 2025, team = "Texas")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_s3_class(x, "data.frame")
  expect_in(identity_cols, colnames(x))
  # 5 identity + 15 punting_* + 10 returning_*
  expect_gte(length(grep("^punting_", colnames(x))), 15L)
  expect_gte(length(grep("^returning_", colnames(x))), 10L)
  expect_in(c("punting_net_yards_per_punt", "punting_inside20", "returning_returns20plus"),
            colnames(x))
  expect_gte(ncol(x), 30L)
})

test_that("CFB Punting Players Season requires a year", {
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  expect_error(cfbd_punting_players_season(team = "Texas"), regexp = "Missing required field: year")
})
