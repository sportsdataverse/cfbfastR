#' @rdname helpers_pbp
#'
#' @description Resolve each captured `*_player_name` to an ESPN `athlete_id`,
#'   producing the matching `*_player_id` column. Ported from sdv-py's
#'   `CFBPlayProcess.__attach_player_ids`.
#'
#' @details cfbfastR has always extracted player *names* and never resolved them
#'   to an identity, so every downstream join was string-keyed and collided
#'   whenever two players shared a name. This closes that gap.
#'
#'   Matching is **team-aware**: each role maps to the team that fielded it (a
#'   sack belongs to the defence, a punt return to the receiving team), so
#'   identical names on opposing rosters cannot collide. Four tiers are tried in
#'   order -- exact name within team, globally-unique name, first-initial +
#'   surname within team, surname within team -- and the fuzzy tiers are
#'   **withheld** while a captured name still carries a narrative tail, because a
#'   tail word is itself a plausible surname: with roster entries
#'   "Russell Wilson" and "Alex Screen", running the surname tier on
#'   `"Russell Wilson screen"` resolves it to Alex Screen.
#'
#'   The trailing `(TEAM)` strip is unconditional -- a parenthesised team code is
#'   never part of a person's name. The narrative-tail strip is applied only when
#'   the roster confirms the trimmed form, so a real surname that collides with a
#'   stopword ("John Middle") survives instead of being truncated and then
#'   mis-resolved.
#'
#'   With no roster supplied only the name cleanup runs, and the id columns are
#'   created as all-`NA` so the output shape is stable either way.
#'
#' @param raw_df (*data.frame* required): frame that has been through
#'   [add_player_cols()], carrying the `*_player_name` columns.
#' @param roster (*data.frame* optional): game roster with `athlete_id`,
#'   `athlete_display_name` (or `full_name`) and `team_id`. Supply the cached
#'   roster rather than re-fetching per game -- see [espn_cfb_pbp_v2()].
#' @return `raw_df` with cleaned `*_player_name` columns and one `*_player_id`
#'   per role.
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom stringr str_replace str_replace_all str_squish str_detect regex
#' @importFrom dplyr mutate
#' @noRd

# role -> (name column, id column, team column that fielded the role).
#
# The team columns are the ID-keyed ones. `pos_team` / `def_pos_team` are team
# NAMES resolved through the ESPN teams catalog, and they go NA whenever that
# catalog is unavailable -- which takes the team-aware tier with them and
# silently drops every match down to the global-unique fallback. The ids come
# straight off the play. `kicking_team` / `return_team` / `punt_return_team` /
# `fumble_recovery_team` are produced by `.pbp_add_attribution_cols()`; before
# that landed they did not exist at all, so every special-teams role matched
# with a NA team.
.pbp_player_id_team_map <- list(
  c("rusher_player_name",            "rusher_player_id",            "pos_team_id"),
  c("passer_player_name",            "passer_player_id",            "pos_team_id"),
  c("receiver_player_name",          "receiver_player_id",          "pos_team_id"),
  c("fumble_player_name",            "fumble_player_id",            "pos_team_id"),
  c("sack_player_name",              "sack_player_id",              "def_pos_team_id"),
  c("sack_player_name2",             "sack_player_id2",             "def_pos_team_id"),
  c("interception_player_name",      "interception_player_id",      "def_pos_team_id"),
  c("pass_breakup_player_name",      "pass_breakup_player_id",      "def_pos_team_id"),
  c("fumble_forced_player_name",     "fumble_forced_player_id",     "def_pos_team_id"),
  c("fumble_recovered_player_name",  "fumble_recovered_player_id",  "fumble_recovery_team"),
  c("fg_kicker_player_name",         "fg_kicker_player_id",         "kicking_team"),
  c("punter_player_name",            "punter_player_id",            "kicking_team"),
  c("kickoff_player_name",           "kickoff_player_id",           "kicking_team"),
  c("kickoff_return_player_name",    "kickoff_return_player_id",    "return_team"),
  c("punt_return_player_name",       "punt_return_player_id",       "punt_return_team"),
  c("fg_block_player_name",          "fg_block_player_id",          "return_team"),
  c("punt_block_player_name",        "punt_block_player_id",        "return_team"),
  c("fg_return_player_name",         "fg_return_player_id",         "return_team"),
  c("punt_block_return_player_name", "punt_block_return_player_id", "return_team")
)

# ESPN's pre-2014 play text renders a name as "Player Name (TEAM)". The rusher
# capture strips the parenthetical but the passer capture keeps it, and the
# normalizer then folds it into the join key ("matt ryan bc" != "matt ryan"), so
# every 2004 passer failed the roster join. Stripping it at the shared cleanup
# chokepoint fixes the emitted name column AND the join in one place.
.player_name_team_suffix <- "\\s*\\([A-Za-z][\\w&'.[:space:]-]{0,11}\\)\\s*$"

