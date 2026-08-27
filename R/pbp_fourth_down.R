#' Fourth-down decision surface
#'
#' @description Port of cfb4th's fourth-down model by way of
#'   `sportsdataverse-py`'s `cfb_fourth_down`. Each branch -- go for it, punt,
#'   kick -- is scored as a win probability so they can be compared directly.
#'
#' @details The GO branch is the novel one: `fd_model` is not a probability but
#'   a **76-class distribution over yards gained** (-10 to +65). Each play is
#'   expanded to one row per possible gain, the resulting game state is built
#'   for every outcome, EP and WP are scored there, and the results are folded
#'   back weighted by each outcome's probability.
#'
#' @keywords internal
#' @noRd
NULL

#' Fourth-down model feature contract, class count and gain offset
#'
#' Uses the ONE-HOT rule era ([.cfb_era_onehot()], cuts 2006/2013/2020) -- not
#' the ordinal era the xpass and two-point models take.
#'
#' @keywords internal
#' @noRd
.FD_FEATURES <- c("down", "distance", "yards_to_goal",
                  "posteam_total", "posteam_spread",
                  "era0", "era1", "era2", "era3")

#' @keywords internal
#' @noRd
.FD_NUM_CLASS <- 76L

#' Class 0 of the fourth-down model is a TEN YARD LOSS, not a gain of zero.
#' @keywords internal
#' @noRd
.FD_GAIN_OFFSET <- -10L

#' Lazily load the bundled fourth-down yardage model
#' @keywords internal
#' @noRd
.cfb_fd_model <- function() {
  if (!is.null(.cfb_model_env$fd_model)) return(.cfb_model_env$fd_model)
  if (isTRUE(.cfb_model_env$unavailable[["fd_model"]])) return(NULL)
  fail <- function() {
    .cfb_model_env$unavailable[["fd_model"]] <- TRUE
    NULL
  }
  if (!requireNamespace("xgboost", quietly = TRUE)) return(fail())
  f <- .cfb_model_file("fd_model.ubj")
  if (is.null(f)) return(fail())
  b <- try(xgboost::xgb.load(f), silent = TRUE)
  if (inherits(b, "try-error") || is.null(b)) return(fail())
  .cfb_model_env$fd_model <- b
  b
}

#' The 76-class yards-gained distribution for each fourth-down state
#'
#' @return Matrix, `nrow(st)` x 76, or `NULL` when the model or the season is
#'   unavailable.
#' @keywords internal
#' @noRd
.fd_gain_distribution <- function(st) {
  model <- .cfb_fd_model()
  if (is.null(model)) return(NULL)
  if (all(is.na(st$season))) return(NULL)
  x <- cbind(
    down = st$down,
    distance = st$distance,
    yards_to_goal = st$yards_to_goal,
    posteam_total = st$posteam_total,
    posteam_spread = st$pos_team_spread,
    .cfb_era_onehot(st$season, nrow(st))
  )
  colnames(x) <- .FD_FEATURES
  p <- try(stats::predict(model, x), silent = TRUE)
  if (inherits(p, "try-error")) return(NULL)
  if (!is.matrix(p) || ncol(p) != .FD_NUM_CLASS) {
    p <- matrix(as.numeric(p), ncol = .FD_NUM_CLASS, byrow = TRUE)
  }
  if (nrow(p) != nrow(st)) return(NULL)
  p
}

