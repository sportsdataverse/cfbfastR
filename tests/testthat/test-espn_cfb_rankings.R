

test_that("ESPN CFB Ranking Sources", {
  skip_on_cran()

  cols <- c(
    "season", "ranking_id", "name", "short_name", "type", "n_snapshots",
    "ranking_ref"
  )

  x <- espn_cfb_rankings(year = 2024)

  y <- espn_cfb_rankings(year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN rankings data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
