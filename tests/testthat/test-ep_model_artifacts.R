### Gates for the shared `cfb_model_artifacts` EP model (issue #138 P1).
###
### The class-order gate is the important one. cfbfastR's historical
### `ep_model$lev` order and the bundle's class order share NO fixed point, so
### scoring with the wrong permutation produces EP that is wrong but lands in a
### plausible range -- it will not trip a range check or an eyeball. Every test
### here is written to fail loudly if that mapping drifts.

test_that(".EP_LEV still matches the weights vector it is scored against", {
  # `weights <- c(0, 3, -3, -2, -7, 2, 7)` in .pbp_create_epa() is positional.
  # If .EP_LEV is ever reordered without reordering the weights, EPA silently
  # becomes garbage -- so pin the pairing explicitly.
  expect_identical(
    .EP_LEV,
    c("No_Score", "FG", "Opp_FG", "Opp_Safety", "Opp_TD", "Safety", "TD")
  )
  points <- c(No_Score = 0, FG = 3, Opp_FG = -3, Opp_Safety = -2,
              Opp_TD = -7, Safety = 2, TD = 7)
  expect_identical(unname(points[.EP_LEV]), c(0, 3, -3, -2, -7, 2, 7))
})

test_that(".EP_PERM_FALLBACK is a valid permutation that reproduces the weights", {
  expect_setequal(.EP_PERM_FALLBACK, 1:7)
  # Bundle order and its point values, per MANIFEST.json's ep_class_contract.
  bundle_points <- c(7, -7, 3, -3, 2, -2, 0)   # TD, Opp_TD, FG, Opp_FG, Sfty, Opp_Sfty, None
  expect_identical(bundle_points[.EP_PERM_FALLBACK], c(0, 3, -3, -2, -7, 2, 7))
})

test_that(".ep_feature_matrix builds the bundle's contract in order", {
  nd <- data.frame(
    TimeSecsRem = c(1800, 300),
    yards_to_goal = c(75, 20),
    distance = c(10, 3),
    down = factor(c(1, 3), levels = c("1", "2", "3", "4")),
    pos_score_diff_start = c(0, -7)
  )
  m <- .ep_feature_matrix(nd)
  expect_identical(colnames(m), .EP_FEATURES)
  expect_equal(nrow(m), 2L)
  # one-hot down, exactly one hot per row
  expect_equal(unname(rowSums(m[, c("down_1", "down_2", "down_3", "down_4")])), c(1, 1))
  expect_equal(unname(m[1, "down_1"]), 1)
  expect_equal(unname(m[2, "down_3"]), 1)
})

test_that(".ep_feature_matrix reads down VALUES, not factor level codes", {
  # as.numeric() on a factor returns level codes. With reversed levels that
  # turns 1st down into 4th down -- a silent, plausible-looking corruption.
  a <- data.frame(TimeSecsRem = 900, yards_to_goal = 60, distance = 10,
                  down = factor("1", levels = c("1", "2", "3", "4")),
                  pos_score_diff_start = 0)
  b <- a
  b$down <- factor("1", levels = c("4", "3", "2", "1"))
  expect_identical(.ep_feature_matrix(a), .ep_feature_matrix(b))
  expect_equal(unname(.ep_feature_matrix(b)[1, "down_1"]), 1)
})

test_that(".ep_feature_matrix refuses a frame missing model columns", {
  nd <- data.frame(TimeSecsRem = 900, yards_to_goal = 60, down = 1)
  expect_error(.ep_feature_matrix(nd), "distance")
})

test_that("the published manifest agrees with the in-package fallback", {
  skip_on_cran()
  skip_if_offline()
  man <- .cfb_model_manifest()
  skip_if(is.null(man), "cfb_model_artifacts MANIFEST.json unavailable")

  ep <- man$ep_class_contract
  expect_identical(unlist(ep$cfbfastR_lev_order), .EP_LEV)
  expect_identical(as.integer(unlist(ep$permutation_to_cfbfastR_lev_1based)),
                   .EP_PERM_FALLBACK)
  # the manifest's own numbers must be self-consistent
  expect_equal(
    as.numeric(unlist(ep$point_values))[.EP_PERM_FALLBACK],
    c(0, 3, -3, -2, -7, 2, 7)
  )
  expect_identical(unlist(man$assets$ep_model.ubj$features), .EP_FEATURES)
})

test_that(".ep_predict returns lev-ordered probabilities that keep rows intact", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("xgboost")
  ep_model <- load_ep_model()
  skip_if(!inherits(ep_model, "xgb.Booster"), "bundled EP model unavailable")

  nd <- data.frame(
    TimeSecsRem = c(1800, 120, 600, 30),
    yards_to_goal = c(75, 5, 50, 95),
    distance = c(10, 2, 7, 10),
    down = factor(c(1, 3, 2, 4), levels = c("1", "2", "3", "4")),
    pos_score_diff_start = c(0, -3, 7, -14)
  )
  p <- .ep_predict(ep_model, nd)

  expect_s3_class(p, "data.frame")
  expect_identical(colnames(p), .EP_LEV)
  expect_equal(nrow(p), nrow(nd))
  expect_true(all(abs(rowSums(p) - 1) < 1e-6))

  # Batch scoring must equal row-by-row: catches a byrow/bycol reshape error,
  # which would scramble probabilities across plays without changing sums.
  alone <- do.call(rbind, lapply(seq_len(nrow(nd)), function(i) {
    .ep_predict(ep_model, nd[i, , drop = FALSE])
  }))
  expect_equal(as.matrix(p), as.matrix(alone), tolerance = 1e-12)

  # Football sanity, which a wrong permutation fails: 3rd & 2 at the 5 is worth
  # far more than 4th & 10 from your own 5 while down two scores.
  ep <- as.numeric(as.matrix(p) %*% c(0, 3, -3, -2, -7, 2, 7))
  expect_gt(ep[2], 3)
  expect_lt(ep[4], 0)
  expect_gt(ep[2], ep[1])
})

test_that("a wrong class permutation would be caught by the sanity gate", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("xgboost")
  ep_model <- load_ep_model()
  skip_if(!inherits(ep_model, "xgb.Booster"), "bundled EP model unavailable")

  nd <- data.frame(TimeSecsRem = 1800, yards_to_goal = 75, distance = 10,
                   down = factor("1", levels = c("1", "2", "3", "4")),
                   pos_score_diff_start = 0)
  raw <- stats::predict(ep_model, .ep_feature_matrix(nd))
  raw <- matrix(as.numeric(raw), ncol = 7, byrow = TRUE)

  correct <- sum(raw * c(7, -7, 3, -3, 2, -2, 0))          # bundle order
  naive <- sum(raw * c(0, 3, -3, -2, -7, 2, 7))            # cfbfastR weights, unpermuted
  # Both are small positives -- which is exactly why this needs a test rather
  # than a range check -- but they are NOT the same number.
  expect_false(isTRUE(all.equal(correct, naive)))
  expect_equal(sum(as.numeric(.ep_predict(ep_model, nd)) * c(0, 3, -3, -2, -7, 2, 7)),
               correct, tolerance = 1e-9)
})