#' Kneel-out clamps (cfb4th `end_game_fn`)
#'
#' When the team holding the ball leads and the defence can no longer stop the
#' clock, the game is decided: pin the win probability rather than letting the
#' model regress it toward a comeback that cannot happen.
#'
#' Every condition is read off the RESULTING state, not the pre-play one:
#' `leading`, `def_to` and `adj` all describe the team that ends up holding the
#' ball. cfb4th's own `end_game_fn` gates additionally on `period == 4`; its
#' inline go-for-it clamps do not, so `period` is optional here and each caller
#' passes what its branch of cfb4th passes.
#'
#' @param wp Win probabilities to clamp.
#' @param leading Logical: does the team whose WP this is hold the lead?
#' @param adj Adjusted seconds remaining in the resulting state.
#' @param def_to Defensive timeouts remaining in the resulting state.
#' @param value What a clamped row is pinned to.
#' @param period Period of the resulting state; when supplied, only the fourth
#'   quarter clamps (cfb4th `end_game_fn`). `NULL` clamps in any period (the
#'   go-for-it branch).
#' @keywords internal
#' @noRd
.fd_kneel_clamp <- function(wp, leading, adj, def_to, value, period = NULL) {
  if (!is.null(period)) leading <- leading & !is.na(period) & period == 4
  wp <- ifelse(leading & adj < 120 & def_to == 0, value, wp)
  wp <- ifelse(leading & adj < 80 & def_to == 1, value, wp)
  ifelse(leading & adj < 40 & def_to == 2, value, wp)
}

