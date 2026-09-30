#' ESPN play order, as sdv-py orders a game's plays
#'
#' Port of sportsdataverse-py's `_sort_plays_ot_aware()` (cfb_pbp.py) as its final
#' call sees the plays -- in `__add_downs_data()`, after a play with no type has
#' been labelled "Unknown": sort by play id (then game clock), and repair the order
#' ESPN's ids get wrong:
#'
#' * **late inserts** (2014+): a play ESPN added after the fact with a fresh,
#'   later id but the `sequenceNumber` and clock of its true position moves back
#'   after the play with the greatest smaller sequence in its own drive
#'   (`_reorder_late_inserts`);
#' * **drive reunite**: a row filed inside a later drive moves back to its own
#'   drive when its start down-and-distance text continues the end text of its
#'   drive's last earlier row (`_reunite_drive_rows`, sportsdataverse-py #637);
#' * **tries filed after the kickoff** swap back behind their touchdown
#'   (`_place_tries_filed_after_the_kickoff`);
#' * **overtime** is ordered separately, by sequence or id -- whichever steps
#'   the score backwards least.
#'
#' The engine sorts by the resulting `play_order` instead of `id_play`, so every
#' lead/lag reads the same neighbour sdv-py's does. On a 12-game 2024-2026 sample
#' plain id order differed from sdv-py's in 21 adjacent pairs (late inserts 12,
#' reunite 5).
#'
#' @param id,sequence Play id and ESPN `sequenceNumber` (character or numeric).
#' @param period Period number.
#' @param clock Clock display value, `"mm:ss"`.
#' @param drive_id ESPN drive id (rises in drive-list order).
#' @param type Play type text.
#' @param start_text,end_text Start / end down-and-distance texts.
#' @param season Season (the late-insert pass runs from 2014).
#' @param home_score,away_score Scores after the play (overtime order choice).
#' @return Integer vector: row indices in play order.
#' @keywords internal
#' @noRd
.espn_play_order <- function(id, sequence, period, clock, drive_id, type,
                             start_text, end_text, season, home_score, away_score) {
  n <- length(id)
  if (n < 2L) return(seq_len(n))
  num <- function(x) suppressWarnings(as.numeric(x))
  # 2014+ play ids are 18 digits -- past 2^53, where doubles stop being exact
  # (as.numeric() ordered 401635534101849911 before ...849902). Compare them as
  # digit strings: by length, then byte order, which is numeric order.
  idc <- .id_digits(id); idl <- nchar(idc)
  seqn <- num(sequence); per <- num(period)
  mm <- num(sub(":.*$", "", clock)); ss <- num(sub("^.*:", "", clock))
  # an NA period falls through to 0 like polars' when/otherwise chain
  adj_t <- ifelse(per %in% 1, 2700, ifelse(per %in% 2, 1800, ifelse(per %in% 3, 900, 0))) + 60 * mm + ss
  drv <- num(drive_id)
  # sdv-py labels a typeless play "Unknown" before its final sort, which makes it
  # eligible as a late insert (401752914's re-filed touchdown drive)
  type <- ifelse(is.na(type), "Unknown", as.character(type))

  # polars sorts nulls first; R's order() puts NA last unless told otherwise
  o <- order(idl, idc, adj_t, na.last = FALSE, method = "radix")
  season <- suppressWarnings(max(num(season), na.rm = TRUE))
  o <- o[.reorder_late_inserts(seqn[o], adj_t[o], drv[o], per[o], type[o], season)]
  o <- o[.reunite_drive_rows(drv[o], start_text[o], end_text[o], type[o], per[o], id[o])]
  o <- o[.place_tries_after_kickoff(type[o], per[o], adj_t[o])]

  ot <- which(per[o] >= 5)
  if (!length(ot)) return(o)
  non_ot <- o[setdiff(seq_along(o), ot)]
  ot_rows <- o[ot]
  by_seq <- ot_rows[order(seqn[ot_rows], idl[ot_rows], idc[ot_rows], na.last = FALSE, method = "radix")]
  by_id <- ot_rows[order(idl[ot_rows], idc[ot_rows], na.last = FALSE, method = "radix")]
  backsteps <- function(r) {
    h <- diff(num(home_score)[r]); a <- diff(num(away_score)[r])
    sum((h < 0) %in% TRUE | (a < 0) %in% TRUE)
  }
  # sdv-py: (min sequence or 0) >= 1e8, so an all-NA overtime is not the sequence scheme
  mn <- suppressWarnings(min(seqn[ot_rows], na.rm = TRUE))
  seq_scheme <- is.finite(mn) && mn >= 1e8
  s_seq <- backsteps(by_seq); s_id <- backsteps(by_id)
  c(non_ot, if (s_seq < s_id || (s_seq == s_id && seq_scheme)) by_seq else by_id)
}

.try_types <- c("Extra Point Good", "Extra Point Missed", "Two-Point Conversion Good",
                "Two-Point Conversion Missed", "Two Point Pass", "Two Point Rush",
                "Blocked PAT", "Defensive 2pt Conversion")

