

test_that("CFB Game Player Stats", {
  skip_on_cran()
  cols <- c(
    "game_id",
    "team",
    "conference",
    "home_away",
    "team_points",
    "athlete_id",
    "athlete_name",
    "defensive_td",
    "defensive_qb_hur",
    "defensive_pd",
    "defensive_tfl",
    "defensive_sacks",
    "defensive_solo",
    "defensive_tot",
    "fumbles_rec",
    "fumbles_lost",
    "fumbles_fum",
    "punting_long",
    "punting_in_20",
    "punting_tb",
    "punting_avg",
    "punting_yds",
    "punting_no",
    "kicking_pts",
    "kicking_long",
    "kicking_pct",
    "punt_returns_td",
    "punt_returns_long",
    "punt_returns_avg",
    "punt_returns_yds",
    "punt_returns_no",
    "kick_returns_td",
    "kick_returns_long",
    "kick_returns_avg",
    "kick_returns_yds",
    "kick_returns_no",
    "interceptions_td",
    "interceptions_yds",
    "interceptions_int",
    "receiving_long",
    "receiving_td",
    "receiving_avg",
    "receiving_yds",
    "receiving_rec",
    "rushing_long",
    "rushing_td",
    "rushing_avg",
    "rushing_yds",
    "rushing_car",
    "passing_int",
    "passing_td",
    "passing_avg",
    "passing_yds",
    "passing_completions",
    "passing_attempts",
    "passing_qbr",
    "kicking_xpm",
    "kicking_xpa",
    "kicking_fgm",
    "kicking_fga")

  x <- cfbd_game_player_stats(2018, week = 15, conference = 'Ind')

  y <- cfbd_game_player_stats(2013, week = 1, team = "Florida State", category = 'passing')

  z <- cfbd_game_player_stats(2013, week = 1, team = "Florida State")
  expect_setequal(sort(colnames(x)), sort(cols))
  expect_setequal(sort(colnames(y)), sort(cols))
  expect_setequal(sort(colnames(z)), sort(cols))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