#' Win probability of going for it on fourth down
#'
#' @return data.frame with `go_wp`, `first_down_prob`, `wp_succeed`, `wp_fail`.
#'   The conditional columns are `NA` for degenerate goal-line plays where one
#'   outcome bucket is empty, matching the reference implementation.
#' @keywords internal
#' @noRd
.fd_go_wp <- function(st) {
  n <- nrow(st)
  empty <- data.frame(go_wp = rep(NA_real_, n), first_down_prob = rep(NA_real_, n),
                      wp_succeed = rep(NA_real_, n), wp_fail = rep(NA_real_, n))
  if (!n) return(empty)
  probs <- .fd_gain_distribution(st)
  if (is.null(probs)) return(empty)

  # ---- expand to one row per (play, possible gain) ----
  play_idx <- rep(seq_len(n), each = .FD_NUM_CLASS)
  gain <- rep(seq_len(.FD_NUM_CLASS) + .FD_GAIN_OFFSET - 1L, times = n)
  prob <- as.numeric(t(probs))
  ytg0 <- st$yards_to_goal[play_idx]

  # A gain cannot pass the goal line, and cannot push the offence back through
  # its own end zone. Both cap onto an ALREADY EXISTING bucket, so the capped
  # probability mass has to be combined rather than counted twice.
  gain <- ifelse(gain > ytg0, ytg0, gain)
  gain <- ifelse(ytg0 - gain >= 100, ytg0 - 99, gain)
  agg <- stats::aggregate(list(prob = prob),
                          by = list(play_idx = play_idx, gain = gain), FUN = sum)
  agg <- agg[order(agg$play_idx, agg$gain), , drop = FALSE]
  play_idx <- agg$play_idx
  gain <- agg$gain
  prob <- agg$prob

  s <- st[play_idx, , drop = FALSE]
  ytg <- s$yards_to_goal - gain
  # `distance` is clamped to the goal line before the comparison. On a row that
  # ships `distance > yards_to_goal` the capped gain reaches the end zone but
  # still falls short of `distance`, so the touchdown is classified a TURNOVER
  # and the state becomes a first down at the offence's own goal line -- every
  # outcome lands in the failure bucket and `first_down_prob` reads 0. cfb4th
  # compares against the raw `distance`; this is a deliberate divergence,
  # because the state it produces is not a state the game can be in.
  turnover <- as.integer(gain < pmin(s$distance, s$yards_to_goal))
  to_mask <- turnover == 1L
  # A failed conversion hands the ball over where it sits, seen from the other
  # end of the field.
  ytg <- ifelse(to_mask, 100 - ytg, ytg)

  pos_to <- s$pos_team_timeouts_rem_before
  def_to <- s$def_pos_team_timeouts_rem_before
  new_pos_to <- ifelse(to_mask, def_to, pos_to)
  new_def_to <- ifelse(to_mask, pos_to, def_to)
  first_half <- !is.na(s$period) & s$period <= 2
  recv <- s$pos_team_receives_2H_kickoff
  recv <- ifelse(first_half & recv %in% 0 & to_mask, 1, recv)
  recv <- ifelse(first_half & recv %in% 1 & to_mask, 0, recv)
  is_home <- ifelse(to_mask, 1 - s$is_home, s$is_home)
  spread <- ifelse(to_mask, -s$pos_team_spread, s$pos_team_spread)
  pos_diff <- ifelse(to_mask, -s$pos_score_diff_start, s$pos_score_diff_start)

  # A touchdown scores six and hands off for the kickoff -- the same possession
  # bookkeeping again, layered on top of any turnover flip.
  td_mask <- ytg == 0
  pos_diff <- ifelse(td_mask, -pos_diff - 6, pos_diff)
  ytg <- ifelse(td_mask, 75, ytg)
  td_pos_to <- ifelse(td_mask, new_def_to, new_pos_to)
  td_def_to <- ifelse(td_mask, new_pos_to, new_def_to)
  new_pos_to <- td_pos_to
  new_def_to <- td_def_to
  recv <- ifelse(first_half & recv %in% 0 & td_mask, 1, recv)
  recv <- ifelse(first_half & recv %in% 1 & td_mask, 0, recv)
  is_home <- ifelse(td_mask, 1 - is_home, is_home)
  spread <- ifelse(td_mask, -spread, spread)

  s$yards_to_goal <- ytg
  s$distance <- ifelse(ytg < 10, ytg, 10)
  s$down <- 1
  s$pos_team_timeouts_rem_before <- new_pos_to
  s$def_pos_team_timeouts_rem_before <- new_def_to
  s$pos_team_receives_2H_kickoff <- recv
  s$is_home <- is_home
  s$pos_team_spread <- spread
  s$pos_score_diff_start <- pos_diff
  s$TimeSecsRem <- pmax(s$TimeSecsRem - 6, 0)
  s$adj_TimeSecsRem <- pmax(s$adj_TimeSecsRem - 6, 0)

  wp <- .state_wp(s)
  # Wherever possession changed hands, the scored WP belongs to the other team.
  wp <- ifelse(is_home != st$is_home[play_idx], 1 - wp, wp)

  # Kneel-out. Both conditions read the RESULTING state's `pos_diff`, which the
  # turnover branch above has already negated -- so on a failed conversion
  # `pos_diff > 0` means the team that just TOOK the ball leads and can kneel it
  # out, which is why the offence's win probability goes to zero. Reading it as
  # `pos_diff < 0` inverts the rule: it pins a team that just turned the ball
  # over while LEADING to a certain loss (cfb4th `decision_functions.R:365-367`,
  # and sdv-py has the inverted form).
  succ_alive <- turnover == 0L & !td_mask & ytg > 0 & pos_diff > 0
  wp <- .fd_kneel_clamp(wp, succ_alive, s$adj_TimeSecsRem, new_def_to, 1)
  fail_lead <- turnover == 1L & pos_diff > 0
  wp <- .fd_kneel_clamp(wp, fail_lead, s$adj_TimeSecsRem, new_def_to, 0)

  # ---- fold back, weighted by each outcome's probability ----
  go_wp <- tapply(prob * wp, play_idx, sum)
  pct_succ <- tapply(prob * (turnover == 0L), play_idx, sum)
  wsum_succ <- tapply(prob * wp * (turnover == 0L), play_idx, sum)
  pct_fail <- tapply(prob * (turnover == 1L), play_idx, sum)
  wsum_fail <- tapply(prob * wp * (turnover == 1L), play_idx, sum)
  idx <- as.integer(names(go_wp))

  out <- empty
  out$go_wp[idx] <- as.numeric(go_wp)
  out$first_down_prob[idx] <- as.numeric(pct_succ)
  # An empty outcome bucket has no conditional WP -- NA, not a fabricated zero.
  out$wp_succeed[idx] <- ifelse(as.numeric(pct_succ) > 0,
                                as.numeric(wsum_succ) / as.numeric(pct_succ), NA_real_)
  out$wp_fail[idx] <- ifelse(as.numeric(pct_fail) > 0,
                             as.numeric(wsum_fail) / as.numeric(pct_fail), NA_real_)
  out
}

