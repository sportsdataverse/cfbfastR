#' @keywords internal
#' @noRd
.cfb_predict_from_card <- function(df, model, booster) {
  feats <- cfb_card_features(model)
  missing <- setdiff(feats, names(df))
  if (length(missing) > 0L) {
    cli::cli_abort(c(
      "{model} needs {length(missing)} column{?s} not present in the data.",
      "x" = "Missing: {.val {missing}}",
      "i" = "Its card declares: {.val {feats}}"
    ))
  }
  # Selected in the CARD's order, never the frame's: xgboost aligns a DMatrix by
  # position, so frame order would silently score against the wrong columns.
  mat <- as.matrix(df[, feats, drop = FALSE])
  storage.mode(mat) <- "double"
  stats::predict(booster, xgboost::xgb.DMatrix(mat))
}

#' Play-by-play column names for each model feature
#'
#' A real pbp frame carries `start.TimeSecsRem`; the cards declare
#' `TimeSecsRem`. Without this the calculators would only accept already-named
#' frames, which is not what a caller holding play-by-play has. Mirrors
#' `_PBP_ALIASES` in sportsdataverse-py.
#' @keywords internal
#' @noRd
.CFB_PBP_ALIASES <- list(
  TimeSecsRem = "start.TimeSecsRem",
  adj_TimeSecsRem = "start.adj_TimeSecsRem",
  yards_to_goal = c("start.yardsToEndzone", "start.yards_to_goal"),
  distance = "start.distance",
  down = "start.down",
  pos_score_diff = "pos_score_diff_start",
  period = "start.period",
  is_home = "start.is_home",
  spread_time = "start.spread_time",
  ExpScoreDiff_Time_Ratio = "start.ExpScoreDiff_Time_Ratio",
  pos_team_receives_2H_kickoff = "start.pos_team_receives_2H_kickoff",
  pos_team_timeouts_rem_before = "start.pos_team_timeouts_rem_before",
  def_pos_team_timeouts_rem_before = "start.def_pos_team_timeouts_rem_before"
)

#' Features whose pbp source OVERRIDES a like-named column already in the frame
#'
#' The CP model's `score_diff` is fed from `pos_score_diff_start` -- signed from
#' the possessing team's view -- and a cfbfastR pbp frame ALSO carries its own
#' `score_diff`, which is not the same quantity. Taking the like-named column
#' produces completion probabilities that are wrong yet entirely plausible, so
#' where the pbp source is present it wins: its presence is what identifies the
#' frame as play-by-play, and a hand-built frame has no such column.
#' @keywords internal
#' @noRd
.CFB_PBP_OVERRIDES <- list(score_diff = "pos_score_diff_start")

#' @keywords internal
#' @noRd
.CFB_DOWN_ONE_HOTS <- c("down_1", "down_2", "down_3", "down_4")

#' @keywords internal
#' @noRd
.cfb_normalize_pbp_columns <- function(df, model) {
  feats <- cfb_card_features(model)
  for (feature in feats) {
    override <- .CFB_PBP_OVERRIDES[[feature]]
    if (!is.null(override) && override %in% names(df)) {
      df[[feature]] <- df[[override]]
      next
    }
    if (feature %in% names(df)) next
    for (source in .CFB_PBP_ALIASES[[feature]]) {
      if (!is.null(source) && source %in% names(df)) {
        # copy, never rename: nothing the caller passed in is removed
        df[[feature]] <- df[[source]]
        break
      }
    }
  }

  # EP is trained on one-hot downs, not a `down` column, so aliasing
  # start.down -> down leaves a raw pbp frame four features short.
  wanted <- intersect(feats, .CFB_DOWN_ONE_HOTS)
  if (length(wanted) > 0L && !all(wanted %in% names(df))) {
    src <- if ("down" %in% names(df)) "down" else if ("start.down" %in% names(df)) "start.down" else NULL
    if (!is.null(src)) {
      for (col in setdiff(wanted, names(df))) {
        # never overwrite a caller's own indicator: a pbp frame may carry them
        df[[col]] <- as.integer(df[[src]] == as.integer(sub("^down_", "", col)))
      }
    }
  }
  df
}

