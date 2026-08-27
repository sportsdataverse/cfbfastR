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

### ------------------------------------------------------------------ ###
### Punt, field goal, and the combiner (#140).
###
### The three sign conventions pinned below were each found INVERTED in
### sportsdataverse-py while porting. None of them crashes; each one produces a
### confident, wrong recommendation in exactly the situations a fourth-down bot
### exists to answer. cfb4th's `decision_functions.R` is the reference.
### ------------------------------------------------------------------ ###

mk_late <- function(distance = 10, yards_to_goal = 50, diff = 0, period = 4,
                    adj = 60, pos_to = 0, def_to = 0) {
  data.frame(
    period = period, pos_team_receives_2H_kickoff = 0,
    pos_team_timeouts_rem_before = pos_to, def_pos_team_timeouts_rem_before = def_to,
    pos_score_diff_start = diff, pos_team_spread = 0, is_home = 1,
    down = 4, distance = distance, yards_to_goal = yards_to_goal,
    TimeSecsRem = adj, adj_TimeSecsRem = adj,
    posteam_total = 27.5, season = 2021
  )
}

test_that(".fd_kneel_clamp gates on the fourth quarter only when asked to", {
  wp <- rep(0.5, 3)
  lead <- rep(TRUE, 3)
  adj <- rep(100, 3)
  def_to <- rep(0, 3)
  period <- c(2, 4, NA)
  # The go-for-it branch of cfb4th has no period condition; end_game_fn does.
  expect_equal(.fd_kneel_clamp(wp, lead, adj, def_to, 0), c(0, 0, 0))
  expect_equal(.fd_kneel_clamp(wp, lead, adj, def_to, 0, period = period),
               c(0.5, 0, 0.5))
})

test_that(".fourth_down_decision_rows keeps only scoreable fourth downs", {
  df <- data.frame(
    down = c(4, 3, 4, 4, 4, 4),
    yards_to_goal = c(50, 50, 0, 50, 50, 50),
    distance = c(5, 5, 5, 5, 5, 5),
    TimeSecsRem = c(600, 600, 600, 600, 600, 600),
    adj_TimeSecsRem = c(600, 600, 600, 20, 600, 600),
    period = c(2, 2, 2, 2, 5, 4)
  )
  # kept: a real 4th down; dropped: 3rd down, a zero yardline, the dead final
  # 30 seconds of a half, and overtime.
  expect_equal(.fourth_down_decision_rows(df), c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE))
})

test_that(".fd_punt_wp and .fd_fg_wp degrade rather than raise", {
  expect_equal(length(.fd_punt_wp(mk_late()[0, , drop = FALSE])), 0L)
  expect_equal(nrow(.fd_fg_wp(mk_late()[0, , drop = FALSE])), 0L)
  # No season means no valid era one-hot, and .fg_make_prob() aborts rather than
  # zeroing it. The surface must catch that, not propagate it.
  st <- mk_late(); st$season <- NA_real_
  expect_true(all(is.na(.fd_fg_wp(st)$fg_wp)))
})

test_that(".pbp_add_fourth_down adds its columns even with nothing to score", {
  df <- data.frame(down = 4, distance = 5, yards_to_goal = 50, period = 2,
                   TimeSecsRem = 600, adj_TimeSecsRem = 2400)
  out <- .pbp_add_fourth_down(df)
  # No pre-game line -> no state -> NA columns, and crucially still columns.
  expect_true(all(c(.FD_NUMERIC_COLS, "fourth_down_recommendation") %in% names(out)))
  expect_true(all(is.na(out$go_wp)))
  expect_identical(nrow(.pbp_add_fourth_down(df[0, , drop = FALSE])), 0L)
})

test_that("the punt distribution covers 31-99 and sums to one per yardline", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("arrow")
  pd <- .cfb_punt_distribution()
  skip_if(is.null(pd), "punt_distribution unavailable")
  expect_setequal(names(pd), c("yards_to_goal", "yards_to_goal_end", "pct"))
  expect_equal(range(pd$yards_to_goal), c(31, 99))
  # Every yardline's distribution is a probability distribution; if it were not,
  # punt_wp would silently stop being a win probability.
  by_line <- tapply(pd$pct, pd$yards_to_goal, sum)
  expect_true(all(abs(by_line - 1) < 1e-9))
})

test_that("punting has no distribution inside the 31, and cfb4th leaves it NA", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("arrow")
  skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_punt_distribution()), "punt_distribution unavailable")
  skip_if(is.null(.cfb_wp_spread_model()), "wp_spread unavailable")
  st <- do.call(rbind, lapply(c(10, 25, 30, 31, 50), function(y) {
    mk_late(yards_to_goal = y, period = 2, adj = 1800)
  }))
  p <- .fd_punt_wp(st)
  expect_true(all(is.na(p[1:3])))          # inside the 31: no table, no number
  expect_true(all(!is.na(p[4:5])))
  expect_true(all(p[4:5] >= 0 & p[4:5] <= 1))
})

