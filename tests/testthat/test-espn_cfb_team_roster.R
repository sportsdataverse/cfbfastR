

test_that("ESPN CFB Team Roster", {
  skip_on_cran()

  cols <- c(
    "season", "team_id", "athlete_id", "first_name", "last_name",
    "full_name", "display_name", "jersey", "position", "position_abbr",
    "height", "display_height", "weight", "display_weight", "experience",
    "class", "birth_city", "birth_state", "birth_country", "status",
    "active", "headshot_href"
  )

  team_detail_cols <- c(
    "team_name", "team_abbreviation", "team_location", "team_display_name",
    "team_short_display_name", "team_nickname", "team_color",
    "team_alternate_color", "team_logo_href", "team_logo_dark_href"
  )
  position_detail_cols <- c(
    "position_id", "position_name", "position_display_name",
    "position_abbreviation", "position_leaf", "position_parent_id"
  )

  x <- espn_cfb_team_roster(team_id = 61, year = 2024)

  y <- espn_cfb_team_roster(team_id = 61, year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN team roster data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")

  # team_detail / position_detail = TRUE (defaults) attach the friendly cols.
  expect_in(team_detail_cols, colnames(x))
  expect_in(position_detail_cols, colnames(x))

  # team_detail = FALSE / position_detail = FALSE reproduce the base output.
  z <- espn_cfb_team_roster(team_id = 61, year = 2024,
                            position_detail = FALSE, team_detail = FALSE)
  expect_in(cols, colnames(z))
  expect_false(any(team_detail_cols %in% colnames(z)))
  expect_false(any(position_detail_cols %in% colnames(z)))
})