#' sdv-py `_reorder_late_inserts` on vectors already in id order; returns a permutation.
#' @keywords internal
#' @noRd
.reorder_late_inserts <- function(seqn, adj_t, drv, per, type, season) {
  n <- length(seqn)
  if (n < 3L || !is.finite(season) || season < 2014) return(seq_len(n))
  # polars cum_max skips nulls; a null anywhere means "not late"
  cm <- cummax(ifelse(is.na(seqn), -Inf, seqn))
  lag_t <- c(NA, adj_t[-n])
  late <- (seqn < cm) & (per < 5) & (adj_t > lag_t + 5) & !grepl("timeout|end", type, ignore.case = TRUE)
  late <- late %in% TRUE
  if (!any(late)) return(seq_len(n))
  pos <- seq_len(n)
  fixed <- pos[!late]
  tpos <- rep(NA_integer_, n)
  for (l in pos[late]) {
    cand <- fixed[(seqn[fixed] < seqn[l]) %in% TRUE]
    if (!length(cand)) next
    # greatest sequence below this one; among equals the last-positioned
    best <- cand[seqn[cand] == max(seqn[cand])]
    t <- max(best)
    ndrv <- if (t < n) drv[t + 1L] else NA
    if ((drv[t] == drv[l]) %in% TRUE || (ndrv == drv[l]) %in% TRUE) tpos[l] <- t
  }
  # a try that fails the drive test goes right after the last touchdown sequenced
  # before it in the same period
  for (l in pos[late & is.na(tpos) & type %in% .try_types]) {
    tds <- fixed[grepl("touchdown", type[fixed], ignore.case = TRUE) &
                   (seqn[fixed] < seqn[l]) %in% TRUE & (per[fixed] == per[l]) %in% TRUE]
    if (length(tds)) tpos[l] <- tds[order(seqn[tds], method = "radix")][length(tds)]
  }
  if (all(is.na(tpos))) return(seq_len(n))
  key <- ifelse(is.na(tpos), pos, tpos + 0.5)
  order(key, seqn, na.last = FALSE, method = "radix")
}

#' sdv-py `_reunite_drive_rows` on vectors in current order; returns a permutation.
#' @keywords internal
#' @noRd
.reunite_drive_rows <- function(drv, start_text, end_text, type, per, id) {
  n <- length(drv)
  if (n < 3L) return(seq_len(n))
  dd_key <- function(x) {
    x <- as.character(x)
    ok <- !is.na(x) & nzchar(x) & grepl("at (.+)$", x, perl = TRUE)
    out <- rep(NA_character_, length(x))
    out[ok] <- paste(sub(" .*$", "", x[ok]), sub("^.*?at ", "", x[ok], perl = TRUE))
    out
  }
  sk <- dd_key(start_text); ek <- dd_key(end_text)
  admin <- grepl("^(timeout|end period|end of (half|game)|official)", type, ignore.case = TRUE, perl = TRUE)
  per <- ifelse(is.na(per), 0, per)
  id <- as.character(id)
  order_ <- seq_len(n)
  i <- 2L
  while (i <= length(order_)) {
    r <- order_[i]; prev <- order_[i - 1L]; k <- sk[r]
    if (!is.na(drv[r]) && !is.na(drv[prev]) && drv[r] < drv[prev] && per[r] < 5 &&
        !is.na(k) && !admin[r]) {
      j <- NA_integer_
      if (i >= 3L) for (x in seq(i - 2L, 1L)) {
        if ((drv[order_[x]] == drv[r]) %in% TRUE && !admin[order_[x]]) { j <- x; break }
      }
      if (!is.na(j) && (ek[order_[j]] == k) %in% TRUE && !((ek[prev] == k) %in% TRUE)) {
        end <- i + 1L
        while (end <= length(order_) &&
               ((type[order_[end]] %in% .try_types && !((drv[order_[end]] == drv[prev]) %in% TRUE)) ||
                (!is.na(id[r]) && (id[order_[end]] == id[r]) %in% TRUE))) {
          end <- end + 1L
        }
        block <- order_[i:(end - 1L)]
        order_ <- append(order_[-(i:(end - 1L))], block, after = j)
        i <- i + length(block)
        next
      }
    }
    i <- i + 1L
  }
  order_
}

#' sdv-py `_place_tries_filed_after_the_kickoff`; returns a permutation.
#' @keywords internal
#' @noRd
.place_tries_after_kickoff <- function(type, per, adj_t) {
  n <- length(type)
  kickoff <- c("Kickoff", "Kickoff Return (Offense)", "Kickoff Return Touchdown", "Kickoff Touchdown",
               "Kickoff Team Fumble Recovery", "Kickoff Team Fumble Recovery Touchdown",
               "Kickoff (Safety)", "Penalty (Kickoff)")
  if (n < 3L) return(seq_len(n))
  lag1 <- c(NA, type[-n]); lag2 <- c(NA, NA, type[-c(n - 1L, n)])
  per2 <- c(NA, NA, per[-c(n - 1L, n)]); t2 <- c(NA, NA, adj_t[-c(n - 1L, n)])
  misfiled <- (type %in% .try_types & lag1 %in% kickoff & grepl("touchdown", lag2, ignore.case = TRUE) &
                 (per == per2) %in% TRUE & (adj_t == t2) %in% TRUE)
  if (!any(misfiled)) return(seq_len(n))
  key <- ifelse(misfiled, seq_len(n) - 1.5, seq_len(n))
  order(key, method = "radix")
}

#' Give the engine frame a `play_order` if the adapter did not
#'
#' ESPN adapters set it from `.espn_play_order()`. Elsewhere (the CFBD path, whose
#' plays carry none of the fields the repairs read) it is plain id order, compared
#' as digit strings so 18-digit ids sort exactly.
#' @keywords internal
#' @noRd
.pbp_ensure_play_order <- function(df) {
  if ("play_order" %in% names(df) && !anyNA(df$play_order)) return(df)
  idc <- .id_digits(df$id_play)
  df$play_order <- order(order(as.character(df$game_id), nchar(idc), idc, method = "radix"))
  df
}

#' Play ids as digit strings; as.character() writes a round double as "4e+17"
#' @keywords internal
#' @noRd
.id_digits <- function(x) if (is.numeric(x)) sprintf("%.0f", x) else as.character(x)
