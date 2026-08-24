#' @rdname helpers_pbp
#'
#' @description Aggregate play-by-play to one row per team per game, using the
#'   definitions that actually reconcile against ESPN's official box score.
#'   Ported from sdv-py's `tools/validation/checks/boxscore_parity.aggregate`.
#'
#' @details The per-play checks answer "is this play self-consistent"; this
#'   answers the only question that catches attribution errors: **do the flags
#'   add up to the official box score**. A parser change that puts the right
#'   events on the wrong team leaves every per-play assertion green and shows up
#'   here immediately.
#'
#'   Three conventions are encoded because they were proven against the box, and
#'   two of them are the opposite of the NFL's:
#'
#'   * **NCAA charges sacks to RUSHING** -- both the attempt and the (negative)
#'     yardage. The NFL charges them to passing.
#'   * **Pass attempts EXCLUDE sacks.**
#'   * **A penalty belongs to the team that COMMITTED it**, not the team with the
#'     ball. A positive `penalty_yards_signed` means the offense gained, so the
#'     defence was the side flagged.
#'
#' @param pbp (*data.frame* required): play-by-play carrying `game_id`,
#'   `pos_team_id`/`pos_team`, `def_pos_team_id`/`def_pos_team`, the `rush`,
#'   `pass`, `completion`, `sack`, `int`, `fumble_lost` and `penalty_flag`
#'   flags, and the `yds_rushed` / `yds_receiving` / `yds_sacked` /
#'   `penalty_yards_signed` yardage columns.
#' @return A data frame with one row per `game_id` x `team_key` and the ten
#'   tracked stats.
#' @keywords internal
#' @noRd
.pbp_boxscore_aggregate <- function(pbp) {
  n <- nrow(pbp)
  empty <- data.frame(
    game_id = character(0), team_key = character(0), season = integer(0),
    completions = integer(0), interceptions = integer(0),
    fumbles_lost = integer(0), turnovers = integer(0),
    rush_att = integer(0), pass_att = integer(0),
    rush_yds = numeric(0), pass_yds = numeric(0),
    penalties = integer(0), penalty_yds = numeric(0),
    stringsAsFactors = FALSE
  )
  if (!n) return(empty)

  chr <- function(...) {
    v <- .attr_col(pbp, ...)
    if (is.null(v)) rep(NA_character_, n) else as.character(v)
  }
  flag <- function(nm) {
    v <- .attr_col(pbp, nm)
    if (is.null(v)) return(rep(0L, n))
    if (is.logical(v)) return(as.integer(!is.na(v) & v))
    as.integer(!is.na(v) & suppressWarnings(as.numeric(v)) > 0)
  }
  yds <- function(nm) {
    v <- .attr_col(pbp, nm)
    if (is.null(v)) return(rep(0, n))
    v <- suppressWarnings(as.numeric(v))
    v[is.na(v)] <- 0
    v
  }

  gid <- chr("game_id")
  pos <- chr("pos_team_id", "pos_team")
  def <- chr("def_pos_team_id", "def_pos_team")
  season <- suppressWarnings(as.integer(chr("season")))

  is_rush <- flag("rush")
  is_pass <- flag("pass")
  is_sack <- flag("sack")

  off <- data.frame(
    game_id = gid, team_key = pos, season = season,
    completions   = flag("completion"),
    interceptions = flag("int"),
    fumbles_lost  = flag("fumble_lost"),
    # NCAA: a sack is a rushing attempt with negative rushing yardage.
    rush_att = is_rush + is_sack,
    # pmax: a row flagged `sack` but not `pass` would otherwise contribute -1
    # and silently understate the team total in the sum below.
    pass_att = pmax(is_pass - is_sack, 0L),
    rush_yds = yds("yds_rushed") * is_rush + yds("yds_sacked") * is_sack,
    pass_yds = yds("yds_receiving") * is_pass,
    stringsAsFactors = FALSE
  )
  off$turnovers <- off$interceptions + off$fumbles_lost
  off <- off[!is.na(off$team_key), , drop = FALSE]

  agg <- stats::aggregate(
    off[, c("completions", "interceptions", "fumbles_lost", "turnovers",
            "rush_att", "pass_att", "rush_yds", "pass_yds")],
    by = list(game_id = off$game_id, team_key = off$team_key),
    FUN = sum
  )
  seasons <- stats::aggregate(
    list(season = off$season),
    by = list(game_id = off$game_id, team_key = off$team_key),
    FUN = function(x) x[1]
  )
  agg <- merge(agg, seasons, by = c("game_id", "team_key"), all.x = TRUE)

  # Penalties go to the committing side.
  pf <- flag("penalty_flag") == 1L
  pen <- if (any(pf)) {
    signed <- yds("penalty_yards_signed")[pf]
    charged <- ifelse(signed > 0, def[pf], pos[pf])
    keep <- !is.na(charged)
    if (any(keep)) {
      d <- data.frame(game_id = gid[pf][keep], team_key = charged[keep],
                      penalties = 1L, penalty_yds = abs(signed[keep]),
                      stringsAsFactors = FALSE)
      stats::aggregate(d[, c("penalties", "penalty_yds")],
                       by = list(game_id = d$game_id, team_key = d$team_key),
                       FUN = sum)
    } else {
      NULL
    }
  } else {
    NULL
  }

  out <- if (is.null(pen)) {
    agg$penalties <- 0L
    agg$penalty_yds <- 0
    agg
  } else {
    merge(agg, pen, by = c("game_id", "team_key"), all.x = TRUE)
  }
  out$penalties[is.na(out$penalties)] <- 0L
  out$penalty_yds[is.na(out$penalty_yds)] <- 0
  out[order(out$game_id, out$team_key), names(empty), drop = FALSE]
}

