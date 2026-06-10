cols <- c(
  "year", "team", "conference", "athlete_id", "player", "position",
  "passing_completions", "passing_att", "passing_pct", "passing_yds",
  "passing_td", "passing_int", "passing_ypa",
  "rushing_car", "rushing_yds", "rushing_td", "rushing_ypc", "rushing_long",
  "receiving_rec", "receiving_yds", "receiving_td", "receiving_ypr", "receiving_long",
  "fumbles_fum", "fumbles_rec", "fumbles_lost",
  "defensive_solo", "defensive_tot", "defensive_tfl", "defensive_sacks",
  "defensive_qb_hur", "interceptions_int", "interceptions_yds",
  "interceptions_avg", "interceptions_td", "defensive_pd", "defensive_td",
  "kicking_fgm", "kicking_fga", "kicking_pct",
  "kicking_xpa", "kicking_xpm", "kicking_pts", "kicking_long",
  "kick_returns_no", "kick_returns_yds", "kick_returns_avg",
  "kick_returns_td", "kick_returns_long",
  "punting_no", "punting_yds", "punting_ypp",
  "punting_long", "punting_in_20", "punting_tb",
  "punt_returns_no", "punt_returns_yds", "punt_returns_avg",
  "punt_returns_td", "punt_returns_long"
)

test_that("CFB Season Player Stats", {
  skip_on_cran()
  x <- cfbd_stats_season_player(year = 2018, conference = "Ind")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_stats_season_player(year = 2019, team = "Florida State", category = "passing")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  z <- cfbd_stats_season_player(year = 2018, team = "Florida State")
  if (is.null(z) || !is.data.frame(z) || nrow(z) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_setequal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
