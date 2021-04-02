context("CFB Metrics API Win Probability")

x <- cfbd_metrics_wp(game_id = 401012356)

y <- cfbd_metrics_wp(game_id = 401110720)

cols <- c("play_id", "play_text", "home_id", "home", "away_id", "away",       
          "spread", "home_ball", "home_score", "away_score", "down",
          "distance", "home_win_prob", "away_win_prob", "play_number",  "yard_line")

test_that("CFB Metrics API Win Probability", {
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
