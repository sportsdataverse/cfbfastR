# espn_cfb_player.R -- ESPN college football player wrappers
# Consolidated family file. Each function keeps its own
# roxygen block; edit the block above the function you want.

#' Fetch ESPN CFB athlete-name detail for a single athlete
#'
#' Internal helper. Dereferences one athlete's ESPN core-v2 record and
#' returns a flat list of the human-readable name fields -- `display_name`,
#' `first_name`, `last_name`, `jersey`, `position`, `position_abbreviation`.
#' The season-scoped path
#' `seasons/{year}/athletes/{athlete_id}` is used when `year` is supplied
#' (so the returned jersey / position reflect that season); the league-wide
#' path `athletes/{athlete_id}` is used when `year` is `NULL`. The fetch is
#' wrapped in `tryCatch` so any failure (HTTP error, parse error, missing
#' payload) degrades to a list of `NA`s -- it never errors the caller.
#'
#' @param athlete_id ESPN athlete id.
#' @param year Optional season (4-digit year). When `NULL` the league-wide
#'   athlete resource is used.
#' @return A named list with `display_name`, `first_name`, `last_name`,
#'   `jersey`, `position`, `position_abbreviation` (each character, possibly
#'   `NA`).
#' @keywords internal
#' @noRd
.espn_cfb_athlete_detail <- function(athlete_id, year = NULL) {
  `%||%` <- rlang::`%||%`

  na_detail <- list(
    display_name           = NA_character_,
    first_name             = NA_character_,
    last_name              = NA_character_,
    jersey                 = NA_character_,
    position               = NA_character_,
    position_abbreviation  = NA_character_
  )

  if (is.null(athlete_id) || is.na(athlete_id) ||
      athlete_id == "" || athlete_id == "NA") {
    return(na_detail)
  }

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  url <- if (!is.null(year)) {
    glue::glue(
      "https://sports.core.api.espn.com/v2/sports/football/leagues/",
      "college-football/seasons/{year}/athletes/{athlete_id}",
      "?lang=en&region=us"
    )
  } else {
    glue::glue(
      "https://sports.core.api.espn.com/v2/sports/football/leagues/",
      "college-football/athletes/{athlete_id}?lang=en&region=us"
    )
  }

  detail <- na_detail
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      if (is.list(raw) && !is.null(raw[["id"]])) {
        pos <- raw[["position"]]
        detail <- list(
          display_name          = as.character(raw[["displayName"]] %||% NA_character_),
          first_name            = as.character(raw[["firstName"]] %||% NA_character_),
          last_name             = as.character(raw[["lastName"]] %||% NA_character_),
          jersey                = as.character(raw[["jersey"]] %||% NA_character_),
          position              = if (is.list(pos)) {
            as.character(pos[["name"]] %||% NA_character_)
          } else {
            NA_character_
          },
          position_abbreviation = if (is.list(pos)) {
            as.character(pos[["abbreviation"]] %||% NA_character_)
          } else {
            NA_character_
          }
        )
      }
    },
    error = function(e) {},
    warning = function(w) {}
  )
  detail
}


#' Attach ESPN CFB athlete-name columns to a single-athlete frame
#'
#' Internal helper for the single-athlete season wrappers. Given a frame
#' whose every row describes the same `athlete_id`, fetches that athlete's
#' name detail once with `.espn_cfb_athlete_detail()` and appends the six
#' `athlete_*` name columns (`athlete_display_name`, `athlete_first_name`,
#' `athlete_last_name`, `athlete_jersey`, `athlete_position`,
#' `athlete_position_abbreviation`) to every row. A fetch failure leaves the
#' columns `NA`; the caller's base output is never harmed.
#'
#' @param df Data frame to enrich (all rows share one `athlete_id`).
#' @param athlete_id ESPN athlete id common to every row.
#' @param year Optional season passed through to
#'   `.espn_cfb_athlete_detail()`.
#' @return `df` with the six `athlete_*` name columns appended.
#' @keywords internal
#' @noRd
.espn_cfb_attach_athlete_detail <- function(df, athlete_id, year = NULL) {
  if (!is.data.frame(df) || nrow(df) == 0) {
    return(df)
  }
  d <- .espn_cfb_athlete_detail(athlete_id, year = year)
  df[["athlete_display_name"]]          <- d[["display_name"]]
  df[["athlete_first_name"]]            <- d[["first_name"]]
  df[["athlete_last_name"]]             <- d[["last_name"]]
  df[["athlete_jersey"]]                <- d[["jersey"]]
  df[["athlete_position"]]              <- d[["position"]]
  df[["athlete_position_abbreviation"]] <- d[["position_abbreviation"]]
  df
}


#' Attach ESPN CFB athlete-name columns to a multi-athlete frame
#'
#' Internal helper for the multi-athlete season wrappers
#' ([espn_cfb_qbr()]). Given a frame with an `athlete_id` column spanning
#' many athletes, dereferences each *distinct* athlete once with
#' `.espn_cfb_athlete_detail()` and joins the six `athlete_*` name columns
#' onto every row. This is one HTTP call per distinct athlete -- the cost
#' the caller documents in its `@details`. A per-athlete fetch failure
#' leaves that athlete's name columns `NA`; the caller's base output is
#' never harmed.
#'
#' @param df Data frame carrying an `athlete_id` column.
#' @param year Optional season passed through to
#'   `.espn_cfb_athlete_detail()`.
#' @return `df` with the six `athlete_*` name columns appended.
#' @keywords internal
#' @noRd
.espn_cfb_attach_athlete_detail_multi <- function(df, year = NULL) {
  if (!is.data.frame(df) || nrow(df) == 0 ||
      !("athlete_id" %in% colnames(df))) {
    return(df)
  }
  ids <- as.character(df[["athlete_id"]])
  uniq <- unique(ids[!is.na(ids) & ids != "" & ids != "NA"])

  detail_lk <- list()
  for (aid in uniq) {
    detail_lk[[aid]] <- .espn_cfb_athlete_detail(aid, year = year)
  }

  pull <- function(field) {
    vapply(ids, function(aid) {
      if (is.null(aid) || is.na(aid) || aid == "" || aid == "NA") {
        return(NA_character_)
      }
      e <- detail_lk[[aid]]
      if (is.null(e)) return(NA_character_)
      v <- e[[field]]
      if (is.null(v)) NA_character_ else as.character(v)
    }, character(1), USE.NAMES = FALSE)
  }

  df[["athlete_display_name"]]          <- pull("display_name")
  df[["athlete_first_name"]]            <- pull("first_name")
  df[["athlete_last_name"]]             <- pull("last_name")
  df[["athlete_jersey"]]                <- pull("jersey")
  df[["athlete_position"]]              <- pull("position")
  df[["athlete_position_abbreviation"]] <- pull("position_abbreviation")
  df
}


