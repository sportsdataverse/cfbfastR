test_that("CFBD - Team Season Overview", {
  skip_on_cran()
  x <- cfbd_team_season_overview(year = 2024, team = "Texas")
  if (is.null(x) || !is.list(x) || length(x) == 0L || nrow(x$overview) == 0L) skip("CFBD rate-limited or returned no rows")
  expect_type(x, "list")
  expect_in(c("overview", "record", "ratings", "advanced", "passing",
              "rushing", "players"), names(x))
  expect_in(c("season", "team_id", "team"), colnames(x$overview))
  expect_s3_class(x$overview, "data.frame")
})
