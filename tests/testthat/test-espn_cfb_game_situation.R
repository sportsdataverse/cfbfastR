

test_that("ESPN CFB Game Situation", {
  skip_on_cran()

  cols <- c(
    "game_id", "down", "distance", "yard_line", "is_red_zone",
    "home_timeouts", "away_timeouts", "last_play_id", "situation_ref",
    "last_play_ref"
  )

  x <- espn_cfb_game_situation(game_id = 401628339)

  y <- espn_cfb_game_situation(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game situation data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
