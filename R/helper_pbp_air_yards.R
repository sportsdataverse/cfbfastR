#' @rdname helpers_pbp
#'
#' @description Split a completed pass into the yards thrown and the yards run
#'   after the catch. Ported from sdv-py's `CFBPlayProcess.__add_air_yards_cols`.
#'
#' @details ESPN annotates pass plays with the on-field catch point --
#'   `"caught at OU35"` on a completion, `"thrown to TEX42"` on a target. The
#'   stated yard line belongs to whichever team owns **that side of the field**,
#'   not to the offense, so the abbreviation has to be sided before the number
#'   means anything:
#'
#'   * catch abbreviation on the possessing team's side -> `100 - yardline`
#'   * catch abbreviation on the defending team's side  -> `yardline`
#'   * a spot at the 50 -> `50` (no abbreviation needed)
#'   * no catch text, or an abbreviation that resolves to neither -> `NA`
#'
#'   The 2025+ vendor text spots the catch with each school's **own**
#'   abbreviation (`UHM`, `GSO`, `USC` for South Carolina, `Sac St`, `BC.`),
#'   which is frequently not the payload's `home_team_abbreviation` /
#'   `away_team_abbreviation` (`HAW`, `GASO`, `SC`) -- in 2025 that dropped one
#'   whole team's plays in a quarter of new-template games. So the side is
#'   resolved in this order, per game (sdv-py #418):
#'
#'   1. the game's own text: the **last** `"... to the ABC nn"` end spot of
#'      every play is compared with the payload's `end_yards_to_endzone` and votes
#'      for `ABC` being the possessing or the defending team; the majority per
#'      abbreviation wins (at least two votes and 60% agreement, the 50 abstains);
#'   2. the payload abbreviations through the same prefix-tolerant matcher the
#'      recovery and penalty teams use (`BUF` / `BUFF` still resolves);
#'   3. otherwise `NA` -- never a guess.
#'
#'   Abbreviations are compared upper-cased with spaces and dots removed, so
#'   `Sac St10`, `NC ST19`, `UA 10` and `BC.41` all read as one token.
#'
#'   `yards_after_catch` is taken from `yards_gained` rather than
#'   `yds_receiving`: the two are the same quantity, but the receiving-yards
#'   extractor is empty on modern ESPN text (`"complete short middle to ..."`),
#'   so it cannot be used. It is computed for **completions only** -- an
#'   incompletion has a catch point but no yards after it, and subtracting there
#'   would invent a number.
#'
#' @param play_df (*data.frame* required): play frame carrying the play text,
#'   `yards_to_goal`, the possessing/defending team ids, the home/away team ids
#'   and abbreviations, `yards_gained` and `completion`; `end_yards_to_endzone`
#'   (the ESPN v2/summary adapters' end-of-play yardline; `yards_to_goal_end`
#'   and sdv-py's `end.yardsToEndzone` are accepted too) enables the
#'   game-learned siding and
#'   `game_id` scopes it per game when the frame holds several.
#' @return `play_df` with `air_yardsToEndzone`, `air_yards` and
#'   `yards_after_catch` appended (integer, `NA` where undetermined).
#' @keywords internal
#' @importFrom stringr str_match regex
#' @noRd
.pbp_add_air_yards_cols <- function(play_df) {
  n <- nrow(play_df)
  if (!n) return(play_df)

  chr <- function(x) if (is.null(x)) rep(NA_character_, n) else as.character(x)
  num <- function(x) if (is.null(x)) rep(NA_real_, n) else suppressWarnings(as.numeric(x))

  txt  <- chr(.attr_col(play_df, "play_text", "text"))
  pos  <- chr(.attr_col(play_df, "pos_team_id", "pos_team"))
  def  <- chr(.attr_col(play_df, "def_pos_team_id", "def_pos_team"))
  home_id <- chr(.attr_col(play_df, "home_team_id", "homeTeamId"))
  home_ab <- toupper(chr(.attr_col(play_df, "home_team_abbreviation", "homeTeamAbbrev")))
  away_ab <- toupper(chr(.attr_col(play_df, "away_team_abbreviation", "awayTeamAbbrev")))
  ytg  <- num(.attr_col(play_df, "yards_to_goal", "start.yardsToEndzone"))
  gain <- num(.attr_col(play_df, "yards_gained", "statYardage"))

  completion <- .attr_col(play_df, "completion")
  completion <- if (is.null(completion)) {
    rep(FALSE, n)
  } else if (is.logical(completion)) {
    !is.na(completion) & completion
  } else {
    !is.na(completion) & suppressWarnings(as.numeric(completion)) > 0
  }

  # pos_team / def_pos_team are ids; map each back to ITS abbreviation for this
  # play so the catch-point abbreviation can be sided against them.
  #
  # The NA arm is load-bearing. `.pbp_add_play_counts()` sets pos_team_id and
  # def_pos_team_id to NA for the WHOLE frame when the id columns it needs are
  # absent, and a bare `ifelse(pos == home_id, home_ab, away_ab)` sends both
  # sides to the away abbreviation on those rows. The first branch of the siding
  # logic below would then win every time and emit `100 - catch_line` for every
  # play -- wrong on roughly half of them, with nothing to show it. An unknown
  # side must stay unknown so the catch point resolves to NA instead.
  side_abbr <- function(team_id) {
    ifelse(is.na(team_id) | is.na(home_id), NA_character_,
           ifelse(team_id == home_id, home_ab, away_ab))
  }
  pos_abbr <- side_abbr(pos)
  def_abbr <- side_abbr(def)

  # First end-yardline alias that actually carries values: an all-NA canonical
  # column must not mask a populated legacy alias.
  end_ytg <- num(.first_usable_col(play_df, "end_yards_to_endzone", "yards_to_goal_end", "end.yardsToEndzone"))
  gid <- .attr_col(play_df, "game_id", "gameId")
  gid <- if (is.null(gid)) rep(1L, n) else as.character(gid)
  gid[is.na(gid)] <- "<NA>"  # split() would silently drop NA groups

  # sdv-py's CDN summary feed writes "caught at OU35"; cfbfastR's core-v2 path
  # writes "caught at the UGA20" for the same event. Both are accepted (as sdv-py
  # does since #418), and the vendor token is read whole: "SDSU47", "UA 10",
  # "Sac St10", "NC ST19", "BC.41", or a bare "50".
  m <- stringr::str_match(txt, stringr::regex(.catch_spot_re, ignore_case = TRUE))
  catch_key <- .spot_key(m[, 2])
  catch_line <- suppressWarnings(as.integer(m[, 3]))

  # Learn this game's text abbreviations from its own end spots, then side the
  # catch spot with that map first; the payload abbreviations are the fallback.
  catch_team <- rep(NA_character_, n)
  for (ix in split(seq_len(n), gid)) {
    side <- .spot_side_map(txt[ix], end_ytg[ix], pos[ix], def[ix])
    if (length(side)) catch_team[ix] <- unname(side[catch_key[ix]])
  }
  # Compare like with like: the payload abbreviations get the same
  # normalisation as the text token ("NC ST" -> "NCST", "BC." -> "BC").
  side_pos <- (!is.na(catch_team) & catch_team == pos) |
    (is.na(catch_team) & .abbrev_compat(catch_key, .spot_key(pos_abbr)))
  side_def <- (!is.na(catch_team) & catch_team == def) |
    (is.na(catch_team) & .abbrev_compat(catch_key, .spot_key(def_abbr)))

  air_to_ez <- ifelse(
    is.na(catch_line), NA_integer_,
    # midfield is 50 from either endzone; the text often carries no abbreviation there
    ifelse(catch_line == 50L, 50L,
      ifelse(is.na(catch_key), NA_integer_,
        ifelse(side_pos, 100L - catch_line,
          ifelse(side_def, catch_line, NA_integer_)))))

  air_yards <- as.integer(ytg) - air_to_ez
  # Completions only: an incompletion has a catch point but no yards after it.
  yac <- ifelse(completion, as.integer(gain) - air_yards, NA_integer_)

  play_df$air_yardsToEndzone <- as.integer(air_to_ez)
  play_df$air_yards <- as.integer(air_yards)
  play_df$yards_after_catch <- as.integer(yac)
  play_df
}

