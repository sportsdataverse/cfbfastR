#' @rdname helpers_pbp
#'
#' @description Resolve **which team** each play event belongs to. Ported from
#'   sdv-py's `CFBPlayProcess.__add_attribution_cols`.
#'
#' @details cfbfastR knew *what* happened on a play and *who* did it, but not
#'   which side to credit. That gap is why every special-teams role in
#'   [.pbp_attach_player_ids()] matched against a team column that did not
#'   exist, and why no turnover column could be derived at all.
#'
#'   Three ideas do the work:
#'
#'   \describe{
#'     \item{The special-teams flip}{`pos_team` means the receiving team on a
#'       kickoff and the kicking team on a punt or field goal. Every kicking /
#'       return column follows from getting that one convention right.}
#'     \item{The possession chain}{A play can change hands more than once --
#'       offense fumbles, defense recovers and returns, defense fumbles back --
#'       so the text is walked as an ordered list of `recovered by {TEAM}`
#'       clauses. Each change of holder charges one fumble-lost, and the flags
#'       are framed **per side** so both teams can register a turnover on the
#'       same play, matching the official box's per-event accounting.}
#'     \item{Overturned plays are stripped first}{ESPN appends the *reversed*
#'       description in a trailing `(Original Play: ...)` clause. Parsing
#'       recoveries out of that counts a reversed fumble as a real turnover.}
#'   }
#'
#'   Blocked punts and blocked field goals get their own flags rather than
#'   joining `is_turnover`, because ESPN's official box counts only giveaways
#'   (interceptions and fumbles lost). Folding them in would break the
#'   reconciliation against that box while looking more complete.
#'
#' @param play_df (*data.frame* required): play-by-play frame carrying the play
#'   flags, text and the home/away team identifiers.
#' @return `play_df` with the attribution columns appended -- `kicking_team`,
#'   `return_team`, `fumble_or_muff`, `fumbling_team`, `recovery_team`,
#'   `recovery_team_2`, `turnover_team`, `is_turnover`, `is_st_turnover`,
#'   `int_turnover`, `pos_fumble_lost`, `def_fumble_lost`,
#'   `is_pos_team_turnover`, `is_def_pos_team_turnover`,
#'   `is_blocked_punt_turnover`, `is_blocked_fg_turnover`, `sack_team`,
#'   `interception_team`, `pass_breakup_team`, `forced_fumble_team`,
#'   `fumble_recovery_team`, `punt_return_team`, `kick_return_team`, `fg_team`,
#'   `punt_team`, `penalized_team`, `penalty_team_id` and
#'   `penalty_yards_signed`. Team columns are character team ids.
#' @keywords internal
#' @importFrom stringr str_detect str_match_all str_match str_remove regex
#' @noRd

# Trailing "(Original Play: ...)" clause on a reviewed/overturned play.
.overturned_pattern <- "(?is)\\(Original Play:.*?\\)\\s*$"

# "recovered by TEAM" -- one clause per change of possession, in text order.
.recovery_abbrev_pattern <- "recovered by\\s+([A-Z&]{2,})\\b"

# Penalty-detail labels that indicate a DEFENSIVE foul. "Pass Interference" is
# here because the upstream detector emits that generic label for BOTH offensive
# and defensive PI, so a bare "Pass Interference" cannot be assumed offensive.
# "Encroachment" is deliberately absent: in NCAA usage it is an OFFENSIVE foul
# (lineman in the neutral zone), unlike the NFL's defensive usage.
.defensive_penalties <- c(
  "Defensive Holding", "Defensive Pass Interference", "Defensive Offside",
  "Roughing the Passer", "Roughing the Kicker", "Roughing the Holder",
  "Roughing the Snapper", "12 Men on the Field", "Neutral Zone Infraction",
  "Targeting", "Pass Interference"
)

# (pattern, direction). Direction controls the word-shrink order: "prefix" puts
# the team first after "PENALTY" ("BAYLOR Pass Interference" -> "BAYLOR"),
# "suffix" puts it last before "Penalty," ("for a TD Vanderbilt Penalty," ->
# "Vanderbilt"). The suffix form also admits "(" so "Miami (OH) Penalty,"
# captures whole.
.penalty_token_patterns <- list(
  c("PENALTY[,:]?\\s+(?:on\\s+)?([A-Z][\\w.&'-]*(?:\\s+[A-Z][\\w.&'-]*){0,2})", "prefix"),
  c("([A-Z(][\\w.&'()-]*(?:\\s+[A-Z(][\\w.&'()-]*){0,2})\\s+Penalty,", "suffix")
)

