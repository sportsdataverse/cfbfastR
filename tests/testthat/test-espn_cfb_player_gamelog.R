

test_that("ESPN CFB Player Game Log", {
  skip_on_cran()

  cols <- c(
    "athlete_id", "season", "season_type", "game_id", "game_date",
    "week", "at_vs", "opponent_id", "opponent_name", "team_id",
    "game_result", "score"
  )

  # team_detail = TRUE (default) -- friendly team columns joined next to
  # the team_id column.
  team_cols <- c(
    "team_name", "team_abbreviation", "team_location", "team_display_name",
    "team_short_display_name", "team_nickname", "team_color",
    "team_alternate_color", "team_logo_href", "team_logo_dark_href"
  )

  # athlete_detail = TRUE (default) -- friendly athlete name columns
  # appended from one cheap athlete fetch.
  athlete_cols <- c(
    "athlete_display_name", "athlete_first_name", "athlete_last_name",
    "athlete_jersey", "athlete_position", "athlete_position_abbreviation"
  )

  x <- espn_cfb_player_gamelog(athlete_id = 102597, year = 2024)

  y <- espn_cfb_player_gamelog(athlete_id = 102597, year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN player game log data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_in(team_cols, colnames(x))
  expect_in(athlete_cols, colnames(x))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_true(all(!is.na(x$game_id)))

  # team_detail = FALSE / athlete_detail = FALSE -- the friendly columns
  # and the extra fetches are skipped; the base schema is unchanged.
  z <- espn_cfb_player_gamelog(athlete_id = 102597, year = 2024,
                               team_detail = FALSE,
                               athlete_detail = FALSE)
  if (is.data.frame(z) && nrow(z) > 0) {
    expect_in(cols, colnames(z))
    expect_false(any(team_cols %in% colnames(z)))
    expect_false(any(athlete_cols %in% colnames(z)))
  }
})
