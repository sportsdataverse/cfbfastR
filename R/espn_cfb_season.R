# espn_cfb_season.R -- ESPN college football season + structure wrappers
# Consolidated family file. Each function keeps its own
# roxygen block; edit the block above the function you want.

#' @title
#' **ESPN College Football Groups & Conferences**
#' @description Get the full ESPN group hierarchy for a college football
#' season -- the division roll-ups (Division I, FBS, FCS) and every
#' conference nested beneath them, flattened into one catalog table.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/groups`.
#' ESPN's group index only exposes two top-level groups; the conferences
#' sit several levels deep under `children`. This wrapper walks the tree
#' recursively, dereferencing every node, and returns one row per group.
#' Filter `is_conference == TRUE` for the actual conferences (ACC, SEC,
#' Big Ten, ...); the `group_id` of a conference is what
#' [espn_cfb_standings()] accepts as `group_id`. The `parent_group_id`
#' column lets you reconstruct the division -> conference nesting.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param season_type (*Integer* default 2): ESPN season type id.
#' `2` = regular season is the sensible default.
#' @return A data frame with one row per group:
#'
#'    |col_name        |types     |description                                       |
#'    |:---------------|:---------|:-------------------------------------------------|
#'    |season          |integer   |Season (4-digit year).                            |
#'    |season_type     |integer   |ESPN season type id queried.                      |
#'    |group_id        |character |ESPN group id.                                    |
#'    |name            |character |Group / conference name.                          |
#'    |abbreviation    |character |Group abbreviation.                               |
#'    |short_name      |character |Group short name.                                 |
#'    |is_conference   |logical   |`TRUE` for an actual conference, `FALSE` for a division roll-up. |
#'    |parent_group_id |character |`group_id` of the parent node (`NA` at the root). |
#'    |slug            |character |Group slug.                                       |
#'    |group_ref       |character |`$ref` URL to the group resource.                 |
#'    |standings_ref   |character |`$ref` URL to the group standings resource.       |
#'    |teams_ref       |character |`$ref` URL to the group teams index.              |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Groups Conferences
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_groups(year = 2024))
#' }
espn_cfb_groups <- function(year = NULL,
                            season_type = 2) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN groups endpoint.")
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

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/types/{season_type}/groups",
    "?limit=200&lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]] %||% list()
      if (length(items) == 0) {
        return(df)
      }

      rows <- list()

      # Recursively dereference a group node and its children.
      walk_group <- function(group_ref, parent_id) {
        g <- get_json(group_ref)
        gid <- as.character(g[["id"]] %||% NA)
        ref_of <- function(k) {
          v <- g[[k]]
          if (is.list(v)) v[["$ref"]] %||% NA_character_ else NA_character_
        }
        rows[[length(rows) + 1L]] <<- data.frame(
          season          = suppressWarnings(as.integer(year)),
          season_type     = suppressWarnings(as.integer(season_type)),
          group_id        = gid,
          name            = as.character(g[["name"]] %||% NA),
          abbreviation    = as.character(g[["abbreviation"]] %||% NA),
          short_name      = as.character(g[["shortName"]] %||% NA),
          is_conference   = isTRUE(g[["isConference"]]),
          parent_group_id = parent_id,
          slug            = as.character(g[["slug"]] %||% NA),
          group_ref       = group_ref,
          standings_ref   = ref_of("standings"),
          teams_ref       = ref_of("teams"),
          stringsAsFactors = FALSE
        )
        # Recurse into children.
        ch <- g[["children"]]
        ch_ref <- if (is.list(ch)) ch[["$ref"]] %||% NA_character_ else NA_character_
        if (!is.na(ch_ref)) {
          ch_idx <- get_json(ch_ref)
          for (c_it in ch_idx[["items"]] %||% list()) {
            c_ref <- c_it[["$ref"]] %||% NA_character_
            if (!is.na(c_ref)) walk_group(c_ref, gid)
          }
        }
      }

      for (it in items) {
        g_ref <- it[["$ref"]] %||% NA_character_
        if (!is.na(g_ref)) walk_group(g_ref, NA_character_)
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Groups and conferences from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN groups data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Ranking Sources**
#' @description Get the index of poll / ranking sources ESPN publishes for
#' a college football season -- the AP Top 25, the Coaches Poll, the CFP
#' committee rankings, and the computer-derived polls.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/rankings`.
#' The index returns one `$ref` per ranking source (~6-7); this wrapper
#' dereferences each and returns one row per source, with a count of how
#' many weekly snapshots that source published in the season. To pull the
#' actual ranked teams for a given week, feed `season`, `season_type`, and
#' a `week` to [espn_cfb_week_rankings()].
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @return A data frame with one row per ranking source:
#'
#'    |col_name    |types     |description                                          |
#'    |:-----------|:---------|:----------------------------------------------------|
#'    |season      |integer   |Season (4-digit year).                               |
#'    |ranking_id  |character |ESPN ranking source id.                              |
#'    |name        |character |Ranking source name (e.g. `AP Top 25`).              |
#'    |short_name  |character |Ranking source short name (e.g. `AP Poll`).          |
#'    |type        |character |Ranking source type code (e.g. `ap`, `cfp`).         |
#'    |n_snapshots |integer   |Number of weekly snapshots published by the source.  |
#'    |ranking_ref |character |`$ref` URL to the ranking source resource.           |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Rankings
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_rankings(year = 2024))
#' }
espn_cfb_rankings <- function(year = NULL) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN rankings endpoint.")
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

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/rankings?limit=100&lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]] %||% list()
      if (length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        ranking_ref <- it[["$ref"]] %||% NA_character_
        r <- get_json(ranking_ref)
        rows[[length(rows) + 1L]] <- data.frame(
          season      = suppressWarnings(as.integer(year)),
          ranking_id  = as.character(r[["id"]] %||% NA),
          name        = as.character(r[["name"]] %||% NA),
          short_name  = as.character(r[["shortName"]] %||% NA),
          type        = as.character(r[["type"]] %||% NA),
          n_snapshots = length(r[["rankings"]] %||% list()),
          ranking_ref = ranking_ref,
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Ranking sources from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN rankings data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Season Detail**
#' @description Get the ESPN core-v2 detail record for a single college
#' football season -- start / end dates, the active season type, and the
#' `$ref` links to that season's types, rankings, athletes, awards, and
#' futures sub-resources.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}`.
#' Returns a single-row tibble. The `*_ref` columns are the season-scoped
#' sub-resource entry points -- feed `types_ref` to [espn_cfb_season_types()],
#' `rankings_ref` to [espn_cfb_rankings()], and so on. `active_type_*`
#' describes the season type ESPN currently considers "live" for the year
#' (preseason / regular / postseason / off-season).
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @return A single-row data frame:
#'
#'    |col_name          |types     |description                                       |
#'    |:-----------------|:---------|:-------------------------------------------------|
#'    |season            |integer   |Season (4-digit year).                            |
#'    |display_name      |character |ESPN display name for the season.                 |
#'    |start_date        |character |Season start timestamp (ISO 8601, UTC).           |
#'    |end_date          |character |Season end timestamp (ISO 8601, UTC).             |
#'    |active_type_id    |integer   |ESPN id of the currently active season type.      |
#'    |active_type       |integer   |Active season type code (1 pre, 2 reg, 3 post).   |
#'    |active_type_name  |character |Active season type name (e.g. `Regular Season`).  |
#'    |types_ref         |character |`$ref` URL to the season types index.             |
#'    |rankings_ref      |character |`$ref` URL to the season rankings index.          |
#'    |athletes_ref      |character |`$ref` URL to the season athletes index.          |
#'    |awards_ref        |character |`$ref` URL to the season awards index.            |
#'    |futures_ref       |character |`$ref` URL to the season betting-futures index.   |
#'    |leaders_ref       |character |`$ref` URL to the season leaders resource.        |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Season Info
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_season_info(year = 2024))
#' }
espn_cfb_season_info <- function(year = NULL) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN season info endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}?lang=en&region=us"
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

      ref_of <- function(k) {
        v <- raw[[k]]
        if (is.list(v)) v[["$ref"]] %||% NA_character_ else NA_character_
      }

      active <- raw[["type"]]
      if (!is.list(active)) active <- list()

      df <- data.frame(
        season           = suppressWarnings(as.integer(raw[["year"]] %||% year)),
        display_name     = as.character(raw[["displayName"]] %||% NA),
        start_date       = as.character(raw[["startDate"]] %||% NA),
        end_date         = as.character(raw[["endDate"]] %||% NA),
        active_type_id   = suppressWarnings(as.integer(active[["id"]] %||% NA)),
        active_type      = suppressWarnings(as.integer(active[["type"]] %||% NA)),
        active_type_name = as.character(active[["name"]] %||% NA),
        types_ref        = ref_of("types"),
        rankings_ref     = ref_of("rankings"),
        athletes_ref     = ref_of("athletes"),
        awards_ref       = ref_of("awards"),
        futures_ref      = ref_of("futures"),
        leaders_ref      = ref_of("leaders"),
        stringsAsFactors = FALSE
      ) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Season detail from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN season info data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Season Types**