#' @keywords internal
#' @noRd
cfb_add_era_columns <- function(df, model, season = NULL) {
  contract <- cfb_card_era_contract(model)
  if (is.null(contract)) {
    return(df)
  }
  cols <- contract$columns
  if (all(cols %in% names(df))) {
    return(df)
  }
  cuts <- contract$cuts
  # The frame's own season wins; `season` is the documented fallback for a frame
  # that carries none. Letting the argument override stamps one era across a
  # multi-season frame and scores most rows against the wrong inputs -- silently,
  # because no column is ever missing. Same defect fixed in sportsdataverse-py.
  # `df[["season"]]`, never `df$season`: `$` partial-matches on data frames, so a
  # pbp frame carrying `season_type` but no `season` returns "regular" here and
  # the era comparison silently runs against a season TYPE. Verified.
  yr <- if ("season" %in% names(df)) {
    df[["season"]]
  } else if (!is.null(season)) {
    rep(season, nrow(df))
  } else {
    NULL
  }
  if (is.null(yr)) {
    cli::cli_abort(
      "{model} needs an era column; supply a {.code season} column or the {.arg season} argument."
    )
  }
  bucket <- ifelse(yr <= cuts[1], 0L, ifelse(yr <= cuts[2], 1L, ifelse(yr <= cuts[3], 2L, 3L)))
  if (identical(contract$encoding, "ordinal")) {
    df[[cols[1]]] <- bucket
  } else {
    for (i in seq_along(cols)) df[[cols[i]]] <- as.integer(bucket == (i - 1L))
  }
  df
}

#' @keywords internal
#' @noRd
.cfb_booster_for <- function(model) {
  path <- .cfb_model_file(paste0(model, ".ubj"))
  if (is.null(path) || !file.exists(path)) {
    cli::cli_abort("Could not obtain the {.val {model}} booster.")
  }
  xgboost::xgb.load(path)
}

#' @keywords internal
#' @noRd
.cfb_calculate <- function(df, model, out_col, season = NULL) {
  prepared <- cfb_add_era_columns(.cfb_normalize_pbp_columns(df, model), model, season = season)
  prepared[[out_col]] <- .cfb_predict_from_card(prepared, model, .cfb_booster_for(model))
  prepared
}

#' @name calculate_cfb_models
#' @title
#' **Score a data frame with the shipped CFB models**
#' @description
#' Hand a data frame to any of these and get model output back, whether the rows
#' came from a play-by-play frame or were typed by hand to ask a hypothetical.
#' Only the model card's declared columns are required; extra columns pass
#' through untouched, and every input column is preserved so chaining two
#' calculators is lossless.
#'
#' Play-by-play column names are normalized automatically -- a frame carrying
#' `start.TimeSecsRem` and `start.yardsToEndzone` is accepted as-is.
#'
#' * `calculate_expected_points()`: expected points, plus the seven next-score class probabilities.
#' * `calculate_win_probability()`: win probability (`wp_spread` when a spread is present, else `wp_naive`).
#' * `calculate_epa()` / `calculate_wpa()`: the change in EP / WP across a play.
#' * `calculate_field_goal_probability()`: field-goal make probability.
#' * `calculate_completion_probability()`: completion probability.
#' * `calculate_xpass()`: expected pass probability.
#' * `calculate_two_point_probability()`: two-point conversion probability.
#' * `calculate_fourth_down()`: fourth-down model output.
#' * `calculate_qbr()`: model QBR.
#'
#' These wrap [create_epa()] and [create_wpa_naive()], which remain available for
#' callers that already hold booster objects.
#'
#' @param df (*data.frame* required): Rows to score. Requires the columns the
#'   model's published card declares; see the per-function entries.
#' @param season (*Integer* optional): Season used to derive era columns when
#'   `df` carries no `season` column. The frame's own `season` always wins.
#'
#' @return A data frame: `df` with the model's output column(s) appended.
#'
#' @keywords CFB Model Calculators
#' @importFrom cli cli_abort
#' @family CFB Model Calculators
NULL

