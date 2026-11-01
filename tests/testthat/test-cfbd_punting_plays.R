cols <- c(
  "game_id", "play_id", "drive_id", "season", "week", "season_type",
  "punting_team_id", "punting_team", "punting_conference",
  "receiving_team_id", "receiving_team", "receiving_conference",
  "period", "down", "distance", "play_type", "play_text",
  "punter_id", "punter", "receiver_id", "receiver",
  "returner_id", "returner", "blocker_id", "blocker",
  "counts_as_punt", "counts_as_return", "start_yards_to_goal",
  "punt_yards", "return_yards", "returner_yards", "net_punt_yards",
  "kick_end_yardline", "end_yardline",
  "is_touchback", "is_fair_catch", "is_out_of_bounds", "is_downed",
  "is_blocked", "is_muffed", "is_return_touchdown",
  "is_receiving_team_turnover", "has_penalty", "parse_status",
  "clock_minutes", "clock_seconds"
)

test_that("CFB Punting Plays", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  x <- cfbd_punting_plays(year = 2025, week = 5)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  expect_true(all(x$week == 5L))
})

test_that("CFB Punting Plays requires a year or a game id", {
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  expect_error(cfbd_punting_plays(week = 5), regexp = "Missing required field: year")
})
