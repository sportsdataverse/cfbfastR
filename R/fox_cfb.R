# fox_cfb.R -- Fox Sports "Bifrost" college football wrappers.
#
# Read-only wrappers over api.foxsports.com/bifrost/v1/cfb/*. The Bifrost API is
# a layout API (sections -> tables -> rows -> cells); these functions flatten the
# layout into tidy tibbles. Reverse-engineering notes + an OpenAPI spec live in
# the sdv-internal-refs repo (_notes/foxsportsapi/). Vertical slice: pbp, roster,
# boxscore. The public apikey ships in the foxsports.com web bundle.

# Public Bifrost data-tier key (overridable via options(cfbfastR.fox_key=)).
.FOX_CFB_KEY <- "jE7yBJVRNAwdDesMgTzTXUUSx1It41Fq"

.fox_or <- function(a, b) if (is.null(a) || length(a) == 0) b else a

#' @keywords internal
#' @importFrom httr2 request req_url_query req_headers req_retry req_perform resp_body_string
#' @importFrom jsonlite fromJSON
.fox_cfb_get <- function(path, query = list()) {
  query[["apikey"]] <- .fox_or(query[["apikey"]], getOption("cfbfastR.fox_key", .FOX_CFB_KEY))
  query[["api-version"]] <- .fox_or(query[["api-version"]], "1.1")
  url <- paste0("https://api.foxsports.com/bifrost/v1/", path)
  res <- httr2::request(url) |>
    httr2::req_url_query(!!!query) |>
    httr2::req_headers(Origin = "https://www.foxsports.com",
                       Referer = "https://www.foxsports.com/") |>
    httr2::req_retry(max_tries = 3, backoff = ~ 2) |>
    httr2::req_perform()
  res |>
    httr2::resp_body_string(encoding = "UTF-8") |>
    jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)
}

# cell text out of a Bifrost columns list. Elements may be {text:...} objects
# (most tables) or bare strings (e.g. odds columnHeaders).
.fox_cells <- function(cols) {
  vapply(cols, function(c) {
    v <- if (is.list(c)) c[["text"]] else c
    if (is.null(v) || length(v) == 0) NA_character_ else as.character(v)[1]
  }, character(1))
}
# numeric id out of a contentUri like football/cfb/athletes/233452
.fox_uri_id <- function(uri) {
  if (is.null(uri)) return(NA_character_)
  m <- regmatches(uri, regexpr("[0-9]+$", uri))
  if (length(m)) m else NA_character_
}

# generic: a Bifrost table {headers, rows} -> a wide data.frame. `extra` is a
# named list of constant columns to prepend (e.g. section/table title).
#' @importFrom janitor make_clean_names
.fox_table_df <- function(tbl, extra = list()) {
  if (is.null(tbl)) return(NULL)
  hdr <- .fox_cells(tbl[["headers"]][[1]][["columns"]])
  nm <- janitor::make_clean_names(ifelse(is.na(hdr) | hdr == "", paste0("v", seq_along(hdr)), hdr))
  rws <- .fox_or(tbl[["rows"]], list())
  if (!length(rws)) return(NULL)
  recs <- lapply(rws, function(r) {
    cells <- .fox_cells(r[["columns"]])
    vals <- as.list(cells)
    names(vals) <- nm[seq_along(vals)]
    eid <- .fox_uri_id(.fox_or(r[["entityLink"]][["contentUri"]], NULL))
    as.data.frame(c(extra, vals, list(entity_id = eid)), stringsAsFactors = FALSE)
  })
  dplyr::bind_rows(recs)
}

