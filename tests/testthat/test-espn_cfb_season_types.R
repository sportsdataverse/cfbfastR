

test_that("ESPN CFB Season Types", {
  skip_on_cran()

  cols <- c(
    "season", "season_type", "type", "name", "abbreviation", "slug",
    "start_date", "end_date", "has_groups", "has_standings", "type_ref"
  )

  x <- espn_cfb_season_types(year = 2024)

  y <- espn_cfb_season_types(year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN season types data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