# A field-position token in the 2025+ vendor play text: a school abbreviation of
# up to two words in any case ("SDSU", "Sac St", "NC ST", "Mizzou", "Wake F",
# "BC."), an optional dot/space, then the 1-2 digit yardline. The abbreviation is
# optional so a bare "50" (midfield) still yields the yardline. Mirrors sdv-py's
# _SPOT_TOKEN_RE / _CATCH_SPOT_RE / _END_SPOT_RE (cfb_pbp.py, #418).
.spot_token_re <- "(?:([A-Za-z][A-Za-z&.\\-]*(?: [A-Za-z][A-Za-z&.\\-]*)?)\\.? ?)?(\\d{1,2})\\b"
.catch_spot_re <- paste0("(?:caught at|thrown to) (?:the )?", .spot_token_re)
.end_spot_re <- paste0("to the ", .spot_token_re)

# First of the named columns that is present AND carries at least one non-NA
# value; NULL when none does. .attr_col() returns the first PRESENT column.
.first_usable_col <- function(df, ...) {
  for (nm in c(...)) {
    if (nm %in% names(df) && any(!is.na(df[[nm]]))) return(df[[nm]])
  }
  NULL
}

# Normalise a text abbreviation for matching: upper-case, no spaces or dots.
.spot_key <- function(x) {
  out <- gsub("[ .]", "", toupper(x))
  out[!is.na(out) & !nzchar(out)] <- NA_character_
  out
}