#' **Get Fox Sports college football play-by-play**
#'
#' Flattens the Bifrost `event/{id}/data` play-by-play layout
#' (quarters -> drives -> plays) into one tidy play-level tibble.
#'
#' @param game_id (character/numeric, required): Fox Bifrost event id (e.g. `"41616"`).
#'   This is the Fox event id, not the ESPN game id.
#' @return A `cfbfastR`-tagged tibble with one row per play:
#'
#' * `game_id`: character.: Fox event id echoed back.
#' * `quarter`: character.: Period title (e.g. "1ST QUARTER", "OVERTIME").
#' * `drive_id`: character.: Drive identifier within the game.
#' * `drive_result`: character.: Drive outcome (e.g. "TOUCHDOWN", "PUNT").
#' * `drive_summary`: character.: Drive summary ("4 plays, 65 yards, 1:21").
#' * `drive_team`: character.: Team on offense for the drive.
#' * `play_id`: character.: Play identifier.
#' * `period`: character.: Period of the play ("1ST", "OT").
#' * `clock`: character.: Game clock at the play ("15:00").
#' * `field_position`: character.: Field-position label ("KENT 35").
#' * `play_text`: character.: Full play description.
#' * `play_team`: character.: Team credited with the play.
#'
#' @keywords PBP Data
#' @importFrom janitor clean_names
#' @importFrom tibble as_tibble
#' @export
#' @examples
#' \donttest{
#'   try(fox_cfb_pbp(game_id = "41616"))
#' }
fox_cfb_pbp <- function(game_id) {
  pbp_out <- data.frame()
  tryCatch(
    expr = {
      raw <- .fox_cfb_get(paste0("cfb/event/", game_id, "/data"))
      sections <- .fox_or(raw[["pbp"]][["sections"]], list())
      rows <- list()
      for (sec in sections) {
        quarter <- .fox_or(sec[["title"]], NA_character_)
        for (drv in .fox_or(sec[["groups"]], list())) {
          drive_team <- .fox_or(drv[["entityLink"]][["title"]], NA_character_)
          for (p in .fox_or(drv[["plays"]], list())) {
            rows[[length(rows) + 1]] <- data.frame(
              game_id = as.character(game_id),
              quarter = quarter,
              drive_id = .fox_or(drv[["id"]], NA_character_) |> as.character(),
              drive_result = .fox_or(drv[["title"]], NA_character_),
              drive_summary = .fox_or(drv[["subtitle"]], NA_character_),
              drive_team = drive_team,
              play_id = .fox_or(p[["id"]], NA_character_) |> as.character(),
              period = .fox_or(p[["periodOfPlay"]], NA_character_),
              clock = .fox_or(p[["timeOfPlay"]], NA_character_),
              field_position = .fox_or(p[["title"]], NA_character_),
              play_text = .fox_or(p[["playDescription"]], NA_character_),
              play_team = .fox_or(p[["entityLink"]][["title"]], NA_character_),
              stringsAsFactors = FALSE)
          }
        }
      }
      pbp_out <- (if (length(rows)) do.call(rbind, rows) else data.frame()) |>
        tibble::as_tibble() |>
        janitor::clean_names() |>
        make_cfbfastR_data("Play-by-play data from Fox Sports (Bifrost)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid game_id or no Fox PBP data available!"))
    }
  )
  return(.attach_query_meta_auto(pbp_out))
}