#' @title
#' **ESPN College Football Player Detail**
#' @description Get the full ESPN record for a single college football
#' player in a given season -- biographical fields, physical measurements,
#' position, team, status, and the `$ref` URLs to the player's nested
#' resources (statistics, event log, college).
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/athletes/{athlete_id}`.
#' The season-scoped path is used so the returned `team_id` reflects the
#' team the player was on *that* season. The wrapper returns a single-row
#' tibble: scalar bio fields are flattened inline, nested objects
#' (`position`, `status`, `birthPlace`, `experience`) are flattened with a
#' prefix, and the nested `$ref` URLs are surfaced as `*_ref` columns
#' rather than auto-dereferenced. Harvest athlete ids from
#' [espn_cfb_players()].
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`, inserted immediately after
#' `team_id`. A catalog failure degrades to `NA` rather than erroring the
#' wrapper. Set `team_detail = FALSE` to skip the catalog fetch and the
#' join.
#'
#' When `position_detail = TRUE` (the default) the ESPN position catalog
#' ([espn_cfb_positions()]) is fetched once and joined onto `position_id`,
#' appending `position_display_name`, `position_leaf`, and
#' `position_parent_id` (the existing `position_name` /
#' `position_abbreviation` columns are left in place). A catalog failure
#' degrades to `NA` rather than erroring the wrapper. Set
#' `position_detail = FALSE` to skip the catalog fetch and the join.
#' @param athlete_id (*Character/Integer* required): ESPN athlete id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @param position_detail (*Logical*): when `TRUE` (default), fetch the
#' ESPN position catalog once and join it onto `position_id`, appending the
#' `position_display_name` / `position_leaf` / `position_parent_id` detail
#' columns. A catalog failure degrades to `NA` rather than erroring the
#' wrapper. Set `FALSE` to skip the extra fetch and the join.
#' @return A one-row data frame describing the player:
#'
#'    |col_name              |types     |description                                      |
#'    |:---------------------|:---------|:------------------------------------------------|
#'    |athlete_id            |character |ESPN athlete id.                                 |
#'    |season                |integer   |Season (4-digit year).                           |
#'    |uid                   |character |ESPN athlete UID.                                |
#'    |guid                  |character |ESPN athlete GUID.                               |
#'    |first_name            |character |Player first name.                               |
#'    |last_name             |character |Player last name.                                |
#'    |full_name             |character |Player full name.                                |
#'    |display_name          |character |Player display name.                             |
#'    |short_name            |character |Player short name.                               |
#'    |weight                |numeric   |Listed weight (lbs).                             |
#'    |display_weight        |character |Display-formatted weight.                        |
#'    |height                |numeric   |Listed height (inches).                          |
#'    |display_height        |character |Display-formatted height.                        |
#'    |jersey                |character |Jersey number.                                   |
#'    |slug                  |character |ESPN athlete URL slug.                           |
#'    |active                |logical   |Whether the player is currently active.          |
#'    |date_of_birth         |character |Player date of birth (if published).             |
#'    |birth_city            |character |Birthplace city.                                 |
#'    |birth_state           |character |Birthplace state.                                |
#'    |birth_country         |character |Birthplace country.                              |
#'    |position_id           |character |ESPN position id.                                |
#'    |position_name         |character |Position name.                                   |
#'    |position_abbreviation |character |Position abbreviation.                           |
#'    |position_display_name |character |Human-readable position name; `position_detail = TRUE` only. |
#'    |position_leaf         |logical   |`TRUE` for a most-specific (leaf) position; `position_detail = TRUE` only. |
#'    |position_parent_id    |character |ESPN id of the parent position; `position_detail = TRUE` only. |
#'    |experience_years      |integer   |Years of experience.                             |
#'    |status_id             |character |ESPN status id.                                  |
#'    |status_name           |character |Status name (e.g. `Active`).                     |
#'    |status_type           |character |Status type.                                     |
#'    |headshot_href         |character |URL of the player headshot image.                |
#'    |team_id               |character |ESPN team id for the season (from `team_ref`).   |
#'    |team_name             |character |Team nickname; `team_detail = TRUE` only.        |
#'    |team_abbreviation     |character |Team abbreviation; `team_detail = TRUE` only.    |
#'    |team_location         |character |Team location / school name; `team_detail = TRUE` only. |
#'    |team_display_name     |character |Full team display name; `team_detail = TRUE` only. |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only. |
#'    |team_nickname         |character |Team nickname label; `team_detail = TRUE` only.  |
#'    |team_color            |character |Primary team color; `team_detail = TRUE` only.   |
#'    |team_alternate_color  |character |Alternate team color; `team_detail = TRUE` only. |
#'    |team_logo_href        |character |Default team logo URL; `team_detail = TRUE` only. |
#'    |team_logo_dark_href   |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |team_ref              |character |`$ref` URL to the team-in-season resource.       |
#'    |statistics_ref        |character |`$ref` URL to the player statistics resource.    |
#'    |eventlog_ref          |character |`$ref` URL to the player event log resource.     |
#'    |college_ref           |character |`$ref` URL to the player college resource.       |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Player
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_player(athlete_id = 102597, year = 2024))
#'   try(espn_cfb_player(athlete_id = 102597, year = 2024,
#'                       team_detail = FALSE, position_detail = FALSE))
#' }
espn_cfb_player <- function(athlete_id = NULL,
                            year = NULL,
                            team_detail = TRUE,
                            position_detail = TRUE) {

  # Validation ----
  if (is.null(athlete_id)) {
    cli::cli_abort("{.arg athlete_id} is required for the ESPN player endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN player endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/athletes/{athlete_id}",
    "?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      if (is.null(raw) || is.null(raw[["id"]])) {
        return(df)
      }

      pos    <- raw[["position"]]
      status <- raw[["status"]]
      bp     <- raw[["birthPlace"]]
      exp    <- raw[["experience"]]
      hs     <- raw[["headshot"]]

      team_ref <- if (is.list(raw[["team"]])) {
        raw[["team"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      team_id <- if (!is.na(team_ref)) {
        sub(".*/teams/([0-9]+).*", "\\1", team_ref)
      } else {
        NA_character_
      }
      stats_ref <- if (is.list(raw[["statistics"]])) {
        raw[["statistics"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      eventlog_ref <- if (is.list(raw[["eventLog"]])) {
        raw[["eventLog"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      college_ref <- if (is.list(raw[["college"]])) {
        raw[["college"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }

      df <- data.frame(
        athlete_id            = as.character(raw[["id"]]),
        season                = suppressWarnings(as.integer(year)),
        uid                   = raw[["uid"]] %||% NA_character_,
        guid                  = raw[["guid"]] %||% NA_character_,
        first_name            = raw[["firstName"]] %||% NA_character_,
        last_name             = raw[["lastName"]] %||% NA_character_,
        full_name             = raw[["fullName"]] %||% NA_character_,
        display_name          = raw[["displayName"]] %||% NA_character_,
        short_name            = raw[["shortName"]] %||% NA_character_,
        weight                = suppressWarnings(as.numeric(raw[["weight"]] %||% NA)),
        display_weight        = raw[["displayWeight"]] %||% NA_character_,
        height                = suppressWarnings(as.numeric(raw[["height"]] %||% NA)),
        display_height        = raw[["displayHeight"]] %||% NA_character_,
        jersey                = as.character(raw[["jersey"]] %||% NA_character_),
        slug                  = raw[["slug"]] %||% NA_character_,
        active                = raw[["active"]] %||% NA,
        date_of_birth         = raw[["dateOfBirth"]] %||% NA_character_,
        birth_city            = if (is.list(bp)) bp[["city"]] %||% NA_character_ else NA_character_,
        birth_state           = if (is.list(bp)) bp[["state"]] %||% NA_character_ else NA_character_,
        birth_country         = if (is.list(bp)) bp[["country"]] %||% NA_character_ else NA_character_,
        position_id           = if (is.list(pos)) as.character(pos[["id"]] %||% NA_character_) else NA_character_,
        position_name         = if (is.list(pos)) pos[["name"]] %||% NA_character_ else NA_character_,
        position_abbreviation = if (is.list(pos)) pos[["abbreviation"]] %||% NA_character_ else NA_character_,
        experience_years      = if (is.list(exp)) suppressWarnings(as.integer(exp[["years"]] %||% NA)) else NA_integer_,
        status_id             = if (is.list(status)) as.character(status[["id"]] %||% NA_character_) else NA_character_,
        status_name           = if (is.list(status)) status[["name"]] %||% NA_character_ else NA_character_,
        status_type           = if (is.list(status)) status[["type"]] %||% NA_character_ else NA_character_,
        headshot_href         = if (is.list(hs)) hs[["href"]] %||% NA_character_ else NA_character_,
        team_id               = team_id,
        team_ref              = team_ref,
        statistics_ref        = stats_ref,
        eventlog_ref          = eventlog_ref,
        college_ref           = college_ref,
        stringsAsFactors      = FALSE
      ) %>%
        dplyr::as_tibble()

      # Join the ESPN position catalog onto position_id when requested --
      # appends position_display_name / _leaf / _parent_id (the existing
      # position_name / _abbreviation columns are kept as-is).
      if (isTRUE(position_detail)) {
        df <- .espn_cfb_attach_position_detail(
          df, .espn_cfb_position_lookup()
        )
      }

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df %>%
        make_cfbfastR_data("Player detail from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN player data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Player Event Log**
#' @description Get the per-game event log for a single college football
#' player in a season -- one row per game, with the `$ref` URLs to each
#' game's event, competition, and the player's per-game statistics.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/athletes/{athlete_id}/eventlog`.
#' The event log lists every game the player appeared on a roster for in
#' the requested season. Per-game statistics are referenced by a
#' `statistics_ref` URL rather than being inlined -- they are not
#' auto-dereferenced, since one fetch per game would be costly; resolve a
#' particular game with a direct request to that URL when needed. If the
#' player did not play in the requested season ESPN returns an empty
#' payload and this wrapper returns an empty data frame.
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`, inserted immediately after
#' `team_id`. A catalog failure degrades to `NA` rather than erroring the
#' wrapper. Set `team_detail = FALSE` to skip the catalog fetch and the
#' join.
#'
#' When `athlete_detail = TRUE` (the default) the requested athlete's ESPN
#' record is fetched once and the human-readable name columns
#' `athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
#' `athlete_jersey`, `athlete_position`, and `athlete_position_abbreviation`
#' are appended to every row. This is a single cheap fetch -- the wrapper
#' already takes one `athlete_id`. A fetch failure degrades the name columns
#' to `NA` rather than erroring the wrapper. Set `athlete_detail = FALSE` to
#' skip the fetch and reproduce the prior output exactly.
#' @param athlete_id (*Character/Integer* required): ESPN athlete id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @param athlete_detail (*Logical*): when `TRUE` (default), fetch the
#' requested athlete's ESPN record once and append the `athlete_*` name
#' columns (see *Details*). Set `FALSE` to skip the fetch, reproducing the
#' prior output exactly.
#' @return A data frame with one row per game:
#'
#'    |col_name        |types     |description                                          |
#'    |:---------------|:---------|:----------------------------------------------------|
#'    |athlete_id      |character |ESPN athlete id.                                     |
#'    |season          |integer   |Season (4-digit year).                               |
#'    |game_id         |character |ESPN event (game) id (parsed from `event_ref`).      |
#'    |team_id         |character |ESPN team id the player played for in the game.      |
#'    |team_name       |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.       |
#'    |team_location   |character |Team location / school name; `team_detail = TRUE` only. |
#'    |team_display_name|character |Full team display name; `team_detail = TRUE` only.  |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only. |
#'    |team_nickname   |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color      |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.  |
#'    |team_logo_href  |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |played          |logical   |Whether the player played in the game.               |
#'    |event_ref       |character |`$ref` URL to the event resource.                    |
#'    |competition_ref |character |`$ref` URL to the competition resource.              |
#'    |statistics_ref  |character |`$ref` URL to the player's per-game statistics.      |
#'    |athlete_display_name|character |Player display name; `athlete_detail = TRUE` only. |
#'    |athlete_first_name|character |Player first name; `athlete_detail = TRUE` only.   |
#'    |athlete_last_name|character |Player last name; `athlete_detail = TRUE` only.     |
#'    |athlete_jersey  |character |Player jersey number; `athlete_detail = TRUE` only.  |
#'    |athlete_position|character |Player position name; `athlete_detail = TRUE` only.  |
#'    |athlete_position_abbreviation|character |Player position abbreviation; `athlete_detail = TRUE` only. |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Player Event Log
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_player_eventlog(athlete_id = 102597, year = 2024))
#'   try(espn_cfb_player_eventlog(athlete_id = 102597, year = 2024,
#'                                team_detail = FALSE,
#'                                athlete_detail = FALSE))
#' }
espn_cfb_player_eventlog <- function(athlete_id = NULL,
                                     year = NULL,
                                     team_detail = TRUE,
                                     athlete_detail = TRUE) {

  # Validation ----
  if (is.null(athlete_id)) {
    cli::cli_abort("{.arg athlete_id} is required for the ESPN player event log endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN player event log endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/athletes/{athlete_id}/eventlog",
    "?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["events"]][["items"]]
      if (is.null(items) || length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        event_ref <- if (is.list(it[["event"]])) {
          it[["event"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        competition_ref <- if (is.list(it[["competition"]])) {
          it[["competition"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        statistics_ref <- if (is.list(it[["statistics"]])) {
          it[["statistics"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        game_id <- if (!is.na(event_ref)) {
          sub(".*/events/([0-9]+).*", "\\1", event_ref)
        } else {
          NA_character_
        }

        rows[[length(rows) + 1L]] <- data.frame(
          athlete_id       = as.character(athlete_id),
          season           = suppressWarnings(as.integer(year)),
          game_id          = game_id,
          team_id          = as.character(it[["teamId"]] %||% NA_character_),
          played           = it[["played"]] %||% NA,
          event_ref        = event_ref,
          competition_ref  = competition_ref,
          statistics_ref   = statistics_ref,
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      # Append the athlete name columns from one cheap athlete fetch.
      if (isTRUE(athlete_detail)) {
        df <- .espn_cfb_attach_athlete_detail(df, athlete_id, year = year)
      }

      df <- df %>%
        make_cfbfastR_data("Player event log from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN player event log data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Player Game Log**
#' @description Get a single college football player's game-by-game
#' statistical log for a season -- one row per game, with the player's
#' stat line joined to opponent, score, and result metadata.
#' @details Wraps the ESPN web-v3 endpoint
#' `site.web.api.espn.com/apis/common/v3/sports/football/college-football/athletes/{athlete_id}/gamelog`.
#' Unlike the core-v2 [espn_cfb_player_eventlog()] (which returns only
#' `$ref` URLs), this endpoint ships fully-resolved per-game stat lines.
#' The wrapper joins three blocks of the payload: the `events` map (game
#' metadata -- opponent, date, score, result), the `seasonTypes` ->
#' `categories` -> `events` block (the per-game stat values), and the
#' top-level `labels` / `names` arrays (the stat column names). Stat
#' columns are named from the `names` array (e.g. `completions`,
#' `passing_yards`); they vary by the player's position. If the player
#' did not play in the requested season ESPN returns only a `filters`
#' object and this wrapper returns an empty data frame.
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`, inserted immediately after
#' `team_id`. A catalog failure degrades to `NA` rather than erroring the
#' wrapper. Set `team_detail = FALSE` to skip the catalog fetch and the
#' join.
#'
#' When `athlete_detail = TRUE` (the default) the requested athlete's ESPN
#' record is fetched once and the human-readable name columns
#' `athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
#' `athlete_jersey`, `athlete_position`, and `athlete_position_abbreviation`
#' are appended to every row. This is a single cheap fetch -- the wrapper
#' already takes one `athlete_id`. A fetch failure degrades the name columns
#' to `NA` rather than erroring the wrapper. Set `athlete_detail = FALSE` to
#' skip the fetch and reproduce the prior output exactly.
#' @param athlete_id (*Character/Integer* required): ESPN athlete id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @param athlete_detail (*Logical*): when `TRUE` (default), fetch the
#' requested athlete's ESPN record once and append the `athlete_*` name
#' columns (see *Details*). Set `FALSE` to skip the fetch, reproducing the
#' prior output exactly.
#' @return A data frame with one row per game. The leading columns are
#' fixed; the trailing stat columns vary by position:
#'
#'    |col_name        |types     |description                                          |
#'    |:---------------|:---------|:----------------------------------------------------|
#'    |athlete_id      |character |ESPN athlete id.                                     |
#'    |season          |integer   |Season (4-digit year).                               |
#'    |season_type     |character |Season-type label (e.g. `2024 Regular Season`).      |
#'    |game_id         |character |ESPN event (game) id.                                |
#'    |game_date       |character |Game date (ISO 8601).                                |
#'    |week            |integer   |Week number.                                         |
#'    |at_vs           |character |`vs` (home) or `@` (away).                           |
#'    |opponent_id     |character |ESPN team id of the opponent.                        |
#'    |opponent_name   |character |Opponent display name.                               |
#'    |opponent_abbr   |character |Opponent abbreviation.                               |
#'    |team_id         |character |ESPN team id the player played for.                  |
#'    |team_name       |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.       |
#'    |team_location   |character |Team location / school name; `team_detail = TRUE` only. |
#'    |team_display_name|character |Full team display name; `team_detail = TRUE` only.  |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only. |
#'    |team_nickname   |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color      |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.  |
#'    |team_logo_href  |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |home_team_score |character |Home team final score.                               |
#'    |away_team_score |character |Away team final score.                               |
#'    |game_result     |character |Game result for the player's team (`W`/`L`).         |
#'    |score           |character |Final score string.                                 |
#'    |athlete_display_name|character |Player display name; `athlete_detail = TRUE` only. |
#'    |athlete_first_name|character |Player first name; `athlete_detail = TRUE` only.   |
#'    |athlete_last_name|character |Player last name; `athlete_detail = TRUE` only.     |
#'    |athlete_jersey  |character |Player jersey number; `athlete_detail = TRUE` only.  |
#'    |athlete_position|character |Player position name; `athlete_detail = TRUE` only.  |
#'    |athlete_position_abbreviation|character |Player position abbreviation; `athlete_detail = TRUE` only. |
#'    |...             |character |One column per stat in the `names` array (varies).   |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Player Game Log
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_player_gamelog(athlete_id = 102597, year = 2024))
#'   try(espn_cfb_player_gamelog(athlete_id = 102597, year = 2024,
#'                               team_detail = FALSE,
#'                               athlete_detail = FALSE))
#' }
espn_cfb_player_gamelog <- function(athlete_id = NULL,
                                    year = NULL,
                                    team_detail = TRUE,
                                    athlete_detail = TRUE) {

  # Validation ----
  if (is.null(athlete_id)) {
    cli::cli_abort("{.arg athlete_id} is required for the ESPN player game log endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN player game log endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://site.web.api.espn.com/apis/common/v3/sports/football/",
    "college-football/athletes/{athlete_id}/gamelog?season={year}"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      events <- raw[["events"]]
      season_types <- raw[["seasonTypes"]]
      stat_names <- unlist(raw[["names"]] %||% list())

      if (is.null(events) || length(events) == 0 ||
          is.null(season_types) || length(season_types) == 0) {
        return(df)
      }

      rows <- list()
      for (st in season_types) {
        season_type <- st[["displayName"]] %||% NA_character_
        for (cat in st[["categories"]] %||% list()) {
          if (!identical(cat[["type"]], "event")) next
          for (ev in cat[["events"]] %||% list()) {
            event_id <- as.character(ev[["eventId"]] %||% NA_character_)
            meta <- events[[event_id]]

            opp <- if (is.list(meta)) meta[["opponent"]] else NULL
            team <- if (is.list(meta)) meta[["team"]] else NULL

            base <- data.frame(
              athlete_id       = as.character(athlete_id),
              season           = suppressWarnings(as.integer(year)),
              season_type      = season_type,
              game_id          = event_id,
              game_date        = if (is.list(meta)) meta[["gameDate"]] %||% NA_character_ else NA_character_,
              week             = if (is.list(meta)) suppressWarnings(as.integer(meta[["week"]] %||% NA)) else NA_integer_,
              at_vs            = if (is.list(meta)) meta[["atVs"]] %||% NA_character_ else NA_character_,
              opponent_id      = if (is.list(opp)) as.character(opp[["id"]] %||% NA_character_) else NA_character_,
              opponent_name    = if (is.list(opp)) opp[["displayName"]] %||% NA_character_ else NA_character_,
              opponent_abbr    = if (is.list(opp)) opp[["abbreviation"]] %||% NA_character_ else NA_character_,
              team_id          = if (is.list(team)) as.character(team[["id"]] %||% NA_character_) else NA_character_,
              home_team_score  = if (is.list(meta)) as.character(meta[["homeTeamScore"]] %||% NA_character_) else NA_character_,
              away_team_score  = if (is.list(meta)) as.character(meta[["awayTeamScore"]] %||% NA_character_) else NA_character_,
              game_result      = if (is.list(meta)) meta[["gameResult"]] %||% NA_character_ else NA_character_,
              score            = if (is.list(meta)) meta[["score"]] %||% NA_character_ else NA_character_,
              stringsAsFactors = FALSE
            )

            stat_vals <- unlist(ev[["stats"]] %||% list())
            if (length(stat_vals) > 0 && length(stat_names) == length(stat_vals)) {
              stat_df <- as.data.frame(
                as.list(as.character(stat_vals)),
                stringsAsFactors = FALSE
              )
              names(stat_df) <- stat_names
              base <- cbind(base, stat_df)
            }

            rows[[length(rows) + 1L]] <- base
          }
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) %>%
        janitor::clean_names() %>%
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      # Append the athlete name columns from one cheap athlete fetch.
      if (isTRUE(athlete_detail)) {
        df <- .espn_cfb_attach_athlete_detail(df, athlete_id, year = year)
      }

      df <- df %>%
        make_cfbfastR_data("Player game log from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN player game log data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Player Statistics Overview**
#' @description Get the season-by-season statistics overview ESPN shows on a
#' college football player's player page -- one row per season the
#' player has played, with the headline stat line for each.
#' @details Wraps the ESPN web-v3 endpoint
#' `site.web.api.espn.com/apis/common/v3/sports/football/college-football/athletes/{athlete_id}/overview`.
#' The overview payload's `statistics` block is the player's career
#' summary table: it carries a `splits` array with one entry per season the
#' player has played (most recent first), plus the `names` array of stat
#' keys. This wrapper returns that career table -- one row per season --
#' joining each season's stat values to the `names` columns. Note that the
#' `season` argument selects the player's player-page context but the
#' `statistics` block is *always* the player's full multi-season career
#' table; the returned `stat_season` column identifies which season each
#' row describes. Stat columns vary by the player's position. For
#' game-by-game data use [espn_cfb_player_gamelog()].
#'
#' When `athlete_detail = TRUE` (the default) the requested athlete's ESPN
#' record is fetched once and the human-readable name columns
#' `athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
#' `athlete_jersey`, `athlete_position`, and `athlete_position_abbreviation`
#' are appended to every row. This is a single cheap fetch -- the wrapper
#' already takes one `athlete_id`. A fetch failure degrades the name columns
#' to `NA` rather than erroring the wrapper. Set `athlete_detail = FALSE` to
#' skip the fetch and reproduce the prior output exactly.
#' @param athlete_id (*Character/Integer* required): ESPN athlete id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param athlete_detail (*Logical*): when `TRUE` (default), fetch the
#' requested athlete's ESPN record once and append the `athlete_*` name
#' columns (see *Details*). Set `FALSE` to skip the fetch, reproducing the
#' prior output exactly.
#' @return A data frame with one row per season in the player's career
#' table. The leading columns are fixed; the trailing stat columns vary by
#' position:
#'
#'    |col_name    |types     |description                                          |
#'    |:-----------|:---------|:----------------------------------------------------|
#'    |athlete_id  |character |ESPN athlete id.                                     |
#'    |season      |integer   |Season passed as the player-page context argument.   |
#'    |stat_season |character |Season this row's stat line describes.               |
#'    |athlete_display_name|character |Player display name; `athlete_detail = TRUE` only. |
#'    |athlete_first_name|character |Player first name; `athlete_detail = TRUE` only.   |
#'    |athlete_last_name|character |Player last name; `athlete_detail = TRUE` only.     |
#'    |athlete_jersey  |character |Player jersey number; `athlete_detail = TRUE` only.  |
#'    |athlete_position|character |Player position name; `athlete_detail = TRUE` only.  |
#'    |athlete_position_abbreviation|character |Player position abbreviation; `athlete_detail = TRUE` only. |
#'    |...         |character |One column per stat in the `names` array (varies).   |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Player Overview
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_player_overview(athlete_id = 102597, year = 2024))
#'   try(espn_cfb_player_overview(athlete_id = 102597, year = 2024,
#'                                athlete_detail = FALSE))
#' }
espn_cfb_player_overview <- function(athlete_id = NULL,
                                     year = NULL,
                                     athlete_detail = TRUE) {

  # Validation ----
  if (is.null(athlete_id)) {
    cli::cli_abort("{.arg athlete_id} is required for the ESPN player overview endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN player overview endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://site.web.api.espn.com/apis/common/v3/sports/football/",
    "college-football/athletes/{athlete_id}/overview?season={year}"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      stats_block <- raw[["statistics"]]
      splits <- stats_block[["splits"]]
      stat_names <- unlist(stats_block[["names"]] %||% list())

      if (is.null(splits) || length(splits) == 0) {
        return(df)
      }

      rows <- list()
      for (sp in splits) {
        base <- data.frame(
          athlete_id       = as.character(athlete_id),
          season           = suppressWarnings(as.integer(year)),
          stat_season      = as.character(sp[["displayName"]] %||% NA_character_),
          stringsAsFactors = FALSE
        )

        stat_vals <- unlist(sp[["stats"]] %||% list())
        if (length(stat_vals) > 0 && length(stat_names) == length(stat_vals)) {
          stat_df <- as.data.frame(
            as.list(as.character(stat_vals)),
            stringsAsFactors = FALSE
          )
          names(stat_df) <- stat_names
          base <- cbind(base, stat_df)
        }

        rows[[length(rows) + 1L]] <- base
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) %>%
        janitor::clean_names() %>%
        dplyr::as_tibble()

      # Append the athlete name columns from one cheap athlete fetch.
      if (isTRUE(athlete_detail)) {
        df <- .espn_cfb_attach_athlete_detail(df, athlete_id, year = year)
      }

      df <- df %>%
        make_cfbfastR_data("Player statistics overview from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN player overview data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Player Seasons**
#' @description Get the list of seasons a single college football player
#' has a statistical record for on ESPN -- one row per season, with the
#' `$ref` URLs to that season's statistics.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/athletes/{athlete_id}/statisticslog`.
#' ESPN exposes no dedicated `/athletes/{id}/seasons` resource for college
#' football (that path 404s); the statistics log is the closest thing -- it
#' returns one `entry` per season the player accumulated statistics in,
#' which is exactly the player's season list. Each entry carries the
#' season `$ref` and one or more statistics references (split by stat
#' `type`, e.g. `total`). The statistics themselves are not
#' auto-dereferenced; use [espn_cfb_player_statistics()] for a resolved,
#' long-format stat table for a given season.
#'
#' When `athlete_detail = TRUE` (the default) the requested athlete's ESPN
#' record is fetched once (from the league-wide athlete resource, since this
#' wrapper takes no `year`) and the human-readable name columns
#' `athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
#' `athlete_jersey`, `athlete_position`, and `athlete_position_abbreviation`
#' are appended to every row. This is a single cheap fetch -- the wrapper
#' already takes one `athlete_id`. A fetch failure degrades the name columns
#' to `NA` rather than erroring the wrapper. Set `athlete_detail = FALSE` to
#' skip the fetch and reproduce the prior output exactly.
#' @param athlete_id (*Character/Integer* required): ESPN athlete id.
#' @param athlete_detail (*Logical*): when `TRUE` (default), fetch the
#' requested athlete's ESPN record once and append the `athlete_*` name
#' columns (see *Details*). Set `FALSE` to skip the fetch, reproducing the
#' prior output exactly.
#' @return A data frame with one row per season-stat-type entry:
#'
#'    |col_name        |types     |description                                        |
#'    |:---------------|:---------|:--------------------------------------------------|
#'    |athlete_id      |character |ESPN athlete id.                                   |
#'    |season          |integer   |Season (4-digit year) the player has a record in.  |
#'    |stat_type       |character |Statistics type for the entry (e.g. `total`).      |
#'    |season_ref      |character |`$ref` URL to the season resource.                 |
#'    |statistics_ref  |character |`$ref` URL to the season statistics resource.      |
#'    |athlete_display_name|character |Player display name; `athlete_detail = TRUE` only. |
#'    |athlete_first_name|character |Player first name; `athlete_detail = TRUE` only.   |
#'    |athlete_last_name|character |Player last name; `athlete_detail = TRUE` only.     |
#'    |athlete_jersey  |character |Player jersey number; `athlete_detail = TRUE` only.  |
#'    |athlete_position|character |Player position name; `athlete_detail = TRUE` only.  |
#'    |athlete_position_abbreviation|character |Player position abbreviation; `athlete_detail = TRUE` only. |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Player Seasons
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_player_seasons(athlete_id = 102597))
#'   try(espn_cfb_player_seasons(athlete_id = 102597, athlete_detail = FALSE))
#' }
espn_cfb_player_seasons <- function(athlete_id = NULL,
                                    athlete_detail = TRUE) {

  # Validation ----
  if (is.null(athlete_id)) {
    cli::cli_abort("{.arg athlete_id} is required for the ESPN player seasons endpoint.")
  }

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/athletes/{athlete_id}/statisticslog?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      entries <- raw[["entries"]]
      if (is.null(entries) || length(entries) == 0) {
        return(df)
      }

      rows <- list()
      for (entry in entries) {
        season_ref <- if (is.list(entry[["season"]])) {
          entry[["season"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        season <- if (!is.na(season_ref)) {
          suppressWarnings(as.integer(
            sub(".*/seasons/([0-9]+).*", "\\1", season_ref)
          ))
        } else {
          NA_integer_
        }

        stats_list <- entry[["statistics"]] %||% list()
        if (length(stats_list) == 0) {
          rows[[length(rows) + 1L]] <- data.frame(
            athlete_id       = as.character(athlete_id),
            season           = season,
            stat_type        = NA_character_,
            season_ref       = season_ref,
            statistics_ref   = NA_character_,
            stringsAsFactors = FALSE
          )
          next
        }

        for (s in stats_list) {
          statistics_ref <- if (is.list(s[["statistics"]])) {
            s[["statistics"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          rows[[length(rows) + 1L]] <- data.frame(
            athlete_id       = as.character(athlete_id),
            season           = season,
            stat_type        = s[["type"]] %||% NA_character_,
            season_ref       = season_ref,
            statistics_ref   = statistics_ref,
            stringsAsFactors = FALSE
          )
        }
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble()

      # Append the athlete name columns from one cheap athlete fetch. No
      # `year` is taken by this wrapper, so the league-wide athlete record
      # is used.
      if (isTRUE(athlete_detail)) {
        df <- .espn_cfb_attach_athlete_detail(df, athlete_id, year = NULL)
      }

      df <- df %>%
        make_cfbfastR_data("Player seasons from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN player seasons data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Player Statistical Splits**
#' @description Get a single college football player's statistical splits
#' for a season -- stat lines broken out by situation (by month, by
#' quarter, by half, by down, by field position, and more).
#' @details Wraps the ESPN web-v3 endpoint
#' `site.web.api.espn.com/apis/common/v3/sports/football/college-football/athletes/{athlete_id}/splits`.
#' ESPN groups splits under `splitCategories[]` (e.g. `byMonth`,
#' `byQuarter`, `byDown`, `byFieldPosition`); each category holds one or
#' more individual `splits` (e.g. the rows under `byQuarter` are `1st
#' Quarter`, `2nd Quarter`, ...). This wrapper returns one row per
#' individual split, tagged with its parent category, and joins the split's
#' stat values to the top-level `names` array for column names. Stat
#' columns vary by the player's position.
#'
#' When `athlete_detail = TRUE` (the default) the requested athlete's ESPN
#' record is fetched once and the human-readable name columns
#' `athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
#' `athlete_jersey`, `athlete_position`, and `athlete_position_abbreviation`
#' are appended to every row. This is a single cheap fetch -- the wrapper
#' already takes one `athlete_id`. A fetch failure degrades the name columns
#' to `NA` rather than erroring the wrapper. Set `athlete_detail = FALSE` to
#' skip the fetch and reproduce the prior output exactly.
#' @param athlete_id (*Character/Integer* required): ESPN athlete id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param athlete_detail (*Logical*): when `TRUE` (default), fetch the
#' requested athlete's ESPN record once and append the `athlete_*` name
#' columns (see *Details*). Set `FALSE` to skip the fetch, reproducing the
#' prior output exactly.
#' @return A data frame with one row per split. The leading columns are
#' fixed; the trailing stat columns vary by position:
#'
#'    |col_name         |types     |description                                          |
#'    |:----------------|:---------|:----------------------------------------------------|
#'    |athlete_id       |character |ESPN athlete id.                                     |
#'    |season           |integer   |Season (4-digit year).                               |
#'    |category         |character |Split category key (e.g. `byQuarter`, `byDown`).     |
#'    |category_display |character |Human-readable split category name.                  |
#'    |split_name       |character |Individual split name (e.g. `1st Quarter`).          |
#'    |split_abbr       |character |Individual split abbreviation.                       |
#'    |athlete_display_name|character |Player display name; `athlete_detail = TRUE` only. |
#'    |athlete_first_name|character |Player first name; `athlete_detail = TRUE` only.   |
#'    |athlete_last_name|character |Player last name; `athlete_detail = TRUE` only.     |
#'    |athlete_jersey   |character |Player jersey number; `athlete_detail = TRUE` only.  |
#'    |athlete_position |character |Player position name; `athlete_detail = TRUE` only.  |
#'    |athlete_position_abbreviation|character |Player position abbreviation; `athlete_detail = TRUE` only. |
#'    |...              |character |One column per stat in the `names` array (varies).   |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Player Splits
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_player_splits(athlete_id = 102597, year = 2024))
#'   try(espn_cfb_player_splits(athlete_id = 102597, year = 2024,
#'                              athlete_detail = FALSE))
#' }
espn_cfb_player_splits <- function(athlete_id = NULL,
                                   year = NULL,
                                   athlete_detail = TRUE) {

  # Validation ----
  if (is.null(athlete_id)) {
    cli::cli_abort("{.arg athlete_id} is required for the ESPN player splits endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN player splits endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://site.web.api.espn.com/apis/common/v3/sports/football/",
    "college-football/athletes/{athlete_id}/splits?season={year}"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      split_categories <- raw[["splitCategories"]]
      stat_names <- unlist(raw[["names"]] %||% list())

      if (is.null(split_categories) || length(split_categories) == 0) {
        return(df)
      }

      rows <- list()
      for (cat in split_categories) {
        cat_name    <- cat[["name"]] %||% NA_character_
        cat_display <- cat[["displayName"]] %||% NA_character_
        for (sp in cat[["splits"]] %||% list()) {
          base <- data.frame(
            athlete_id       = as.character(athlete_id),
            season           = suppressWarnings(as.integer(year)),
            category         = cat_name,
            category_display = cat_display,
            split_name       = sp[["displayName"]] %||% NA_character_,
            split_abbr       = sp[["abbreviation"]] %||% NA_character_,
            stringsAsFactors = FALSE
          )

          stat_vals <- unlist(sp[["stats"]] %||% list())
          if (length(stat_vals) > 0 && length(stat_names) == length(stat_vals)) {
            stat_df <- as.data.frame(
              as.list(as.character(stat_vals)),
              stringsAsFactors = FALSE
            )
            names(stat_df) <- stat_names
            base <- cbind(base, stat_df)
          }

          rows[[length(rows) + 1L]] <- base
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) %>%
        janitor::clean_names() %>%
        dplyr::as_tibble()

      # Append the athlete name columns from one cheap athlete fetch.
      if (isTRUE(athlete_detail)) {
        df <- .espn_cfb_attach_athlete_detail(df, athlete_id, year = year)
      }

      df <- df %>%
        make_cfbfastR_data("Player statistical splits from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN player splits data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Player Season Statistics (Long Format)**
#' @description Get a single college football player's full season
#' statistics from ESPN -- every published stat across every category, in
#' long format (one row per stat).
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/athletes/{athlete_id}/statistics`.
#' ESPN nests a player's season stats under
#' `splits -> categories[] -> stats[]`; this wrapper flattens that tree to
#' long format -- each row is one stat, tagged with its `category` (e.g.
#' `passing`, `rushing`, `defensive`). The long shape is deliberate: ESPN
#' adds and retires stats and whole categories across positions and
#' seasons, and a long frame absorbs that drift without breaking column
#' expectations. Pivot wider with [tidyr::pivot_wider()] keyed on
#' `stat_name` for a wide table. Each stat carries both a season-total
#' value (`value`) and a per-game value (`per_game_value`).
#'
#' When `athlete_detail = TRUE` (the default) the requested athlete's ESPN
#' record is fetched once and the human-readable name columns
#' `athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
#' `athlete_jersey`, `athlete_position`, and `athlete_position_abbreviation`
#' are appended to every row. This is a single cheap fetch -- the wrapper
#' already takes one `athlete_id`. A fetch failure degrades the name columns
#' to `NA` rather than erroring the wrapper. Set `athlete_detail = FALSE` to
#' skip the fetch and reproduce the prior output exactly.
#' @param athlete_id (*Character/Integer* required): ESPN athlete id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param season_type (*Integer* optional, default 2): ESPN season type.
#' `2` = regular season, `3` = postseason.
#' @param athlete_detail (*Logical*): when `TRUE` (default), fetch the
#' requested athlete's ESPN record once and append the `athlete_*` name
#' columns (see *Details*). Set `FALSE` to skip the fetch, reproducing the
#' prior output exactly.
#' @return A data frame with one row per stat:
#'
#'    |col_name                |types     |description                                       |
#'    |:-----------------------|:---------|:-------------------------------------------------|
#'    |athlete_id              |character |ESPN athlete id.                                  |
#'    |season                  |integer   |Season (4-digit year).                            |
#'    |season_type             |integer   |ESPN season type (2 = regular, 3 = postseason).   |
#'    |category                |character |Stat category (e.g. `passing`, `rushing`).        |
#'    |category_display        |character |Human-readable category name.                     |
#'    |stat_name               |character |Internal stat key (e.g. `passingYards`).          |
#'    |display_name            |character |Human-readable stat name.                         |
#'    |abbreviation            |character |Stat abbreviation.                                |
#'    |description             |character |ESPN's description of the stat.                   |
#'    |value                   |numeric   |Season-total value of the stat.                   |
#'    |display_value           |character |Display-formatted season-total value.             |
#'    |per_game_value          |numeric   |Per-game value of the stat.                       |
#'    |per_game_display_value  |character |Display-formatted per-game value.                 |
#'    |athlete_display_name    |character |Player display name; `athlete_detail = TRUE` only. |
#'    |athlete_first_name      |character |Player first name; `athlete_detail = TRUE` only.  |
#'    |athlete_last_name       |character |Player last name; `athlete_detail = TRUE` only.   |
#'    |athlete_jersey          |character |Player jersey number; `athlete_detail = TRUE` only. |
#'    |athlete_position        |character |Player position name; `athlete_detail = TRUE` only. |
#'    |athlete_position_abbreviation|character |Player position abbreviation; `athlete_detail = TRUE` only. |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Player Statistics
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_player_statistics(athlete_id = 102597, year = 2024))
#'   try(espn_cfb_player_statistics(athlete_id = 102597, year = 2024,
#'                                  athlete_detail = FALSE))
#' }
espn_cfb_player_statistics <- function(athlete_id = NULL,
                                       year = NULL,
                                       season_type = 2,
                                       athlete_detail = TRUE) {

  # Validation ----
  if (is.null(athlete_id)) {
    cli::cli_abort("{.arg athlete_id} is required for the ESPN player statistics endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN player statistics endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/types/{season_type}/athletes/",
    "{athlete_id}/statistics?lang=en&region=us"
  )

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      categories <- raw[["splits"]][["categories"]]
      if (is.null(categories) || length(categories) == 0) {
        return(df)
      }

      rows <- list()
      for (cat in categories) {
        cat_name    <- cat[["name"]] %||% NA_character_
        cat_display <- cat[["displayName"]] %||% NA_character_
        for (s in cat[["stats"]] %||% list()) {
          rows[[length(rows) + 1L]] <- data.frame(
            athlete_id             = as.character(athlete_id),
            season                 = suppressWarnings(as.integer(year)),
            season_type            = suppressWarnings(as.integer(season_type)),
            category               = cat_name,
            category_display       = cat_display,
            stat_name              = s[["name"]] %||% NA_character_,
            display_name           = s[["displayName"]] %||% NA_character_,
            abbreviation           = s[["abbreviation"]] %||% NA_character_,
            description            = s[["description"]] %||% NA_character_,
            value                  = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
            display_value          = as.character(s[["displayValue"]] %||% NA),
            per_game_value         = suppressWarnings(as.numeric(s[["perGameValue"]] %||% NA)),
            per_game_display_value = as.character(s[["perGameDisplayValue"]] %||% NA),
            stringsAsFactors       = FALSE
          )
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble()

      # Append the athlete name columns from one cheap athlete fetch.
      if (isTRUE(athlete_detail)) {
        df <- .espn_cfb_attach_athlete_detail(df, athlete_id, year = year)
      }

      df <- df %>%
        make_cfbfastR_data("Player season statistics from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN player statistics data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **Get ESPN college football player stats data**
#' @author Saiem Gilani
#' @param athlete_id Athlete ID
#' @param year Year
#' @param season_type (character, default: regular): Season type - regular or postseason
#' @param total (boolean, default: FALSE): Totals
#' @keywords CFB Player Stats
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows
#' @importFrom tidyr unnest unnest_wider everything
#' @export
#' @return Returns a tibble with the following columns:
#'
#'   |col_name                                        |types     |
#'   |:-----------------------------------------------|:---------|
#'   |athlete_id                                      |character |
#'   |athlete_uid                                     |character |
#'   |athlete_guid                                    |character |
#'   |athlete_type                                    |character |
#'   |sdr                                             |character |
#'   |first_name                                      |character |
#'   |last_name                                       |character |
#'   |full_name                                       |character |
#'   |display_name                                    |character |
#'   |short_name                                      |character |
#'   |weight                                          |numeric   |
#'   |display_weight                                  |character |
#'   |height                                          |numeric   |
#'   |display_height                                  |character |
#'   |age                                             |integer   |
#'   |date_of_birth                                   |character |
#'   |birth_place_city                                |character |
#'   |birth_place_state                               |character |
#'   |birth_place_country                             |character |
#'   |birth_country_alternate_id                      |character |
#'   |birth_country_abbreviation                      |character |
#'   |slug                                            |character |
#'   |jersey                                          |character |
#'   |flag_href                                       |character |
#'   |flag_alt                                        |character |
#'   |flag_x_country_flag                             |character |
#'   |position_id                                     |character |
#'   |position_name                                   |character |
#'   |position_display_name                           |character |
#'   |position_abbreviation                           |character |
#'   |position_leaf                                   |logical   |
#'   |linked                                          |logical   |
#'   |experience_years                                |integer   |
#'   |experience_display_value                        |character |
#'   |experience_abbreviation                         |character |
#'   |active                                          |logical   |
#'   |status_id                                       |character |
#'   |status_name                                     |character |
#'   |status_type                                     |character |
#'   |status_abbreviation                             |character |
#'   |headshot_href                                   |character |
#'   |headshot_alt                                    |character |
#'   |general_fumbles                                 |numeric   |
#'   |general_fumbles_lost                            |numeric   |
#'   |general_fumbles_touchdowns                      |numeric   |
#'   |general_games_played                            |numeric   |
#'   |general_offensive_two_pt_returns                |numeric   |
#'   |general_offensive_fumbles_touchdowns            |numeric   |
#'   |general_defensive_fumbles_touchdowns            |numeric   |
#'   |passing_avg_gain                                |numeric   |
#'   |passing_completion_pct                          |numeric   |
#'   |passing_completions                             |numeric   |
#'   |passing_espnqb_rating                           |numeric   |
#'   |passing_interception_pct                        |numeric   |
#'   |passing_interceptions                           |numeric   |
#'   |passing_long_passing                            |numeric   |
#'   |passing_net_passing_yards                       |numeric   |
#'   |passing_net_passing_yards_per_game              |numeric   |
#'   |passing_net_total_yards                         |numeric   |
#'   |passing_net_yards_per_game                      |numeric   |
#'   |passing_passing_attempts                        |numeric   |
#'   |passing_passing_big_plays                       |numeric   |
#'   |passing_passing_first_downs                     |numeric   |
#'   |passing_passing_fumbles                         |numeric   |
#'   |passing_passing_fumbles_lost                    |numeric   |
#'   |passing_passing_touchdown_pct                   |numeric   |
#'   |passing_passing_touchdowns                      |numeric   |
#'   |passing_passing_yards                           |numeric   |
#'   |passing_passing_yards_after_catch               |numeric   |
#'   |passing_passing_yards_at_catch                  |numeric   |
#'   |passing_passing_yards_per_game                  |numeric   |
#'   |passing_qb_rating                               |numeric   |
#'   |passing_sacks                                   |numeric   |
#'   |passing_sack_yards_lost                         |numeric   |
#'   |passing_team_games_played                       |numeric   |
#'   |passing_total_offensive_plays                   |numeric   |
#'   |passing_total_points_per_game                   |numeric   |
#'   |passing_total_touchdowns                        |numeric   |
#'   |passing_total_yards                             |numeric   |
#'   |passing_total_yards_from_scrimmage              |numeric   |
#'   |passing_two_point_pass_convs                    |numeric   |
#'   |passing_two_pt_pass                             |numeric   |
#'   |passing_two_pt_pass_attempts                    |numeric   |
#'   |passing_yards_from_scrimmage_per_game           |numeric   |
#'   |passing_yards_per_completion                    |numeric   |
#'   |passing_yards_per_game                          |numeric   |
#'   |passing_yards_per_pass_attempt                  |numeric   |
#'   |passing_net_yards_per_pass_attempt              |numeric   |
#'   |passing_qbr                                     |numeric   |
#'   |passing_adj_qbr                                 |numeric   |
#'   |passing_quarterback_rating                      |numeric   |
#'   |rushing_avg_gain                                |numeric   |
#'   |rushing_espnrb_rating                           |numeric   |
#'   |rushing_long_rushing                            |numeric   |
#'   |rushing_net_total_yards                         |numeric   |
#'   |rushing_net_yards_per_game                      |numeric   |
#'   |rushing_rushing_attempts                        |numeric   |
#'   |rushing_rushing_big_plays                       |numeric   |
#'   |rushing_rushing_first_downs                     |numeric   |
#'   |rushing_rushing_fumbles                         |numeric   |
#'   |rushing_rushing_fumbles_lost                    |numeric   |
#'   |rushing_rushing_touchdowns                      |numeric   |
#'   |rushing_rushing_yards                           |numeric   |
#'   |rushing_rushing_yards_per_game                  |numeric   |
#'   |rushing_stuffs                                  |numeric   |
#'   |rushing_stuff_yards_lost                        |numeric   |
#'   |rushing_team_games_played                       |numeric   |
#'   |rushing_total_offensive_plays                   |numeric   |
#'   |rushing_total_points_per_game                   |numeric   |
#'   |rushing_total_touchdowns                        |numeric   |
#'   |rushing_total_yards                             |numeric   |
#'   |rushing_total_yards_from_scrimmage              |numeric   |
#'   |rushing_two_point_rush_convs                    |numeric   |
#'   |rushing_two_pt_rush                             |numeric   |
#'   |rushing_two_pt_rush_attempts                    |numeric   |
#'   |rushing_yards_from_scrimmage_per_game           |numeric   |
#'   |rushing_yards_per_game                          |numeric   |
#'   |rushing_yards_per_rush_attempt                  |numeric   |
#'   |receiving_avg_gain                              |numeric   |
#'   |receiving_espnwr_rating                         |numeric   |
#'   |receiving_long_reception                        |numeric   |
#'   |receiving_net_total_yards                       |numeric   |
#'   |receiving_net_yards_per_game                    |numeric   |
#'   |receiving_receiving_big_plays                   |numeric   |
#'   |receiving_receiving_first_downs                 |numeric   |
#'   |receiving_receiving_fumbles                     |numeric   |
#'   |receiving_receiving_fumbles_lost                |numeric   |
#'   |receiving_receiving_targets                     |numeric   |
#'   |receiving_receiving_touchdowns                  |numeric   |
#'   |receiving_receiving_yards                       |numeric   |
#'   |receiving_receiving_yards_after_catch           |numeric   |
#'   |receiving_receiving_yards_at_catch              |numeric   |
#'   |receiving_receiving_yards_per_game              |numeric   |
#'   |receiving_receptions                            |numeric   |
#'   |receiving_team_games_played                     |numeric   |
#'   |receiving_total_offensive_plays                 |numeric   |
#'   |receiving_total_points_per_game                 |numeric   |
#'   |receiving_total_touchdowns                      |numeric   |
#'   |receiving_total_yards                           |numeric   |
#'   |receiving_total_yards_from_scrimmage            |numeric   |
#'   |receiving_two_point_rec_convs                   |numeric   |
#'   |receiving_two_pt_reception                      |numeric   |
#'   |receiving_two_pt_reception_attempts             |numeric   |
#'   |receiving_yards_from_scrimmage_per_game         |numeric   |
#'   |receiving_yards_per_game                        |numeric   |
#'   |receiving_yards_per_reception                   |numeric   |
#'   |scoring_defensive_points                        |numeric   |
#'   |scoring_field_goals                             |numeric   |
#'   |scoring_kick_extra_points                       |numeric   |
#'   |scoring_kick_extra_points_made                  |numeric   |
#'   |scoring_misc_points                             |numeric   |
#'   |scoring_passing_touchdowns                      |numeric   |
#'   |scoring_receiving_touchdowns                    |numeric   |
#'   |scoring_return_touchdowns                       |numeric   |
#'   |scoring_rushing_touchdowns                      |numeric   |
#'   |scoring_total_points                            |numeric   |
#'   |scoring_total_points_per_game                   |numeric   |
#'   |scoring_total_touchdowns                        |numeric   |
#'   |scoring_total_two_point_convs                   |numeric   |
#'   |scoring_two_point_pass_convs                    |numeric   |
#'   |scoring_two_point_rec_convs                     |numeric   |
#'   |scoring_two_point_rush_convs                    |numeric   |
#'   |scoring_one_pt_safeties_made                    |numeric   |
#'   |general_fumbles_forced                          |logical   |
#'   |general_fumbles_recovered                       |logical   |
#'   |passing_misc_yards                              |logical   |
#'   |passing_total_points                            |logical   |
#'   |rushing_misc_yards                              |logical   |
#'   |rushing_total_points                            |logical   |
#'   |receiving_misc_yards                            |logical   |
#'   |receiving_total_points                          |logical   |
#'   |defensive_assist_tackles                        |logical   |
#'   |defensive_avg_interception_yards                |logical   |
#'   |defensive_avg_sack_yards                        |logical   |
#'   |defensive_avg_stuff_yards                       |logical   |
#'   |defensive_blocked_field_goal_touchdowns         |logical   |
#'   |defensive_blocked_punt_touchdowns               |logical   |
#'   |defensive_defensive_touchdowns                  |logical   |
#'   |defensive_hurries                               |logical   |
#'   |defensive_kicks_blocked                         |logical   |
#'   |defensive_long_interception                     |logical   |
#'   |defensive_misc_touchdowns                       |logical   |
#'   |defensive_missed_field_goal_return_td           |numeric   |
#'   |defensive_blocked_punt_ez_rec_td                |numeric   |
#'   |defensive_passes_batted_down                    |logical   |
#'   |defensive_passes_defended                       |logical   |
#'   |defensive_two_pt_returns                        |logical   |
#'   |defensive_sacks                                 |logical   |
#'   |defensive_sack_yards                            |logical   |
#'   |defensive_safeties                              |logical   |
#'   |defensive_solo_tackles                          |logical   |
#'   |defensive_stuffs                                |logical   |
#'   |defensive_stuff_yards                           |logical   |
#'   |defensive_tackles_for_loss                      |logical   |
#'   |defensive_team_games_played                     |logical   |
#'   |defensive_total_tackles                         |logical   |
#'   |defensive_yards_allowed                         |logical   |
#'   |defensive_points_allowed                        |logical   |
#'   |defensive_one_pt_safeties_made                  |logical   |
#'   |defensive_interceptions_interceptions           |logical   |
#'   |defensive_interceptions_interception_touchdowns |logical   |
#'   |defensive_interceptions_interception_yards      |logical   |
#'   |kicking_avg_kickoff_return_yards                |logical   |
#'   |kicking_avg_kickoff_yards                       |logical   |
#'   |kicking_extra_point_attempts                    |logical   |
#'   |kicking_extra_point_pct                         |logical   |
#'   |kicking_extra_points_blocked                    |logical   |
#'   |kicking_extra_points_blocked_pct                |logical   |
#'   |kicking_extra_points_made                       |logical   |
#'   |kicking_fair_catches                            |logical   |
#'   |kicking_fair_catch_pct                          |logical   |
#'   |kicking_field_goal_attempts                     |logical   |
#'   |kicking_field_goal_attempts1_19                 |logical   |
#'   |kicking_field_goal_attempts20_29                |logical   |
#'   |kicking_field_goal_attempts30_39                |logical   |
#'   |kicking_field_goal_attempts40_49                |logical   |
#'   |kicking_field_goal_attempts50_59                |logical   |
#'   |kicking_field_goal_attempts60_99                |logical   |
#'   |kicking_field_goal_attempts50                   |logical   |
#'   |kicking_field_goal_attempt_yards                |logical   |
#'   |kicking_field_goal_pct                          |logical   |
#'   |kicking_field_goals_blocked                     |logical   |
#'   |kicking_field_goals_blocked_pct                 |logical   |
#'   |kicking_field_goals_made                        |logical   |
#'   |kicking_field_goals_made1_19                    |logical   |
#'   |kicking_field_goals_made20_29                   |logical   |
#'   |kicking_field_goals_made30_39                   |logical   |
#'   |kicking_field_goals_made40_49                   |logical   |
#'   |kicking_field_goals_made50_59                   |logical   |
#'   |kicking_field_goals_made60_99                   |logical   |
#'   |kicking_field_goals_made50                      |logical   |
#'   |kicking_field_goals_made_yards                  |logical   |
#'   |kicking_field_goals_missed_yards                |logical   |
#'   |kicking_kickoff_returns                         |logical   |
#'   |kicking_kickoff_return_touchdowns               |logical   |
#'   |kicking_kickoff_return_yards                    |logical   |
#'   |kicking_kickoffs                                |logical   |
#'   |kicking_kickoff_yards                           |logical   |
#'   |kicking_long_field_goal_attempt                 |logical   |
#'   |kicking_long_field_goal_made                    |logical   |
#'   |kicking_long_kickoff                            |logical   |
#'   |kicking_team_games_played                       |logical   |
#'   |kicking_total_kicking_points                    |logical   |
#'   |kicking_touchback_pct                           |logical   |
#'   |kicking_touchbacks                              |logical   |
#'   |returning_def_fumble_returns                    |logical   |
#'   |returning_def_fumble_return_yards               |logical   |
#'   |returning_fumble_recoveries                     |logical   |
#'   |returning_fumble_recovery_yards                 |logical   |
#'   |returning_kick_return_fair_catches              |logical   |
#'   |returning_kick_return_fair_catch_pct            |logical   |
#'   |returning_kick_return_fumbles                   |logical   |
#'   |returning_kick_return_fumbles_lost              |logical   |
#'   |returning_kick_returns                          |logical   |
#'   |returning_kick_return_touchdowns                |logical   |
#'   |returning_kick_return_yards                     |logical   |
#'   |returning_long_kick_return                      |logical   |
#'   |returning_long_punt_return                      |logical   |
#'   |returning_misc_fumble_returns                   |logical   |
#'   |returning_misc_fumble_return_yards              |logical   |
#'   |returning_opp_fumble_recoveries                 |logical   |
#'   |returning_opp_fumble_recovery_yards             |logical   |
#'   |returning_opp_special_team_fumble_returns       |logical   |
#'   |returning_opp_special_team_fumble_return_yards  |logical   |
#'   |returning_punt_return_fair_catches              |logical   |
#'   |returning_punt_return_fair_catch_pct            |logical   |
#'   |returning_punt_return_fumbles                   |logical   |
#'   |returning_punt_return_fumbles_lost              |logical   |
#'   |returning_punt_returns                          |logical   |
#'   |returning_punt_returns_started_inside_the10     |logical   |
#'   |returning_punt_returns_started_inside_the20     |logical   |
#'   |returning_punt_return_touchdowns                |logical   |
#'   |returning_punt_return_yards                     |logical   |
#'   |returning_special_team_fumble_returns           |logical   |
#'   |returning_special_team_fumble_return_yards      |logical   |
#'   |returning_team_games_played                     |logical   |
#'   |returning_yards_per_kick_return                 |logical   |
#'   |returning_yards_per_punt_return                 |logical   |
#'   |returning_yards_per_return                      |logical   |
#'   |punting_avg_punt_return_yards                   |logical   |
#'   |punting_fair_catches                            |logical   |
#'   |punting_gross_avg_punt_yards                    |logical   |
#'   |punting_long_punt                               |logical   |
#'   |punting_net_avg_punt_yards                      |logical   |
#'   |punting_punt_returns                            |logical   |
#'   |punting_punt_return_yards                       |logical   |
#'   |punting_punts                                   |logical   |
#'   |punting_punts_blocked                           |logical   |
#'   |punting_punts_blocked_pct                       |logical   |
#'   |punting_punts_inside10                          |logical   |
#'   |punting_punts_inside10pct                       |logical   |
#'   |punting_punts_inside20                          |logical   |
#'   |punting_punts_inside20pct                       |logical   |
#'   |punting_punt_yards                              |logical   |
#'   |punting_team_games_played                       |logical   |
#'   |punting_touchback_pct                           |logical   |
#'   |punting_touchbacks                              |logical   |
#'   |miscellaneous_first_downs                       |logical   |
#'   |miscellaneous_first_downs_passing               |logical   |
#'   |miscellaneous_first_downs_penalty               |logical   |
#'   |miscellaneous_first_downs_per_game              |logical   |
#'   |miscellaneous_first_downs_rushing               |logical   |
#'   |miscellaneous_fourth_down_attempts              |logical   |
#'   |miscellaneous_fourth_down_conv_pct              |logical   |
#'   |miscellaneous_fourth_down_convs                 |logical   |
#'   |miscellaneous_fumbles_lost                      |logical   |
#'   |miscellaneous_possession_time_seconds           |logical   |
#'   |miscellaneous_redzone_efficiency_pct            |logical   |
#'   |miscellaneous_redzone_field_goal_pct            |logical   |
#'   |miscellaneous_redzone_scoring_pct               |logical   |
#'   |miscellaneous_redzone_touchdown_pct             |logical   |
#'   |miscellaneous_third_down_attempts               |logical   |
#'   |miscellaneous_third_down_conv_pct               |logical   |
#'   |miscellaneous_third_down_convs                  |logical   |
#'   |miscellaneous_total_giveaways                   |logical   |
#'   |miscellaneous_total_penalties                   |logical   |
#'   |miscellaneous_total_penalty_yards               |logical   |
#'   |miscellaneous_total_takeaways                   |logical   |
#'   |miscellaneous_total_drives                      |logical   |
#'   |miscellaneous_turn_over_differential            |logical   |
#'   |team_id                                         |character |
#'   |team_guid                                       |character |
#'   |team_uid                                        |character |
#'   |team_sdr                                        |character |
#'   |team_slug                                       |character |
#'   |team_location                                   |character |
#'   |team_name                                       |character |
#'   |team_nickname                                   |character |
#'   |team_abbreviation                               |character |
#'   |team_display_name                               |character |
#'   |team_short_display_name                         |character |
#'   |team_color                                      |character |
#'   |team_alternate_color                            |character |
#'   |is_active                                       |logical   |
#'   |is_all_star                                     |logical   |
#'   |logo_href                                       |character |
#'   |logo_dark_href                                  |character |
#'
#' @examples
#' \donttest{
#'   try(espn_cfb_player_stats(athlete_id = 530308, year = 2013))
#'   try(espn_cfb_player_stats(athlete_id = 4360799, year = 2022))
#' }
#'
espn_cfb_player_stats <- function(athlete_id, year, season_type='regular', total=FALSE){
  validate_season_type(season_type, allow_both = F)

  s_type <- ifelse(season_type == "postseason", 3, 2)

  base_url <- "https://sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/"

  totals <- ifelse(total == TRUE, 0, "")
  full_url <- paste0(
    base_url,
    year,
    '/types/',s_type,
    '/athletes/', athlete_id,
    '/statistics/', totals
  )
  athlete_url <- paste0(
    base_url,
    year,
    '/athletes/', athlete_id
  )
  cols <- c(
    "general_fumbles",
    "general_fumbles_lost",
    "general_fumbles_forced",
    "general_fumbles_recovered",
    "general_fumbles_touchdowns",
    "general_games_played",
    "general_offensive_two_pt_returns",
    "general_offensive_fumbles_touchdowns",
    "general_defensive_fumbles_touchdowns",
    "passing_avg_gain",
    "passing_completion_pct",
    "passing_completions",
    "passing_espnqb_rating",
    "passing_interception_pct",
    "passing_interceptions",
    "passing_long_passing",
    "passing_misc_yards",
    "passing_net_passing_yards",
    "passing_net_passing_yards_per_game",
    "passing_net_total_yards",
    "passing_net_yards_per_game",
    "passing_passing_attempts",
    "passing_passing_big_plays",
    "passing_passing_first_downs",
    "passing_passing_fumbles",
    "passing_passing_fumbles_lost",
    "passing_passing_touchdown_pct",
    "passing_passing_touchdowns",
    "passing_passing_yards",
    "passing_passing_yards_after_catch",
    "passing_passing_yards_at_catch",
    "passing_passing_yards_per_game",
    "passing_qb_rating",
    "passing_sacks",
    "passing_sack_yards_lost",
    "passing_team_games_played",
    "passing_total_offensive_plays",
    "passing_total_points",
    "passing_total_points_per_game",
    "passing_total_touchdowns",
    "passing_total_yards",
    "passing_total_yards_from_scrimmage",
    "passing_two_point_pass_convs",
    "passing_two_pt_pass",
    "passing_two_pt_pass_attempts",
    "passing_yards_from_scrimmage_per_game",
    "passing_yards_per_completion",
    "passing_yards_per_game",
    "passing_yards_per_pass_attempt",
    "passing_net_yards_per_pass_attempt",
    "passing_quarterback_rating",
    "rushing_avg_gain",
    "rushing_espnrb_rating",
    "rushing_long_rushing",
    "rushing_misc_yards",
    "rushing_net_total_yards",
    "rushing_net_yards_per_game",
    "rushing_rushing_attempts",
    "rushing_rushing_big_plays",
    "rushing_rushing_first_downs",
    "rushing_rushing_fumbles",
    "rushing_rushing_fumbles_lost",
    "rushing_rushing_touchdowns",
    "rushing_rushing_yards",
    "rushing_rushing_yards_per_game",
    "rushing_stuffs",
    "rushing_stuff_yards_lost",
    "rushing_team_games_played",
    "rushing_total_offensive_plays",
    "rushing_total_points",
    "rushing_total_points_per_game",
    "rushing_total_touchdowns",
    "rushing_total_yards",
    "rushing_total_yards_from_scrimmage",
    "rushing_two_point_rush_convs",
    "rushing_two_pt_rush",
    "rushing_two_pt_rush_attempts",
    "rushing_yards_from_scrimmage_per_game",
    "rushing_yards_per_game",
    "rushing_yards_per_rush_attempt",
    "receiving_avg_gain",
    "receiving_espnwr_rating",
    "receiving_long_reception",
    "receiving_misc_yards",
    "receiving_net_total_yards",
    "receiving_net_yards_per_game",
    "receiving_receiving_big_plays",
    "receiving_receiving_first_downs",
    "receiving_receiving_fumbles",
    "receiving_receiving_fumbles_lost",
    "receiving_receiving_targets",
    "receiving_receiving_touchdowns",
    "receiving_receiving_yards",
    "receiving_receiving_yards_after_catch",
    "receiving_receiving_yards_at_catch",
    "receiving_receiving_yards_per_game",
    "receiving_receptions",
    "receiving_team_games_played",
    "receiving_total_offensive_plays",
    "receiving_total_points",
    "receiving_total_points_per_game",
    "receiving_total_touchdowns",
    "receiving_total_yards",
    "receiving_total_yards_from_scrimmage",
    "receiving_two_point_rec_convs",
    "receiving_two_pt_reception",
    "receiving_two_pt_reception_attempts",
    "receiving_yards_from_scrimmage_per_game",
    "receiving_yards_per_game",
    "receiving_yards_per_reception",
    "defensive_assist_tackles",
    "defensive_avg_interception_yards",
    "defensive_avg_sack_yards",
    "defensive_avg_stuff_yards",
    "defensive_blocked_field_goal_touchdowns",
    "defensive_blocked_punt_touchdowns",
    "defensive_defensive_touchdowns",
    "defensive_hurries",
    "defensive_kicks_blocked",
    "defensive_long_interception",
    "defensive_misc_touchdowns",
    "defensive_passes_batted_down",
    "defensive_passes_defended",
    "defensive_two_pt_returns",
    "defensive_sacks",
    "defensive_sack_yards",
    "defensive_safeties",
    "defensive_solo_tackles",
    "defensive_stuffs",
    "defensive_stuff_yards",
    "defensive_tackles_for_loss",
    "defensive_team_games_played",
    "defensive_total_tackles",
    "defensive_yards_allowed",
    "defensive_points_allowed",
    "defensive_one_pt_safeties_made",
    "defensive_interceptions_interceptions",
    "defensive_interceptions_interception_touchdowns",
    "defensive_interceptions_interception_yards",
    "kicking_avg_kickoff_return_yards",
    "kicking_avg_kickoff_yards",
    "kicking_extra_point_attempts",
    "kicking_extra_point_pct",
    "kicking_extra_points_blocked",
    "kicking_extra_points_blocked_pct",
    "kicking_extra_points_made",
    "kicking_fair_catches",
    "kicking_fair_catch_pct",
    "kicking_field_goal_attempts",
    "kicking_field_goal_attempts1_19",
    "kicking_field_goal_attempts20_29",
    "kicking_field_goal_attempts30_39",
    "kicking_field_goal_attempts40_49",
    "kicking_field_goal_attempts50_59",
    "kicking_field_goal_attempts60_99",
    "kicking_field_goal_attempts50",
    "kicking_field_goal_attempt_yards",
    "kicking_field_goal_pct",
    "kicking_field_goals_blocked",
    "kicking_field_goals_blocked_pct",
    "kicking_field_goals_made",
    "kicking_field_goals_made1_19",
    "kicking_field_goals_made20_29",
    "kicking_field_goals_made30_39",
    "kicking_field_goals_made40_49",
    "kicking_field_goals_made50_59",
    "kicking_field_goals_made60_99",
    "kicking_field_goals_made50",
    "kicking_field_goals_made_yards",
    "kicking_field_goals_missed_yards",
    "kicking_kickoff_returns",
    "kicking_kickoff_return_touchdowns",
    "kicking_kickoff_return_yards",
    "kicking_kickoffs",
    "kicking_kickoff_yards",
    "kicking_long_field_goal_attempt",
    "kicking_long_field_goal_made",
    "kicking_long_kickoff",
    "kicking_team_games_played",
    "kicking_total_kicking_points",
    "kicking_touchback_pct",
    "kicking_touchbacks",
    "returning_def_fumble_returns",
    "returning_def_fumble_return_yards",
    "returning_fumble_recoveries",
    "returning_fumble_recovery_yards",
    "returning_kick_return_fair_catches",
    "returning_kick_return_fair_catch_pct",
    "returning_kick_return_fumbles",
    "returning_kick_return_fumbles_lost",
    "returning_kick_returns",
    "returning_kick_return_touchdowns",
    "returning_kick_return_yards",
    "returning_long_kick_return",
    "returning_long_punt_return",
    "returning_misc_fumble_returns",
    "returning_misc_fumble_return_yards",
    "returning_opp_fumble_recoveries",
    "returning_opp_fumble_recovery_yards",
    "returning_opp_special_team_fumble_returns",
    "returning_opp_special_team_fumble_return_yards",
    "returning_punt_return_fair_catches",
    "returning_punt_return_fair_catch_pct",
    "returning_punt_return_fumbles",
    "returning_punt_return_fumbles_lost",
    "returning_punt_returns",
    "returning_punt_returns_started_inside_the10",
    "returning_punt_returns_started_inside_the20",
    "returning_punt_return_touchdowns",
    "returning_punt_return_yards",
    "returning_special_team_fumble_returns",
    "returning_special_team_fumble_return_yards",
    "returning_team_games_played",
    "returning_yards_per_kick_return",
    "returning_yards_per_punt_return",
    "returning_yards_per_return",
    "punting_avg_punt_return_yards",
    "punting_fair_catches",
    "punting_gross_avg_punt_yards",
    "punting_long_punt",
    "punting_net_avg_punt_yards",
    "punting_punt_returns",
    "punting_punt_return_yards",
    "punting_punts",
    "punting_punts_blocked",
    "punting_punts_blocked_pct",
    "punting_punts_inside10",
    "punting_punts_inside10pct",
    "punting_punts_inside20",
    "punting_punts_inside20pct",
    "punting_punt_yards",
    "punting_team_games_played",
    "punting_touchback_pct",
    "punting_touchbacks",
    "scoring_defensive_points",
    "scoring_field_goals",
    "scoring_kick_extra_points",
    "scoring_misc_points",
    "scoring_passing_touchdowns",
    "scoring_receiving_touchdowns",
    "scoring_return_touchdowns",
    "scoring_rushing_touchdowns",
    "scoring_total_points",
    "scoring_total_points_per_game",
    "scoring_total_touchdowns",
    "scoring_total_two_point_convs",
    "scoring_two_point_pass_convs",
    "scoring_two_point_rec_convs",
    "scoring_two_point_rush_convs",
    "scoring_one_pt_safeties_made",
    "miscellaneous_first_downs",
    "miscellaneous_first_downs_passing",
    "miscellaneous_first_downs_penalty",
    "miscellaneous_first_downs_per_game",
    "miscellaneous_first_downs_rushing",
    "miscellaneous_fourth_down_attempts",
    "miscellaneous_fourth_down_conv_pct",
    "miscellaneous_fourth_down_convs",
    "miscellaneous_fumbles_lost",
    "miscellaneous_possession_time_seconds",
    "miscellaneous_redzone_efficiency_pct",
    "miscellaneous_redzone_field_goal_pct",
    "miscellaneous_redzone_scoring_pct",
    "miscellaneous_redzone_touchdown_pct",
    "miscellaneous_third_down_attempts",
    "miscellaneous_third_down_conv_pct",
    "miscellaneous_third_down_convs",
    "miscellaneous_total_giveaways",
    "miscellaneous_total_penalties",
    "miscellaneous_total_penalty_yards",
    "miscellaneous_total_takeaways",
    "miscellaneous_total_drives",
    "miscellaneous_turn_over_differential"
  )

  athlete_cols <- c(
    "athlete_id",
    "athlete_uid",
    "athlete_guid",
    "athlete_type",
    "sdr",
    "first_name",
    "last_name",
    "full_name",
    "display_name",
    "short_name",
    "weight",
    "display_weight",
    "height",
    "display_height",
    "birth_place_city",
    "birth_place_state",
    "birth_place_country",
    "date_of_birth",
    "age",
    "slug",
    "headshot_href",
    "headshot_alt",
    "jersey",
    "position_id",
    "position_name",
    "position_display_name",
    "position_abbreviation",
    "position_leaf",
    "linked",
    "experience_years",
    "experience_display_value",
    "experience_abbreviation",
    "active",
    "status_id",
    "status_name",
    "status_type",
    "status_abbreviation"
  )

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- httr::RETRY("GET", full_url)

      # Check the result
      check_status(res)
      # Create the GET request and set response as res
      athlete_res <- httr::RETRY("GET", athlete_url)

      # Check the result
      check_status(athlete_res)

      athlete_df <- athlete_res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)

      team_url <- athlete_df[["team"]][["$ref"]]

      # Create the GET request and set response as res
      team_res <- httr::RETRY("GET", team_url)

      # Check the result
      check_status(team_res)

      team_df <- team_res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)

      team_df[["links"]] <- NULL
      team_df[["injuries"]] <- NULL
      team_df[["record"]] <- NULL
      team_df[["athletes"]] <- NULL
      team_df[["venue"]] <- NULL
      team_df[["groups"]] <- NULL
      team_df[["ranks"]] <- NULL
      team_df[["statistics"]] <- NULL
      team_df[["leaders"]] <- NULL
      team_df[["links"]] <- NULL
      team_df[["notes"]] <- NULL
      team_df[["franchise"]] <- NULL
      team_df[["againstTheSpreadRecords"]] <- NULL
      team_df[["oddsRecords"]] <- NULL
      team_df[["college"]] <- NULL
      team_df[["transactions"]] <- NULL
      team_df[["leaders"]] <- NULL
      team_df[["depthCharts"]] <- NULL
      team_df[["awards"]] <- NULL
      team_df[["events"]] <- NULL


      team_df <- team_df %>%
        purrr::map_if(is.list,as.data.frame) %>%
        as.data.frame() %>%
        dplyr::select(
          -dplyr::any_of(
            c("logos.width",
              "logos.height",
              "logos.alt",
              "logos.rel..full.",
              "logos.rel..default.",
              "logos.rel..scoreboard.",
              "logos.rel..scoreboard..1",
              "logos.rel..scoreboard.2",
              "logos.lastUpdated",
              "logos.width.1",
              "logos.height.1",
              "logos.alt.1",
              "logos.rel..full..1",
              "logos.rel..dark.",
              "logos.rel..dark..1",
              "logos.lastUpdated.1",
              "logos.width.2",
              "logos.height.2",
              "logos.alt.2",
              "logos.rel..full..2",
              "logos.rel..scoreboard.",
              "logos.lastUpdated.2",
              "logos.width.3",
              "logos.height.3",
              "logos.alt.3",
              "logos.rel..full..3",
              "logos.lastUpdated.3",
              "X.ref",
              "X.ref.1",
              "X.ref.2"))) %>%
        janitor::clean_names()
      colnames(team_df)[1:13] <- paste0("team_",colnames(team_df)[1:13])

      team_df <- team_df %>%
        dplyr::rename(
          "logo_href" = "logos_href",
          "logo_dark_href" = "logos_href_1") %>%
        dplyr::select(-tidyr::starts_with("logos"))

      athlete_df[["links"]] <- NULL
      athlete_df[["injuries"]] <- NULL

      athlete_df <- athlete_df %>%
        purrr::map_if(is.list, as.data.frame) %>%
        tibble::tibble(data=.data$.)

      athlete_df <- athlete_df$data %>%
        as.data.frame() %>%
        dplyr::select(-dplyr::any_of(c("X.ref","X.ref.1","X.ref.2","X.ref.3","X.ref.4","X.ref.5","X.ref.6","X.ref.7","X.ref.8",
                                       "position.X.ref","position.X.ref.1",
                                       "contract.x.ref","contract.x.ref.1","contract.x.ref.2",
                                       "draft.x.ref","draft.x.ref.1"))) %>%
        janitor::clean_names() %>%
        dplyr::rename(
          "athlete_id" = "id",
          "athlete_uid" = "uid",
          "athlete_guid" = "guid",
          "athlete_type" = "type")


      # Get the content and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        purrr::pluck("splits") %>%
        purrr::pluck("categories") %>%
        tidyr::unnest("stats", names_sep="_")
      df <- df %>%
        dplyr::mutate(
          stats_category_name = glue::glue("{.data$name}_{.data$stats_name}")) %>%
        dplyr::select("stats_category_name", "stats_value") %>%
        tidyr::pivot_wider(names_from = "stats_category_name",
                           values_from = "stats_value",
                           values_fn = dplyr::first) %>%
        janitor::clean_names()

      df[cols[!(cols %in% colnames(df))]] <- NA
      athlete_df[athlete_cols[!(athlete_cols %in% colnames(athlete_df))]] <- NA

      df <- athlete_df %>%
        dplyr::bind_cols(df) %>%
        dplyr::bind_cols(team_df)

      df <- df %>%
        make_cfbfastR_data("CFB Player Season stats from ESPN.com",Sys.time())

    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no season player stats data available!"))
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Players Index**
#' @description Get a paginated index of ESPN college football players for a
#' season. Each row is one player reference (id + `$ref` URL); dereference
#' a row with [espn_cfb_player()] to retrieve the full player record.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/athletes`.
#' The season-scoped index contains roughly 99,500 players, returned in
#' fixed-size pages -- this wrapper deliberately returns *id + `$ref` rows
#' only* and never dereferences the individual player records, because a
#' full crawl would be tens of thousands of HTTP calls. Walk the index a
#' page at a time with `page`, and cap how far a single call goes with
#' `max_pages`. The total page count for the season is reported in the
#' `page_count` column so a caller can drive its own pagination loop. To
#' resolve an individual player to a full record, pass its `athlete_id`
#' to [espn_cfb_player()].
#'
#' When `athlete_detail = TRUE` the index is enriched with the
#' human-readable name columns `athlete_display_name`,
#' `athlete_first_name`, `athlete_last_name`, `athlete_jersey`,
#' `athlete_position`, and `athlete_position_abbreviation`. There is no
#' bulk athlete-name catalog, so resolving names here costs **one HTTP call
#' per player returned** -- with the default `limit = 100` that is 100
#' extra requests per page. It therefore defaults to `FALSE`. A per-athlete
#' fetch failure leaves that player's name columns `NA` rather than
#' erroring the wrapper. Keep `limit` small (or `athlete_detail = FALSE`)
#' when walking many pages.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param page (*Integer* optional, default 1): First page of the index to
#' fetch.
#' @param max_pages (*Integer* optional, default 1): Number of consecutive
#' pages to fetch starting at `page`. Each page holds `limit` players.
#' @param limit (*Integer* optional, default 100): Players per page
#' (ESPN page size).
#' @param athlete_detail (*Logical*): when `TRUE`, dereference each player
#' returned and append the `athlete_*` name columns (see *Details*). This
#' costs one HTTP call per player, so it defaults to `FALSE`; setting it
#' `FALSE` reproduces the prior output exactly.
#' @return A data frame with one row per player reference:
#'
#'    |col_name    |types     |description                                       |
#'    |:-----------|:---------|:-------------------------------------------------|
#'    |season      |integer   |Season (4-digit year).                            |
#'    |athlete_id  |character |ESPN athlete id (parsed from `athlete_ref`).      |
#'    |athlete_ref |character |`$ref` URL to the athlete-in-season resource.     |
#'    |page        |integer   |Index page this player was returned on.           |
#'    |page_count  |integer   |Total number of pages in the season index.        |
#'    |count       |integer   |Total number of players in the season index.      |
#'    |athlete_display_name|character |Player display name; `athlete_detail = TRUE` only. |
#'    |athlete_first_name|character |Player first name; `athlete_detail = TRUE` only.   |
#'    |athlete_last_name|character |Player last name; `athlete_detail = TRUE` only.     |
#'    |athlete_jersey|character |Player jersey number; `athlete_detail = TRUE` only.  |
#'    |athlete_position|character |Player position name; `athlete_detail = TRUE` only. |
#'    |athlete_position_abbreviation|character |Player position abbreviation; `athlete_detail = TRUE` only. |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Players
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_players(year = 2024, page = 1, max_pages = 1))
#'   try(espn_cfb_players(year = 2024, page = 1, max_pages = 1, limit = 5,
#'                        athlete_detail = TRUE))
#' }
espn_cfb_players <- function(year = NULL,
                             page = 1,
                             max_pages = 1,
                             limit = 100,
                             athlete_detail = FALSE) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN players index endpoint.")
  }
  validate_year(year)

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      rows <- list()
      pages_to_fetch <- seq.int(
        from = as.integer(page),
        length.out = max(1L, as.integer(max_pages))
      )

      for (pg in pages_to_fetch) {
        url <- glue::glue(
          "https://sports.core.api.espn.com/v2/sports/football/leagues/",
          "college-football/seasons/{year}/athletes",
          "?limit={limit}&page={pg}&lang=en&region=us"
        )
        res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
        check_status(res)

        raw <- res %>%
          httr::content(as = "text", encoding = "UTF-8") %>%
          jsonlite::fromJSON(simplifyVector = FALSE)

        items <- raw[["items"]]
        page_count <- suppressWarnings(as.integer(raw[["pageCount"]] %||% NA))
        count <- suppressWarnings(as.integer(raw[["count"]] %||% NA))

        if (is.null(items) || length(items) == 0) {
          break
        }

        for (it in items) {
          athlete_ref <- it[["$ref"]] %||% NA_character_
          athlete_id <- if (!is.na(athlete_ref)) {
            sub(".*/athletes/([0-9]+).*", "\\1", athlete_ref)
          } else {
            NA_character_
          }
          rows[[length(rows) + 1L]] <- data.frame(
            season           = suppressWarnings(as.integer(year)),
            athlete_id       = athlete_id,
            athlete_ref      = athlete_ref,
            page             = suppressWarnings(as.integer(pg)),
            page_count       = page_count,
            count            = count,
            stringsAsFactors = FALSE
          )
        }

        # Stop early if we have walked past the last page.
        if (!is.na(page_count) && pg >= page_count) {
          break
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble()

      # Optional name resolution -- one HTTP call per athlete returned, so
      # off by default. Each distinct athlete is dereferenced once.
      if (isTRUE(athlete_detail)) {
        df <- .espn_cfb_attach_athlete_detail_multi(df, year = year)
      }

      df <- df %>%
        make_cfbfastR_data("Players index from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN players index data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Recruits**
#' @description Get the ESPN recruiting-class catalog for a college football
#' signing class -- one row per recruit, with athlete identity, position,
#' physical measurements, ESPN grade, the overall / position / state /
#' region rankings, the committed school, and the recruit's hometown and
#' high school.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/recruits`.
#' The season index is `$ref`-paginated and large (roughly 3,700-4,900
#' recruits per class), so dereferencing every recruit would be thousands
#' of HTTP calls. ESPN exposes no pre-expanded recruiting endpoint -- the
#' `site.web.api.espn.com` recruiting paths all 404 -- so this wrapper caps
#' the walk at `max_results` recruits (default 100). Raise `max_results`
#' (e.g. to several hundred or higher) to pull more of the class, at the
#' cost of one extra HTTP call per recruit.
#'
#' The index is returned by ESPN in athlete-name (alphabetical) order, not
#' ranking order, and the `sort` query parameter is ignored upstream. The
#' default `max_results = 100` therefore returns the alphabetically-first
#' 100 recruits, not the top-100 ranked recruits. To rank the class, pull a
#' larger slice and sort the result on `overall_rank` (lower is better);
#' note ESPN only publishes an `overall_rank` for the highly-rated portion
#' of each class, so most recruits carry `NA` there. `position_rank`,
#' `state_rank`, and `region_rank` are populated more widely. `grade` is
#' ESPN's 0-100 recruit grade (`0` / `gradeDisplayValue = "NR"` means not
#' rated).
#'
#' `committed_team_id` / `committed_team_ref` are resolved from the
#' recruit's `schools` array by matching a school whose commitment status
#' equals the recruit's top-level status (e.g. `Signed`); recruits still
#' uncommitted at fetch time leave both columns `NA`.
#' @param year (*Integer* required): Recruiting class / signing year, 4
#' digit format (*YYYY*).
#' @param max_results (*Integer* default 100): Maximum number of recruits
#' to dereference and return. The index is alphabetical, so this returns
#' the alphabetically-first `max_results` recruits; raise it to pull more
#' of the class.
#' @return A data frame with one row per recruit:
#'
#'    |col_name              |types     |description                                       |
#'    |:---------------------|:---------|:-------------------------------------------------|
#'    |recruit_id            |character |ESPN recruit id.                                  |
#'    |recruiting_class      |integer   |Recruiting class / signing year.                  |
#'    |athlete_id            |character |ESPN athlete id.                                  |
#'    |alternate_athlete_id  |character |ESPN alternate athlete id (recruiting feed id).   |
#'    |first_name            |character |Recruit first name.                               |
#'    |last_name             |character |Recruit last name.                                |
#'    |full_name             |character |Recruit full name.                                |
#'    |display_name          |character |Recruit display name.                             |
#'    |short_name            |character |Recruit short name.                               |
#'    |position_id           |character |ESPN position id.                                 |
#'    |position_abbreviation |character |Position abbreviation (e.g. `OT`, `WR`).          |
#'    |weight                |numeric   |Listed weight (lbs).                              |
#'    |height                |numeric   |Listed height (inches).                           |
#'    |grade                 |numeric   |ESPN recruit grade (0-100; `0` = not rated).      |
#'    |grade_display_value   |character |Display-formatted grade (`NR` when not rated).    |
#'    |overall_rank          |integer   |Overall recruit ranking (top recruits only; may be `NA`). |
#'    |position_rank         |integer   |Position ranking.                                 |
#'    |state_rank            |integer   |State ranking.                                    |
#'    |region_rank           |integer   |Region ranking.                                   |
#'    |status_id             |character |ESPN commitment status id.                        |
#'    |status                |character |Commitment status description (e.g. `Signed`).    |
#'    |committed_team_id     |character |ESPN team id of the committed school (may be `NA`). |
#'    |hometown_city         |character |Recruit hometown city.                            |
#'    |hometown_state        |character |Recruit hometown state.                           |
#'    |hometown_state_abbreviation|character |Recruit hometown state abbreviation.         |
#'    |high_school_id        |character |ESPN high-school id.                              |
#'    |high_school_name      |character |Recruit high-school name.                         |
#'    |recruit_ref           |character |`$ref` URL to the recruit resource.               |
#'    |athlete_ref           |character |Player-card URL for the recruit.                  |
#'    |committed_team_ref    |character |`$ref` URL to the committed team-in-season resource. |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Recruiting
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_recruits(year = 2024, max_results = 25))
#' }
espn_cfb_recruits <- function(year = NULL,
                              max_results = 100) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN recruits endpoint.")
  }
  validate_year(year)

  max_results <- suppressWarnings(as.integer(max_results))
  if (is.na(max_results) || max_results < 1L) max_results <- 100L

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  get_json <- function(u) {
    httr::RETRY("GET", u, httr::add_headers(.headers = headers)) %>%
      httr::content(as = "text", encoding = "UTF-8") %>%
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  base_url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/recruits?limit=100&lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", base_url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      page_count <- raw[["pageCount"]] %||% 1L
      items <- raw[["items"]] %||% list()

      # Walk additional pages only until the cap is reached.
      pg <- 2L
      while (length(items) < max_results && pg <= page_count) {
        pg_raw <- get_json(paste0(base_url, "&page=", pg))
        items <- c(items, pg_raw[["items"]] %||% list())
        pg <- pg + 1L
      }

      if (length(items) == 0) {
        return(df)
      }
      items <- items[seq_len(min(length(items), max_results))]

      rows <- list()
      for (it in items) {
        recruit_ref <- it[["$ref"]] %||% NA_character_
        rec <- if (!is.na(recruit_ref)) get_json(recruit_ref) else it
        if (!is.list(rec)) next

        ath    <- if (is.list(rec[["athlete"]]))    rec[["athlete"]]    else list()
        pos    <- if (is.list(ath[["position"]]))   ath[["position"]]   else list()
        home   <- if (is.list(ath[["hometown"]]))   ath[["hometown"]]   else list()
        hs     <- if (is.list(ath[["highSchool"]])) ath[["highSchool"]] else list()
        status <- if (is.list(rec[["status"]]))     rec[["status"]]     else list()

        # athlete_ref: the recruit player-card link, when present.
        athlete_ref <- NA_character_
        for (lnk in ath[["links"]] %||% list()) {
          if (is.list(lnk) && !is.null(lnk[["href"]])) {
            athlete_ref <- lnk[["href"]]
            break
          }
        }

        # Rankings live in the attributes array, keyed by `name`.
        attrs <- list()
        for (at in rec[["attributes"]] %||% list()) {
          nm <- at[["name"]]
          if (!is.null(nm)) attrs[[nm]] <- at[["value"]]
        }

        # Committed school: among schools[], the one whose commitment
        # status matches the recruit's top-level status (Signed/Committed),
        # ignoring the `Undecided` (id 0) interest entries.
        committed_ref <- NA_character_
        top_status_id <- as.character(status[["id"]] %||% NA)
        for (s in rec[["schools"]] %||% list()) {
          if (!is.list(s)) next
          s_status <- if (is.list(s[["status"]])) s[["status"]] else list()
          s_id <- as.character(s_status[["id"]] %||% NA)
          if (!is.na(s_id) && s_id != "0" && !is.na(top_status_id) &&
              s_id == top_status_id) {
            committed_ref <- if (is.list(s[["team"]])) {
              s[["team"]][["$ref"]] %||% NA_character_
            } else {
              NA_character_
            }
            break
          }
        }
        committed_team_id <- if (!is.na(committed_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", committed_ref)
        } else {
          NA_character_
        }

        recruit_id <- if (!is.na(recruit_ref)) {
          sub(".*/recruits/([0-9]+).*", "\\1", recruit_ref)
        } else {
          NA_character_
        }

        rows[[length(rows) + 1L]] <- data.frame(
          recruit_id                  = recruit_id,
          recruiting_class            = suppressWarnings(as.integer(
            rec[["recruitingClass"]] %||% year)),
          athlete_id                  = as.character(ath[["id"]] %||% NA_character_),
          alternate_athlete_id        = as.character(ath[["alternateId"]] %||% NA_character_),
          first_name                  = ath[["firstName"]] %||% NA_character_,
          last_name                   = ath[["lastName"]] %||% NA_character_,
          full_name                   = ath[["fullName"]] %||% NA_character_,
          display_name                = ath[["displayName"]] %||% NA_character_,
          short_name                  = ath[["shortName"]] %||% NA_character_,
          position_id                 = as.character(pos[["id"]] %||% NA_character_),
          position_abbreviation       = pos[["abbreviation"]] %||% NA_character_,
          weight                      = suppressWarnings(as.numeric(ath[["weight"]] %||% NA)),
          height                      = suppressWarnings(as.numeric(ath[["height"]] %||% NA)),
          grade                       = suppressWarnings(as.numeric(rec[["grade"]] %||% NA)),
          grade_display_value         = as.character(rec[["gradeDisplayValue"]] %||% NA_character_),
          overall_rank                = suppressWarnings(as.integer(attrs[["rank"]] %||% NA)),
          position_rank               = suppressWarnings(as.integer(attrs[["positionRank"]] %||% NA)),
          state_rank                  = suppressWarnings(as.integer(attrs[["stateRank"]] %||% NA)),
          region_rank                 = suppressWarnings(as.integer(attrs[["regionRank"]] %||% NA)),
          status_id                   = as.character(status[["id"]] %||% NA_character_),
          status                      = status[["description"]] %||% NA_character_,
          committed_team_id           = committed_team_id,
          hometown_city               = home[["city"]] %||% NA_character_,
          hometown_state              = home[["state"]] %||% NA_character_,
          hometown_state_abbreviation = home[["stateAbbreviation"]] %||% NA_character_,
          high_school_id              = as.character(hs[["id"]] %||% NA_character_),
          high_school_name            = hs[["name"]] %||% NA_character_,
          recruit_ref                 = recruit_ref,
          athlete_ref                 = athlete_ref,
          committed_team_ref          = committed_ref,
          stringsAsFactors            = FALSE
        )
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Recruiting class data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN recruits data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}
