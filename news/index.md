# Changelog

## **cfbfastR v2.3.0**

This release adds a 65-function ESPN college-football API layer,
expanding `cfbfastR`’s ESPN surface from 8 wrappers to 73. The new
wrappers expose ESPN’s core-v2 endpoints in ESPN’s own ID space —
complementary to the CollegeFootballData (`cfbd_*`) wrappers, and the
natural join partners for
[`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
/
[`espn_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.md).
Every wrapper was verified live against the 2023, 2024, and 2025
seasons.

**Naming alignment with the sportsdataverse convention (this dev cycle,
never on CRAN):** `espn_cfb_player_statistics()` is renamed to
[`espn_cfb_player_career_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_career_stats.md)
(the core-v2 `/athletes/{id}/statistics` career view, matching
hoopR/wehoop/sportsdataverse-py). New
[`espn_cfb_player_stats_v3()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats_v3.md)
wraps the comprehensive web-common-v3 `/athletes/{id}/stats` payload
(all categories, long format) — the `_v3` companion to
[`espn_cfb_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats.md)
(core-v2 season statistics).

#### New Fox Sports API wrappers (`fox_cfb_*`)

A read-only Fox Sports “Bifrost” college-football layer
(`api.foxsports.com/bifrost/v1/cfb/*`), complementary to the
`espn_cfb_*` and `cfbd_*` families. Eight wrappers flatten Fox’s
layout-oriented JSON (sections → tables → rows → cells) into tidy
`cfbfastR`-tagged tibbles. Reverse-engineering notes and an OpenAPI 3.1
spec live in the `sdv-internal-refs` repo. Verified live against the
2025 season.

- [`fox_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_pbp.md)
  — game play-by-play (quarters → drives → plays), one row per play.
- [`fox_cfb_boxscore()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_boxscore.md)
  — per-team player stat tables, tidy long (one row per player-stat).
- [`fox_cfb_odds()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_odds.md)
  — matchup six-pack (spread / to-win / total) per team.
- [`fox_cfb_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_team_roster.md)
  — roster by position group, one row per player.
- [`fox_cfb_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_team_stats.md)
  — team stat leaders by category.
- [`fox_cfb_team_gamelog()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_team_gamelog.md)
  — per-game team stats, tidy long (game × category × stat), each game
  keyed to its Fox event id.
- [`fox_cfb_standings()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_standings.md)
  — a team’s conference standings table.
- [`fox_cfb_league_leaders()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_league_leaders.md)
  — statistical leaderboards by category (`stats-con`).

#### New ESPN wrappers — football-specific metrics

- [`espn_cfb_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_powerindex.md)
  — ESPN’s College Football Power Index (FPI): every predictive metric
  and efficiency component, in long format.
- [`espn_cfb_qbr()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_qbr.md)
  — Total Quarterback Rating (QBR) and the full set of clutch-weighted
  EPA components, one row per qualified passer.
- [`espn_cfb_futures()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_futures.md)
  — the season betting-futures board (national championship, conference,
  and award markets) with each sportsbook’s American odds.
- [`espn_cfb_recruits()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_recruits.md)
  — ESPN’s recruiting board for a class, one row per recruit with grade,
  position/state/region rank, committed school, and hometown.

#### New ESPN wrappers — players

- [`espn_cfb_players()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_players.md),
  [`espn_cfb_player()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player.md),
  [`espn_cfb_player_eventlog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_eventlog.md),
  [`espn_cfb_player_gamelog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_gamelog.md),
  `espn_cfb_player_statistics()`,
  [`espn_cfb_player_splits()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_splits.md),
  [`espn_cfb_player_overview()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_overview.md),
  and
  [`espn_cfb_player_seasons()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_seasons.md)
  — player index, biographical detail, per-game logs, season statistics,
  and split breakdowns. The season-level wrappers resolve `athlete_id`
  to human-readable name/position columns via an `athlete_detail`
  argument.

#### New ESPN wrappers — teams

- [`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md),
  [`espn_cfb_team()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team.md),
  [`espn_cfb_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_roster.md),
  [`espn_cfb_team_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_schedule.md),
  [`espn_cfb_team_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_record.md),
  and
  [`espn_cfb_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_leaders.md)
  — team index, team-in-season detail, roster, schedule, records, and
  statistical leaders.
- [`espn_cfb_team_ats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_ats.md),
  [`espn_cfb_team_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_powerindex.md),
  [`espn_cfb_team_events()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_events.md),
  [`espn_cfb_team_ranks()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_ranks.md),
  [`espn_cfb_team_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_awards.md),
  and
  [`espn_cfb_team_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_coaches.md)
  — team against-the-spread records, single-team power index, season
  event log, poll-rank history, player awards, and coaching staff.

#### New ESPN wrappers — game detail

- [`espn_cfb_game_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_teams.md),
  [`espn_cfb_game_team_linescores()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_linescores.md),
  [`espn_cfb_game_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_leaders.md),
  [`espn_cfb_game_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_roster.md),
  [`espn_cfb_game_team_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_statistics.md),
  and
  [`espn_cfb_game_team_records()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_records.md)
  — per-game team breakdowns.
- [`espn_cfb_game_odds()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_odds.md),
  [`espn_cfb_game_broadcasts()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_broadcasts.md),
  [`espn_cfb_game_predictor()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_predictor.md),
  [`espn_cfb_game_probabilities()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_probabilities.md),
  [`espn_cfb_game_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_powerindex.md),
  and
  [`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
  — per-game odds, broadcasts, pre-game predictor, live win-probability,
  matchup power index, and play-by-play.
- [`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md),
  [`espn_cfb_game_drive_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drive_plays.md),
  [`espn_cfb_game_play()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_play.md),
  [`espn_cfb_game_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_leaders.md),
  [`espn_cfb_game_situation()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_situation.md),
  [`espn_cfb_game_status()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_status.md),
  [`espn_cfb_game_player_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_player_statistics.md),
  and
  [`espn_cfb_game_player_box()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_player_box.md)
  — drive log, drive-scoped plays, single-play detail, game statistical
  leaders, situation, status, and per-player game box lines.
- The play-level wrappers
  ([`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md),
  [`espn_cfb_game_drive_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drive_plays.md),
  [`espn_cfb_game_play()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_play.md))
  extract every field ESPN returns for a play and expose its nested
  child collections through opt-in parameters: `participants`
  (`"none"`/`"wide"`/`"long"`) and `participants_list` surface per-play
  athlete involvement (passer, rusher, tackler, …), and
  `team_participants` / `team_participants_list` surface the
  offense/defense team participants — `"wide"` modes pivot to one row
  per play, the `*_list` flags keep the raw detail as a list-column.
- `espn_cfb_game_team_records(detail = TRUE)` unpacks each record’s full
  statistic breakdown; `espn_cfb_game_odds(line_history = TRUE)` returns
  the open/close/current line-movement history. Roster and player-stats
  wrappers join ESPN position-catalog detail when
  `position_detail = TRUE`.
- [`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)
  gains a `plays` argument — `"list"` nests each drive’s plays (full
  play-by-play schema, with the participant pass-through options) as a
  list-column, `"expand"` returns the flat one-row-per-play table with
  `drive_*` context columns. The new
  [`espn_cfb_unnest_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_unnest_plays.md)
  performs the same drives-to-play-by-play transform on an
  already-fetched nested frame.
- The game wrappers join human-readable team detail when
  `team_detail = TRUE` (default): every team-id column (`team_id`,
  `home_team_id`, `start_team_id`, `leader_team_id`, …) gains sibling
  `*_name`, `*_abbreviation`, `*_location`, `*_display_name`, `*_color`,
  `*_logo_href`, … columns from the ESPN team catalog.
  `espn_cfb_game_teams(format = "wide")` collapses the two competitor
  rows into a single per-game row with `home_*` / `away_*` columns for
  direct joining onto one-row-per-game tables.
- [`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md)
  — a core-v2-sourced successor to
  [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md):
  assembles play-by-play in one structured request (vs. the legacy
  site-v2 summary parse) and, with `epa_wpa = TRUE`, runs cfbfastR’s
  full EPA/WPA model pipeline — producing EPA/WPA columns identical to
  the legacy modeled feed.

#### New ESPN wrappers — catalogs and season metadata

- [`espn_cfb_seasons()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_seasons.md),
  [`espn_cfb_season_info()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_info.md),
  [`espn_cfb_season_types()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_types.md),
  [`espn_cfb_season_weeks()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_weeks.md),
  [`espn_cfb_groups()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_groups.md),
  and
  [`espn_cfb_standings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_standings.md)
  — season structure, conferences, and standings.
- [`espn_cfb_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coaches.md),
  [`espn_cfb_coach()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach.md),
  [`espn_cfb_venues()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venues.md),
  [`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md),
  [`espn_cfb_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_awards.md),
  [`espn_cfb_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_rankings.md),
  and
  [`espn_cfb_week_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_week_rankings.md)
  — league catalogs and poll rankings.
- [`espn_cfb_coach_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach_record.md),
  [`espn_cfb_franchises()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchises.md),
  [`espn_cfb_franchise()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchise.md),
  [`espn_cfb_venue()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venue.md),
  [`espn_cfb_position()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_position.md),
  and
  [`espn_cfb_award()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_award.md)
  — coach season win/loss records, the league franchise catalog, and
  single-record venue / position / award detail.

#### New CollegeFootballData wrappers

- [`cfbd_betting_ats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_ats.md)
  — season against-the-spread (ATS) summary records by team, wrapping
  the CollegeFootballData `/teams/ats` endpoint.
- [`cfbd_stats_game_havoc()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_havoc.md)
  — per-game havoc statistics (total / front-seven / defensive-back
  havoc events and rates, offense and defense), wrapping the
  CollegeFootballData `/stats/game/havoc` endpoint.
- [`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md)
  is a new public function: a modular successor to
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
  that runs the same EPA/WPA pipeline through a single shared engine
  (`.run_epa_wpa()`) and a canonical play-type taxonomy
  (`.pbp_play_types()`). The legacy
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
  is unchanged.
- [`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md)
  now sources play-by-play and meta through the shared engine, requests
  `participants = "wide"` and `team_participants = "wide"` from
  [`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md),
  and adds the meta columns `home_team_name`, `home_team_color`,
  `home_team_alternate_color`, `home_team_rank` (and `away_*`) via the
  new `.espn_pbp_game_meta()` bridge. Output is a strict superset of
  legacy
  [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
  on the meta columns.

#### Bug fixes

- [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
  now builds its request URL with the `?event=` query separator
  (previously concatenated as `summaryevent=`, which returned HTTP 404
  for every game) and initializes its return frame before the `tryCatch`
  so an upstream failure no longer throws `object 'plays_df' not found`.
- [`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md)
  and
  [`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md)
  preserve character `id_play` precision through the EPA/WPA pipeline.
  The legacy shared helper used unquoted numeric literals in two
  `ifelse` calls (a historical `id_play` swap for one game), which
  silently coerced character `id_play` to numeric and then lost
  precision past 2^53 — breaking the play-id join-back in
  [`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md).
  The modular `.pbp_clean_pbp_dat()` quotes those literals so `id_play`
  stays character; the legacy
  [`clean_pbp_dat()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)
  is unchanged.

#### Internal changes

- **httr -\> httr2 migration.** cfbfastR’s HTTP layer now uses the
  modern `httr2` package (\>= 1.0.0) instead of the legacy `httr`. End
  users running existing wrapper calls (`cfbd_*`, `espn_cfb_*`) should
  see no behavioural change – the migration is internal. Custom code
  that calls `get_req()` or `check_status()` directly must update from
  `httr::content(res, as = "text")` to `httr2::resp_body_string(res)`
  and from `httr::status_code(res)` to `httr2::resp_status(res)`.
- **Proxy support.** `get_req()` now resolves a proxy in the order:
  explicit `proxy` argument -\> `getOption("cfbfastR.proxy")` -\>
  `http_proxy` / `https_proxy` env vars. The proxy value accepts either
  a URL string or a named list with `url` / `port` / `username` /
  `password` / `auth` for authenticated proxies.
- **Dependency footprint trimmed.** `lubridate`, `progressr`, `memoise`,
  `cachem`, and `magrittr` have moved out of `Imports` (21 -\> 16).
  `lubridate` is gone entirely – its two `ymd_hm() |> with_tz()` calls
  in `espn_cfb_schedule.R` are now base-R
  `as.POSIXct(format = "%Y-%m-%dT%H:%M", tz = "UTC")` +
  `attr(., "tzone")`. `progressr`, `memoise`, and `cachem` moved to
  `Suggests` and the helpers degrade gracefully when missing:
  [`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md)
  /
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
  / `pbp_epa_wpa_engine()` run without a progress bar when `progressr`
  is absent; ESPN catalog wrappers run uncached when `memoise` /
  `cachem` are absent
  ([`espn_cfb_clear_cache()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_clear_cache.md)
  becomes a no-op). Drops the `Imports` count below the \>20
  `R CMD check` NOTE threshold.
- **Native pipe migration.** All 1,419 `%>%` chains in `R/`, plus 137
  across `vignettes/` and `tests/`, were converted to the base-R native
  pipe `|>`. `magrittr` is no longer an `Imports`; downstream consumers
  that load `cfbfastR` purely for its functions don’t get `%>%`
  re-exported anymore. User-visible impact is minimal – the public API
  is unchanged and `dplyr` (which is in `Imports`) still re-exports
  `%>%` for users who want to keep writing it. Two non-mechanical fixes
  were needed during the sweep: three `|> [[("url")` chains in
  `cfbd_betting.R` and `cfbd_coaches.R` (rejected as RHS in R 4.1’s
  `|>`) became `|> purrr::pluck("url")`; seven
  `|> tibble::tibble(col = .data$.)` constructs were a magrittr quirk
  that silently duplicated the LHS into both a `.` and the named column
  – rewritten to `tibble::tibble(col = <lhs>)`, which drops the
  redundant `.` column.
- **Test-time CFBD throttle.** A new
  `tests/testthat/setup-cfbd-throttle.R` adds a 1-second sleep before
  every CFBD request made by `devtools::test()` / `R CMD check`. It
  works by monkey-patching `cfbfastR:::get_req()` for the duration of
  the test session (restored via `withr::defer(., teardown_env())`) –
  the package code is unchanged, so interactive and production calls pay
  no penalty. Tunable via `options(cfbfastR.test_request_delay = N)`
  (default 1; set to 0 for unthrottled local runs). Resolves the
  cascading `HTTP 429` skip-if-empty results that were turning
  otherwise-green test runs into “all green, mostly skipped.” `withr`
  joins `Suggests` to declare the test-side dependency cleanly (it was
  already a transitive dep of `testthat`).

## **cfbfastR v2.2.0**

- Fixes a bug in `validate_week()` utility function where some inputs
  were not being handled correctly (i.e. week 16). Fixes trickle down to
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
  and other functions.
- Default value for `season_type` parameter in
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  and
  [`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md)
  function changed from “regular” to “both” to align with other
  functions in the package.

## **cfbfastR v2.1.0**

- Fixes a bug in
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
  where play-by-play data for some games were not as expected.
- Improves
  [`add_yardage()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)
  where plays with missing yardage values were not being handled
  correctly.

## **cfbfastR v2.0.0**

CRAN release: 2025-09-09

#### Breaking Changes to Loading Functions

- All `load_cfb_*()` functions now use [`sportsdataverse-data`
  releases](https://github.com/sportsdataverse/sportsdataverse-data/releases/tag/cfbfastR_cfb_pbp)
  or the [CollegeFootballData.com
  API](https://api.collegefootballdata.com/) as their underlying data
  source to remain in compliance with CFBD API terms and conditions (See
  **Note** below).
- Updated
  [`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md)
  dataset to include various team- and game-level ID’s and flags that
  were not being included, like `home_team_id`, `away_team_id`,
  `season_type`, `venue_id`, some `drive_*` columns, a half-dozen player
  stat columns, etc. Essentially, all the leg-work users have
  undoubtedly had to do while using these datasets is mostly just
  included now. **The downside:** this means end users need to check
  their pipelines which build off these datasets to ensure behavior is
  as expected and all your joins are doing what is intended.

#### Now upgraded to the CFBD v2 API

*Special thanks are in order for our newest contributor, Brad Hill
([@bradisbrad](https://github.com/bradisbrad)) for providing most of the
v2 upgrade via his first PR to
[cfbfastR](https://cfbfastr.sportsdataverse.org/)!! 🙌🏽 👑 🥇 Your
contributions are most appreciated by the community.*

**Note: The [free-tier API
key](https://collegefootballdata.com/api-tiers) for the CFBD v2 API has
a strict 1k calls/month limit, so plan your workflows accordingly! If
you receive errors mentioning `r Request failed [429]`, you have most
likely run out of API calls for the month in your membership tier.**

- Added all new `cfbd_*()` functions accommodated by the new College
  Football Data API v2. This includes the following functions:

  - Added
    [`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.html)
    function to access the new field goal expected points added metric
    from the API.
  - Added
    [`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.html)
    function to access the new opponent adjusted team season predicted
    points added metric from the API.
  - Added
    [`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.html)
    function to access the new opponent adjusted players passing
    predicted points added metric from the API.
  - Added
    [`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.html)
    function to access the new opponent adjusted players rushing
    predicted points added metric from the API.
  - Added
    [`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.html)
    function to access the new Points Added Above Replacement (PAAR)
    ratings for kickers from the API.
  - Added
    [`cfbd_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_fpi.html)
    function to access the new FPI ratings from the API.
  - Added
    [`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.html)
    function to access live scoreboard data from the API.
  - Added
    [`cfbd_live_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.html)
    function to access live play-by-play data from the API.
  - Added
    [`cfbd_api_key_info()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.html)
    function to get information about your API key, including your
    Patreon level and usage limits.

- Minor changes to the existing `cfbd_*()` functions under the hood to
  accommodate the new API v2 structure. Please see below for a list of
  all updated functions:

  - Updated
    [`cfbd_betting_lines()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_lines.html)
    function
  - Updated
    [`cfbd_coaches()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.html)
    function
  - Updated
    [`cfbd_conferences()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conferences.html)
    function
  - Updated
    [`cfbd_drives()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_drives.html)
    function
  - Updated
    [`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.html)
    function
  - Updated
    [`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.html)
    function
  - Updated
    [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.html)
    function
  - Updated
    [`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.html)
    function
  - Updated
    [`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.html)
    function
  - Updated
    [`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.html)
    function
  - Updated
    [`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.html)
    function
  - Updated
    [`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.html)
    function
  - Updated
    [`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.html)
    function
  - Updated
    [`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.html)
    function
  - Updated
    [`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.html)
    function
  - Updated
    [`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.html)
    function
  - Updated
    [`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.html)
    function
  - Updated
    [`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.html)
    function
  - Updated
    [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html)
    function
  - Updated
    [`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.html)
    function
  - Updated
    [`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.html)
    function
  - Updated
    [`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.html)
    function
  - Updated
    [`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.html)
    function
  - Updated
    [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.html)
    function
  - Updated
    [`cfbd_player_returning()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_returning.html)
    function
  - Updated
    [`cfbd_player_usage()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.html)
    function
  - Updated
    [`cfbd_rankings()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rankings.html)
    function
  - Updated
    [`cfbd_ratings_sp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp.html)
    function
  - Updated
    [`cfbd_ratings_sp_conference()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp_conference.html)
    function
  - Updated
    [`cfbd_ratings_srs()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs.html)
    function
  - Updated
    [`cfbd_recruiting_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.html)
    function
  - Updated
    [`cfbd_recruiting_position()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_position.html)
    function
  - Updated
    [`cfbd_recruiting_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_team.html)
    function
  - Updated
    [`cfbd_stats_categories()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_categories.html)
    function
  - Updated
    [`cfbd_stats_game_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.html)
    function
  - Updated
    [`cfbd_stats_season_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_advanced.html)
    function
  - Updated
    [`cfbd_stats_season_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.html)
    function
  - Updated
    [`cfbd_stats_season_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_team.html)
    function
  - Updated
    [`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.html)
    function
  - Updated
    [`cfbd_team_matchup()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup.html)
    function
  - Updated
    [`cfbd_team_matchup_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup_records.html)
    function
  - Updated
    [`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.html)
    function
  - Updated
    [`cfbd_team_talent()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_talent.html)
    function
  - Updated
    [`cfbd_venues()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_venues.html)
    function

- Fixed the following functions and/or documentation:

  - Documentation
    [`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.html)
    addressing
    [\#97](https://github.com/sportsdataverse/cfbfastR/issues/97)
  - Ensuring
    [`cfbd_stats_game_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.html)
    returns an empty data frame when there are no results
  - Documentation
    [`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.html)
    updated to reflect all parameter requirement scenarios.
  - Fixed `athlete_id` parameter
    [`cfbd_player_usage()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.html)
    so that it works as users would expect. There was an API
    query-parameter mismatch
  - Fixed `athlete_id` parameter for
    [`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.html)
    function and added more thorough documentation.
  - Fixed returned `position` to correct value (instead of NA) from
    [`cfbd_stats_season_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.html)
  - Added more thorough `season_type` parameter documentation across
    many functions
  - Changed behavior of
    [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html)
    to substitute 3 timeouts per half when the data is missing from the
    API.

## **cfbfastR v1.9.5**

- fixed breaking bug related to `stringi` v1.8 update in
  [`cfbd_play_pbp_data()`](https://cfbfastr.sportsdataverse.org/reference/cfbd_pbp_data.html)
  EPA and WPA processing
- Minor documentation and test updates

## **cfbfastR v1.9.4**

- Improve date parsing for
  [`espn_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.html)
  and
  [`espn_cfb_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_schedule.html)
  functions while adding `lubridate` dependency
- Made a minor tweak to the returns of the
  [`espn_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html)
  function

## **cfbfastR v1.9.3**

- Add division parameter to the following functions:
  - [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.html)
  - [`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.html)
  - [`cfbd_drives()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_drives.html)
  - [`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.html)
  - [`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.html)

## **cfbfastR v1.9.2**

- [`espn_cfb_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats.html)
  function added.

## **cfbfastR v1.9.1**

- Improved drive_pts logic in play-by-play data.
- Fixed an issue that occasionally made the
  [`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md)
  function return data in a long format
- Minor documentation and test updates

## **cfbfastR v1.9.0**

CRAN release: 2022-06-13

##### Added functions to access ESPN API:

- [`espn_cfb_calendar()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_calendar.html)
- [`espn_cfb_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.html)
- Added EPA and WPA processing to
  [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.html)
- [`espn_cfb_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_stats.html)

##### Added functions to pull data from the data repo:

- [`load_cfb_rosters()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_rosters.html)

- [`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.html)

- [`load_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_teams.html)

- Removes `furrr`, `future` dependencies, adds `Rcpp`, `RcppParallel`,
  and `purrr` dependencies

## **cfbfastR v1.8.0**

- All functions now default to return tibbles.
- Added S3 method to print outputs with data info and retrieval
  timestamps. Thank you to Tan Ho
  ([@tanho36](https://github.com/tanho63)) for the idea.

## **cfbfastR v1.7.1**

- Added
  [`espn_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html)
  to exports.

## **cfbfastR v1.7.0**

- Added
  [`cfbd_recruiting_transfer_portal()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_transfer_portal.html).

## **cfbfastR v1.6.7**

- Fixed bug in
  [`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md)
  with \_allowed columns duplicating team stats instead of showing
  opponent stats.
- Updated tests and documentation for
  [`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md).

## **cfbfastR v1.6.6**

- Updated function
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
  to account for additional timeout cases (namely, kickoffs/extra point
  attempts).

## **cfbfastR v1.6.5**

- Updated tests and documentation for
  [`cfbd_betting_lines()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_lines.md)
- API call in
  [`espn_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.md)
  now requires headers in httr request

## **cfbfastR v1.6.4**

CRAN release: 2021-10-27

- Changed options to revert to old options on exit of function.
- Removed check_github functions.

## **cfbfastR v1.6.3**

- Switched package urls in DESCRIPTION again.

## **cfbfastR v1.6.2**

- Switched package urls in README and DESCRIPTION files to <https://>

## **cfbfastR v1.6.1**

- Removed source urls from many package documentation entries.
- Updated a test to skip on CRAN

## **cfbfastR v1.6.0**

- Added
  [`cfbd_ratings_elo()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_elo.html)
  function
- Fixed a bug in
  [`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md)
  where the function failed when trying to load recent games from the
  data repo.
  ([\#35](https://github.com/sportsdataverse/cfbfastR/issues/35))
- Added the option `cfbfastR.dbdirectory` that allows to set the
  database directory in
  [`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md)
  globally.

## **cfbfastR v1.5.2**

- Remove verbose parameter

## **cfbfastR v1.5.1**

###### **Minor release**

- Removed calculated columns from
  [`cfbd_stats_season_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_team.md)
  that were not behaving correctly
- Fixed bug where `only_fbs` input in
  [`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md)
  was ignored. It is now possible to get the team info for all the
  colleges in the API instead of only FBS schools.
- Removed default year from `cfbd_metrics_ppa_teams`.
  `cfbd_metrics_ppa_teams` and `cfbd_metrics_ppa_players_season` now
  require one of `team` or `year` to be specified

## **cfbfastR v1.5.0**

#### Added [`espn_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.html)

#### Added [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.html)

## **cfbfastR v1.4.0**

#### Added [`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.html)

## **cfbfastR v1.3.3**

#### Hotfix [`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.html)

## **cfbfastR v1.3.2**

#### Added ID linking to [`cfbd_recruiting_players()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.html)

## **cfbfastR v1.3.0-1**

#### Added three [NFL draft](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft.html) functions:

- [`cfbd_draft_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_teams.html) -
  **Get list of NFL teams**
- [`cfbd_draft_positions()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_positions.html) -
  **Get list of NFL positions for mapping to collegiate**
- [`cfbd_draft_picks()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_picks.html) -
  **Get list of NFL Draft picks**

## **cfbfastR v1.2.1**

###### **Minor release**

- Added headshot_url to outputs of
  [`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.html)

- Renamed returns in
  [`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.html):

  - `rushing_line_yd_avg` to plural `rushing_line_yds_avg`
  - `rushing_second_lvl_yd_avg` to plural `rushing_second_lvl_yds_avg`
  - `rushing_open_field_yd_avg` to plural `rushing_open_field_yds_avg`

- Completed documentation for all returns except
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)

- Continued work on intro vignette

## **cfbfastR v1.2.0-1**

##### **Add significant documentation to the package**

- Added mini-vignettes pertaining to CFB Data functionality:
  - [`cfbd_betting`](https://cfbfastR.sportsdataverse.org/articles/cfbd_betting.html),
  - [`cfbd_games`](https://cfbfastR.sportsdataverse.org/articles/cfbd_games.html),
  - [`cfbd_plays`](https://cfbfastR.sportsdataverse.org/articles/cfbd_plays.html),
  - [`cfbd_recruiting`](https://cfbfastR.sportsdataverse.org/articles/cfbd_recruiting.html),
  - [`cfbd_stats`](https://cfbfastR.sportsdataverse.org/articles/cfbd_stats.html),
  - [`cfbd_teams`](https://cfbfastR.sportsdataverse.org/articles/cfbd_teams.html)
- [Introductory vignette
  stub](https://cfbfastR.sportsdataverse.org/articles/intro.html) added

##### **ESPN/CFBD metrics function variable return standardization**

- Change `id` variable to `team_id` in
  [`espn_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html)
- Changed `espn_game_id` variable to `game_id` in
  [`espn_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/espn_metrics.html),
  corrected the `away_win_percentage` calculation and added
  `tie_percentage` to the returns.
- Change `id` variable to `athlete_id` in
  [`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.html)

## **cfbfastR v1.1.0**

##### **Add loading from Data Repository functionality**

- Added
  [`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.html)
  and
  [`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.html)
  functions. Pretty much cherry-picking the `nflfastR` methodology of
  loading data from the
  [`cfbfastR-data`](https://github.com/sportsdataverse/cfbfastR-data)
  repository.

##### **Add support for parallel processing and progress updates**

- Added [`furrr`](https://furrr.futureverse.org/index.html),
  [`future`](https://future.futureverse.org/), and
  [`progressr`](https://progressr.futureverse.org/) dependencies to the
  package to allow for parallel processing of the play-by-play data with
  progress updates if desired.

## **cfbfastR v1.0.0**

##### **Function Naming Convention Change**

- All functions sourced from the College Football Data API will start
  with `cfbd_` as opposed to `cfb_` (as in cfbscrapR). One additional
  `cfbd_` function has been added that corresponds to the result when
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html)
  has the parameter `epa_wpa=FALSE`. It has now been separated into its
  own function for clarity
  [`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play.html).
  The parameter and functionality still exists in
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html)
  but we expect this function will still exist but made obsolete in
  favor of a function more closely matching `nflfastR`’s naming
  conventions.

- Similarly, data and metrics sourced from ESPN will begin with `espn_`
  as opposed to `cfb_`. In particular, the two functions are now
  [`espn_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html)
  and
  [`espn_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/espn_metrics.html)

- Data generated from any of the `cfbfastR` methods will use `cfb_`

##### **College Football Data API Keys**

The [CollegeFootballData API](https://collegefootballdata.com/) now
requires an API key, here’s a quick run-down:

- To get an API key, follow the directions here: [College Football Data
  Key Registration.](https://collegefootballdata.com/key)

- Using the key: You can save the key for consistent usage by adding
  `CFBD_API_KEY=XXXX-YOUR-API-KEY-HERE-XXXXX` to your .Renviron file
  (easily accessed via
  [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)).
  Run
  [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html),
  a new script will pop open named `.Renviron`, **THEN** paste the
  following in the new script that pops up (with**out** quotations)

``` r

CFBD_API_KEY = XXXX-YOUR-API-KEY-HERE-XXXXX
```

Save the script and restart your RStudio session, by clicking `Session`
(in between `Plots` and `Build`) and click `Restart R` (n.b. there also
exists the shortcut `Ctrl + Shift + F10` to restart your session). If
set correctly, from then on you should be able to use any of the `cfbd_`
functions without any other changes.

- For less consistent usage: At the beginning of every session or within
  an R environment, save your API key as the environment variable
  `CFBD_API_KEY` (with quotations) using a command like the following.

`{r} Sys.setenv(CFBD_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")`

- Added [API Key
  methods](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.html).
  If you forget to set your environment variable, functions will give
  you a warning and ask for one.