# Learn which team each text abbreviation refers to, from one game's end spots.
# Port of sdv-py's _spot_side_map: for every play whose text carries a
# "... to the ABC nn" spot (the LAST one when there are several -- a fumble
# return or a penalty restatement names two, and the payload's end yardline
# describes the final one) and whose end_yards_to_endzone is known, the yardline is
# either nn (ABC is the defending team's side) or 100 - nn (the possessing
# team's side). Each such play votes; the majority per abbreviation wins, with a
# floor of two votes and 60% agreement so one mis-stated spot cannot flip a
# side. The 50 abstains (it votes for both). Returns a named character vector,
# key -> team id, empty when nothing can be learned.
.spot_side_map <- function(txt, end_ytg, pos, def) {
  if (!length(txt) || all(is.na(end_ytg))) return(character())
  # Greedy ".*" backs off to the LAST "to the <token>" in the (single-line) text.
  m <- stringr::str_match(txt, stringr::regex(paste0(".*", .end_spot_re), ignore_case = TRUE))
  key <- .spot_key(m[, 2])
  yl <- suppressWarnings(as.integer(m[, 3]))
  end_i <- suppressWarnings(as.integer(end_ytg))
  team <- ifelse(!is.na(end_i) & !is.na(yl) & end_i == 100L - yl, pos,
                 ifelse(!is.na(end_i) & !is.na(yl) & end_i == yl, def, NA_character_))
  ok <- !is.na(key) & !is.na(yl) & yl != 50L & !is.na(team)
  if (!any(ok)) return(character())
  votes <- table(key[ok], team[ok])
  out <- character()
  for (k in rownames(votes)) {
    v <- votes[k, ]
    top <- which.max(v)
    if (v[[top]] >= 2 && v[[top]] >= 0.6 * sum(v)) out[[k]] <- colnames(votes)[top]
  }
  out
}

#' @rdname helpers_pbp
#'
#' @description Extract the pass depth/direction, rush direction and
#'   quarterback-hurry flag that ESPN states in the play text. Ported from the
#'   corresponding block of sdv-py's `CFBPlayProcess.__add_player_cols`.
#'
#' @details Four cheap text reads that cfbfastR never surfaced, all `NA` where
#'   ESPN omits the phrase (sacks, screens, and older seasons that do not
#'   annotate depth or direction at all).
#'
#'   The depth/direction patterns are deliberately **case-sensitive**, matching
#'   sdv-py: ESPN writes these tokens lowercase mid-sentence, and folding case
#'   would let a capitalised team or player name ("Deep", "Wright") match. The
#'   hurry pattern is case-insensitive because it is a whole phrase, not a word
#'   that collides with a name.
#'
#' @param play_df (*data.frame* required): play frame with the play text and the
#'   `pass` / `rush` flags.
#' @return `play_df` with `pass_depth`, `pass_direction`, `rush_direction` and
#'   `qb_hurry` appended.
#' @keywords internal
#' @importFrom stringr str_match str_detect regex
#' @noRd
.pbp_add_pass_direction_cols <- function(play_df) {
  n <- nrow(play_df)
  if (!n) return(play_df)

  txt <- if (!is.null(.attr_col(play_df, "play_text", "text"))) {
    as.character(.attr_col(play_df, "play_text", "text"))
  } else {
    rep(NA_character_, n)
  }
  gate <- function(nm) {
    v <- .attr_col(play_df, nm)
    if (is.null(v)) return(rep(FALSE, n))
    if (is.logical(v)) return(!is.na(v) & v)
    !is.na(v) & suppressWarnings(as.numeric(v)) > 0
  }
  is_pass <- gate("pass")
  is_rush <- gate("rush")

  grab <- function(pattern, keep) {
    hit <- stringr::str_match(txt, pattern)[, 2]
    ifelse(keep, hit, NA_character_)
  }

  play_df$pass_depth <- grab("\\s(short|deep)\\s", is_pass)
  play_df$pass_direction <- grab("\\s(left|middle|right)\\s", is_pass)
  play_df$rush_direction <- grab("\\s(left|middle|right)\\s", is_rush)
  # Null text must read FALSE, not NA, so the flag stays a clean boolean for
  # downstream filters and models.
  play_df$qb_hurry <- !is.na(txt) &
    stringr::str_detect(txt, stringr::regex("\\shurried by\\s", ignore_case = TRUE))
  play_df
}
