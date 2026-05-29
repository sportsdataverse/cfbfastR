

test_that("ESPN CFB Season Info", {
  skip_on_cran()

  cols <- c(
    "season", "display_name", "start_date", "end_date", "active_type_id",
    "active_type", "active_type_name", "types_ref", "rankings_ref",
    "athletes_ref", "awards_ref", "futures_ref", "leaders_ref"
  )

  x <- espn_cfb_season_info(year = 2024)

  y <- espn_cfb_season_info(year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN season info data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_equal(nrow(x), 1L)
})
