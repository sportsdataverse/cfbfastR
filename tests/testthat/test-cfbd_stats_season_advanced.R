
cols <- c(
  "season", "team", "conference", "off_plays", "off_drives",
  "off_ppa", "off_total_ppa", "off_success_rate", "off_explosiveness",
  "off_power_success", "off_stuff_rate", "off_line_yds",
  "off_line_yds_total", "off_second_lvl_yds", "off_second_lvl_yds_total",
  "off_open_field_yds", "off_open_field_yds_total",
  "off_total_opportunities","off_pts_per_opp",
  "off_field_pos_avg_start", "off_field_pos_avg_predicted_points",
  "off_havoc_total", "off_havoc_front_seven", "off_havoc_db",
  "off_standard_downs_rate", "off_standard_downs_ppa",
  "off_standard_downs_success_rate", "off_standard_downs_explosiveness",
  "off_passing_downs_rate", "off_passing_downs_ppa",
  "off_passing_downs_success_rate", "off_passing_downs_explosiveness",
  "off_rushing_plays_rate", "off_rushing_plays_ppa",
  "off_rushing_plays_total_ppa", "off_rushing_plays_success_rate",
  "off_rushing_plays_explosiveness", "off_passing_plays_rate",
  "off_passing_plays_ppa", "off_passing_plays_total_ppa",
  "off_passing_plays_success_rate", "off_passing_plays_explosiveness",
  "def_plays", "def_drives", "def_ppa", "def_total_ppa",
  "def_success_rate", "def_explosiveness", "def_power_success",
  "def_stuff_rate", "def_line_yds", "def_line_yds_total",
  "def_second_lvl_yds", "def_second_lvl_yds_total", "def_open_field_yds",
  "def_open_field_yds_total", "def_total_opportunities",
  "def_pts_per_opp", "def_field_pos_avg_start",
  "def_field_pos_avg_predicted_points", "def_havoc_total",
  "def_havoc_front_seven", "def_havoc_db", "def_standard_downs_rate",
  "def_standard_downs_ppa", "def_standard_downs_success_rate",
  "def_standard_downs_explosiveness", "def_passing_downs_rate",
  "def_passing_downs_ppa", "def_passing_downs_total_ppa",
  "def_passing_downs_success_rate", "def_passing_downs_explosiveness",
  "def_rushing_plays_rate", "def_rushing_plays_ppa", "def_rushing_plays_total_ppa",
  "def_rushing_plays_success_rate", "def_rushing_plays_explosiveness",
  "def_passing_plays_rate", "def_passing_plays_ppa",
  "def_passing_plays_total_ppa",
  "def_passing_plays_success_rate", "def_passing_plays_explosiveness"
)

test_that("CFB Stats Season - Advanced", {

  skip_on_cran()
  x <- cfbd_stats_season_advanced(year = 2018, start_week = 8, end_week = 12, team = "Texas A&M")

  y <- cfbd_stats_season_advanced(2019, team = "LSU")

  z <- cfbd_stats_season_advanced(2013, team = "Florida State")
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_equal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
