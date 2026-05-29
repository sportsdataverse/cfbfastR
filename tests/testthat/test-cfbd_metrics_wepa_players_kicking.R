

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
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_metrics_wepa_players_kicking(year = 2019, team = "Alabama")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
