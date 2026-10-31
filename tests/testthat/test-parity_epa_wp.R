### Parity oracle: sdv-py EP / EPA / WP scoring on real games -> cfbfastR's scoring stage
###
### fixtures/parity/epa_wp_oracle.csv.gz (provenance in fixtures/parity/README.md) holds,
### per play of six real games, the start and end state sdv-py scored its EP and WP
### boosters on and what it got. This replays the functions cfbfastR's engine scores
### with -- .state_ep() (EP for a state, via .ep_predict()), .wp_predict() (naive
### `wp_before`) and .pbp_add_vegas_wp() (`vegas_wp`) -- on the same states. Both
### languages load the same booster bytes from the cfb_model_artifacts bundle, so a
### disagreement is a feature-derivation divergence, the class of the C-NF-2
### 2H-kickoff skew: the frame below carries the TRUE published flag, as cfbfastR's
### engine computes it, and only the shim makes R feed the boosters what they were
### trained on.
###
### Column mapping (sdv-py -> cfbfastR):
###   ep_start_raw    -> ep_before  (sdv-py's EP model on the start state)
###   ep_end_raw      -> ep_after   (on the end state)
###   EP_start, EP_end, EPA -> ep_before, ep_after, EPA where sdv-py's pipeline
###                    rules leave the model values as they are
###   wp_naive_raw    -> wp_before  (sdv-py publishes it as wp_before_naive)
###   wp_spread_raw   -> vegas_wp   (sdv-py publishes it as wp_before)
###
### Tolerance 1e-5 (absolute): xgboost scores in float32 (~6e-8 relative), and EP
### sums seven float32 class probabilities weighted by up to 7 points, so honest
### agreement sits near 1e-6; 1e-5 leaves headroom without hiding a real gap (the
### 2H skew moves WP by up to ~0.1).
###
### Allow-list -- what is deliberately NOT compared, and why:
###   * sdv-py's published wp_before_naive / wp_before: they include sdv-py's
###     overtime stage (cfb_wp_overtime.adjust_wp), which cfbfastR has not ported;
###     the oracle's *_raw columns are the boosters' output through sdv-py's own
###     scoring path without that stage.
###   * published EP_start / EP_end / EPA on rows where sdv-py's pipeline rewrote
###     them (possession flips negate EP_end, scores pin it to the try's value,
###     ...): those are pipeline rules, not model scoring, and cfbfastR's engine
###     cannot be replayed offline on these games (it reads ESPN core-v2 live).
###     The model values on those rows are still compared, via the *_raw columns.

oracle_path <- testthat::test_path("fixtures", "parity", "epa_wp_oracle.csv.gz")
tol <- 1e-5

skip_if_no_models <- function() {
  testthat::skip_on_cran()
  testthat::skip_if_not(file.exists(oracle_path), "EP/WP parity oracle not generated")
  testthat::skip_if_not_installed("xgboost")
  # The bundle download failed (offline, GitHub down): the loaders fell back to
  # the retired GAMs, or found nothing, and there is no booster to compare.
  testthat::skip_if_not(inherits(get("wp_model", asNamespace("cfbfastR")), "xgb.Booster"),
                        "WP booster unavailable (bundle not fetched)")
  testthat::skip_if_not(inherits(get("ep_model", asNamespace("cfbfastR")), "xgb.Booster"),
                        "EP booster unavailable (bundle not fetched)")
  testthat::skip_if(is.null(.cfb_wp_spread_model()), "spread WP booster unavailable")
}

read_oracle <- function() {
  o <- utils::read.csv(oracle_path, colClasses = c(game_id = "character",
                       id_play = "character", home_id = "character",
                       pos_team_id = "character"))
  o$is_home <- as.integer(as.logical(o$is_home))
  o$pos_team_receives_2H_kickoff <- as.integer(as.logical(o$pos_team_receives_2H_kickoff))
  o
}

# The start state under cfbfastR's names, as its engine hands it to the scorers:
# team ids for pos_team/home (is_home is derived, never read), the TRUE 2H flag,
# and the home line in CFBD's sign convention (negative = home favoured).
r_start <- function(o) {
  data.frame(
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
    stringsAsFactors = FALSE
  )
}