# Uppercase and strip non-alphanumerics for team-token comparison.
.squash_team <- function(x) {
  if (is.null(x) || length(x) == 0L || is.na(x)) return("")
  gsub("[^A-Z0-9]", "", toupper(as.character(x)))
}

# TRUE when `needle`'s characters appear in `hay` in order. Handles ESPN's
# vowel-dropped spellings ("WESTMICH" vs "Western Michigan") that neither
# equality nor a prefix test matches.
.is_char_subseq <- function(needle, hay) {
  n <- strsplit(needle, "", fixed = TRUE)[[1]]
  h <- strsplit(hay, "", fixed = TRUE)[[1]]
  j <- 1L
  for (ch in n) {
    hit <- FALSE
    while (j <= length(h)) {
      if (h[j] == ch) { hit <- TRUE; j <- j + 1L; break }
      j <- j + 1L
    }
    if (!hit) return(FALSE)
  }
  TRUE
}

# 0 = no match, 1 = subsequence/alias, 2 = prefix either way, 3 = exact.
.score_team_match <- function(tok, cands) {
  best <- 0L
  for (cand in cands) {
    if (!nzchar(cand)) next
    if (identical(tok, cand)) return(3L)
    if (startsWith(cand, tok) || startsWith(tok, cand)) {
      best <- max(best, 2L)
    } else if (nchar(tok) >= 3L && .is_char_subseq(tok, cand)) {
      best <- max(best, 1L)
    }
  }
  best
}

# Derived initialism aliases ("UT" for Texas, "OSU" for Ohio State) that the
# payload never carries. Single-word names already in all caps are skipped --
# prefixing "TCU" would invent the OPPONENT's alias. Weak tier only.
.team_alias_initialisms <- function(name) {
  if (is.null(name) || is.na(name) || !nzchar(name)) return(character(0))
  words <- strsplit(trimws(name), "\\s+")[[1]]
  if (length(words) == 1L) {
    if (identical(name, toupper(name))) return(character(0))
    first <- substr(.squash_team(name), 1L, 1L)
    return(c(paste0("U", first), paste0(first, "U")))
  }
  initials <- toupper(paste(substr(words, 1L, 1L), collapse = ""))
  c(initials, paste0(initials, "U"), paste0("U", initials))
}

# Resolve the PENALIZED team from play text to "home" / "away" / NA. Attribution
# is a binary choice per game, so the extracted token only has to match one
# side's candidates BETTER than the other's; a tie returns NA so the caller
# falls back to the foul-direction heuristic rather than guessing.
.parse_penalty_team_side <- function(text, home, away, home_alias, away_alias) {
  if (is.na(text) || !nzchar(text)) return(NA_character_)
  for (pat in .penalty_token_patterns) {
    hits <- stringr::str_match_all(text, pat[1])[[1]]
    if (!nrow(hits)) next
    for (r in seq_len(nrow(hits))) {
      words <- strsplit(trimws(hits[r, 2]), "\\s+")[[1]]
      if (!length(words)) next
      for (k in seq(length(words), 1L)) {
        run <- if (identical(pat[2], "prefix")) words[seq_len(k)] else utils::tail(words, k)
        tok <- .squash_team(paste(run, collapse = " "))
        if (nchar(tok) < 2L) next
        # also try the U-university prefix stripped ("UMass" -> "MASS")
        toks <- c(tok, if (startsWith(tok, "U") && nchar(tok) >= 4L) substring(tok, 2L))
        for (t in toks) {
          hs <- .score_team_match(t, home)
          as_ <- .score_team_match(t, away)
          if (hs == as_) {
            hs  <- as.integer(t %in% home_alias)
            as_ <- as.integer(t %in% away_alias)
          }
          if (hs > as_) return("home")
          if (as_ > hs) return("away")
        }
      }
    }
  }
  NA_character_
}

