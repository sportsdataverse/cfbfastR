#' Hypothetical game states for the CFB decision surfaces
#'
#' @description The two-point and fourth-down surfaces both work the same way:
#'   construct the state the game would be in after some choice, score EP and
#'   WP there, and compare. That machinery lives here so both consume one
#'   implementation of the state contract and one flip.
#'
#' @details Ported from `sportsdataverse-py`'s `cfb_fourth_down` helpers
#'   (`_PBP_COLS` / `_flip_team_state` / `_predict_ep` / `_predict_wp`), which
#'   are themselves a port of cfb4th. Two sign conventions in here have a
#'   documented history of being inverted, and both are pinned by test:
#'   `spread_time` is `+pos_team_spread * exp(-4 * elapsed_share)` (the `-1 *`
#'   form scores favourites as underdogs), and the flip negates the score
#'   differential so the try's value is added BEFORE flipping, not after.
#'
#' @keywords internal
#' @noRd
NULL

#' State columns the decision surfaces read
#'
#' `yards_to_goal` is deliberately included but never set by
#' [.flip_team_state()] -- each scenario supplies its own field position.
#'
#' @keywords internal
#' @noRd
.CFB_STATE_COLS <- c(
  "period", "pos_team_receives_2H_kickoff",
  "pos_team_timeouts_rem_before", "def_pos_team_timeouts_rem_before",
  "pos_score_diff_start", "pos_team_spread", "is_home",
  "down", "distance", "yards_to_goal", "TimeSecsRem", "adj_TimeSecsRem",
  # fourth-down only: its model reads the implied team total and a rule era
  "posteam_total", "season"
)

#' Build the decision-surface state frame from a play-by-play frame
#'
#' @return A data.frame with [.CFB_STATE_COLS], or `NULL` when the frame cannot
#'   supply them (no pre-game line, missing clock columns).
#' @keywords internal
#' @noRd
.cfb_state_from_pbp <- function(df, season = NULL) {
  spread <- .wp_pos_team_spread(df)
  if (is.null(spread)) return(NULL)
  num <- function(nm) {
    if (!nm %in% names(df)) return(rep(NA_real_, nrow(df)))
    suppressWarnings(as.numeric(as.character(df[[nm]])))
  }
  st <- data.frame(
    period = num("period"),
    pos_team_receives_2H_kickoff = num("pos_team_receives_2H_kickoff"),
    pos_team_timeouts_rem_before = num("pos_team_timeouts_rem_before"),
    def_pos_team_timeouts_rem_before = num("def_pos_team_timeouts_rem_before"),
    pos_score_diff_start = num("pos_score_diff_start"),
    pos_team_spread = spread,
    is_home = .wp_is_home(df),
    down = num("down"),
    distance = num("distance"),
    yards_to_goal = num("yards_to_goal"),
    TimeSecsRem = num("TimeSecsRem"),
    adj_TimeSecsRem = num("adj_TimeSecsRem"),
    posteam_total = {
      tot <- .cfb_posteam_total(df)
      if (is.null(tot)) rep(NA_real_, nrow(df)) else tot
    },
    season = rep(NA_real_, nrow(df))
  )
  if (!is.null(season)) st$season <- suppressWarnings(as.numeric(season))[1]
  if (all(is.na(st$adj_TimeSecsRem)) || all(is.na(st$TimeSecsRem))) return(NULL)
  st
}

#' Hand the ball to the other team
#'
#' cfb4th's `flip_team`: timeouts swap, score differential and spread negate,
#' `is_home` toggles, the second-half-kickoff indicator toggles **only in the
#' first half**, it becomes 1st and 10, and six seconds run off.
#'
#' `yards_to_goal` is NOT set -- the caller supplies the field position its
#' scenario implies (a touchback after a score, a punt's landing spot, the
#' turnover-on-downs spot).
#'
#' @keywords internal
#' @noRd
.flip_team_state <- function(st) {
  out <- st
  # The 2H-kickoff indicator only means anything while the second half is still
  # ahead; toggling it in the second half would invent a kickoff that already
  # happened.
  first_half <- !is.na(st$period) & st$period <= 2
  recv <- st$pos_team_receives_2H_kickoff
  out$pos_team_receives_2H_kickoff <- ifelse(
    first_half & recv %in% 0, 1,
    ifelse(first_half & recv %in% 1, 0, recv)
  )
  out$pos_team_timeouts_rem_before <- st$def_pos_team_timeouts_rem_before
  out$def_pos_team_timeouts_rem_before <- st$pos_team_timeouts_rem_before
  out$pos_score_diff_start <- -st$pos_score_diff_start
  out$pos_team_spread <- -st$pos_team_spread
  out$is_home <- 1 - st$is_home
  out$down <- 1
  out$distance <- 10
  out$TimeSecsRem <- pmax(st$TimeSecsRem - 6, 0)
  out$adj_TimeSecsRem <- pmax(st$adj_TimeSecsRem - 6, 0)
  out
}

