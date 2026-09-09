cols <- c(
  "game_id", "play_id", "drive_id", "season", "week", "season_type",
  "offense_id", "offense", "offense_conference",
  "defense_id", "defense", "defense_conference",
  "period", "down", "distance", "play_text",
  "passer_id", "passer", "target_id", "target", "outcome",
  "air_yards", "pass_depth", "pass_direction", "pass_location",
  "total_yards", "yards_after_catch",
  "start_yardline", "start_yards_to_goal", "target_yards_to_goal",
  "is_spike", "is_throwaway", "is_intentional_grounding",
  "parse_status", "ppa", "success", "location_analysis_eligible",
  "clock_minutes", "clock_seconds"
)

test_that("CFB Passing Plays", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  x <- cfbd_passing_plays(year = 2025, week = 5)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
  expect_true(all(x$week == 5L))
})

test_that("CFB Passing Plays honours the outcome filter", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  x <- cfbd_passing_plays(year = 2025, week = 5, outcome = "interception")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_true(all(x$outcome == "interception"))
})

test_that("CFB Passing Plays rejects an invalid outcome", {
  # The key guard AND the message matter: validate_api_key() runs first, so
  # without a key this passes on the missing-key error and never exercises the
  # outcome check it exists to cover (CodeRabbit on #151).
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  expect_error(cfbd_passing_plays(year = 2025, outcome = "touchdown"),
               regexp = "Enter valid outcome")
})

test_that("CFB Passing Plays requires a year", {
  # The API requires `year` here, but validate_year(NULL) is a no-op, so before
  # this guard a yearless call went out without the parameter and came back as
  # an empty frame -- the docs promised a contract nothing enforced.
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  expect_error(cfbd_passing_plays(week = 5), regexp = "Missing required field: year")
})
