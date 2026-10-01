#' Modular PBP -- adapt the CFBD raw plays frame into the modeling input contract
#'
#' Extracts the season/week assignment from the legacy `cfbd_pbp_data()`. The
#' heavier CFBD-side adapter work (join with `clean_drive_df`, `clean_names()`,
#' rename block, `rm_cols` select) stays inline in `cfbd_pbp_data_v2()`
#' because it depends on the betting + drives fetches done there. This adapter
#' exists for symmetry with `.espn_to_epa_input()` and as the single place
#' future CFBD-to-modeling-input drift should land.
#'
#' @param raw_play_df CFBD raw plays + clean_drive joined frame, with
#'   `janitor::clean_names()` already applied (i.e. the `play_df` value as it
#'   exists in `cfbd_pbp_data()` just before the `if (epa_wpa) { ... }` block).
#' @param year Numeric season year (assigned into the `season` column).
#' @param week Numeric week (assigned into the `wk` column).
#' @return `raw_play_df` with `season` and `wk` assigned.
#' @keywords internal
#' @noRd
#' @importFrom rlang .data
#' @importFrom dplyr mutate
.cfbd_to_epa_input <- function(raw_play_df, year, week) {
  raw_play_df |>
    dplyr::mutate(
      season = year,
      wk     = week
    )
}

#' Modular PBP -- attach team identity to CFBD plays
#'
#' CFBD plays carry team NAMES only, but every team-aware stage the modeled path
#' shares with the ESPN path -- possession ids, turnover / penalty / return
#' attribution, air-yard siding, roster matching -- keys on `home_team_id`,
#' `away_team_id`, `offense_play_id` and the team abbreviations. Only the ESPN
#' adapter supplied them, so on this path they all came back NA and, for one, a
#' lost fumble never counted. CFBD's `/games` carries the ids and `/teams` the
#' abbreviations; both are the ids and abbreviations ESPN uses.
#'
#' @param play_df CFBD plays with `game_id`, `home`, `away`, `offense_play` and
#'   `defense_play` (names).
#' @param games [cfbd_game_info()] rows: `game_id`, `home_id`, `away_id`.
#' @param teams Team catalog: `team_id`, `abbreviation`.
#' @return `play_df` plus character `home_team_id`, `away_team_id`,
#'   `home_team_abbreviation`, `away_team_abbreviation`, `offense_play_id` and
#'   `defense_play_id`. Plays whose game is not in `games` keep NA ids.
#' @keywords internal
#' @noRd
.cfbd_team_identity <- function(play_df, games, teams) {
  # match() rather than a join: play order and the integer `game_id` stay as
  # they are, and a duplicated game row cannot fan the plays out. Numeric, not
  # character: as.character(401000000) is "4.01e+08" unless scipen is raised.
  i <- match(as.numeric(play_df$game_id), as.numeric(games$game_id))
  # /plays and /games are both CFBD, but if they ever disagree on the home team
  # the ids would land on the wrong sides; leave that game unknown instead.
  if ("home_team" %in% names(games)) {
    same <- play_df$home == as.character(games$home_team)[i]
    i[is.na(same) | !same] <- NA
  }
  home_id <- as.character(games$home_id)[i]
  away_id <- as.character(games$away_id)[i]
  abbrev <- stats::setNames(as.character(teams$abbreviation), as.character(teams$team_id))
  # Same rule as the ESPN adapter: a name that is neither team stays unknown,
  # never a confirmed away possession that every downstream stage then trusts.
  side <- function(team) {
    dplyr::case_when(
      is.na(team) ~ NA_character_,
      team == play_df$home ~ home_id,
      team == play_df$away ~ away_id
    )
  }
  play_df$home_team_id <- home_id
  play_df$away_team_id <- away_id
  play_df$home_team_abbreviation <- unname(abbrev[home_id])
  play_df$away_team_abbreviation <- unname(abbrev[away_id])
  play_df$offense_play_id <- side(play_df$offense_play)
  play_df$defense_play_id <- side(play_df$defense_play)
  play_df
}

