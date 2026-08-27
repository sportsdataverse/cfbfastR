### Gates for the era-aware bundled FG model (issue #138 P3).
###
### Two traps here. (1) An absent season makes every era dummy 0 -- not a valid
### one-hot -- which shifts every field-goal probability without erroring.
### (2) sdv-py carries TWO era definitions: the one-hot era0..era3 used by
### fg_model/fd_model cuts at 2006/2013/2020, while the ORDINAL `era` used by
### xpass/two_pt cuts at 2006/2013/2017. Conflating them mislabels 2018-2020.

test_that("FG era cuts are the one-hot set, not the ordinal set", {
  expect_identical(.FG_ERA_CUTS, c(2006, 2013, 2020))
  # 2018 is the season that distinguishes the two definitions: era2 under the
  # one-hot cuts, but ordinal-era 3 under the 2017 cut.
  expect_equal(unname(.cfb_era_onehot(2018, 1)[1, ]), c(0, 0, 1, 0))
})

test_that(".cfb_era_onehot is a valid one-hot at every boundary", {
  seasons <- c(1999, 2006, 2007, 2013, 2014, 2020, 2021, 2026)
  m <- .cfb_era_onehot(seasons, length(seasons))
  expect_identical(colnames(m), c("era0", "era1", "era2", "era3"))
  expect_equal(unname(rowSums(m)), rep(1, length(seasons)))
  # boundaries are inclusive on the lower era
  expect_equal(unname(m[seasons == 2006, ]), c(1, 0, 0, 0))
  expect_equal(unname(m[seasons == 2007, ]), c(0, 1, 0, 0))
  expect_equal(unname(m[seasons == 2013, ]), c(0, 1, 0, 0))
  expect_equal(unname(m[seasons == 2014, ]), c(0, 0, 1, 0))
  expect_equal(unname(m[seasons == 2020, ]), c(0, 0, 1, 0))
  expect_equal(unname(m[seasons == 2021, ]), c(0, 0, 0, 1))
})

test_that(".cfb_era_onehot recycles a scalar season across rows", {
  m <- .cfb_era_onehot(2019, 3)
  expect_equal(nrow(m), 3L)
  expect_equal(unname(rowSums(m)), rep(1, 3))
})

test_that("the era-aware FG model refuses to score without a season", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("xgboost")
  fg <- load_fg_model()
  skip_if(!inherits(fg, "xgb.Booster"), "bundled FG model unavailable")
  skip_if(!any(startsWith(.booster_feature_names(fg), "era")),
          "loaded FG model is not era-aware")

  d <- data.frame(yards_to_goal = c(20, 30))
  # Silently scoring with all-zero era dummies is the failure mode this guards.
  expect_error(.fg_make_prob(fg, d, season = NULL), "season")
  expect_error(.fg_make_prob(fg, d, season = NA), "season")
})

test_that("FG make probability falls with distance and stays in [0,1]", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("xgboost")
  fg <- load_fg_model()
  skip_if(!inherits(fg, "xgb.Booster"), "bundled FG model unavailable")

  d <- data.frame(yards_to_goal = c(2, 10, 20, 30, 40))
  p <- .fg_make_prob(fg, d, season = 2021)
  expect_length(p, 5L)
  expect_true(all(p >= 0 & p <= 1))
  # A chip shot must beat a long attempt. Not strict monotonicity at every
  # step -- a tree model can plateau -- but the endpoints must order.
  expect_gt(p[1], p[5])
  expect_gt(p[1], 0.9)
})

test_that("era actually moves the FG prediction", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("xgboost")
  fg <- load_fg_model()
  skip_if(!inherits(fg, "xgb.Booster"), "bundled FG model unavailable")
  skip_if(!any(startsWith(.booster_feature_names(fg), "era")),
          "loaded FG model is not era-aware")

  d <- data.frame(yards_to_goal = 35)
  old <- .fg_make_prob(fg, d, season = 2004)
  new <- .fg_make_prob(fg, d, season = 2024)
  # If these were equal the era features would not be reaching the booster.
  expect_false(isTRUE(all.equal(old, new)))
})

test_that("the published manifest agrees with the in-package FG contract", {
  skip_on_cran()
  skip_if_offline()
  man <- .cfb_model_manifest()
  skip_if(is.null(man), "cfb_model_artifacts MANIFEST.json unavailable")
  expect_identical(unlist(man$assets$fg_model.ubj$features), .FG_FEATURES)
})

test_that("every entry point forwards season to the era-aware FG model", {
  # Regression guard. The v2 paths threaded `season` from the start, but the
  # LEGACY paths called create_epa() without it, so with the era-aware model
  # every FG/XP play aborted in .fg_make_prob() and the outer handler swallowed
  # it -- the game came back with no modeled EPA at all. Validating only the v2
  # paths is what let that through, so all four are exercised here.
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("xgboost")
  fg <- load_fg_model()
  skip_if(!inherits(fg, "xgb.Booster"), "bundled FG model unavailable")
  skip_if(!any(startsWith(.booster_feature_names(fg), "era")),
          "loaded FG model is not era-aware")

  for (engine in c("legacy", "v2")) {
    r <- try(suppressWarnings(suppressMessages(
      espn_cfb_pbp(game_id = "401331242", epa_wpa = TRUE, engine = engine)
    )), silent = TRUE)
    skip_if(inherits(r, "try-error") || is.null(r) || !nrow(r),
            paste("ESPN unavailable for engine", engine))
    expect_true("fg_make_prob" %in% names(r),
                info = paste("engine", engine))
    # A game with no scored field goals would make this vacuous, so require at
    # least one -- this game has several.
    expect_gt(sum(!is.na(r$fg_make_prob)), 0)
    expect_gt(sum(is.finite(r$EPA)), 100)
  }
})