#' @description Get the set of season types (preseason, regular season,
#' postseason, off-season) ESPN tracks for a college football season,
#' including each type's date window and capability flags.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types`.
#' The index returns one `$ref` per season type; this wrapper dereferences
#' each and returns one row per type (typically four: `1` preseason,
#' `2` regular season, `3` postseason, `4` off-season). The `season_type`
#' ids returned here are the values other Batch 5 wrappers
#' ([espn_cfb_season_weeks()], [espn_cfb_groups()], [espn_cfb_standings()],
#' [espn_cfb_week_rankings()]) accept as their `season_type` argument.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @return A data frame with one row per season type:
#'
#'    |col_name      |types     |description                                          |
#'    |:-------------|:---------|:----------------------------------------------------|
#'    |season        |integer   |Season (4-digit year).                               |
#'    |season_type   |integer   |ESPN season type id (1 pre, 2 reg, 3 post, 4 off).   |
#'    |type          |integer   |Season type code (mirrors `season_type`).            |
#'    |name          |character |Season type name (e.g. `Regular Season`).            |
#'    |abbreviation  |character |Season type abbreviation (e.g. `reg`).               |
#'    |slug          |character |Season type slug (e.g. `regular-season`).            |
#'    |start_date    |character |Season type start timestamp (ISO 8601, UTC).         |
#'    |end_date      |character |Season type end timestamp (ISO 8601, UTC).           |
#'    |has_groups    |logical   |Whether the season type exposes a groups resource.   |
#'    |has_standings |logical   |Whether the season type exposes standings.           |
#'    |type_ref      |character |`$ref` URL to the season type resource.              |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Season Types
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_season_types(year = 2024))
#' }
espn_cfb_season_types <- function(year = NULL) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN season types endpoint.")
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

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/types?lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]] %||% list()
      if (length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        type_ref <- it[["$ref"]] %||% NA_character_
        s <- get_json(type_ref)
        rows[[length(rows) + 1L]] <- data.frame(
          season        = suppressWarnings(as.integer(s[["year"]] %||% year)),
          season_type   = suppressWarnings(as.integer(s[["id"]] %||% NA)),
          type          = suppressWarnings(as.integer(s[["type"]] %||% NA)),
          name          = as.character(s[["name"]] %||% NA),
          abbreviation  = as.character(s[["abbreviation"]] %||% NA),
          slug          = as.character(s[["slug"]] %||% NA),
          start_date    = as.character(s[["startDate"]] %||% NA),
          end_date      = as.character(s[["endDate"]] %||% NA),
          has_groups    = isTRUE(s[["hasGroups"]]),
          has_standings = isTRUE(s[["hasStandings"]]),
          type_ref      = type_ref,
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Season types from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN season types data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Season Weeks**
#' @description Get the calendar of weeks ESPN tracks for a college football
#' season type -- each week's number, label, and start / end dates.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/weeks`.
#' The index returns one `$ref` per week; this wrapper dereferences each and
#' returns one row per week (~15-16 for a regular season). The `week`
#' numbers returned here are the values [espn_cfb_week_rankings()] accepts.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param season_type (*Integer* default 2): ESPN season type id.
#' `2` = regular season (the only type with a meaningful week calendar),
#' `3` = postseason, `1` = preseason.
#' @return A data frame with one row per week:
#'
#'    |col_name    |types     |description                                       |
#'    |:-----------|:---------|:-------------------------------------------------|
#'    |season      |integer   |Season (4-digit year).                            |
#'    |season_type |integer   |ESPN season type id queried.                      |
#'    |week        |integer   |Week number.                                      |
#'    |text        |character |Week label (e.g. `Week 1`, `Bowls`).             |
#'    |start_date  |character |Week start timestamp (ISO 8601, UTC).             |
#'    |end_date    |character |Week end timestamp (ISO 8601, UTC).               |
#'    |week_ref    |character |`$ref` URL to the week resource.                  |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Season Weeks
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_season_weeks(year = 2024))
#' }
espn_cfb_season_weeks <- function(year = NULL,
                                  season_type = 2) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN season weeks endpoint.")
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

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/types/{season_type}/weeks",
    "?limit=100&lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]] %||% list()
      if (length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        week_ref <- it[["$ref"]] %||% NA_character_
        w <- get_json(week_ref)
        rows[[length(rows) + 1L]] <- data.frame(
          season      = suppressWarnings(as.integer(year)),
          season_type = suppressWarnings(as.integer(season_type)),
          week        = suppressWarnings(as.integer(w[["number"]] %||% NA)),
          text        = as.character(w[["text"]] %||% NA),
          start_date  = as.character(w[["startDate"]] %||% NA),
          end_date    = as.character(w[["endDate"]] %||% NA),
          week_ref    = week_ref,
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Season weeks from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN season weeks data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Seasons Index**
#' @description Get the index of every college football season ESPN tracks
#' in its core-v2 API, with each season's start and end dates.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons`.
#' The index is `$ref`-paginated; this wrapper walks every page, dereferences
#' each season `$ref`, and returns one row per season. ESPN's CFB season
#' coverage runs back to the early 1900s, so the table is long -- filter on
#' `season` for the years you need. Use [espn_cfb_season_info()] for the
#' full per-season detail (season types, rankings, awards, futures refs).
#' @return A data frame with one row per season:
#'
#'    |col_name     |types     |description                                     |
#'    |:------------|:---------|:-----------------------------------------------|
#'    |season       |integer   |Season (4-digit year).                          |
#'    |display_name |character |ESPN display name for the season.               |
#'    |start_date   |character |Season start timestamp (ISO 8601, UTC).         |
#'    |end_date     |character |Season end timestamp (ISO 8601, UTC).           |
#'    |season_ref   |character |`$ref` URL to the season resource.              |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Seasons
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_seasons())
#' }
espn_cfb_seasons <- function() {

  headers <- c(
    `User-Agent` = paste0(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ",
      "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
    ),
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  # Fetch + parse one JSON resource with the shared ESPN headers.
  get_json <- function(u) {
    httr::RETRY("GET", u, httr::add_headers(.headers = headers)) %>%
      httr::content(as = "text", encoding = "UTF-8") %>%
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  base_url <- paste0(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons?limit=100&lang=en&region=us"
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

      # Walk remaining pages.
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
        season_ref <- it[["$ref"]] %||% NA_character_
        s <- get_json(season_ref)
        rows[[length(rows) + 1L]] <- data.frame(
          season       = suppressWarnings(as.integer(s[["year"]] %||% NA)),
          display_name = as.character(s[["displayName"]] %||% NA),
          start_date   = as.character(s[["startDate"]] %||% NA),
          end_date     = as.character(s[["endDate"]] %||% NA),
          season_ref   = season_ref,
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble() %>%
        make_cfbfastR_data("Seasons index from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN seasons data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Standings (Long Format)**
#' @description Get ESPN's standings for a college football group -- the
#' full set of record splits (overall, home, away, conference, ...) and
#' every standings statistic (wins, losses, point differential,
#' streak, ...) for every team in the group.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/groups/{group_id}/standings`.
#' The standings resource nests three levels deep -- team -> record split
#' -> statistic -- so this wrapper returns long format: one row per
#' (team x record split x statistic). The long shape absorbs ESPN's habit
#' of adding standings stats across seasons. Pivot wider keyed on
#' `stat_name` (within a `record_type`) when a wide table is wanted.
#'
#' `group_id = 90` (NCAA Division I) is the sensible default and yields
#' every D-I team in one call. Conference-level `group_id`s -- enumerate
#' them with [espn_cfb_groups()] -- restrict the table to that conference.
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`, inserted immediately after
#' `team_id`.
#' A catalog failure degrades to `NA` rather than erroring the wrapper. Set
#' `team_detail = FALSE` to skip the catalog fetch and the join.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param group_id (*Integer* default 90): ESPN group id. `90` = NCAA
#' Division I (all D-I teams). Conference group ids also work.
#' @param season_type (*Integer* default 2): ESPN season type id.
#' `2` = regular season.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per team-record-statistic:
#'
#'    |col_name               |types     |description                                          |
#'    |:----------------------|:---------|:----------------------------------------------------|
#'    |season                 |integer   |Season (4-digit year).                               |
#'    |season_type            |integer   |ESPN season type id queried.                         |
#'    |group_id               |character |ESPN group id queried.                               |
#'    |team_id                |character |ESPN team id (parsed from `team_ref`).               |
#'    |team_name              |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation      |character |Team abbreviation; `team_detail = TRUE` only.        |
#'    |team_location          |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name      |character |Full team display name; `team_detail = TRUE` only.   |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.  |
#'    |team_nickname          |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color             |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color   |character |Alternate team color; `team_detail = TRUE` only.     |
#'    |team_logo_href         |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href    |character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |record_type            |character |Record split type code (e.g. `total`, `homerecord`). |
#'    |record_name            |character |Record split name (e.g. `Overall`, `Home`).          |
#'    |record_summary         |character |Record split summary (e.g. `14-0`).                  |
#'    |stat_name              |character |Standings statistic key (e.g. `wins`, `streak`).     |
#'    |abbreviation           |character |Statistic abbreviation.                              |
#'    |display_name           |character |Human-readable statistic name.                       |
#'    |value                  |numeric   |Statistic value.                                     |
#'    |display_value          |character |Display-formatted statistic value.                   |
#'    |team_ref               |character |`$ref` URL to the per-season team resource.          |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Standings
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_standings(year = 2024))
#'   try(espn_cfb_standings(year = 2024, team_detail = FALSE))
#' }
espn_cfb_standings <- function(year = NULL,
                               group_id = 90,
                               season_type = 2,
                               team_detail = TRUE) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN standings endpoint.")
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

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/types/{season_type}/groups/",
    "{group_id}/standings?lang=en&region=us"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]] %||% list()
      if (length(items) == 0) {
        return(df)
      }

      # The first standings item is the "overall" table.
      first <- items[[1]]
      overall <- if (!is.null(first[["$ref"]])) {
        get_json(first[["$ref"]])
      } else {
        first
      }

      entries <- overall[["standings"]] %||% list()
      if (length(entries) == 0) {
        return(df)
      }

      rows <- list()
      for (en in entries) {
        team_ref <- if (is.list(en[["team"]])) {
          en[["team"]][["$ref"]] %||% NA_character_
        } else {
          NA_character_
        }
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          NA_character_
        }
        for (rec in en[["records"]] %||% list()) {
          rec_type    <- as.character(rec[["type"]] %||% NA)
          rec_name    <- as.character(rec[["name"]] %||% NA)
          rec_summary <- as.character(rec[["summary"]] %||% NA)
          for (s in rec[["stats"]] %||% list()) {
            rows[[length(rows) + 1L]] <- data.frame(
              season         = suppressWarnings(as.integer(year)),
              season_type    = suppressWarnings(as.integer(season_type)),
              group_id       = as.character(group_id),
              team_id        = team_id,
              record_type    = rec_type,
              record_name    = rec_name,
              record_summary = rec_summary,
              stat_name      = as.character(s[["name"]] %||% NA),
              abbreviation   = as.character(s[["abbreviation"]] %||% NA),
              display_name   = as.character(s[["displayName"]] %||% NA),
              value          = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
              display_value  = as.character(s[["displayValue"]] %||% NA),
              team_ref       = team_ref,
              stringsAsFactors = FALSE
            )
          }
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column once, before
      # the make_cfbfastR_data() class/attribute stamp.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df %>%
        make_cfbfastR_data("Standings data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN standings data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Weekly Rankings**
#' @description Get the ranked teams from every poll ESPN published in a
#' single week of a college football season -- the AP Top 25, the Coaches
#' Poll, the CFP committee rankings, and the computer polls, with each
#' team's rank, points, and first-place votes.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/weeks/{week}/rankings`.
#' The week index returns one `$ref` per poll; this wrapper dereferences
#' each poll and returns one row per (poll x ranked team). Both the
#' top-25 ranked teams (`rank_type = "ranked"`) and the receiving-votes
#' teams ESPN lists below the cutoff (`rank_type = "others"`) are included.
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' in next to the `team_id` column -- `team_name`, `team_abbreviation`,
#' `team_location`, `team_display_name`, `team_short_display_name`,
#' `team_nickname`, `team_color`, `team_alternate_color`,
#' `team_logo_href`, and `team_logo_dark_href`, inserted immediately after
#' `team_id`.
#' A catalog failure degrades to `NA` rather than erroring the wrapper. Set
#' `team_detail = FALSE` to skip the catalog fetch and the join; teams are
#' then returned as ESPN team ids only.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param week (*Integer* required): Week number within the season type.
#' @param season_type (*Integer* default 2): ESPN season type id.
#' `2` = regular season, `3` = postseason.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per poll-team:
#'
#'    |col_name               |types     |description                                       |
#'    |:----------------------|:---------|:-------------------------------------------------|
#'    |season                 |integer   |Season (4-digit year).                            |
#'    |season_type            |integer   |ESPN season type id queried.                      |
#'    |week                   |integer   |Week number queried.                              |
#'    |ranking_id             |character |ESPN poll id.                                     |
#'    |ranking_name           |character |Poll name (e.g. `AP Top 25`).                     |
#'    |ranking_type           |character |Poll type code (e.g. `ap`, `coaches`, `cfp`).     |
#'    |occurrence             |character |Poll occurrence label (e.g. `Week 8`, `Preseason`). |
#'    |rank_type              |character |`ranked` for ranked teams, `others` for receiving-votes teams. |
#'    |current_rank           |integer   |Current rank (`0` for receiving-votes teams).     |
#'    |previous_rank          |integer   |Rank in the previous poll (`0` if unranked).      |
#'    |points                 |numeric   |Poll points awarded to the team.                  |
#'    |first_place_votes      |integer   |Number of first-place votes received.             |
#'    |trend                  |character |Movement vs the previous poll (e.g. `-`, `+3`).   |
#'    |record_summary         |character |Team record at the time of the poll (e.g. `7-1`). |
#'    |team_id                |character |ESPN team id (parsed from `team_ref`).            |
#'    |team_name              |character |Team nickname; `team_detail = TRUE` only.         |
#'    |team_abbreviation      |character |Team abbreviation; `team_detail = TRUE` only.     |
#'    |team_location          |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name      |character |Full team display name; `team_detail = TRUE` only.|
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname          |character |Team nickname label; `team_detail = TRUE` only.   |
#'    |team_color             |character |Primary team color; `team_detail = TRUE` only.    |
#'    |team_alternate_color   |character |Alternate team color; `team_detail = TRUE` only.  |
#'    |team_logo_href         |character |Default team logo URL; `team_detail = TRUE` only. |
#'    |team_logo_dark_href    |character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |team_ref               |character |`$ref` URL to the per-season team resource.       |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr RETRY add_headers content
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Week Rankings
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_week_rankings(year = 2024, week = 8))
#'   try(espn_cfb_week_rankings(year = 2024, week = 8, team_detail = FALSE))
#' }
espn_cfb_week_rankings <- function(year = NULL,
                                   week = NULL,
                                   season_type = 2,
                                   team_detail = TRUE) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN week rankings endpoint.")
  }
  if (is.null(week)) {
    cli::cli_abort("{.arg week} is required for the ESPN week rankings endpoint.")
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

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/types/{season_type}/weeks/",
    "{week}/rankings?lang=en&region=us"
  )

  # Pull one poll's ranks[] / others[] arrays into rows.
  poll_rows <- function(poll) {
    ranking_id   <- as.character(poll[["id"]] %||% NA)
    ranking_name <- as.character(poll[["name"]] %||% NA)
    ranking_type <- as.character(poll[["type"]] %||% NA)
    occ <- poll[["occurrence"]]
    occurrence <- if (is.list(occ)) {
      as.character(occ[["displayValue"]] %||% NA)
    } else {
      NA_character_
    }

    one_entry <- function(en, rank_type) {
      team_ref <- if (is.list(en[["team"]])) {
        en[["team"]][["$ref"]] %||% NA_character_
      } else {
        NA_character_
      }
      team_id <- if (!is.na(team_ref)) {
        sub(".*/teams/([0-9]+).*", "\\1", team_ref)
      } else {
        NA_character_
      }
      rec <- en[["record"]]
      rec_summary <- if (is.list(rec)) {
        as.character(rec[["summary"]] %||% NA)
      } else {
        NA_character_
      }
      data.frame(
        season            = suppressWarnings(as.integer(year)),
        season_type       = suppressWarnings(as.integer(season_type)),
        week              = suppressWarnings(as.integer(week)),
        ranking_id        = ranking_id,
        ranking_name      = ranking_name,
        ranking_type      = ranking_type,
        occurrence        = occurrence,
        rank_type         = rank_type,
        current_rank      = suppressWarnings(as.integer(en[["current"]] %||% NA)),
        previous_rank     = suppressWarnings(as.integer(en[["previous"]] %||% NA)),
        points            = suppressWarnings(as.numeric(en[["points"]] %||% NA)),
        first_place_votes = suppressWarnings(as.integer(en[["firstPlaceVotes"]] %||% NA)),
        trend             = as.character(en[["trend"]] %||% NA),
        record_summary    = rec_summary,
        team_id           = team_id,
        team_ref          = team_ref,
        stringsAsFactors  = FALSE
      )
    }

    out <- list()
    for (en in poll[["ranks"]] %||% list()) {
      out[[length(out) + 1L]] <- one_entry(en, "ranked")
    }
    for (en in poll[["others"]] %||% list()) {
      out[[length(out) + 1L]] <- one_entry(en, "others")
    }
    out
  }

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr::RETRY("GET", url, httr::add_headers(.headers = headers))
      check_status(res)

      raw <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]] %||% list()
      if (length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        poll <- if (!is.null(it[["$ref"]])) get_json(it[["$ref"]]) else it
        rows <- c(rows, poll_rows(poll))
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) %>%
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column once, before
      # the make_cfbfastR_data() class/attribute stamp.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df %>%
        make_cfbfastR_data("Weekly rankings from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN week rankings data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}