#' Expected points for an arbitrary state
#'
#' @keywords internal
#' @noRd
.state_ep <- function(st) {
  model <- .cfb_ep_model_or_null()
  if (is.null(model)) return(rep(NA_real_, nrow(st)))
  probs <- try(.ep_predict(model, st), silent = TRUE)
  if (inherits(probs, "try-error")) return(rep(NA_real_, nrow(st)))
  # .ep_predict returns .EP_LEV-ordered columns, so the positional weights the
  # rest of the package uses apply directly.
  as.numeric(as.matrix(probs) %*% c(0, 3, -3, -2, -7, 2, 7))
}

#' The loaded EP model, or NULL when it is not an era of model we can score
#' @keywords internal
#' @noRd
.cfb_ep_model_or_null <- function() {
  m <- try(get("ep_model", envir = asNamespace("cfbfastR")), silent = TRUE)
  if (inherits(m, "try-error") || is.null(m)) return(NULL)
  m
}

#' Spread-aware win probability for an arbitrary state
#'
#' Derives `ExpScoreDiff_Time_Ratio` from the state's own EP rather than
#' reading a column, because a hypothetical state has no precomputed one.
#'
#' @param st State frame.
#' @param ep Expected points for those states; computed when omitted.
#' @keywords internal
#' @noRd
.state_wp <- function(st, ep = NULL) {
  model <- .cfb_wp_spread_model()
  if (is.null(model)) return(rep(NA_real_, nrow(st)))
  if (is.null(ep)) ep <- .state_ep(st)
  adj <- st$adj_TimeSecsRem
  exp_score_diff <- st$pos_score_diff_start + ep
  elapsed_share <- pmax((3600 - adj) / 3600, 0)
  # POSITIVE pos_team_spread * exp(...). The negated form scores favourites as
  # underdogs -- a documented past defect upstream, so it is pinned by test.
  spread_time <- st$pos_team_spread * exp(-4 * elapsed_share)
  x <- cbind(
    pos_team_receives_2H_kickoff = st$pos_team_receives_2H_kickoff,
    spread_time = spread_time,
    TimeSecsRem = st$TimeSecsRem,
    adj_TimeSecsRem = adj,
    ExpScoreDiff_Time_Ratio = exp_score_diff / (adj + 1),
    pos_score_diff_start = st$pos_score_diff_start,
    down = st$down,
    distance = st$distance,
    yards_to_goal = st$yards_to_goal,
    is_home = st$is_home,
    pos_team_timeouts_rem_before = st$pos_team_timeouts_rem_before,
    def_pos_team_timeouts_rem_before = st$def_pos_team_timeouts_rem_before,
    period = st$period
  )
  colnames(x) <- .WP_SPREAD_FEATURES
  p <- try(as.numeric(stats::predict(model, x)), silent = TRUE)
  if (inherits(p, "try-error") || length(p) != nrow(st)) {
    return(rep(NA_real_, nrow(st)))
  }
  p
}

#' Empirical CFB extra-point make rate
#'
#' cfb4th derives the XP probability from its field-goal GAM at a 2-yard kick;
#' the flat empirical rate is more accurate for college, where XP success is
#' near-constant. Matches sdv-py's `_XP_MAKE_PROB`.
#'
#' @keywords internal
#' @noRd
.XP_MAKE_PROB <- 0.9851

