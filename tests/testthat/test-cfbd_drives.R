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
  skip_on_cran()
  x <- cfbd_drives(2018, week = 1, team = "TCU")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_drives(2018, team = "Texas A&M", defense_conference = "SEC")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_in(colnames(x), cols)
  expect_in(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
