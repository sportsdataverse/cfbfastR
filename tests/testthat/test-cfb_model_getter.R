test_that(".cfb_model() loads on first use, keeps a model, and retries after a failed load", {
  rm(list = ls(.cfb_models), envir = .cfb_models)
  withr::defer(rm(list = ls(.cfb_models), envir = .cfb_models))

  calls <- 0L
  result <- NULL
  local_mocked_bindings(load_ep_model = function() {
    calls <<- calls + 1L
    result
  })

  expect_null(.cfb_model("ep_model"))
  expect_null(.cfb_model("ep_model"))
  expect_identical(calls, 2L)

  result <- structure(list(), class = "fake_booster")
  expect_s3_class(.cfb_model("ep_model"), "fake_booster")
  expect_s3_class(.cfb_model("ep_model"), "fake_booster")
  expect_identical(calls, 3L)

  expect_error(.cfb_model("qbr_model"), "Unknown model")
})

test_that(".cfb_model_dir() caches in tempdir() under R CMD check, the user cache otherwise", {
  withr::local_envvar(c("_R_CHECK_PACKAGE_NAME_" = "cfbfastR"))
  expect_identical(.cfb_model_dir(), file.path(tempdir(), "cfbfastR", "models"))
  withr::local_envvar(c("_R_CHECK_PACKAGE_NAME_" = ""))
  expect_identical(
    .cfb_model_dir(),
    file.path(tools::R_user_dir("cfbfastR", which = "cache"), "models")
  )
})

test_that("scoring with a model that failed to load stops with a clear message", {
  expect_error(.ep_predict(NULL, data.frame()), "expected points model could not be loaded")
  expect_error(.wp_predict(NULL, data.frame()), "win probability model could not be loaded")
  expect_error(.fg_make_prob(NULL, data.frame()), "field goal model could not be loaded")
})

test_that("a failed bundle load falls back to the legacy model with one warning per session", {
  rm(list = ls(.cfb_fallback_warned), envir = .cfb_fallback_warned)
  withr::defer(rm(list = ls(.cfb_fallback_warned), envir = .cfb_fallback_warned))
  legacy <- structure(list(lev = .EP_LEV), class = "nnet")
  local_mocked_bindings(
    .cfb_model_file = function(asset) NULL,
    .load_legacy_ep_model = function() legacy,
    .load_legacy_wp_model = function() legacy
  )
  skip_if_not_installed("xgboost")

  w <- expect_warning(m <- load_ep_model(), class = "cfbfastR_legacy_model")
  expect_identical(m, legacy)
  msg <- conditionMessage(w)
  expect_match(msg, "retired nnet expected points model")
  expect_match(msg, "ep_model.ubj")
  expect_match(msg, "network connection")

  # once per session: the second fallback is silent
  expect_no_warning(load_ep_model())
  # a different model warns on its own
  expect_warning(load_wp_model(), "win probability", class = "cfbfastR_legacy_model")
})

test_that("the warning says to install xgboost when that is the reason", {
  rm(list = ls(.cfb_fallback_warned), envir = .cfb_fallback_warned)
  withr::defer(rm(list = ls(.cfb_fallback_warned), envir = .cfb_fallback_warned))
  local_mocked_bindings(
    .cfb_bundle_booster = function(asset) "no_xgboost",
    .load_legacy_fg_model = function() structure(list(), class = "bam")
  )
  expect_warning(load_fg_model(), "install.packages", class = "cfbfastR_legacy_model")
})

test_that("no fallback warning when the legacy model did not load either", {
  rm(list = ls(.cfb_fallback_warned), envir = .cfb_fallback_warned)
  withr::defer(rm(list = ls(.cfb_fallback_warned), envir = .cfb_fallback_warned))
  local_mocked_bindings(
    .cfb_bundle_booster = function(asset) "download_failed",
    .load_legacy_ep_model = function() NULL
  )
  expect_no_warning(expect_null(load_ep_model()))
})
