

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

  y <- cfbd_game_info(2018, week = 4, conference = "Ind")
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
