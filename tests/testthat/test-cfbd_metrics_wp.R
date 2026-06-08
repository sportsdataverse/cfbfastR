

cols <- c(
  "play_id", "play_text", "home_id", "home", "away_id", "away",
  "spread", "home_ball", "home_score", "away_score", "down",
  "distance", "home_win_prob", "away_win_prob", "play_number", "yard_line"
)

test_that("CFB Metrics API Win Probability", {
  skip_on_cran()
  x <- cfbd_metrics_wp(game_id = 401012356)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_metrics_wp(game_id = 401110720)
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
