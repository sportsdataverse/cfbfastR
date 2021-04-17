context("CFB Game Box Advanced")



cols <- c("stat", "team1", "team2")
cols <- c("team", "ppa_plays", "ppa_overall_total", "ppa_overall_quarter1", "ppa_overall_quarter2", "ppa_overall_quarter3", "ppa_overall_quarter4", "ppa_passing_total", "ppa_passing_quarter1", "ppa_passing_quarter2", "ppa_passing_quarter3", "ppa_passing_quarter4", "ppa_rushing_total", "ppa_rushing_quarter1", "ppa_rushing_quarter2", "ppa_rushing_quarter3", "ppa_rushing_quarter4", "cumulative_ppa_plays", "cumulative_ppa_overall_total", "cumulative_ppa_overall_quarter1", "cumulative_ppa_overall_quarter2", "cumulative_ppa_overall_quarter3", "cumulative_ppa_overall_quarter4", "cumulative_ppa_passing_total", "cumulative_ppa_passing_quarter1", "cumulative_ppa_passing_quarter2", "cumulative_ppa_passing_quarter3", "cumulative_ppa_passing_quarter4", "cumulative_ppa_rushing_total", "cumulative_ppa_rushing_quarter1", "cumulative_ppa_rushing_quarter2", "cumulative_ppa_rushing_quarter3", "cumulative_ppa_rushing_quarter4", "success_rates_overall_total", "success_rates_overall_quarter1", "success_rates_overall_quarter2", "success_rates_overall_quarter3", "success_rates_overall_quarter4", "success_rates_standard_downs_total", "success_rates_standard_downs_quarter1", "success_rates_standard_downs_quarter2", "success_rates_standard_downs_quarter3", "success_rates_standard_downs_quarter4", "success_rates_passing_downs_total", "success_rates_passing_downs_quarter1", "success_rates_passing_downs_quarter2", "success_rates_passing_downs_quarter3", "success_rates_passing_downs_quarter4", "explosiveness_overall_total", "explosiveness_overall_quarter1", "explosiveness_overall_quarter2", "explosiveness_overall_quarter3", "explosiveness_overall_quarter4", "rushing_power_success", "rushing_stuff_rate", "rushing_line_yds", "rushing_line_yd_avg", "rushing_second_lvl_yds", "rushing_second_lvl_yd_avg", "rushing_open_field_yds", "rushing_open_field_yd_avg", "havoc_total", "havoc_front_seven", "havoc_db", "scoring_opps_opportunities", "scoring_opps_points", "scoring_opps_pts_per_opp", "field_pos_avg_start", "field_pos_avg_starting_predicted_pts")
test_that("CFB Game Box Advanced", {
  skip_on_cran()
  x <- cfbd_game_box_advanced(game_id = 401012356)
  
  y <- cfbd_game_box_advanced(game_id = 401110720)
  expect_equal(nrow(x), 2)
  expect_equal(nrow(y), 2)
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
