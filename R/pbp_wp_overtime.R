#' Overtime-aware win probability (port of sdv-py `cfb_wp_overtime`)
#'
#' @description The regulation WP boosters (`wp_naive`, `wp_spread`) were
#'   trained on a frame that drops every game that reached overtime, so they
#'   estimate P(win | state, settled in regulation): a tied game late in the
#'   fourth quarter overrates the team with the ball, and an overtime state was
#'   never seen at all. sportsdataverse-py's `cfb_wp_overtime.adjust_wp()`
#'   corrects both, from `wp_ot_reach.ubj` and its card in the
#'   `cfb_model_artifacts` bundle; this file ports it so the two libraries
#'   agree on overtime `wp_before` / `vegas_wp`.
#'
#'   * **Regulation:** `(1 - q) * wp + q * tie_value`, where `q` is
#'     P(the game reaches overtime | state) (`wp_ot_reach.ubj`) and `tie_value`
#'     is P(win | overtime reached), a logistic in the pregame spread (a coin
#'     flip for the spread-free model).
#'   * **Overtime:** the booster is not used. The possession is rolled through
#'     the overtime rules: the drive ends in a touchdown, a field goal or
#'     nothing (a multinomial logistic on yards to goal, down and distance),
#'     the team that had the ball first is answered by the other from the 25,
#'     and a tie after both possessions is worth `tie_value` again.
#'
#'   Not ported: sdv-py's two-point shootout periods and end-of-possession
#'   states, which rewrite its published `wp_before` on top of this.
#'
#' @keywords internal
#' @noRd
NULL

#' Snaps that do not say who has the ball (sdv-py `NOT_A_SNAP`)
#' @keywords internal
#' @noRd
.OT_NOT_A_SNAP <- c("Timeout", "End Period", "Penalty")

#' `(first season, first overtime period)` from which a touchdown must be
#' followed by a two-point try (sdv-py `OT_TWO_POINT_FORCED_FROM`)
#' @keywords internal
#' @noRd
.OT_TWO_POINT_FORCED_FROM <- list(c(1996, 3), c(2019, 3), c(2021, 2))

#' The overtime correction: `wp_ot_reach` booster plus the card's parameters
#'
#' Bundle-or-nothing like CP: without it WP stays the regulation booster's,
#' and a failed fetch is remembered so a season sweep pays the timeout once.
#'
#' @return `list(q_model, features, slope, p_xp, p_2pt, coef, intercept,
#'   bound)` or `NULL`.
#' @keywords internal
#' @noRd
.cfb_wp_ot_model <- function() {
  if (!is.null(.cfb_model_env$wp_ot)) return(.cfb_model_env$wp_ot)
  if (isTRUE(.cfb_model_env$unavailable[["wp_ot"]])) return(NULL)
  fail <- function() {
    .cfb_model_env$unavailable[["wp_ot"]] <- TRUE
    NULL
  }
  b <- .cfb_bundle_booster("wp_ot_reach.ubj")
  if (is.character(b)) return(fail())
  card <- try(cfb_model_card("wp_ot_reach"), silent = TRUE)
  if (inherits(card, "try-error") || is.null(card$overtime)) return(fail())
  ot <- card$overtime
  dm <- ot$drive_model
  # simplifyVector turns the card's list of class rows into a 3 x 7 matrix
  coef <- matrix(as.numeric(dm$coef), nrow = 3L)
  m <- list(
    q_model = b,
    features = as.character(unlist(card$features)),
    slope = as.numeric(ot$spread_slope),
    p_xp = as.numeric(ot$p_extra_point),
    p_2pt = as.numeric(ot$p_two_point),
    coef = coef,
    intercept = as.numeric(unlist(dm$intercept)),
    bound = as.numeric(ot$live_bound %||% 0)
  )
  .cfb_model_env$wp_ot <- m
  m
}

