#' QBR from a modeled play-by-play frame
#'
#' @description Port of the bundled `qbr_model` surface by way of
#'   `sportsdataverse-py`'s `CFBPlayProcess.__process_qbr()`. Unlike the other
#'   bundle artifacts this one does not score a play: its features are per-QB
#'   per-game weighted aggregates, so it emits a different table than the
#'   play-by-play frame it is given.
#'
#' @keywords internal
#' @noRd
NULL

#' QBR model feature contract
#'
#' Uses the ONE-HOT rule era ([.cfb_era_onehot()], cuts 2006/2013/2020) -- the
#' same encoding the fourth-down and field-goal models take, not the ordinal era
#' the xpass and two-point models take.
#'
#' @keywords internal
#' @noRd
.QBR_FEATURES <- c("qbr_epa", "sack_epa", "pass_epa", "rush_epa", "pen_epa",
                   "spread", "era0", "era1", "era2", "era3")

#' Lazily load the bundled QBR model
#' @keywords internal
#' @noRd
.cfb_qbr_model <- function() {
  if (!is.null(.cfb_model_env$qbr_model)) return(.cfb_model_env$qbr_model)
  if (isTRUE(.cfb_model_env$unavailable[["qbr_model"]])) return(NULL)
  fail <- function() {
    .cfb_model_env$unavailable[["qbr_model"]] <- TRUE
    NULL
  }
  if (!requireNamespace("xgboost", quietly = TRUE)) return(fail())
  f <- .cfb_model_file("qbr_model.ubj")
  if (is.null(f)) return(fail())
  b <- try(xgboost::xgb.load(f), silent = TRUE)
  if (inherits(b, "try-error") || is.null(b)) return(fail())
  .cfb_model_env$qbr_model <- b
  b
}

#' Leverage weight for a play
#'
#' QBR discounts garbage time. A play taken with the game already decided counts
#' 0.6, one taken while it is nearly decided counts 0.9, and everything in the
#' competitive middle counts fully.
#'
#' The bands are asymmetric at their edges by construction, not by oversight:
#' `home_wp_before` of exactly 0.9 falls through to 1 because the low band is
#' half-open (`>= 0.8` and `< 0.9`) and the high band is strict (`> 0.9`). That
#' is the reference implementation's own boundary and is reproduced here so the
#' aggregates agree play for play.
#'
#' @keywords internal
#' @noRd
.qbr_weight <- function(home_wp_before) {
  wp <- suppressWarnings(as.numeric(home_wp_before))
  w <- rep(1, length(wp))
  w[!is.na(wp) & wp >= 0.1 & wp < 0.2] <- 0.9
  w[!is.na(wp) & wp >= 0.8 & wp < 0.9] <- 0.9
  w[!is.na(wp) & wp < 0.1] <- 0.6
  w[!is.na(wp) & wp > 0.9] <- 0.6
  w
}

#' Clipped EPA the QBR aggregates are built from
#'
#' A single catastrophic play should not swamp a quarterback's game, so EPA is
#' floored at -5, and a fumble is charged a flat -3.5 regardless of what the
#' play's EPA came out to.
#'
#' @keywords internal
#' @noRd
.qbr_epa <- function(df) {
  epa <- suppressWarnings(as.numeric(df$EPA))
  fumble <- .qbr_flag(df, "fumble_vec")
  ifelse(!is.na(epa) & epa < -5, -5,
         ifelse(fumble, -3.5, epa))
}

#' Read a play-by-play flag as logical, absent column included
#' @keywords internal
#' @noRd
.qbr_flag <- function(df, nm) {
  if (!nm %in% names(df)) return(rep(FALSE, nrow(df)))
  v <- df[[nm]]
  if (is.logical(v)) return(!is.na(v) & v)
  suppressWarnings(as.numeric(v)) %in% 1
}

#' Weighted mean that reports "no plays" rather than inventing a zero
#'
#' A quarterback who was never sacked has no sack EPA. Returning `NA` is not a
#' gap to be filled: it is what the training frame carried for that cell (the
#' reference implementation's 0/0 produces `NaN`, which its null-fill does not
#' touch), and `xgboost` routes it down its own missing-value branch. Filling it
#' with 0 would instead assert that the quarterback was sacked for exactly zero
#' expected points.
#'
#' @keywords internal
#' @noRd
.qbr_weighted_mean <- function(x, w) {
  keep <- !is.na(x) & !is.na(w)
  denom <- sum(w[keep])
  if (!length(denom) || denom == 0) return(NA_real_)
  sum(x[keep] * w[keep]) / denom
}

