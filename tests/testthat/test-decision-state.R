### Gates for the shared decision-surface state machinery (#140).
###
### Both sign conventions in here have a documented history of being inverted
### upstream, and neither failure crashes -- they produce confident, wrong
### recommendations. So both are pinned directly.

mk_state <- function(period = 1, recv = 0, pos_to = 3, def_to = 2,
                     diff = 0, spread = 7, is_home = 1, tsr = 1800) {
  data.frame(
    period = period, pos_team_receives_2H_kickoff = recv,
    pos_team_timeouts_rem_before = pos_to, def_pos_team_timeouts_rem_before = def_to,
    pos_score_diff_start = diff, pos_team_spread = spread, is_home = is_home,
    down = 2, distance = 7, yards_to_goal = 40,
    TimeSecsRem = tsr, adj_TimeSecsRem = tsr
  )
}

test_that(".flip_team_state hands the ball over correctly", {
  st <- mk_state(diff = 10, spread = 7, is_home = 1, pos_to = 3, def_to = 1)
  f <- .flip_team_state(st)
  expect_equal(f$pos_score_diff_start, -10)   # a 10-point lead is a 10-point deficit
  expect_equal(f$pos_team_spread, -7)         # the favourite's opponent is the underdog
  expect_equal(f$is_home, 0)
  expect_equal(f$pos_team_timeouts_rem_before, 1)      # swapped
  expect_equal(f$def_pos_team_timeouts_rem_before, 3)
  expect_equal(f$down, 1)
  expect_equal(f$distance, 10)
  expect_equal(f$TimeSecsRem, 1794)           # 6s runoff
  expect_equal(f$adj_TimeSecsRem, 1794)
  # yards_to_goal is the caller's business, so the flip leaves it alone.
  expect_equal(f$yards_to_goal, st$yards_to_goal)
})

test_that("the 2H-kickoff indicator toggles in the first half only", {
  expect_equal(.flip_team_state(mk_state(period = 1, recv = 0))$pos_team_receives_2H_kickoff, 1)
  expect_equal(.flip_team_state(mk_state(period = 2, recv = 1))$pos_team_receives_2H_kickoff, 0)
  # In the second half the kickoff has already happened -- toggling would
  # invent one.
  expect_equal(.flip_team_state(mk_state(period = 3, recv = 1))$pos_team_receives_2H_kickoff, 1)
  expect_equal(.flip_team_state(mk_state(period = 4, recv = 0))$pos_team_receives_2H_kickoff, 0)
})

test_that("the clock runoff never goes negative", {
  expect_equal(.flip_team_state(mk_state(tsr = 3))$TimeSecsRem, 0)
  expect_equal(.flip_team_state(mk_state(tsr = 0))$adj_TimeSecsRem, 0)
})

test_that("flipping twice returns to the original state", {
  st <- mk_state(period = 1, recv = 1, diff = -4, spread = 3, is_home = 0)
  twice <- .flip_team_state(.flip_team_state(st))
  for (c in c("pos_score_diff_start", "pos_team_spread", "is_home",
              "pos_team_timeouts_rem_before", "def_pos_team_timeouts_rem_before",
              "pos_team_receives_2H_kickoff")) {
    expect_equal(twice[[c]], st[[c]], info = c)
  }
})

test_that(".cfb_state_from_pbp returns NULL without a usable line or clock", {
  expect_null(.cfb_state_from_pbp(data.frame(pos_team = "A", home = "A")))
})

test_that(".state_wp reads a positive spread as favouring the possessing team", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_wp_spread_model()), "wp_spread unavailable")
  skip_if(is.null(.cfb_ep_model_or_null()), "ep model unavailable")
  # The inverted form (-1 * spread) scores favourites as underdogs. Same state,
  # opposite spreads: the favourite must come out ahead.
  fav <- .state_wp(mk_state(spread = 14, tsr = 3600))
  dog <- .state_wp(mk_state(spread = -14, tsr = 3600))
  expect_true(all(fav >= 0 & fav <= 1))
  expect_gt(fav, dog)
})

test_that("a try's points are added BEFORE the flip, not after", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_wp_spread_model()), "wp_spread unavailable")
  skip_if(is.null(.cfb_ep_model_or_null()), "ep model unavailable")
  # Scoring more points cannot lower your win probability. If the sign were
  # applied post-flip the ordering would invert.
  st <- mk_state(diff = 0, tsr = 900, period = 3)
  wp0 <- .wp_after_pts(st, 0)
  wp1 <- .wp_after_pts(st, 1)
  wp2 <- .wp_after_pts(st, 2)
  expect_true(all(c(wp0, wp1, wp2) >= 0 & c(wp0, wp1, wp2) <= 1))
  expect_gt(wp1, wp0)
  expect_gt(wp2, wp1)
})

test_that("the decision chain matches sportsdataverse-py exactly", {
  # Regression lock. These values were produced by sdv-py's _wp_after_pts on
  # this state and agree to 8 decimals; drift here means the port has diverged
  # from the implementation that owns the models.
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_wp_spread_model()), "wp_spread unavailable")
  skip_if(is.null(.cfb_ep_model_or_null()), "ep model unavailable")

  st <- data.frame(
    period = 3, pos_team_receives_2H_kickoff = 0,
    pos_team_timeouts_rem_before = 3, def_pos_team_timeouts_rem_before = 2,
    pos_score_diff_start = -2, pos_team_spread = 3, is_home = 1,
    down = 1, distance = 10, yards_to_goal = 75,
    TimeSecsRem = 900, adj_TimeSecsRem = 900
  )
  expect_equal(.wp_after_pts(st, 0), 0.41458899, tolerance = 1e-7)
  expect_equal(.wp_after_pts(st, 1), 0.43897551, tolerance = 1e-7)
  expect_equal(.wp_after_pts(st, 2), 0.48901886, tolerance = 1e-7)
  expect_equal(.XP_MAKE_PROB, 0.9851)
})

test_that("the two-point surface degrades rather than raising", {
  df <- data.frame(prob_2pt = NA_real_, pass_td = 1, rush_td = 0,
                   offense_score_play = 1, pos_score_diff_start = 0)
  out <- .pbp_add_two_pt_decision(df, season = 2021)
  expect_true(all(c("two_pt_wp", "xp_wp", "two_pt_wp_diff",
                    "two_pt_recommendation") %in% names(out)))
  expect_true(is.na(out$two_pt_wp))
  expect_true(is.na(out$two_pt_recommendation))
})
