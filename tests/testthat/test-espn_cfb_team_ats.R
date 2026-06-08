

test_that("ESPN CFB Team ATS", {
  skip_on_cran()

  cols <- c(
    "season", "season_type", "team_id", "ats_type_id", "ats_type_name",
    "ats_description", "wins", "losses", "pushes"
  )

  team_detail_cols <- c(
    "team_name", "team_abbreviation", "team_location", "team_display_name",
    "team_short_display_name", "team_nickname", "team_color",
    "team_alternate_color", "team_logo_href", "team_logo_dark_href"
  )

  x <- espn_cfb_team_ats(team_id = 61, year = 2024)

  y <- espn_cfb_team_ats(team_id = 61, year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN team ATS data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")

  # team_detail = TRUE (default) attaches the friendly team columns.
  expect_in(team_detail_cols, colnames(x))

  # team_detail = FALSE reproduces the un-enriched output.
  z <- espn_cfb_team_ats(team_id = 61, year = 2024, team_detail = FALSE)
  expect_in(cols, colnames(z))
  expect_false(any(team_detail_cols %in% colnames(z)))
})
