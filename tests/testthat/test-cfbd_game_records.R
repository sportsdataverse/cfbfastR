


cols <- c(
  "year", "team_id", "team", "classification", "conference", "division", "expected_wins",
  "total_games", "total_wins", "total_losses", "total_ties",
  "conference_games", "conference_wins", "conference_losses", "conference_ties",
  "home_games", "home_wins", "home_losses", "home_ties",
  "away_games", "away_wins", "away_losses", "away_ties",
  "neutral_games", "neutral_wins", "neutral_losses", "neutral_ties",
  "regular_season_games", "regular_season_wins", "regular_season_losses", "regular_season_ties",
  "postseason_games", "postseason_wins", "postseason_losses", "postseason_ties"
)

test_that("CFB Game Records", {
  skip_on_cran()
  x <- cfbd_game_records(2018, team = "Notre Dame")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_game_records(2013, team = "Florida State")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
