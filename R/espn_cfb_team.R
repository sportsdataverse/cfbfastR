# espn_cfb_team.R -- ESPN college football team wrappers
# Consolidated family file. Each function keeps its own
# roxygen block; edit the block above the function you want.

#' @name espn_cfb_team
#' @aliases espn_cfb_team team team_roster team_schedule
#' @title
#' **ESPN College Football Team Endpoint Overview**
#' @description
#'
#' * `espn_cfb_team()`: Get ESPN's detailed record for a single college
#'   football team in a given season -- identifiers, branding, conference
#'   grouping, and home venue.
#' * `espn_cfb_teams()`: Get the full ESPN directory of college football
#'   teams -- one row per team with identifiers, branding, conference
#'   grouping, and logo URLs.
#' * `espn_cfb_team_ats()`: Get a college football team's
#'   against-the-spread (ATS) records for a season -- the 6-7 betting
#'   split rows ESPN tracks (overall, as favorite, as underdog, home,
#'   away, ...).
#' * `espn_cfb_team_awards()`: Get the awards won by a college football
#'   team's players in a season -- one row per (award x winning athlete).
#' * `espn_cfb_team_coaches()`: Get the coaches associated with a college
#'   football team for a season -- one row per coach, with name, birth
#'   detail, and experience.
#' * `espn_cfb_team_events()`: Get a college football team's full season
#'   event log -- every game (regular season and postseason) ESPN lists
#'   for the team-season.
#' * `espn_cfb_team_leaders()`: Get a college football team's season
#'   statistical leaders -- the top athletes in each ESPN leader category
#'   (passing, rushing, receiving, tackles, ...).
#' * `espn_cfb_team_powerindex()`: Get ESPN's College Football Power
#'   Index (FPI) detail for a single team-season -- the full set of
#'   predictive metrics and efficiency components ESPN attaches to one
#'   team.
#' * `espn_cfb_team_ranks()`: Get a college football team's poll-rank
#'   history for a season -- one row per poll (AP, Coaches, CFP
#'   Committee, ...) the team appeared in.
#' * `espn_cfb_team_record()`: Get a college football team's season
#'   records -- overall, home, away, and conference splits -- with the
#'   full set of summary stats ESPN attaches to each.
#' * `espn_cfb_team_roster()`: Get the season roster for a single college
#'   football team -- one row per athlete with biographical detail,
#'   position, jersey number, and class/experience.
#' * `espn_cfb_team_schedule()`: Get a single college football team's
#'   full-season schedule -- one row per game with opponent, venue,
#'   broadcast, score, and result.
#' * `espn_cfb_team_stats()`: Get ESPN college football team season
#'   statistics -- a wide tibble of team identifiers and per-category
#'   statistical totals.
#'
#' @details
#' ## **ESPN College Football Team Detail (Season-Scoped)**
#'
#' ```r
#' espn_cfb_team(team_id = 61, year = 2024)
#' ```
#'
#' ## **ESPN College Football Teams Index**
#'
#' ```r
#' espn_cfb_teams()
#' ```
#'
#' ## **ESPN College Football Team Against-the-Spread Records**
#'
#' ```r
#' espn_cfb_team_ats(team_id = 61, year = 2024)
#' ```
#'
#' ## **ESPN College Football Team Awards**
#'
#' ```r
#' espn_cfb_team_awards(team_id = 61, year = 2023)
#' ```
#'
#' ## **ESPN College Football Team Coaches**
#'
#' ```r
#' espn_cfb_team_coaches(team_id = 61, year = 2024)
#' ```
#'
#' ## **ESPN College Football Team Season Event Log**
#'
#' ```r
#' espn_cfb_team_events(team_id = 61, year = 2024)
#' ```
#'
#' ## **ESPN College Football Team Statistical Leaders**
#'
#' ```r
#' espn_cfb_team_leaders(team_id = 61, year = 2024)
#' ```
#'
#' ## **ESPN College Football Single-Team Power Index (Long Format)**
#'
#' ```r
#' espn_cfb_team_powerindex(team_id = 61, year = 2024)
#' ```
#'
#' ## **ESPN College Football Team Poll Rank History**
#'
#' ```r
#' espn_cfb_team_ranks(team_id = 61, year = 2024)
#' ```
#'
#' ## **ESPN College Football Team Record (Long Format)**
#'
#' ```r
#' espn_cfb_team_record(team_id = 61, year = 2024)
#' ```
#'
#' ## **ESPN College Football Team Roster (Season-Scoped)**
#'
#' ```r
#' espn_cfb_team_roster(team_id = 61, year = 2024)
#' ```
#'
#' ## **ESPN College Football Team Schedule**
#'
#' ```r
#' espn_cfb_team_schedule(team_id = 61, year = 2024)
#' ```
#'
#' ## **Get ESPN college football team stats data**
#'
#' ```r
#' espn_cfb_team_stats(team_id = 52, year = 2020)
#' ```
#'
NULL

