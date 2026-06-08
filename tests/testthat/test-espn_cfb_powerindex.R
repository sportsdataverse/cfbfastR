

test_that("ESPN CFB Power Index", {
  skip_on_cran()

  cols <- c(
    "season", "team_id", "team_ref", "metric_group", "stat_name",
    "abbreviation", "display_name", "value", "display_value", "description"
  )

  x <- espn_cfb_powerindex(year = 2024)

  y <- espn_cfb_powerindex(year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN power index data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_true(all(x$metric_group %in% c("predictive", "efficiency")))
  expect_true(any(x$stat_name == "fpi"))
})