#' CFBD team catalog (`team_id`, `school`, `abbreviation`) for a season
#'
#' Memoised per `year` (see `.espn_memoised_helpers` in `zzz.R`), so repeated
#' pbp calls in a season reuse one `/teams` request. Aborts on an empty
#' response instead of returning it: memoise does not cache errors, and an
#' empty catalog must not stick for the cache's lifetime.
#' @keywords internal
#' @noRd
.cfbd_team_catalog <- function(year) {
  x <- cfbd_team_info(only_fbs = FALSE, year = year)
  if (!is.data.frame(x) || !nrow(x)) {
    cli::cli_abort("CFBD /teams returned no teams for {year}.")
  }
  data.frame(team_id = as.character(x$team_id), school = as.character(x$school),
             abbreviation = as.character(x$abbreviation), stringsAsFactors = FALSE)
}

#' CFBD season-wide roster (`athlete_id`, `first_name`, `last_name`, `team`)
#'
#' One `/roster` request per season, memoised per `year` (see
#' `.espn_memoised_helpers` in `zzz.R`). Aborts on an empty response so a
#' failed request is retried next time rather than cached.
#' @keywords internal
#' @noRd
.cfbd_roster_year <- function(year) {
  r <- cfbd_team_roster(year = year)
  if (!is.data.frame(r) || !nrow(r)) {
    cli::cli_abort("CFBD /roster returned no players for {year}.")
  }
  as.data.frame(r)[c("athlete_id", "first_name", "last_name", "team")]
}

#' CFBD season roster in the engine's roster contract
#'
#' Built from the season-wide `/roster` (about 30,000 rows, roughly 20 s),
#' which `.cfbd_roster_year()` fetches once per season and memoises. CFBD
#' athlete ids are ESPN athlete ids, so the ids resolved here agree with the
#' ESPN path's.
#' @return `athlete_id`, `display_name`, `team_id` (character), or NULL.
#' @keywords internal
#' @noRd
.cfbd_season_roster <- function(year, teams) {
  r <- tryCatch(.cfbd_roster_year(year), error = function(e) {
    cli::cli_alert_warning("CFBD /roster failed for {year}: {conditionMessage(e)}; player ids will be NA.")
    NULL
  })
  if (is.null(r)) return(NULL)
  out <- data.frame(
    athlete_id   = as.character(r$athlete_id),
    display_name = trimws(paste(dplyr::coalesce(r$first_name, ""), dplyr::coalesce(r$last_name, ""))),
    team_id      = teams$team_id[match(r$team, teams$school)],
    stringsAsFactors = FALSE
  )
  # A player whose school is missing from /teams cannot be scoped to a game,
  # and kept he would join every game that also lacks ids (NA %in% NA is TRUE).
  out[!is.na(out$team_id), , drop = FALSE]
}

#' Goal-to-go distance
#'
#' Some games' feeds send `distance = 0` on goal-to-go downs, where the line
#' to gain is the goal line: ESPN ("1st & Goal at LSU 4") and, more rarely,
#' CFBD. The EP model was trained on sdv-py's ESPN output, which sets those to
#' yards-to-goal (cfb_pbp.py, the `start.distance` goal rewrite), so scoring
#' the raw 0 puts the model outside its training data.
#'
#' ESPN callers pass the down-and-distance `text` and, exactly like sdv-py,
#' only rows reading "Goal" change here; ESPN's "& 0 at" rows are resolved
#' from the previous snap by `.espn_amp0_distance()`. ESPN kickoffs (down 1,
#' distance 0) have no text and never match. CFBD has no text, so without one
#' only rows at the 10 or closer change: there any down at distance 0 is
#' goal-to-go.
#' @return `distance` with those downs set to `yards_to_goal`.
#' @keywords internal
#' @noRd
.goal_to_go_distance <- function(distance, down, yards_to_goal, text = NULL) {
  g2g <- distance %in% 0 & down %in% 1:4 & yards_to_goal %in% 1:99
  g2g <- g2g & if (is.null(text)) yards_to_goal <= 10 else grepl("goal", text, ignore.case = TRUE)
  distance[g2g] <- yards_to_goal[g2g]
  distance
}