#' The bundled punt end-yardline distribution
#'
#' cfb4th does not model a punt; it joins an empirical distribution of where
#' the ball ends up, keyed on the punting team's `yards_to_goal`, and averages
#' the resulting win probabilities weighted by `pct`. The table covers
#' `yards_to_goal` 31-99 only -- inside the 31 punting is dominated and cfb4th's
#' left join simply produces `NA`, which is the behaviour reproduced here.
#'
#' `arrow` is a Suggests, not an Imports, so an installation without it must
#' leave `punt_wp` `NA` rather than abort the play-by-play pipeline.
#'
#' @return data.frame with `yards_to_goal`, `yards_to_goal_end`, `pct`, or
#'   `NULL` when the asset or a parquet reader is unavailable.
#' @keywords internal
#' @noRd
.cfb_punt_distribution <- function() {
  if (!is.null(.cfb_model_env$punt_dist)) return(.cfb_model_env$punt_dist)
  if (isTRUE(.cfb_model_env$unavailable[["punt_dist"]])) return(NULL)
  fail <- function() {
    .cfb_model_env$unavailable[["punt_dist"]] <- TRUE
    NULL
  }
  if (!requireNamespace("arrow", quietly = TRUE)) return(fail())
  f <- .cfb_model_file("punt_distribution.parquet")
  if (is.null(f)) return(fail())
  d <- try(as.data.frame(arrow::read_parquet(f)), silent = TRUE)
  need <- c("yards_to_goal", "yards_to_goal_end", "pct")
  if (inherits(d, "try-error") || !all(need %in% names(d))) return(fail())
  d <- data.frame(
    yards_to_goal = as.numeric(d$yards_to_goal),
    yards_to_goal_end = as.numeric(d$yards_to_goal_end),
    pct = as.numeric(d$pct)
  )
  .cfb_model_env$punt_dist <- d
  d
}

#' Win probability of punting
#'
#' Each play is joined to every end-yardline its distribution supports, the
#' receiving team's ensuing drive is scored at each one, and the results are
#' averaged weighted by `pct`.
#'
#' The rare return-touchdown rows (`yards_to_goal_end == 100`, carrying under
#' 0.2% of the mass) hand the ball straight back: everything the flip swapped is
#' swapped again so the punting team is the one receiving a kickoff, and the
#' seven points come off its differential. The clamp is applied to those rows
#' exactly as cfb4th applies it, even though possession did not change there.
#'
#' @return Numeric, `nrow(st)` long; `NA` where the play's field position has no
#'   punt distribution (inside the 31) or the table is unavailable.
#' @keywords internal
#' @noRd
.fd_punt_wp <- function(st) {
  n <- nrow(st)
  out <- rep(NA_real_, n)
  if (!n) return(out)
  pd <- .cfb_punt_distribution()
  if (is.null(pd)) return(out)

  key <- data.frame(play_idx = seq_len(n), yards_to_goal = st$yards_to_goal)
  long <- merge(key, pd, by = "yards_to_goal")
  if (!nrow(long)) return(out)
  long <- long[order(long$play_idx, long$yards_to_goal_end), , drop = FALSE]

  idx <- long$play_idx
  ytg_end <- long$yards_to_goal_end
  orig <- st[idx, , drop = FALSE]
  s <- .flip_team_state(orig)

  rtd <- ytg_end == 100
  s$yards_to_goal <- ifelse(rtd, 75, 100 - ytg_end)
  # Negating the ALREADY-FLIPPED differential and then subtracting seven leaves
  # the punting team's own lead minus the return touchdown. Negating the
  # punting team's differential instead (as sdv-py does) turns a 10-point lead
  # into a 17-point deficit.
  s$pos_score_diff_start <- ifelse(rtd, -s$pos_score_diff_start - 7,
                                   s$pos_score_diff_start)
  for (nm in c("is_home", "pos_team_spread", "pos_team_receives_2H_kickoff",
               "pos_team_timeouts_rem_before",
               "def_pos_team_timeouts_rem_before")) {
    s[[nm]] <- ifelse(rtd, orig[[nm]], s[[nm]])
  }
  s$distance <- ifelse(s$yards_to_goal < 10, s$yards_to_goal, 10)

  wp <- .state_wp(s)
  # Wherever possession actually changed hands, the scored WP belongs to the
  # receiving team and the punting team's is its complement.
  wp <- ifelse(!rtd, 1 - wp, wp)
  # cfb4th reads the clamp off the RESULTING frame: the team now holding the
  # ball leads, and the team it just took the ball from is out of timeouts, so
  # whoever is asking loses.
  wp <- .fd_kneel_clamp(wp, s$pos_score_diff_start > 0, s$adj_TimeSecsRem,
                        s$def_pos_team_timeouts_rem_before, 0, period = s$period)

  agg <- tapply(long$pct * wp, idx, sum)
  out[as.integer(names(agg))] <- as.numeric(agg)
  out
}

