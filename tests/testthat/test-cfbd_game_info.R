

cols <- c(
  "game_id",
  "season",
  "week",
  "season_type",
  "start_date",
  "start_time_tbd",
  "completed",
  "neutral_site",
  "conference_game",
  "attendance",
  "venue_id",
  "venue",
  "home_id",
  "home_team",
  "home_conference",
  "home_division",
  "home_points",
  "home_post_win_prob",
  "home_pregame_elo",
  "home_postgame_elo",
  "away_id",
  "away_team",
  "away_conference",
  "away_division",
  "away_points",
  "away_post_win_prob",
  "away_pregame_elo",
  "away_postgame_elo",
  "excitement_index",
  "highlights",
  "notes"
)

test_that("CFB Game Info", {
  skip_on_cran()
  x <- cfbd_game_info(2019, week = 1, conference = "ACC")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_game_info(2018, week = 4, conference = "Ind")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  # Subset direction (expected subset of actual), per the repo convention:
  # CFBD adds columns over time and an exact set/count assertion turns that
  # into a red build for a change that broke nothing.
  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