test_that("a punt while trailing late against a team that can kneel it out loses", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("arrow")
  skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_punt_distribution()), "punt_distribution unavailable")
  skip_if(is.null(.cfb_wp_spread_model()), "wp_spread unavailable")
  # cfb4th reads end_game_fn off the RESULTING frame: the RECEIVING team leads
  # and the PUNTING team is out of timeouts. sdv-py reads the punting team's own
  # differential instead, which pins the WP to zero for the team that is AHEAD.
  down_3 <- .fd_punt_wp(mk_late(diff = -3, pos_to = 0))
  up_3 <- .fd_punt_wp(mk_late(diff = 3, pos_to = 0))
  expect_lt(down_3, 0.01)     # you punt, they kneel, you lose
  expect_gt(up_3, 0.5)        # you punt while ahead -- not the same situation
  # With timeouts left it is a game again, in any quarter.
  expect_gt(.fd_punt_wp(mk_late(diff = -3, pos_to = 3)), down_3)
  expect_gt(.fd_punt_wp(mk_late(diff = -3, pos_to = 0, period = 2, adj = 1860)),
            down_3)
})

test_that("turning it over on downs while LEADING is not an automatic loss", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_fd_model()), "bundled fd_model unavailable")
  skip_if(is.null(.cfb_wp_spread_model()), "wp_spread unavailable")
  # The clamp condition is read off the post-turnover frame, where the score
  # differential has already been negated. Reading it as "the offence trails"
  # inverts it and pins a LEADING team's failed-conversion WP to zero.
  #
  # The timeouts here are load-bearing and easy to get backwards. After a
  # turnover `new_def_to` is the OFFENCE'S pre-play count, so firing the clamp
  # needs `pos_to = 0` -- not `def_to = 0`, which leaves `new_def_to == 3` and
  # no threshold applies at all. Configured that way this test passes on the
  # model's own gradient with EITHER sign (0.776 vs 0.037), which is no gate.
  lead <- .fd_go_wp(mk_late(distance = 1, diff = 3, pos_to = 0, def_to = 3))
  trail <- .fd_go_wp(mk_late(distance = 1, diff = -3, pos_to = 0, def_to = 3))
  # Exactly zero is the clamp's signature -- the model alone never returns it.
  expect_identical(trail$wp_fail, 0)
  # And the leading team must be left alone entirely.
  expect_gt(lead$wp_fail, 0.5)
})

test_that("field-goal probability carries cfb4th's two policy clamps", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_fg_model_or_null()), "fg model unavailable")
  st <- do.call(rbind, lapply(c(2, 20, 33, 34, 35, 42, 43, 60), function(y) {
    mk_late(yards_to_goal = y, period = 2, adj = 1800)
  }))
  p <- .fd_fg_wp(st)$fg_make_prob
  expect_true(all(p >= 0 & p <= 1))
  # Decreasing with distance, but only to a tolerance: the bundled model is a
  # tree ensemble and its step function has a ~0.004 bump between 33 and 34
  # yards to goal. That is the model, not the port -- a real inversion would be
  # an order of magnitude bigger.
  expect_true(all(diff(p) <= 0.01))
  expect_gt(p[1], 0.95)                        # a 19-yard chip shot
  expect_gt(p[6], 0)                           # 42 is the last kick allowed
  expect_equal(p[7], 0)                        # 43+ is zeroed outright
  expect_equal(p[8], 0)
  # The 0.9x shrink at 35 is a step, not part of the fitted curve. The fitted
  # curve loses about a point per yard through this band; the clamp takes a
  # tenth of the probability at once.
  expect_gt(p[4] - p[5], 0.05)
})

test_that("a made field goal is worth more than a missed one", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_fg_model_or_null()), "fg model unavailable")
  skip_if(is.null(.cfb_wp_spread_model()), "wp_spread unavailable")
  st <- do.call(rbind, lapply(c(5, 15, 25, 35), function(y) {
    mk_late(yards_to_goal = y, period = 2, adj = 1800)
  }))
  f <- .fd_fg_wp(st)
  expect_true(all(f$make_fg_wp > f$miss_fg_wp))
  # And the blend has to sit between the two things it blends.
  expect_true(all(f$fg_wp >= f$miss_fg_wp & f$fg_wp <= f$make_fg_wp))
  # The make state does not depend on where the kick came from -- it is always a
  # kickoff from three points up.
  expect_equal(length(unique(round(f$make_fg_wp, 10))), 1L)
})