#' @rdname helpers_pbp
#'
#' @description Measure how often the aggregated play-by-play matches ESPN's own
#'   team box, per stat. Ported from sdv-py's `boxscore_parity.measure`.
#'
#' @details Returns a rate per stat rather than a pass/fail, because parity is
#'   strongly era-dependent: modern seasons reconcile above 90% on most stats
#'   while 2004 yardage sits near zero, and a single pooled threshold would be
#'   simultaneously too loose for one and impossible for the other. Callers
#'   compare each rate against a floor **measured from real data**, never a
#'   guessed one.
#'
#'   **Rows the join does not match are excluded from both `n` and `rate`**, and
#'   so are rows where ESPN's box has no value for that stat (older seasons omit
#'   several). That is the honest description of what the code does; an earlier
#'   version of this note claimed the opposite.
#'
#'   The exclusion is a real hazard rather than a detail: a team-key
#'   normalisation change can shrink the denominator and *raise* the rate with
#'   nothing reported. It is guarded from the test side instead of here --
#'   `test-pbp_boxscore_parity.R` asserts a floor on `min(n)`, bounds the spread
#'   across stats, and proves every unmatched team-game genuinely has no
#'   offensive plays. `n` is returned alongside `rate` so a caller can see the
#'   denominator move.
#'
#'   On the shipped corpus the aggregate has 112 rows against 120 box rows. That
#'   gap is benign and measured: the eight belong to four games carrying exactly
#'   one play row each with a null `pos_team`, so there are no offensive plays to
#'   aggregate. A test asserts that rather than leaving it to look like loss.
#'
#' @param agg (*data.frame*): output of `.pbp_boxscore_aggregate()`.
#' @param box (*data.frame*): ESPN team box, one row per `game_id` x `team_key`,
#'   with the `espn_*` columns.
#' @return A data frame of `stat`, `n`, `matched` and `rate`.
#' @keywords internal
#' @noRd
.pbp_boxscore_parity <- function(agg, box) {
  pairs <- list(
    c("completions",   "espn_completions"),
    c("interceptions", "espn_interceptions"),
    c("fumbles_lost",  "espn_fumbles_lost"),
    c("turnovers",     "espn_turnovers"),
    c("rush_att",      "espn_rushing_attempts"),
    c("rush_yds",      "espn_rushing_yards"),
    c("pass_yds",      "espn_net_passing_yards"),
    c("penalties",     "espn_penalties"),
    c("penalty_yds",   "espn_penalty_yards")
  )
  j <- merge(agg, box, by = c("game_id", "team_key"), all.x = TRUE)

  out <- lapply(pairs, function(p) {
    if (!all(p %in% names(j))) return(NULL)
    a <- suppressWarnings(as.numeric(j[[p[1]]]))
    b <- suppressWarnings(as.numeric(j[[p[2]]]))
    ok <- !is.na(b)
    if (!any(ok)) return(NULL)
    data.frame(stat = p[1], n = sum(ok),
               matched = sum(a[ok] == b[ok], na.rm = TRUE),
               rate = mean(a[ok] == b[ok], na.rm = TRUE),
               stringsAsFactors = FALSE)
  })
  out <- do.call(rbind, Filter(Negate(is.null), out))
  if (is.null(out)) {
    return(data.frame(stat = character(0), n = integer(0),
                      matched = integer(0), rate = numeric(0),
                      stringsAsFactors = FALSE))
  }
  out
}

#' Measured parity floors for the shipped fixture corpus
#'
#' @description Per-stat exact-match rates the 60-game fixture corpus currently
#'   achieves against ESPN's own team box, minus a 5-point margin.
#'
#' @details **Measured, never guessed.** Recorded 2026-08-19 over the 60-game
#'   corpus (five games from each of 2004, 2006, 2008, 2010, 2013, 2014, 2017,
#'   2019, 2020, 2021, 2023 and 2025):
#'
#'   \preformatted{
#'   interceptions 0.972   rush_att    0.657   penalties   0.111
#'   completions   0.833   pass_yds    0.519   penalty_yds 0.093
#'   fumbles_lost  0.731   rush_yds    0.315
#'   turnovers     0.704
#'   }
#'
#'   The spread is era, not quality: the corpus deliberately spans 2004-2025 and
#'   ESPN's early play text carries almost no yardage detail, so a pooled floor
#'   is loose by construction. Their job is to catch a *regression* -- a producer
#'   or parser change moving parity backwards -- not to certify accuracy.
#'
#'   Penalties sit lowest because attribution there is genuinely hard: sdv-py's
#'   own text resolver scores 61.5% count / 73.1% yards on a 13-game **modern**
#'   oracle, and this corpus is three-quarters pre-2020.
#'
#'   Raise a floor only after confirming a parity change is an improvement.
#'   Never lower one to silence a regression you have not explained.
#'
#' @keywords internal
#' @noRd
.pbp_boxscore_parity_floors <- list(
  completions   = 0.78,
  interceptions = 0.92,
  fumbles_lost  = 0.68,
  turnovers     = 0.65,
  rush_att      = 0.60,
  rush_yds      = 0.26,
  pass_yds      = 0.46,
  penalties     = 0.06,
  penalty_yds   = 0.04
)
