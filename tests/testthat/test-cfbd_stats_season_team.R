

cols <- c(
  "season", "team", "conference", "games", "time_of_poss_total", #"time_of_poss_pg",
  "pass_comps", "pass_atts", #"completion_pct",
  "net_pass_yds", #"pass_ypa", "pass_ypr",
  "pass_TDs", "interceptions", #"int_pct",
  "rush_atts", "rush_yds", "rush_TDs", #"rush_ypc",
  "total_yds", "fumbles_lost", "turnovers",#"turnovers_pg",
  "first_downs", "third_downs", "third_down_convs",
  #"third_conv_rate",
  "fourth_down_convs", "fourth_downs",
  #"fourth_conv_rate",
  "penalties", "penalty_yds", #"penalties_pg","penalty_yds_pg", "yards_per_penalty",
  "kick_returns", "kick_return_yds",
  "kick_return_TDs", #"kick_return_avg",
  "punt_returns", "punt_return_yds",
  "punt_return_TDs", #"punt_return_avg",
  "passes_intercepted",
  "passes_intercepted_yds", "passes_intercepted_TDs"
)

test_that("CFB Team Season Stats", {
  skip_on_cran()
  x <- cfbd_stats_season_team(year = 2018, conference = "B12", start_week = 1, end_week = 8)

  y <- cfbd_stats_season_team(2019, team = "LSU")

  z <- cfbd_stats_season_team(2013, team = "Florida State")
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_setequal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
