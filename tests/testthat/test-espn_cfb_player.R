

test_that("ESPN CFB Player Detail", {
  skip_on_cran()

  cols <- c(
    "athlete_id", "season", "uid", "guid", "first_name", "last_name",
    "full_name", "display_name", "weight", "height", "jersey", "slug",
    "active", "position_id", "position_name", "position_abbreviation",
    "status_id", "status_name", "team_id", "team_ref", "statistics_ref",
    "eventlog_ref"
  )

  # team_detail = TRUE / position_detail = TRUE (defaults) -- the friendly
  # team and position columns are joined in next to their id columns.
  detail_cols <- c(
    "team_name", "team_abbreviation", "team_location", "team_display_name",
    "team_short_display_name", "team_nickname", "team_color",
    "team_alternate_color", "team_logo_href", "team_logo_dark_href",
    "position_display_name", "position_leaf", "position_parent_id"
  )

  x <- espn_cfb_player(athlete_id = 102597, year = 2024)

  y <- espn_cfb_player(athlete_id = 102597, year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN player data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_in(detail_cols, colnames(x))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_equal(nrow(x), 1L)

  # team_detail = FALSE / position_detail = FALSE -- the friendly columns
  # (and the catalog fetches) are skipped; the base schema is unchanged.
  z <- espn_cfb_player(athlete_id = 102597, year = 2024,
                       team_detail = FALSE, position_detail = FALSE)
  if (is.data.frame(z) && nrow(z) > 0) {
    expect_in(cols, colnames(z))
    expect_false(any(detail_cols %in% colnames(z)))
  }
})
