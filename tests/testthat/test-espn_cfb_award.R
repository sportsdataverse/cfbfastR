

test_that("ESPN CFB Award Detail", {
  skip_on_cran()

  cols <- c(
    "season", "award_id", "name", "description", "history", "athlete_id",
    "team_id", "award_ref", "athlete_ref", "team_ref"
  )

  team_cols <- c(
    "team_name", "team_abbreviation", "team_location", "team_display_name",
    "team_short_display_name", "team_nickname", "team_color",
    "team_alternate_color", "team_logo_href", "team_logo_dark_href"
  )

  x <- espn_cfb_award(award_id = 1, year = 2024)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN award data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(team_cols, colnames(x))
  expect_s3_class(x, "data.frame")

  # team_detail = FALSE reproduces the prior (non-enriched) output.
  x_plain <- espn_cfb_award(award_id = 1, year = 2024, team_detail = FALSE)
  expect_in(cols, colnames(x_plain))
  expect_false(any(team_cols %in% colnames(x_plain)))

  y <- espn_cfb_award(award_id = 1, year = 2023)
  if (!is.null(y) && is.data.frame(y) && nrow(y) > 0) {
    expect_in(cols, colnames(y))
    expect_in(team_cols, colnames(y))
    expect_s3_class(y, "data.frame")
  }
})
