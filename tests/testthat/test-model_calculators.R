fake_booster <- function(features) {
  # Must actually DISCRIMINATE on its features. Training on an all-zero matrix
  # gives a booster that returns 0.5 for every input, which made the
  # column-ordering test unable to fail: a scrambled frame scored identically to
  # a correct one because every frame scored identically.
  set.seed(42)
  n <- 200L
  X <- matrix(stats::runif(n * length(features), 0, 50), nrow = n,
              dimnames = list(NULL, features))
  # label depends on the FIRST feature, so a permuted column order changes the
  # prediction and the ordering assertion has something to catch
  y <- as.integer(X[, 1] > 25)
  xgboost::xgb.train(
    params = list(objective = "binary:logistic", max_depth = 3),
    data = xgboost::xgb.DMatrix(X, label = y), nrounds = 10, verbose = 0
  )
}

test_that("the test booster actually discriminates", {
  # Guards the guard: if this ever returns a constant again, every ordering and
  # validation test below silently stops testing anything.
  feats <- c("down", "distance", "yards_to_goal")
  local_mocked_bindings(cfb_card_features = function(model) feats)
  b <- fake_booster(feats)
  lo <- .cfb_predict_from_card(
    data.frame(down = 1, distance = 1, yards_to_goal = 1), "xpass_model", b
  )
  hi <- .cfb_predict_from_card(
    data.frame(down = 49, distance = 49, yards_to_goal = 49), "xpass_model", b
  )
  expect_gt(abs(hi - lo), 0.1)
})

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

test_that("a season_type column is not mistaken for season", {
  # `$` partial-matches on data frames, so df$season on a pbp frame carrying
  # season_type but no season returns "regular" and the era comparison runs
  # against a season TYPE. Exact [["season"]] lookup is required.
  local_mocked_bindings(cfb_card_era_contract = function(model) {
    list(encoding = "ordinal", columns = "era", cuts = c(2006, 2013, 2020))
  })
  df <- data.frame(season_type = "regular", yards_to_goal = 30, stringsAsFactors = FALSE)
  out <- cfb_add_era_columns(df, "xpass_model", season = 2018)
  expect_equal(out$era, 2L)
})

# ---------------------------------------------------------------------------
# The ten public calculators, against the real packaged models.
# ---------------------------------------------------------------------------

test_that("a hand-built row scores without any pbp machinery", {
  skip_on_cran()
  out <- calculate_field_goal_probability(data.frame(season = 2024, yards_to_goal = 25))
  expect_true(out$fg_make_prob >= 0 && out$fg_make_prob <= 1)
})

test_that("field goal probability moves with the era", {
  # The era one-hot must actually reach the model. Kickers improved over the
  # covered seasons, so a fixed distance must not score identically in 2005 and
  # 2024 -- if it does, the era columns are being ignored.
  skip_on_cran()
  fg <- function(y) {
    calculate_field_goal_probability(data.frame(season = y, yards_to_goal = 25))$fg_make_prob
  }
  expect_lt(fg(2005), fg(2024))
})

test_that("calculators preserve every input column", {
  # Chaining two calculators must be lossless.
  skip_on_cran()
  out <- calculate_field_goal_probability(
    data.frame(season = 2024, yards_to_goal = 25, marker = "keep", stringsAsFactors = FALSE)
  )
  expect_equal(out$marker, "keep")
})

test_that("a missing column names what is absent", {
  skip_on_cran()
  expect_error(
    calculate_field_goal_probability(data.frame(season = 2024)),
    regexp = "yards_to_goal"
  )
})

test_that("expected points emits class probabilities summing to one", {
  skip_on_cran()
  out <- calculate_expected_points(data.frame(
    TimeSecsRem = 1800, yards_to_goal = 75, distance = 10,
    down_1 = 1, down_2 = 0, down_3 = 0, down_4 = 0, pos_score_diff_start = 0
  ))
  expect_true(all(.EP_LEV %in% names(out)))
  expect_equal(sum(unlist(out[1, .EP_LEV])), 1, tolerance = 1e-4)
  expect_true(out$ep >= -10 && out$ep <= 10)
})

test_that("expected points scores a raw pbp frame", {
  # R's .ep_feature_matrix() takes a plain `down` and builds the indicators
  # itself, so the card's post-one-hot list is the wrong contract to validate.
  skip_on_cran()
  pbp <- data.frame(
    season = 2024, start.TimeSecsRem = 900, start.yardsToEndzone = 75,
    start.distance = 10, start.down = 1, pos_score_diff_start = 0
  )
  expect_true(is.finite(calculate_expected_points(pbp)$ep))
})

test_that("epa and wpa require the after-play value", {
  # EPA is a difference; these score rows, not sequences. Inventing ep_end would
  # produce a number that looks like EPA and is not.
  expect_error(calculate_epa(data.frame(yards_to_goal = 75)), regexp = "ep_end")
  expect_error(calculate_wpa(data.frame(down = 1)), regexp = "wp_end")
})

test_that("epa is the difference and reuses an existing ep", {
  # An ep already present must not be recomputed -- that would fight a pbp frame
  # whose ep came from the pipeline.
  expect_equal(calculate_epa(data.frame(ep = 2, ep_end = 5))$epa, 3)
  expect_equal(calculate_wpa(data.frame(wp = 0.4, wp_end = 0.6))$wpa, 0.2, tolerance = 1e-9)
})

