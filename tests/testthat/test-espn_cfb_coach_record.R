

test_that("ESPN CFB Coach Season Record", {
  skip_on_cran()

  cols <- c(
    "coach_id", "season", "season_type", "record_id", "record_name",
    "record_type", "record_summary", "record_value", "stat_name",
    "display_name", "short_display_name", "abbreviation", "stat_type",
    "description", "value"
  )

  x <- espn_cfb_coach_record(coach_id = 5120149, year = 2024)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN coach record data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")

  y <- espn_cfb_coach_record(coach_id = 5120149, year = 2023)
  if (!is.null(y) && is.data.frame(y) && nrow(y) > 0) {
    expect_in(cols, colnames(y))
    expect_s3_class(y, "data.frame")
  }
})