#' The loaded FG model, or NULL
#' @keywords internal
#' @noRd
.cfb_fg_model_or_null <- function() {
  m <- try(get("fg_model", envir = asNamespace("cfbfastR")), silent = TRUE)
  if (inherits(m, "try-error") || is.null(m)) return(NULL)
  m
}

#' Win probability of attempting a field goal
#'
#' Scores the two outcomes -- a make (kick off to the opponent at the 25, three
#' points up) and a miss (opponent takes over at the spot) -- and blends them by
#' the make probability.
#'
#' The make probability carries cfb4th's two post-clamps, which are policy
#' rather than model: zero beyond 42 `yards_to_goal` (about a 59-yard attempt),
#' and 0.9x from 35 out, because the fitted curve is optimistic in the long
#' band and the recommendation should be conservative there.
#'
#' @return data.frame with `fg_make_prob`, `make_fg_wp`, `miss_fg_wp`, `fg_wp`;
#'   all `NA` when the FG model or its inputs are unavailable. Probabilities are
#'   never fabricated.
#' @keywords internal
#' @noRd
.fd_fg_wp <- function(st, fg_model = NULL) {
  n <- nrow(st)
  empty <- data.frame(fg_make_prob = rep(NA_real_, n), make_fg_wp = rep(NA_real_, n),
                      miss_fg_wp = rep(NA_real_, n), fg_wp = rep(NA_real_, n))
  if (!n) return(empty)
  if (is.null(fg_model)) fg_model <- .cfb_fg_model_or_null()
  if (is.null(fg_model)) return(empty)

  # .fg_make_prob() aborts rather than silently zeroing the era dummies when the
  # season is missing. That is the right contract for the EPA path, which owns
  # the season; here the decision surface is additive, so the abort is caught
  # and turned into NA columns instead of taking the game down with it.
  make_prob <- try(
    .fg_make_prob(fg_model, data.frame(yards_to_goal = st$yards_to_goal),
                  season = st$season),
    silent = TRUE
  )
  if (inherits(make_prob, "try-error") || length(make_prob) != n) return(empty)

  ytg <- st$yards_to_goal
  make_prob <- ifelse(ytg > 42, 0, make_prob)
  make_prob <- ifelse(ytg >= 35, 0.9 * make_prob, make_prob)

  # Made: the opponent receives a touchback three points down.
  mk <- .flip_team_state(st)
  mk$yards_to_goal <- 75
  mk$distance <- 10
  mk$pos_score_diff_start <- mk$pos_score_diff_start - 3
  # The flip always changes possession here, so the kicking team's WP is the
  # complement of the frame's -- no is_home comparison needed (and none that
  # survives a missing is_home).
  wp_make <- 1 - .state_wp(mk)
  wp_make <- .fd_kneel_clamp(wp_make, mk$pos_score_diff_start > 0,
                             mk$adj_TimeSecsRem,
                             mk$def_pos_team_timeouts_rem_before, 0,
                             period = mk$period)

  # Missed: the opponent takes over at the spot, no closer to its own goal line
  # than the 20 (the touchback floor caps yards_to_goal at 80).
  ms <- .flip_team_state(st)
  miss_ytg <- pmin(pmax(100 - ytg, 1), 80)
  ms$yards_to_goal <- miss_ytg
  ms$distance <- ifelse(miss_ytg < 10, miss_ytg, 10)
  wp_miss <- 1 - .state_wp(ms)
  wp_miss <- .fd_kneel_clamp(wp_miss, ms$pos_score_diff_start > 0,
                             ms$adj_TimeSecsRem,
                             ms$def_pos_team_timeouts_rem_before, 0,
                             period = ms$period)

  data.frame(
    fg_make_prob = as.numeric(make_prob),
    make_fg_wp = as.numeric(wp_make),
    miss_fg_wp = as.numeric(wp_miss),
    fg_wp = as.numeric(make_prob * wp_make + (1 - make_prob) * wp_miss)
  )
}

