

test_that("ESPN CFB Game Odds", {
  skip_on_cran()

  cols <- c(
    "game_id", "provider_id", "provider_name", "provider_priority",
    "details", "over_under", "spread", "over_odds", "under_odds",
    "home_favorite", "home_underdog", "away_favorite", "away_underdog",
    "home_spread_odds", "away_spread_odds", "home_money_line",
    "away_money_line", "moneyline_winner", "spread_winner"
  )

  x <- espn_cfb_game_odds(game_id = 401628339)

  y <- espn_cfb_game_odds(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game odds data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})

test_that("ESPN CFB Game Odds - line_history = TRUE", {
  skip_on_cran()

  cols <- c(
    "game_id", "provider_id", "provider_name", "snapshot", "market", "side",
    "american", "value", "display_value"
  )

  x <- espn_cfb_game_odds(game_id = 401628339, line_history = TRUE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game odds data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
})
