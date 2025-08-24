

cols <- c(
  "year",
  "athlete_id",
  "athlete_name",
  "position",
  "team",
  "conference",
  "wepa",
  "plays"
)

test_that("CFB Metrics Opponent Adjusted Players Rushing PPA", {
  skip_on_cran()
  x <- cfbd_metrics_wepa_players_rushing(year = 2019, team = "TCU")

  y <- cfbd_metrics_wepa_players_rushing(year = 2019, team = "Alabama")
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
