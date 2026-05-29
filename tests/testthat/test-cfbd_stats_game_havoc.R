

cols <- c(
  "game_id", "season", "season_type", "week", "team", "conference",
  "opponent", "opponent_conference",
  "off_total_plays", "off_total_havoc_events", "off_front_seven_havoc_events",
  "off_db_havoc_events", "off_havoc_rate", "off_front_seven_havoc_rate",
  "off_db_havoc_rate",
  "def_total_plays", "def_total_havoc_events", "def_front_seven_havoc_events",
  "def_db_havoc_events", "def_havoc_rate", "def_front_seven_havoc_rate",
  "def_db_havoc_rate"
)

test_that("CFB Stats Game - Havoc", {
  skip_on_cran()
  skip_if(!has_cfbd_key(), "CFBD API key not available for testing")

  x <- cfbd_stats_game_havoc(year = 2024, team = "Georgia")
  y <- cfbd_stats_game_havoc(year = 2023, team = "Georgia")

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No CFBD game havoc data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")

  if (!is.null(y) && is.data.frame(y) && nrow(y) > 0) {
    expect_in(cols, colnames(y))
    expect_s3_class(y, "data.frame")
  }
})
