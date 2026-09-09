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

#' @keywords internal
#' @noRd
.cfb_normalize_pbp_columns <- function(df, model) {
  for (feature in cfb_card_features(model)) {
    if (feature %in% names(df)) next
    for (source in .CFB_PBP_ALIASES[[feature]]) {
      if (!is.null(source) && source %in% names(df)) {
        # copy, never rename: nothing the caller passed in is removed
        df[[feature]] <- df[[source]]
        break
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
  yr <- if (!is.null(df$season)) {
    df$season
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
