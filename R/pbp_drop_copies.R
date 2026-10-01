#' ESPN play copies, as sdv-py drops them
#'
#' Port of sportsdataverse-py's `_drop_espn_play_copies()` and the adjacent-copy
#' rule that follows it (`text_dupe`, cfb_pbp.py). Each drops a real play ESPN
#' filed twice; vectors are in play order.
#'
#' * **stub echo** -- the row after a play repeats its text, period and start
#'   down/distance with `start.yardsToEndzone` 0 where the play has a spot. The
#'   echo goes, but its type is kept: it corrects the play's (401752854 files
#'   punts, kickoffs, a run and a missed field goal first as "Pass Completion").
#' * **stale drive copy** -- a row with a later twin in its drive (same period,
#'   start state and type) at a lower clock, in a clock batch where at least two
#'   rows have a twin with identical text.
#' * **copy across a marker** -- the same play (text, period, clock, start state)
#'   on both sides of a timeout or end-of-period row; the first copy goes.
#' * **adjacent copy** -- the next row carries the same id, or the same text,
#'   period and start state (not a timeout); the first goes.
#'
#' Timeouts and end-of-period rows are never dropped, and the first three rules
#' skip plays without a start spot (the spotless 2004 feed).
#'
#' @param type,text,id Play type, text and id.
#' @param drive,period,clock Drive id, period and clock display value.
#' @param team,down,distance,ytg Start team id, down, distance, yards to the end zone.
#' @return List: `drop` (rows to drop) and `retype` (rows that take the next row's type).
#' @keywords internal
#' @noRd
.espn_play_copies <- function(type, text, drive, period, team, down, distance, ytg, clock, id) {
  n <- length(type)
  out <- list(drop = rep(FALSE, n), retype = rep(FALSE, n))
  if (n < 2L) return(out)
  # a comparison with a null is null in polars, and a null condition never fires
  eq <- function(a, b) (a == b) %in% TRUE
  prev <- function(x) c(x[NA_integer_], x[-n])
  nxt <- function(x) c(x[-1L], x[NA_integer_])
  tx <- as.character(text)
  is_marker <- function(ty) {
    grepl("^(?:timeout|end\\b)", ty, ignore.case = TRUE, perl = TRUE) |
      grepl("^end of", tx, ignore.case = TRUE, perl = TRUE)
  }
  num <- function(x) suppressWarnings(as.numeric(x))
  per <- num(period)
  t <- ifelse(per %in% 1, 2700, ifelse(per %in% 2, 1800, ifelse(per %in% 3, 900, 0))) +
    60 * num(sub(":.*$", "", clock)) + num(sub("^.*:", "", clock))

  stub <- (ytg == 0) %in% TRUE & (prev(ytg) != 0) %in% TRUE & eq(tx, prev(tx)) &
    eq(period, prev(period)) & eq(team, prev(team)) & eq(down, prev(down)) &
    eq(distance, prev(distance)) & !is_marker(type)
  retype <- nxt(stub) %in% TRUE & !is.na(nxt(type))
  type[retype] <- type[which(retype) + 1L]

  marker <- is_marker(type)
  elig <- which(!stub & !marker & (ytg != 0) %in% TRUE)
  # twins: same drive, period and start state and type, filed later at a lower clock
  # A row with any NA key never twins. sdv-py's polars self-join matches null keys on
  # 4+ key columns when no row has a full key (polars 1.40-1.44); no real game hits it.
  keyed <- elig[!is.na(drive[elig]) & !is.na(period[elig]) & !is.na(team[elig]) & !is.na(down[elig]) &
                  !is.na(distance[elig]) & !is.na(ytg[elig]) & !is.na(type[elig])]
  key <- paste(drive, period, team, down, distance, ytg, type, sep = "\r")[keyed]
  has_twin <- exact <- rep(FALSE, length(keyed))
  for (g in split(seq_along(keyed), key)) {
    if (length(g) < 2L) next
    for (a in g) {
      later <- g[keyed[g] > keyed[a] & (t[keyed[g]] < t[keyed[a]]) %in% TRUE]
      if (!length(later)) next
      has_twin[a] <- TRUE
      exact[a] <- any(eq(tx[keyed[later]], tx[keyed[a]]))
    }
  }
  # a clock batch is stale when at least two of its rows have an identical-text twin
  tw <- which(has_twin)
  batch <- paste(period[keyed[tw]], t[keyed[tw]])
  stale <- keyed[tw][(tapply(exact[tw], batch, sum)[batch] >= 2) %in% TRUE]
  rows <- setdiff(elig, stale)
  nx <- c(rows[-1L], NA_integer_)
  echo <- rows[eq(tx[rows], tx[nx]) & eq(t[rows], t[nx]) & eq(period[rows], period[nx]) &
                 eq(team[rows], team[nx]) & eq(down[rows], down[nx]) &
                 eq(distance[rows], distance[nx]) & eq(ytg[rows], ytg[nx])]
  drop <- stub
  drop[c(stale, echo)] <- TRUE

  kept <- which(!drop)
  nk <- c(kept[-1L], NA_integer_)
  adjacent <- eq(id[kept], id[nk]) |
    (eq(team[kept], team[nk]) & eq(down[kept], down[nk]) & eq(ytg[kept], ytg[nk]) &
       eq(distance[kept], distance[nk]) & eq(tx[kept], tx[nk]) & eq(period[kept], period[nk]) &
       (type[kept] != "Timeout") %in% TRUE)
  drop[kept[adjacent]] <- TRUE
  list(drop = drop, retype = retype)
}

#' Drop ESPN's play copies from the v2 frame before it is modeled
#'
#' Runs [.espn_play_copies()] in play order; returns the frame in its own row
#' order without the copies, a stub echo's type moved onto the play it repeats.
#' @keywords internal
#' @noRd
.espn_drop_play_copies <- function(df, season) {
  if (nrow(df) < 2L) return(df)
  o <- .espn_play_order(df$play_id, df$sequence_number, df$period, df$clock, df$drive_drive_id,
                        df$type_text, df$start_down_distance_text, df$end_down_distance_text,
                        season, df$home_score, df$away_score)
  d <- df[o, , drop = FALSE]
  cp <- .espn_play_copies(d$type_text, d$text, d$drive_drive_id, d$period, d$start_team_id,
                          d$start_down, d$start_distance, d$start_yards_to_endzone, d$clock, d$play_id)
  for (col in intersect(c("type_id", "type_text", "type_abbreviation"), names(d))) {
    d[[col]][cp$retype] <- d[[col]][which(cp$retype) + 1L]
  }
  d <- d[!cp$drop, , drop = FALSE]
  d[order(o[!cp$drop]), , drop = FALSE]
}
