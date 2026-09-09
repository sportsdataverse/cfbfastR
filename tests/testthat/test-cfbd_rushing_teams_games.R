
identity_cols <- c("game_id", "season", "week", "season_type",
                   "team", "conference", "opponent")

test_that("CFB Rushing Teams Games", {
  skip_on_cran()
  x <- cfbd_rushing_teams_games(year = 2025, week = 5)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_s3_class(x, "data.frame")
  expect_true(all(identity_cols %in% colnames(x)))
  expect_equal(length(grep("^offense_", colnames(x))), 86L)
  expect_equal(length(grep("^defense_", colnames(x))), 86L)
  expect_equal(ncol(x), 179L)
})
