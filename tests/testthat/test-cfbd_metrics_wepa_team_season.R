

cols <- c(
  "year",
  "team_id",
  "team",
  "conference",
  "explosiveness",
  "explosiveness_allowed",
  "epa_total",
  "epa_passing",
  "epa_rushing",
  "epa_allowed_total",
  "epa_allowed_passing",
  "epa_allowed_rushing",
  "success_rate_total",
  "success_rate_standard_downs",
  "success_rate_passing_downs",
  "success_rate_allowed_total",
  "success_rate_allowed_standard_downs",
  "success_rate_allowed_passing_downs",
  "rushing_line_yards",
  "rushing_second_level_yards",
  "rushing_open_field_yards",
  "rushing_highlight_yards",
  "rushing_allowed_line_yards",
  "rushing_allowed_second_level_yards",
  "rushing_allowed_open_field_yards",
  "rushing_allowed_highlight_yards"
)

test_that("CFB Metrics Opponent Adjusted Team PPA Season", {
  skip_on_cran()
  x <- cfbd_metrics_wepa_team_season(year = 2019, team = "TCU")

  y <- cfbd_metrics_wepa_team_season(year = 2019, team = "Alabama")
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
