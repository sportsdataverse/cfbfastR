
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

  # Subset direction: hard-coded `cols` is the contract we expect to
  # appear in the response. ESPN adds fields over time, so strict
  # set equality breaks on every upstream addition.
  expect_in(sort(cols), sort(colnames(x)))
  expect_in(sort(cols), sort(colnames(y)))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