# Prefix-tolerant team-abbreviation match. ESPN ships two abbreviation forms for
# some teams -- the play text says "recovered by BUF" while awayTeamAbbrev
# carries "BUFF". In a two-team game cross-opponent collisions are effectively
# nonexistent.
.abbrev_compat <- function(abbr, team) {
  !is.na(abbr) & !is.na(team) & nzchar(abbr) & nzchar(team) &
    (abbr == team | startsWith(team, abbr) | startsWith(abbr, team))
}

# First column present and not entirely NA, else NULL. Two frames reach this
# helper -- the engine's (play_text / play_type / home_team_id) and sdv-py's
# (text / type.text / homeTeamId) -- and aliasing here is what lets one oracle
# test the code that actually runs.
.attr_col <- function(df, ...) {
  for (nm in c(...)) {
    if (nm %in% names(df)) return(df[[nm]])
  }
  NULL
}

.pbp_add_attribution_cols <- function(play_df) {
  n <- nrow(play_df)
  if (!n) return(play_df)

  chr <- function(x) if (is.null(x)) rep(NA_character_, n) else as.character(x)
  # ESPN flags arrive as logical from sdv-py and 1/0 numeric from cfbfastR's
  # own taxonomy; both must read as TRUE, and an absent flag as FALSE.
  flag <- function(x) {
    if (is.null(x)) return(rep(FALSE, n))
    if (is.logical(x)) return(!is.na(x) & x)
    !is.na(x) & suppressWarnings(as.numeric(x)) > 0
  }

  pos  <- chr(.attr_col(play_df, "pos_team_id", "pos_team"))
  def  <- chr(.attr_col(play_df, "def_pos_team_id", "def_pos_team"))
  txt  <- chr(.attr_col(play_df, "play_text", "text"))
  ptyp <- chr(.attr_col(play_df, "play_type", "type.text"))
  home_id <- chr(.attr_col(play_df, "home_team_id", "homeTeamId"))
  away_id <- chr(.attr_col(play_df, "away_team_id", "awayTeamId"))
  home_ab <- toupper(chr(.attr_col(play_df, "home_team_abbreviation", "homeTeamAbbrev")))
  away_ab <- toupper(chr(.attr_col(play_df, "away_team_abbreviation", "awayTeamAbbrev")))

  kickoff <- flag(.attr_col(play_df, "kickoff_play"))
  punt    <- flag(.attr_col(play_df, "punt"))
  fumble  <- flag(.attr_col(play_df, "fumble_vec"))
  is_int  <- flag(.attr_col(play_df, "int"))
  coposs  <- flag(.attr_col(play_df, "change_of_poss", "change_of_pos_team"))

  # `fg_attempt`, `sp` and `scrimmage_play` are sdv-py flags that cfbfastR's
  # pipeline never produced. Letting them default to FALSE would not fail
  # anything -- it would silently drop field goals out of `kicking_team`, strand
  # the special-teams branch of `fumbling_team`, and make the `is_st_turnover`
  # and possession-change fallbacks unreachable. So when the frame does not
  # carry them they are derived from the shared play-type taxonomy, which is the
  # same definition sdv-py uses.
  tt <- .pbp_play_types()
  in_types <- function(v) !is.na(ptyp) & ptyp %in% v
  fg_att <- if ("fg_attempt" %in% names(play_df)) {
    flag(play_df$fg_attempt)
  } else {
    in_types(tt$field_goal)
  }
  sp <- if ("sp" %in% names(play_df)) {
    flag(play_df$sp)
  } else {
    kickoff | punt | fg_att
  }
  scrim <- if ("scrimmage_play" %in% names(play_df)) {
    flag(play_df$scrimmage_play)
  } else {
    # Everything that is neither special teams nor an administrative row.
    !sp & !in_types(c(tt$penalty, "End Period", "End of Half", "End of Game",
                      "Timeout", "Coin Toss"))
  }

  ci <- function(p) stringr::regex(p, ignore_case = TRUE)

  # --- special-teams flip -------------------------------------------------
  kicking_team <- ifelse(kickoff, def, ifelse(punt | fg_att, pos, NA_character_))
  return_team  <- ifelse(kickoff, pos, ifelse(punt | fg_att, def, NA_character_))

  fumble_or_muff <- fumble | (!is.na(txt) & stringr::str_detect(txt, ci("muff")))

  # --- recovery chain, on the ruled portion of the text only --------------
  clean_txt <- stringr::str_remove(txt, .overturned_pattern)
  clean_txt <- trimws(clean_txt)
  rec <- lapply(clean_txt, function(s) {
    if (is.na(s) || !nzchar(s)) return(character(0))
    m <- stringr::str_match_all(s, .recovery_abbrev_pattern)[[1]]
    if (!nrow(m)) character(0) else toupper(m[, 2])
  })
  nth <- function(i) vapply(rec, function(v) if (length(v) >= i) v[i] else NA_character_, character(1))

  abbrev_to_id <- function(abbr) {
    ifelse(is.na(abbr), NA_character_,
           ifelse(.abbrev_compat(abbr, home_ab), home_id,
                  ifelse(.abbrev_compat(abbr, away_ab), away_id, NA_character_)))
  }
  recovery_team   <- abbrev_to_id(nth(1L))
  recovery_team_2 <- abbrev_to_id(nth(2L))

  # --- special-teams RETURN detection (flag OR text) ----------------------
  # ESPN sometimes reclassifies a return fumble to "Fumble Recovery (...)" and
  # DROPS the punt/kickoff flags, so a text fallback is required to recover the
  # special-teams nature and attribute the fumble to the returning team.
  has <- function(p) !is.na(txt) & stringr::str_detect(txt, ci(p))
  is_kick_return <- kickoff | (has("kickoff") & has("return|muff"))
  is_punt_return <- punt | (has("punt") & has("return|muff|fair catch"))

  # --- fumbling team ------------------------------------------------------
  fumbling_team <- ifelse(
    !fumble_or_muff, NA_character_,
    ifelse(is_int, def,
           ifelse(is_kick_return, pos,
                  ifelse(is_punt_return, def,
                         ifelse(sp, return_team, pos)))))

  # --- possession-chain turnover model ------------------------------------
  same <- function(a, b) !is.na(a) & !is.na(b) & a == b
  diff <- function(a, b) !is.na(a) & !is.na(b) & a != b

  loser_1 <- ifelse(
    fumble_or_muff & !is.na(recovery_team) & !is.na(fumbling_team) &
      diff(recovery_team, fumbling_team),
    fumbling_team,
    # last-resort possession-change fallback: scrimmage offense fumbles only
    ifelse(fumble_or_muff & is.na(recovery_team) & scrim & !is_int &
             !is_punt_return & !is_kick_return & same(fumbling_team, pos) & coposs,
           fumbling_team, NA_character_))

  loser_2 <- ifelse(
    fumble_or_muff & !is.na(recovery_team_2) & !is.na(recovery_team) &
      diff(recovery_team_2, recovery_team),
    recovery_team, NA_character_)

  int_turnover    <- is_int
  pos_fumble_lost <- same(loser_1, pos) | same(loser_2, pos)
  def_fumble_lost <- same(loser_1, def) | same(loser_2, def)

  is_pos_team_turnover <- int_turnover | pos_fumble_lost
  is_def_pos_team_turnover <- def_fumble_lost
  is_turnover <- is_pos_team_turnover | is_def_pos_team_turnover
  turnover_team <- ifelse(is_pos_team_turnover, pos,
                          ifelse(is_def_pos_team_turnover, def, NA_character_))
  # Interceptions are never special teams.
  is_st_turnover <- (pos_fumble_lost | def_fumble_lost) &
    (sp | is_punt_return | is_kick_return)

  # Blocked kicks stay OUT of is_turnover: ESPN's official box counts only
  # giveaways, and folding them in breaks the reconciliation against it. These
  # standalone flags surface the possession loss the giveaway derivation misses.
  blocked <- function(td_label, plain_label) {
    ifelse(!is.na(ptyp) & ptyp == td_label, TRUE,
           !is.na(ptyp) & ptyp == plain_label & coposs)
  }
  is_blocked_punt_turnover <- blocked("Blocked Punt Touchdown", "Blocked Punt")
  is_blocked_fg_turnover <- blocked("Blocked Field Goal Touchdown", "Blocked Field Goal")

  # --- event -> credited team --------------------------------------------
  # A recovery is never dropped just because the abbreviation failed to match:
  # fall back to the gaining side on a turnover, the fumbling side on an own
  # recovery.
  fumble_recovery_team <- ifelse(
    !is.na(recovery_team), recovery_team,
    ifelse(!fumble_or_muff, NA_character_,
           ifelse(is_turnover,
                  ifelse(same(fumbling_team, pos), def, pos),
                  fumbling_team)))

  # --- penalties ----------------------------------------------------------
  pen_detail <- chr(.attr_col(play_df, "penalty_detail"))
  home_nm  <- chr(.attr_col(play_df, "home_team_name", "homeTeamName"))
  away_nm  <- chr(.attr_col(play_df, "away_team_name", "awayTeamName"))
  home_alt <- chr(.attr_col(play_df, "homeTeamNameAlt", "home_team"))
  away_alt <- chr(.attr_col(play_df, "awayTeamNameAlt", "away_team"))
  home_msc <- chr(.attr_col(play_df, "homeTeamMascot"))
  away_msc <- chr(.attr_col(play_df, "awayTeamMascot"))

  nz <- function(x) if (is.na(x)) "" else x
  side <- vapply(seq_len(n), function(i) {
    if (is.na(pen_detail[i])) return(NA_character_)
    hc <- c(.squash_team(home_ab[i]), .squash_team(home_nm[i]), .squash_team(home_alt[i]),
            .squash_team(paste0(nz(home_nm[i]), nz(home_msc[i]))))
    ac <- c(.squash_team(away_ab[i]), .squash_team(away_nm[i]), .squash_team(away_alt[i]),
            .squash_team(paste0(nz(away_nm[i]), nz(away_msc[i]))))
    .parse_penalty_team_side(txt[i], hc, ac,
                             .team_alias_initialisms(home_nm[i]),
                             .team_alias_initialisms(away_nm[i]))
  }, character(1))

  penalty_from_text <- ifelse(is.na(side), NA_character_,
                              ifelse(side == "home", home_id, away_id))
  # Best evidence first: the binary home/away text resolver, then the
  # foul-direction heuristic, then the offense.
  penalized_team <- ifelse(
    is.na(pen_detail), NA_character_,
    ifelse(!is.na(penalty_from_text), penalty_from_text,
           ifelse(pen_detail %in% .defensive_penalties, def, pos)))

  yds_pen <- chr(.attr_col(play_df, "yds_penalty", "penalty_yards"))
  signed <- suppressWarnings(as.integer(stringr::str_match(yds_pen, "(-?\\d+)")[, 2]))
  signed[is.na(signed)] <- 0L

  play_df$kicking_team <- kicking_team
  play_df$return_team <- return_team
  play_df$fumble_or_muff <- fumble_or_muff
  play_df$fumbling_team <- fumbling_team
  play_df$recovery_team <- recovery_team
  play_df$recovery_team_2 <- recovery_team_2
  play_df$int_turnover <- int_turnover
  play_df$pos_fumble_lost <- pos_fumble_lost
  play_df$def_fumble_lost <- def_fumble_lost
  play_df$is_pos_team_turnover <- is_pos_team_turnover
  play_df$is_def_pos_team_turnover <- is_def_pos_team_turnover
  play_df$is_turnover <- is_turnover
  play_df$turnover_team <- turnover_team
  play_df$is_st_turnover <- is_st_turnover
  play_df$is_blocked_punt_turnover <- is_blocked_punt_turnover
  play_df$is_blocked_fg_turnover <- is_blocked_fg_turnover
  play_df$sack_team <- def
  play_df$interception_team <- def
  play_df$pass_breakup_team <- def
  play_df$forced_fumble_team <- def
  play_df$fumble_recovery_team <- fumble_recovery_team
  play_df$punt_return_team <- return_team
  play_df$kick_return_team <- return_team
  play_df$fg_team <- kicking_team
  play_df$punt_team <- kicking_team
  play_df$penalized_team <- penalized_team
  play_df$penalty_team_id <- penalized_team
  play_df$penalty_yards_signed <- signed

  play_df
}
