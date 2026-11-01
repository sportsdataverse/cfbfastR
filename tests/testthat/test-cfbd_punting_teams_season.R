identity_cols <- c("season", "team", "conference")

test_that("CFB Punting Teams Season", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  x <- cfbd_punting_teams_season(year = 2025, team = "Texas")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_s3_class(x, "data.frame")
  expect_in(identity_cols, colnames(x))
  # 3 identity + the 24-column team block twice (punting_ / returning_)
  expect_gte(length(grep("^punting_", colnames(x))), 24L)
  expect_gte(length(grep("^returning_", colnames(x))), 24L)
  expect_in(c("punting_receiving_team_turnovers", "returning_receiving_team_turnovers"),
            colnames(x))
  expect_gte(ncol(x), 51L)
})

test_that("CFB Punting Teams Season returns empty out of coverage", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  # These endpoints carry 2015 onward. Earlier seasons answer HTTP 200 with an
  # empty array, which must surface as a 0-row frame and not a parse error.
  x <- cfbd_punting_teams_season(year = 2014, team = "Texas")
  expect_s3_class(x, "data.frame")
  expect_equal(nrow(x), 0L)
})

test_that("CFB Punting Teams Season requires a year", {
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  expect_error(cfbd_punting_teams_season(team = "Texas"), regexp = "Missing required field: year")
})
