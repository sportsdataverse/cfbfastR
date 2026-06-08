

test_that("ESPN CFB Betting Futures", {
  skip_on_cran()

  cols <- c(
    "season", "market_id", "market_name", "market_type", "market_display",
    "provider_id", "provider_name", "team_id", "athlete_id", "odds_value",
    "team_ref", "athlete_ref"
  )

  x <- espn_cfb_futures(year = 2024)

  y <- espn_cfb_futures(year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN futures data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
