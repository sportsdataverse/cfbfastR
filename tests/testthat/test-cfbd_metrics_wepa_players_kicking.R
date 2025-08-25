

cols <- c(
  "year",
  "athlete_id",
  "athlete_name",
  "team",
  "conference",
  "paar",
  "attempts"
)

test_that("CFB Metrics Points Added Above Replacement (PAAR) ratings for kickers", {
  skip_on_cran()
  x <- cfbd_metrics_wepa_players_kicking(year = 2019, team = "TCU")

  y <- cfbd_metrics_wepa_players_kicking(year = 2019, team = "Alabama")
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