#' **Get Fox Sports college football team roster**
#'
#' Flattens the Bifrost `team/{id}/roster` position-group tables into one tidy
#' player-level tibble.
#'
#' @param team_id (character/numeric, required): Fox Bifrost team id (e.g. `"11"`
#'   for Miami (FL)). Discover ids via the league team directory (`league/teamnav`).
#' @return A `cfbfastR`-tagged tibble with one row per player:
#'
#' * `team_id`: character.: Fox team id echoed back.
#' * `position_group`: character.: Roster group ("OFFENSE", "DEFENSE", "SPECIAL TEAMS").
#' * `player`: character.: Player name.
#' * `pos`: character.: Position abbreviation.
#' * `class`: character.: Class (FR/SO/JR/SR).
#' * `height`: character.: Listed height.
#' * `weight`: character.: Listed weight.
#' * `athlete_id`: character.: Fox athlete id (from the player's contentUri).
#'
#' @keywords Roster Data
#' @importFrom janitor clean_names
#' @importFrom tibble as_tibble
#' @export
#' @examples
#' \donttest{
#'   try(fox_cfb_team_roster(team_id = "11"))
#' }
fox_cfb_team_roster <- function(team_id) {
  roster_out <- data.frame()
  tryCatch(
    expr = {
      raw <- .fox_cfb_get(paste0("cfb/team/", team_id, "/roster"))
      rows <- list()
      for (g in .fox_or(raw[["groups"]], list())) {
        hdr <- .fox_cells(g[["headers"]][[1]][["columns"]])
        group_label <- .fox_or(g[["title"]], .fox_or(hdr[1], NA_character_))
        col_names <- c("player", tolower(.fox_or(hdr[-1], character(0))))
        for (r in .fox_or(g[["rows"]], list())) {
          uri <- .fox_or(r[["entityLink"]][["contentUri"]], NULL)
          if (is.null(uri) || !grepl("athletes/", uri)) next   # players only
          cells <- .fox_cells(r[["columns"]])
          vals <- as.list(cells)
          names(vals) <- col_names[seq_along(vals)]
          rows[[length(rows) + 1]] <- data.frame(
            team_id = as.character(team_id),
            position_group = group_label,
            as.data.frame(vals, stringsAsFactors = FALSE),
            athlete_id = .fox_uri_id(uri),
            stringsAsFactors = FALSE)
        }
      }
      roster_out <- (if (length(rows)) dplyr::bind_rows(rows) else data.frame()) |>
        tibble::as_tibble() |>
        janitor::clean_names() |>
        make_cfbfastR_data("Roster data from Fox Sports (Bifrost)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid team_id or no Fox roster data available!"))
    }
  )
  return(.attach_query_meta_auto(roster_out))
}

#' **Get Fox Sports college football boxscore**
#'
#' Flattens the per-team stat tables embedded in Bifrost `event/{id}/data`
#' (`boxscore`) into one tidy, long player-stat tibble.
#'
#' @param game_id (character/numeric, required): Fox Bifrost event id (e.g. `"41616"`).
#' @return A `cfbfastR`-tagged tibble with one row per (player, stat):
#'
#' * `game_id`: character.: Fox event id echoed back.
#' * `team`: character.: Team name (boxscore section title).
#' * `stat_group`: character.: Stat category ("PASSING", "RUSHING", ...).
#' * `player`: character.: Player name (or "TOTALS").
#' * `athlete_id`: character.: Fox athlete id (from the player's contentUri).
#' * `stat`: character.: Stat column name (e.g. "yds", "td").
#' * `value`: character.: Stat value as displayed.
#'
#' @keywords Boxscore Data
#' @importFrom janitor clean_names make_clean_names
#' @importFrom tibble as_tibble
#' @export
#' @examples
#' \donttest{
#'   try(fox_cfb_boxscore(game_id = "41616"))
#' }
fox_cfb_boxscore <- function(game_id) {
  box_out <- data.frame()
  tryCatch(
    expr = {
      raw <- .fox_cfb_get(paste0("cfb/event/", game_id, "/data"))
      rows <- list()
      for (sec in .fox_or(raw[["boxscore"]][["boxscoreSections"]], list())) {
        team <- .fox_or(sec[["title"]], NA_character_)
        for (item in .fox_or(sec[["boxscoreItems"]], list())) {
          tbl <- item[["boxscoreTable"]]
          if (is.null(tbl)) next
          hdr <- .fox_cells(tbl[["headers"]][[1]][["columns"]])
          stat_group <- .fox_or(hdr[1], NA_character_)
          stat_names <- janitor::make_clean_names(.fox_or(hdr[-1], character(0)))
          for (r in .fox_or(tbl[["rows"]], list())) {
            cells <- .fox_cells(r[["columns"]])
            player <- .fox_or(cells[1], NA_character_)
            aid <- .fox_uri_id(.fox_or(r[["entityLink"]][["contentUri"]], NULL))
            vals <- cells[-1]
            for (j in seq_along(vals)) {
              rows[[length(rows) + 1]] <- data.frame(
                game_id = as.character(game_id), team = team, stat_group = stat_group,
                player = player, athlete_id = aid,
                stat = .fox_or(stat_names[j], paste0("v", j)), value = vals[j],
                stringsAsFactors = FALSE)
            }
          }
        }
      }
      box_out <- (if (length(rows)) do.call(rbind, rows) else data.frame()) |>
        tibble::as_tibble() |>
        janitor::clean_names() |>
        make_cfbfastR_data("Boxscore data from Fox Sports (Bifrost)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid game_id or no Fox boxscore data available!"))
    }
  )
  return(.attach_query_meta_auto(box_out))
}

