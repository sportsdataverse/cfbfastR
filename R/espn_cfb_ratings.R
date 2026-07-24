# espn_cfb_ratings.R -- ESPN college football ratings + metrics wrappers
# Consolidated family file. Each function keeps its own
# roxygen block; edit the block above the function you want.

#' @title
#' **ESPN College Football Betting Futures (Long Format)**
#' @description Get ESPN's full futures-betting board for a college football
#' season -- national championship, conference, and award markets with the
#' American odds each sportsbook is offering on every team or player.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/futures`.
#' The season index returns one `$ref` per futures market; this wrapper
#' dereferences each market and flattens the nested
#' `market -> provider -> books` tree into long format: one row per
#' (market x provider x entry). Most markets are team markets (national
#' championship, conference winners) and populate `team_id`; player markets
#' (e.g. the Heisman) populate `athlete_id` instead, with the other id
#' column left `NA`. `odds_value` is the raw American-odds string ESPN
#' returns (e.g. `-400`, `+150`).
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*). \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'espn_cfb_futures', 'min_year']`
#' @return A data frame with one row per market-provider-entry:
#'
#'    |col_name       |types     |description                                            |
#'    |:--------------|:---------|:------------------------------------------------------|
#'    |season         |integer   |Season (4-digit year).                                 |
#'    |market_id      |character |ESPN futures-market identifier.                        |
#'    |market_name    |character |Internal market name (e.g. `NCAA(F) - Championship`).  |
#'    |market_type    |character |Market type code (e.g. `winLeague`).                   |
#'    |market_display |character |Human-readable market name (e.g. `National Championship Winner`). |
#'    |provider_id    |character |Sportsbook / provider identifier.                      |
#'    |provider_name  |character |Sportsbook / provider name (e.g. `ESPN BET`).          |
#'    |team_id        |character |ESPN team id (parsed from `team_ref`); `NA` for player markets. |
#'    |athlete_id     |character |ESPN athlete id (parsed from `athlete_ref`); `NA` for team markets. |
#'    |odds_value     |character |American odds for the entry (e.g. `-400`, `+150`).     |
#'    |team_ref       |character |`$ref` URL to the per-season team resource (may be `NA`). |
#'    |athlete_ref    |character |`$ref` URL to the per-season athlete resource (may be `NA`). |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Futures Betting
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_futures(year = 2024))
#' }
espn_cfb_futures <- function(year = NULL) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN futures endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/futures?limit=200&lang=en&region=us"
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

  # Fetch + parse one JSON resource with the shared ESPN headers.
  get_json <- function(u) {
    httr2::request(u) |>
      httr2::req_headers(!!!headers) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
      httr2::req_perform() |>
      httr2::resp_body_string(encoding = "UTF-8") |>
      jsonlite::fromJSON(simplifyVector = FALSE)
  }

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)
      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]]
      if (is.null(items) || length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        # The season index returns one $ref per market -- dereference it.
        # Tolerate an inline market object too, in case the shape changes.
        market <- if (!is.null(it[["$ref"]])) get_json(it[["$ref"]]) else it

        market_id   <- market[["id"]] %||% NA_character_
        market_name <- market[["name"]] %||% NA_character_
        market_type <- market[["type"]] %||% NA_character_
        market_disp <- market[["displayName"]] %||% NA_character_

        for (f in market[["futures"]] %||% list()) {
          prov <- f[["provider"]]
          prov_id <- if (is.list(prov)) {
            prov[["id"]] %||% NA_character_
          } else {
            NA_character_
          }
          prov_name <- if (is.list(prov)) {
            prov[["name"]] %||% NA_character_
          } else {
            NA_character_
          }

          for (b in f[["books"]] %||% list()) {
            team_ref <- if (is.list(b[["team"]])) {
              b[["team"]][["$ref"]] %||% NA_character_
            } else {
              NA_character_
            }
            athlete_ref <- if (is.list(b[["athlete"]])) {
              b[["athlete"]][["$ref"]] %||% NA_character_
            } else {
              NA_character_
            }
            team_id <- if (!is.na(team_ref)) {
              sub(".*/teams/([0-9]+).*", "\\1", team_ref)
            } else {
              NA_character_
            }
            athlete_id <- if (!is.na(athlete_ref)) {
              sub(".*/athletes/([0-9]+).*", "\\1", athlete_ref)
            } else {
              NA_character_
            }

            rows[[length(rows) + 1L]] <- data.frame(
              season         = suppressWarnings(as.integer(year)),
              market_id      = as.character(market_id),
              market_name    = market_name,
              market_type    = market_type,
              market_display = market_disp,
              provider_id    = as.character(prov_id),
              provider_name  = prov_name,
              team_id        = team_id,
              athlete_id     = athlete_id,
              odds_value     = as.character(b[["value"]] %||% NA),
              team_ref       = team_ref,
              athlete_ref    = athlete_ref,
              stringsAsFactors = FALSE
            )
          }
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble() |>
        make_cfbfastR_data("Betting futures data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN futures data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Power Index (Long Format)**
#' @description Get ESPN's College Football Power Index (FPI) ratings for a
#' season, including the full set of predictive metrics and efficiency
#' components ESPN publishes alongside the headline FPI number.
#' @details Wraps the ESPN core-v2 endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/powerindex`.
#' Returns one row per team-metric in long format: each team contributes
#' one row for every predictive metric (FPI, projected wins, strength of
#' record, ...) and every efficiency component (offensive, defensive, and
#' special-teams efficiency, ...). The long shape is deliberate -- ESPN
#' adds and retires metrics across seasons, and a long frame absorbs that
#' drift without breaking column expectations. Pivot wider with
#' [tidyr::pivot_wider()] keyed on `stat_name` when a wide table is wanted.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*). \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'espn_cfb_powerindex', 'min_year']`
#' @return A data frame with one row per team-metric:
#'
#'    |col_name      |types     |description                                        |
#'    |:-------------|:---------|:--------------------------------------------------|
#'    |season        |integer   |Season (4-digit year).                             |
#'    |team_id       |character |ESPN team id (parsed from `team_ref`).             |
#'    |team_ref      |character |`$ref` URL to the team-in-season resource.         |
#'    |metric_group  |character |`predictive` or `efficiency`.                      |
#'    |stat_name     |character |Internal metric key (e.g. `fpi`, `offefficiency`). |
#'    |abbreviation  |character |Metric abbreviation.                               |
#'    |display_name  |character |Human-readable metric name.                        |
#'    |value         |numeric   |Metric value.                                      |
#'    |display_value |character |Display-formatted metric value as shown on ESPN.   |
#'    |description   |character |ESPN's description of the metric.                  |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Power Index FPI
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_powerindex(year = 2024))
#' }
espn_cfb_powerindex <- function(year = NULL) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN power index endpoint.")
  }

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/powerindex?limit=200&lang=en&region=us"
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

  metric_groups <- c(predictives = "predictive", efficiencies = "efficiency")

  df <- data.frame()
  tryCatch(
    expr = {
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)

      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]]
      if (is.null(items) || length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        team_ref <- it[["team"]][["$ref"]] %||% NA_character_
        team_id <- if (!is.na(team_ref)) {
          sub(".*/teams/([0-9]+).*", "\\1", team_ref)
        } else {
          NA_character_
        }
        season <- it[["season"]] %||% year
        for (grp in names(metric_groups)) {
          for (s in it[[grp]]) {
            rows[[length(rows) + 1L]] <- data.frame(
              season           = suppressWarnings(as.integer(season)),
              team_id          = team_id,
              team_ref         = team_ref,
              metric_group     = metric_groups[[grp]],
              stat_name        = s[["name"]] %||% NA_character_,
              abbreviation     = s[["abbreviation"]] %||% NA_character_,
              display_name     = s[["displayName"]] %||% NA_character_,
              value            = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
              display_value    = as.character(s[["displayValue"]] %||% NA),
              description      = s[["description"]] %||% NA_character_,
              stringsAsFactors = FALSE
            )
          }
        }
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble() |>
        make_cfbfastR_data("Power Index data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN power index data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Total Quarterback Rating (QBR)**
#' @description Get ESPN's Total Quarterback Rating (QBR) and its full set
#' of clutch-weighted EPA components for a college football season.
#' @details Wraps the ESPN core-v2 QBR endpoint
#' `seasons/{year}/types/2/groups/{group}/qbr/0`. It returns season-to-date
#' regular-season QBR for every qualified passer in the requested `group`
#' (conference / division). `group = 80` is the all-FBS bucket and is the
#' sensible default; conference group ids (e.g. `4` ACC, `8` Big 12,
#' `12` SEC, `21` Big Ten) also work.
#'
#' Two parameters ESPN's QBR path technically accepts are deliberately
#' **not** exposed, because neither carries data for college football:
#'
#' * The `.../weeks/{week}/qbr/...` path returns the same season aggregate
#'   for every week -- use [espn_cfb_player_stats()] for week-resolved
#'   passing production instead.
#' * The home/away game-location split (`.../qbr/1`, `.../qbr/2`) responds
#'   `200` but is empty for college football; only the total (`.../qbr/0`)
#'   is populated.
#'
#' The result is wide -- one row per quarterback -- with the headline `qbr`
#' column plus the 18 component metrics ESPN derives it from. Players are
#' returned as ESPN athlete ids only (`athlete_id`) unless name resolution
#' is requested.
#'
#' When `athlete_detail = TRUE` the human-readable name columns
#' `athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
#' `athlete_jersey`, `athlete_position`, and `athlete_position_abbreviation`
#' are appended. There is no bulk athlete-name catalog, so resolving names
#' here costs **one HTTP call per quarterback** -- roughly 130 extra
#' requests for an all-FBS pull. It therefore defaults to `FALSE`. A
#' per-athlete fetch failure leaves that quarterback's name columns `NA`
#' rather than erroring the wrapper. To resolve names without these extra
#' calls, join `athlete_id` to another athlete source (e.g.
#' [cfbd_team_roster()]).
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*). \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'espn_cfb_qbr', 'min_year']`
#' @param group (*Integer* default 80): ESPN group id. `80` = all FBS.
#' Conference group ids (e.g. `4` ACC, `8` Big 12, `12` SEC, `21` Big Ten)
#' also work.
#' @param athlete_detail (*Logical*): when `TRUE`, dereference each
#' quarterback and append the `athlete_*` name columns (see *Details*).
#' This costs one HTTP call per quarterback, so it defaults to `FALSE`;
#' setting it `FALSE` reproduces the prior output exactly.
#' @return A data frame with one row per quarterback:
#'
#'    |col_name               |types     |description                                          |
#'    |:----------------------|:---------|:----------------------------------------------------|
#'    |season                 |integer   |Season (4-digit year).                               |
#'    |season_type            |integer   |ESPN season type (2 = regular season).               |
#'    |group_id               |character |ESPN group id queried (`80` = all FBS).              |
#'    |athlete_id             |character |ESPN athlete id (parsed from `athlete_ref`).         |
#'    |team_id                |character |ESPN team id (parsed from `team_ref`).               |
#'    |qbpaa                  |numeric   |QB Points Added Above Average.                       |
#'    |cwepa_passes_condensed |numeric   |Clutch-weighted EPA from passes (condensed).         |
#'    |cwepa_rushes           |numeric   |Clutch-weighted EPA from designed rushes.            |
#'    |cwepa_sacked_condensed |numeric   |Clutch-weighted EPA lost to sacks (condensed).       |
#'    |cwepa_penalties        |numeric   |Clutch-weighted EPA from penalties.                  |
#'    |cwepa_total            |numeric   |Total clutch-weighted EPA.                           |
#'    |action_plays           |numeric   |Action plays charged to the quarterback.             |
#'    |cw_average             |numeric   |Clutch-weighted average win value per play.          |
#'    |qbr                    |numeric   |Total Quarterback Rating (0-100).                    |
#'    |cwepa_passes           |numeric   |Clutch-weighted EPA from pass attempts.              |
#'    |cwepa_interceptions    |numeric   |Clutch-weighted EPA lost to interceptions.           |
#'    |cwepa_yards_after_carry|numeric   |Clutch-weighted EPA from yards after carry.          |
#'    |cwepa_runs             |numeric   |Clutch-weighted EPA from runs.                       |
#'    |cwepa_scrambles        |numeric   |Clutch-weighted EPA from scrambles.                  |
#'    |cwepa_sacked           |numeric   |Clutch-weighted EPA lost to sacks.                   |
#'    |cwepa_fumbles          |numeric   |Clutch-weighted EPA lost to fumbles.                 |
#'    |avg_opp_dqbr           |numeric   |Average opponent defensive QBR faced.                |
#'    |sched_adj_qbr          |numeric   |Schedule-adjusted QBR.                               |
#'    |unqualified_rank       |numeric   |QBR rank including unqualified passers.              |
#'    |athlete_ref            |character |`$ref` URL to the athlete-in-season resource.        |
#'    |team_ref               |character |`$ref` URL to the team-in-season resource.           |
#'    |athlete_display_name   |character |Player display name; `athlete_detail = TRUE` only.   |
#'    |athlete_first_name     |character |Player first name; `athlete_detail = TRUE` only.     |
#'    |athlete_last_name      |character |Player last name; `athlete_detail = TRUE` only.      |
#'    |athlete_jersey         |character |Player jersey number; `athlete_detail = TRUE` only.  |
#'    |athlete_position       |character |Player position name; `athlete_detail = TRUE` only.  |
#'    |athlete_position_abbreviation|character |Player position abbreviation; `athlete_detail = TRUE` only. |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_perform resp_body_string
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB QBR
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_qbr(year = 2024))
#'   try(espn_cfb_qbr(year = 2024, athlete_detail = TRUE))
#' }
espn_cfb_qbr <- function(year = NULL,
                         group = 80,
                         athlete_detail = FALSE) {

  # Validation ----
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN QBR endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/types/2/groups/{group}/qbr/0",
    "?limit=200&lang=en&region=us"
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
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)

      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      items <- raw[["items"]]
      if (is.null(items) || length(items) == 0) {
        return(df)
      }

      rows <- list()
      for (it in items) {
        athlete_ref <- it[["athlete"]][["$ref"]] %||% NA_character_
        team_ref    <- it[["team"]][["$ref"]] %||% NA_character_
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

        # splits is a single named object {id, name, abbreviation, categories}
        stat_vals <- list()
        for (cat in it[["splits"]][["categories"]] %||% list()) {
          for (s in cat[["stats"]] %||% list()) {
            nm <- s[["name"]]
            if (is.null(nm)) next
            stat_vals[[nm]] <- suppressWarnings(
              as.numeric(s[["value"]] %||% NA)
            )
          }
        }

        meta_head <- list(
          season      = suppressWarnings(as.integer(year)),
          season_type = 2L,
          group_id    = as.character(group),
          athlete_id  = athlete_id,
          team_id     = team_id
        )
        meta_tail <- list(athlete_ref = athlete_ref, team_ref = team_ref)

        rows[[length(rows) + 1L]] <- as.data.frame(
          c(meta_head, stat_vals, meta_tail),
          stringsAsFactors = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) |>
        janitor::clean_names() |>
        dplyr::as_tibble()

      # Optional name resolution -- one HTTP call per quarterback, so off
      # by default. Each distinct athlete is dereferenced once.
      if (isTRUE(athlete_detail)) {
        df <- .espn_cfb_attach_athlete_detail_multi(df, year = year)
      }

      df <- df |>
        make_cfbfastR_data("QBR data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN QBR data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN FPI Ratings**
#' @description Get FPI historical rating data (most recent of each year)
#' @details Adapted from sabinanalytic's fork of the cfbfastR repo
#' @param year Year \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'espn_ratings_fpi', 'min_year']`
#' @return A data frame with 20 variables:
#'
#' * `year`: integer. Season of the Football Power Index (FPI) Rating.
#' * `team_id`: integer. Unique ESPN team ID - `team_id`.
#' * `team_name`: character. Team Name.
#' * `team_abbreviation`: character. Team abbreviation.
#' * `fpi`: character. Football Power Index (FPI) Rating.
#' * `fpi_rk`: character. Football Power Index (FPI) Rank.
#' * `trend`: character. Football Power Index (FPI) ranking trend.
#' * `projected_wins`: character. Projected Win total for the season.
#' * `projected_losses`: character. Projected Loss total for the season.
#' * `win_out_pct`: double. Probability the team wins out.
#' * `win_6_pct`: double. Probability the team wins at least six games.
#' * `win_division_pct`: double. Probability the team wins at their division.
#' * `playoff_pct`: double. Probability the team reaches the playoff.
#' * `nc_game_pct`: double. Probability the team reaches the national championship game.
#' * `nc_win_pct`: double. Probability the team wins the national championship game.
#' * `win_conference_pct`: double. Probability the team wins their conference game.
#' * `w`: integer. Wins on the season.
#' * `l`: integer. Losses on the season.
#' * `t`: character. Ties on the season.
#'
#' @keywords Ratings FPI
#' @importFrom stringr str_remove
#' @importFrom tidyr unnest_wider
#' @importFrom dplyr as_tibble between select mutate mutate_at row_number everything
#' @importFrom jsonlite fromJSON
#' @importFrom utils data
#' @importFrom utils URLencode
#' @importFrom utils globalVariables
#' @importFrom purrr pluck set_names quietly map
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#'   try(espn_ratings_fpi(year=2019))
#' }
espn_ratings_fpi <- function(year = 2019) {
  current_year <- as.double(substr(Sys.Date(), 1, 4))

  # Small error handling to guide the limits on years
  if (!dplyr::between(as.numeric(year), 2004, current_year)) {
    stop(paste("Please choose year between 2004 and", current_year))
  }


  # Base URL
  fpi_full_url <- "https://site.web.api.espn.com/apis/fitt/v3/sports/football/college-football/powerindex?region=us&lang=en"

  url <- glue::glue("{fpi_full_url}&season={year}&sort=fpi.fpi%3Adesc")

  headers <- c(
    `authority` = 'site.web.api.espn.com',
    `User-Agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36',
    `Accept` = 'application/json, text/plain, */*',
    `Accept-Language` = 'en-US,en;q=0.9',
    `sec-fetch-site` = 'same-site',
    `sec-fetch-mode` = 'cors',
    `sec-fetch-dest` = 'empty',
    `Origin` = "https://www.espn.com",
    `Referer` = 'https://www.espn.com/',
    `Pragma` = 'no-cache',
    `Cache-Control` = 'no-cache'
  )

  df <- data.frame()
  tryCatch(
    expr = {

      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()

      # Check the result
      check_status(res)

      resp <- res |>
        httr2::resp_body_string(encoding = "UTF-8")
      raw_json_fpi <- jsonlite::fromJSON(resp)

      ## get team fpi stats
      get_fpi_data <- function(row_n) {
        purrr::pluck(raw_json_fpi, "teams", "categories", row_n, "totals", 1)
      }
      purrr::pluck(raw_json_fpi, "categories", "labels", 1)

      # tidyr::unnest_wider() name repair is noisy
      # Let's make it quiet with purrr::quietly()
      quiet_unnest_wider <- purrr::quietly(tidyr::unnest_wider)

      df <- purrr::pluck(raw_json_fpi, "teams", "team") |>
        dplyr::as_tibble() |>
        dplyr::select(
          "id",
          "nickname",
          "abbreviation",
          "logos",
          "links") |>
        dplyr::mutate(row_n = dplyr::row_number()) |>
        dplyr::mutate(data = purrr::map(.data$row_n, get_fpi_data))

      df <- df |>
        tidyr::unnest_wider("data", names_sep = "_") |>
        purrr::set_names(nm = c(
          "team_id", "team_name", "team_abbreviation", "logos", "links", "row_n",
          "fpi", "fpi_rk", "trend", "projected_wins", "projected_losses", "win_out_pct",
          "win_6_pct", "win_division_pct", "playoff_pct", "nc_game_pct", "nc_win_pct",
          "win_conference_pct", "w", "l", "t"
        )) |>
        dplyr::select(-c("logos", "links")) |>
        dplyr::mutate(
          year = year,
          t = ifelse(is.na(t), 0, t)) |>
        dplyr::mutate_at(vars("win_out_pct":"win_conference_pct"), ~ as.double(stringr::str_remove(., "%")) / 100) |>
        dplyr::select("year", dplyr::everything()) |>
        dplyr::select(-"row_n") |>
        dplyr::mutate(dplyr::across(dplyr::any_of(c(
          "year",
          "team_id",
          "w",
          "l"
        )), ~as.integer(.x))) |>
        as.data.frame()

      df <- df |>
        make_cfbfastR_data("FPI rating data from ESPN",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN FPI data available!"))
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' **ESPN Metrics**
#' @name espn_metrics
NULL
#' Get win probability chart data from ESPN
#' Graciously contributed by MrCaseB:
#' @rdname espn_metrics
#'
#' @param game_id (*Integer* required): Game ID filter for querying a single game
#' Can be found using the [cfbd_game_info()] function
#'
#' @return [espn_metrics_wp()] - A data frame with 5 variables:
#'
#' * `game_id`: character. Referencing game ID (should be same as `game_id` from other functions).
#' * `play_id`: character. Referencing play ID.
#' * `seconds_left`: integer. DEPRECATED. Seconds left in the game.
#' * `home_win_percentage`: double. The probability of the home team winning the game.
#' * `away_win_percentage`: double. The probability of the away team winning the game (calculated as 1 - `home_win_percentage` - `tie_percentage`).
#' * `tie_percentage`: double. The probability of the game ending the final period in a tie.
#'
#' @keywords Win Probability Chart Data
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_perform resp_body_string
#' @importFrom utils URLencode URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom stringr str_sub str_length
#' @import dplyr
#' @export
#' @examples
#' \donttest{
#'   try(espn_metrics_wp(game_id = 401628369))
#' }
#'
espn_metrics_wp <- function(game_id) {

  validate_id(game_id)

  espn_game_id <- game_id

  espn_wp <- data.frame()

  tryCatch(
    expr = {
      espn_data <-
        httr2::request(glue::glue("http://site.api.espn.com/apis/site/v2/sports/football/college-football/summary?event={espn_game_id}")) |>
        httr2::req_perform() |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      # to-do: Grab play data and back into seconds left

      espn_wp <-
        espn_data |>
        purrr::pluck("winprobability") |>
        janitor::clean_names() |>
        dplyr::mutate(
          espn_game_id = stringr::str_sub(.data$play_id, end = stringr::str_length(espn_game_id)),
          seconds_left = NA
        ) |>
        dplyr::rename(
          "home_win_percentage" = "home_win_percentage",
          "seconds_left" = "seconds_left",
          "play_id" = "play_id",
          "game_id" = "espn_game_id"
        ) |>
        dplyr::mutate(
          away_win_percentage = 1 - .data$home_win_percentage - .data$tie_percentage
        ) |>
        dplyr::select(
          "game_id",
          "play_id",
          "seconds_left",
          "home_win_percentage",
          "away_win_percentage",
          "tie_percentage"
        )

      espn_wp <- espn_wp |>
        make_cfbfastR_data("Win probability chart data from ESPN",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: game_id '{espn_game_id}' invalid or no ESPN win probability data available!"))
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(espn_wp))
}