#' @rdname calculate_cfb_models
#' @return [calculate_xpass()] - `df` with one column appended:
#'
#'  |col_name |types   |description                           |
#'  |:--------|:-------|:-------------------------------------|
#'  |xpass    |numeric |Probability the play is a pass (0-1). |
#'
#' @export
#' @examples
#' \donttest{
#'   try(calculate_xpass(data.frame(season = 2024, down = 3, distance = 8,
#'     yards_to_goal = 55, pos_score_diff = -4, TimeSecsRem = 900, period = 3)))
#' }
calculate_xpass <- function(df, season = NULL) {
  .cfb_calculate(df, "xpass_model", "xpass", season = season)
}

#' @rdname calculate_cfb_models
#' @return [calculate_field_goal_probability()] - `df` with one column appended:
#'
#'  |col_name |types   |description                        |
#'  |:--------|:-------|:----------------------------------|
#'  |fg_prob  |numeric |Field-goal make probability (0-1). |
#'
#' @export
#' @examples
#' \donttest{
#'   try(calculate_field_goal_probability(data.frame(season = 2024, yards_to_goal = 25)))
#' }
calculate_field_goal_probability <- function(df, season = NULL) {
  .cfb_calculate(df, "fg_model", "fg_prob", season = season)
}

#' @rdname calculate_cfb_models
#' @return [calculate_completion_probability()] - `df` with one column appended:
#'
#'  |col_name |types   |description                      |
#'  |:--------|:-------|:--------------------------------|
#'  |cp       |numeric |Completion probability (0-1).    |
#'
#' @export
#' @examples
#' \donttest{
#'   try(calculate_completion_probability(data.frame(season = 2024, down = 3,
#'     distance = 8, yards_to_goal = 55, score_diff = -4,
#'     seconds_remaining = 900, is_home = 1, period = 3, passing_down = 1)))
#' }
calculate_completion_probability <- function(df, season = NULL) {
  .cfb_calculate(df, "cfb_cp_model", "cp", season = season)
}

#' @rdname calculate_cfb_models
#' @return [calculate_two_point_probability()] - `df` with one column appended:
#'
#'  |col_name    |types   |description                                |
#'  |:-----------|:-------|:------------------------------------------|
#'  |two_pt_prob |numeric |Two-point conversion probability (0-1).    |
#'
#' @export
#' @examples
#' \donttest{
#'   try(calculate_two_point_probability(data.frame(season = 2024,
#'     posteam_spread = -3, posteam_total = 28, pos_score_diff = -2)))
#' }
calculate_two_point_probability <- function(df, season = NULL) {
  .cfb_calculate(df, "two_pt_model", "two_pt_prob", season = season)
}

#' @rdname calculate_cfb_models
#' @return [calculate_fourth_down()] - `df` with two columns appended:
#'
#'  |col_name           |types   |description                                          |
#'  |:------------------|:-------|:----------------------------------------------------|
#'  |fd_conversion_prob |numeric |Probability the gain reaches `distance` (0-1).       |
#'  |fd_expected_yards  |numeric |Expected yards gained on the play.                   |
#'
#' `fd_model` is a 76-class yards-gained distribution (class *k* is a gain of
#' *k* - 10 yards), not a probability, so these are derived from it rather than
#' returned raw -- an array column could not be written to CSV and is not a
#' usable public surface.
#'
#' @export
#' @examples
#' \donttest{
#'   try(calculate_fourth_down(data.frame(season = 2024, down = 4, distance = 2,
#'     yards_to_goal = 45, posteam_total = 52, posteam_spread = -3)))
#' }
calculate_fourth_down <- function(df, season = NULL) {
  prepared <- cfb_add_era_columns(
    .cfb_normalize_pbp_columns(df, "fd_model"), "fd_model",
    season = season
  )
  if (!"distance" %in% names(prepared)) {
    cli::cli_abort(
      "{.fn calculate_fourth_down} needs a {.code distance} column to compute conversion probability."
    )
  }
  probs <- .cfb_predict_from_card(prepared, "fd_model", .cfb_booster_for("fd_model"))
  n <- nrow(prepared)
  # Class k is a gain of k - 10 yards, spanning -10..65 (76 classes).
  n_class <- 76L
  # xgboost returns an n x 76 matrix here already. Flattening with as.numeric()
  # and rebuilding byrow reassembles it column-major and silently scrambles the
  # classes -- it produced a "probability" of 1.75. Only reshape a flat vector,
  # the same guard .ep_predict() applies.
  m <- if (is.matrix(probs) && ncol(probs) == n_class) {
    probs
  } else {
    matrix(as.numeric(probs), nrow = n, ncol = n_class, byrow = TRUE)
  }
  gains <- seq_len(n_class) - 11L
  prepared[["fd_expected_yards"]] <- as.numeric(m %*% gains)
  need <- as.numeric(prepared[["distance"]])
  prepared[["fd_conversion_prob"]] <- vapply(
    seq_len(n), function(i) sum(m[i, gains >= need[i]]), numeric(1)
  )
  prepared
}

