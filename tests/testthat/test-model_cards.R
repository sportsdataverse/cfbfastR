# The model card is the contract; nothing may restate it. cfbfastR previously
# kept a private copy of the era cuts, drifted to a 2017 boundary the trainer
# never used, and scored 2018-2020 an era off -- cfbfastR-cfb-data#70.

test_that("card features come back in the card's declared order", {
  # Order is load-bearing: xgboost aligns a DMatrix by position, so a sorted
  # list scores against the wrong columns without ever erroring.
  feats <- c("TimeSecsRem", "yards_to_goal", "distance", "down_1")
  local_mocked_bindings(.read_card_json = function(model) list(features = feats))
  cfb_card_reset_cache()
  expect_identical(cfb_card_features("ep_model"), feats)
})

test_that("the era contract is returned when the model consumes one", {
  contract <- list(
    encoding = "one_hot",
    columns = c("era0", "era1", "era2", "era3"),
    cuts = c(2006, 2013, 2020)
  )
  local_mocked_bindings(.read_card_json = function(model) {
    list(features = "yards_to_goal", era_contract = contract)
  })
  cfb_card_reset_cache()
  expect_identical(cfb_card_era_contract("fg_model"), contract)
})

test_that("a model with no era feature returns NULL", {
  # NULL is CORRECT for ep_model, wp_naive, wp_spread and cfb_cp_model.
  local_mocked_bindings(.read_card_json = function(model) {
    list(features = "TimeSecsRem", era_contract = NULL)
  })
  cfb_card_reset_cache()
  expect_null(cfb_card_era_contract("ep_model"))
})

test_that("a card declaring no features is rejected", {
  # A card with no features validates nothing; fail loudly, not silently.
  local_mocked_bindings(.read_card_json = function(model) list(model_type = "ep"))
  cfb_card_reset_cache()
  expect_error(cfb_card_features("ep_model"), regexp = "no features")
})

test_that("the card is read once and cached", {
  calls <- 0L
  local_mocked_bindings(.read_card_json = function(model) {
    calls <<- calls + 1L
    list(features = "a")
  })
  cfb_card_reset_cache()
  cfb_card_features("ep_model")
  cfb_card_features("ep_model")
  expect_equal(calls, 1L)
})

test_that("the real bundle cards carry the contracts they should", {
  skip_on_cran()
  cfb_card_reset_cache()
  # ep consumes no era feature; fg is one-hot; xpass is ordinal. Getting this
  # backwards would mean deriving era columns a model never saw.
  expect_null(cfb_card_era_contract("ep_model"))
  expect_identical(cfb_card_era_contract("fg_model")$encoding, "one_hot")
  expect_identical(cfb_card_era_contract("xpass_model")$encoding, "ordinal")
  expect_equal(cfb_card_era_contract("fg_model")$cuts, c(2006, 2013, 2020))
  expect_length(cfb_card_features("ep_model"), 8L)
})
