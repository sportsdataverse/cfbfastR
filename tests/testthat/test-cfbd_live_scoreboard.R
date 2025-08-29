

cols <- c(
  "game_id",
  "start_date",
  "start_time_tbd",
  "tv",
  "neutral_site",
  "conference_game",
  "status",
  "period",
  "clock",
  "situation",
  "possession",
  "last_play",
  "venue_name",
  "venue_city",
  "venue_state",
  "home_team_id",
  "home_team_name",
  "home_team_conference",
  "home_team_classification",
  "home_team_points",
  "home_team_line_scores_Q1",
  "home_team_line_scores_Q2",
  "home_team_line_scores_Q3",
  "home_team_line_scores_Q4",
  "home_team_win_probability",
  "away_team_id",
  "away_team_name",
  "away_team_conference",
  "away_team_classification",
  "away_team_points",
  "away_team_line_scores_Q1",
  "away_team_line_scores_Q2",
  "away_team_line_scores_Q3",
  "away_team_line_scores_Q4",
  "away_team_win_probability",
  "weather_temperature",
  "weather_description",
  "weather_wind_speed",
  "weather_wind_direction",
  "betting_spread",
  "betting_over_under",
  "betting_home_moneyline",
  "betting_away_moneyline"
)

test_that("CFB Live Scoreboard", {
  skip_on_cran()
  x <- cfbd_live_scoreboard(division='fbs', conference = "B12")

  y <- cfbd_live_scoreboard(division='fbs')
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
