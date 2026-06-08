

test_that("ESPN CFB Team Schedule", {
  skip_on_cran()

  cols <- c(
    "season", "team_id", "game_id", "game_date", "game_name",
    "game_short_name", "season_type", "week", "home_away", "team_score",
    "team_winner", "opponent_id", "opponent_name", "opponent_abbr",
    "opponent_score", "neutral_site", "venue_name", "venue_city",
    "venue_state", "attendance", "broadcast", "status", "completed"
  )

  # The attach helper enriches team_id; opponent_id is enriched via the
  # opponent_team_* alias path.
  team_detail_cols <- c(
    "team_name", "team_abbreviation", "team_location", "team_display_name",
    "team_short_display_name", "team_nickname", "team_color",
    "team_alternate_color", "team_logo_href", "team_logo_dark_href",
    "opponent_team_name", "opponent_team_abbreviation",
    "opponent_team_location", "opponent_team_display_name",
    "opponent_team_short_display_name", "opponent_team_nickname",
    "opponent_team_color", "opponent_team_alternate_color",
    "opponent_team_logo_href", "opponent_team_logo_dark_href"
  )

  x <- espn_cfb_team_schedule(team_id = 61, year = 2024)

  y <- espn_cfb_team_schedule(team_id = 61, year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN team schedule data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")

  # team_detail = TRUE (default) attaches the friendly team columns and
  # retains the original opponent_id (the opponent_team_id alias is dropped).
  expect_in(team_detail_cols, colnames(x))
  expect_in("opponent_id", colnames(x))
  expect_false("opponent_team_id" %in% colnames(x))

  # team_detail = FALSE reproduces the un-enriched output.
  z <- espn_cfb_team_schedule(team_id = 61, year = 2024, team_detail = FALSE)
  expect_in(cols, colnames(z))
  expect_false(any(team_detail_cols %in% colnames(z)))
})
