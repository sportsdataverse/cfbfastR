# The NCAA's 2012 kickoff rule brought a touchback out to the 25 (75 yards to
# goal); through 2011 it came out to the 20 (80). Before this fix every kickoff
# touchback site scored 75 whatever the season. Twin of sdv-py #778.

test_that("the touchback spot follows the 2012 rule", {
  expect_equal(.kickoff_touchback_ytg(2011), 80)
  expect_equal(.kickoff_touchback_ytg(2012), 75)
  expect_equal(.kickoff_touchback_ytg(2013), 75)
  expect_equal(.kickoff_touchback_ytg(NULL), 75)
  expect_equal(.kickoff_touchback_ytg(NA), 75)
})

# A 2011 and a 2012 game, each one kickoff touchback plus one scrimmage play.
.tb_rows <- function(season) {
  data.frame(
    id_play = c(1, 2), new_id = c(1, 2), drive_id = 1, game_id = season, play_order = c(1, 2),
    season = season, period = 1, play_type = c("Kickoff", "Rush"),
    kickoff_play = c(1, 0), kickoff_tb = c(1, 0), turnover = 0,
    change_of_pos_team = 0, TimeSecsRem = 1800, adj_TimeSecsRem = 3600,
    down = c(1, 1), distance = 10, yards_to_goal = c(65, 75),
    log_ydstogo = log(10), Under_two = FALSE, Goal_To_Go = FALSE,
    pos_score_diff_start = 0, ep_before = 0, half = 1, ExpScoreDiff = 0,
    pos_team_timeouts_rem_before = 3, def_pos_team_timeouts_rem_before = 3,
    new_TimeSecsRem = 1800, new_down = 1, new_distance = 10,
    new_yardline = c(75, 70), new_log_ydstogo = log(10), new_Under_two = FALSE,
    new_Goal_To_Go = FALSE, new_pos_score_diff_start = 0
  )
}

# The kickoff row's yards_to_goal as each EP site hands it to the model. The
# kickoff call is the only one whose frame holds just the kickoff rows; the run
# is stopped there, so the rest of the EP pipeline needs no columns.
.ep_kickoff_ytg <- function(fn, season) {
  seen <- NULL
  fake_probs <- function(n) {
    m <- matrix(1 / 7, n, 7)
    colnames(m) <- .EP_LEV
    m
  }
  local_mocked_bindings(
    .ep_predict = function(model, df) {
      if (all(df$play_type == "Kickoff")) {
        seen <<- df$yards_to_goal
        stop("kickoff scored")
      }
      fake_probs(nrow(df))
    },
    .pbp_epa_fg_probs = function(dat, current_probs, ...) as.data.frame(current_probs),
    epa_fg_probs = function(dat, current_probs, ...) as.data.frame(current_probs)
  )
  expect_error(fn(.tb_rows(season), ep_model = NULL, fg_model = NULL, season = season),
               "kickoff scored")
  seen
}

test_that("create_epa scores a kickoff as a touchback at the 2011 and 2012 spots", {
  for (fn in list(.pbp_create_epa, create_epa)) {
    expect_equal(.ep_kickoff_ytg(fn, 2011), 80)
    expect_equal(.ep_kickoff_ytg(fn, 2012), 75)
  }
})

test_that("create_wpa_naive scores the kickoff wp_before at the 2011 and 2012 spots", {
  # A stand-in WP model that reads back the yards_to_goal it was handed.
  local_mocked_bindings(
    .wp_predict = function(model, df) df$yards_to_goal / 100,
    .pbp_wpa_calcs_naive = function(df) df,
    wpa_calcs_naive = function(df) df
  )
  for (fn in list(.pbp_create_wpa_naive, create_wpa_naive)) {
    for (s in c(2011, 2012)) {
      out <- fn(.tb_rows(s), wp_model = NULL, season = s)
      expect_equal(out$wp_before[out$kickoff_play == 1], if (s == 2011) 0.80 else 0.75)
    }
  }
})