#' Must a touchdown in this period be followed by a two-point try?
#'
#' @param season,period Recycled to a common length; `period` is ESPN's (5 is
#'   the first overtime). Regulation, or an `NA` season or period, is `FALSE`.
#' @keywords internal
#' @noRd
.ot_forced_two_point <- function(season, period) {
  s <- suppressWarnings(as.numeric(season))
  p <- suppressWarnings(as.numeric(period))
  n <- max(length(s), length(p))
  s <- rep_len(s, n)
  p <- rep_len(p, n)
  cut <- rep(Inf, n)
  for (r in .OT_TWO_POINT_FORCED_FROM) cut <- ifelse(!is.na(s) & s >= r[1], r[2], cut)
  !is.na(p) & (p - 4 >= cut)
}

#' P(win | the game reaches overtime); `NULL` spread is a coin flip
#' @keywords internal
#' @noRd
.ot_tie_value <- function(m, spread = NULL, n = 0L) {
  if (is.null(spread)) return(rep(0.5, n))
  s <- suppressWarnings(as.numeric(spread))
  s[is.na(s)] <- 0
  1 / (1 + exp(-m$slope * s))
}

#' Is the team with the ball second in its overtime period?
#'
#' Known values pass through; unknown ones fall back on the margin -- only the
#' second team can be behind or ahead at the snap.
#' @keywords internal
#' @noRd
.ot_infer_second <- function(second, diff) {
  fallback <- as.numeric(diff) != 0
  if (is.null(second)) return(fallback)
  s <- suppressWarnings(as.numeric(second))
  ifelse(is.na(s), fallback, s > 0)
}

#' Per play: is the possessing team second in its overtime period?
#'
#' The first team of a period is the possessing team on its first snap that
#' has a down and is not a timeout, period marker or penalty (sdv-py
#' `ot_first_team`). `NA` in regulation and where the frame cannot say.
#'
#' @param df One or more games' plays, in play order.
#' @keywords internal
#' @noRd
.ot_second_possession <- function(df) {
  if (!all(c("game_id", "period", "pos_team", "down") %in% names(df))) return(NULL)
  n <- nrow(df)
  period <- suppressWarnings(as.numeric(df$period))
  down <- suppressWarnings(as.numeric(as.character(df$down)))
  snap <- !is.na(down) & down >= 1 & down <= 4
  if ("play_type" %in% names(df)) snap <- snap & !(df$play_type %in% .OT_NOT_A_SNAP)
  key <- paste(df$game_id, period)
  # match() takes the first hit, so walk the snaps in play order.
  ord <- if ("play_order" %in% names(df)) order(df$play_order) else seq_len(n)
  ord <- ord[snap[ord]]
  first <- df$pos_team[ord][match(key, key[ord])]
  ifelse(!is.na(period) & period >= 5 & !is.na(first), df$pos_team != first, NA)
}

#' Overtime drive outcome: `(n, 3)` P(touchdown, field goal, no score)
#' @keywords internal
#' @noRd
.ot_drive_probs <- function(m, ytg, down, distance) {
  n <- max(length(ytg), length(down), length(distance))
  y <- pmin(pmax(rep_len(as.numeric(ytg), n), 1), 99) / 25
  dn <- rep_len(as.numeric(down), n)
  ld <- log1p(pmin(pmax(rep_len(as.numeric(distance), n), 1), 99))
  x <- cbind(y, y^2, dn == 2, dn == 3, dn == 4, ld, (dn == 4) * ld)
  z <- x %*% t(m$coef) + matrix(m$intercept, n, 3, byrow = TRUE)
  z <- exp(z - apply(z, 1, max))
  z / rowSums(z)
}

#' Win probability once both teams have had the ball (`NA` stays `NA`)
#' @keywords internal
#' @noRd
.ot_g <- function(margin, tie) (margin > 0) + tie * (margin == 0)

#' Second team's touchdown at `margin` (six counted): best of kick and two, or
#' the forced two-point try
#' @keywords internal
#' @noRd
.ot_after_td <- function(m, margin, tie, forced) {
  kick <- m$p_xp * .ot_g(margin + 1, tie) + (1 - m$p_xp) * .ot_g(margin, tie)
  two <- m$p_2pt * .ot_g(margin + 2, tie) + (1 - m$p_2pt) * .ot_g(margin, tie)
  ifelse(forced, two, pmax(kick, two))
}

