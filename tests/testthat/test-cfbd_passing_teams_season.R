
identity_cols <- c("season", "team", "conference")

test_that("CFB Passing Teams Season", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  x <- cfbd_passing_teams_season(year = 2025, team = "Texas")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_s3_class(x, "data.frame")
  expect_true(all(identity_cols %in% colnames(x)))

  # Team frames carry the production + location blocks twice: once for the
  # offense and once for passing allowed. Losing one side would silently halve
  # the frame, so assert both prefixes.
  expect_equal(length(grep("^offense_", colnames(x))), 184L)
  expect_equal(length(grep("^defense_", colnames(x))), 184L)
  expect_equal(ncol(x), 371L)
})