# Tokens that mean the capture swallowed play narration rather than a name.
.player_name_garbage <-
  "\\b(loss|gain|yards?|incomplete|penalty|fumbled|sacked|touchdown|kickoff|punt|return|hurried by|QB)\\b"

# Narrative tails that bleed into a captured name where the extraction regex has
# no stopword boundary: pass-direction phrases ("Russell Wilson deep out") and
# missing-space concatenations in ESPN's own text ("Raynard Hornetackled by").
# Anchored to end-of-string and matched without a leading word boundary so the
# concatenated form sheds the tail and keeps the surname.
.player_name_tail <- paste0(
  "\\s*(?:tackled\\s+by|pushed\\s+out\\s+of\\s+bounds|ran\\s+out\\s+of\\s+bounds",
  "|deep\\s+(?:left|right|middle|out)|short\\s+(?:left|right|middle)",
  "|sideline|crossing|screen|middle|scramble)\\s*\\.?\\s*$"
)

# ASCII-fold, lowercase, drop punctuation + generational suffixes, collapse
# whitespace. Empty input returns "" so it never matches.
#
# The team sentinel ("TEAM run for a loss of 2 yards") is NOT blanked here. It
# used to be, because with only a game roster to match against there is no
# "team" record to hit exactly, so the sentinel fell through to the surname tier
# and resolved to whichever roster player the fallback happened to reach -- a
# wrong athlete on a play that had no individual ball carrier at all.
#
# ESPN's box score DOES carry the sentinel, as a negative athlete id (`-5154`,
# name `" Team"`), which is the id sdv-py credits. So the rule is not "never
# match" but "exact match only": the fuzzy tiers are withheld for it in
# `match_one()`, leaving the exact tiers to hit when the box score is present
# and to miss -- yielding NA, the old behaviour -- when it is not.
#
# The blank-out below is deliberately CASE-SENSITIVE and deliberately runs
# before folding, mirroring sdv-py's `_norm_player_name`. This looks like a bug
# and is load-bearing, so do not "fix" it: ESPN writes three different strings
# and they mean different things.
#
#   "TEAM"  play-text sentinel on a team-credited rush -> resolves to the box
#           score's team entry, which is the credit sdv-py assigns
#   " Team" the box score's own label for that entry -> must normalise to the
#           same key, or the match above cannot happen
#   "Team"  a bare capture with no play-text or box-score provenance -> blanked,
#           because there is nothing to say which team it belongs to
#
# Folding case here would collapse all three and credit the wrong side of the
# ball on the fumble columns, where the team column is the defence.
.norm_player_name <- function(x) {
  x <- as.character(x)
  out <- iconv(x, to = "ASCII//TRANSLIT")
  out <- tolower(trimws(out))
  out[is.na(x) | (!is.na(x) & x == "Team")] <- ""
  out <- sub("\\.$", "", out)
  out <- gsub("\\b(jr|sr|ii|iii|iv|v)\\b\\.?", "", out)
  out <- gsub("[^a-z0-9 ]", "", out)
  out[is.na(out)] <- ""
  stringr::str_squish(out)
}

# Normalize a roster into (norm_name, athlete_id, team_id).
.pbp_roster_records <- function(roster) {
  if (is.null(roster) || !nrow(as.data.frame(roster))) return(NULL)
  r <- as.data.frame(roster)
  name_col <- intersect(c("athlete_display_name", "full_name", "display_name",
                          "athlete_full_name", "name"), names(r))
  id_col   <- intersect(c("athlete_id", "player_id", "id"), names(r))
  team_col <- intersect(c("team_id", "athlete_team_id"), names(r))
  if (!length(name_col) || !length(id_col)) return(NULL)
  data.frame(
    norm_name  = .norm_player_name(r[[name_col[1]]]),
    athlete_id = suppressWarnings(as.character(r[[id_col[1]]])),
    team_id    = if (length(team_col)) as.character(r[[team_col[1]]]) else NA_character_,
    stringsAsFactors = FALSE
  )
}

