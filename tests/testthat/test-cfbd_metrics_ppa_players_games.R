

cols <- c(
  "season", "week", "season_type", "athlete_id", "name", "position", "team", "opponent", "avg_PPA_all",
  "avg_PPA_pass", "avg_PPA_rush"
)

test_that("CFB Metrics PPA Games", {
  skip_on_cran()
  x <- cfbd_metrics_ppa_players_games(year = 2019, week = 4, team = "TCU")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_metrics_ppa_players_games(year = 2019, team = "Alabama", week = 11)
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
