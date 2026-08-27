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
#' @param wp Win probabilities to clamp.
#' @param leading Logical: does the team whose WP this is hold the lead?
#' @param value What a clamped row is pinned to.
#' @keywords internal
#' @noRd
.fd_kneel_clamp <- function(wp, leading, adj, def_to, value) {
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
  turnover <- as.integer(gain < s$distance)
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

  # Kneel-out: a conversion that keeps a lead alive wins outright, and a
  # turnover while trailing loses outright.
  succ_alive <- turnover == 0L & !td_mask & ytg > 0 & pos_diff > 0
  wp <- .fd_kneel_clamp(wp, succ_alive, s$adj_TimeSecsRem, new_def_to, 1)
  fail_lead <- turnover == 1L & pos_diff < 0
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
