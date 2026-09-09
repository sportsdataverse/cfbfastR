fake_booster <- function(features) {
  X <- matrix(0, nrow = 4, ncol = length(features), dimnames = list(NULL, features))
  xgboost::xgb.train(
    params = list(objective = "binary:logistic", max_depth = 1),
    data = xgboost::xgb.DMatrix(X, label = c(0, 1, 0, 1)), nrounds = 1
  )
}

test_that("missing columns are all named in one error", {
  # The failure this surface exists to remove is a caller unable to tell what
  # their frame is missing -- so name every absent column, not just the first.
  local_mocked_bindings(
    cfb_card_features = function(model) c("down", "distance", "yards_to_goal")
  )
  err <- expect_error(
    .cfb_predict_from_card(
      data.frame(down = 1), "xpass_model",
      fake_booster(c("down", "distance", "yards_to_goal"))
    )
  )
  expect_match(conditionMessage(err), "distance")
  expect_match(conditionMessage(err), "yards_to_goal")
  expect_match(conditionMessage(err), "xpass_model")
})

test_that("columns are ordered by the card, not the frame", {
  # A frame in a different column order must score identically. If the DMatrix
  # were built from frame order this silently scores garbage.
  feats <- c("down", "distance", "yards_to_goal")
  local_mocked_bindings(cfb_card_features = function(model) feats)
  b <- fake_booster(feats)
  ordered <- data.frame(down = 3, distance = 7, yards_to_goal = 42)
  shuffled <- ordered[, c("yards_to_goal", "down", "distance")]
  expect_equal(
    .cfb_predict_from_card(ordered, "xpass_model", b),
    .cfb_predict_from_card(shuffled, "xpass_model", b)
  )
})

test_that("2018 through 2020 land in era bucket 2, not 3", {
  # The exact regression from cfbfastR-cfb-data#70: this package kept a private
  # 2017 cut the trainer never used, so 2018-2020 scored an era off.
  local_mocked_bindings(cfb_card_era_contract = function(model) {
    list(encoding = "ordinal", columns = "era", cuts = c(2006, 2013, 2020))
  })
  out <- cfb_add_era_columns(data.frame(season = c(2018, 2019, 2020)), "xpass_model")
  expect_equal(out$era, c(2L, 2L, 2L))
})

test_that("one-hot era produces all four columns", {
  local_mocked_bindings(cfb_card_era_contract = function(model) {
    list(
      encoding = "one_hot", columns = c("era0", "era1", "era2", "era3"),
      cuts = c(2006, 2013, 2020)
    )
  })
  out <- cfb_add_era_columns(data.frame(season = 2018), "fg_model")
  expect_equal(unlist(out[1, c("era0", "era1", "era2", "era3")], use.names = FALSE), c(0L, 0L, 1L, 0L))
})

test_that("a model with no era contract is left untouched", {
  local_mocked_bindings(cfb_card_era_contract = function(model) NULL)
  df <- data.frame(season = 2018, yards_to_goal = 30)
  expect_identical(names(cfb_add_era_columns(df, "ep_model")), names(df))
})

test_that("an existing era column is not overwritten", {
  # A pbp frame already carries era; recomputing would fight the pipeline.
  local_mocked_bindings(cfb_card_era_contract = function(model) {
    list(encoding = "ordinal", columns = "era", cuts = c(2006, 2013, 2020))
  })
  expect_equal(cfb_add_era_columns(data.frame(season = 2018, era = 99), "xpass_model")$era, 99)
})

test_that("the frame's own season beats the season argument", {
  # `season` is documented as the fallback for a frame carrying none. Letting it
  # override stamps one era across a multi-season frame and scores most rows
  # against the wrong inputs -- silently, since no column is ever missing.
  local_mocked_bindings(cfb_card_era_contract = function(model) {
    list(encoding = "ordinal", columns = "era", cuts = c(2006, 2013, 2020))
  })
  out <- cfb_add_era_columns(data.frame(season = c(2005, 2024)), "xpass_model", season = 2024)
  expect_equal(out$era, c(0L, 3L))
})

test_that("a hand-built row can supply the season argument", {
  local_mocked_bindings(cfb_card_era_contract = function(model) {
    list(encoding = "ordinal", columns = "era", cuts = c(2006, 2013, 2020))
  })
  out <- cfb_add_era_columns(data.frame(yards_to_goal = 30), "xpass_model", season = 2018)
  expect_equal(out$era, 2L)
})

test_that("pbp column names are normalized onto the card's names", {
  # pbp carries start.TimeSecsRem; the card declares TimeSecsRem. Without this
  # the calculators accept only already-renamed frames.
  local_mocked_bindings(
    cfb_card_features = function(model) c("TimeSecsRem", "yards_to_goal", "down")
  )
  pbp <- data.frame(
    start.TimeSecsRem = 900, start.yardsToEndzone = 55, start.down = 3
  )
  out <- .cfb_normalize_pbp_columns(pbp, "xpass_model")
  expect_equal(out$TimeSecsRem, 900)
  expect_equal(out$yards_to_goal, 55)
  # copies, never renames: the caller's own columns must survive
  expect_true("start.TimeSecsRem" %in% names(out))
})

test_that("normalization does not clobber an already-named column", {
  local_mocked_bindings(cfb_card_features = function(model) "TimeSecsRem")
  df <- data.frame(TimeSecsRem = 111, start.TimeSecsRem = 999)
  expect_equal(.cfb_normalize_pbp_columns(df, "xpass_model")$TimeSecsRem, 111)
})
