context("CFB Drives")

x <- cfbd_drives(2018, week = 1, team = "TCU")

y <- cfbd_drives(2018, team = "Texas A&M", defense_conference = "SEC")

cols <- c(
  "offense", "offense_conference", "defense", "defense_conference",
  "game_id", "drive_id", "drive_number", "scoring", "start_period", "start_yardline",
  "start_yards_to_goal", "end_period", "end_yardline", "end_yards_to_goal", "plays",
  "yards", "drive_result", "is_home_offense", "start_offense_score",
  "start_defense_score", "end_offense_score", "end_defense_score",
  "time_minutes_start", "time_seconds_start",
  "time_minutes_end", "time_seconds_end", "time_minutes_elapsed",
  "time_seconds_elapsed"
)

test_that("CFB Drives", {
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
