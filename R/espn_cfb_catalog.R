# espn_cfb_catalog.R -- ESPN college football league catalog wrappers
# Consolidated family file. Each function keeps its own
# roxygen block; edit the block above the function you want.

#' @title
#' **ESPN College Football Award Detail**
#' @description Get the ESPN core-v2 detail record for a single college
#' football award in a given season -- name, description, history, and the
#' athlete (and team) that won it.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/awards/{award_id}`.
#' [espn_cfb_awards()] returns the season award index; this wrapper returns
#' the single-award detail (including the long-form `history` text) for one
#' id. Returns one row per (award x winner) -- most awards have a single
#' winner, so the table is typically one row. An award with no winner
#' recorded yet still contributes one row with `athlete_id`/`team_id` left
#' `NA`. Winners are returned as ESPN athlete and team ids only -- join to
#' an athlete source for names. Enumerate `award_id`s with
#' [espn_cfb_awards()].
#' @param award_id (*Integer* required): ESPN award id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), the ESPN team
#' catalog ([espn_cfb_teams()]) is fetched once and friendly team fields are
#' joined in next to the `team_id` column. The sibling columns `team_name`,
#' `team_abbreviation`, `team_location`, `team_display_name`,
#' `team_short_display_name`, `team_nickname`, `team_color`,
#' `team_alternate_color`, `team_logo_href`, `team_logo_dark_href` are
#' inserted immediately after `team_id`. A catalog failure degrades to `NA`
#' rather than erroring the wrapper. Set `FALSE` to skip the catalog fetch
#' and the join, reproducing the prior output exactly.
#' @return A data frame with one row per award-winner:
#'
#'    |col_name                |types     |description                                          |
#'    |:-----------------------|:---------|:----------------------------------------------------|
#'    |season                  |integer   |Season (4-digit year) queried.                       |
#'    |award_id                |character |ESPN award id.                                       |
#'    |name                    |character |Award name (e.g. `Buck Buchanan Award`).             |
#'    |description             |character |ESPN's short description of the award.               |
#'    |history                 |character |ESPN's long-form history text for the award.         |
#'    |athlete_id              |character |ESPN id of the winning athlete (parsed from `athlete_ref`); `NA` if none. |
#'    |team_id                 |character |ESPN id of the winner's team (parsed from `team_ref`); `NA` if none. |
#'    |team_name               |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation       |character |Team abbreviation; `team_detail = TRUE` only.        |
#'    |team_location           |character |Team location / school name; `team_detail = TRUE` only. |
#'    |team_display_name       |character |Full team display name; `team_detail = TRUE` only.   |
#'    |team_short_display_name |character |Short team display name; `team_detail = TRUE` only.  |
#'    |team_nickname           |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color              |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color    |character |Alternate team color; `team_detail = TRUE` only.     |
#'    |team_logo_href          |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href     |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |award_ref               |character |`$ref` URL to the award resource.                    |
#'    |athlete_ref             |character |`$ref` URL to the winning athlete resource (may be `NA`). |
#'    |team_ref                |character |`$ref` URL to the winner's team resource (may be `NA`). |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Award
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_award(award_id = 1, year = 2024))
#'   try(espn_cfb_award(award_id = 1, year = 2024, team_detail = FALSE))
#' }
espn_cfb_award <- function(award_id = NULL,
                           year = NULL,
                           team_detail = TRUE) {

  # Validation ----
  if (is.null(award_id)) {
    cli::cli_abort("{.arg award_id} is required for the ESPN award endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN award endpoint.")
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

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/awards/{award_id}?lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      a <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      award_id_v  <- as.character(a[["id"]] %||% award_id)
      award_name  <- as.character(a[["name"]] %||% NA)
      award_desc  <- as.character(a[["description"]] %||% NA)
      award_hist  <- as.character(a[["history"]] %||% NA)
      award_ref   <- as.character(a[["$ref"]] %||% NA)

      winners <- a[["winners"]] %||% list()

      rows <- list()
      if (length(winners) == 0) {
        rows[[1L]] <- data.frame(
          season      = suppressWarnings(as.integer(year)),
          award_id    = award_id_v,
          name        = award_name,
          description = award_desc,
          history     = award_hist,
          athlete_id  = NA_character_,
          team_id     = NA_character_,
          award_ref   = award_ref,
          athlete_ref = NA_character_,
          team_ref    = NA_character_,
          stringsAsFactors = FALSE
        )
      } else {
        for (w in winners) {
          athlete_ref <- if (is.list(w[["athlete"]])) {
            w[["athlete"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          team_ref <- if (is.list(w[["team"]])) {
            w[["team"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          athlete_id <- if (!is.na(athlete_ref)) {
            sub(".*/athletes/([0-9]+).*", "\\1", athlete_ref)
          } else {
            NA_character_
          }
          team_id <- if (!is.na(team_ref)) {
            sub(".*/teams/([0-9]+).*", "\\1", team_ref)
          } else {
            NA_character_
          }
          rows[[length(rows) + 1L]] <- data.frame(
            season      = suppressWarnings(as.integer(year)),
            award_id    = award_id_v,
            name        = award_name,
            description = award_desc,
            history     = award_hist,
            athlete_id  = athlete_id,
            team_id     = team_id,
            award_ref   = award_ref,
            athlete_ref = athlete_ref,
            team_ref    = team_ref,
            stringsAsFactors = FALSE
          )
        }
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column once.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df %>%
        make_cfbfastR_data("Award detail from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN award data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Awards**
#' @description Get ESPN's college football awards for a season -- the
#' Heisman, position and player-of-the-year honors, and the athlete (and
#' team) that won each.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/awards`.
#' The index returns one `$ref` per award (~32); this wrapper dereferences
#' each and returns one row per (award x winner). Most awards have a single
#' winner, so the table is roughly one row per award. Winners are returned
#' as ESPN athlete ids (and team ids) only -- join to an athlete source for
#' names. An award with no winner recorded yet still contributes one row
#' with `athlete_id`/`team_id` left `NA`.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), the ESPN team
#' catalog ([espn_cfb_teams()]) is fetched once and friendly team fields are
#' joined in next to the `team_id` column. The sibling columns `team_name`,
#' `team_abbreviation`, `team_location`, `team_display_name`,
#' `team_short_display_name`, `team_nickname`, `team_color`,
#' `team_alternate_color`, `team_logo_href`, `team_logo_dark_href` are
#' inserted immediately after `team_id`. A catalog failure degrades to `NA`
#' rather than erroring the wrapper. Set `FALSE` to skip the catalog fetch
#' and the join, reproducing the prior output exactly.
#' @return A data frame with one row per award-winner:
#'
#'    |col_name                |types     |description                                          |
#'    |:-----------------------|:---------|:----------------------------------------------------|
#'    |season                  |integer   |Season (4-digit year).                               |
#'    |award_id                |character |ESPN award id.                                       |
#'    |name                    |character |Award name (e.g. `Heisman Trophy`).                  |
#'    |description             |character |ESPN's description of the award.                     |
#'    |athlete_id              |character |ESPN id of the winning athlete (parsed from `athlete_ref`); `NA` if none. |
#'    |team_id                 |character |ESPN id of the winner's team (parsed from `team_ref`); `NA` if none. |
#'    |team_name               |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation       |character |Team abbreviation; `team_detail = TRUE` only.        |
#'    |team_location           |character |Team location / school name; `team_detail = TRUE` only. |
#'    |team_display_name       |character |Full team display name; `team_detail = TRUE` only.   |
#'    |team_short_display_name |character |Short team display name; `team_detail = TRUE` only.  |
#'    |team_nickname           |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color              |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color    |character |Alternate team color; `team_detail = TRUE` only.     |
#'    |team_logo_href          |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href     |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |award_ref               |character |`$ref` URL to the award resource.                    |
#'    |athlete_ref             |character |`$ref` URL to the winning athlete resource (may be `NA`). |
#'    |team_ref                |character |`$ref` URL to the winner's team resource (may be `NA`). |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Awards
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_awards(year = 2024))
#'   try(espn_cfb_awards(year = 2024, team_detail = FALSE))
#' }
espn_cfb_awards <- function(year = NULL,
                            team_detail = TRUE) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN awards endpoint.")
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

  get_json <- function(u) {
    httr::RETRY("GET", u, httr::add_headers(.headers = headers)) %>%
      httr::content(as = "text", encoding = "UTF-8") %>%
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  base_url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/awards?limit=100&lang=en&region=us"
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

      if (page_count > 1L) {
        for (pg in 2:page_count) {
          pg_raw <- get_json(paste0(base_url, "&page=", pg))
          items <- c(items, pg_raw[["items"]] %||% list())
        }
      }

      if (length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        award_ref <- it[["$ref"]] %||% NA_character_
        a <- get_json(award_ref)
        award_id   <- as.character(a[["id"]] %||% NA)
        award_name <- as.character(a[["name"]] %||% NA)
        award_desc <- as.character(a[["description"]] %||% NA)

        winners <- a[["winners"]] %||% list()
        if (length(winners) == 0) {
          rows[[length(rows) + 1L]] <- data.frame(
            season      = suppressWarnings(as.integer(year)),
            award_id    = award_id,
            name        = award_name,
            description = award_desc,
            athlete_id  = NA_character_,
            team_id     = NA_character_,
            award_ref   = award_ref,
            athlete_ref = NA_character_,
            team_ref    = NA_character_,
            stringsAsFactors = FALSE
          )
          next
        }

        for (w in winners) {
          athlete_ref <- if (is.list(w[["athlete"]])) {
            w[["athlete"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          team_ref <- if (is.list(w[["team"]])) {
            w[["team"]][["$ref"]] %||% NA_character_
          } else {
            NA_character_
          }
          athlete_id <- if (!is.na(athlete_ref)) {
            sub(".*/athletes/([0-9]+).*", "\\1", athlete_ref)
          } else {
            NA_character_
          }
          team_id <- if (!is.na(team_ref)) {
            sub(".*/teams/([0-9]+).*", "\\1", team_ref)
          } else {
            NA_character_
          }
          rows[[length(rows) + 1L]] <- data.frame(
            season      = suppressWarnings(as.integer(year)),
            award_id    = award_id,
            name        = award_name,
            description = award_desc,
            athlete_id  = athlete_id,
            team_id     = team_id,
            award_ref   = award_ref,
            athlete_ref = athlete_ref,
            team_ref    = team_ref,
            stringsAsFactors = FALSE
          )
        }
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column once.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df %>%
        make_cfbfastR_data("Awards data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN awards data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Coach Detail**
#' @description Get the ESPN core-v2 detail record for a single college
#' football coach -- name, the team coached in the requested season, and a
#' count of career-record and coach-season entries ESPN has on file.
#' @details Wraps two ESPN core-v2 endpoints and merges them: the
#' season-scoped coach resource
#' `seasons/{year}/coaches/{coach_id}` (supplies the team coached that
#' season) and the league-wide coach resource `coaches/{coach_id}`
#' (supplies the career-record and coach-season counts). Returns a
#' single-row tibble. Enumerate `coach_id`s with [espn_cfb_coaches()].
#' @param coach_id (*Integer* required): ESPN coach id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' Used to resolve the team the coach led that season.
#' @param team_detail (*Logical*): when `TRUE` (default), the ESPN team
#' catalog ([espn_cfb_teams()]) is fetched once and friendly team fields are
#' joined in next to the `team_id` column. The sibling columns `team_name`,
#' `team_abbreviation`, `team_location`, `team_display_name`,
#' `team_short_display_name`, `team_nickname`, `team_color`,
#' `team_alternate_color`, `team_logo_href`, `team_logo_dark_href` are
#' inserted immediately after `team_id`. A catalog failure degrades to `NA`
#' rather than erroring the wrapper. Set `FALSE` to skip the catalog fetch
#' and the join, reproducing the prior output exactly.
#' @return A single-row data frame:
#'
#'    |col_name                |types     |description                                        |
#'    |:-----------------------|:---------|:--------------------------------------------------|
#'    |coach_id                |character |ESPN coach id.                                     |
#'    |season                  |integer   |Season (4-digit year) queried.                     |
#'    |first_name              |character |Coach first name.                                  |
#'    |last_name               |character |Coach last name.                                   |
#'    |uid                     |character |ESPN coach UID string.                             |
#'    |team_id                 |character |ESPN id of the team coached that season (parsed from `team_ref`). |
#'    |team_name               |character |Team nickname; `team_detail = TRUE` only.          |
#'    |team_abbreviation       |character |Team abbreviation; `team_detail = TRUE` only.      |
#'    |team_location           |character |Team location / school name; `team_detail = TRUE` only. |
#'    |team_display_name       |character |Full team display name; `team_detail = TRUE` only. |
#'    |team_short_display_name |character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname           |character |Team nickname label; `team_detail = TRUE` only.    |
#'    |team_color              |character |Primary team color; `team_detail = TRUE` only.     |
#'    |team_alternate_color    |character |Alternate team color; `team_detail = TRUE` only.   |
#'    |team_logo_href          |character |Default team logo URL; `team_detail = TRUE` only.  |
#'    |team_logo_dark_href     |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |n_career_records        |integer   |Number of career-record entries ESPN has on file.  |
#'    |n_coach_seasons         |integer   |Number of coach-season entries ESPN has on file.   |
#'    |team_ref                |character |`$ref` URL to the per-season team resource.        |
#'    |person_ref              |character |`$ref` URL to the league-wide coach (person) resource. |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Coach
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_coach(coach_id = 5120149, year = 2024))
#'   try(espn_cfb_coach(coach_id = 5120149, year = 2024, team_detail = FALSE))
#' }
espn_cfb_coach <- function(coach_id = NULL,
                           year = NULL,
                           team_detail = TRUE) {

  # Validation ----
  if (is.null(coach_id)) {
    cli::cli_abort("{.arg coach_id} is required for the ESPN coach endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN coach endpoint.")
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

  get_json <- function(u) {
    httr::RETRY("GET", u, httr::add_headers(.headers = headers)) %>%
      httr::content(as = "text", encoding = "UTF-8") %>%
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  season_url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/coaches/{coach_id}?lang=en&region=us"
  )
  league_url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/coaches/{coach_id}?lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", season_url, httr::add_headers(.headers = headers))
      check_status(res)

      sc <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      team_ref <- if (is.list(sc[["team"]])) {
        sc[["team"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      person_ref <- if (is.list(sc[["person"]])) {
        sc[["person"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      team_id <- if (!is.na(team_ref)) {
        sub(".*/teams/([0-9]+).*", "\\1", team_ref)
      } else {
        NA_character_
      }

      # League-wide resource for career-record / coach-season counts.
      lc <- tryCatch(get_json(league_url), error = function(e) list())

      df <- data.frame(
        coach_id         = as.character(sc[["id"]] %||% coach_id),
        season           = suppressWarnings(as.integer(year)),
        first_name       = as.character(sc[["firstName"]] %||% NA),
        last_name        = as.character(sc[["lastName"]] %||% NA),
        uid              = as.character(sc[["uid"]] %||% NA),
        team_id          = team_id,
        n_career_records = length(lc[["careerRecords"]] %||% list()),
        n_coach_seasons  = length(lc[["coachSeasons"]] %||% list()),
        team_ref         = team_ref,
        person_ref       = person_ref,
        stringsAsFactors = FALSE
      ) %>%
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column once.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df %>%
        make_cfbfastR_data("Coach detail from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN coach data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Coach Season Record**
#' @description Get a college football coach's win/loss record for a single
#' season -- the headline summary plus every stat category ESPN publishes
#' for that coach-season (wins, losses, ties, overtime wins/losses), in
#' long format.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/coaches/{coach_id}/record`.
#' The `records` block is otherwise only reachable nested inside
#' [espn_cfb_coach()]; this wrapper exposes it tabular. Returns one row per
#' stat category. Each row carries the season-level `summary`/`value`
#' alongside the per-stat fields, so the table is self-describing. Enumerate
#' `coach_id`s with [espn_cfb_coaches()].
#' @param coach_id (*Integer* required): ESPN coach id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param season_type (*Integer* default 2): ESPN season type -- `2` for
#' regular season, `3` for postseason.
#' @return A data frame with one row per stat category:
#'
#'    |col_name           |types     |description                                          |
#'    |:------------------|:---------|:----------------------------------------------------|
#'    |coach_id           |character |ESPN coach id queried.                               |
#'    |season             |integer   |Season (4-digit year) queried.                       |
#'    |season_type        |integer   |ESPN season type queried (`2` regular, `3` post).    |
#'    |record_id          |character |ESPN record id (season-type id, e.g. `2`).           |
#'    |record_name        |character |Record name (e.g. `Regular Season`).                 |
#'    |record_type        |character |Record type (e.g. `Regular Season`).                 |
#'    |record_summary     |character |Season record summary (e.g. `7-6-0`).                |
#'    |record_value       |numeric   |Season win-percentage value (may be `NA`).           |
#'    |stat_name          |character |Stat key (e.g. `wins`, `losses`, `OTWins`).          |
#'    |display_name       |character |Human-readable stat name (e.g. `Wins`).              |
#'    |short_display_name |character |Short stat name (e.g. `W`).                          |
#'    |abbreviation       |character |Stat abbreviation (e.g. `W`).                        |
#'    |stat_type          |character |Internal stat type key (e.g. `wins`).                |
#'    |description        |character |ESPN's description of the stat.                      |
#'    |value              |numeric   |Stat value.                                          |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Coach Record
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_coach_record(coach_id = 5120149, year = 2024))
#' }
espn_cfb_coach_record <- function(coach_id = NULL,
                                  year = NULL,
                                  season_type = 2) {

  # Validation ----
  if (is.null(coach_id)) {
    cli::cli_abort("{.arg coach_id} is required for the ESPN coach record endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN coach record endpoint.")
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

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/types/{season_type}/coaches/",
    "{coach_id}/record?lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      stats <- raw[["stats"]] %||% list()
      if (length(stats) == 0) {
        return(df)
      }

      record_id      <- as.character(raw[["id"]] %||% NA)
      record_name    <- as.character(raw[["name"]] %||% NA)
      record_type    <- as.character(raw[["type"]] %||% NA)
      record_summary <- as.character(raw[["summary"]] %||% NA)
      record_value   <- suppressWarnings(as.numeric(raw[["value"]] %||% NA))

      rows <- list()
      for (s in stats) {
        rows[[length(rows) + 1L]] <- data.frame(
          coach_id           = as.character(coach_id),
          season             = suppressWarnings(as.integer(year)),
          season_type        = suppressWarnings(as.integer(season_type)),
          record_id          = record_id,
          record_name        = record_name,
          record_type        = record_type,
          record_summary     = record_summary,
          record_value       = record_value,
          stat_name          = as.character(s[["name"]] %||% NA),
          display_name       = as.character(s[["displayName"]] %||% NA),
          short_display_name = as.character(s[["shortDisplayName"]] %||% NA),
          abbreviation       = as.character(s[["abbreviation"]] %||% NA),
          stat_type          = as.character(s[["type"]] %||% NA),
          description        = as.character(s[["description"]] %||% NA),
          value              = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
          stringsAsFactors   = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Coach season record from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN coach record data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Coaches Index**
#' @description Get every head coach ESPN tracks for a college football
#' season, with their name, ESPN ids, and the team they coached that year.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/coaches`.
#' The index is `$ref`-paginated (~268 coaches across three pages); this
#' wrapper walks every page and dereferences each coach `$ref`, returning
#' one row per coach. The `coach_id` column is the value
#' [espn_cfb_coach()] accepts for the full per-coach detail (date of birth,
#' birthplace, career-record / coach-season counts).
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), the ESPN team
#' catalog ([espn_cfb_teams()]) is fetched once and friendly team fields are
#' joined in next to the `team_id` column. The sibling columns `team_name`,
#' `team_abbreviation`, `team_location`, `team_display_name`,
#' `team_short_display_name`, `team_nickname`, `team_color`,
#' `team_alternate_color`, `team_logo_href`, `team_logo_dark_href` are
#' inserted immediately after `team_id`. A catalog failure degrades to `NA`
#' rather than erroring the wrapper. Set `FALSE` to skip the catalog fetch
#' and the join, reproducing the prior output exactly.
#' @return A data frame with one row per coach:
#'
#'    |col_name                |types     |description                                          |
#'    |:-----------------------|:---------|:----------------------------------------------------|
#'    |season                  |integer   |Season (4-digit year).                               |
#'    |coach_id                |character |ESPN coach id.                                       |
#'    |first_name              |character |Coach first name.                                    |
#'    |last_name               |character |Coach last name.                                     |
#'    |team_id                 |character |ESPN id of the team coached that season (parsed from `team_ref`). |
#'    |team_name               |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation       |character |Team abbreviation; `team_detail = TRUE` only.        |
#'    |team_location           |character |Team location / school name; `team_detail = TRUE` only. |
#'    |team_display_name       |character |Full team display name; `team_detail = TRUE` only.   |
#'    |team_short_display_name |character |Short team display name; `team_detail = TRUE` only.  |
#'    |team_nickname           |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color              |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color    |character |Alternate team color; `team_detail = TRUE` only.     |
#'    |team_logo_href          |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href     |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |coach_ref               |character |`$ref` URL to the season-scoped coach resource.      |
#'    |person_ref              |character |`$ref` URL to the league-wide coach (person) resource. |
#'    |team_ref                |character |`$ref` URL to the per-season team resource.          |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Coaches
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_coaches(year = 2024))
#'   try(espn_cfb_coaches(year = 2024, team_detail = FALSE))
#' }
espn_cfb_coaches <- function(year = NULL,
                             team_detail = TRUE) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN coaches endpoint.")
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

  get_json <- function(u) {
    httr::RETRY("GET", u, httr::add_headers(.headers = headers)) %>%
      httr::content(as = "text", encoding = "UTF-8") %>%
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  base_url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/coaches?limit=100&lang=en&region=us"
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

      if (page_count > 1L) {
        for (pg in 2:page_count) {
          pg_raw <- get_json(paste0(base_url, "&page=", pg))
          items <- c(items, pg_raw[["items"]] %||% list())
        }
      }

      if (length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        coach_ref <- it[["$ref"]] %||% NA_character_
        c <- get_json(coach_ref)
        team_ref <- if (is.list(c[["team"]])) {
          c[["team"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        person_ref <- if (is.list(c[["person"]])) {
          c[["person"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          NA_character_
        }
        rows[[length(rows) + 1L]] <- data.frame(
          season     = suppressWarnings(as.integer(year)),
          coach_id   = as.character(c[["id"]] %||% NA),
          first_name = as.character(c[["firstName"]] %||% NA),
          last_name  = as.character(c[["lastName"]] %||% NA),
          team_id    = team_id,
          coach_ref  = coach_ref,
          person_ref = person_ref,
          team_ref   = team_ref,
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column once.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df %>%
        make_cfbfastR_data("Coaches index from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN coaches data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Franchise Detail**
#' @description Get the ESPN core-v2 detail record for a single college
#' football franchise -- location, nickname, abbreviation, color, the
#' associated venue and current team, and active status.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/franchises/{franchise_id}`.
#' A franchise is the stable program identity, distinct from `/teams`
#' (which is season-scoped). Returns a single-row tibble. Enumerate
#' `franchise_id`s with [espn_cfb_franchises()].
#' @param franchise_id (*Integer* required): ESPN franchise id.
#' @param team_detail (*Logical*): when `TRUE` (default), the ESPN team
#' catalog ([espn_cfb_teams()]) is fetched once and friendly team fields are
#' joined in next to the `team_id` column. The sibling columns `team_name`,
#' `team_abbreviation`, `team_location`, `team_display_name`,
#' `team_short_display_name`, `team_nickname`, `team_color`,
#' `team_alternate_color`, `team_logo_href`, `team_logo_dark_href` are
#' inserted immediately after `team_id`. A catalog failure degrades to `NA`
#' rather than erroring the wrapper. Set `FALSE` to skip the catalog fetch
#' and the join, reproducing the prior output exactly.
#' @return A single-row data frame:
#'
#'    |col_name                |types     |description                                       |
#'    |:-----------------------|:---------|:-------------------------------------------------|
#'    |franchise_id            |character |ESPN franchise id.                                |
#'    |uid                     |character |ESPN franchise UID string.                        |
#'    |slug                    |character |Franchise slug (e.g. `auburn-tigers`).            |
#'    |location                |character |Franchise location (e.g. `Auburn`).               |
#'    |name                    |character |Franchise name (e.g. `Tigers`).                   |
#'    |nickname                |character |Franchise nickname (e.g. `Auburn`).               |
#'    |abbreviation            |character |Franchise abbreviation (e.g. `AUB`).              |
#'    |display_name            |character |Full display name (e.g. `Auburn Tigers`).         |
#'    |short_display_name      |character |Short display name (e.g. `Auburn`).               |
#'    |color                   |character |Primary team color (hex, no `#`).                 |
#'    |is_active               |logical   |`TRUE` if the franchise is currently active.      |
#'    |venue_id                |character |ESPN id of the franchise's venue (`NA` if none).  |
#'    |venue_name              |character |Full name of the franchise's venue.               |
#'    |team_id                 |character |ESPN id of the current team (parsed from `team_ref`). |
#'    |team_name               |character |Team nickname; `team_detail = TRUE` only.         |
#'    |team_abbreviation       |character |Team abbreviation; `team_detail = TRUE` only.     |
#'    |team_location           |character |Team location / school name; `team_detail = TRUE` only. |
#'    |team_display_name       |character |Full team display name; `team_detail = TRUE` only. |
#'    |team_short_display_name |character |Short team display name; `team_detail = TRUE` only. |
#'    |team_nickname           |character |Team nickname label; `team_detail = TRUE` only.   |
#'    |team_color              |character |Primary team color; `team_detail = TRUE` only.    |
#'    |team_alternate_color    |character |Alternate team color; `team_detail = TRUE` only.  |
#'    |team_logo_href          |character |Default team logo URL; `team_detail = TRUE` only. |
#'    |team_logo_dark_href     |character |Dark-variant team logo URL; `team_detail = TRUE` only. |
#'    |team_ref                |character |`$ref` URL to the current team-in-season resource. |
#'    |franchise_ref           |character |`$ref` URL to the franchise resource.             |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Franchise
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_franchise(franchise_id = 2))
#'   try(espn_cfb_franchise(franchise_id = 2, team_detail = FALSE))
#' }
espn_cfb_franchise <- function(franchise_id = NULL,
                               team_detail = TRUE) {

  # Validation ----
  if (is.null(franchise_id)) {
    cli::cli_abort("{.arg franchise_id} is required for the ESPN franchise endpoint.")
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

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/franchises/{franchise_id}?lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      f <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      venue <- f[["venue"]]
      venue_id   <- if (is.list(venue)) as.character(venue[["id"]] %||% NA) else NA_character_
      venue_name <- if (is.list(venue)) as.character(venue[["fullName"]] %||% NA) else NA_character_

      team_ref <- if (is.list(f[["team"]])) {
        f[["team"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      team_id <- if (!is.na(team_ref)) {
        sub(".*/teams/([0-9]+).*", "\\1", team_ref)
      } else {
        NA_character_
      }

      df <- data.frame(
        franchise_id       = as.character(f[["id"]] %||% franchise_id),
        uid                = as.character(f[["uid"]] %||% NA),
        slug               = as.character(f[["slug"]] %||% NA),
        location           = as.character(f[["location"]] %||% NA),
        name               = as.character(f[["name"]] %||% NA),
        nickname           = as.character(f[["nickname"]] %||% NA),
        abbreviation       = as.character(f[["abbreviation"]] %||% NA),
        display_name       = as.character(f[["displayName"]] %||% NA),
        short_display_name = as.character(f[["shortDisplayName"]] %||% NA),
        color              = as.character(f[["color"]] %||% NA),
        is_active          = isTRUE(f[["isActive"]]),
        venue_id           = venue_id,
        venue_name         = venue_name,
        team_id            = team_id,
        team_ref           = team_ref,
        franchise_ref      = as.character(f[["$ref"]] %||% NA),
        stringsAsFactors   = FALSE
      ) %>%
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column once.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df %>%
        make_cfbfastR_data("Franchise detail from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN franchise data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Franchises Index**
#' @description Get the catalog of college football franchises ESPN tracks
#' -- the stable program identities (~797) that underpin ESPN's team
#' resources.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/franchises`.
#' A franchise is the stable program identity, distinct from `/teams`
#' (which is season-scoped). The index is `$ref`-paginated and large
#' (~797 franchises); dereferencing every franchise would be hundreds of
#' HTTP calls, so this wrapper returns the lightweight index instead --
#' one row per franchise with the `franchise_id` parsed from each `$ref`.
#' Pass an id to [espn_cfb_franchise()] to dereference the full detail
#' record (slug, location, nickname, division, venue, colors, logos).
#' @return A data frame with one row per franchise:
#'
#'    |col_name      |types     |description                                       |
#'    |:-------------|:---------|:-------------------------------------------------|
#'    |franchise_id  |character |ESPN franchise id (parsed from `franchise_ref`).  |
#'    |franchise_ref |character |`$ref` URL to the franchise detail resource.      |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Franchises
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_franchises())
#' }
espn_cfb_franchises <- function() {

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

  base_url <- paste0(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/franchises?limit=100&lang=en&region=us"
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

      if (page_count > 1L) {
        for (pg in 2:page_count) {
          pg_raw <- get_json(paste0(base_url, "&page=", pg))
          items <- c(items, pg_raw[["items"]] %||% list())
        }
      }

      if (length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        franchise_ref <- it[["$ref"]] %||% NA_character_
        franchise_id <- if (!is.na(franchise_ref)) {
          sub(".*/franchises/([0-9]+).*", "\\1", franchise_ref)
        } else {
          NA_character_
        }
        rows[[length(rows) + 1L]] <- data.frame(
          franchise_id  = franchise_id,
          franchise_ref = franchise_ref,
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Franchises index from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN franchises data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Position Detail**
#' @description Get the ESPN core-v2 detail record for a single college
#' football player position -- name, display name, abbreviation, leaf flag,
#' and the parent position id.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/positions/{position_id}`.
#' [espn_cfb_positions()] returns the position index; this wrapper returns
#' the single-position detail for one id. ESPN's position table is a tree --
#' specific positions roll up under broader ones; the `leaf` flag marks the
#' most specific positions and `parent_id` (when present) reconstructs the
#' grouping. Returns a single-row tibble. Enumerate `position_id`s with
#' [espn_cfb_positions()].
#' @param position_id (*Integer* required): ESPN position id.
#' @return A single-row data frame:
#'
#'    |col_name     |types     |description                                       |
#'    |:------------|:---------|:-------------------------------------------------|
#'    |position_id  |character |ESPN position id.                                 |
#'    |name         |character |Position name (e.g. `Quarterback`).               |
#'    |display_name |character |Human-readable position name.                     |
#'    |abbreviation |character |Position abbreviation (e.g. `QB`).                |
#'    |leaf         |logical   |`TRUE` for a most-specific (leaf) position.        |
#'    |parent_id    |character |ESPN id of the parent position (`NA` at the root). |
#'    |position_ref |character |`$ref` URL to the position resource.              |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Position
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_position(position_id = 8))
#' }
espn_cfb_position <- function(position_id = NULL) {

  # Validation ----
  if (is.null(position_id)) {
    cli::cli_abort("{.arg position_id} is required for the ESPN position endpoint.")
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

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/positions/{position_id}?lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      p <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      parent <- p[["parent"]]
      parent_ref <- if (is.list(parent)) parent[["$ref"]] %||% NA_character_ else NA_character_
      parent_id <- if (!is.na(parent_ref)) {
        sub(".*/positions/([0-9]+).*", "\\1", parent_ref)
      } else {
        NA_character_
      }

      df <- data.frame(
        position_id  = as.character(p[["id"]] %||% position_id),
        name         = as.character(p[["name"]] %||% NA),
        display_name = as.character(p[["displayName"]] %||% NA),
        abbreviation = as.character(p[["abbreviation"]] %||% NA),
        leaf         = isTRUE(p[["leaf"]]),
        parent_id    = parent_id,
        position_ref = as.character(p[["$ref"]] %||% NA),
        stringsAsFactors = FALSE
      ) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Position detail from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN position data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Positions Index**
#' @description Get the catalog of player positions ESPN tracks for
#' college football -- the position names, abbreviations, and ids used
#' throughout ESPN's athlete and roster resources.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/positions`.
#' The index returns one `$ref` per position (~74); this wrapper
#' dereferences each and returns one row per position. ESPN's position
#' table is a tree -- specific positions (e.g. left tackle) roll up under
#' broader ones (e.g. offensive line). The `leaf` flag marks the most
#' specific positions; `parent_id` (when present) reconstructs the
#' grouping.
#' @return A data frame with one row per position:
#'
#'    |col_name     |types     |description                                       |
#'    |:------------|:---------|:-------------------------------------------------|
#'    |position_id  |character |ESPN position id.                                 |
#'    |name         |character |Position name (e.g. `Quarterback`).               |
#'    |display_name |character |Human-readable position name.                     |
#'    |abbreviation |character |Position abbreviation (e.g. `QB`).                |
#'    |leaf         |logical   |`TRUE` for a most-specific (leaf) position.        |
#'    |parent_id    |character |ESPN id of the parent position (`NA` at the root). |
#'    |position_ref |character |`$ref` URL to the position resource.              |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Positions
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_positions())
#' }
espn_cfb_positions <- function() {

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

  base_url <- paste0(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/positions?limit=100&lang=en&region=us"
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

      if (page_count > 1L) {
        for (pg in 2:page_count) {
          pg_raw <- get_json(paste0(base_url, "&page=", pg))
          items <- c(items, pg_raw[["items"]] %||% list())
        }
      }

      if (length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        position_ref <- it[["$ref"]] %||% NA_character_
        p <- get_json(position_ref)
        parent <- p[["parent"]]
        parent_ref <- if (is.list(parent)) parent[["$ref"]] %||% NA_character_ else NA_character_
        parent_id <- if (!is.na(parent_ref)) {
          sub(".*/positions/([0-9]+).*", "\\1", parent_ref)
        } else {
          NA_character_
        }
        rows[[length(rows) + 1L]] <- data.frame(
          position_id  = as.character(p[["id"]] %||% NA),
          name         = as.character(p[["name"]] %||% NA),
          display_name = as.character(p[["displayName"]] %||% NA),
          abbreviation = as.character(p[["abbreviation"]] %||% NA),
          leaf         = isTRUE(p[["leaf"]]),
          parent_id    = parent_id,
          position_ref = position_ref,
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Positions index from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN positions data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Venue Detail**
#' @description Get the ESPN core-v2 detail record for a single college
#' football venue -- full name, address, playing-surface and indoor flags.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/venues/{venue_id}`.
#' [espn_cfb_venues()] returns the venue index; this wrapper returns the
#' single-venue detail for one id. Returns a single-row tibble. Enumerate
#' `venue_id`s with [espn_cfb_venues()].
#' @param venue_id (*Integer* required): ESPN venue id.
#' @return A single-row data frame:
#'
#'    |col_name  |types     |description                                       |
#'    |:---------|:---------|:-------------------------------------------------|
#'    |venue_id  |character |ESPN venue id.                                    |
#'    |full_name |character |Venue full name (e.g. `Tenney Stadium`).          |
#'    |city      |character |Venue city.                                       |
#'    |state     |character |Venue state.                                      |
#'    |zip_code  |character |Venue postal code.                                |
#'    |country   |character |Venue country.                                    |
#'    |grass     |logical   |`TRUE` if the playing surface is grass.           |
#'    |indoor    |logical   |`TRUE` if the venue is indoors.                   |
#'    |venue_ref |character |`$ref` URL to the venue resource.                 |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Venue
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_venue(venue_id = 3785))
#' }
espn_cfb_venue <- function(venue_id = NULL) {

  # Validation ----
  if (is.null(venue_id)) {
    cli::cli_abort("{.arg venue_id} is required for the ESPN venue endpoint.")
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

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/venues/{venue_id}?lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      v <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      addr <- v[["address"]]
      if (!is.list(addr)) addr <- list()

      df <- data.frame(
        venue_id  = as.character(v[["id"]] %||% venue_id),
        full_name = as.character(v[["fullName"]] %||% NA),
        city      = as.character(addr[["city"]] %||% NA),
        state     = as.character(addr[["state"]] %||% NA),
        zip_code  = as.character(addr[["zipCode"]] %||% NA),
        country   = as.character(addr[["country"]] %||% NA),
        grass     = isTRUE(v[["grass"]]),
        indoor    = isTRUE(v[["indoor"]]),
        venue_ref = as.character(v[["$ref"]] %||% NA),
        stringsAsFactors = FALSE
      ) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Venue detail from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN venue data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **ESPN College Football Venues Index**
#' @description Get the catalog of stadiums and venues ESPN tracks for
#' college football, with location, capacity-related flags, and addresses.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/venues`.
#' The index is `$ref`-paginated and large (~911 venues). Dereferencing
#' every venue is hundreds of HTTP calls, so this wrapper caps the walk at
#' `max_results` venues (default 200) -- raise it to pull more, or set it
#' high enough to harvest the whole catalog in one (slow) call. Pages are
#' walked in id order, so the same `max_results` always returns the same
#' prefix of the catalog.
#' @param max_results (*Integer* default 200): Maximum number of venues to
#' dereference and return.
#' @return A data frame with one row per venue:
#'
#'    |col_name   |types     |description                                       |
#'    |:----------|:---------|:-------------------------------------------------|
#'    |venue_id   |character |ESPN venue id.                                    |
#'    |full_name  |character |Venue full name (e.g. `Tenney Stadium`).          |
#'    |city       |character |Venue city.                                       |
#'    |state      |character |Venue state.                                      |
#'    |zip_code   |character |Venue postal code.                                |
#'    |country    |character |Venue country.                                    |
#'    |grass      |logical   |`TRUE` if the playing surface is grass.           |
#'    |indoor     |logical   |`TRUE` if the venue is indoors.                   |
#'    |venue_ref  |character |`$ref` URL to the venue resource.                 |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Venues
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_venues(max_results = 50))
#' }
espn_cfb_venues <- function(max_results = 200) {

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

  max_results <- suppressWarnings(as.integer(max_results))
  if (is.na(max_results) || max_results < 1L) max_results <- 200L

  base_url <- paste0(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/venues?limit=100&lang=en&region=us"
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
        venue_ref <- it[["$ref"]] %||% NA_character_
        v <- get_json(venue_ref)
        addr <- v[["address"]]
        if (!is.list(addr)) addr <- list()
        rows[[length(rows) + 1L]] <- data.frame(
          venue_id  = as.character(v[["id"]] %||% NA),
          full_name = as.character(v[["fullName"]] %||% NA),
          city      = as.character(addr[["city"]] %||% NA),
          state     = as.character(addr[["state"]] %||% NA),
          zip_code  = as.character(addr[["zipCode"]] %||% NA),
          country   = as.character(addr[["country"]] %||% NA),
          grass     = isTRUE(v[["grass"]]),
          indoor    = isTRUE(v[["indoor"]]),
          venue_ref = venue_ref,
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Venues index from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN venues data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
