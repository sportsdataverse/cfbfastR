context("CFB Game Weather")


  cols <- c(
    "game_id",
    "season",
    "week",
    "season_type",
    "start_time",
    "home_team",
    "home_conference",
    "away_team",
    "away_conference",
    "venue_id",
    "venue",
    "temperature",
    "dew_point",
    "humidity",
    "precipitation",
    "snowfall",
    "wind_direction",
    "wind_speed",
    "pressure",
    "weather_condition_code",
    "weather_condition"
  )

test_that("CFB Game Info", {
  skip_on_cran()
  x <- cfbd_game_weather(2019, week = 1, conference = "ACC")
  
  y <- cfbd_game_weather(2018, week = 4, conference = "Ind")
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