#' ESPN "& 0 at" distance, from the previous snap's end state
#'
#' ESPN writes "& 0 at" (no "Goal") for two things: goal-to-go after the ball
#' moved back ("2nd & 0 at LSU 14" follows a sack that ended "2nd & Goal at
#' LSU 14") and a distance it lost ("2nd & 0 at UWA 21" follows "2nd & 18 at
#' UWA 21"). Mirrors sdv-py's `_repair_amp0_distance()` (sportsdataverse-py
#' #636): the previous real snap -- skipping up to two timeout / period-end
#' rows -- must end on the same down at the same "at <spot>" text; an end
#' reading "Goal" gives the yards to the goal, a real end distance gives that
#' distance capped at the yards to the goal, and anything else stays 0. The
#' spot is compared as text because field-goal rows' yards-to-goal run a yard
#' deeper than their text. When the previous snap has no usable end state, a
#' series that started "Goal" for the same `team` (offense id) stays goal-to-go
#' ("1st & 0 at TULN 15" after a penalty on "1st & Goal at TULN 10") while the
#' series is the same one: same `period`, no possession-ending previous snap, no
#' down reset. Without `team` and `period` that branch is skipped. Vectors are one game in ESPN's drive order.
#'
#' sdv-py sorts plays by id, and ESPN sometimes files a drive-ending play with
#' an id past the next drive's plays; since sportsdataverse-py #638 (#637) sdv-py
#' moves such a row back to its drive, so its previous snap agrees with the drive
#' order R reads here (e.g. 400548134 "4th & 0 at KENT 14" -> 14 on both).
#' @return `distance` with those rows resolved.
#' @keywords internal
#' @noRd
.espn_amp0_distance <- function(distance, down, yards_to_goal, text, type,
                                end_down, end_distance, end_text, team = NULL,
                                period = NULL) {
  n <- length(distance)
  if (!n) return(distance)
  admin <- grepl("^(timeout|end period|end of (half|game)|official)", type,
                 ignore.case = TRUE, perl = TRUE)
  i <- seq_len(n)
  lag_admin <- function(k) c(rep(FALSE, k), admin)[i]
  j <- ifelse(lag_admin(1), ifelse(lag_admin(2), i - 3L, i - 2L), i - 1L)
  j[j < 1L] <- NA_integer_
  spot <- function(x) {
    m <- regexpr("at (.+)$", x, perl = TRUE)
    out <- rep(NA_character_, length(x))
    ok <- !is.na(m) & m > 0
    out[ok] <- substring(x[ok], m[ok] + 3L)
    out
  }
  prev_text <- end_text[j]
  base <- distance %in% 0 & grepl("& 0 at", text, fixed = TRUE) &
    down %in% 1:4 & yards_to_goal %in% 1:99 &
    !is.na(type) & !grepl("kickoff|extra point|two[- ]point|2pt", type, ignore.case = TRUE)
  amp0 <- base & (end_down[j] == down) %in% TRUE & (spot(prev_text) == spot(text)) %in% TRUE
  goal <- amp0 & grepl("goal", prev_text, ignore.case = TRUE)
  lost <- amp0 & !goal & (end_distance[j] > 0) %in% TRUE
  # Same series: when the previous snap left no usable end state (a penalty that
  # backs a goal-to-go series up often carries none), a series that started
  # "Goal" for the same offense stays goal-to-go -- sdv-py's third branch.
  # A present, non-goal end text would contradict the series, so it is never
  # overridden; and the series must still be the same one -- same period, no
  # possession-ending previous snap, no down reset -- or a team opening an
  # overtime period would inherit its own goal line (sdv-py #639).
  ends_possession <- grepl(paste0("touchdown|field goal|punt|safety|interception|",
                                  "fumble recovery \\(opponent\\)|turnover|downs|kickoff"),
                           type[j], ignore.case = TRUE)
  series <- if (is.null(team) || is.null(period)) rep(FALSE, n) else
    base & !goal & !lost & grepl("goal", text[j], ignore.case = TRUE) & (team[j] == team) %in% TRUE &
    (is.na(prev_text) | prev_text == "" | grepl("goal", prev_text, ignore.case = TRUE)) &
    (period[j] == period) %in% TRUE & !ends_possession & (down >= down[j]) %in% TRUE
  distance[goal | series] <- yards_to_goal[goal | series]
  distance[lost] <- pmin(end_distance[j][lost], yards_to_goal[lost])
  distance
}