#' @rdname calculate_cfb_models
#' @return [calculate_qbr()] - `df` with one column appended:
#'
#'  |col_name |types   |description        |
#'  |:--------|:-------|:------------------|
#'  |qbr      |numeric |Model QBR.         |
#'
#' @export
#' @examples
#' \donttest{
#'   try(calculate_qbr(data.frame(season = 2024, qbr_epa = 0.1, sack_epa = -0.2,
#'     pass_epa = 0.3, rush_epa = 0.05, pen_epa = 0, spread = -3)))
#' }
calculate_qbr <- function(df, season = NULL) {
  .cfb_calculate(df, "qbr_model", "qbr", season = season)
}

#' @rdname calculate_cfb_models
#' @return [calculate_expected_points()] - `df` with eight columns appended:
#'
#'  |col_name     |types   |description                                             |
#'  |:------------|:-------|:-------------------------------------------------------|
#'  |No_Score     |numeric |Probability the next score is none.                     |
#'  |FG           |numeric |Probability the next score is a field goal.             |
#'  |Opp_FG       |numeric |Probability the next score is an opponent field goal.   |
#'  |Opp_Safety   |numeric |Probability the next score is an opponent safety.       |
#'  |Opp_TD       |numeric |Probability the next score is an opponent touchdown.    |
#'  |Safety       |numeric |Probability the next score is a safety.                 |
#'  |TD           |numeric |Probability the next score is a touchdown.              |
#'  |ep           |numeric |Expected points: the class probabilities weighted by their point values. |
#'
#' Class order follows [.EP_LEV], which is **not** the ordering
#' `sportsdataverse-py` uses. Scoring goes through `.ep_predict()`, which applies
#' the bundle's own class permutation -- reimplementing the reshape here would
#' produce every column present and every value mis-assigned.
#'
#' @export
#' @examples
#' \donttest{
#'   try(calculate_expected_points(data.frame(TimeSecsRem = 1800,
#'     yards_to_goal = 75, distance = 10, down_1 = 1, down_2 = 0, down_3 = 0,
#'     down_4 = 0, pos_score_diff_start = 0)))
#' }
calculate_expected_points <- function(df, season = NULL) {
  prepared <- cfb_add_era_columns(
    .cfb_normalize_pbp_columns(df, "ep_model"), "ep_model",
    season = season
  )
  # Validate against `.ep_feature_matrix()`'s contract, NOT the card's feature
  # list. The card declares the post-one-hot names (down_1..down_4) because that
  # is what the booster was trained on, but the R scorer takes a plain `down`
  # column and builds the indicators itself. Checking the card here would demand
  # columns `.ep_predict()` never wants.
  if (!"down" %in% names(prepared)) {
    onehots <- intersect(.CFB_DOWN_ONE_HOTS, names(prepared))
    if (length(onehots) > 0L) {
      # recover `down` from indicators, so a frame shaped for the Python
      # calculators is accepted here too
      idx <- as.integer(sub("^down_", "", onehots))
      prepared[["down"]] <- Reduce(
        function(a, b) a + b,
        Map(function(col, i) as.integer(prepared[[col]] == 1L) * i, onehots, idx)
      )
    }
  }
  need <- c("TimeSecsRem", "yards_to_goal", "distance", "down", "pos_score_diff_start")
  missing <- setdiff(need, names(prepared))
  if (length(missing) > 0L) {
    cli::cli_abort(c(
      "ep_model needs {length(missing)} column{?s} not present in the data.",
      "x" = "Missing: {.val {missing}}",
      "i" = "The bundled EP model needs {.val {need}}."
    ))
  }
  probs <- .ep_predict(.cfb_ep_model(), prepared)
  # Positional weights matching .EP_LEV, as used by .pbp_create_epa().
  weights <- c(0, 3, -3, -2, -7, 2, 7)
  prepared[names(probs)] <- probs
  prepared[["ep"]] <- as.numeric(as.matrix(probs) %*% weights)
  prepared
}