#' Decision columns the fourth-down surface emits
#'
#' cfb4th calls the field-goal make probability `fg_make_prob`, but cfbfastR
#' already publishes a column of that name from the EPA path -- the make
#' probability of the field goal that was ACTUALLY attempted, on every attempt
#' row. The decision surface's is a different quantity (a hypothetical kick from
#' the current spot, carrying cfb4th's policy clamps) on a different row set, so
#' it is namespaced. Overwriting the existing column instead is not a name
#' clash you notice: it nulls a shipped column on every non-fourth-down play.
#'
#' @keywords internal
#' @noRd
.FD_NUMERIC_COLS <- c(
  "go_wp", "first_down_prob", "wp_succeed", "wp_fail",
  "fourth_down_fg_make_prob", "make_fg_wp", "miss_fg_wp", "fg_wp",
  "punt_wp", "go_boost", "go_wp_diff", "fg_wp_diff", "punt_wp_diff"
)

#' All three fourth-down options, plus the comparison between them
#'
#' cfb4th's `add_4th_probs()`. `go_boost` is its headline number: how many
#' percentage points of win probability going for it is worth against the better
#' of the two kicks. An unavailable punt scores as zero rather than dropping out
#' of that maximum -- inside the 31 the punt table is empty and punting is
#' dominated there anyway.
#'
#' The `*_wp_diff` columns are each option minus the recommended one, so the
#' recommendation's own diff is zero and the others are negative. They exist so
#' callers can apply their own threshold instead of acting on a bare `argmax`
#' that may be separated from second place by numerical noise.
#'
#' @return data.frame with [.FD_NUMERIC_COLS] plus
#'   `fourth_down_recommendation`.
#' @keywords internal
#' @noRd
.fd_probs <- function(st, fg_model = NULL) {
  n <- nrow(st)
  out <- as.data.frame(stats::setNames(
    replicate(length(.FD_NUMERIC_COLS), rep(NA_real_, n), simplify = FALSE),
    .FD_NUMERIC_COLS
  ))
  out$fourth_down_recommendation <- rep(NA_character_, n)
  if (!n) return(out)

  go <- .fd_go_wp(st)
  fg <- .fd_fg_wp(st, fg_model = fg_model)
  punt <- .fd_punt_wp(st)
  for (nm in names(go)) out[[nm]] <- go[[nm]]
  # .fd_fg_wp() keeps cfb4th's own column names; the pbp-facing name is
  # namespaced here -- see .FD_NUMERIC_COLS for why.
  names(fg)[names(fg) == "fg_make_prob"] <- "fourth_down_fg_make_prob"
  for (nm in names(fg)) out[[nm]] <- fg[[nm]]
  out$punt_wp <- punt

  opts <- cbind(go = out$go_wp, field_goal = out$fg_wp, punt = punt)
  # An option that could not be scored cannot be recommended, and -Inf is how it
  # loses every comparison without contaminating the maximum with NA.
  scored <- opts
  scored[is.na(scored)] <- -Inf
  best <- max.col(scored, ties.method = "first")
  best_wp <- scored[cbind(seq_len(n), best)]
  none <- is.infinite(best_wp)

  out$fourth_down_recommendation <- ifelse(none, NA_character_,
                                           colnames(opts)[best])
  best_wp[none] <- NA_real_
  out$go_wp_diff <- out$go_wp - best_wp
  out$fg_wp_diff <- out$fg_wp - best_wp
  out$punt_wp_diff <- punt - best_wp
  out$go_boost <- 100 * (out$go_wp -
                           pmax(out$fg_wp, ifelse(is.na(punt), 0, punt),
                                na.rm = TRUE))
  out
}