#' Calculate QBR for each quarterback in a modeled play-by-play frame
#'
#' @description Aggregates a modeled play-by-play frame into the per-quarterback,
#' per-game weighted EPA components the bundled `qbr_model` takes, and scores it.
#'
#' The five EPA components are leverage-weighted means over the plays a
#' quarterback was involved in: every play (`qbr_epa`), non-fumble sacks
#' (`sack_epa`), passes (`pass_epa`), rushes (`rush_epa`) and penalties
#' (`pen_epa`). The weight discounts garbage time: a play taken with the game
#' already decided (`home_wp_before` below 0.1 or above 0.9) counts 0.6, one
#' taken while it is nearly decided (0.1 to 0.2, or 0.8 to 0.9) counts 0.9, and
#' everything in the competitive middle counts fully. The EPA feeding them is
#' clipped at -5, with a flat -3.5 charged for a fumble.
#'
#' Only players who actually threw a pass are included; a running back's carries
#' are aggregated into the quarterback's line only when that player also attempted
#' a pass in the game.
#'
#' @param play_df A modeled play-by-play data frame, as returned by
#'   [cfbd_pbp_data()] or [espn_cfb_pbp()]. Must carry `EPA`, `home_wp_before`,
#'   the `pass` / `rush` / `sack_vec` / `fumble_vec` / `penalty_flag` play flags,
#'   `passer_player_name` / `rusher_player_name` and `pos_team`. `spread` and
#'   `home` are additionally needed for the `spread` feature.
#' @param qbr_model Optional pre-loaded `xgb.Booster`. Defaults to the bundled
#'   `qbr_model.ubj` from the shared `cfb_model_artifacts` release.
#' @param season Optional season, used for the one-hot rule era when the frame
#'   carries no `season` column.
#'
#' @return A data frame, one row per quarterback per game, with:
#'
#'    |col_name        |types     |
#'    |:---------------|:---------|
#'    |game_id         |character |
#'    |pos_team        |character |
#'    |athlete_name    |character |
#'    |plays           |integer   |
#'    |qbr_epa         |double    |
#'    |sack_epa        |double    |
#'    |pass_epa        |double    |
#'    |rush_epa        |double    |
#'    |pen_epa         |double    |
#'    |spread          |double    |
#'    |era0            |double    |
#'    |era1            |double    |
#'    |era2            |double    |
#'    |era3            |double    |
#'    |exp_qbr         |double    |
#'
#'   A component with no qualifying plays is `NA` rather than 0 -- that is the
#'   missing-value branch the model was trained against. `exp_qbr` is `NA` when
#'   the bundled model or `xgboost` is unavailable; probabilities and ratings are
#'   never fabricated. A frame with no identifiable quarterbacks returns a
#'   zero-row frame carrying this schema.
#'
#' @examples
#' \donttest{
#'   try({
#'     pbp <- cfbfastR::cfbd_pbp_data(2021, week = 6, team = "Texas", epa_wpa = TRUE)
#'     create_qbr(pbp)
#'   })
#' }
#'
#' @export
create_qbr <- function(play_df, qbr_model = NULL, season = NULL) {
  empty <- data.frame(
    game_id = character(), pos_team = character(), athlete_name = character(),
    plays = integer(), qbr_epa = double(), sack_epa = double(),
    pass_epa = double(), rush_epa = double(), pen_epa = double(),
    spread = double(), era0 = double(), era1 = double(), era2 = double(),
    era3 = double(), exp_qbr = double(), stringsAsFactors = FALSE
  ) |>
    janitor::clean_names() |>
    make_cfbfastR_data("QBR data", Sys.time())
  if (!is.data.frame(play_df) || !nrow(play_df)) return(empty)
  if (!all(c("EPA", "passer_player_name") %in% names(play_df))) {
    cli::cli_abort(c(
      "{.arg play_df} does not look like a modeled play-by-play frame.",
      x = "It is missing {.field EPA} and/or {.field passer_player_name}.",
      i = "Pass the output of {.fn cfbd_pbp_data} or {.fn espn_cfb_pbp} with EPA/WPA enabled."
    ))
  }

  passer <- as.character(play_df$passer_player_name)
  rusher <- if ("rusher_player_name" %in% names(play_df)) {
    as.character(play_df$rusher_player_name)
  } else {
    rep(NA_character_, nrow(play_df))
  }
  is_pass <- .qbr_flag(play_df, "pass")
  is_rush <- .qbr_flag(play_df, "rush")

  # Only quarterbacks, decided PER GAME AND TEAM rather than by name across the
  # whole frame. A name-only set lets a quarterback who threw in one game but
  # only carried in another produce a QBR row for that second game with no pass
  # attempt in it, and merges two same-named players on different teams.
  gkey <- .qbr_game_key(play_df)
  pos <- as.character(play_df$pos_team)
  eligible <- unique(
    paste(gkey, pos, passer, sep = "\r")[is_pass & !is.na(passer)]
  )
  if (!length(eligible)) return(empty)

  athlete <- ifelse(!is.na(passer), passer, rusher)
  # cfbfastR carries no `scrimmage_play` column, so it is taken as pass-or-rush
  # -- the same substitution the CP surface makes.
  keep <- !is.na(athlete) & (is_pass | is_rush) &
    paste(gkey, pos, athlete, sep = "\r") %in% eligible
  if (!any(keep)) return(empty)

  epa <- .qbr_epa(play_df)
  weight <- .qbr_weight(if ("home_wp_before" %in% names(play_df)) {
    play_df$home_wp_before
  } else {
    rep(NA_real_, nrow(play_df))
  })
  # A sack that ends in a fumble is already charged the flat fumble penalty; it
  # is not additionally counted as a sack.
  non_fumble_sack <- .qbr_flag(play_df, "sack_vec") & !.qbr_flag(play_df, "fumble_vec")
  is_pen <- .qbr_flag(play_df, "penalty_flag")

  spread <- .wp_pos_team_spread(play_df)
  if (is.null(spread)) spread <- rep(NA_real_, nrow(play_df))
  seasons <- if ("season" %in% names(play_df)) {
    suppressWarnings(as.numeric(as.character(play_df$season)))
  } else {
    rep(suppressWarnings(as.numeric(season))[1] %||% NA_real_, nrow(play_df))
  }
  game_id <- if ("game_id" %in% names(play_df)) {
    as.character(play_df$game_id)
  } else {
    rep(NA_character_, nrow(play_df))
  }

  dat <- data.frame(
    game_id = game_id[keep],
    gkey = gkey[keep],
    pos_team = as.character(play_df$pos_team)[keep],
    athlete_name = athlete[keep],
    epa = epa[keep],
    weight = weight[keep],
    is_pass = is_pass[keep],
    is_rush = is_rush[keep],
    is_sack = non_fumble_sack[keep],
    is_pen = is_pen[keep],
    spread = spread[keep],
    season = seasons[keep],
    stringsAsFactors = FALSE
  )
  # Group on the sentinel-backed key, never on `game_id` itself: `split()` drops
  # every row whose factor level is NA, so a frame with no game id split into
  # nothing, `rbind` returned NULL, and the documented one-game fallback died on
  # the next line instead of returning a table.
  grp <- interaction(dat$gkey, dat$pos_team, dat$athlete_name,
                     drop = TRUE, sep = "\r")
  split_rows <- split(seq_len(nrow(dat)), grp)

  out <- do.call(rbind, lapply(split_rows, function(i) {
    d <- dat[i, , drop = FALSE]
    masked <- function(flag) .qbr_weighted_mean(ifelse(flag, d$epa, NA_real_),
                                                ifelse(flag, d$weight, NA_real_))
    data.frame(
      game_id = d$game_id[1], gkey = d$gkey[1], pos_team = d$pos_team[1],
      athlete_name = d$athlete_name[1], plays = nrow(d),
      qbr_epa = .qbr_weighted_mean(d$epa, d$weight),
      sack_epa = masked(d$is_sack),
      pass_epa = masked(d$is_pass),
      rush_epa = masked(d$is_rush),
      pen_epa = masked(d$is_pen),
      spread = d$spread[1],
      season = suppressWarnings(max(d$season, na.rm = TRUE)),
      stringsAsFactors = FALSE
    )
  }))
  rownames(out) <- NULL
  out$season[!is.finite(out$season)] <- NA_real_
  out <- cbind(out[, setdiff(names(out), "season")],
               .cfb_era_onehot(out$season, nrow(out)))
  out$exp_qbr <- .qbr_predict(out, qbr_model = qbr_model)
  # Order on the sentinel key so an absent game_id does not sort to the end.
  out <- out[order(out$gkey, out$pos_team, -out$plays), names(empty)]
  out |>
    janitor::clean_names() |>
    make_cfbfastR_data("QBR data", Sys.time())
}

