test_that("CFBD - Game Schedule", {
  skip_on_cran()
  x <- cfbd_game_schedule(year = 2025, season_type = "regular", week = 1)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) skip("CFBD rate-limited or returned no rows")
  cols <- c("game_id", "season", "week", "season_type", "start_date",
            "status", "neutral_site", "home_team_id", "away_team_id")
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
})