#' **Get Fox Sports college football conference standings**
#'
#' Flattens the Bifrost `team/{id}/standings` conference table (the standings of
#' the given team's conference). Note: the league-wide `league/standings`
#' endpoint returns header-only tables, so this is keyed by team.
#'
#' @param team_id (character/numeric, required): Fox Bifrost team id (e.g. `"11"`).
#' @return A `cfbfastR`-tagged tibble with one row per team in the conference;
#'   columns are the standings headers (rank, team, `conf`, `w_l`, `home`,
#'   `away`, `pf`, `pa`, ...) plus `team_id`, `section` (conference), and
#'   `entity_id` (Fox team id). Column set varies with the standings template.
#'
#' @keywords Standings Data
#' @importFrom janitor clean_names
#' @importFrom tibble as_tibble
#' @importFrom dplyr bind_rows
#' @export
#' @examples
#' \donttest{
#'   try(fox_cfb_standings(team_id = "11"))
#' }
fox_cfb_standings <- function(team_id) {
  standings_out <- data.frame()
  tryCatch(
    expr = {
      raw <- .fox_cfb_get(paste0("cfb/team/", team_id, "/standings"))
      parts <- list()  # each section's `standings` is a LIST of tables
      for (s in .fox_or(raw[["standingsSections"]], list())) {
        for (tbl in .fox_or(s[["standings"]], list())) {
          parts[[length(parts) + 1]] <- .fox_table_df(
            tbl, extra = list(team_id = as.character(team_id),
                              section = .fox_or(s[["title"]], NA_character_)))
        }
      }
      standings_out <- dplyr::bind_rows(parts) |>
        tibble::as_tibble() |>
        janitor::clean_names() |>
        make_cfbfastR_data("Standings data from Fox Sports (Bifrost)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: no Fox standings data available!"))
    }
  )
  return(.attach_query_meta_auto(standings_out))
}

#' **Get Fox Sports college football team stat leaders**
#'
#' Flattens the Bifrost `team/{id}/stats` leaders sections.
#'
#' @param team_id (character/numeric, required): Fox Bifrost team id (e.g. `"11"`).
#' @return A `cfbfastR`-tagged tibble with one row per (category, leader):
#'
#' * `team_id`: character.: Fox team id echoed back.
#' * `category`: character.: Leader section title.
#' * `stat`: character.: Stat name (e.g. "Passing Yards").
#' * `stat_abbreviation`: character.: Stat abbreviation (e.g. "PYDS").
#' * `player`: character.: Leading player name.
#' * `value`: character.: Stat value as displayed.
#'
#' @keywords Stats Data
#' @importFrom janitor clean_names
#' @importFrom tibble as_tibble
#' @export
#' @examples
#' \donttest{
#'   try(fox_cfb_team_stats(team_id = "11"))
#' }
fox_cfb_team_stats <- function(team_id) {
  stats_out <- data.frame()
  tryCatch(
    expr = {
      raw <- .fox_cfb_get(paste0("cfb/team/", team_id, "/stats"))
      rows <- list()
      for (sec in .fox_or(raw[["leadersSections"]], list())) {
        cat_title <- .fox_or(sec[["title"]], NA_character_)
        for (ld in .fox_or(sec[["leaders"]], list())) {
          rows[[length(rows) + 1]] <- data.frame(
            team_id = as.character(team_id),
            category = cat_title,
            stat = .fox_or(ld[["title"]], NA_character_),
            stat_abbreviation = .fox_or(ld[["statAbbreviation"]], NA_character_),
            player = .fox_or(ld[["name"]], NA_character_),
            value = .fox_or(ld[["statValue"]], NA_character_),
            stringsAsFactors = FALSE)
        }
      }
      stats_out <- (if (length(rows)) do.call(rbind, rows) else data.frame()) |>
        tibble::as_tibble() |>
        janitor::clean_names() |>
        make_cfbfastR_data("Team stat leaders from Fox Sports (Bifrost)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid team_id or no Fox team stats available!"))
    }
  )
  return(.attach_query_meta_auto(stats_out))
}

