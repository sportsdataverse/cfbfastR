### Parity oracle: sdv-py's overtime WP stage and air-yards CP on two real overtime games
###
### fixtures/parity/wp_overtime_oracle.csv.gz (provenance in fixtures/parity/README.md) holds,
### per play of two 2025 games that reached overtime (one a second overtime, where a touchdown
### must be followed by a two-point try), the start state sdv-py scored its WP boosters on, the
### boosters' raw output and that output through sdv-py's cfb_wp_overtime.adjust_wp
### (`wp_*_adj`), plus sdv-py's published cp / cp_model / cp_game_state with their inputs.
### Both languages load the same booster bytes, so a gap is a port divergence.
###
### Allow-list: sdv-py's published wp_before_naive / wp_before are not compared on overtime
### rows -- its end-of-possession and shootout stages rewrite them, and cfbfastR has not ported
### those. The `wp_*_adj` columns are the adjust_wp output on the start state, which is what
### cfbfastR's .wp_predict() / .pbp_add_vegas_wp() compute.

ot_path <- testthat::test_path("fixtures", "parity", "wp_overtime_oracle.csv.gz")
tol <- 1e-5

skip_if_no_ot_models <- function() {
  testthat::skip_on_cran()
  testthat::skip_if_not_installed("xgboost")
  testthat::skip_if_not(inherits(.cfb_model("wp_model"), "xgb.Booster"),
                        "WP booster unavailable (bundle not fetched)")
  testthat::skip_if(is.null(.cfb_wp_spread_model()), "spread WP booster unavailable")
  testthat::skip_if(is.null(.cfb_wp_ot_model()), "wp_ot_reach unavailable")
}

read_ot_oracle <- function() {
  o <- utils::read.csv(ot_path, colClasses = c(game_id = "character",
                       id_play = "character", home_id = "character",
                       pos_team_id = "character"), na.strings = c("", "NA"))
  for (c in c("is_home", "pos_team_receives_2H_kickoff", "ot_second", "ot_forced",
              "pass", "rush", "completion", "qb_hurry", "passing_down")) {
    o[[c]] <- as.integer(as.logical(o[[c]]))
  }
  o
}

# The oracle's start state under cfbfastR's names (team ids for pos_team / home).
r_ot_state <- function(o) {
  data.frame(
    game_id = o$game_id, play_order = o$play_order, play_type = o$play_type,
    season = o$season,
    pos_team = o$pos_team_id, home = o$home_id,
    pos_team_receives_2H_kickoff = o$pos_team_receives_2H_kickoff,
    TimeSecsRem = o$TimeSecsRem, adj_TimeSecsRem = o$adj_TimeSecsRem,
    ExpScoreDiff_Time_Ratio = o$ExpScoreDiff_Time_Ratio,
    pos_score_diff_start = o$pos_score_diff_start,
    down = o$down, distance = o$distance, yards_to_goal = o$yards_to_goal,
    pos_team_timeouts_rem_before = o$pos_team_timeouts_rem_before,
    def_pos_team_timeouts_rem_before = o$def_pos_team_timeouts_rem_before,
    period = o$period,
    spread = ifelse(o$is_home == 1, -o$pos_team_spread, o$pos_team_spread),
    pass = o$pass, rush = o$rush, completion = o$completion,
    air_yards = o$air_yards, pass_direction = o$pass_direction, qb_hurry = o$qb_hurry,
    stringsAsFactors = FALSE
  )
}

expect_close_ot <- function(got, want, what) {
  d <- abs(as.numeric(got) - as.numeric(want))
  testthat::expect_false(anyNA(d), info = paste(what, "has NA"))
  testthat::expect_lt(max(d, na.rm = TRUE), tol, label = paste(what, "max |R - sdv-py|"))
}

test_that("the overtime oracle covers what it claims", {
  o <- read_ot_oracle()
  expect_equal(length(unique(o$game_id)), 2L)
  expect_true(any(o$period >= 6))
  expect_true(any(o$ot_forced == 1))
  expect_true(any(o$ot_second == 1, na.rm = TRUE))
  expect_true(any(o$cp_model == "air_yards", na.rm = TRUE))
})

test_that("the forced two-point rule and possession order match sdv-py", {
  o <- read_ot_oracle()
  expect_identical(as.integer(.ot_forced_two_point(o$season, o$period)), o$ot_forced)
  got <- .ot_second_possession(r_ot_state(o))
  expect_identical(as.integer(got), o$ot_second)
  expect_identical(.ot_forced_two_point(c(2018, 2020, 2021, 2021, NA), c(6, 7, 6, 5, 7)),
                   c(FALSE, TRUE, TRUE, FALSE, FALSE))
})

test_that("a factor season or period is read by label, not by level code", {
  o <- read_ot_oracle()
  # Overtime rows only, so that level codes (1, 2, ...) differ from the labels.
  num <- r_ot_state(o)[o$period >= 5, ]
  fct <- num
  fct$period <- factor(fct$period)
  expect_true(any(.ot_second_possession(num), na.rm = TRUE))
  expect_identical(.ot_second_possession(fct), .ot_second_possession(num))
  expect_identical(.ot_forced_two_point(factor(o$season), factor(o$period)),
                   .ot_forced_two_point(o$season, o$period))
})

test_that("overtime-adjusted naive WP (wp_before) matches sdv-py adjust_wp", {
  skip_if_no_ot_models()
  o <- read_ot_oracle()
  st <- r_ot_state(o)
  raw <- .wp_predict(.cfb_model("wp_model"), st, adjust = FALSE)
  expect_close_ot(raw, o$wp_naive_raw, "naive WP raw")
  got <- .wp_predict(.cfb_model("wp_model"), st, second = .ot_second_possession(st))
  expect_close_ot(got, o$wp_naive_adj, "naive WP adjusted")
  ot <- o$period >= 5
  # the stage moves overtime a long way, regulation a little
  expect_gt(max(abs(got - raw)[ot]), 0.05)
})

test_that("overtime-adjusted spread WP (vegas_wp) matches sdv-py adjust_wp", {
  skip_if_no_ot_models()
  o <- read_ot_oracle()
  got <- .pbp_add_vegas_wp(r_ot_state(o))$vegas_wp
  expect_close_ot(got, o$wp_spread_adj, "spread WP adjusted")
})

test_that("cp, cp_model and cp_game_state match sdv-py, air-yards arm included", {
  skip_if_no_ot_models()
  skip_if(is.null(.cfb_cp_model()) || is.null(.cfb_cp_air_yards_model()),
          "CP boosters unavailable")
  o <- read_ot_oracle()
  st <- r_ot_state(o)
  # cfbfastR derives passing_down itself; sdv-py's own column must agree
  expect_identical(as.integer(.cp_passing_down(st)), o$passing_down)
  got <- .pbp_add_cp_cpoe(st)
  expect_identical(got$cp_model, o$cp_model)
  pass <- o$pass == 1
  expect_close_ot(got$cp[pass], o$cp[pass], "cp")
  expect_close_ot(got$cp_game_state[pass], o$cp_game_state[pass], "cp_game_state")
  expect_true(all(is.na(got$cp[!pass])))
})

test_that("a card naming a feature the WP frame lacks leaves WP at the booster's value", {
  m <- list(features = "not_a_feature", q_model = NULL)
  local_mocked_bindings(.cfb_wp_ot_model = function() m)
  x <- cbind(period = 1, adj_TimeSecsRem = 1000)
  expect_identical(.cfb_adjust_wp(0.4, x), 0.4)
})