.pbp_attach_player_ids <- function(raw_df, roster = NULL) {
  present <- Filter(function(m) m[1] %in% names(raw_df), .pbp_player_id_team_map)

  # 1) Cleanup always runs, roster or not.
  for (m in present) {
    nm <- m[1]
    v <- as.character(raw_df[[nm]])
    v <- stringr::str_replace(v, stringr::regex(.player_name_team_suffix), "")
    v <- stringr::str_squish(v)
    v[is.na(v) | v == "" |
      stringr::str_detect(v, stringr::regex(.player_name_garbage, ignore_case = TRUE))] <- NA_character_
    raw_df[[nm]] <- v
  }

  recs <- .pbp_roster_records(roster)

  # Stable shape: the id columns exist even with no roster to resolve against.
  for (m in present) raw_df[[m[2]]] <- NA_character_
  if (is.null(recs) || !nrow(recs)) return(raw_df)

  recs <- recs[nzchar(recs$norm_name), , drop = FALSE]
  parts <- strsplit(recs$norm_name, " ", fixed = TRUE)
  surname <- vapply(parts, function(p) p[length(p)], character(1))
  initial <- vapply(parts, function(p) if (length(p) >= 2) paste0(substr(p[1], 1, 1), " ", p[length(p)]) else NA_character_, character(1))

  # Exact tiers. A globally-unique name resolves without a team; a name that
  # appears twice globally must be disambiguated by team or not at all.
  team_lu <- stats::setNames(recs$athlete_id, paste(recs$norm_name, recs$team_id, sep = "\r"))
  uniq_global <- names(which(table(recs$norm_name) == 1L))
  global_lu <- stats::setNames(recs$athlete_id[recs$norm_name %in% uniq_global],
                               recs$norm_name[recs$norm_name %in% uniq_global])

  # Fuzzy tiers, kept only where the key is unambiguous within the team.
  uniq_key <- function(key, id) {
    ok <- !is.na(key)
    tb <- tapply(id[ok], key[ok], function(z) if (length(unique(z)) == 1L) unique(z) else NA_character_)
    tb[!is.na(tb)]
  }
  initial_lu <- uniq_key(paste(initial, recs$team_id, sep = "\r"), recs$athlete_id)
  last_lu    <- uniq_key(paste(surname, recs$team_id, sep = "\r"), recs$athlete_id)

  # `[[` on a named vector ERRORS on a missing key rather than returning NULL,
  # so every lookup goes through match() -- which returns NA for a miss and is
  # the faster form besides.
  lu <- function(tbl, key) {
    if (!length(tbl) || is.na(key)) return(NA_character_)
    i <- match(key, names(tbl))
    if (is.na(i)) NA_character_ else unname(tbl[i])
  }

  match_one <- function(name, team_id, allow_fallback) {
    nn <- .norm_player_name(name)
    if (!nzchar(nn)) return(NA_character_)
    # The team sentinel is exact-match-only: it has no surname to fall back on,
    # and the fuzzy tiers would hand it an arbitrary player. See .norm_player_name.
    if (identical(nn, "team")) allow_fallback <- FALSE
    tid <- as.character(team_id)
    hit <- lu(team_lu, paste(nn, tid, sep = "\r"))
    if (!is.na(hit)) return(hit)
    hit <- lu(global_lu, nn)
    if (!is.na(hit)) return(hit)
    if (!allow_fallback) return(NA_character_)
    p <- strsplit(nn, " ", fixed = TRUE)[[1]]
    if (length(p) >= 2) {
      hit <- lu(initial_lu, paste(paste0(substr(p[1], 1, 1), " ", p[length(p)]), tid, sep = "\r"))
      if (!is.na(hit)) return(hit)
    }
    lu(last_lu, paste(p[length(p)], tid, sep = "\r"))
  }

  resolve_one <- function(name, team_id) {
    if (is.na(name) || !nzchar(name)) return(NA_character_)
    trimmed <- stringr::str_squish(
      stringr::str_replace(name, stringr::regex(.player_name_tail, ignore_case = TRUE), "")
    )
    has_tail <- !identical(trimmed, name)
    # A name still carrying a tail is trustworthy for an EXACT match only.
    id <- match_one(name, team_id, allow_fallback = !has_tail)
    if (!is.na(id)) return(id)
    if (has_tail && nzchar(trimmed)) return(match_one(trimmed, team_id, allow_fallback = TRUE))
    NA_character_
  }

  # Resolve a role's team column, preferring the id-keyed name and falling back
  # to the bare one. Two frames reach here: the engine's, where `pos_team` is a
  # team NAME and `pos_team_id` is the id, and sdv-py's, where `pos_team` is
  # itself the id. Preferring `*_id` and accepting the bare column covers both
  # without the caller having to rename anything.
  team_vec <- function(teamc) {
    for (cand in unique(c(teamc, sub("_id$", "", teamc)))) {
      if (cand %in% names(raw_df)) {
        v <- as.character(raw_df[[cand]])
        if (any(!is.na(v))) return(v)
      }
    }
    rep(NA_character_, nrow(raw_df))
  }

  for (m in present) {
    nm <- m[1]; idc <- m[2]; teamc <- m[3]
    teams <- team_vec(teamc)
    # mapply() over a zero-row frame returns list(), which assigns a LOGICAL
    # column -- so an empty game would ship id columns of the wrong type and a
    # downstream rbind would fail on schema. Keep the documented character type.
    raw_df[[idc]] <- if (nrow(raw_df)) {
      as.character(mapply(resolve_one, raw_df[[nm]], teams, USE.NAMES = FALSE))
    } else {
      character(0)
    }
  }
  raw_df
}
