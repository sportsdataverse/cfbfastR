cols <- c(
  "game_id", "play_id", "drive_id", "season", "week", "season_type",
  "offense_id", "offense", "offense_conference",
  "defense_id", "defense", "defense_conference",
  "period", "down", "distance", "play_text",
  "start_yardline", "start_yards_to_goal",
  "rusher_id", "rusher", "rush_direction",
  "rushing_yards", "rusher_yards",
  "is_rushing_touchdown", "is_sack", "is_kneel", "is_team_rush",
  "attribution_status", "direction_analysis_eligible",
  "parse_status", "ppa", "success",
  "clock_minutes", "clock_seconds"
)

test_that("CFB Rushing Plays", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  x <- cfbd_rushing_plays(year = 2025, week = 5)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
  expect_true(all(x$week == 5L))
})

test_that("CFB Rushing Plays rejects invalid enum arguments", {
  # See the note in test-cfbd_passing_plays.R: without the key guard these pass
  # on validate_api_key()'s error rather than on the enum validation.
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  expect_error(cfbd_rushing_plays(year = 2025, rush_direction = "sideways"),
               regexp = "Enter valid rush_direction")
  expect_error(cfbd_rushing_plays(year = 2025, attribution_status = "guessed"),
               regexp = "Enter valid attribution_status")
})

test_that("CFB Rushing Plays does NOT require a year", {
  # Unlike the passing plays endpoint, /rushing/plays does not mark year
  # required in the spec, so a game-scoped call must remain valid.
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  expect_no_error(cfbd_rushing_plays(game_id = 401752717))
})