test_that("the recommendation is the argmax and the diffs are measured from it", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("xgboost")
  skip_if_not_installed("arrow")
  skip_if(is.null(.cfb_fd_model()), "bundled fd_model unavailable")
  skip_if(is.null(.cfb_wp_spread_model()), "wp_spread unavailable")
  # Mid-second-quarter, tied, full timeouts -- the plain situations the
  # conventional chart and the bot agree on.
  situation <- function(distance, yards_to_goal) {
    mk_late(distance = distance, yards_to_goal = yards_to_goal, period = 2,
            adj = 1800, pos_to = 3, def_to = 3)
  }
  st <- do.call(rbind, list(
    situation(1, 5), situation(1, 40), situation(10, 60), situation(8, 20)
  ))
  o <- .fd_probs(st)
  expect_true(all(o$fourth_down_recommendation %in% c("go", "field_goal", "punt")))
  opts <- cbind(go = o$go_wp, field_goal = o$fg_wp, punt = o$punt_wp)
  chosen <- opts[cbind(seq_len(nrow(o)), match(o$fourth_down_recommendation,
                                               colnames(opts)))]
  expect_equal(chosen, pmax(o$go_wp, o$fg_wp, ifelse(is.na(o$punt_wp), -Inf, o$punt_wp)))
  # The recommended option's own diff is zero; nothing beats it.
  diffs <- cbind(o$go_wp_diff, o$fg_wp_diff, o$punt_wp_diff)
  expect_true(all(diffs <= 1e-12, na.rm = TRUE))
  expect_true(all(apply(diffs, 1, function(r) any(abs(r) < 1e-12, na.rm = TRUE))))
  # go_boost is the headline number and must agree in sign with the choice.
  expect_true(all((o$go_boost > 0) == (o$fourth_down_recommendation == "go")))

  # Football reality: a yard to gain near the goal line is a go, and 4th and 10
  # from your own 40 is a punt.
  expect_equal(o$fourth_down_recommendation[1], "go")
  expect_equal(o$fourth_down_recommendation[3], "punt")
  expect_equal(o$fourth_down_recommendation[4], "field_goal")
})

test_that("the decision columns never overwrite a column the pbp frame ships", {
  # `fg_make_prob` collides: the EPA path already publishes one, for the kick
  # that was actually attempted. Initialising a same-named decision column nulls
  # it on every play that is not a fourth down -- a shipped column quietly
  # emptied, with nothing raised. Any future decision column has to clear the
  # same check.
  emitted <- c(.FD_NUMERIC_COLS, "fourth_down_recommendation")
  expect_equal(intersect(emitted, .pbp_output_order), character(0))
})

test_that("a goal-line gain is a touchdown even when distance exceeds it", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_fd_model()), "bundled fd_model unavailable")
  skip_if(is.null(.cfb_wp_spread_model()), "wp_spread unavailable")
  # CFBD ships ~0.12% of fourth downs with distance > yards_to_goal (32 rows in
  # 2023, 18 in 2015). Comparing the capped gain against the raw distance marks
  # every one of those outcomes -- the touchdown included -- a turnover, so
  # first_down_prob reads exactly 0 and the state becomes a first down at the
  # offence's OWN goal line. Nothing raises.
  bad <- .fd_go_wp(mk_late(distance = 8, yards_to_goal = 3, period = 2, adj = 1800))
  # Not equal to the 4th-and-3 case -- `distance` is itself a feature of the
  # gain model, so the distribution legitimately differs. What must hold is that
  # the success bucket is reachable at all: before the clamp it was empty, so
  # first_down_prob was exactly 0 and wp_succeed exactly NA.
  expect_gt(bad$first_down_prob, 0)
  expect_false(is.na(bad$wp_succeed))
  # And the scoring outcome has to beat the failing one, which cannot be true
  # when every outcome is bucketed as a failure.
  expect_gt(bad$wp_succeed, bad$wp_fail)
})

test_that("a punt return touchdown clamps toward a win, not a loss", {
  # Possession never changes on those rows -- the ball comes straight back --
  # so the win probability there is already the punting team's and a kneel-out
  # is a WIN for it. cfb4th clamps every row to zero, which pins a punting team
  # still leading after conceding the score to a certain loss.
  #
  # Asserted through the clamp helper: return-TD rows carry under 0.2% of the
  # punt distribution's mass, so an assertion on punt_wp would pass either way.
  wp <- 0.5
  lead <- TRUE
  expect_equal(.fd_kneel_clamp(wp, lead, 60, 0, 0, period = 4), 0)
  expect_equal(.fd_kneel_clamp(wp, lead, 60, 0, 1, period = 4), 1)
  # Not leading is nobody's kneel-out, whichever value is passed.
  expect_equal(.fd_kneel_clamp(wp, FALSE, 60, 0, 1, period = 4), 0.5)
})
