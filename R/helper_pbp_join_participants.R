#' @rdname helpers_pbp
#'
#' @description Overwrite regex-extracted `*_player_name` values with ESPN's own
#'   participant display names. Ported from sdv-py's
#'   `CFBPlayProcess.__join_participants`.
#'
#' @details ESPN ships a structured `participants[]` array on every play from
#'   2014 onward. It names the same people the play-text regexes try to capture,
#'   but as clean roster display names rather than whatever the sentence happened
#'   to render -- so a capture that trailed narration (`"Russell Wilson deep
#'   out"`), abbreviated (`"A. Smith"`), or carried a team code
#'   (`"Matt Ryan (BC)"`) becomes the real name. Everything downstream that keys
#'   on the name -- above all `.pbp_attach_player_ids()` -- gets a better key.
#'
#'   Two coalesce modes, because the roles differ in how much ESPN's attribution
#'   can be trusted:
#'
#'   * **Authoritative** (passer, rusher, receiver, punter, kicker, sacked-by,
#'     forced-by): the participant name wins whenever it exists, even where the
#'     regex found nothing. These roles derive their team from `pos_team` /
#'     `def_pos_team`, which is always right.
#'   * **Cleanup-only** (punt return, kickoff return): the participant name is
#'     used *only* to correct a name the regex already found. Both map to the one
#'     shared `returner_player_name`, and their team columns
#'     (`punt_return_team` / `return_team`) can point at the KICKING team on some
#'     play types -- populating a previously-empty name there would invent a
#'     returner on the wrong side of the ball.
#'
#'   The `pass_defender` participant is routed by play type rather than
#'   coalesced: ESPN files the **interceptor** as the pass defender on an
#'   interception, so on `int` plays it feeds `interception_player_name`, and on
#'   every other play it feeds `pass_breakup_player_name`. A regex-extracted
#'   breakup on an interception play is *kept*, not nulled -- a tip drill names
#'   two different defenders and the breakup credit is real.
#'
#'   Any failure (no participants, no `id` column, unusable frame) returns the
#'   input untouched, so an offline or pre-2014 game is unaffected.
#'
#' @param play_df (*data.frame* required): play-by-play frame carrying the ESPN
#'   play `id` and the `*_player_name` columns from [add_player_cols()].
#' @param participants (*data.frame* optional): one row per play with `play_id`
#'   plus the ESPN participant name columns, as returned by
#'   [espn_cfb_game_pbp()] with `participants = "wide"`. `NULL` skips the stage.
#' @return `play_df` with `*_player_name` columns coalesced against the
#'   participant names. Column set and row count are unchanged.
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom dplyr left_join distinct coalesce if_else join_by
#' @importFrom stringr str_squish
#' @noRd
NULL

# (pbp column, participant column, authoritative?) -- see @details for why the
# two return roles are cleanup-only. `pass_defender_player_name` is absent here
# on purpose; it is routed by play type below.
.participant_coalesce_map <- list(
  c("passer_player_name",         "passer_player_name",      "TRUE"),
  c("rusher_player_name",         "rusher_player_name",      "TRUE"),
  c("receiver_player_name",       "receiver_player_name",    "TRUE"),
  c("punter_player_name",         "punter_player_name",      "TRUE"),
  c("fg_kicker_player_name",      "kicker_player_name",      "TRUE"),
  c("sack_player_name",           "sacked_by_player_name",   "TRUE"),
  c("fumble_forced_player_name",  "forced_by_player_name",   "TRUE"),
  c("punt_return_player_name",    "returner_player_name",    "FALSE"),
  c("kickoff_return_player_name", "returner_player_name",    "FALSE")
)

# Every scalar participant name column we are willing to read. Deliberately an
# allow-list rather than a suffix match: the participant frame also carries
# `*_player_names` LIST columns, and pulling one of those into a join would
# turn a scalar name column into a list column.
.participant_name_cols <- c(
  "kicker_player_name", "returner_player_name", "passer_player_name",
  "receiver_player_name", "rusher_player_name", "punter_player_name",
  "pass_defender_player_name", "sacked_by_player_name", "forced_by_player_name"
)