#' Modular PBP -- adapt an ESPN core-v2 plays frame into the modeling input
#'
#' Extracts the rename / mutate / timeout block that's currently duplicated
#' between legacy `espn_cfb_pbp()` (site-v2 path) and `espn_cfb_pbp_v2()`
#' (core-v2 path). Both feeds, once mapped to the canonical `plays_*` /
#' `drive_*` raw-column names, share this exact adapter -- so the same
#' function serves both.
#'
#' The caller supplies `df` already conforming to the `plays_*` / `drive_*`
#' raw column names. For the core-v2 path that comes from a `transmute()`
#' onto `espn_cfb_game_drives(plays = "expand")` output; for the site-v2
#' path it comes from the unnested summary feed.
#'
#' @param df Frame keyed by `plays_*` and `drive_*` raw columns plus
#'   `home_team` / `away_team` / `home_team_id` / `away_team_id` /
#'   `home_team_abbreviation` / `away_team_abbreviation`.
#' @param game_id ESPN game identifier (assigned into the `game_id` column).
#' @return The modeling input frame.
#' @keywords internal
#' @noRd
#' @importFrom rlang .data
#' @importFrom dplyr rename mutate group_by ungroup case_when
#' @importFrom stringr str_extract str_remove regex
.espn_to_epa_input <- function(df, game_id) {
  df |>
    dplyr::rename(
      "play_text"     = "plays_text",
      "play_type"     = "plays_type_text",
      "down"          = "plays_start_down",
      "distance"      = "plays_start_distance",
      "period"        = "plays_period_number",
      "id_play"       = "plays_id",
      "home"          = "home_team",
      "away"          = "away_team",
      "yards_to_goal" = "plays_start_yards_to_endzone",
      "yards_gained"  = "plays_stat_yardage",
      "yard_line"     = "plays_start_yard_line"
    ) |>
    # end-of-play yardline for the air-yards side vote; tolerated absent
    dplyr::rename(dplyr::any_of(c(end_yards_to_endzone = "plays_end_yards_to_endzone"))) |>
    dplyr::mutate(
      game_id = game_id,
      clock_minutes = as.numeric(stringr::str_extract(
        .data$plays_clock_display_value, ".*(?=:)"
      )),
      clock_seconds = as.numeric(stringr::str_extract(
        .data$plays_clock_display_value, "(?<=:).*"
      )),
      # The is.na() arm mirrors the id columns below: without it an unknown
      # start team is reported as a CONFIRMED away possession, and
      # .pbp_add_play_counts() then emits a named pos_team/def_pos_team that
      # contradicts the NA ids -- the worst outcome, because the frame looks
      # authoritative.
      offense_play = dplyr::case_when(
        is.na(.data$plays_start_team_id) ~ NA_character_,
        .data$plays_start_team_id == .data$home_team_id ~ .data$home,
        TRUE ~ .data$away
      ),
      # This was a copy of `offense_play` -- both branches returned `home` --
      # so `defense_play` named the team with the ball on every ESPN play.
      defense_play = dplyr::case_when(
        is.na(.data$plays_start_team_id) ~ NA_character_,
        .data$plays_start_team_id == .data$home_team_id ~ .data$away,
        TRUE ~ .data$home
      ),
      # Id-keyed twins of the two columns above. `home`/`away` are team NAMES
      # resolved through the ESPN teams catalog, and that catalog can come back
      # empty -- `espn_cfb_teams()` currently returns zero rows, which makes
      # `home`/`away` NA and takes `pos_team`, `def_pos_team`, `offense_play`
      # and `defense_play` down with them. The ids come straight off the play
      # and are always present, so anything that needs to know WHICH TEAM
      # (roster matching, team attribution) keys on these instead of the names.
      # The is.na() arm is explicit on purpose: a bare `TRUE ~ away_team_id`
      # turns an unknown start team into a CONFIRMED away possession, and every
      # team-aware stage downstream then trusts it. Unknown must stay unknown.
      offense_play_id = dplyr::case_when(
        is.na(.data$plays_start_team_id) ~ NA_character_,
        .data$plays_start_team_id == .data$home_team_id ~ .data$home_team_id,
        TRUE ~ .data$away_team_id
      ),
      defense_play_id = dplyr::case_when(
        is.na(.data$plays_start_team_id) ~ NA_character_,
        .data$plays_start_team_id == .data$home_team_id ~ .data$away_team_id,
        TRUE ~ .data$home_team_id
      ),
      # Scores follow possession: if we do not know who had the ball we cannot
      # say which score is the offence's.
      offense_score = dplyr::case_when(
        is.na(.data$offense_play) ~ NA_integer_,
        .data$offense_play == .data$home ~ .data$plays_home_score,
        TRUE ~ .data$plays_away_score
      ),
      defense_score = dplyr::case_when(
        is.na(.data$offense_play) ~ NA_integer_,
        .data$offense_play == .data$home ~ .data$plays_away_score,
        TRUE ~ .data$plays_home_score
      ),
      half = dplyr::case_when(
        .data$period <= 2 ~ 1,
        .data$period <= 4 ~ 2,
        TRUE              ~ .data$period - 2
      ),
      drive_start_field_side    = stringr::str_remove(
        .data$drive_start_text, " [0-9]{1,2}"
      ),
      drive_start_yards_to_goal = ifelse(
        .data$drive_start_field_side == .data$home_team_abbreviation,
        100 - .data$drive_start_yard_line,
        .data$drive_start_yard_line
      ),
      drive_end_field_side      = stringr::str_remove(
        .data$drive_end_text, " [0-9]{1,2}"
      ),
      drive_end_yards_to_goal   = ifelse(
        .data$drive_end_field_side == .data$home_team_abbreviation,
        100 - .data$drive_end_yard_line,
        .data$drive_end_yard_line
      ),
      drive_number = cumsum(!duplicated(.data$drive_id)),
      # ppa is a CFBD-only column referenced inside the modeling pipeline;
      # placeholder so the chain's selects do not error.
      ppa = NA_real_
    ) |>
    # Timeout handling -- count timeouts per half.
    dplyr::group_by(.data$half) |>
    dplyr::mutate(
      timeout_team  = stringr::str_extract(
        .data$play_text, "(?<=Timeout ).{1,10}(?=,)"
      ),
      home_timeouts = 3 - cumsum(dplyr::case_when(
        .data$timeout_team == .data$home_team_abbreviation ~ 1,
        TRUE                                               ~ 0
      )),
      away_timeouts = 3 - cumsum(dplyr::case_when(
        .data$timeout_team == .data$away_team_abbreviation ~ 1,
        TRUE                                               ~ 0
      )),
      offense_timeouts = dplyr::case_when(
        .data$offense_play == .data$home ~ .data$home_timeouts,
        TRUE                             ~ .data$away_timeouts
      ),
      defense_timeouts = dplyr::case_when(
        .data$offense_play == .data$home ~ .data$away_timeouts,
        TRUE                             ~ .data$home_timeouts
      )
    ) |>
    dplyr::ungroup()
}