#' Grouping key that survives an absent `game_id`
#'
#' A frame with no `game_id` is treated as ONE game rather than silently pooling
#' across games -- the aggregates are per-QB-per-GAME, and merging two games into
#' one row is a wrong number, not a missing one. The sentinel exists because
#' `split()` DROPS rows whose grouping level is `NA` rather than grouping them,
#' so keying on `game_id` directly turned that documented fallback into an
#' error. `game_id` itself stays `NA` in the returned table.
#'
#' @keywords internal
#' @noRd
.qbr_game_key <- function(df) {
  if (!"game_id" %in% names(df)) return(rep("<single-game>", nrow(df)))
  g <- as.character(df$game_id)
  ifelse(is.na(g), "<single-game>", g)
}

#' Score the bundled QBR model on an aggregate frame
#'
#' @return Numeric, `nrow(agg)` long; all `NA` when the model is unavailable or
#'   the era could not be determined.
#' @keywords internal
#' @noRd
.qbr_predict <- function(agg, qbr_model = NULL) {
  n <- nrow(agg)
  if (!n) return(numeric(0))
  model <- if (is.null(qbr_model)) .cfb_qbr_model() else qbr_model
  # Anything that is not a booster -- an unavailable bundle, or a caller passing
  # the wrong object -- yields NA ratings rather than a partly-scored table.
  if (!inherits(model, "xgb.Booster")) return(rep(NA_real_, n))
  x <- as.matrix(agg[, .QBR_FEATURES, drop = FALSE])
  storage.mode(x) <- "double"
  colnames(x) <- .QBR_FEATURES
  p <- try(as.numeric(stats::predict(model, x)), silent = TRUE)
  if (inherits(p, "try-error") || length(p) != n) return(rep(NA_real_, n))
  p
}