test_that("cp score_diff comes from the model's source, not the like-named column", {
  # The CP model's score_diff is fed from pos_score_diff_start. A pbp frame also
  # carries its own score_diff, which is a different quantity; taking it yields
  # completion probabilities that are wrong yet entirely plausible.
  local_mocked_bindings(
    cfb_card_features = function(model) c("score_diff", "down")
  )
  df <- data.frame(pos_score_diff_start = -4, score_diff = 99, down = 3)
  expect_equal(.cfb_normalize_pbp_columns(df, "cfb_cp_model")$score_diff, -4)
})

test_that("a hand-built frame keeps its own score_diff", {
  # No pos_score_diff_start means it is not a pbp frame, so nothing overrides.
  local_mocked_bindings(cfb_card_features = function(model) c("score_diff", "down"))
  df <- data.frame(score_diff = 7, down = 1)
  expect_equal(.cfb_normalize_pbp_columns(df, "cfb_cp_model")$score_diff, 7)
})

test_that("fourth down emits scalars in range, not a scrambled distribution", {
  # fd_model is a 76-class yards-gained distribution, not a probability. An
  # earlier reshape flattened xgboost's n x 76 matrix with as.numeric() and
  # rebuilt it byrow, reassembling column-major and producing a "probability"
  # of 1.75. Bounds are what caught it -- assert them.
  skip_on_cran()
  df <- data.frame(
    season = c(2024, 2024), down = c(4, 4), distance = c(1, 15),
    yards_to_goal = c(45, 45), posteam_total = c(52, 52), posteam_spread = c(-3, -3)
  )
  out <- calculate_fourth_down(df)
  expect_true(all(out$fd_conversion_prob >= 0 & out$fd_conversion_prob <= 1))
  # a short distance must convert more often than a long one
  expect_gt(out$fd_conversion_prob[1], out$fd_conversion_prob[2])
  expect_true(all(is.finite(out$fd_expected_yards)))
})

test_that("fourth down needs distance for the conversion probability", {
  skip_on_cran()
  expect_error(
    calculate_fourth_down(data.frame(
      season = 2024, down = 4, yards_to_goal = 45,
      posteam_total = 52, posteam_spread = -3
    )),
    regexp = "distance"
  )
})

test_that("incomplete down indicators are rejected, not silently mapped to 0", {
  # A partial set silently maps unmatched rows to down = 0 -- a frame that
  # scores clean and means something else.
  df <- data.frame(TimeSecsRem = 900, yards_to_goal = 75, distance = 10,
                   pos_score_diff_start = 0, down_1 = 1, down_2 = 0)
  expect_error(calculate_expected_points(df), regexp = "incomplete")
})

test_that("non-binary down indicators are rejected", {
  df <- data.frame(TimeSecsRem = 900, yards_to_goal = 75, distance = 10,
                   pos_score_diff_start = 0,
                   down_1 = 2, down_2 = 0, down_3 = 0, down_4 = 0)
  expect_error(calculate_expected_points(df), regexp = "0/1")
})

test_that("two active down indicators are rejected", {
  # Two actives sum to a plausible-looking down that is simply wrong.
  df <- data.frame(TimeSecsRem = 900, yards_to_goal = 75, distance = 10,
                   pos_score_diff_start = 0,
                   down_1 = 1, down_2 = 1, down_3 = 0, down_4 = 0)
  expect_error(calculate_expected_points(df), regexp = "exactly one")
})

test_that("no active down indicator is rejected", {
  df <- data.frame(TimeSecsRem = 900, yards_to_goal = 75, distance = 10,
                   pos_score_diff_start = 0,
                   down_1 = 0, down_2 = 0, down_3 = 0, down_4 = 0)
  expect_error(calculate_expected_points(df), regexp = "exactly one")
})

test_that("a complete valid indicator set reconstructs down", {
  # Omit the other required columns so the abort lands on the missing-column
  # check: `down` absent from that list proves reconstruction ran, without
  # needing the bundled booster.
  df <- data.frame(down_1 = c(1, 0, 0, 0), down_2 = c(0, 1, 0, 0),
                   down_3 = c(0, 0, 1, 0), down_4 = c(0, 0, 0, 1))
  err <- tryCatch(calculate_expected_points(df), error = function(e) e)
  expect_s3_class(err, "error")
  # 4 missing, not 5: `down` was rebuilt from the indicators. (The trailing
  # hint line names every required column, so a bare grep for "down" would
  # match whether reconstruction ran or not.)
  expect_match(conditionMessage(err), "needs 4 columns")
})

test_that("the booster is resolved before anything reads the card", {
  # Normalization and era derivation both read the card. Resolving the booster
  # afterwards let a stale card pass the mtime stamp check and only THEN
  # triggered the .ubj TTL refresh -- pairing a new booster with the old
  # contract, the exact skew the stamp keying exists to prevent.
  order <- character(0)
  local_mocked_bindings(
    .cfb_booster_for = function(model) {
      order <<- c(order, "booster")
      fake_booster(c("down", "distance"))
    },
    cfb_card_features = function(model) {
      order <<- c(order, "card")
      c("down", "distance")
    },
    cfb_card_era_contract = function(model) NULL
  )
  .cfb_calculate(data.frame(down = 1, distance = 10), "xpass_model", "xpass")
  expect_equal(order[1], "booster")
})