#' Win probability after a try worth `pts`, from the SCORING team's view
#'
#' The scoring team's lead grows by `pts`, the ball goes to the opponent at the
#' 25 after a touchback, and the resulting WP is flipped back to the scoring
#' team.
#'
#' **Sign:** `pts` is added BEFORE the flip. `.flip_team_state()` negates the
#' score differential when handing off, so adding first leaves the opponent
#' correctly facing `-(lead + pts)`. cfb4th subtracts because it operates on the
#' already-flipped frame; subtracting here would invert the try's value.
#'
#' @keywords internal
#' @noRd
.wp_after_pts <- function(st, pts) {
  s <- st
  s$pos_score_diff_start <- s$pos_score_diff_start + pts
  flipped <- .flip_team_state(s)
  flipped$yards_to_goal <- 75   # touchback to the 25
  flipped$distance <- 10
  wp <- .state_wp(flipped)
  # The flip always changes possession, so the opponent's WP is the scoring
  # team's loss.
  1 - wp
}

#' Append the two-point decision surface
#'
#' On each offensive-touchdown row, compares going for two against kicking the
#' extra point by scoring the opponent's ensuing drive for each outcome:
#'
#' * `two_pt_wp` -- `prob_2pt * wp(+2) + (1 - prob_2pt) * wp(+0)`
#' * `xp_wp` -- `XP_MAKE_PROB * wp(+1) + (1 - XP_MAKE_PROB) * wp(+0)`
#' * `two_pt_wp_diff` -- `two_pt_wp - xp_wp`
#' * `two_pt_recommendation` -- `"go_for_2"` when the difference is positive,
#'   else `"kick_xp"`
#'
#' Never raises; missing inputs leave the columns `NA`.
#'
#' **Read `two_pt_recommendation` with care.** It is a faithful port of
#' cfb4th's rule -- `go_for_2` whenever `two_pt_wp > xp_wp`, with no margin --
#' and verified bit-identical to `sportsdataverse-py` to eight decimals. Two
#' consequences follow from the rule rather than from the port:
#'
#' * The bundled two-point model is optimistic. It predicts conversion around
#'   0.50 where college teams actually convert nearer 0.45, and cfb4th itself
#'   hardcodes a flat 0.45. At 0.50 a try is worth about 1.00 points against
#'   the extra point's 0.985, so the comparison leans toward going for two far
#'   more often than conventional charts do.
#' * In blowouts both branches saturate near 0 or 1 and the difference between
#'   them collapses to numerical noise, so the strict `>` can tip either way on
#'   a margin no one would act on.
#'
#' `two_pt_wp_diff` is exposed precisely so callers can apply their own
#' threshold rather than treating the bare recommendation as advice.
#'
#' @keywords internal
#' @noRd
.pbp_add_two_pt_decision <- function(df, season = NULL) {
  df$two_pt_wp <- rep(NA_real_, nrow(df))
  df$xp_wp <- rep(NA_real_, nrow(df))
  df$two_pt_wp_diff <- rep(NA_real_, nrow(df))
  df$two_pt_recommendation <- rep(NA_character_, nrow(df))
  if (!nrow(df) || !"prob_2pt" %in% names(df)) return(df)

  rows <- .two_pt_decision_rows(df) & !is.na(df$prob_2pt)
  if (!any(rows)) return(df)
  st <- .cfb_state_from_pbp(df)
  if (is.null(st)) return(df)

  st <- st[rows, , drop = FALSE]
  # The try is decided at the POST-touchdown score, the same adjustment
  # prob_2pt is scored at.
  st$pos_score_diff_start <- .two_pt_score_diff(df)[rows]

  out <- try({
    wp0 <- .wp_after_pts(st, 0)
    wp1 <- .wp_after_pts(st, 1)
    wp2 <- .wp_after_pts(st, 2)
    p2 <- df$prob_2pt[rows]
    two <- p2 * wp2 + (1 - p2) * wp0
    xp <- .XP_MAKE_PROB * wp1 + (1 - .XP_MAKE_PROB) * wp0
    list(two = two, xp = xp)
  }, silent = TRUE)
  if (inherits(out, "try-error")) return(df)

  df$two_pt_wp[rows] <- out$two
  df$xp_wp[rows] <- out$xp
  df$two_pt_wp_diff[rows] <- out$two - out$xp
  df$two_pt_recommendation[rows] <- ifelse(
    is.na(out$two - out$xp), NA_character_,
    ifelse(out$two > out$xp, "go_for_2", "kick_xp")
  )
  df
}
