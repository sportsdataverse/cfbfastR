

cols <- c(
  "season", "week", "name", "position", "team", "opponent", "avg_PPA_all",
  "avg_PPA_pass", "avg_PPA_rush"
)

test_that("CFB Metrics PPA Games", {
  skip_on_cran()
  x <- cfbd_metrics_ppa_players_games(year = 2019, week = 4, team = "TCU")

  y <- cfbd_metrics_ppa_players_games(year = 2019, team = "Alabama", week = 11)
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
