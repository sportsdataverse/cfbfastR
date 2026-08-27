### Gates for the bundled completion-probability model (issue #138 P3).
###
### The load-bearing risk here is the `score_diff` feature: the bundle feeds it
### from `pos_score_diff_start`, but cfbfastR ALSO has a column literally named
### `score_diff` with a different value. Reading the like-named one yields
### completion probabilities that are wrong and entirely plausible.

test_that(".CP_FEATURES matches the bundle contract", {
  expect_identical(
    .CP_FEATURES,
    c("down", "distance", "yards_to_goal", "score_diff",
      "seconds_remaining", "is_home", "period", "passing_down")
  )
})

test_that("cp score_diff is sourced from pos_score_diff_start, not score_diff", {
  # The two differ in real data; this pins which one the model gets.
  df <- data.frame(
    down = 1, distance = 10, yards_to_goal = 60,
    pos_score_diff_start = -7, score_diff = 21,   # deliberately different
    TimeSecsRem = 900, period = 2,
    pos_team = "A", home = "A", pass = 1, rush = 0, completion = 1
  )
  m <- .cp_feature_matrix(df)
  expect_equal(unname(m[, "score_diff"]), -7)
  expect_false(identical(unname(m[, "score_diff"]), 21))
})

test_that(".cp_passing_down implements the 2nd&8 / 3rd&5 / 4th&5 rule", {
  df <- data.frame(
    down     = c(1, 2, 2, 3, 3, 4, 4, 2),
    distance = c(10, 8, 7, 5, 4, 5, 4, 20),
    pass     = c(1, 1, 1, 1, 1, 1, 1, 0),
    rush     = c(0, 0, 0, 0, 0, 0, 0, 1)
  )
  expect_equal(.cp_passing_down(df), c(0, 1, 0, 1, 0, 1, 0, 1))
})

test_that(".cp_passing_down excludes non-scrimmage plays", {
  # A punt or kickoff on 4th & long is not a passing down.
  df <- data.frame(down = 4, distance = 10, pass = 0, rush = 0)
  expect_equal(.cp_passing_down(df), 0)
  # Unclassified play (NA) must not become a passing down either.
  df2 <- data.frame(down = 3, distance = 10,
                    pass = NA_real_, rush = NA_real_)
  expect_equal(.cp_passing_down(df2), 0)
})

test_that(".cp_feature_matrix builds all eight features in contract order", {
  df <- data.frame(
    down = c(1, 3), distance = c(10, 6), yards_to_goal = c(75, 40),
    pos_score_diff_start = c(0, -3), score_diff = c(0, 3),
    TimeSecsRem = c(1800, 300), period = c(1, 4),
    pos_team = c("A", "B"), home = c("A", "A"),
    pass = c(1, 1), rush = c(0, 0), completion = c(1, 0)
  )
  m <- .cp_feature_matrix(df)
  expect_identical(colnames(m), .CP_FEATURES)
  expect_equal(nrow(m), 2L)
  expect_equal(unname(m[, "is_home"]), c(1, 0))
  expect_equal(unname(m[, "passing_down"]), c(0, 1))
  expect_equal(unname(m[, "seconds_remaining"]), c(1800, 300))
  expect_false(anyNA(m))
})

test_that(".pbp_add_cp_cpoe degrades to NA columns instead of raising", {
  # Contract match with sdv-py: a frame lacking model inputs must still come
  # back with the columns present, so the pipeline can run unconditionally.
  df <- data.frame(down = 1, distance = 10)
  out <- .pbp_add_cp_cpoe(df)
  expect_true(all(c("cp", "cpoe") %in% names(out)))
  expect_true(is.na(out$cp))
  expect_true(is.na(out$cpoe))
  expect_equal(nrow(out), 1L)
})

test_that(".pbp_add_cp_cpoe handles a zero-row frame", {
  df <- data.frame(down = numeric(0), distance = numeric(0),
                   yards_to_goal = numeric(0), pos_score_diff_start = numeric(0),
                   TimeSecsRem = numeric(0), period = numeric(0),
                   pass = numeric(0), completion = numeric(0))
  out <- .pbp_add_cp_cpoe(df)
  expect_equal(nrow(out), 0L)
  expect_true(all(c("cp", "cpoe") %in% names(out)))
})

test_that("the published manifest agrees with the in-package CP contract", {
  skip_on_cran()
  skip_if_offline()
  man <- .cfb_model_manifest()
  skip_if(is.null(man), "cfb_model_artifacts MANIFEST.json unavailable")
  expect_identical(unlist(man$assets$cfb_cp_model.ubj$features), .CP_FEATURES)
})

test_that("cp/cpoe are populated on pass plays only and on the right scale", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_cp_model()), "bundled CP model unavailable")

  df <- data.frame(
    down = c(1, 2, 3), distance = c(10, 8, 5),
    yards_to_goal = c(75, 50, 30), pos_score_diff_start = c(0, -7, 3),
    TimeSecsRem = c(1800, 900, 200), period = c(1, 2, 4),
    pos_team = c("A", "A", "B"), home = c("A", "A", "A"),
    pass = c(1, 0, 1), rush = c(0, 1, 0),      # middle play is a run
    completion = c(1, NA, 0)
  )
  out <- .pbp_add_cp_cpoe(df)

  expect_false(is.na(out$cp[1]))
  expect_true(is.na(out$cp[2]))               # run play -> no cp
  expect_false(is.na(out$cp[3]))
  expect_true(all(out$cp[c(1, 3)] >= 0 & out$cp[c(1, 3)] <= 1))

  # cpoe is percentage points: a completion scores positive, an incompletion
  # negative, and the magnitude tracks 100*(completion - cp).
  expect_equal(out$cpoe[1], 100 * (1 - out$cp[1]))
  expect_equal(out$cpoe[3], 100 * (0 - out$cp[3]))
  expect_gt(out$cpoe[1], 0)
  expect_lt(out$cpoe[3], 0)
  expect_true(is.na(out$cpoe[2]))
})