#' The other team's win probability, second in the period, from its 25
#' @keywords internal
#' @noRd
.ot_answer <- function(m, need, tie_other, forced) {
  p25 <- .ot_drive_probs(m, 25, 1, 10)[1, ]
  p25[1] * .ot_after_td(m, need + 6, tie_other, forced) +
    p25[2] * .ot_g(need + 3, tie_other) +
    p25[3] * .ot_g(need, tie_other)
}

#' Win probability when the possession has just ended at `margin`
#' @keywords internal
#' @noRd
.ot_possession_over_wp <- function(m, margin, tie, second, forced) {
  ifelse(second, .ot_g(margin, tie), 1 - .ot_answer(m, -margin, 1 - tie, forced))
}

#' Win probability right after a touchdown, `margin` being the margin before it
#' @keywords internal
#' @noRd
.ot_touchdown_wp <- function(m, margin, tie, second, forced) {
  miss <- 1 - .ot_answer(m, -(margin + 6), 1 - tie, forced)
  kick <- m$p_xp * (1 - .ot_answer(m, -(margin + 7), 1 - tie, forced)) +
    (1 - m$p_xp) * miss
  two <- m$p_2pt * (1 - .ot_answer(m, -(margin + 8), 1 - tie, forced)) +
    (1 - m$p_2pt) * miss
  first <- ifelse(forced, two, kick)
  ifelse(second, .ot_after_td(m, margin + 6, tie, forced), first)
}

#' Win probability of the team with the ball at a live overtime snap,
#' bounded to `[live_bound, 1 - live_bound]` (card)
#' @keywords internal
#' @noRd
.ot_live_wp <- function(m, margin, down, distance, ytg, tie, second, forced) {
  p <- .ot_drive_probs(m, ytg, down, distance)
  v <- p[, 1] * .ot_touchdown_wp(m, margin, tie, second, forced) +
    p[, 2] * .ot_possession_over_wp(m, margin + 3, tie, second, forced) +
    p[, 3] * .ot_possession_over_wp(m, margin, tie, second, forced)
  pmin(pmax(v, m$bound), 1 - m$bound)
}

#' Turn a regulation booster's output into P(win | state)
#'
#' Port of sdv-py `cfb_wp_overtime.adjust_wp()`. Returns `wp` unchanged when
#' the overtime model is unavailable, so scoring never fails on it.
#'
#' @param wp The regulation booster's prediction on `x`.
#' @param x The WP feature matrix it scored (needs `period`,
#'   `adj_TimeSecsRem`, `pos_score_diff_start`, `down`, `distance`,
#'   `yards_to_goal` and the `wp_ot_reach` card features).
#' @param spread_time `spread_time` for the spread model, `NULL` for naive
#'   (a coin-flip overtime).
#' @param second Optional per-row "second possession of the overtime period".
#' @param forced Optional per-row "a touchdown must be followed by a two-point
#'   try" ([.ot_forced_two_point()]); `NULL` allows the kick everywhere.
#' @keywords internal
#' @noRd
.cfb_adjust_wp <- function(wp, x, spread_time = NULL, second = NULL, forced = NULL) {
  m <- .cfb_wp_ot_model()
  if (is.null(m) || !length(wp)) return(wp)
  col <- function(nm) as.numeric(x[, nm])
  adj <- col("adj_TimeSecsRem")
  tie <- if (is.null(spread_time)) {
    .ot_tie_value(m, NULL, length(wp))
  } else {
    # spread_time = pos_team_spread * exp(-4 * elapsed_share); undo the decay
    .ot_tie_value(m, as.numeric(spread_time) * exp(4 * pmax((3600 - adj) / 3600, 0)))
  }
  q <- as.numeric(stats::predict(m$q_model, x[, m$features, drop = FALSE]))
  out <- (1 - q) * wp + q * tie
  ot <- !is.na(col("period")) & col("period") >= 5
  if (any(ot)) {
    margin <- col("pos_score_diff_start")
    sec <- .ot_infer_second(second, margin)
    # rep_len: ifelse() takes its length from the test, so a scalar FALSE
    # would collapse every overtime value to the first play's.
    forced <- rep_len(if (is.null(forced)) FALSE else as.logical(forced), length(wp))
    live <- .ot_live_wp(m, margin, col("down"), col("distance"),
                        col("yards_to_goal"), tie, sec, forced)
    out <- ifelse(ot, live, out)
  }
  out
}
