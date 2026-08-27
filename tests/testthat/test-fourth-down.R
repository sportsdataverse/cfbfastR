### Gates for the fourth-down GO branch (#140).
###
### NOTE ON VALIDATION: this branch has no cross-language oracle. sdv-py's
### get_go_wp() -- the implementation that owns the model -- raises
### AttributeError unconditionally on pandas 3 ("'float' object has no
### attribute 'to_numpy'"), so it cannot be scored against. These gates are
### therefore behavioural and anchored to known football reality: conversion
### rates by distance, and the structural relationships any probability-weighted
### average must satisfy.

mk_fd <- function(distance, yards_to_goal = 50, diff = 0, period = 2,
                  tsr = 900, def_to = 3, spread = 0) {
  data.frame(
    period = period, pos_team_receives_2H_kickoff = 0,
    pos_team_timeouts_rem_before = 3, def_pos_team_timeouts_rem_before = def_to,
    pos_score_diff_start = diff, pos_team_spread = spread, is_home = 1,
    down = 4, distance = distance, yards_to_goal = yards_to_goal,
    TimeSecsRem = tsr, adj_TimeSecsRem = tsr + 1800,
    posteam_total = 27.5, season = 2021
  )
}

test_that("class 0 of the fourth-down model is a ten-yard LOSS", {
  # Reading the 76 classes as gains of 0..75 rather than -10..65 would shift
  # every outcome ten yards downfield without erroring.
  expect_equal(.FD_GAIN_OFFSET, -10L)
  expect_equal(.FD_NUM_CLASS, 76L)
  expect_identical(.FD_FEATURES[6:9], c("era0", "era1", "era2", "era3"))
})

test_that("the fourth-down model uses the ONE-HOT era, not the ordinal one", {
  # fd_model and fg_model take era0..era3 (cuts 2006/2013/2020); xpass and
  # two_pt take a single ordinal era (2017 cut). 2018 separates them.
  expect_true(all(c("era0", "era1", "era2", "era3") %in% .FD_FEATURES))
  expect_equal(unname(.cfb_era_onehot(2018, 1)[1, ]), c(0, 0, 1, 0))
})

test_that(".fd_kneel_clamp pins only a leading team against a timeout-less defence", {
  wp <- rep(0.5, 4)
  lead <- c(TRUE, TRUE, FALSE, TRUE)
  adj <- c(100, 300, 100, 100)          # row 2 is too early to clamp
  def_to <- c(0, 0, 0, 2)               # row 4 needs adj < 40, and 100 is not
  out <- .fd_kneel_clamp(wp, lead, adj, def_to, 1)
  expect_equal(out, c(1, 0.5, 0.5, 0.5))
})

test_that(".fd_go_wp returns an all-NA frame rather than raising on empty input", {
  out <- .fd_go_wp(mk_fd(5)[0, , drop = FALSE])
  expect_equal(nrow(out), 0L)
  expect_true(all(c("go_wp", "first_down_prob", "wp_succeed", "wp_fail") %in% names(out)))
})

test_that(".fd_go_wp degrades when the season is unavailable", {
  st <- mk_fd(5); st$season <- NA_real_
  out <- .fd_go_wp(st)
  expect_true(is.na(out$go_wp))
})

test_that("conversion probability tracks distance the way college football does", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_fd_model()), "bundled fd_model unavailable")
  skip_if(is.null(.cfb_wp_spread_model()), "wp_spread unavailable")

  st <- do.call(rbind, lapply(c(1, 2, 3, 5, 7, 10, 15), mk_fd))
  o <- .fd_go_wp(st)

  expect_true(all(o$first_down_prob >= 0 & o$first_down_prob <= 1))
  # Strictly harder as the distance grows -- a flat or inverted curve means the
  # 76-class distribution is being read wrong.
  expect_true(all(diff(o$first_down_prob) < 0))
  # Anchored to reality: 4th & 1 converts around 70-75%, 4th & 10 around 30%.
  expect_gt(o$first_down_prob[1], 0.65)
  expect_lt(o$first_down_prob[1], 0.85)
  expect_gt(o$first_down_prob[6], 0.22)
  expect_lt(o$first_down_prob[6], 0.40)
})

test_that("go_wp is a probability-weighted average of its two outcomes", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_fd_model()), "bundled fd_model unavailable")
  skip_if(is.null(.cfb_wp_spread_model()), "wp_spread unavailable")

  st <- do.call(rbind, lapply(c(1, 3, 7, 12), mk_fd))
  o <- .fd_go_wp(st)

  expect_true(all(o$go_wp >= 0 & o$go_wp <= 1))
  # Converting must be worth more than failing, on every row.
  expect_true(all(o$wp_succeed > o$wp_fail))
  # And a weighted average has to sit between the things it averages.
  expect_true(all(o$go_wp >= o$wp_fail & o$go_wp <= o$wp_succeed))
})
