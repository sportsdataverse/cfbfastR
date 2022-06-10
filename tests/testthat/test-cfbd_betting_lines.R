


test_that("CFB Betting Lines", {
  skip_on_cran()
  x <- cfbd_betting_lines(
    year = 2018,
    week = 12,
    team = "Florida State"
  )

  y <- cfbd_betting_lines(
    year = 2018,
    week = 13,
    team = "Texas A&M",
    conference = "SEC",
    line_provider = "numberfire"
  )

  cols <- c(
    "game_id", "season", "season_type", "week",
    "start_date",
    "home_team", "home_conference", "home_score",
    "away_team", "away_conference", "away_score",
    "provider", "spread", "formatted_spread",
    "spread_open", "over_under", "over_under_open",
    "home_moneyline", "away_moneyline"
  )
  expect_equal(nrow(x), 4)
  expect_equal(nrow(y), 1)
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