expect_close <- function(got, want, what) {
  d <- abs(as.numeric(got) - as.numeric(want))
  testthat::expect_false(anyNA(d), info = paste(what, "has NA"))
  testthat::expect_lt(max(d, na.rm = TRUE), tol, label = paste(what, "max |R - sdv-py|"))
}

test_that("the oracle covers what it claims", {
  skip_if_no_models()
  o <- read_oracle()
  expect_equal(length(unique(o$game_id)), 6L)
  expect_false(anyDuplicated(paste(o$game_id, o$id_play)) > 0)
  # cfbfastR derives is_home from the ids exactly as sdv-py does
  expect_equal(.wp_is_home(r_start(o)), as.numeric(o$is_home))
  # the rows that decide the shim: the true flag is not 1 - is_home
  expect_gt(sum(o$pos_team_receives_2H_kickoff != 1 - o$is_home), 300L)
})

test_that("naive WP (R wp_before) matches sdv-py on real games", {
  skip_if_no_models()
  o <- read_oracle()
  got <- .wp_predict(get("wp_model", asNamespace("cfbfastR")), r_start(o))
  expect_close(got, o$wp_naive_raw, "wp_before vs sdv-py wp_before_naive (raw)")
})

test_that("calculate_win_probability() and the decision state score the trained flag too", {
  skip_if_no_models()
  o <- read_oracle()
  df <- r_start(o)
  df$spread <- NULL
  df$is_home <- o$is_home
  got <- calculate_win_probability(df, season = 2024)
  expect_close(got$wp, o$wp_naive_raw, "calculate_win_probability() vs sdv-py (raw)")
  # the caller's flag is returned untouched; only the booster input changes
  expect_identical(got$pos_team_receives_2H_kickoff, df$pos_team_receives_2H_kickoff)

  st <- .cfb_state_from_pbp(r_start(o))
  expect_equal(st$pos_team_receives_2H_kickoff, 1 - st$is_home)
})

test_that("spread WP (R vegas_wp) matches sdv-py on real games", {
  skip_if_no_models()
  o <- read_oracle()
  testthat::expect_true(all(as.logical(o$game_spread_available)))
  got <- .pbp_add_vegas_wp(r_start(o))$vegas_wp
  expect_close(got, o$wp_spread_raw, "vegas_wp vs sdv-py wp_before (raw)")
})

test_that("EP before / after and EPA match sdv-py on real games", {
  skip_if_no_models()
  o <- read_oracle()
  ep_before <- .state_ep(data.frame(
    TimeSecsRem = o$TimeSecsRem, yards_to_goal = o$yards_to_goal,
    distance = o$distance, down = o$ep_down,
    pos_score_diff_start = o$pos_score_diff_start
  ))
  ep_after <- .state_ep(data.frame(
    TimeSecsRem = o$end_TimeSecsRem, yards_to_goal = o$end_yards_to_goal,
    distance = o$end_distance, down = o$ep_end_down,
    pos_score_diff_start = o$end_pos_score_diff
  ))
  expect_close(ep_before, o$ep_start_raw, "ep_before vs sdv-py EP model on the start state")
  expect_close(ep_after, o$ep_end_raw, "ep_after vs sdv-py EP model on the end state")

  # sdv-py's published EP_start / EP_end / EPA are the model values after its
  # possession-flip and scoring rules. Where those rules leave a play alone, the
  # published values ARE the model values and R must reproduce them as published.
  # The EPA term drops the plays whose EPA sdv-py rewrites even though both EPs
  # stand (1 of 1,014 here: 400547719104939901, EPA 0.015 off EP_end - EP_start).
  model_rows <- !is.na(o$EPA) &
    abs(o$EP_start - o$ep_start_raw) < tol & abs(o$EP_end - o$ep_end_raw) < tol &
    abs(o$EPA - (o$EP_end - o$EP_start)) < tol
  expect_gt(sum(model_rows), 750L)
  expect_close(ep_before[model_rows], o$EP_start[model_rows], "ep_before vs sdv-py EP_start")
  expect_close(ep_after[model_rows], o$EP_end[model_rows], "ep_after vs sdv-py EP_end")
  expect_close((ep_after - ep_before)[model_rows], o$EPA[model_rows], "EPA vs sdv-py EPA")
})
