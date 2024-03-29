

cols <- c(
  "play_id", "game_id", "season", "week", "opponent", "team_score", "opponent_score",
  "drive_id", "period", "yards_to_goal", "down", "distance",
  "reception_player_id", "reception_player", "reception_yds",
  "completion_player_id", "completion_player", "completion_yds",
  "rush_player_id", "rush_player", "rush_yds",
  "interception_player_id", "interception_player", "interception_stat",
  "interception_thrown_player_id", "interception_thrown_player", "interception_thrown_stat",
  "touchdown_player_id", "touchdown_player", "touchdown_stat",
  "incompletion_player_id", "incompletion_player", "incompletion_stat",
  "target_player_id", "target_player", "target_stat",
  "fumble_recovered_player_id", "fumble_recovered_player", "fumble_recovered_stat",
  "fumble_forced_player_id", "fumble_forced_player", "fumble_forced_stat",
  "fumble_player_id", "fumble_player", "fumble_stat",
  "sack_player_id", "sack_player", "sack_stat",
  "sack_taken_player_id", "sack_taken_player", "sack_taken_stat",
  "pass_breakup_player_id", "pass_breakup_player", "pass_breakup_stat"
)

test_that("CFB Play Stats - Player", {
  skip_on_cran()
  x <- cfbd_play_stats_player(game_id = 401012356)

  y <- cfbd_play_stats_player(game_id = 401110720)
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