#' Rows where a fourth-down decision is actually faced
#'
#' cfb4th's `prepare_cfbfastr_data()` filter: real fourth downs, in regulation,
#' with a clock and a field position the models can score. The `adj_TimeSecsRem`
#' floor drops the dead plays at the very end of a half, where the ensuing-drive
#' states the surface builds are fiction.
#'
#' @keywords internal
#' @noRd
.fourth_down_decision_rows <- function(df) {
  num <- function(nm) {
    if (!nm %in% names(df)) return(rep(NA_real_, nrow(df)))
    suppressWarnings(as.numeric(as.character(df[[nm]])))
  }
  down <- num("down")
  ytg <- num("yards_to_goal")
  dist <- num("distance")
  adj <- num("adj_TimeSecsRem")
  period <- num("period")
  !is.na(down) & down == 4 &
    !is.na(ytg) & ytg > 0 & ytg < 100 &
    !is.na(dist) &
    !is.na(num("TimeSecsRem")) &
    !is.na(adj) & adj > 30 &
    !is.na(period) & period <= 4
}

#' Append the fourth-down decision surface
#'
#' On each fourth down, scores going for it, kicking and punting as win
#' probabilities and compares them. Adds [.FD_NUMERIC_COLS] plus
#' `fourth_down_recommendation` (`"go"` / `"field_goal"` / `"punt"`).
#'
#' Never raises; missing models, a missing punt table, a game with no pre-game
#' line, or an installation without `arrow` each leave the affected columns
#' `NA` rather than aborting the play-by-play pipeline.
#'
#' **Not a cross-validated port.** sdv-py's `get_go_wp()` raises unconditionally
#' on pandas 3, so there is no Python oracle for these three branches; they were
#' ported from cfb4th's R source directly and validated behaviourally against
#' known college conversion and field-goal rates. Two sign conventions were
#' found inverted in sdv-py along the way and are pinned by test here.
#'
#' @keywords internal
#' @noRd
.pbp_add_fourth_down <- function(df, fg_model = NULL, season = NULL) {
  for (nm in .FD_NUMERIC_COLS) df[[nm]] <- rep(NA_real_, nrow(df))
  df$fourth_down_recommendation <- rep(NA_character_, nrow(df))
  if (!nrow(df)) return(df)

  rows <- .fourth_down_decision_rows(df)
  if (!any(rows)) return(df)
  st <- .cfb_state_from_pbp(df, season = season)
  if (is.null(st)) return(df)

  res <- try(.fd_probs(st[rows, , drop = FALSE], fg_model = fg_model),
             silent = TRUE)
  if (inherits(res, "try-error")) return(df)
  for (nm in .FD_NUMERIC_COLS) df[[nm]][rows] <- res[[nm]]
  df$fourth_down_recommendation[rows] <- res$fourth_down_recommendation
  df
}