.pbp_join_participants <- function(play_df, participants = NULL) {
  # sdv-py names the play id `id`; the cfbfastR adapters name it `id_play`.
  # Accept either so the stage drops into the engine and into a parity harness
  # reading the Python frame without a rename at each call site.
  key_col <- intersect(c("id", "id_play", "play_id"), names(play_df))
  if (is.null(participants) || !is.data.frame(participants) ||
      nrow(participants) == 0L || !nrow(play_df) ||
      !length(key_col) || !("play_id" %in% names(participants))) {
    return(play_df)
  }

  avail <- intersect(.participant_name_cols, names(participants))
  if (!length(avail)) return(play_df)

  # ESPN play ids run to 18 digits (401135269101849902), which is past the 2^53
  # exact-integer ceiling of an R double -- a numeric join key silently collides
  # neighbouring plays. Both sides are forced to character so the key stays
  # exact whether the caller handed us integer64, numeric or character.
  parts <- data.frame(
    .part_key = .as_play_key(participants[["play_id"]]),
    participants[, avail, drop = FALSE],
    stringsAsFactors = FALSE
  )
  names(parts) <- c(".part_key", paste0(avail, "_part"))
  parts <- parts[!is.na(parts$.part_key), , drop = FALSE]
  # One row per play. sdv-py's participant frame is unique by construction, but
  # a duplicate here would FAN OUT the play-by-play and quietly double-count
  # every downstream drive and EPA total, so it is enforced rather than assumed.
  parts <- dplyr::distinct(parts, .data$.part_key, .keep_all = TRUE)

  keyed <- data.frame(.play_key = .as_play_key(play_df[[key_col[1]]]),
                      stringsAsFactors = FALSE)
  joined <- dplyr::left_join(keyed, parts,
                             by = dplyr::join_by(".play_key" == ".part_key"),
                             relationship = "many-to-one")

  part_val <- function(participant_col) {
    col <- paste0(participant_col, "_part")
    if (!col %in% names(joined)) return(NULL)
    v <- stringr::str_squish(as.character(joined[[col]]))
    v[!nzchar(v)] <- NA_character_
    v
  }

  for (m in .participant_coalesce_map) {
    pbp_col <- m[1]
    if (!pbp_col %in% names(play_df)) next
    pv <- part_val(m[2])
    if (is.null(pv)) next
    cur <- as.character(play_df[[pbp_col]])
    play_df[[pbp_col]] <- if (identical(m[3], "TRUE")) {
      dplyr::coalesce(pv, cur)
    } else {
      dplyr::if_else(!is.na(cur) & !is.na(pv), pv, cur)
    }
  }

  pd <- part_val("pass_defender_player_name")
  if (!is.null(pd)) {
    # `int` is 1/0 in cfbfastR and boolean in sdv-py; both read as TRUE here.
    is_int <- if ("int" %in% names(play_df)) {
      !is.na(play_df[["int"]]) & play_df[["int"]] > 0
    } else {
      rep(FALSE, nrow(play_df))
    }
    if ("interception_player_name" %in% names(play_df)) {
      cur <- as.character(play_df[["interception_player_name"]])
      play_df[["interception_player_name"]] <-
        dplyr::if_else(is_int, dplyr::coalesce(pd, cur), cur)
    }
    if ("pass_breakup_player_name" %in% names(play_df)) {
      cur <- as.character(play_df[["pass_breakup_player_name"]])
      play_df[["pass_breakup_player_name"]] <-
        dplyr::if_else(is_int, cur, dplyr::coalesce(pd, cur))
    }
  }

  play_df
}

#' Coerce an ESPN play id to an exact character join key
#'
#' @description ESPN play ids exceed `2^53`, so any path that lets one become a
#'   double loses digits (`as.character(4.011352691018499e17)` is not the id).
#'   `integer64` and character both round-trip exactly; a double is formatted at
#'   full width rather than in scientific notation so at least the failure is
#'   visible instead of matching the wrong play.
#'
#' @param x Play id vector.
#' @return Character vector, `NA` preserved.
#' @keywords internal
#' @noRd
.as_play_key <- function(x) {
  if (is.character(x)) return(trimws(x))
  if (inherits(x, "integer64")) return(as.character(x))
  if (is.double(x)) return(format(x, scientific = FALSE, trim = TRUE))
  as.character(x)
}
