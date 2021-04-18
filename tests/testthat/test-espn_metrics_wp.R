context("CFB Metrics ESPN Win Probability")


cols <- c(
  "espn_game_id", "play_id", "seconds_left",
  "home_win_percentage", "away_win_percentage"
)

test_that("CFB Metrics ESPN Win Probability", {
  skip_on_cran()
  x <- espn_metrics_wp(game_id = 401012356)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
