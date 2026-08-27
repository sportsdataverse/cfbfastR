### Gates for the spread-aware WP model (`vegas_wp`, issue #138).
###
### The whole risk here is the SIGN. A flipped spread does not crash and does
### not leave the [0,1] range -- it produces confident, exactly inverted win
### probabilities. Two independent facts pin it, and both are asserted here:
###   1. CFBD `spread` < 0 means the HOME team is favoured (verified over 83
###      games of 2021 wk1 against `formatted_spread`, zero exceptions).
###   2. The booster's WP rises monotonically with `spread_time`, i.e. positive
###      means the team IN POSSESSION is favoured.

test_that(".WP_SPREAD_FEATURES is wp_naive plus spread_time in slot 2", {
  expect_length(.WP_SPREAD_FEATURES, 13L)
  expect_identical(.WP_SPREAD_FEATURES[2], "spread_time")
  expect_identical(.WP_SPREAD_FEATURES[-2], .WP_NAIVE_FEATURES)
})

test_that("pos_team_spread flips sign for the home team, keeps it for the away", {
  # CFBD spread = +19.5 with the AWAY team favoured (the real 2021 Alabama at
  # Miami line, formatted_spread "Alabama -19.5").
  df <- data.frame(
    spread   = c(19.5, 19.5),
    pos_team = c("Alabama", "Miami"),   # away in possession, then home
    home     = c("Miami", "Miami")
  )
  pts <- .wp_pos_team_spread(df)
  expect_equal(pts[1], 19.5)    # favoured away team -> positive
  expect_equal(pts[2], -19.5)   # underdog home team -> negative
})

test_that("pos_team_spread handles a home favourite (negative CFBD spread)", {
  df <- data.frame(spread = c(-7, -7),
                   pos_team = c("Georgia", "Auburn"),
                   home = c("Georgia", "Georgia"))
  pts <- .wp_pos_team_spread(df)
  expect_equal(pts[1], 7)    # favoured home team -> positive
  expect_equal(pts[2], -7)   # underdog away team -> negative
})

test_that(".wp_pos_team_spread returns NULL when there is no usable line", {
  expect_null(.wp_pos_team_spread(data.frame(pos_team = "A", home = "A")))
  expect_null(.wp_pos_team_spread(
    data.frame(spread = NA_real_, pos_team = "A", home = "A")))
})

test_that("spread_time decays the line toward zero as the game elapses", {
  df <- data.frame(spread = c(-14, -14, -14),
                   pos_team = "A", home = "A",
                   adj_TimeSecsRem = c(3600, 1800, 0))
  st <- .wp_spread_time(df)
  expect_equal(st[1], 14)                    # kickoff: undecayed
  expect_true(abs(st[2]) < abs(st[1]))       # halfway: decayed
  expect_true(abs(st[3]) < abs(st[2]))       # final gun: decayed further
  expect_true(all(sign(st) == 1))            # decay never flips the sign
  expect_equal(st[3], 14 * exp(-4))
})

test_that("spread_time clamps elapsed share at zero", {
  # An overtime clock can exceed regulation; the share must not go negative and
  # amplify the line instead of decaying it.
  df <- data.frame(spread = -10, pos_team = "A", home = "A",
                   adj_TimeSecsRem = 4200)
  expect_equal(.wp_spread_time(df), 10)
})

test_that(".pbp_add_vegas_wp adds an NA column rather than raising", {
  df <- data.frame(down = 1, distance = 10)   # no spread, no inputs
  out <- .pbp_add_vegas_wp(df)
  expect_true("vegas_wp" %in% names(out))
  expect_true(is.na(out$vegas_wp))
})

test_that(".pbp_add_vegas_wp handles a zero-row frame", {
  out <- .pbp_add_vegas_wp(data.frame(spread = numeric(0)))
  expect_equal(nrow(out), 0L)
  expect_true("vegas_wp" %in% names(out))
})

test_that("the published manifest agrees with the in-package spread contract", {
  skip_on_cran()
  skip_if_offline()
  man <- .cfb_model_manifest()
  skip_if(is.null(man), "cfb_model_artifacts MANIFEST.json unavailable")
  expect_identical(unlist(man$assets$wp_spread.ubj$features), .WP_SPREAD_FEATURES)
})

test_that("vegas_wp favours the favourite -- the sign gate", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_wp_spread_model()), "bundled wp_spread model unavailable")

  # Kickoff of a tied game, ball with the AWAY team, who are 19.5-point
  # favourites (CFBD spread = +19.5). A flipped sign gives ~0.10 instead.
  base <- data.frame(
    pos_team_receives_2H_kickoff = 0, TimeSecsRem = 3600,
    adj_TimeSecsRem = 3600, ExpScoreDiff_Time_Ratio = 0,
    pos_score_diff_start = 0, down = 1, distance = 10, yards_to_goal = 75,
    pos_team_timeouts_rem_before = 3, def_pos_team_timeouts_rem_before = 3,
    period = 1, spread = 19.5, pos_team = "Alabama", home = "Miami"
  )
  fav <- .pbp_add_vegas_wp(base)$vegas_wp
  expect_gt(fav, 0.75)

  # Same game, ball with the home underdog: mirror image, well under 0.5.
  dog <- base; dog$pos_team <- "Miami"
  dog_wp <- .pbp_add_vegas_wp(dog)$vegas_wp
  expect_lt(dog_wp, 0.25)
  expect_gt(fav, dog_wp)
})

test_that("vegas_wp rises monotonically with the size of the line", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_wp_spread_model()), "bundled wp_spread model unavailable")

  mk <- function(spread) data.frame(
    pos_team_receives_2H_kickoff = 0, TimeSecsRem = 3600,
    adj_TimeSecsRem = 3600, ExpScoreDiff_Time_Ratio = 0,
    pos_score_diff_start = 0, down = 1, distance = 10, yards_to_goal = 75,
    pos_team_timeouts_rem_before = 3, def_pos_team_timeouts_rem_before = 3,
    period = 1, spread = spread, pos_team = "A", home = "B"  # away possession
  )
  wp <- vapply(c(-21, -7, 0, 7, 21),
               function(s) .pbp_add_vegas_wp(mk(s))$vegas_wp, numeric(1))
  expect_true(all(wp >= 0 & wp <= 1))
  expect_true(all(diff(wp) > 0))
})
