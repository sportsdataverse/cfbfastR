

test_that("CFBD Against-the-Spread (ATS) Records", {
  skip_on_cran()
  skip_if(!has_cfbd_key(), "CFBD API key not available")

  cols <- c(
    "year", "team_id", "team", "conference", "games",
    "ats_wins", "ats_losses", "ats_pushes", "avg_cover_margin"
  )

  x <- cfbd_betting_ats(year = 2024, team = "Michigan")

  y <- cfbd_betting_ats(year = 2023, conference = "SEC")

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ATS data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_equal(nrow(x), 1)
})
