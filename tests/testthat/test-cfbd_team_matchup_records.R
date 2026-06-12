

cols <- c("start_year", "end_year", "team1", "team1_wins", "team2", "team2_wins", "ties")

test_that("CFB Team Matchup Records", {
  skip_on_cran()
  x <- cfbd_team_matchup_records("Texas", "Oklahoma")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_team_matchup_records("Texas A&M", "TCU", min_year = 1975)
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
