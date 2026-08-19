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
#'   * no catch text, or an abbreviation that resolves to neither -> `NA`
#'
#'   Sided with the same prefix-tolerant matcher the recovery and penalty teams
#'   use, so ESPN's two-abbreviation-form inconsistency (`BUF` in the text,
#'   `BUFF` in the payload) still resolves.
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
#'   and abbreviations, `yards_gained` and `completion`.
#' @return `play_df` with `air_yardsToEndzone`, `air_yards` and
#'   `yards_after_catch` appended (integer, `NA` where undetermined).
#' @keywords internal
#' @importFrom stringr str_match
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

  # The optional "the " is not in sdv-py's pattern and is required here. sdv-py
  # parses ESPN's CDN summary feed, which writes "caught at OU35"; cfbfastR's v2
  # path parses core-v2, which writes "caught at the UGA20" for the same event.
  # A verbatim port of the Python regex matches ZERO rows on cfbfastR's own
  # feed. Accepting the article matches both forms, so the oracle stays at exact
  # parity and the production path starts resolving.
  m <- stringr::str_match(
    txt,
    stringr::regex("(?:caught at|thrown to) (?:the )?([A-Za-z]+)(\\d{1,2})",
                   ignore_case = TRUE)
  )
  catch_abbr <- toupper(m[, 2])
  catch_line <- suppressWarnings(as.integer(m[, 3]))

  air_to_ez <- ifelse(
    is.na(catch_abbr) | is.na(catch_line), NA_integer_,
    ifelse(.abbrev_compat(catch_abbr, pos_abbr), 100L - catch_line,
           ifelse(.abbrev_compat(catch_abbr, def_abbr), catch_line, NA_integer_)))

  air_yards <- as.integer(ytg) - air_to_ez
  # Completions only: an incompletion has a catch point but no yards after it.
  yac <- ifelse(completion, as.integer(gain) - air_yards, NA_integer_)

  play_df$air_yardsToEndzone <- as.integer(air_to_ez)
  play_df$air_yards <- as.integer(air_yards)
  play_df$yards_after_catch <- as.integer(yac)
  play_df
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
