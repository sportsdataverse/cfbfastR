

  cols <- c(
    "game_id",
    "season",
    "week",
    "season_type",
    "start_time",
    "game_indoors",
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
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_game_weather(2018, week = 4, conference = "Ind")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