# The touchback's end spot (`new_yardline`) through both prep_epa_df_after()
# copies. The frame holds the columns the two functions read, zero by default.
.prep_rows <- function() {
  zero <- c(
    "half", "yards_gained", "lead_down", "lead_down2", "lead_distance",
    "penalty_1st_conv", "penalty_declined", "penalty_offset",
    "drive_start_yards_to_goal", "lead_play_type", "lead_play_type2",
    "lead_distance2", "downs_turnover", "punt", "lead_yards_to_goal",
    "lag_play_type", "id_drive", "drive_id", "drive_event_number",
    "lag_kickoff_play", "lag_play_type2", "lag_kickoff_play2",
    "lag_change_of_pos_team", "lag_punt", "lag_downs_turnover",
    "lag_turnover_vec", "lag_change_of_pos_team2", "lag_punt2",
    "lag_downs_turnover2", "lag_turnover_vec2", "lag_scoring_play",
    "lag_scoring_play2", "lag_change_of_pos_team3", "end_of_half",
    "change_of_pos_team", "pos_score_diff"
  )
  df <- data.frame(
    game_id = 1, id_play = c(1, 2), play_order = c(1, 2), new_id = c(1, 2),
    play_type = c("Kickoff", "Rush"), kickoff_play = c(1, 0), kickoff_tb = c(1, 0),
    period = 1, yard_line = c(35, 25), TimeSecsRem = 1800, lead_TimeSecsRem = 1790,
    down = 1, distance = 10, yards_to_goal = c(65, 75)
  )
  df[zero] <- 0
  df
}

test_that("prep_epa_df_after ends a kickoff touchback at the 2011 and 2012 spots", {
  for (fn in list(.pbp_prep_epa_df_after, prep_epa_df_after)) {
    for (s in c(2011, 2012)) {
      out <- fn(.prep_rows(), season = s)
      expect_equal(out$new_yardline[out$kickoff_play == 1], if (s == 2011) 80 else 75)
    }
  }
})

# A kickoff touchback and a kickoff out of bounds, for add_yardage().
.yardage_rows <- function(season = NULL) {
  df <- data.frame(
    play_type = "Kickoff", kickoff_play = 1, kickoff_tb = c(1, 0),
    play_text = c("Smith kickoff for 65 yds for a touchback",
                  "Smith kickoff for 60 yds, out of bounds")
  )
  df[c("rush", "pass", "yards_gained", "int_td", "int", "fumble_vec",
       "kickoff_downed", "kickoff_fair_catch", "punt", "punt_blocked",
       "punt_tb", "punt_downed", "punt_oob", "punt_fair_catch", "sack",
       "penalty_detail")] <- 0
  if (!is.null(season)) df$season <- season
  df
}

test_that("add_yardage spots a touchback and an out-of-bounds kickoff by season", {
  expect_equal(add_yardage(.yardage_rows(), season = 2011)$yds_kickoff_return, c(20, 40))
  expect_equal(add_yardage(.yardage_rows(), season = 2012)$yds_kickoff_return, c(25, 35))
  # With no argument, the frame's own season column decides.
  expect_equal(add_yardage(.yardage_rows(2011))$yds_kickoff_return, c(20, 40))
})

test_that("a missing season scores the 2012 rules and says so", {
  rlang::local_options(rlib_warning_verbosity = "verbose")
  for (s in list(NULL, NA)) {
    expect_warning(out <- add_yardage(.yardage_rows(), season = s), "touchback at the 25.*out of bounds at the 35")
    expect_equal(out$yds_kickoff_return, c(25, 35))
    expect_warning(out <- prep_epa_df_after(.prep_rows(), season = s), "touchback at the 25.*out of bounds at the 35")
    expect_equal(out$new_yardline[out$kickoff_play == 1], 75)
  }
  # A frame season column means no warning.
  expect_no_warning(add_yardage(.yardage_rows(2013)))
})

test_that("a factor season is read by its label, not its level index", {
  expect_equal(.kickoff_touchback_ytg(factor(2011)), 80)
  expect_equal(.kickoff_touchback_ytg(factor(2012)), 75)
  expect_equal(add_yardage(.yardage_rows(), season = factor(2011))$yds_kickoff_return, c(20, 40))
  expect_equal(add_yardage(.yardage_rows(factor(2012)))$yds_kickoff_return, c(25, 35))
})