#' **Get Fox Sports college football team game log**
#'
#' Flattens the Bifrost `team/{id}/gamelog` into one tidy, long row per
#' (game, stat-category, stat). The endpoint groups team per-game stats by
#' category (passing, rushing, defense, ...) and season-type split.
#'
#' @param team_id (character/numeric, required): Fox Bifrost team id (e.g. `"11"`).
#' @return A `cfbfastR`-tagged tibble with one row per (game, stat):
#'
#' * `team_id`: character.: Fox team id echoed back.
#' * `season_type`: character.: Split label ("REGULAR SEASON", "POSTSEASON").
#' * `category`: character.: Stat category ("passing", "rushing", "defense", ...).
#' * `game_id`: character.: Fox event id for the game.
#' * `game_date`: character.: Game date (M/D).
#' * `opponent`: character.: Opponent abbreviation ("@PITT").
#' * `stat`: character.: Stat column name (deduped; e.g. "yds", "yds_2").
#' * `value`: character.: Stat value as displayed.
#'
#' @keywords Schedule Data
#' @importFrom janitor clean_names make_clean_names
#' @importFrom tibble as_tibble
#' @export
#' @examples
#' \donttest{
#'   try(fox_cfb_team_gamelog(team_id = "11"))
#' }
fox_cfb_team_gamelog <- function(team_id) {
  gamelog_out <- data.frame()
  tryCatch(
    expr = {
      raw <- .fox_cfb_get(paste0("cfb/team/", team_id, "/gamelog"))
      rows <- list()
      for (sec in .fox_or(raw[["sectionList"]], list())) {
        category <- .fox_or(sec[["id"]], NA_character_)
        for (tbl in .fox_or(sec[["tables"]], list())) {
          hdr <- .fox_cells(tbl[["headers"]][[1]][["columns"]])
          season_type <- .fox_or(hdr[1], NA_character_)  # first header = split label
          stat_names <- janitor::make_clean_names(.fox_or(hdr[-(1:2)], character(0)))  # skip date+opp
          for (r in .fox_or(tbl[["rows"]], list())) {
            cells <- .fox_cells(r[["columns"]])
            gid <- .fox_uri_id(.fox_or(r[["entityLink"]][["contentUri"]], NULL))
            vals <- cells[-(1:2)]
            for (j in seq_along(vals)) {
              rows[[length(rows) + 1]] <- data.frame(
                team_id = as.character(team_id), season_type = season_type,
                category = category, game_id = gid,
                game_date = .fox_or(cells[1], NA_character_),
                opponent = .fox_or(cells[2], NA_character_),
                stat = .fox_or(stat_names[j], paste0("v", j)), value = vals[j],
                stringsAsFactors = FALSE)
            }
          }
        }
      }
      gamelog_out <- (if (length(rows)) do.call(rbind, rows) else data.frame()) |>
        tibble::as_tibble() |>
        janitor::clean_names() |>
        make_cfbfastR_data("Team game log from Fox Sports (Bifrost)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid team_id or no Fox game log available!"))
    }
  )
  return(.attach_query_meta_auto(gamelog_out))
}

