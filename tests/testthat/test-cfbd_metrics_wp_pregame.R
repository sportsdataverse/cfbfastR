context("CFB Metrics API Pre-Game Win Probability")

cols <- c(
  "season", "season_type", "week", "game_id",
  "home_team", "away_team", "spread", "home_win_prob", "away_win_prob"
)

test_that("CFB Metrics API Pre-Game Win Probability", {
  skip_on_cran()
  
  x <- cfbd_metrics_wp_pregame(year = 2019, week = 9, team = "Texas A&M")
  
  y <- cfbd_metrics_wp_pregame(year = 2017, week = 8, team = "TCU")
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
