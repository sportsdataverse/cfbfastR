

test_that("ESPN CFB Recruits", {
  skip_on_cran()

  cols <- c(
    "recruit_id", "recruiting_class", "athlete_id", "alternate_athlete_id",
    "first_name", "last_name", "full_name", "display_name", "short_name",
    "position_id", "position_abbreviation", "weight", "height", "grade",
    "grade_display_value", "overall_rank", "position_rank", "state_rank",
    "region_rank", "status_id", "status", "committed_team_id",
    "hometown_city", "hometown_state", "hometown_state_abbreviation",
    "high_school_id", "high_school_name", "recruit_ref", "athlete_ref",
    "committed_team_ref"
  )

  x <- espn_cfb_recruits(year = 2024, max_results = 30)
  y <- espn_cfb_recruits(year = 2023, max_results = 30)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN recruits data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  expect_lte(nrow(x), 30L)

  if (!is.null(y) && is.data.frame(y) && nrow(y) > 0) {
    expect_in(cols, colnames(y))
    expect_s3_class(y, "data.frame")
    expect_lte(nrow(y), 30L)
  }
})
