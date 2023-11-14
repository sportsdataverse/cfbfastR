


cols <- c(
  "year", "team_id", "team", "conference", "division", "expected_wins",
  "total_games", "total_wins", "total_losses", "total_ties",
  "conference_games", "conference_wins", "conference_losses", "conference_ties",
  "home_games", "home_wins", "home_losses", "home_ties",
  "away_games", "away_wins", "away_losses", "away_ties"
)

test_that("CFB Game Records", {
  skip_on_cran()
  x <- cfbd_game_records(2018, team = "Notre Dame")

  y <- cfbd_game_records(2013, team = "Florida State")
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
