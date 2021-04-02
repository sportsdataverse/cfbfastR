context("CFB Game Media")

x <- cfbd_game_media(2019, week = 1, conference = 'ACC')

y <- cfbd_game_media(2018, week = 4, conference = 'Ind')

cols <- c("game_id", "season", "week", "season_type", "start_time",
          "is_start_time_tbd", "home_team", "home_conference", "away_team",
          "away_conference","tv", "radio", "web")

test_that("CFB Game Media", {
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
