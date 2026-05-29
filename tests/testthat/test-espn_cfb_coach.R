

test_that("ESPN CFB Coach Detail", {
  skip_on_cran()

  cols <- c(
    "coach_id", "season", "first_name", "last_name", "uid", "team_id",
    "n_career_records", "n_coach_seasons", "team_ref", "person_ref"
  )

  team_cols <- c(
    "team_name", "team_abbreviation", "team_location", "team_display_name",
    "team_short_display_name", "team_nickname", "team_color",
    "team_alternate_color", "team_logo_href", "team_logo_dark_href"
  )

  x <- espn_cfb_coach(coach_id = 5120149, year = 2024)

  y <- espn_cfb_coach(coach_id = 5120149, year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN coach data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(team_cols, colnames(x))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_equal(nrow(x), 1L)

  # team_detail = FALSE reproduces the prior (non-enriched) output.
  x_plain <- espn_cfb_coach(coach_id = 5120149, year = 2024,
                            team_detail = FALSE)
  expect_in(cols, colnames(x_plain))
  expect_false(any(team_cols %in% colnames(x_plain)))
})
