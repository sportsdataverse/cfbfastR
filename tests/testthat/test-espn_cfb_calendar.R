
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

  expect_equal(sort(colnames(x)), sort(cols))
  expect_equal(sort(colnames(y)), sort(cols))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