#' **Get Fox Sports college football statistical leaders**
#'
#' Flattens a Bifrost `league/stats-con/{who}/{category}/{page}` leaderboard table.
#'
#' @param category (character): Stat category. One of `passing`, `rushing`,
#'   `receiving`, `defense`, `kicking`, `returning`, `scoring`, `yardage`
#'   (team adds `downs`, `turnovers`). Defaults to `"passing"`.
#' @param who (character): `"player"` or `"team"`. Defaults to `"player"`.
#' @param page (integer): 0-based page index. Defaults to `0`.
#' @param group_id (character): Conference/group filter id. Defaults to `"2"` (FBS).
#' @return A `cfbfastR`-tagged tibble with one row per player/team; columns are
#'   the leaderboard headers plus `entity_id`.
#'
#' @keywords Stats Data
#' @importFrom janitor clean_names
#' @importFrom tibble as_tibble
#' @importFrom dplyr bind_rows
#' @export
#' @examples
#' \donttest{
#'   try(fox_cfb_league_leaders(category = "passing"))
#' }
fox_cfb_league_leaders <- function(category = "passing", who = "player",
                                   page = 0, group_id = "2") {
  leaders_out <- data.frame()
  tryCatch(
    expr = {
      raw <- .fox_cfb_get(paste0("cfb/league/stats-con/", who, "/", category, "/", page),
                          query = list(groupId = group_id))
      parts <- lapply(.fox_or(raw[["sectionList"]], list()), function(s) .fox_table_df(s[["table"]]))
      leaders_out <- dplyr::bind_rows(parts) |>
        tibble::as_tibble() |>
        janitor::clean_names() |>
        make_cfbfastR_data("Statistical leaders from Fox Sports (Bifrost)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid arguments or no Fox leaders available!"))
    }
  )
  return(.attach_query_meta_auto(leaders_out))
}

#' **Get Fox Sports college football game odds**
#'
#' Flattens the Bifrost `event/{id}/odds` matchup six-pack (spread / to win / total).
#'
#' @param game_id (character/numeric, required): Fox Bifrost event id (e.g. `"41616"`).
#' @return A `cfbfastR`-tagged tibble with one row per team:
#'
#' * `game_id`: character.: Fox event id echoed back.
#' * `team`: character.: Team full name.
#' * `spread`: character.: Point spread.
#' * `to_win`: character.: Moneyline ("to win").
#' * `total`: character.: Over/under total.
#'
#' Returns an empty tibble when no market is posted for the game.
#'
#' @keywords Odds Data
#' @importFrom janitor clean_names make_clean_names
#' @importFrom tibble as_tibble
#' @export
#' @examples
#' \donttest{
#'   try(fox_cfb_odds(game_id = "41616"))
#' }
fox_cfb_odds <- function(game_id) {
  odds_out <- data.frame()
  tryCatch(
    expr = {
      raw <- .fox_cfb_get(paste0("cfb/event/", game_id, "/odds"))
      sp <- raw[["sixPack"]]
      o <- if (is.null(sp)) NULL else sp[["odds"]]
      rows <- list()
      if (!is.null(o)) {
        hdr <- janitor::make_clean_names(.fox_cells(o[["columnHeaders"]]))
        for (r in .fox_or(o[["rows"]], list())) {
          vals <- vapply(.fox_or(r[["values"]], list()),
                         function(v) .fox_or(v[["odds"]], NA_character_) |> as.character(),
                         character(1))
          rec <- as.list(vals)
          names(rec) <- hdr[seq_along(rec)]
          rows[[length(rows) + 1]] <- data.frame(
            game_id = as.character(game_id),
            team = .fox_or(r[["fullText"]], .fox_or(r[["text"]], NA_character_)),
            as.data.frame(rec, stringsAsFactors = FALSE),
            stringsAsFactors = FALSE)
        }
      }
      odds_out <- (if (length(rows)) dplyr::bind_rows(rows) else data.frame()) |>
        tibble::as_tibble() |>
        janitor::clean_names() |>
        make_cfbfastR_data("Game odds from Fox Sports (Bifrost)", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid game_id or no Fox odds available!"))
    }
  )
  return(.attach_query_meta_auto(odds_out))
}
