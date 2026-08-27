### Gates for the bundled expected-pass model (`xpass` / `pass_oe`, #138).
###
### Two traps, both shared with models already in this PR:
###   * `pos_score_diff` is sourced from `pos_score_diff_start`, not the frame's
###     like-named column, which holds a different value.
###   * the ORDINAL era here cuts at 2006/2013/2017, NOT the one-hot era0..era3
###     cuts of 2006/2013/2020 used by the FG model.

test_that(".XPASS_FEATURES matches the bundle contract", {
  expect_identical(
    .XPASS_FEATURES,
    c("down", "distance", "yards_to_goal", "pos_score_diff",
      "TimeSecsRem", "era", "period")
  )
})

test_that("the ordinal era is NOT the one-hot era set", {
  expect_identical(.XPASS_ERA_CUTS, c(2006, 2013, 2017))
  expect_false(identical(.XPASS_ERA_CUTS, .FG_ERA_CUTS))
  # 2018-2020 is exactly where the two disagree: ordinal era 3, one-hot era2.
  expect_equal(.cfb_era_ordinal(2018, 1), 3)
  expect_equal(unname(.cfb_era_onehot(2018, 1)[1, ]), c(0, 0, 1, 0))
})

test_that(".cfb_era_ordinal maps every boundary", {
  s <- c(2000, 2006, 2007, 2013, 2014, 2017, 2018, 2025)
  expect_equal(.cfb_era_ordinal(s, length(s)), c(0, 0, 1, 1, 2, 2, 3, 3))
})

test_that(".cfb_era_ordinal recycles a scalar season", {
  expect_equal(.cfb_era_ordinal(2021, 3), c(3, 3, 3))
})

test_that(".pbp_add_xpass degrades to NA rather than raising", {
  df <- data.frame(down = 1, distance = 10)
  out <- .pbp_add_xpass(df, season = 2021)
  expect_true(all(c("xpass", "pass_oe") %in% names(out)))
  expect_true(is.na(out$xpass))
})

test_that(".pbp_add_xpass refuses to invent an era when season is absent", {
  # Without a season the ordinal era would silently default, shifting every
  # expected-pass rate -- emit NA instead.
  df <- data.frame(down = 1, distance = 10, yards_to_goal = 60,
                   pos_score_diff_start = 0, TimeSecsRem = 900, period = 2,
                   pass = 1, rush = 0)
  expect_true(is.na(.pbp_add_xpass(df, season = NULL)$xpass))
  expect_true(is.na(.pbp_add_xpass(df, season = NA)$xpass))
})

test_that(".pbp_add_xpass handles a zero-row frame", {
  df <- data.frame(down = numeric(0), distance = numeric(0),
                   yards_to_goal = numeric(0), pos_score_diff_start = numeric(0),
                   TimeSecsRem = numeric(0), period = numeric(0),
                   pass = numeric(0), rush = numeric(0))
  out <- .pbp_add_xpass(df, season = 2021)
  expect_equal(nrow(out), 0L)
  expect_true(all(c("xpass", "pass_oe") %in% names(out)))
})

test_that("the published manifest agrees with the in-package xpass contract", {
  skip_if_offline()
  man <- .cfb_model_manifest()
  skip_if(is.null(man), "cfb_model_artifacts MANIFEST.json unavailable")
  expect_identical(unlist(man$assets$xpass_model.ubj$features), .XPASS_FEATURES)
})

test_that("xpass is scrimmage-only and rises on obvious passing downs", {
  skip_if_offline()
  skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_xpass_model()), "bundled xpass model unavailable")

  df <- data.frame(
    down = c(3, 1, 3),
    distance = c(15, 10, 15),
    yards_to_goal = c(60, 60, 60),
    pos_score_diff_start = c(0, 0, 0),
    TimeSecsRem = c(1800, 1800, 1800),
    period = c(2, 2, 2),
    pass = c(1, 0, 0),
    rush = c(0, 1, 0)      # third row is neither -- a punt/kick
  )
  out <- .pbp_add_xpass(df, season = 2021)

  expect_false(is.na(out$xpass[1]))
  expect_false(is.na(out$xpass[2]))
  expect_true(is.na(out$xpass[3]))          # non-scrimmage -> no xpass
  expect_true(all(out$xpass[1:2] >= 0 & out$xpass[1:2] <= 1))
  # 3rd & 15 must be a likelier pass than 1st & 10.
  expect_gt(out$xpass[1], out$xpass[2])
  expect_gt(out$xpass[1], 0.7)

  # pass_oe is percentage points: passing when expected to pass scores lower
  # than passing when nobody expects it.
  expect_equal(out$pass_oe[1], 100 * (1 - out$xpass[1]))
  expect_equal(out$pass_oe[2], 100 * (0 - out$xpass[2]))
  expect_lt(out$pass_oe[2], 0)              # ran the ball -> negative
})
