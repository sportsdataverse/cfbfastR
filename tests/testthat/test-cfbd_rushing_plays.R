cols <- c(
  "game_id", "play_id", "drive_id", "season", "week", "season_type",
  "offense_id", "offense", "offense_conference",
  "defense_id", "defense", "defense_conference",
  "period", "down", "distance", "play_text",
  "start_yardline", "start_yards_to_goal",
  "rusher_id", "rusher", "rush_direction",
  "rushing_yards", "rusher_yards",
  "is_rushing_touchdown", "is_sack", "is_kneel", "is_team_rush",
  "attribution_status", "direction_analysis_eligible",
  "parse_status", "ppa", "success",
  "clock_minutes", "clock_seconds"
)

test_that("CFB Rushing Plays", {
  skip_on_cran()
  x <- cfbd_rushing_plays(year = 2025, week = 5)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
  expect_true(all(x$week == 5L))
})

test_that("CFB Rushing Plays rejects invalid enum arguments", {
  expect_error(cfbd_rushing_plays(year = 2025, rush_direction = "sideways"))
  expect_error(cfbd_rushing_plays(year = 2025, attribution_status = "guessed"))
})