#' @title
#' **ESPN College Football Team Detail (Season-Scoped)**
#' @description Get ESPN's detailed record for a single college football team
#' in a given season -- identifiers, branding, conference grouping, and home
#' venue.
#' @details Wraps the ESPN core-v2 team-in-season endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}`.
#' Unlike the site-v2 team payload, the core-v2 resource is season-scoped, so
#' a team's conference grouping is resolved for the requested `year`. The
#' result is a single-row data frame. Team ids are ESPN team identifiers --
#' enumerate them with [espn_cfb_teams()].
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
#' @param team_id (*Integer* required): ESPN team id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A one-row data frame:
#'
#'    |col_name           |types     |description                                          |
#'    |:------------------|:---------|:----------------------------------------------------|
#'    |season             |integer   |Season (4-digit year).                               |
#'    |team_id            |character |ESPN team id.                                        |
#'    |team_name          |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation  |character |Team abbreviation; `team_detail = TRUE` only.        |
#'    |team_location      |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name  |character |Full team display name; `team_detail = TRUE` only.   |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname      |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color         |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.    |
#'    |team_logo_href     |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |guid               |character |ESPN team GUID.                                      |
#'    |uid                |character |ESPN global unique identifier.                       |
#'    |slug               |character |URL slug for the team.                               |
#'    |abbreviation       |character |Team abbreviation.                                   |
#'    |display_name       |character |Full team display name.                              |
#'    |short_display_name |character |Short team display name.                             |
#'    |name               |character |Team nickname (e.g. `Bulldogs`).                     |
#'    |nickname           |character |Team nickname / location label.                      |
#'    |location           |character |Team location / school name.                         |
#'    |color              |character |Primary team color (hex, no `#`).                    |
#'    |alternate_color    |character |Alternate team color (hex, no `#`).                  |
#'    |is_active          |logical   |Whether the team is currently active.                |
#'    |is_all_star        |logical   |Whether the team is an all-star team.                |
#'    |group_id           |character |ESPN group (conference) id for the season.           |
#'    |venue_id           |character |ESPN id of the team's home venue.                    |
#'    |venue_name         |character |Name of the team's home venue.                       |
#'    |venue_city         |character |Home venue city.                                     |
#'    |venue_state        |character |Home venue state.                                    |
#'    |venue_indoor       |logical   |Whether the home venue is indoors.                   |
#'    |venue_grass        |logical   |Whether the home venue has a grass surface.          |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Team
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_team(team_id = 61, year = 2024))
#'   try(espn_cfb_team(team_id = 61, year = 2024, team_detail = FALSE))
#' }
espn_cfb_team <- function(team_id = NULL,
                          year = NULL,
                          team_detail = TRUE) {

  # Validation ----
  if (is.null(team_id)) {
    cli::cli_abort("{.arg team_id} is required for the ESPN team endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN team endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/teams/{team_id}?lang=en&region=us"
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

      tm <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      if (is.null(tm) || is.null(tm[["id"]])) {
        return(df)
      }

      group_ref <- tm[["groups"]][["$ref"]] %||% NA_character_
      group_id <- if (!is.na(group_ref)) {
        sub(".*/groups/([0-9]+).*", "\\1", group_ref)
      } else {
        NA_character_
      }
      venue <- tm[["venue"]] %||% list()

      df <- data.frame(
        season             = suppressWarnings(as.integer(year)),
        team_id            = as.character(tm[["id"]]),
        guid               = tm[["guid"]] %||% NA_character_,
        uid                = tm[["uid"]] %||% NA_character_,
        slug               = tm[["slug"]] %||% NA_character_,
        abbreviation       = tm[["abbreviation"]] %||% NA_character_,
        display_name       = tm[["displayName"]] %||% NA_character_,
        short_display_name = tm[["shortDisplayName"]] %||% NA_character_,
        name               = tm[["name"]] %||% NA_character_,
        nickname           = tm[["nickname"]] %||% NA_character_,
        location           = tm[["location"]] %||% NA_character_,
        color              = tm[["color"]] %||% NA_character_,
        alternate_color    = tm[["alternateColor"]] %||% NA_character_,
        is_active          = tm[["isActive"]] %||% NA,
        is_all_star        = tm[["isAllStar"]] %||% NA,
        group_id           = group_id,
        venue_id           = as.character(venue[["id"]] %||% NA),
        venue_name         = venue[["fullName"]] %||% NA_character_,
        venue_city         = venue[["address"]][["city"]] %||% NA_character_,
        venue_state        = venue[["address"]][["state"]] %||% NA_character_,
        venue_indoor       = venue[["indoor"]] %||% NA,
        venue_grass        = venue[["grass"]] %||% NA,
        stringsAsFactors   = FALSE
      ) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df |>
        make_cfbfastR_data("Team detail from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN team data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Team Against-the-Spread Records**
#' @description Get a college football team's against-the-spread (ATS) records
#' for a season -- the 6-7 betting split rows ESPN tracks (overall, as
#' favorite, as underdog, home, away, ...).
#' @details Wraps the ESPN core-v2 team ATS endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/teams/{team_id}/ats`.
#' ESPN returns one item per ATS split, each carrying a `wins`/`losses`/
#' `pushes` triple and a `type` block (id, name, description). This wrapper
#' returns one row per split. The ATS records are populated only for
#' completed games, so an in-progress or future season may return an empty
#' frame.
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
#' @param team_id (*Integer* required): ESPN team id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param season_type (*Integer* default 2): ESPN season type. `2` = regular
#' season, `3` = postseason.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per ATS split:
#'
#'    |col_name        |types     |description                                          |
#'    |:---------------|:---------|:----------------------------------------------------|
#'    |season          |integer   |Season (4-digit year).                               |
#'    |season_type     |integer   |ESPN season type (2 = regular, 3 = postseason).      |
#'    |team_id         |character |ESPN team id.                                        |
#'    |team_name       |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.       |
#'    |team_location   |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name|character |Full team display name; `team_detail = TRUE` only. |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname   |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color      |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.  |
#'    |team_logo_href  |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |ats_type_id     |character |ATS split type id (e.g. `0`, `1`, `2`).              |
#'    |ats_type_name   |character |ATS split type key (e.g. `atsOverall`, `atsFavorite`).|
#'    |ats_description |character |ESPN's description of the ATS split.                 |
#'    |wins            |integer   |Wins against the spread in the split.                |
#'    |losses          |integer   |Losses against the spread in the split.              |
#'    |pushes          |integer   |Pushes (no cover, no loss) in the split.             |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Team ATS
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_team_ats(team_id = 61, year = 2024))
#'   try(espn_cfb_team_ats(team_id = 61, year = 2024, team_detail = FALSE))
#' }
espn_cfb_team_ats <- function(team_id = NULL,
                              year = NULL,
                              season_type = 2,
                              team_detail = TRUE) {

  # Validation ----
  if (is.null(team_id)) {
    cli::cli_abort("{.arg team_id} is required for the ESPN team ATS endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN team ATS endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/types/{season_type}/teams/{team_id}/ats",
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
        type_block <- it[["type"]] %||% list()
        rows[[length(rows) + 1L]] <- data.frame(
          season          = suppressWarnings(as.integer(year)),
          season_type     = suppressWarnings(as.integer(season_type)),
          team_id         = as.character(team_id),
          ats_type_id     = as.character(type_block[["id"]] %||% NA),
          ats_type_name   = type_block[["name"]] %||% NA_character_,
          ats_description = type_block[["description"]] %||% NA_character_,
          wins            = suppressWarnings(as.integer(it[["wins"]] %||% NA)),
          losses          = suppressWarnings(as.integer(it[["losses"]] %||% NA)),
          pushes          = suppressWarnings(as.integer(it[["pushes"]] %||% NA)),
          stringsAsFactors = FALSE
        )
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df |>
        make_cfbfastR_data("Team against-the-spread records from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN team ATS data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Team Awards**
#' @description Get the awards won by a college football team's players in a
#' season -- one row per (award x winning athlete).
#' @details Wraps the ESPN core-v2 team awards endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}/awards`.
#' The index endpoint returns a `$ref` list of award resources; this wrapper
#' dereferences each one and returns a row per winning athlete for the
#' award. Athletes are returned as ESPN athlete ids (parsed from
#' `athlete_ref`); join to another athlete source for names. Most teams have
#' only one or two award items in a season.
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' onto every team-id column the output carries -- `team_id` and
#' `winner_team_id`. For each id column `X_id` the friendly siblings
#' `X_name`, `X_abbreviation`, `X_location`, `X_display_name`,
#' `X_short_display_name`, `X_nickname`, `X_color`, `X_alternate_color`,
#' `X_logo_href`, and `X_logo_dark_href` are inserted immediately after it.
#' A catalog failure degrades to `NA` rather than erroring the wrapper. Set
#' `team_detail = FALSE` to skip the catalog fetch and the join.
#' @param team_id (*Integer* required): ESPN team id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to every team-id
#' column (`team_id`, `winner_team_id`) in the output (see *Details*). Set
#' `FALSE` to skip the catalog fetch and the join.
#' @return A data frame with one row per award-winner:
#'
#'    |col_name          |types     |description                                          |
#'    |:-----------------|:---------|:----------------------------------------------------|
#'    |season            |integer   |Season (4-digit year).                               |
#'    |team_id           |character |ESPN team id.                                        |
#'    |team_name         |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation |character |Team abbreviation; `team_detail = TRUE` only.        |
#'    |team_location     |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name |character |Full team display name; `team_detail = TRUE` only.   |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname     |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color        |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.    |
#'    |team_logo_href    |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |award_id          |character |ESPN award id.                                       |
#'    |award_name        |character |Award display name (e.g. `John Mackey Award`).       |
#'    |award_description |character |Short description of the award.                      |
#'    |athlete_id        |character |ESPN athlete id of the winner (parsed from `athlete_ref`).|
#'    |winner_team_id    |character |ESPN team id credited with the win (parsed from `winner_team_ref`).|
#'    |winner_team_name  |character |Winner team nickname; `team_detail = TRUE` only.     |
#'    |winner_team_abbreviation|character |Winner team abbreviation; `team_detail = TRUE` only.|
#'    |winner_team_location|character |Winner team location / school; `team_detail = TRUE` only.|
#'    |winner_team_display_name|character |Winner team full display name; `team_detail = TRUE` only.|
#'    |winner_team_short_display_name|character |Winner team short display name; `team_detail = TRUE` only.|
#'    |winner_team_nickname|character |Winner team nickname label; `team_detail = TRUE` only.|
#'    |winner_team_color |character |Winner team primary color; `team_detail = TRUE` only.|
#'    |winner_team_alternate_color|character |Winner team alternate color; `team_detail = TRUE` only.|
#'    |winner_team_logo_href|character |Winner team default logo URL; `team_detail = TRUE` only.|
#'    |winner_team_logo_dark_href|character |Winner team dark logo URL; `team_detail = TRUE` only.|
#'    |award_ref         |character |`$ref` URL to the core-v2 award resource.            |
#'    |athlete_ref       |character |`$ref` URL to the winning athlete-in-season resource.|
#'    |winner_team_ref   |character |`$ref` URL to the winner's team-in-season resource.  |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Team Awards
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_team_awards(team_id = 61, year = 2023))
#'   try(espn_cfb_team_awards(team_id = 61, year = 2023,
#'                            team_detail = FALSE))
#' }
espn_cfb_team_awards <- function(team_id = NULL,
                                 year = NULL,
                                 team_detail = TRUE) {

  # Validation ----
  if (is.null(team_id)) {
    cli::cli_abort("{.arg team_id} is required for the ESPN team awards endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN team awards endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/teams/{team_id}/awards",
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
        award_ref <- it[["$ref"]] %||% NA_character_
        if (is.na(award_ref)) next

        aw_res <- httr2::request(award_ref) |>
          httr2::req_headers(!!!headers) |>
          httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
          httr2::req_error(is_error = function(resp) FALSE) |>
          httr2::req_perform()
        if (httr2::resp_status(aw_res) != 200) next
        aw <- aw_res |>
          httr2::resp_body_string(encoding = "UTF-8") |>
          jsonlite::fromJSON(simplifyVector = FALSE)

        award_id   <- as.character(aw[["id"]] %||% NA)
        award_name <- aw[["name"]] %||% NA_character_
        award_desc <- aw[["description"]] %||% NA_character_
        winners    <- aw[["winners"]] %||% list()

        if (length(winners) == 0) {
          rows[[length(rows) + 1L]] <- data.frame(
            season            = suppressWarnings(as.integer(year)),
            team_id           = as.character(team_id),
            award_id          = award_id,
            award_name        = award_name,
            award_description = award_desc,
            athlete_id        = NA_character_,
            winner_team_id    = NA_character_,
            award_ref         = award_ref,
            athlete_ref       = NA_character_,
            winner_team_ref   = NA_character_,
            stringsAsFactors  = FALSE
          )
          next
        }

        for (wn in winners) {
          athlete_ref <- wn[["athlete"]][["$ref"]] %||% NA_character_
          wteam_ref   <- wn[["team"]][["$ref"]] %||% NA_character_
          athlete_id <- if (!is.na(athlete_ref)) {
            sub(".*/athletes/([0-9]+).*", "\\1", athlete_ref)
          } else {
            NA_character_
          }
          wteam_id <- if (!is.na(wteam_ref)) {
            sub(".*/teams/([0-9]+).*", "\\1", wteam_ref)
          } else {
            NA_character_
          }
          rows[[length(rows) + 1L]] <- data.frame(
            season            = suppressWarnings(as.integer(year)),
            team_id           = as.character(team_id),
            award_id          = award_id,
            award_name        = award_name,
            award_description = award_desc,
            athlete_id        = athlete_id,
            winner_team_id    = wteam_id,
            award_ref         = award_ref,
            athlete_ref       = athlete_ref,
            winner_team_ref   = wteam_ref,
            stringsAsFactors  = FALSE
          )
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto every team-id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df |>
        make_cfbfastR_data("Team awards from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN team awards data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Team Coaches**
#' @description Get the coaches associated with a college football team for a
#' season -- one row per coach, with name, birth detail, and experience.
#' @details Wraps the ESPN core-v2 team coaches endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}/coaches`.
#' The index endpoint returns a `$ref` list of coach resources; this wrapper
#' dereferences each one and returns a row per coach with the coach detail
#' flattened. Most teams list a single head coach per season.
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
#' @param team_id (*Integer* required): ESPN team id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per coach:
#'
#'    |col_name        |types     |description                                          |
#'    |:---------------|:---------|:----------------------------------------------------|
#'    |season          |integer   |Season (4-digit year).                               |
#'    |team_id         |character |ESPN team id.                                        |
#'    |team_name       |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.       |
#'    |team_location   |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name|character |Full team display name; `team_detail = TRUE` only. |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname   |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color      |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.  |
#'    |team_logo_href  |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |coach_id        |character |ESPN coach id.                                       |
#'    |first_name      |character |Coach's first name.                                  |
#'    |last_name       |character |Coach's last name.                                   |
#'    |date_of_birth   |character |Coach's date of birth.                               |
#'    |birth_city      |character |City of birth.                                       |
#'    |birth_state     |character |State of birth.                                      |
#'    |birth_country   |character |Country of birth.                                    |
#'    |experience      |integer   |Years of experience ESPN credits the coach.          |
#'    |coach_ref       |character |`$ref` URL to the core-v2 coach-in-season resource.  |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Team Coaches
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_team_coaches(team_id = 61, year = 2024))
#'   try(espn_cfb_team_coaches(team_id = 61, year = 2024,
#'                             team_detail = FALSE))
#' }
espn_cfb_team_coaches <- function(team_id = NULL,
                                  year = NULL,
                                  team_detail = TRUE) {

  # Validation ----
  if (is.null(team_id)) {
    cli::cli_abort("{.arg team_id} is required for the ESPN team coaches endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN team coaches endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/teams/{team_id}/coaches",
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
        coach_ref <- it[["$ref"]] %||% NA_character_
        if (is.na(coach_ref)) next

        co_res <- httr2::request(coach_ref) |>
          httr2::req_headers(!!!headers) |>
          httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
          httr2::req_error(is_error = function(resp) FALSE) |>
          httr2::req_perform()
        if (httr2::resp_status(co_res) != 200) next
        co <- co_res |>
          httr2::resp_body_string(encoding = "UTF-8") |>
          jsonlite::fromJSON(simplifyVector = FALSE)

        birth <- co[["birthPlace"]] %||% list()
        rows[[length(rows) + 1L]] <- data.frame(
          season        = suppressWarnings(as.integer(year)),
          team_id       = as.character(team_id),
          coach_id      = as.character(co[["id"]] %||% NA),
          first_name    = co[["firstName"]] %||% NA_character_,
          last_name     = co[["lastName"]] %||% NA_character_,
          date_of_birth = as.character(co[["dateOfBirth"]] %||% NA),
          birth_city    = birth[["city"]] %||% NA_character_,
          birth_state   = birth[["state"]] %||% NA_character_,
          birth_country = birth[["country"]] %||% NA_character_,
          experience    = suppressWarnings(
            as.integer(co[["experience"]] %||% NA)
          ),
          coach_ref     = coach_ref,
          stringsAsFactors = FALSE
        )
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df |>
        make_cfbfastR_data("Team coaches from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN team coaches data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Team Season Event Log**
#' @description Get a college football team's full season event log -- every
#' game (regular season and postseason) ESPN lists for the team-season.
#' @details Wraps the ESPN core-v2 team events endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}/events`.
#' ESPN returns a `$ref` list -- one reference per game -- in core-v2's id
#' space, complementing the site-v2 [espn_cfb_team_schedule()]. This wrapper
#' returns one row per game with `game_id` parsed from each `$ref`; it does
#' **not** dereference each game (feed the `game_id` values to
#' [espn_cfb_game_teams()], [espn_cfb_game_pbp()], or the other
#' `espn_cfb_game_*()` wrappers for hydrated game detail). The
#' `event_order` column preserves the order ESPN returns the games.
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
#' @param team_id (*Integer* required): ESPN team id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per game:
#'
#'    |col_name    |types     |description                                          |
#'    |:-----------|:---------|:----------------------------------------------------|
#'    |season      |integer   |Season (4-digit year).                               |
#'    |team_id     |character |ESPN team id.                                        |
#'    |team_name   |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.   |
#'    |team_location|character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name|character |Full team display name; `team_detail = TRUE` only.|
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname|character |Team nickname label; `team_detail = TRUE` only.     |
#'    |team_color  |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.|
#'    |team_logo_href|character |Default team logo URL; `team_detail = TRUE` only.  |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |event_order |integer   |Order of the game within the team's season event log.|
#'    |game_id     |character |ESPN game (event) id, parsed from `event_ref`.       |
#'    |event_ref   |character |`$ref` URL to the core-v2 event resource.            |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Team Events
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_team_events(team_id = 61, year = 2024))
#'   try(espn_cfb_team_events(team_id = 61, year = 2024,
#'                            team_detail = FALSE))
#' }
espn_cfb_team_events <- function(team_id = NULL,
                                 year = NULL,
                                 team_detail = TRUE) {

  # Validation ----
  if (is.null(team_id)) {
    cli::cli_abort("{.arg team_id} is required for the ESPN team events endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN team events endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/teams/{team_id}/events",
    "?limit=100&lang=en&region=us"
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
      for (i in seq_along(items)) {
        event_ref <- items[[i]][["$ref"]] %||% NA_character_
        game_id <- if (!is.na(event_ref)) {
          sub(".*/events/([0-9]+).*", "\\1", event_ref)
        } else {
          NA_character_
        }
        rows[[length(rows) + 1L]] <- data.frame(
          season      = suppressWarnings(as.integer(year)),
          team_id     = as.character(team_id),
          event_order = i,
          game_id     = game_id,
          event_ref   = event_ref,
          stringsAsFactors = FALSE
        )
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df |>
        make_cfbfastR_data("Team season event log from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN team events data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Team Statistical Leaders**
#' @description Get a college football team's season statistical leaders --
#' the top athletes in each ESPN leader category (passing, rushing,
#' receiving, tackles, ...).
#' @details Wraps the ESPN core-v2 team leaders endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/teams/{team_id}/leaders`.
#' ESPN groups leaders into categories and ranks several athletes within
#' each. This wrapper flattens that to long format: one row per
#' (category x ranked athlete), with `leader_rank` preserving the order
#' ESPN returns. Athletes are returned as ESPN athlete ids; join to
#' [espn_cfb_team_roster()] for names.
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
#' @param team_id (*Integer* required): ESPN team id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param season_type (*Integer* default 2): ESPN season type. `2` = regular
#' season, `3` = postseason.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per category-leader:
#'
#'    |col_name           |types     |description                                          |
#'    |:------------------|:---------|:----------------------------------------------------|
#'    |season             |integer   |Season (4-digit year).                               |
#'    |season_type        |integer   |ESPN season type (2 = regular, 3 = postseason).      |
#'    |team_id            |character |ESPN team id.                                        |
#'    |team_name          |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation  |character |Team abbreviation; `team_detail = TRUE` only.        |
#'    |team_location      |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name  |character |Full team display name; `team_detail = TRUE` only.   |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname      |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color         |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.    |
#'    |team_logo_href     |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |category_name      |character |Leader category key (e.g. `passingLeader`).          |
#'    |category_display   |character |Leader category display name.                        |
#'    |leader_rank        |integer   |Rank of the athlete within the category (1 = top).   |
#'    |athlete_id         |character |ESPN athlete id (parsed from `athlete_ref`).         |
#'    |value              |numeric   |Leading stat value.                                  |
#'    |display_value      |character |Display-formatted stat line.                         |
#'    |athlete_ref        |character |`$ref` URL to the athlete-in-season resource.        |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Team Leaders
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_team_leaders(team_id = 61, year = 2024))
#'   try(espn_cfb_team_leaders(team_id = 61, year = 2024,
#'                             team_detail = FALSE))
#' }
espn_cfb_team_leaders <- function(team_id = NULL,
                                  year = NULL,
                                  season_type = 2,
                                  team_detail = TRUE) {

  # Validation ----
  if (is.null(team_id)) {
    cli::cli_abort("{.arg team_id} is required for the ESPN team leaders endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN team leaders endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/types/{season_type}/teams/{team_id}/leaders",
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
      res <- httr2::request(url) |>
        httr2::req_headers(!!!headers) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()
      check_status(res)

      raw <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(simplifyVector = FALSE)

      categories <- raw[["categories"]]
      if (is.null(categories) || length(categories) == 0) {
        return(df)
      }

      rows <- list()
      for (ct in categories) {
        cat_name <- ct[["name"]] %||% NA_character_
        cat_disp <- ct[["displayName"]] %||% NA_character_
        leaders <- ct[["leaders"]] %||% list()
        for (i in seq_along(leaders)) {
          ld <- leaders[[i]]
          athlete_ref <- ld[["athlete"]][["$ref"]] %||% NA_character_
          athlete_id <- if (!is.na(athlete_ref)) {
            sub(".*/athletes/([0-9]+).*", "\\1", athlete_ref)
          } else {
            NA_character_
          }
          rows[[length(rows) + 1L]] <- data.frame(
            season           = suppressWarnings(as.integer(year)),
            season_type      = suppressWarnings(as.integer(season_type)),
            team_id          = as.character(team_id),
            category_name    = cat_name,
            category_display = cat_disp,
            leader_rank      = i,
            athlete_id       = athlete_id,
            value            = suppressWarnings(
              as.numeric(ld[["value"]] %||% NA)
            ),
            display_value    = as.character(ld[["displayValue"]] %||% NA),
            athlete_ref      = athlete_ref,
            stringsAsFactors = FALSE
          )
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df |>
        make_cfbfastR_data("Team statistical leaders from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN team leaders data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Single-Team Power Index (Long Format)**
#' @description Get ESPN's College Football Power Index (FPI) detail for a
#' single team-season -- the full set of predictive metrics and efficiency
#' components ESPN attaches to one team.
#' @details Wraps the ESPN core-v2 single-team power-index endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/powerindex/{team_id}`.
#' Where [espn_cfb_powerindex()] returns the league-wide index, this wrapper
#' drills into one team and returns one row per metric in long format: every
#' predictive metric (FPI, projected wins, strength of record, ...) and every
#' efficiency component (offensive, defensive, special-teams efficiency, ...).
#' The long shape is deliberate -- ESPN adds and retires metrics across
#' seasons, and a long frame absorbs that drift. Pivot wider with
#' [tidyr::pivot_wider()] keyed on `stat_name` for a wide table.
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
#' @param team_id (*Integer* required): ESPN team id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per metric:
#'
#'    |col_name      |types     |description                                        |
#'    |:-------------|:---------|:--------------------------------------------------|
#'    |season        |integer   |Season (4-digit year).                             |
#'    |team_id       |character |ESPN team id.                                      |
#'    |team_name     |character |Team nickname; `team_detail = TRUE` only.          |
#'    |team_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.   |
#'    |team_location |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name|character |Full team display name; `team_detail = TRUE` only.|
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname |character |Team nickname label; `team_detail = TRUE` only.    |
#'    |team_color    |character |Primary team color; `team_detail = TRUE` only.     |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.|
#'    |team_logo_href|character |Default team logo URL; `team_detail = TRUE` only.  |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |team_ref      |character |`$ref` URL to the team-in-season resource.         |
#'    |last_updated  |character |Timestamp ESPN last refreshed the power index.     |
#'    |metric_group  |character |`predictive` or `efficiency`.                      |
#'    |stat_name     |character |Internal metric key (e.g. `fpi`, `offefficiency`). |
#'    |abbreviation  |character |Metric abbreviation.                               |
#'    |display_name  |character |Human-readable metric name.                        |
#'    |value         |numeric   |Metric value.                                      |
#'    |display_value |character |Display-formatted metric value as shown on ESPN.   |
#'    |description   |character |ESPN's description of the metric.                  |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Team Power Index FPI
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_team_powerindex(team_id = 61, year = 2024))
#'   try(espn_cfb_team_powerindex(team_id = 61, year = 2024,
#'                                team_detail = FALSE))
#' }
espn_cfb_team_powerindex <- function(team_id = NULL,
                                     year = NULL,
                                     team_detail = TRUE) {

  # Validation ----
  if (is.null(team_id)) {
    cli::cli_abort("{.arg team_id} is required for the ESPN team power index endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN team power index endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/powerindex/{team_id}?lang=en&region=us"
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

      team_ref <- raw[["team"]][["$ref"]] %||% NA_character_
      season   <- raw[["season"]] %||% year
      last_upd <- raw[["lastUpdated"]] %||% NA_character_

      rows <- list()
      for (grp in names(metric_groups)) {
        for (s in raw[[grp]] %||% list()) {
          rows[[length(rows) + 1L]] <- data.frame(
            season           = suppressWarnings(as.integer(season)),
            team_id          = as.character(team_id),
            team_ref         = team_ref,
            last_updated     = as.character(last_upd),
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

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df |>
        make_cfbfastR_data("Team Power Index data from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN team power index data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Team Poll Rank History**
#' @description Get a college football team's poll-rank history for a season
#' -- one row per poll (AP, Coaches, CFP Committee, ...) the team appeared
#' in, with current/previous rank, trend, and record.
#' @details Wraps the ESPN core-v2 team ranks endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}/ranks`.
#' When a `week` is supplied the week-resolved variant is used instead:
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/2/weeks/{week}/teams/{team_id}/ranks`.
#' The index endpoint returns a `$ref` list of poll-rank resources; this
#' wrapper dereferences each one and returns a single row per poll with the
#' rank detail flattened. Without a `week`, ESPN returns the season's final
#' poll positions (one row per poll, plus postseason polls).
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
#' @param team_id (*Integer* required): ESPN team id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param week (*Integer* optional): Regular-season week. When supplied, the
#' team's rank at that specific week is returned.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per poll-rank:
#'
#'    |col_name        |types     |description                                          |
#'    |:---------------|:---------|:----------------------------------------------------|
#'    |season          |integer   |Season (4-digit year).                               |
#'    |team_id         |character |ESPN team id.                                        |
#'    |team_name       |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.       |
#'    |team_location   |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name|character |Full team display name; `team_detail = TRUE` only. |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname   |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color      |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.  |
#'    |team_logo_href  |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |week            |integer   |Week of the rank occurrence.                         |
#'    |poll_id         |character |ESPN poll id (e.g. `21` = CFP Committee Rankings).   |
#'    |poll_name       |character |Poll display name.                                   |
#'    |poll_short_name |character |Poll short name.                                     |
#'    |poll_type       |character |Poll type code (e.g. `cfp`, `ap`, `usa`).            |
#'    |headline        |character |Headline ESPN attaches to the poll release.          |
#'    |date            |character |Date of the poll release.                            |
#'    |current_rank    |integer   |Team's rank in this poll.                            |
#'    |previous_rank   |integer   |Team's rank in the prior release of this poll.       |
#'    |trend           |character |Rank movement string (e.g. `+3`, `-1`).             |
#'    |points          |numeric   |Voting points the team received.                     |
#'    |first_place_votes|integer  |First-place votes the team received.                 |
#'    |record_summary  |character |Team's win-loss record at the time of the poll.      |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Team Ranks
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_team_ranks(team_id = 61, year = 2024))
#'   try(espn_cfb_team_ranks(team_id = 61, year = 2024,
#'                           team_detail = FALSE))
#' }
espn_cfb_team_ranks <- function(team_id = NULL,
                                year = NULL,
                                week = NULL,
                                team_detail = TRUE) {

  # Validation ----
  if (is.null(team_id)) {
    cli::cli_abort("{.arg team_id} is required for the ESPN team ranks endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN team ranks endpoint.")
  }
  validate_year(year)

  if (is.null(week)) {
    url <- glue::glue(
      "https://sports.core.api.espn.com/v2/sports/football/leagues/",
      "college-football/seasons/{year}/teams/{team_id}/ranks",
      "?lang=en&region=us"
    )
  } else {
    url <- glue::glue(
      "https://sports.core.api.espn.com/v2/sports/football/leagues/",
      "college-football/seasons/{year}/types/2/weeks/{week}/teams/{team_id}/ranks",
      "?lang=en&region=us"
    )
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
        rank_ref <- it[["$ref"]] %||% NA_character_
        if (is.na(rank_ref)) next

        rk_res <- httr2::request(rank_ref) |>
          httr2::req_headers(!!!headers) |>
          httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
          httr2::req_error(is_error = function(resp) FALSE) |>
          httr2::req_perform()
        if (httr2::resp_status(rk_res) != 200) next
        rk <- rk_res |>
          httr2::resp_body_string(encoding = "UTF-8") |>
          jsonlite::fromJSON(simplifyVector = FALSE)

        rk_block <- rk[["rank"]] %||% list()
        rows[[length(rows) + 1L]] <- data.frame(
          season           = suppressWarnings(as.integer(year)),
          team_id          = as.character(team_id),
          week             = suppressWarnings(
            as.integer(rk[["occurrence"]][["number"]] %||% week %||% NA)
          ),
          poll_id          = as.character(rk[["id"]] %||% NA),
          poll_name        = rk[["name"]] %||% NA_character_,
          poll_short_name  = rk[["shortName"]] %||% NA_character_,
          poll_type        = rk[["type"]] %||% NA_character_,
          headline         = rk[["headline"]] %||% NA_character_,
          date             = as.character(rk[["date"]] %||% NA),
          current_rank     = suppressWarnings(
            as.integer(rk_block[["current"]] %||% NA)
          ),
          previous_rank    = suppressWarnings(
            as.integer(rk_block[["previous"]] %||% NA)
          ),
          trend            = as.character(rk_block[["trend"]] %||% NA),
          points           = suppressWarnings(
            as.numeric(rk_block[["points"]] %||% NA)
          ),
          first_place_votes = suppressWarnings(
            as.integer(rk_block[["firstPlaceVotes"]] %||% NA)
          ),
          record_summary   = as.character(
            rk_block[["record"]][["summary"]] %||% NA
          ),
          stringsAsFactors = FALSE
        )
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df |>
        make_cfbfastR_data("Team poll rank history from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN team ranks data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Team Record (Long Format)**
#' @description Get a college football team's season records -- overall,
#' home, away, and conference splits -- with the full set of summary stats
#' ESPN attaches to each.
#' @details Wraps the ESPN core-v2 team record endpoint
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/teams/{team_id}/record`.
#' ESPN returns several record items per team (overall, home record, away
#' record, vs. conference), each carrying ~20 summary stats. This wrapper
#' flattens that to long format: one row per (record-item x stat). The long
#' shape absorbs ESPN adding or retiring stat keys across seasons. Pivot
#' wider with [tidyr::pivot_wider()] keyed on `stat_name` for a wide table.
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
#' @param team_id (*Integer* required): ESPN team id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param season_type (*Integer* default 2): ESPN season type. `2` = regular
#' season, `3` = postseason.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per record-stat:
#'
#'    |col_name        |types     |description                                          |
#'    |:---------------|:---------|:----------------------------------------------------|
#'    |season          |integer   |Season (4-digit year).                               |
#'    |season_type     |integer   |ESPN season type (2 = regular, 3 = postseason).      |
#'    |team_id         |character |ESPN team id.                                        |
#'    |team_name       |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.       |
#'    |team_location   |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name|character |Full team display name; `team_detail = TRUE` only. |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname   |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color      |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.  |
#'    |team_logo_href  |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |record_type     |character |Record type code (e.g. `total`, `homerecord`).       |
#'    |record_name     |character |Record display name (e.g. `overall`, `Home`).        |
#'    |record_summary  |character |Win-loss summary string (e.g. `13-1`).               |
#'    |stat_name       |character |Stat key (e.g. `wins`, `avgPointsFor`).              |
#'    |stat_value      |numeric   |Numeric stat value.                                  |
#'    |stat_display    |character |Display-formatted stat value.                        |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Team Record
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_team_record(team_id = 61, year = 2024))
#'   try(espn_cfb_team_record(team_id = 61, year = 2024,
#'                            team_detail = FALSE))
#' }
espn_cfb_team_record <- function(team_id = NULL,
                                 year = NULL,
                                 season_type = 2,
                                 team_detail = TRUE) {

  # Validation ----
  if (is.null(team_id)) {
    cli::cli_abort("{.arg team_id} is required for the ESPN team record endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN team record endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/types/{season_type}/teams/{team_id}/record",
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
        rec_type    <- it[["type"]] %||% NA_character_
        rec_name    <- it[["name"]] %||% NA_character_
        rec_summary <- it[["summary"]] %||% NA_character_
        for (s in it[["stats"]] %||% list()) {
          nm <- s[["name"]]
          if (is.null(nm)) next
          rows[[length(rows) + 1L]] <- data.frame(
            season         = suppressWarnings(as.integer(year)),
            season_type    = suppressWarnings(as.integer(season_type)),
            team_id        = as.character(team_id),
            record_type    = rec_type,
            record_name    = rec_name,
            record_summary = rec_summary,
            stat_name      = nm,
            stat_value     = suppressWarnings(as.numeric(s[["value"]] %||% NA)),
            stat_display   = as.character(s[["displayValue"]] %||% NA),
            stringsAsFactors = FALSE
          )
        }
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df |>
        make_cfbfastR_data("Team record from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN team record data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Team Roster (Season-Scoped)**
#' @description Get the season roster for a single college football team --
#' one row per athlete with biographical detail, position, jersey number,
#' and class/experience.
#' @details Wraps the ESPN core-v2 season athlete index
#' `sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}/athletes`.
#' The index returns one `$ref` per athlete; this wrapper dereferences each
#' athlete resource and flattens it into a row. The site-v2 roster endpoint
#' is deliberately **not** used: it returns only the team's *current*
#' roster and silently ignores a `season` query parameter, so it cannot
#' deliver historical rosters. The core-v2 path used here is genuinely
#' season-scoped.
#'
#' Because each athlete is dereferenced individually, a full roster is
#' roughly 150-220 HTTP requests; allow a few seconds per call.
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
#' ([espn_cfb_positions()]) is fetched once and joined onto the
#' `position_id` column, appending the five `position_*` detail columns
#' (`position_name`, `position_display_name`, `position_abbreviation`,
#' `position_leaf`, `position_parent_id`). A catalog failure degrades to
#' `NA` rather than erroring the wrapper. Set `position_detail = FALSE` to
#' skip the extra fetch and the join.
#' @param team_id (*Integer* required): ESPN team id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param position_detail (*Logical*): when `TRUE` (default), fetch the
#' ESPN position catalog once and join it onto `position_id`, appending the
#' five `position_*` detail columns shown in the *Value* table. A catalog
#' failure degrades to `NA` rather than erroring the wrapper. Set `FALSE`
#' to skip the extra fetch and the join.
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to the `team_id`
#' column (see *Details*). Set `FALSE` to skip the catalog fetch and the
#' join.
#' @return A data frame with one row per athlete:
#'
#'    |col_name        |types     |description                                          |
#'    |:---------------|:---------|:----------------------------------------------------|
#'    |season          |integer   |Season (4-digit year).                               |
#'    |team_id         |character |ESPN team id.                                        |
#'    |team_name       |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.       |
#'    |team_location   |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name|character |Full team display name; `team_detail = TRUE` only. |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname   |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color      |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.  |
#'    |team_logo_href  |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |athlete_id      |character |ESPN athlete id.                                     |
#'    |first_name      |character |Athlete first name.                                  |
#'    |last_name       |character |Athlete last name.                                   |
#'    |full_name       |character |Athlete full name.                                   |
#'    |display_name    |character |Athlete display name.                                |
#'    |jersey          |character |Jersey number.                                       |
#'    |position        |character |Position display name.                               |
#'    |position_abbr   |character |Position abbreviation.                               |
#'    |height          |numeric   |Height in inches.                                    |
#'    |display_height  |character |Human-readable height (e.g. `6' 1"`).                |
#'    |weight          |numeric   |Weight in pounds.                                    |
#'    |display_weight  |character |Human-readable weight (e.g. `205 lbs`).              |
#'    |experience      |integer   |Years of experience.                                 |
#'    |class           |character |Class / experience label (e.g. `Junior`).           |
#'    |birth_city      |character |Birth city.                                          |
#'    |birth_state     |character |Birth state.                                         |
#'    |birth_country   |character |Birth country.                                       |
#'    |status          |character |Athlete status (e.g. `Active`).                      |
#'    |active          |logical   |Whether the athlete is active.                       |
#'    |headshot_href   |character |URL of the athlete headshot image.                   |
#'    |position_id     |character |ESPN position id; `position_detail = TRUE` only.     |
#'    |position_name   |character |Position name (e.g. `Quarterback`); `position_detail = TRUE` only. |
#'    |position_display_name|character |Human-readable position name; `position_detail = TRUE` only. |
#'    |position_abbreviation|character |Position abbreviation (e.g. `QB`); `position_detail = TRUE` only. |
#'    |position_leaf   |logical   |`TRUE` for a most-specific (leaf) position; `position_detail = TRUE` only. |
#'    |position_parent_id|character |ESPN id of the parent position; `position_detail = TRUE` only. |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Team Roster
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_team_roster(team_id = 61, year = 2024))
#'   try(espn_cfb_team_roster(team_id = 61, year = 2024,
#'                            position_detail = FALSE))
#'   try(espn_cfb_team_roster(team_id = 61, year = 2024,
#'                            team_detail = FALSE))
#' }
espn_cfb_team_roster <- function(team_id = NULL,
                                 year = NULL,
                                 position_detail = TRUE,
                                 team_detail = TRUE) {

  # Validation ----
  if (is.null(team_id)) {
    cli::cli_abort("{.arg team_id} is required for the ESPN team roster endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN team roster endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://sports.core.api.espn.com/v2/sports/football/leagues/",
    "college-football/seasons/{year}/teams/{team_id}/athletes",
    "?limit=300&lang=en&region=us"
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

  get_json <- function(u) {
    (httr2::request(u) |>
       httr2::req_headers(!!!headers) |>
       httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
       httr2::req_perform()) |>
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
      position_ids <- character(0)
      for (it in items) {
        ref <- it[["$ref"]]
        if (is.null(ref)) next
        a <- get_json(ref)
        if (is.null(a) || is.null(a[["id"]])) next

        pos <- a[["position"]] %||% list()
        exp <- a[["experience"]] %||% list()
        birth <- a[["birthPlace"]] %||% list()
        status <- a[["status"]] %||% list()
        headshot <- a[["headshot"]] %||% list()

        # The ESPN position block carries an id directly, or via $ref --
        # captured in parallel and only surfaced when position_detail = TRUE.
        pos_id <- pos[["id"]] %||% NA
        if (is.na(pos_id)) {
          pos_ref <- pos[["$ref"]] %||% NA_character_
          if (!is.na(pos_ref)) {
            pos_id <- sub(".*/positions/([0-9]+).*", "\\1", pos_ref)
          }
        }
        position_ids <- c(position_ids, as.character(pos_id %||% NA))

        rows[[length(rows) + 1L]] <- data.frame(
          season         = suppressWarnings(as.integer(year)),
          team_id        = as.character(team_id),
          athlete_id     = as.character(a[["id"]]),
          first_name     = a[["firstName"]] %||% NA_character_,
          last_name      = a[["lastName"]] %||% NA_character_,
          full_name      = a[["fullName"]] %||% NA_character_,
          display_name   = a[["displayName"]] %||% NA_character_,
          jersey         = as.character(a[["jersey"]] %||% NA),
          position       = pos[["displayName"]] %||% NA_character_,
          position_abbr  = pos[["abbreviation"]] %||% NA_character_,
          height         = suppressWarnings(as.numeric(a[["height"]] %||% NA)),
          display_height = a[["displayHeight"]] %||% NA_character_,
          weight         = suppressWarnings(as.numeric(a[["weight"]] %||% NA)),
          display_weight = a[["displayWeight"]] %||% NA_character_,
          experience     = suppressWarnings(as.integer(exp[["years"]] %||% NA)),
          class          = exp[["displayValue"]] %||% NA_character_,
          birth_city     = birth[["city"]] %||% NA_character_,
          birth_state    = birth[["state"]] %||% NA_character_,
          birth_country  = birth[["country"]] %||% NA_character_,
          status         = status[["name"]] %||% NA_character_,
          active         = a[["active"]] %||% NA,
          headshot_href  = headshot[["href"]] %||% NA_character_,
          stringsAsFactors = FALSE
        )
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN position catalog onto position_id when requested --
      # adds position_id plus position_name / _display_name / _abbreviation
      # / _leaf / _parent_id. position_detail = FALSE leaves the frame
      # untouched (position_id is not surfaced).
      if (isTRUE(position_detail)) {
        df[["position_id"]] <- position_ids[seq_len(nrow(df))]
        pos_lk <- .espn_cfb_position_lookup()
        df <- .espn_cfb_attach_position_detail(df, pos_lk)
      }

      # Join the ESPN team catalog onto the team_id column when requested.
      if (isTRUE(team_detail)) {
        df <- .espn_cfb_attach_team_detail(df, .espn_cfb_team_lookup())
      }

      df <- df |>
        make_cfbfastR_data("Team roster from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN team roster data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Team Schedule**
#' @description Get a single college football team's full-season schedule --
#' one row per game with opponent, venue, broadcast, score, and result.
#' @details Wraps the ESPN site-v2 team schedule endpoint
#' `site.api.espn.com/apis/site/v2/sports/football/college-football/teams/{team_id}/schedule`.
#' Each row is one scheduled game from the requested team's perspective:
#' the `opponent_*` columns describe the other team, and `team_score` /
#' `opponent_score` / `team_winner` describe the outcome (scores are `NA`
#' for games that have not been played). Team ids are ESPN team identifiers
#' -- enumerate them with [espn_cfb_teams()].
#'
#' When `team_detail = TRUE` (the default) the ESPN team catalog
#' ([espn_cfb_teams()]) is fetched once and friendly team fields are joined
#' onto every team-id column the output carries -- `team_id` and
#' `opponent_id`. For each id column `X_id` the friendly siblings `X_name`,
#' `X_abbreviation`, `X_location`, `X_display_name`,
#' `X_short_display_name`, `X_nickname`, `X_color`, `X_alternate_color`,
#' `X_logo_href`, and `X_logo_dark_href` are inserted immediately after it.
#' A catalog failure degrades to `NA` rather than erroring the wrapper. Set
#' `team_detail = FALSE` to skip the catalog fetch and the join.
#' @param team_id (*Integer* required): ESPN team id.
#' @param year (*Integer* required): Season, 4 digit format (*YYYY*).
#' @param team_detail (*Logical*): when `TRUE` (default), fetch the ESPN
#' team catalog once and join friendly team fields next to every team-id
#' column (`team_id`, `opponent_id`) in the output (see *Details*). Set
#' `FALSE` to skip the catalog fetch and the join.
#' @return A data frame with one row per scheduled game:
#'
#'    |col_name        |types     |description                                          |
#'    |:---------------|:---------|:----------------------------------------------------|
#'    |season          |integer   |Season (4-digit year).                               |
#'    |team_id         |character |ESPN team id queried.                                |
#'    |team_name       |character |Team nickname; `team_detail = TRUE` only.            |
#'    |team_abbreviation|character |Team abbreviation; `team_detail = TRUE` only.       |
#'    |team_location   |character |Team location / school name; `team_detail = TRUE` only.|
#'    |team_display_name|character |Full team display name; `team_detail = TRUE` only. |
#'    |team_short_display_name|character |Short team display name; `team_detail = TRUE` only.|
#'    |team_nickname   |character |Team nickname label; `team_detail = TRUE` only.      |
#'    |team_color      |character |Primary team color; `team_detail = TRUE` only.       |
#'    |team_alternate_color|character |Alternate team color; `team_detail = TRUE` only.  |
#'    |team_logo_href  |character |Default team logo URL; `team_detail = TRUE` only.    |
#'    |team_logo_dark_href|character |Dark-variant team logo URL; `team_detail = TRUE` only.|
#'    |game_id         |character |ESPN event id.                                       |
#'    |game_date       |character |Kickoff date-time (ISO 8601, UTC).                   |
#'    |game_name       |character |Full event name.                                     |
#'    |game_short_name |character |Short event name (e.g. `UTM @ UGA`).                 |
#'    |season_type     |integer   |ESPN season type (2 = regular, 3 = postseason).      |
#'    |week            |integer   |Week number.                                         |
#'    |home_away       |character |Whether the queried team is `home` or `away`.        |
#'    |team_score      |numeric   |Points scored by the queried team.                   |
#'    |team_winner     |logical   |Whether the queried team won.                        |
#'    |opponent_id     |character |ESPN team id of the opponent.                        |
#'    |opponent_team_name|character |Opponent team nickname; `team_detail = TRUE` only.  |
#'    |opponent_team_abbreviation|character |Opponent team abbreviation; `team_detail = TRUE` only.|
#'    |opponent_team_location|character |Opponent team location / school; `team_detail = TRUE` only.|
#'    |opponent_team_display_name|character |Opponent team full display name; `team_detail = TRUE` only.|
#'    |opponent_team_short_display_name|character |Opponent team short display name; `team_detail = TRUE` only.|
#'    |opponent_team_nickname|character |Opponent team nickname label; `team_detail = TRUE` only.|
#'    |opponent_team_color|character |Opponent team primary color; `team_detail = TRUE` only.|
#'    |opponent_team_alternate_color|character |Opponent team alternate color; `team_detail = TRUE` only.|
#'    |opponent_team_logo_href|character |Opponent team default logo URL; `team_detail = TRUE` only.|
#'    |opponent_team_logo_dark_href|character |Opponent team dark logo URL; `team_detail = TRUE` only.|
#'    |opponent_name   |character |Opponent display name.                               |
#'    |opponent_abbr   |character |Opponent abbreviation.                               |
#'    |opponent_score  |numeric   |Points scored by the opponent.                       |
#'    |neutral_site    |logical   |Whether the game is at a neutral site.               |
#'    |venue_name      |character |Venue name.                                          |
#'    |venue_city      |character |Venue city.                                          |
#'    |venue_state     |character |Venue state.                                         |
#'    |attendance      |integer   |Reported attendance.                                 |
#'    |broadcast       |character |Broadcast network short name.                        |
#'    |status          |character |Game status detail (e.g. `Final`).                   |
#'    |completed       |logical   |Whether the game is completed.                       |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom cli cli_abort
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Team Schedule
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_team_schedule(team_id = 61, year = 2024))
#'   try(espn_cfb_team_schedule(team_id = 61, year = 2024,
#'                              team_detail = FALSE))
#' }
espn_cfb_team_schedule <- function(team_id = NULL,
                                   year = NULL,
                                   team_detail = TRUE) {

  # Validation ----
  if (is.null(team_id)) {
    cli::cli_abort("{.arg team_id} is required for the ESPN team schedule endpoint.")
  }
  if (is.null(year)) {
    cli::cli_abort("{.arg year} is required for the ESPN team schedule endpoint.")
  }
  validate_year(year)

  url <- glue::glue(
    "https://site.api.espn.com/apis/site/v2/sports/football/",
    "college-football/teams/{team_id}/schedule?season={year}"
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

      events <- raw[["events"]]
      if (is.null(events) || length(events) == 0) {
        return(df)
      }

      rows <- list()
      for (e in events) {
        comp <- (e[["competitions"]] %||% list())[[1]]
        if (is.null(comp)) next

        # Split the two competitors into the queried team vs opponent.
        self <- NULL
        opp <- NULL
        for (cm in comp[["competitors"]] %||% list()) {
          if (identical(as.character(cm[["id"]]), as.character(team_id))) {
            self <- cm
          } else {
            opp <- cm
          }
        }

        venue <- comp[["venue"]] %||% list()
        status_type <- comp[["status"]][["type"]] %||% list()
        bcast <- comp[["broadcasts"]] %||% list()
        bcast_name <- if (length(bcast) > 0) {
          bcast[[1]][["media"]][["shortName"]] %||% NA_character_
        } else {
          NA_character_
        }

        rows[[length(rows) + 1L]] <- data.frame(
          season          = suppressWarnings(as.integer(year)),
          team_id         = as.character(team_id),
          game_id         = as.character(e[["id"]] %||% NA),
          game_date       = e[["date"]] %||% NA_character_,
          game_name       = e[["name"]] %||% NA_character_,
          game_short_name = e[["shortName"]] %||% NA_character_,
          season_type     = suppressWarnings(
            as.integer(e[["seasonType"]][["type"]] %||% NA)
          ),
          week            = suppressWarnings(
            as.integer(e[["week"]][["number"]] %||% NA)
          ),
          home_away       = self[["homeAway"]] %||% NA_character_,
          team_score      = suppressWarnings(
            as.numeric(self[["score"]][["value"]] %||% NA)
          ),
          team_winner     = self[["winner"]] %||% NA,
          opponent_id     = as.character(opp[["id"]] %||% NA),
          opponent_name   = opp[["team"]][["displayName"]] %||% NA_character_,
          opponent_abbr   = opp[["team"]][["abbreviation"]] %||% NA_character_,
          opponent_score  = suppressWarnings(
            as.numeric(opp[["score"]][["value"]] %||% NA)
          ),
          neutral_site    = comp[["neutralSite"]] %||% NA,
          venue_name      = venue[["fullName"]] %||% NA_character_,
          venue_city      = venue[["address"]][["city"]] %||% NA_character_,
          venue_state     = venue[["address"]][["state"]] %||% NA_character_,
          attendance      = suppressWarnings(
            as.integer(comp[["attendance"]] %||% NA)
          ),
          broadcast       = bcast_name,
          status          = status_type[["detail"]] %||% NA_character_,
          completed       = status_type[["completed"]] %||% NA,
          stringsAsFactors = FALSE
        )
      }

      if (length(rows) == 0) {
        return(df)
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble()

      # Join the ESPN team catalog onto every team-id column when requested.
      # `opponent_id` is not a `_team_id`-suffixed column, so the helper
      # would skip it; alias it to a temporary `opponent_team_id` (inserted
      # immediately after `opponent_id`) so the opponent is enriched too,
      # then drop the alias -- leaving the `opponent_team_*` friendly
      # siblings and the original `opponent_id` intact.
      if (isTRUE(team_detail)) {
        team_lk <- .espn_cfb_team_lookup()
        if ("opponent_id" %in% colnames(df)) {
          cols0   <- colnames(df)
          opp_pos <- match("opponent_id", cols0)
          new_order <- append(cols0, "opponent_team_id", after = opp_pos)
          df[["opponent_team_id"]] <- df[["opponent_id"]]
          df <- df[, new_order, drop = FALSE]
          df <- .espn_cfb_attach_team_detail(df, team_lk)
          df <- df[, setdiff(colnames(df), "opponent_team_id"), drop = FALSE]
        } else {
          df <- .espn_cfb_attach_team_detail(df, team_lk)
        }
      }

      df <- df |>
        make_cfbfastR_data("Team schedule from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN team schedule data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **Get ESPN college football team stats data**
#' @author Saiem Gilani
#' @param team_id Team ID
#' @param year Year
#' @param season_type (character, default: regular): Season type - regular or postseason
#' @param total (boolean, default: FALSE): Totals
#' @keywords CFB Team Stats
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows
#' @importFrom tidyr unnest unnest_wider everything
#' @export
#' @return Returns a tibble with the following columns:
#'
#'    |col_name                                        |types     |
#'    |:-----------------------------------------------|:---------|
#'    |team_id                                         |character |
#'    |team_guid                                       |character |
#'    |team_uid                                        |character |
#'    |team_sdr                                        |character |
#'    |team_slug                                       |character |
#'    |team_location                                   |character |
#'    |team_name                                       |character |
#'    |team_nickname                                   |character |
#'    |team_abbreviation                               |character |
#'    |team_display_name                               |character |
#'    |team_short_display_name                         |character |
#'    |team_color                                      |character |
#'    |team_alternate_color                            |character |
#'    |is_active                                       |logical   |
#'    |is_all_star                                     |logical   |
#'    |logo_href                                       |character |
#'    |logo_dark_href                                  |character |
#'    |general_fumbles                                 |numeric   |
#'    |general_fumbles_lost                            |numeric   |
#'    |general_fumbles_forced                          |numeric   |
#'    |general_fumbles_recovered                       |numeric   |
#'    |general_fumbles_touchdowns                      |numeric   |
#'    |general_games_played                            |numeric   |
#'    |general_offensive_two_pt_returns                |numeric   |
#'    |general_offensive_fumbles_touchdowns            |numeric   |
#'    |general_defensive_fumbles_touchdowns            |numeric   |
#'    |passing_avg_gain                                |numeric   |
#'    |passing_completion_pct                          |numeric   |
#'    |passing_completions                             |numeric   |
#'    |passing_espnqb_rating                           |numeric   |
#'    |passing_interception_pct                        |numeric   |
#'    |passing_interceptions                           |numeric   |
#'    |passing_long_passing                            |numeric   |
#'    |passing_misc_yards                              |numeric   |
#'    |passing_net_passing_yards                       |numeric   |
#'    |passing_net_passing_yards_per_game              |numeric   |
#'    |passing_net_total_yards                         |numeric   |
#'    |passing_net_yards_per_game                      |numeric   |
#'    |passing_passing_attempts                        |numeric   |
#'    |passing_passing_big_plays                       |numeric   |
#'    |passing_passing_first_downs                     |numeric   |
#'    |passing_passing_fumbles                         |numeric   |
#'    |passing_passing_fumbles_lost                    |numeric   |
#'    |passing_passing_touchdown_pct                   |numeric   |
#'    |passing_passing_touchdowns                      |numeric   |
#'    |passing_passing_yards                           |numeric   |
#'    |passing_passing_yards_after_catch               |numeric   |
#'    |passing_passing_yards_at_catch                  |numeric   |
#'    |passing_passing_yards_per_game                  |numeric   |
#'    |passing_qb_rating                               |numeric   |
#'    |passing_sacks                                   |numeric   |
#'    |passing_sack_yards_lost                         |numeric   |
#'    |passing_team_games_played                       |numeric   |
#'    |passing_total_offensive_plays                   |numeric   |
#'    |passing_total_points                            |numeric   |
#'    |passing_total_points_per_game                   |numeric   |
#'    |passing_total_touchdowns                        |numeric   |
#'    |passing_total_yards                             |numeric   |
#'    |passing_total_yards_from_scrimmage              |numeric   |
#'    |passing_two_point_pass_convs                    |numeric   |
#'    |passing_two_pt_pass                             |numeric   |
#'    |passing_two_pt_pass_attempts                    |numeric   |
#'    |passing_yards_from_scrimmage_per_game           |numeric   |
#'    |passing_yards_per_completion                    |numeric   |
#'    |passing_yards_per_game                          |numeric   |
#'    |passing_yards_per_pass_attempt                  |numeric   |
#'    |passing_net_yards_per_pass_attempt              |numeric   |
#'    |passing_quarterback_rating                      |numeric   |
#'    |rushing_avg_gain                                |numeric   |
#'    |rushing_espnrb_rating                           |numeric   |
#'    |rushing_long_rushing                            |numeric   |
#'    |rushing_misc_yards                              |numeric   |
#'    |rushing_net_total_yards                         |numeric   |
#'    |rushing_net_yards_per_game                      |numeric   |
#'    |rushing_rushing_attempts                        |numeric   |
#'    |rushing_rushing_big_plays                       |numeric   |
#'    |rushing_rushing_first_downs                     |numeric   |
#'    |rushing_rushing_fumbles                         |numeric   |
#'    |rushing_rushing_fumbles_lost                    |numeric   |
#'    |rushing_rushing_touchdowns                      |numeric   |
#'    |rushing_rushing_yards                           |numeric   |
#'    |rushing_rushing_yards_per_game                  |numeric   |
#'    |rushing_stuffs                                  |numeric   |
#'    |rushing_stuff_yards_lost                        |numeric   |
#'    |rushing_team_games_played                       |numeric   |
#'    |rushing_total_offensive_plays                   |numeric   |
#'    |rushing_total_points                            |numeric   |
#'    |rushing_total_points_per_game                   |numeric   |
#'    |rushing_total_touchdowns                        |numeric   |
#'    |rushing_total_yards                             |numeric   |
#'    |rushing_total_yards_from_scrimmage              |numeric   |
#'    |rushing_two_point_rush_convs                    |numeric   |
#'    |rushing_two_pt_rush                             |numeric   |
#'    |rushing_two_pt_rush_attempts                    |numeric   |
#'    |rushing_yards_from_scrimmage_per_game           |numeric   |
#'    |rushing_yards_per_game                          |numeric   |
#'    |rushing_yards_per_rush_attempt                  |numeric   |
#'    |receiving_avg_gain                              |numeric   |
#'    |receiving_espnwr_rating                         |numeric   |
#'    |receiving_long_reception                        |numeric   |
#'    |receiving_misc_yards                            |numeric   |
#'    |receiving_net_total_yards                       |numeric   |
#'    |receiving_net_yards_per_game                    |numeric   |
#'    |receiving_receiving_big_plays                   |numeric   |
#'    |receiving_receiving_first_downs                 |numeric   |
#'    |receiving_receiving_fumbles                     |numeric   |
#'    |receiving_receiving_fumbles_lost                |numeric   |
#'    |receiving_receiving_targets                     |numeric   |
#'    |receiving_receiving_touchdowns                  |numeric   |
#'    |receiving_receiving_yards                       |numeric   |
#'    |receiving_receiving_yards_after_catch           |numeric   |
#'    |receiving_receiving_yards_at_catch              |numeric   |
#'    |receiving_receiving_yards_per_game              |numeric   |
#'    |receiving_receptions                            |numeric   |
#'    |receiving_team_games_played                     |numeric   |
#'    |receiving_total_offensive_plays                 |numeric   |
#'    |receiving_total_points                          |numeric   |
#'    |receiving_total_points_per_game                 |numeric   |
#'    |receiving_total_touchdowns                      |numeric   |
#'    |receiving_total_yards                           |numeric   |
#'    |receiving_total_yards_from_scrimmage            |numeric   |
#'    |receiving_two_point_rec_convs                   |numeric   |
#'    |receiving_two_pt_reception                      |numeric   |
#'    |receiving_two_pt_reception_attempts             |numeric   |
#'    |receiving_yards_from_scrimmage_per_game         |numeric   |
#'    |receiving_yards_per_game                        |numeric   |
#'    |receiving_yards_per_reception                   |numeric   |
#'    |defensive_assist_tackles                        |numeric   |
#'    |defensive_avg_interception_yards                |numeric   |
#'    |defensive_avg_sack_yards                        |numeric   |
#'    |defensive_avg_stuff_yards                       |numeric   |
#'    |defensive_blocked_field_goal_touchdowns         |numeric   |
#'    |defensive_blocked_punt_touchdowns               |numeric   |
#'    |defensive_defensive_touchdowns                  |numeric   |
#'    |defensive_hurries                               |numeric   |
#'    |defensive_kicks_blocked                         |numeric   |
#'    |defensive_long_interception                     |numeric   |
#'    |defensive_misc_touchdowns                       |numeric   |
#'    |defensive_passes_batted_down                    |numeric   |
#'    |defensive_passes_defended                       |numeric   |
#'    |defensive_two_pt_returns                        |numeric   |
#'    |defensive_sacks                                 |numeric   |
#'    |defensive_sack_yards                            |numeric   |
#'    |defensive_safeties                              |numeric   |
#'    |defensive_solo_tackles                          |numeric   |
#'    |defensive_stuffs                                |numeric   |
#'    |defensive_stuff_yards                           |numeric   |
#'    |defensive_tackles_for_loss                      |numeric   |
#'    |defensive_team_games_played                     |numeric   |
#'    |defensive_total_tackles                         |numeric   |
#'    |defensive_yards_allowed                         |numeric   |
#'    |defensive_points_allowed                        |numeric   |
#'    |defensive_one_pt_safeties_made                  |numeric   |
#'    |defensive_interceptions_interceptions           |numeric   |
#'    |defensive_interceptions_interception_touchdowns |numeric   |
#'    |defensive_interceptions_interception_yards      |numeric   |
#'    |kicking_avg_kickoff_return_yards                |numeric   |
#'    |kicking_avg_kickoff_yards                       |numeric   |
#'    |kicking_extra_point_attempts                    |numeric   |
#'    |kicking_extra_point_pct                         |numeric   |
#'    |kicking_extra_points_blocked                    |numeric   |
#'    |kicking_extra_points_blocked_pct                |numeric   |
#'    |kicking_extra_points_made                       |numeric   |
#'    |kicking_fair_catches                            |numeric   |
#'    |kicking_fair_catch_pct                          |numeric   |
#'    |kicking_field_goal_attempts                     |numeric   |
#'    |kicking_field_goal_attempts1_19                 |numeric   |
#'    |kicking_field_goal_attempts20_29                |numeric   |
#'    |kicking_field_goal_attempts30_39                |numeric   |
#'    |kicking_field_goal_attempts40_49                |numeric   |
#'    |kicking_field_goal_attempts50_59                |numeric   |
#'    |kicking_field_goal_attempts60_99                |numeric   |
#'    |kicking_field_goal_attempts50                   |numeric   |
#'    |kicking_field_goal_attempt_yards                |numeric   |
#'    |kicking_field_goal_pct                          |numeric   |
#'    |kicking_field_goals_blocked                     |numeric   |
#'    |kicking_field_goals_blocked_pct                 |numeric   |
#'    |kicking_field_goals_made                        |numeric   |
#'    |kicking_field_goals_made1_19                    |numeric   |
#'    |kicking_field_goals_made20_29                   |numeric   |
#'    |kicking_field_goals_made30_39                   |numeric   |
#'    |kicking_field_goals_made40_49                   |numeric   |
#'    |kicking_field_goals_made50_59                   |numeric   |
#'    |kicking_field_goals_made60_99                   |numeric   |
#'    |kicking_field_goals_made50                      |numeric   |
#'    |kicking_field_goals_made_yards                  |numeric   |
#'    |kicking_field_goals_missed_yards                |numeric   |
#'    |kicking_kickoff_returns                         |numeric   |
#'    |kicking_kickoff_return_touchdowns               |numeric   |
#'    |kicking_kickoff_return_yards                    |numeric   |
#'    |kicking_kickoffs                                |numeric   |
#'    |kicking_kickoff_yards                           |numeric   |
#'    |kicking_long_field_goal_attempt                 |numeric   |
#'    |kicking_long_field_goal_made                    |numeric   |
#'    |kicking_long_kickoff                            |numeric   |
#'    |kicking_team_games_played                       |numeric   |
#'    |kicking_total_kicking_points                    |numeric   |
#'    |kicking_touchback_pct                           |numeric   |
#'    |kicking_touchbacks                              |numeric   |
#'    |returning_def_fumble_returns                    |numeric   |
#'    |returning_def_fumble_return_yards               |numeric   |
#'    |returning_fumble_recoveries                     |numeric   |
#'    |returning_fumble_recovery_yards                 |numeric   |
#'    |returning_kick_return_fair_catches              |numeric   |
#'    |returning_kick_return_fair_catch_pct            |numeric   |
#'    |returning_kick_return_fumbles                   |numeric   |
#'    |returning_kick_return_fumbles_lost              |numeric   |
#'    |returning_kick_returns                          |numeric   |
#'    |returning_kick_return_touchdowns                |numeric   |
#'    |returning_kick_return_yards                     |numeric   |
#'    |returning_long_kick_return                      |numeric   |
#'    |returning_long_punt_return                      |numeric   |
#'    |returning_misc_fumble_returns                   |numeric   |
#'    |returning_misc_fumble_return_yards              |numeric   |
#'    |returning_opp_fumble_recoveries                 |numeric   |
#'    |returning_opp_fumble_recovery_yards             |numeric   |
#'    |returning_opp_special_team_fumble_returns       |numeric   |
#'    |returning_opp_special_team_fumble_return_yards  |numeric   |
#'    |returning_punt_return_fair_catches              |numeric   |
#'    |returning_punt_return_fair_catch_pct            |numeric   |
#'    |returning_punt_return_fumbles                   |numeric   |
#'    |returning_punt_return_fumbles_lost              |numeric   |
#'    |returning_punt_returns                          |numeric   |
#'    |returning_punt_returns_started_inside_the10     |numeric   |
#'    |returning_punt_returns_started_inside_the20     |numeric   |
#'    |returning_punt_return_touchdowns                |numeric   |
#'    |returning_punt_return_yards                     |numeric   |
#'    |returning_special_team_fumble_returns           |numeric   |
#'    |returning_special_team_fumble_return_yards      |numeric   |
#'    |returning_team_games_played                     |numeric   |
#'    |returning_yards_per_kick_return                 |numeric   |
#'    |returning_yards_per_punt_return                 |numeric   |
#'    |returning_yards_per_return                      |numeric   |
#'    |punting_avg_punt_return_yards                   |numeric   |
#'    |punting_fair_catches                            |numeric   |
#'    |punting_gross_avg_punt_yards                    |numeric   |
#'    |punting_long_punt                               |numeric   |
#'    |punting_net_avg_punt_yards                      |numeric   |
#'    |punting_punt_returns                            |numeric   |
#'    |punting_punt_return_yards                       |numeric   |
#'    |punting_punts                                   |numeric   |
#'    |punting_punts_blocked                           |numeric   |
#'    |punting_punts_blocked_pct                       |numeric   |
#'    |punting_punts_inside10                          |numeric   |
#'    |punting_punts_inside10pct                       |numeric   |
#'    |punting_punts_inside20                          |numeric   |
#'    |punting_punts_inside20pct                       |numeric   |
#'    |punting_punt_yards                              |numeric   |
#'    |punting_team_games_played                       |numeric   |
#'    |punting_touchback_pct                           |numeric   |
#'    |punting_touchbacks                              |numeric   |
#'    |scoring_defensive_points                        |numeric   |
#'    |scoring_field_goals                             |numeric   |
#'    |scoring_kick_extra_points                       |numeric   |
#'    |scoring_misc_points                             |numeric   |
#'    |scoring_passing_touchdowns                      |numeric   |
#'    |scoring_receiving_touchdowns                    |numeric   |
#'    |scoring_return_touchdowns                       |numeric   |
#'    |scoring_rushing_touchdowns                      |numeric   |
#'    |scoring_total_points                            |numeric   |
#'    |scoring_total_points_per_game                   |numeric   |
#'    |scoring_total_touchdowns                        |numeric   |
#'    |scoring_total_two_point_convs                   |numeric   |
#'    |scoring_two_point_pass_convs                    |numeric   |
#'    |scoring_two_point_rec_convs                     |numeric   |
#'    |scoring_two_point_rush_convs                    |numeric   |
#'    |scoring_one_pt_safeties_made                    |numeric   |
#'    |miscellaneous_first_downs                       |numeric   |
#'    |miscellaneous_first_downs_passing               |numeric   |
#'    |miscellaneous_first_downs_penalty               |numeric   |
#'    |miscellaneous_first_downs_per_game              |numeric   |
#'    |miscellaneous_first_downs_rushing               |numeric   |
#'    |miscellaneous_fourth_down_attempts              |numeric   |
#'    |miscellaneous_fourth_down_conv_pct              |numeric   |
#'    |miscellaneous_fourth_down_convs                 |numeric   |
#'    |miscellaneous_fumbles_lost                      |numeric   |
#'    |miscellaneous_possession_time_seconds           |numeric   |
#'    |miscellaneous_redzone_efficiency_pct            |numeric   |
#'    |miscellaneous_redzone_field_goal_pct            |numeric   |
#'    |miscellaneous_redzone_scoring_pct               |numeric   |
#'    |miscellaneous_redzone_touchdown_pct             |numeric   |
#'    |miscellaneous_third_down_attempts               |numeric   |
#'    |miscellaneous_third_down_conv_pct               |numeric   |
#'    |miscellaneous_third_down_convs                  |numeric   |
#'    |miscellaneous_total_giveaways                   |numeric   |
#'    |miscellaneous_total_penalties                   |numeric   |
#'    |miscellaneous_total_penalty_yards               |numeric   |
#'    |miscellaneous_total_takeaways                   |numeric   |
#'    |miscellaneous_total_drives                      |numeric   |
#'    |miscellaneous_turn_over_differential            |numeric   |
#'
#' @examples
#' \donttest{
#'   try(espn_cfb_team_stats(team_id = 52, year = 2020))
#' }
#'
espn_cfb_team_stats <- function(team_id, year, season_type='regular', total=FALSE){
  if (!(tolower(season_type) %in% c("regular","postseason"))) {
    # Check if season_type is appropriate, if not regular
    cli::cli_abort("Enter valid season_type: regular or postseason")
  }
  s_type <- ifelse(season_type == "postseason", 3, 2)

  base_url <- "https://sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/"

  totals <- ifelse(total == TRUE, 0, "")
  full_url <- paste0(
    base_url,
    year,
    '/types/',s_type,
    '/teams/',team_id,
    '/statistics/', totals
  )

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- httr2::request(full_url) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()

      # Check the result
      check_status(res)

      # Get the content and return result as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8")  |>
        jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)

      team_url <- df[["team"]][["$ref"]]

      # Create the GET request and set response as res
      team_res <- httr2::request(team_url) |>
        httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
        httr2::req_perform()

      # Check the result
      check_status(team_res)

      team_df <- team_res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
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


      team_df <- team_df |>
        purrr::map_if(is.list,as.data.frame) |>
        as.data.frame() |>
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
              "X.ref.2"))) |>
        janitor::clean_names()

      colnames(team_df)[1:13] <- paste0("team_",colnames(team_df)[1:13])

      team_df <- team_df |>
        dplyr::rename(
          "logo_href" = "logos_href",
          "logo_dark_href" = "logos_href_1")


      # Get the content and return result as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        purrr::pluck("splits") |>
        purrr::pluck("categories") |>
        tidyr::unnest("stats", names_sep="_")
      df <- df |>
        dplyr::mutate(
          stats_category_name = glue::glue("{.data$name}_{.data$stats_name}")) |>
        dplyr::select("stats_category_name", "stats_value") |>
        tidyr::pivot_wider(names_from = "stats_category_name",
                           values_from = "stats_value",
                           values_fn = dplyr::first) |>
        janitor::clean_names()

      df <- team_df |>
        dplyr::bind_cols(df)
      df <- df |>
        make_cfbfastR_data("CFB Team Season stats from ESPN.com",Sys.time())

    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no season team stats data available!"))
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}


#' @title
#' **ESPN College Football Teams Index**
#' @description Get the full ESPN directory of college football teams -- one
#' row per team with identifiers, branding, conference grouping, and logo
#' URLs.
#' @details Wraps the ESPN site-v2 expanded teams endpoint
#' `site.api.espn.com/apis/site/v2/sports/football/college-football/teams`.
#' The expanded endpoint returns every team fully inlined in a single call
#' (no `$ref` dereferencing), so one request produces the whole directory.
#' The `team_id` column is the ESPN team identifier used as the `team_id`
#' argument to the other `espn_cfb_team_*()` wrappers.
#' @return A data frame with one row per team:
#'
#'    |col_name           |types     |description                                          |
#'    |:------------------|:---------|:----------------------------------------------------|
#'    |team_id            |character |ESPN team id.                                        |
#'    |uid                |character |ESPN global unique identifier.                       |
#'    |slug               |character |URL slug for the team.                               |
#'    |abbreviation       |character |Team abbreviation.                                   |
#'    |display_name       |character |Full team display name.                              |
#'    |short_display_name |character |Short team display name.                             |
#'    |name               |character |Team nickname (e.g. `Bulldogs`).                     |
#'    |nickname           |character |Team nickname / location label.                      |
#'    |location           |character |Team location / school name.                         |
#'    |color              |character |Primary team color (hex, no `#`).                    |
#'    |alternate_color    |character |Alternate team color (hex, no `#`).                  |
#'    |is_active          |logical   |Whether the team is currently active.                |
#'    |is_all_star        |logical   |Whether the team is an all-star team.                |
#'    |logo_href          |character |URL of the default team logo.                        |
#'    |logo_dark_href     |character |URL of the dark-variant team logo.                   |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_headers req_retry req_error req_perform resp_body_string resp_status
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom glue glue
#' @importFrom rlang "%||%"
#' @keywords ESPN CFB Teams
#' @family ESPN CFB Functions
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_teams())
#' }
espn_cfb_teams <- function() {

  url <- paste0(
    "https://site.api.espn.com/apis/site/v2/sports/football/",
    "college-football/teams?limit=900"
  )

  # No `User-Agent`. site.api.espn.com now returns HTTP 403 for a spoofed
  # browser UA -- measured 2026-08-19: this endpoint answers 200 with httr2's
  # default UA, with `curl/8.5.0`, or with Accept/Origin/Referer and no UA at
  # all, and 403 with the Chrome string (or any short UA such as "R"). The 403
  # was silent: `espn_cfb_teams()` caught it, returned zero rows, and every
  # consumer degraded to NA -- which took `home`/`away`, `pos_team`,
  # `def_pos_team`, `offense_play`, `defense_play` and every team abbreviation
  # on the ESPN play-by-play path down with it.
  headers <- c(
    `Accept` = "application/json, text/plain, */*",
    `Origin` = "https://www.espn.com",
    `Referer` = "https://www.espn.com/"
  )

  # Pull the default + dark logo hrefs out of the team's logos[] block.
  logo_href <- function(logos, want_dark) {
    for (lg in logos %||% list()) {
      rels <- unlist(lg[["rel"]] %||% list())
      is_dark <- "dark" %in% rels
      if (isTRUE(want_dark) && is_dark) return(lg[["href"]] %||% NA_character_)
      if (isFALSE(want_dark) && !is_dark && "full" %in% rels) {
        return(lg[["href"]] %||% NA_character_)
      }
    }
    NA_character_
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

      teams <- raw[["sports"]][[1]][["leagues"]][[1]][["teams"]]
      if (is.null(teams) || length(teams) == 0) {
        return(df)
      }

      rows <- list()
      for (t in teams) {
        tm <- t[["team"]]
        if (is.null(tm)) next
        rows[[length(rows) + 1L]] <- data.frame(
          team_id            = as.character(tm[["id"]] %||% NA),
          uid                = tm[["uid"]] %||% NA_character_,
          slug               = tm[["slug"]] %||% NA_character_,
          abbreviation       = tm[["abbreviation"]] %||% NA_character_,
          display_name       = tm[["displayName"]] %||% NA_character_,
          short_display_name = tm[["shortDisplayName"]] %||% NA_character_,
          name               = tm[["name"]] %||% NA_character_,
          nickname           = tm[["nickname"]] %||% NA_character_,
          location           = tm[["location"]] %||% NA_character_,
          color              = tm[["color"]] %||% NA_character_,
          alternate_color    = tm[["alternateColor"]] %||% NA_character_,
          is_active          = tm[["isActive"]] %||% NA,
          is_all_star        = tm[["isAllStar"]] %||% NA,
          logo_href          = logo_href(tm[["logos"]], want_dark = FALSE),
          logo_dark_href     = logo_href(tm[["logos"]], want_dark = TRUE),
          stringsAsFactors   = FALSE
        )
      }

      df <- dplyr::bind_rows(rows) |>
        dplyr::as_tibble() |>
        make_cfbfastR_data("Teams index from ESPN", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN teams data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(.attach_query_meta_auto(df))
}
