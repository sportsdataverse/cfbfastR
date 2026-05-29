
test_that("ESPN CFB Calendar", {
  skip_on_cran()

  cols <- c(
    "season",
    "season_type",
    "label",
    "alternate_label",
    "detail",
    "week",
    "start_date",
    "end_date"
  )

  x <- espn_cfb_calendar()

  y <- espn_cfb_calendar(year = 2020)

  # Skip-if-empty guards: ESPN's calendar endpoint occasionally
  # returns an empty frame (between seasons / during transient
  # outages). The schema contract only applies when there are rows.
  if (is.null(x) || nrow(x) == 0L) {
    skip("ESPN calendar (current) returned no rows at test time")
  }
  if (is.null(y) || nrow(y) == 0L) {
    skip("ESPN calendar (year = 2020) returned no rows at test time")
  }

  # Subset direction: hard-coded `cols` is the contract we expect to
  # appear in the response. ESPN adds fields over time, so strict
  # set equality breaks on every upstream addition.
  expect_in(sort(cols), sort(colnames(x)))
  expect_in(sort(cols), sort(colnames(y)))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
