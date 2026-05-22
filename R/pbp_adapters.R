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
#' @importFrom magrittr %>%
.cfbd_to_epa_input <- function(raw_play_df, year, week) {
  raw_play_df %>%
    dplyr::mutate(
      season = year,
      wk     = week
    )
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
#' @importFrom magrittr %>%
.espn_to_epa_input <- function(df, game_id) {
  df %>%
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
    ) %>%
    dplyr::mutate(
      game_id = game_id,
      clock_minutes = as.numeric(stringr::str_extract(
        .data$plays_clock_display_value, ".*(?=:)"
      )),
      clock_seconds = as.numeric(stringr::str_extract(
        .data$plays_clock_display_value, "(?<=:).*"
      )),
      offense_play = dplyr::case_when(
        .data$plays_start_team_id == .data$home_team_id ~ .data$home,
        TRUE ~ .data$away
      ),
      defense_play = dplyr::case_when(
        .data$plays_start_team_id == .data$home_team_id ~ .data$home,
        TRUE ~ .data$away
      ),
      offense_score = dplyr::case_when(
        .data$offense_play == .data$home ~ .data$plays_home_score,
        TRUE ~ .data$plays_away_score
      ),
      defense_score = dplyr::case_when(
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
    ) %>%
    # Timeout handling -- count timeouts per half.
    dplyr::group_by(.data$half) %>%
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
    ) %>%
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
#' @importFrom httr RETRY add_headers content
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
    away_team_rank            = NA_integer_
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
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)
      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
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
          meta[[paste0(side, "_team_id")]]              <- team_id
          meta[[paste0(side, "_team")]]                 <- loc
          meta[[paste0(side, "_team_name")]]            <- name
          meta[[paste0(side, "_team_abbreviation")]]    <- abbr
          meta[[paste0(side, "_team_color")]]           <- colr
          meta[[paste0(side, "_team_alternate_color")]] <- altc
          meta[[paste0(side, "_team_rank")]]            <- rank
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