#' @keywords internal
#' @noRd
.cfb_ep_model <- function() .cfb_booster_for("ep_model")

#' @rdname calculate_cfb_models
#' @return [calculate_win_probability()] - `df` with one column appended:
#'
#'  |col_name |types   |description                                   |
#'  |:--------|:-------|:---------------------------------------------|
#'  |wp       |numeric |Win probability for the possessing team (0-1). |
#'
#' Uses `wp_spread` when the frame carries a `spread_time` column and `wp_naive`
#' otherwise -- the naive model is the spread model minus that single feature, so
#' the presence of spread information is what decides which contract applies.
#'
#' @export
#' @examples
#' \donttest{
#'   try(calculate_win_probability(cfbd_pbp_data(2024, week = 5)))
#' }
calculate_win_probability <- function(df, season = NULL) {
  model <- if ("spread_time" %in% names(df) || "start.spread_time" %in% names(df)) {
    "wp_spread"
  } else {
    "wp_naive"
  }
  .cfb_calculate(df, model, "wp", season = season)
}

#' @rdname calculate_cfb_models
#' @return [calculate_epa()] - `df` with `ep` (when it was absent) and `epa`
#'   appended.
#'
#'  |col_name |types   |description                                  |
#'  |:--------|:-------|:--------------------------------------------|
#'  |epa      |numeric |Expected points added: `ep_end` minus `ep`.  |
#'
#' Requires an `ep_end` column -- the expected points after the play. EPA is a
#' difference and this scores rows rather than sequences, so inventing `ep_end`
#' would produce a number that looks like EPA and is not.
#'
#' @export
#' @examples
#' \donttest{
#'   try(calculate_epa(data.frame(ep = 2, ep_end = 5)))
#' }
calculate_epa <- function(df, season = NULL) {
  if (!"ep_end" %in% names(df)) {
    cli::cli_abort(c(
      "{.fn calculate_epa} needs an {.code ep_end} column (expected points after the play).",
      "i" = "EPA is a difference, and this scores rows rather than sequences."
    ))
  }
  out <- if ("ep" %in% names(df)) df else calculate_expected_points(df, season = season)
  out[["epa"]] <- out[["ep_end"]] - out[["ep"]]
  out
}

#' @rdname calculate_cfb_models
#' @return [calculate_wpa()] - `df` with `wp` (when it was absent) and `wpa`
#'   appended.
#'
#'  |col_name |types   |description                                     |
#'  |:--------|:-------|:-----------------------------------------------|
#'  |wpa      |numeric |Win probability added: `wp_end` minus `wp`.     |
#'
#' Requires a `wp_end` column, for the same reason [calculate_epa()] requires
#' `ep_end`.
#'
#' @export
#' @examples
#' \donttest{
#'   try(calculate_wpa(data.frame(wp = 0.4, wp_end = 0.6)))
#' }
calculate_wpa <- function(df, season = NULL) {
  if (!"wp_end" %in% names(df)) {
    cli::cli_abort(c(
      "{.fn calculate_wpa} needs a {.code wp_end} column (win probability after the play).",
      "i" = "WPA is a difference, and this scores rows rather than sequences."
    ))
  }
  out <- if ("wp" %in% names(df)) df else calculate_win_probability(df, season = season)
  out[["wpa"]] <- out[["wp_end"]] - out[["wp"]]
  out
}
