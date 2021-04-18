context("CFB Game Team Stats")
cols1 <- c("game_id", "school",  "conference", "home_away",
           "points", "total_yards", "net_passing_yards", 
           "completion_attempts","passing_tds","yards_per_pass",
           "passes_intercepted","interception_yards", "interception_tds", 
           "rushing_attempts", "rushing_yards","rush_tds", "yards_per_rush_attempt",
           "first_downs", "third_down_eff", "fourth_down_eff",
           "punt_returns", "punt_return_yards", "punt_return_tds",               
           "kick_return_yards", "kick_return_tds", "kick_returns", "kicking_points",    
           "fumbles_recovered","fumbles_lost", "total_fumbles",                 
           "tackles", "tackles_for_loss", "sacks", "qb_hurries",  
           "interceptions", "passes_deflected", "turnovers","defensive_tds", 
           "total_penalties_yards", "possession_time",
           "conference_allowed", "home_away_allowed",                    
           "points_allowed", "total_yards_allowed", "net_passing_yards_allowed", 
           "completion_attempts_allowed","passing_tds_allowed","yards_per_pass_allowed",
           "passes_intercepted_allowed","interception_yards_allowed", "interception_tds_allowed", 
           "rushing_attempts_allowed", "rushing_yards_allowed",
           "rush_tds_allowed", "yards_per_rush_attempt_allowed",
           "first_downs_allowed", "third_down_eff_allowed", "fourth_down_eff_allowed",
           "punt_returns_allowed", "punt_return_yards_allowed", "punt_return_tds_allowed",               
           "kick_return_yards_allowed", "kick_return_tds_allowed", 
           "kick_returns_allowed", "kicking_points_allowed",    
           "fumbles_recovered_allowed","fumbles_lost_allowed", "total_fumbles_allowed",                 
           "tackles_allowed", "tackles_for_loss_allowed", "sacks_allowed", "qb_hurries_allowed",  
           "interceptions_allowed", "passes_deflected_allowed", 
           "turnovers_allowed","defensive_tds_allowed", 
           "total_penalties_yards_allowed", "possession_time_allowed")  

cols2 <- c("game_id", "school",  "conference", "home_away",                    
           "points", "total_yards", "net_passing_yards", 
           "completion_attempts","passing_tds","yards_per_pass",
           "passes_intercepted","interception_yards", "interception_tds", 
           "rushing_attempts", "rushing_yards","rush_tds", "yards_per_rush_attempt",
           "first_downs", "third_down_eff", "fourth_down_eff",
           "punt_returns", "punt_return_yards", "punt_return_tds",               
           "kick_return_yards", "kick_return_tds", "kick_returns", "kicking_points",    
           "fumbles_recovered","fumbles_lost", "total_fumbles",                 
           "tackles", "tackles_for_loss", "sacks", "qb_hurries",  
           "interceptions", "passes_deflected", "turnovers","defensive_tds", 
           "total_penalties_yards", "possession_time")

test_that("CFB Game Team Stats", {
  skip_on_cran()
  x <- cfbd_game_team_stats(year = 2018, week = 9, team = 'Notre Dame')
  
  y <- cfbd_game_team_stats(2013, week = 1, team = "Florida State")
  
  z <- cfbd_game_team_stats(2013, week = 3, team = "Florida State", rows_per_team = 2)
  
  expect_equal(colnames(x), cols1)
  expect_equal(colnames(y), cols1)
  expect_equal(colnames(z), cols2)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})