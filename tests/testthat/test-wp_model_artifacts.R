### Gates for the shared `cfb_model_artifacts` WP model (issue #138 P2).
###
### WP has no class-order hazard (single probability out), so the risk here is
### the FEATURE contract instead: twelve inputs in a fixed order, one of which
### (`is_home`) cfbfastR does not carry and must derive. A silently wrong
### is_home, or a column order drift, yields win probabilities that still look
### like probabilities.

test_that(".WP_NAIVE_FEATURES matches the bundle's declared contract", {
  expect_length(.WP_NAIVE_FEATURES, 12L)
  # Order is the booster's own; drift here scores the right numbers into the
  # wrong slots without erroring.
  expect_identical(.WP_NAIVE_FEATURES[1], "pos_team_receives_2H_kickoff")
  expect_identical(.WP_NAIVE_FEATURES[12], "period")
  expect_true("is_home" %in% .WP_NAIVE_FEATURES)
  expect_false("spread_time" %in% .WP_NAIVE_FEATURES)  # that is wp_spread
})

test_that(".wp_is_home derives possession-is-home from team names", {
  d <- data.frame(pos_team = c("Alabama", "Georgia", "Alabama"),
                  home = c("Alabama", "Alabama", "Georgia"))
  expect_equal(.wp_is_home(d), c(1, 0, 0))
})

test_that(".wp_is_home treats unresolved teams as not-home rather than NA", {
  # The booster cannot take a missing value, and a neutral-site or unknown
  # possession team must not fabricate home advantage.
  d <- data.frame(pos_team = c(NA, "Ohio State"), home = c("Michigan", NA))
  expect_equal(.wp_is_home(d), c(0, 0))
  expect_false(anyNA(.wp_is_home(d)))
})

test_that(".wp_is_home prefers an existing is_home column", {
  d <- data.frame(is_home = c(TRUE, FALSE), pos_team = "A", home = "B")
  expect_equal(.wp_is_home(d), c(1, 0))
})

test_that(".wp_feature_matrix builds all twelve features in contract order", {
  nd <- data.frame(
    pos_team_receives_2H_kickoff = c(1, 0),
    TimeSecsRem = c(1800, 300),
    adj_TimeSecsRem = c(1800, 300),
    ExpScoreDiff_Time_Ratio = c(0.001, -0.02),
    pos_score_diff_start = c(0, -7),
    down = factor(c(1, 3), levels = c("1", "2", "3", "4")),
    distance = c(10, 8),
    yards_to_goal = c(75, 40),
    pos_team_timeouts_rem_before = c(3, 2),
    def_pos_team_timeouts_rem_before = c(3, 1),
    period = c(1, 4),
    pos_team = c("Alabama", "Georgia"),
    home = c("Alabama", "Alabama")
  )
  m <- .wp_feature_matrix(nd)
  expect_identical(colnames(m), .WP_NAIVE_FEATURES)
  expect_equal(nrow(m), 2L)
  expect_equal(unname(m[, "is_home"]), c(1, 0))
  expect_equal(unname(m[, "down"]), c(1, 3))   # VALUE, not factor code
  expect_false(anyNA(m))
})

test_that(".wp_feature_matrix reads down values, not factor level codes", {
  base <- data.frame(
    pos_team_receives_2H_kickoff = 1, TimeSecsRem = 900, adj_TimeSecsRem = 900,
    ExpScoreDiff_Time_Ratio = 0, pos_score_diff_start = 0,
    distance = 10, yards_to_goal = 60, pos_team_timeouts_rem_before = 3,
    def_pos_team_timeouts_rem_before = 3, period = 2, is_home = 1
  )
  a <- cbind(base, down = factor("1", levels = c("1", "2", "3", "4")))
  b <- cbind(base, down = factor("1", levels = c("4", "3", "2", "1")))
  expect_equal(.wp_feature_matrix(a)[, "down"], .wp_feature_matrix(b)[, "down"])
  expect_equal(unname(.wp_feature_matrix(b)[, "down"]), 1)
})

test_that(".wp_feature_matrix refuses a frame missing model columns", {
  nd <- data.frame(TimeSecsRem = 900, period = 1, is_home = 1)
  expect_error(.wp_feature_matrix(nd), "adj_TimeSecsRem|missing")
})

test_that("the published manifest agrees with the in-package WP contract", {
  skip_if_offline()
  man <- .cfb_model_manifest()
  skip_if(is.null(man), "cfb_model_artifacts MANIFEST.json unavailable")
  expect_identical(unlist(man$assets$wp_naive.ubj$features), .WP_NAIVE_FEATURES)
  # wp_spread is the same contract plus spread_time in slot 2 -- pinned here so
  # P2's spread work starts from a verified assumption.
  spread <- unlist(man$assets$wp_spread.ubj$features)
  expect_length(spread, 13L)
  expect_identical(spread[2], "spread_time")
  expect_identical(spread[-2], .WP_NAIVE_FEATURES)
})

test_that(".wp_predict returns calibrated probabilities with sane ordering", {
  skip_if_offline()
  skip_if_not_installed("xgboost")
  wp_model <- load_wp_model()
  skip_if(!inherits(wp_model, "xgb.Booster"), "bundled WP model unavailable")

  # Same game state, three score margins. WP must rise with the lead.
  mk <- function(diff) data.frame(
    pos_team_receives_2H_kickoff = 0, TimeSecsRem = 600, adj_TimeSecsRem = 600,
    ExpScoreDiff_Time_Ratio = diff / 601, pos_score_diff_start = diff,
    down = 1, distance = 10, yards_to_goal = 65,
    pos_team_timeouts_rem_before = 3, def_pos_team_timeouts_rem_before = 3,
    period = 4, is_home = 1
  )
  wp <- vapply(c(-14, 0, 14), function(d) .wp_predict(wp_model, mk(d)), numeric(1))

  expect_length(wp, 3L)
  expect_true(all(wp >= 0 & wp <= 1))
  expect_true(all(diff(wp) > 0))   # monotone in score margin
  expect_lt(wp[1], 0.5)            # down 14 late
  expect_gt(wp[3], 0.5)            # up 14 late

  # Batch equals row-by-row: guards against any reshape/recycling error.
  batch <- .wp_predict(wp_model, do.call(rbind, lapply(c(-14, 0, 14), mk)))
  expect_equal(batch, wp, tolerance = 1e-12)
})