#' Modular PBP -- game-meta bridge for ESPN PBP wrappers
#'
#' Returns the reconciled union of game-meta fields for a single ESPN game.
#' Replaces the existing `.espn_cfb_game_meta()` (which carried only
#' season/week/neutral/date and had an empty silent error handler) and adds
#' the 8 flat columns the legacy `espn_cfb_pbp()` carries but
#' `espn_cfb_pbp_v2()` currently drops: `home_team_name`, `home_team_color`,
#' `home_team_alternate_color`, `home_team_rank` (and `away_*`).
#'
#' Sources season/season_type/week from the core-v2 event's `week.$ref` path;
#' neutral_site / conference_competition / game_date from the first
#' competition; home/away team info from that competition's `competitors[]`
#' (id, location, abbreviation, name, color, alternate_color, rank).
#'
#' @param game_id ESPN game identifier.
#' @return A named list with elements `season`, `season_type`, `week`,
#'   `neutral_site`, `conference_competition`, `game_date`,
#'   `home_team_id` / `home_team` / `home_team_name` /
#'   `home_team_abbreviation` / `home_team_color` /
#'   `home_team_alternate_color` / `home_team_rank` (and `away_*`).
#'   Missing fields degrade to `NA` (typed appropriately); the function
#'   never errors on transient ESPN failures -- it emits a `cli` warning
#'   and returns the partially populated list.
#' @keywords internal
#' @noRd
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string
#' @importFrom jsonlite fromJSON
#' @importFrom rlang "%||%"
#' @importFrom glue glue
#' @importFrom cli cli_alert_warning
.espn_pbp_game_meta <- function(game_id) {
  `%||%` <- rlang::`%||%`

  meta <- list(
    season                 = NA_integer_,
    season_type            = NA_integer_,
    week                   = NA_integer_,
    neutral_site           = NA,
    conference_competition = NA,
    game_date              = NA_character_,
    home_team_id              = NA_character_,
    home_team                 = NA_character_,
    home_team_name            = NA_character_,
    home_team_abbreviation    = NA_character_,
    home_team_color           = NA_character_,
    home_team_alternate_color = NA_character_,
    home_team_rank            = NA_integer_,
    away_team_id              = NA_character_,
    away_team                 = NA_character_,
    away_team_name            = NA_character_,
    away_team_abbreviation    = NA_character_,
    away_team_color           = NA_character_,
    away_team_alternate_color = NA_character_,
    away_team_rank            = NA_integer_,
    # the header's score (the final, once the game is over): sdv-py's score repairs read it
    home_final_score          = NA_real_,
    away_final_score          = NA_real_
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept`   = "application/json, text/plain, */*",
    `Origin`   = "https://www.espn.com",
    `Referer`  = "https://www.espn.com/"
  )

  tryCatch(
    expr = {
      # The event resource carries the week $ref + season $ref + competition[]
      # array with competitors[]; one HTTP call covers all fields.
      url <- glue::glue(
        "https://sports.core.api.espn.com/v2/sports/football/leagues/",
        "college-football/events/{game_id}?lang=en&region=us"
      )
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3) |>
        httr2::req_error(is_error = function(resp) FALSE) |>
        httr2::req_perform()
      check_status(res)
      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      # --- season / season_type / week from week.$ref ---------------------
      week_ref <- if (is.list(raw[["week"]])) {
        raw[["week"]][["$ref"]] %||% NA_character_
      } else NA_character_
      if (!is.na(week_ref)) {
        yr <- suppressWarnings(as.integer(
          sub(".*/seasons/([0-9]+)/.*", "\\1", week_ref)
        ))
        ty <- suppressWarnings(as.integer(
          sub(".*/types/([0-9]+)/.*", "\\1", week_ref)
        ))
        wk <- suppressWarnings(as.integer(
          sub(".*/weeks/([0-9]+).*", "\\1", week_ref)
        ))
        if (!is.na(yr)) meta$season <- yr
        if (!is.na(ty)) meta$season_type <- ty
        if (!is.na(wk)) meta$week <- wk
      }
      if (is.na(meta$season) && is.list(raw[["season"]])) {
        sref <- raw[["season"]][["$ref"]] %||% NA_character_
        if (!is.na(sref)) {
          meta$season <- suppressWarnings(as.integer(
            sub(".*/seasons/([0-9]+).*", "\\1", sref)
          ))
        }
      }

      # --- competition-level meta ---------------------------------------
      comp  <- raw[["competitions"]]
      comp1 <- if (is.list(comp) && length(comp) > 0) comp[[1]] else NULL
      if (is.list(comp1)) {
        meta$neutral_site           <- as.logical(comp1[["neutralSite"]] %||% NA)
        meta$conference_competition <- as.logical(
          comp1[["conferenceCompetition"]] %||% NA
        )
        meta$game_date <- as.character(
          comp1[["date"]] %||% raw[["date"]] %||% NA
        )

        # --- competitors[] -> home/away flat columns ---------------------
        # The core-v2 events endpoint returns each competitor's `team` as a
        # `{"$ref": "..."}` reference rather than the inlined team object,
        # so the inline name/location/abbreviation/color fields are absent.
        # When that happens we fall back to the package's memoised ESPN
        # team lookup (keyed by team_id) so the WP/EPA pipeline downstream
        # has the team identifiers it needs to populate
        # `offense_play`/`defense_play`/`pos_team` and, via those,
        # `pos_team_timeouts_rem_before` which feeds the `wp_model`. The
        # lookup is fetched at most once per call and cached by memoise.
        team_lookup <- NULL
        competitors <- comp1[["competitors"]] %||% list()
        for (c in competitors) {
          side    <- if (isTRUE(c[["homeAway"]] == "home")) "home" else "away"
          team    <- c[["team"]] %||% list()
          team_id <- as.character(c[["id"]] %||% team[["id"]] %||% NA)
          loc     <- as.character(team[["location"]] %||% NA)
          name    <- as.character(team[["name"]] %||% NA)
          abbr    <- as.character(team[["abbreviation"]] %||% NA)
          colr    <- as.character(team[["color"]] %||% NA)
          altc    <- as.character(team[["alternateColor"]] %||% NA)
          rank    <- suppressWarnings(as.integer(c[["curatedRank"]][["current"]]
                       %||% c[["rank"]] %||% NA))

          # Fallback path: hydrate missing inline fields from the team lookup.
          if ((is.na(name) || is.na(loc) || is.na(abbr)) &&
              !is.na(team_id) && nzchar(team_id)) {
            if (is.null(team_lookup)) {
              team_lookup <- tryCatch(
                .espn_cfb_team_lookup(),
                error = function(e) list()
              )
            }
            ent <- team_lookup[[team_id]]
            if (!is.null(ent)) {
              if (is.na(loc))  loc  <- as.character(ent$location        %||% NA)
              if (is.na(name)) name <- as.character(ent$name            %||% NA)
              if (is.na(abbr)) abbr <- as.character(ent$abbreviation    %||% NA)
              if (is.na(colr)) colr <- as.character(ent$color           %||% NA)
              if (is.na(altc)) altc <- as.character(ent$alternate_color %||% NA)
            }
          }

          meta[[paste0(side, "_team_id")]]              <- team_id
          meta[[paste0(side, "_team")]]                 <- loc
          meta[[paste0(side, "_team_name")]]            <- name
          meta[[paste0(side, "_team_abbreviation")]]    <- abbr
          meta[[paste0(side, "_team_color")]]           <- colr
          meta[[paste0(side, "_team_alternate_color")]] <- altc
          meta[[paste0(side, "_team_rank")]]            <- rank
          # core-v2 files the score as a $ref; one small request per side, NA if it fails
          sc <- c[["score"]]
          meta[[paste0(side, "_final_score")]] <- suppressWarnings(as.numeric(
            if (is.list(sc) && !is.null(sc[["value"]])) {
              sc[["value"]]
            } else if (is.list(sc) && !is.null(sc[["$ref"]])) {
              tryCatch({
                r <- httr2::request(sc[["$ref"]]) |>
                  httr2::req_headers(!!!headers) |>
                  httr2::req_retry(max_tries = 3) |>
                  httr2::req_perform()
                httr2::resp_body_json(r)[["value"]] %||% NA
              }, error = function(e) NA)
            } else {
              NA
            }
          ))
        }
      } else {
        meta$game_date <- as.character(raw[["date"]] %||% NA)
      }
    },
    error = function(e) {
      cli::cli_alert_warning(
        "ESPN meta unavailable for game {game_id}: {conditionMessage(e)}"
      )
    },
    warning = function(w) {
      cli::cli_alert_warning(
        "ESPN meta partial for game {game_id}: {conditionMessage(w)}"
      )
    }
  )

  meta
}
