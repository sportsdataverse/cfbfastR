

test_that("ESPN CFB Season Weeks", {
  skip_on_cran()

  cols <- c(
    "season", "season_type", "week", "text", "start_date", "end_date",
    "week_ref"
  )

  x <- espn_cfb_season_weeks(year = 2024)

  y <- espn_cfb_season_weeks(year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN season weeks data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
