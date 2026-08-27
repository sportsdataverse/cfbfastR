# **cfbfastR (development version)**

### Expected Points model now comes from the shared `cfb_model_artifacts` bundle

The EP model is now the XGBoost artifact published in
[`cfb_model_artifacts`](https://github.com/sportsdataverse/sportsdataverse-data/releases/tag/cfb_model_artifacts)
— **the same artifact `sportsdataverse-py` scores with**, so both libraries
agree on EPA for a given play and a retrain updates both from one publish
([#138](https://github.com/sportsdataverse/cfbfastR/issues/138)).

* **Fixes [#5](https://github.com/sportsdataverse/cfbfastR/issues/5)** — `epa_wpa = TRUE`
  no longer aborts with `predict.nnet(): missing values in 'x'` on mid-era CFBD
  data (seasons ~2006–2013), in either engine.
* EP scoring is consolidated behind one internal helper, so the seven
  next-score probability columns keep their historical names and order and no
  downstream code changed. **The bundle's class order differs from the retired
  model's** with no fixed point between them; the permutation is read from the
  bundle's `MANIFEST.json` and asserted in tests, because getting it wrong
  yields EP that is wrong yet plausible-looking.
* Model artifacts are cached under the package cache dir and refreshed on the
  `cfbfastR.cache_duration` TTL (default 24h), so a republished model is picked
  up without a package update. An expired cached copy is still used if the
  release is unreachable.
* `xgboost` (Suggests) is now required to score EP and its floor moved to
  `>= 1.7` for `.ubj` support. Without it — or offline with no cached copy —
  the retired `nnet` model is loaded as a fallback and still works.
* The **Win Probability** model moved to the bundle's `wp_naive.ubj` on the
  same terms. Eleven of its twelve features already existed on the frame; only
  `is_home` is derived.
* The **Field Goal** model moved to the bundle's era-aware `fg_model.ubj`
  (`yards_to_goal` + one-hot `era0..era3`). `season` is now threaded through
  `.run_epa_wpa()` and the exported `create_epa()` / `epa_fg_probs()` gain a
  `season` argument (defaulting to `NULL`). Scoring the era-aware model
  without a season is an error rather than a silent all-zero one-hot.
* **New: completion probability.** `cp` and `cpoe` columns are added on pass
  plays, `cpoe` on the percentage-point scale `100 * (completion - cp)`,
  matching `sportsdataverse-py`. The model loads lazily on first use and the
  stage degrades to `NA` columns rather than failing.
* Existing EPA/WPA values **will change**: this is a different model
  generation. Rebuild rather than mixing old and new outputs in one dataset.

# **cfbfastR v3.0.0**

### New release-dataset loaders (39 functions)

`cfbfastR` now loads every published CFB dataset on the
[sportsdataverse-data](https://github.com/sportsdataverse/sportsdataverse-data/releases)
release repo, closing the gap with `sportsdataverse-py`'s loader surface. All
loaders return `cfbfastR_data`-tagged tibbles, accept `seasons = TRUE` for the
full published range, and support the `dbConnection`/`tablename` database
write-through.

* `load_espn_cfb_*()` — 27 loaders for the ESPN-derived family: `pbp`,
  `schedules`, `team_box`, `player_box`, `drives`, `game_rosters`,
  `linescores`, `betting`, `play_participants`, `power_index`, `percentiles`,
  `passing`, `rushing`, `receiving`, `team_summaries`, `model_pbp`, and the
  eleven `adv_*` advanced-stats datasets.
* `load_cfb_ratings()`, `load_cfb_ratings_weekly()`, `load_cfb_fpi_weekly()`,
  `load_cfb_team_summaries_weekly()`, `load_cfb_team_talent()`,
  `load_cfb_recruits()`, `load_cfb_recruiting_proj()`,
  `load_cfb_returning_production()` — season/weekly ratings, talent, and
  recruiting datasets.
* `load_cfb_schedule_crosswalk()`, `load_cfb_teams_crosswalk()`,
  `load_cfb_rosters_crosswalk()` — CFBD/ESPN id crosswalks.
* `load_ncaa_mfb_*()` — 10 loaders for the stats.ncaa.org men's football
  family (covers FCS and lower divisions): `pbp`, `pbp_cfbfastr` (the
  cfbfastR-schema-shaped variant), `drives`, `linescore`, `officials`,
  `player_stats`, `rosters`, `schedule`, `team_stats`, `teams`.
* New internal `parquet_from_url()` helper backs the parquet-only datasets
  (requires the suggested `arrow` package).

**Which play-by-play loader do I want?** Nothing is deprecated — the classic
functions are unchanged; the new families add sources:

* `load_cfb_pbp()` (unchanged) — the classic cfbfastR EPA/WPA play-by-play,
  FBS 2014+.
* `load_espn_cfb_pbp()` (new) — the ESPN-derived play-by-play (469 columns,
  EPA/WPA + participant ids), 2004+.
* `load_ncaa_mfb_pbp()` (new) — stats.ncaa.org play-by-play incl. FCS and
  lower divisions, 2013+; `load_ncaa_mfb_pbp_cfbfastr()` is the same data
  reshaped onto cfbfastR pbp column conventions for cross-source binds.

This release adds a 65-function ESPN college-football API layer, expanding `cfbfastR`'s ESPN surface from 8 wrappers to 73. The new wrappers expose ESPN's core-v2 endpoints in ESPN's own ID space — complementary to the CollegeFootballData (`cfbd_*`) wrappers, and the natural join partners for `espn_cfb_pbp()` / `espn_cfb_scoreboard()`. Every wrapper was verified live against the 2023, 2024, and 2025 seasons.

**Naming alignment with the sportsdataverse convention (this dev cycle, never on CRAN):** `espn_cfb_player_statistics()` is renamed to `espn_cfb_player_career_stats()` (the core-v2 `/athletes/{id}/statistics` career view, matching hoopR/wehoop/sportsdataverse-py). New `espn_cfb_player_stats_v3()` wraps the comprehensive web-common-v3 `/athletes/{id}/stats` payload (all categories, long format) — the `_v3` companion to `espn_cfb_player_stats()` (core-v2 season statistics).

### New Fox Sports API wrappers (`fox_cfb_*`)

A read-only Fox Sports "Bifrost" college-football layer (`api.foxsports.com/bifrost/v1/cfb/*`), complementary to the `espn_cfb_*` and `cfbd_*` families. Eight wrappers flatten Fox's layout-oriented JSON (sections → tables → rows → cells) into tidy `cfbfastR`-tagged tibbles. Reverse-engineering notes and an OpenAPI 3.1 spec live in the `sdv-internal-refs` repo. Verified live against the 2025 season.

* `fox_cfb_pbp()` — game play-by-play (quarters → drives → plays), one row per play.
* `fox_cfb_boxscore()` — per-team player stat tables, tidy long (one row per player-stat).
* `fox_cfb_odds()` — matchup six-pack (spread / to-win / total) per team.
* `fox_cfb_team_roster()` — roster by position group, one row per player.
* `fox_cfb_team_stats()` — team stat leaders by category.
* `fox_cfb_team_gamelog()` — per-game team stats, tidy long (game × category × stat), each game keyed to its Fox event id.
* `fox_cfb_standings()` — a team's conference standings table.
* `fox_cfb_league_leaders()` — statistical leaderboards by category (`stats-con`).

### New ESPN wrappers — football-specific metrics

* `espn_cfb_powerindex()` — ESPN's College Football Power Index (FPI): every predictive metric and efficiency component, in long format.
* `espn_cfb_qbr()` — Total Quarterback Rating (QBR) and the full set of clutch-weighted EPA components, one row per qualified passer.
* `espn_cfb_futures()` — the season betting-futures board (national championship, conference, and award markets) with each sportsbook's American odds.
* `espn_cfb_recruits()` — ESPN's recruiting board for a class, one row per recruit with grade, position/state/region rank, committed school, and hometown.

### New ESPN wrappers — players

* `espn_cfb_players()`, `espn_cfb_player()`, `espn_cfb_player_eventlog()`, `espn_cfb_player_gamelog()`, `espn_cfb_player_statistics()`, `espn_cfb_player_splits()`, `espn_cfb_player_overview()`, and `espn_cfb_player_seasons()` — player index, biographical detail, per-game logs, season statistics, and split breakdowns. The season-level wrappers resolve `athlete_id` to human-readable name/position columns via an `athlete_detail` argument.

### New ESPN wrappers — teams

* `espn_cfb_teams()`, `espn_cfb_team()`, `espn_cfb_team_roster()`, `espn_cfb_team_schedule()`, `espn_cfb_team_record()`, and `espn_cfb_team_leaders()` — team index, team-in-season detail, roster, schedule, records, and statistical leaders.
* `espn_cfb_team_ats()`, `espn_cfb_team_powerindex()`, `espn_cfb_team_events()`, `espn_cfb_team_ranks()`, `espn_cfb_team_awards()`, and `espn_cfb_team_coaches()` — team against-the-spread records, single-team power index, season event log, poll-rank history, player awards, and coaching staff.

### New ESPN wrappers — game detail

* `espn_cfb_game_teams()`, `espn_cfb_game_team_linescores()`, `espn_cfb_game_team_leaders()`, `espn_cfb_game_team_roster()`, `espn_cfb_game_team_statistics()`, and `espn_cfb_game_team_records()` — per-game team breakdowns.
* `espn_cfb_game_odds()`, `espn_cfb_game_broadcasts()`, `espn_cfb_game_predictor()`, `espn_cfb_game_probabilities()`, `espn_cfb_game_powerindex()`, and `espn_cfb_game_pbp()` — per-game odds, broadcasts, pre-game predictor, live win-probability, matchup power index, and play-by-play.
* `espn_cfb_game_drives()`, `espn_cfb_game_drive_plays()`, `espn_cfb_game_play()`, `espn_cfb_game_leaders()`, `espn_cfb_game_situation()`, `espn_cfb_game_status()`, `espn_cfb_game_player_statistics()`, and `espn_cfb_game_player_box()` — drive log, drive-scoped plays, single-play detail, game statistical leaders, situation, status, and per-player game box lines.
* The play-level wrappers (`espn_cfb_game_pbp()`, `espn_cfb_game_drive_plays()`, `espn_cfb_game_play()`) extract every field ESPN returns for a play and expose its nested child collections through opt-in parameters: `participants` (`"none"`/`"wide"`/`"long"`) and `participants_list` surface per-play athlete involvement (passer, rusher, tackler, …), and `team_participants` / `team_participants_list` surface the offense/defense team participants — `"wide"` modes pivot to one row per play, the `*_list` flags keep the raw detail as a list-column.
* `espn_cfb_game_team_records(detail = TRUE)` unpacks each record's full statistic breakdown; `espn_cfb_game_odds(line_history = TRUE)` returns the open/close/current line-movement history. Roster and player-stats wrappers join ESPN position-catalog detail when `position_detail = TRUE`.
* `espn_cfb_game_drives()` gains a `plays` argument — `"list"` nests each drive's plays (full play-by-play schema, with the participant pass-through options) as a list-column, `"expand"` returns the flat one-row-per-play table with `drive_*` context columns. The new `espn_cfb_unnest_plays()` performs the same drives-to-play-by-play transform on an already-fetched nested frame.
* The game wrappers join human-readable team detail when `team_detail = TRUE` (default): every team-id column (`team_id`, `home_team_id`, `start_team_id`, `leader_team_id`, …) gains sibling `*_name`, `*_abbreviation`, `*_location`, `*_display_name`, `*_color`, `*_logo_href`, … columns from the ESPN team catalog. `espn_cfb_game_teams(format = "wide")` collapses the two competitor rows into a single per-game row with `home_*` / `away_*` columns for direct joining onto one-row-per-game tables.
* `espn_cfb_pbp_v2()` — a core-v2-sourced successor to `espn_cfb_pbp()`: assembles play-by-play in one structured request (vs. the legacy site-v2 summary parse) and, with `epa_wpa = TRUE`, runs cfbfastR's full EPA/WPA model pipeline — producing EPA/WPA columns identical to the legacy modeled feed.

### New ESPN wrappers — catalogs and season metadata

* `espn_cfb_seasons()`, `espn_cfb_season_info()`, `espn_cfb_season_types()`, `espn_cfb_season_weeks()`, `espn_cfb_groups()`, and `espn_cfb_standings()` — season structure, conferences, and standings.
* `espn_cfb_coaches()`, `espn_cfb_coach()`, `espn_cfb_venues()`, `espn_cfb_positions()`, `espn_cfb_awards()`, `espn_cfb_rankings()`, and `espn_cfb_week_rankings()` — league catalogs and poll rankings.
* `espn_cfb_coach_record()`, `espn_cfb_franchises()`, `espn_cfb_franchise()`, `espn_cfb_venue()`, `espn_cfb_position()`, and `espn_cfb_award()` — coach season win/loss records, the league franchise catalog, and single-record venue / position / award detail.

### New Yahoo Sports wrappers

* Added Yahoo Sports college football wrappers: `yahoo_cfb_player_season_stats()`, `yahoo_cfb_team_season_stats()`, `yahoo_cfb_player_season_stats_legacy()`, `yahoo_cfb_team_season_stats_legacy()`, `yahoo_cfb_scoreboard()`, and `yahoo_cfb_boxscore()` (scaffold), wrapping Yahoo's shangrila stats graph and editorial feed.

### New CollegeFootballData wrappers

* `cfbd_betting_ats()` — season against-the-spread (ATS) summary records by team, wrapping the CollegeFootballData `/teams/ats` endpoint.
* `cfbd_stats_game_havoc()` — per-game havoc statistics (total / front-seven / defensive-back havoc events and rates, offense and defense), wrapping the CollegeFootballData `/stats/game/havoc` endpoint.
* `cfbd_pbp_data_v2()` is a new public function: a modular successor to `cfbd_pbp_data()` that runs the same EPA/WPA pipeline through a single shared engine (`.run_epa_wpa()`) and a canonical play-type taxonomy (`.pbp_play_types()`). The legacy `cfbd_pbp_data()` is unchanged.
* `espn_cfb_pbp_v2()` now sources play-by-play and meta through the shared engine, requests `participants = "wide"` and `team_participants = "wide"` from `espn_cfb_game_drives()`, and adds the meta columns `home_team_name`, `home_team_color`, `home_team_alternate_color`, `home_team_rank` (and `away_*`) via the new `.espn_pbp_game_meta()` bridge. Output is a strict superset of legacy `espn_cfb_pbp()` on the meta columns.

### Play-by-play engine — v2 is now the default

* **`cfbd_pbp_data()` and `espn_cfb_pbp()` now run the v2 engine by default.** Both gain penalty enforcement resolution, ESPN-resolved player names, the `*_player_id` columns and the `output` tier selector without a code change. The previous behaviour is one argument away — `engine = "legacy"` per call, or `options(cfbfastR.pbp_engine = "legacy")` for a session — and a once-per-session message says so. `engine = "auto"` continues to mean "whatever this release considers current". `tests/testthat/test-pbp_equivalence.R` asserts v2 reproduces the legacy frames column-for-column, with an explicit allow-list of intentional deltas.

* Play-by-play now overwrites the regex-extracted `*_player_name` values with ESPN's own `participants[]` names (2014 onward), so a capture that trailed narration (`"Rod Smith 3 Yd"`), abbreviated, or carried a team code becomes the real name. Ported from `sportsdataverse`'s `CFBPlayProcess.__join_participants` and verified against a 60-game offline oracle (5 games from each of 2004, 2006, 2008, 2010, 2013, 2014, 2017, 2019, 2020, 2021, 2023, 2025, including the postseason): 1,236 of 9,545 × 11 name cells change, with zero divergence from the Python. The stage runs **before** id resolution, so the roster matcher gets a clean key rather than narration.

* `espn_cfb_pbp_v2()` gains `resolve_names` (default `TRUE`). When `epa_wpa = TRUE` it spends one memoised request per game on ESPN's play-by-play sidecar, which supplies (a) full athlete names — `"Jalen Mitchell"` rather than the core-v2 roster's `"J. Mitchell"` — and (b) the per-player box score as a second identity source. The box score is the *only* identity source on the large share of games where ESPN 404s the roster resource; adding it cuts `*_player_id` divergence from sdv-py from 52/163,656 to 26/166,482 — fewer mismatches over more plays. Set `resolve_names = FALSE` for a bulk sweep that would rather have the short names than the requests.

* Play-by-play now resolves **which team** each event belongs to, adding 30 columns cfbfastR could not previously produce: the special-teams flip (`kicking_team`, `return_team`, `punt_return_team`, `kick_return_team`, `fg_team`, `punt_team`), the event-credit columns (`sack_team`, `interception_team`, `pass_breakup_team`, `forced_fumble_team`, `fumble_recovery_team`), the fumble/recovery chain (`fumble_or_muff`, `fumbling_team`, `recovery_team`, `recovery_team_2`), the per-side turnover model (`is_turnover`, `turnover_team`, `int_turnover`, `pos_fumble_lost`, `def_fumble_lost`, `is_pos_team_turnover`, `is_def_pos_team_turnover`, `is_st_turnover`, `is_blocked_punt_turnover`, `is_blocked_fg_turnover`), penalty attribution (`penalized_team`, `penalty_team_id`, `penalty_yards_signed`) and the id-keyed `pos_team_id` / `def_pos_team_id`. Ported from `sportsdataverse`'s `CFBPlayProcess.__add_attribution_cols` and verified against the 60-game offline oracle at zero divergence over 267,260 cells.

  The turnover flags are framed **per side** because one play can lose the ball twice — the offense fumbles, the defense recovers and fumbles back — and a single boolean cannot say that both teams turned it over. Blocked punts and blocked field goals deliberately stay *out* of `is_turnover`: ESPN's official box counts only giveaways, so folding them in would break the reconciliation against it. They get their own flags instead.

  On the ESPN path, ESPN's own per-play turnover flag is preserved as **`espn_is_turnover`** rather than being silently overwritten. The two legitimately differ — ESPN's also fires on blocked kicks.

* Play-by-play gains `air_yards`, `air_yardsToEndzone` and `yards_after_catch`, splitting a completed pass into the yards thrown and the yards run after the catch. ESPN states the catch point as `"caught at OU35"`; the stated yard line belongs to whichever team owns that side of the field, so the abbreviation is sided against the possessing and defending teams with the same prefix-tolerant matcher the recovery and penalty teams use. `yards_after_catch` is computed for completions only. Ported from `sportsdataverse`'s `CFBPlayProcess.__add_air_yards_cols`.

  **One deliberate divergence from the Python:** sdv-py's pattern has no article, so it resolves `"caught at OU35"` and silently drops `"thrown to the ARK30"`. Both forms occur in ESPN's text — and cfbfastR's core-v2 feed uses the article form almost exclusively, where a verbatim port would have matched nothing at all. This implementation accepts both. The parity test is partitioned accordingly: exact agreement on the 137 oracle rows sdv-py resolves, plus an explicit assertion that the 7 article-form rows it drops are recovered here.

* Play-by-play gains `pass_depth`, `pass_direction`, `rush_direction` and `qb_hurry`, read from the play text (`"short"`/`"deep"`, `"left"`/`"middle"`/`"right"`, and ESPN's `"QB hurried by"` annotation). Null where ESPN omits the phrase — sacks, screens, and older seasons that never annotated depth or direction.

* `espn_cfb_pbp_v2()` now refuses to run the EPA/WPA models on an obviously malformed feed — no plays, or implausibly few or many for a game that has finished — and returns the unmodeled frame with a warning instead. A truncated game models perfectly cleanly and produces EPA, drive results and a box score that all look reasonable and are all wrong, and nothing downstream can distinguish that from a real blowout. The count rules apply only to completed games so a live feed is never rejected. Ported from `CFBPlayProcess.corrupt_pbp_check`.

* A **pbp-to-boxscore parity gate** now guards the test suite. The per-play parity tests check a play against itself; this aggregates play-by-play by team and compares it against ESPN's own team box, which is the only cheap end-to-end judge of whether parsing put the right events on the right *team*. An attribution bug leaves every per-play assertion green and shows up here immediately. Ported from `sportsdataverse`'s `tools/validation/checks/boxscore_parity`, adapted from a per-season harness check to a per-game library gate.

  It encodes three conventions proven against the box, two of which are the opposite of the NFL's: **NCAA charges a sack to rushing** (attempt and yardage both), **pass attempts exclude sacks**, and **a penalty belongs to the team that committed it** — a positive `penalty_yards_signed` means the offence gained, so the defence was flagged. Floors are measured from the shipped 60-game corpus, never guessed, and are per-stat because parity is strongly era-dependent (interceptions reconcile at 97%, 2004-inclusive rushing yardage at 31%).

### CFBD API coverage

Audited against the CollegeFootballData OpenAPI spec (5.24.1, 74 endpoints).

**15 endpoints that had no wrapper now have one:** `cfbd_playoffs_cfp()`, `cfbd_playoffs_cfp_games()`, `cfbd_playoffs_cfp_participants()`, `cfbd_conference_affiliations()`, `cfbd_conference_changes()`, `cfbd_coaches_profile()`, `cfbd_coaches_seasons()`, `cfbd_coaches_tenures()`, `cfbd_ratings_core()`, `cfbd_ratings_srs_expanded()`, `cfbd_teams_fbs()`, `cfbd_stats_player_success()`, `cfbd_stats_player_success_game()`, `cfbd_player_season_overview()` and `cfbd_info_usage()`. Every one was exercised against the live API before being committed.

**26 parameters added** to existing wrappers — most importantly `division` on ten more functions, plus `defense` / `offense_conference` / `defense_conference` / `conference` / `division` on `cfbd_pbp_data()`, `competition` and `round` on `cfbd_game_info()` (College Football Playoff filtering), `line_provider` on `cfbd_betting_lines()`, `conference` on `cfbd_play_stats_player()` and `recruit_type` on `cfbd_recruiting_position()`. `cfbd_conferences()` previously took **no arguments at all** and now accepts `year` and `division`.

**New `validate_division()`** covering `fbs` / `fcs` / `ii` / `ii/iii` / `iii`. This validates locally because CFBD *ignores* an unrecognised filter value rather than rejecting it — so without it a typo silently returns every division.

Two spec parameters were deliberately **not** exposed after testing them: `/rankings` declares `latest` and `final` as booleans, but the API returns HTTP 400 for every form of both. `poll` is validated to `"cfp"`, the only value it accepts.

### Bug fixes

* `espn_cfb_team_coaches()` — the `year` argument is deprecated. ESPN's core-v2 coaches endpoint returns the **current** coach whatever season is requested, echoing the requested year back in the response, so historical calls silently returned today's coach labelled with the old season (#125). `year` now defaults to `most_recent_cfb_season()`; passing any other season warns and is coerced, rather than returning misattributed data. Existing calls keep working.

* `espn_cfb_teams()` returned **zero rows**, because `site.api.espn.com` now answers HTTP 403 to a spoofed browser `User-Agent`. The failure was silent — the wrapper caught it and returned an empty frame — and every consumer degraded to `NA`, which took `home`, `away`, `pos_team`, `def_pos_team`, `offense_play`, `defense_play` and every team abbreviation on the ESPN play-by-play path down with it. Measured 2026-08-19: the endpoint answers 200 with httr2's default UA, with `curl/8.5.0`, or with `Accept`/`Origin`/`Referer` and no UA at all, and 403 with the Chrome string. The `User-Agent` header is dropped.

  Probing every ESPN host the package uses narrowed the blast radius to **exactly two callers** — `espn_cfb_teams()` and `espn_cfb_team_schedule()`, the only two that combine `site.api.espn.com` with the spoofed header. `espn_cfb_team_schedule()` was returning zero rows for the same reason and now returns data. The other ~65 occurrences of the header sit on `sports.core.api.espn.com` and `site.web.api.espn.com`, which answer 200 either way, so they are left alone.

  Worth knowing for anyone adding an ESPN call: `cdn.espn.com` does something worse than a 403 under the browser UA — it answers **200 with a zero-byte body**, so nothing raises and the parse silently yields nothing. `tests/testthat/test-espn_http_headers.R` is a source-level guard that fails if the header is re-added to a `site.api` caller.
* `defense_play` was a copy-paste duplicate of `offense_play` in the ESPN adapter — both `case_when()` branches returned the home team — so it named the team **with** the ball on every ESPN play.
* Play-by-play gains `pos_team_id` / `def_pos_team_id` / `offense_play_id` / `defense_play_id`. `pos_team`, `def_pos_team`, `offense_play` and `defense_play` are team NAMES resolved through the ESPN teams catalog, and when that catalog is unavailable they all go NA together — which silently disabled team-aware roster matching, dropping every player-id lookup to the global-unique fallback. The ids come straight off the play and are always present. (`espn_cfb_teams()` currently returns zero rows, so this is the live condition, not a hypothetical.)
* `.espn_cfb_participant_roster()` is now memoised alongside the ESPN catalog helpers. `espn_cfb_pbp_v2()` needs one game's roster twice — once to name participants, once to resolve player ids — and a season sweep asked for it once per game; both now cost a single request. The memoised-helper list is a single constant shared by `.onLoad()` and `espn_cfb_clear_cache()`, which had been a second hand-maintained copy that could silently drift into caching a helper it never cleared.
* `.run_epa_wpa_by_game()` had no roster argument, so `cfbd_pbp_data_v2()` could never resolve `*_player_id` columns however the roster was supplied. It now threads `rosters` and `participants` through, sliced per `game_id`.
* `espn_cfb_pbp()` now builds its request URL with the `?event=` query separator (previously concatenated as `summaryevent=`, which returned HTTP 404 for every game) and initializes its return frame before the `tryCatch` so an upstream failure no longer throws `object 'plays_df' not found`.
* `cfbd_pbp_data_v2()` and `espn_cfb_pbp_v2()` preserve character `id_play` precision through the EPA/WPA pipeline. The legacy shared helper used unquoted numeric literals in two `ifelse` calls (a historical `id_play` swap for one game), which silently coerced character `id_play` to numeric and then lost precision past 2^53 — breaking the play-id join-back in `espn_cfb_pbp_v2()`. The modular `.pbp_clean_pbp_dat()` quotes those literals so `id_play` stays character; the legacy `clean_pbp_dat()` is unchanged.

### Internal changes

- **httr -> httr2 migration.** cfbfastR's HTTP layer now uses the modern `httr2` package (>= 1.0.0) instead of the legacy `httr`. End users running existing wrapper calls (`cfbd_*`, `espn_cfb_*`) should see no behavioural change -- the migration is internal. Custom code that calls `get_req()` or `check_status()` directly must update from `httr::content(res, as = "text")` to `httr2::resp_body_string(res)` and from `httr::status_code(res)` to `httr2::resp_status(res)`.
- **Proxy support.** `get_req()` now resolves a proxy in the order: explicit `proxy` argument -> `getOption("cfbfastR.proxy")` -> `http_proxy` / `https_proxy` env vars. The proxy value accepts either a URL string or a named list with `url` / `port` / `username` / `password` / `auth` for authenticated proxies.
- **Dependency footprint trimmed.** `lubridate`, `progressr`, `memoise`, `cachem`, and `magrittr` have moved out of `Imports` (21 -> 16). `lubridate` is gone entirely -- its two `ymd_hm() |> with_tz()` calls in `espn_cfb_schedule.R` are now base-R `as.POSIXct(format = "%Y-%m-%dT%H:%M", tz = "UTC")` + `attr(., "tzone")`. `progressr`, `memoise`, and `cachem` moved to `Suggests` and the helpers degrade gracefully when missing: `load_cfb_pbp()` / `cfbd_pbp_data()` / `pbp_epa_wpa_engine()` run without a progress bar when `progressr` is absent; ESPN catalog wrappers run uncached when `memoise` / `cachem` are absent (`espn_cfb_clear_cache()` becomes a no-op). Drops the `Imports` count below the >20 `R CMD check` NOTE threshold.
- **Native pipe migration.** All 1,419 `%>%` chains in `R/`, plus 137 across `vignettes/` and `tests/`, were converted to the base-R native pipe `|>`. `magrittr` is no longer an `Imports`; downstream consumers that load `cfbfastR` purely for its functions don't get `%>%` re-exported anymore. User-visible impact is minimal -- the public API is unchanged and `dplyr` (which is in `Imports`) still re-exports `%>%` for users who want to keep writing it. Two non-mechanical fixes were needed during the sweep: three `|> [[("url")` chains in `cfbd_betting.R` and `cfbd_coaches.R` (rejected as RHS in R 4.1's `|>`) became `|> purrr::pluck("url")`; seven `|> tibble::tibble(col = .data$.)` constructs were a magrittr quirk that silently duplicated the LHS into both a `.` and the named column -- rewritten to `tibble::tibble(col = <lhs>)`, which drops the redundant `.` column.
- **Test-time CFBD throttle.** A new `tests/testthat/setup-cfbd-throttle.R` adds a 1-second sleep before every CFBD request made by `devtools::test()` / `R CMD check`. It works by monkey-patching `cfbfastR:::get_req()` for the duration of the test session (restored via `withr::defer(., teardown_env())`) -- the package code is unchanged, so interactive and production calls pay no penalty. Tunable via `options(cfbfastR.test_request_delay = N)` (default 1; set to 0 for unthrottled local runs). Resolves the cascading `HTTP 429` skip-if-empty results that were turning otherwise-green test runs into "all green, mostly skipped." `withr` joins `Suggests` to declare the test-side dependency cleanly (it was already a transitive dep of `testthat`).

# **cfbfastR v2.2.0**

* Fixes a bug in `validate_week()` utility function where some inputs were not being handled correctly (i.e. week 16). Fixes trickle down to `cfbd_pbp_data()` and other functions.
* Default value for `season_type` parameter in `cfbd_game_info()` and `cfbd_play_stats_player()` function changed from "regular" to "both" to align with other functions in the package.

# **cfbfastR v2.1.0**

* Fixes a bug in `cfbd_pbp_data()` where play-by-play data for some games were not as expected.
* Improves `add_yardage()` where plays with missing yardage values were not being handled correctly.


# **cfbfastR v2.0.0**
### Breaking Changes to Loading Functions

* All `load_cfb_*()` functions now use [```sportsdataverse-data``` releases](https://github.com/sportsdataverse/sportsdataverse-data/releases/tag/cfbfastR_cfb_pbp) or the [CollegeFootballData.com API](https://api.collegefootballdata.com/) as their underlying data source to remain in compliance with CFBD API terms and conditions (See **Note** below).
* Updated `load_cfb_pbp()` dataset to include various team- and game-level ID's and flags that were not being included, like `home_team_id`, `away_team_id`, `season_type`, `venue_id`, some `drive_*` columns, a half-dozen player stat columns, etc. Essentially, all the leg-work users have undoubtedly had to do while using these datasets is mostly just included now. **The downside:** this means end users need to check their pipelines which build off these datasets to ensure behavior is as expected and all your joins are doing what is intended.

### Now upgraded to the CFBD v2 API

_Special thanks are in order for our newest contributor, Brad Hill (@bradisbrad) for providing most of the v2 upgrade via his first PR to [cfbfastR](https://cfbfastr.sportsdataverse.org/)!! 🙌🏽 👑 🥇 Your contributions are most appreciated by the community._

**Note: The [free-tier API key](https://collegefootballdata.com/api-tiers) for the CFBD v2 API has a strict 1k calls/month limit, so plan your workflows accordingly! If you receive errors mentioning ```r Request failed [429]```, you have most likely run out of API calls for the month in your membership tier.**

* Added all new `cfbd_*()` functions accommodated by the new College Football Data API v2. This includes the following functions:

  - Added [```cfbd_metrics_fg_ep()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.html) function to access the new field goal expected points added metric from the API.
  - Added [```cfbd_metrics_wepa_team_season()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.html) function to access the new opponent adjusted team season predicted points added metric from the API.
  - Added [```cfbd_metrics_wepa_players_passing()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.html) function to access the new opponent adjusted players passing predicted points added metric from the API.
  - Added [```cfbd_metrics_wepa_players_rushing()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.html) function to access the new opponent adjusted players rushing predicted points added metric from the API.
  - Added [```cfbd_metrics_wepa_players_kicking()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.html) function to access the new  Points Added Above Replacement (PAAR) ratings for kickers from the API.
  - Added [```cfbd_ratings_fpi()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_fpi.html) function to access the new FPI ratings from the API.
  - Added [```cfbd_live_scoreboard()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.html) function to access live scoreboard data from the API.
  - Added [```cfbd_live_plays()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.html) function to access live play-by-play data from the API.
  - Added [```cfbd_api_key_info()```](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.html) function to get information about your API key, including your Patreon level and usage limits.

* Minor changes to the existing `cfbd_*()` functions under the hood to accommodate the new API v2 structure. Please see below for a list of all updated functions:

  - Updated [```cfbd_betting_lines()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_lines.html) function
  - Updated [```cfbd_coaches()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.html) function
  - Updated [```cfbd_conferences()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_conferences.html) function
  - Updated [```cfbd_drives()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_drives.html) function
  - Updated [```cfbd_calendar()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.html) function
  - Updated [```cfbd_game_box_advanced()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.html) function
  - Updated [```cfbd_game_info()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.html) function
  - Updated [```cfbd_game_media()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.html) function
  - Updated [```cfbd_game_player_stats()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.html) function
  - Updated [```cfbd_game_records()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.html) function
  - Updated [```cfbd_game_team_stats()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.html) function
  - Updated [```cfbd_metrics_ppa_games()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.html) function
  - Updated [```cfbd_metrics_ppa_players_games()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.html) function
  - Updated [```cfbd_metrics_ppa_players_season()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.html) function
  - Updated [```cfbd_metrics_ppa_predicted()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.html) function
  - Updated [```cfbd_metrics_ppa_teams()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.html) function
  - Updated [```cfbd_metrics_wp()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.html) function
  - Updated [```cfbd_metrics_wp_pregame()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.html) function
  - Updated [```cfbd_pbp_data()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html) function
  - Updated [```cfbd_play_stats_player()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.html) function
  - Updated [```cfbd_play_stats_types()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.html) function
  - Updated [```cfbd_play_types()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.html) function
  - Updated [```cfbd_plays()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.html) function
  - Updated [```cfbd_player_info()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.html) function
  - Updated [```cfbd_player_returning()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_returning.html) function
  - Updated [```cfbd_player_usage()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.html) function
  - Updated [```cfbd_rankings()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_rankings.html) function
  - Updated [```cfbd_ratings_sp()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp.html) function
  - Updated [```cfbd_ratings_sp_conference()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp_conference.html) function
  - Updated [```cfbd_ratings_srs()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs.html) function
  - Updated [```cfbd_recruiting_player()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.html) function
  - Updated [```cfbd_recruiting_position()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_position.html) function
  - Updated [```cfbd_recruiting_team()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_team.html) function
  - Updated [```cfbd_stats_categories()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_categories.html) function
  - Updated [```cfbd_stats_game_advanced()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.html) function
  - Updated [```cfbd_stats_season_advanced()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_advanced.html) function
  - Updated [```cfbd_stats_season_player()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.html) function
  - Updated [```cfbd_stats_season_team()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_team.html) function
  - Updated [```cfbd_team_info()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.html) function
  - Updated [```cfbd_team_matchup()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup.html) function
  - Updated [```cfbd_team_matchup_records()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup_records.html) function
  - Updated [```cfbd_team_roster()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.html) function
  - Updated [```cfbd_team_talent()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_talent.html) function
  - Updated [```cfbd_venues()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_venues.html) function

* Fixed the following functions and/or documentation:
  - Documentation [```cfbd_team_info()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.html) addressing #97
  - Ensuring [```cfbd_stats_game_advanced()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.html) returns an empty data frame when there are no results
  - Documentation [```cfbd_game_team_stats()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.html) updated to reflect all parameter requirement scenarios.
  - Fixed `athlete_id` parameter [```cfbd_player_usage()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.html) so that it works as users would expect. There was an API query-parameter mismatch
  - Fixed `athlete_id` parameter for [```cfbd_play_stats_player()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.html) function and added more thorough documentation.
  - Fixed returned `position` to correct value (instead of NA) from [```cfbd_stats_season_player()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.html)
  - Added more thorough `season_type` parameter documentation across many functions
  - Changed behavior of [```cfbd_pbp_data()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html) to substitute 3 timeouts per half when the data is missing from the API.

# **cfbfastR v1.9.5**
* fixed breaking bug related to `stringi` v1.8 update in [```cfbd_play_pbp_data()```](https://cfbfastr.sportsdataverse.org/reference/cfbd_pbp_data.html) EPA and WPA processing
* Minor documentation and test updates

# **cfbfastR v1.9.4**
* Improve date parsing for [```espn_cfb_scoreboard()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.html) and [```espn_cfb_schedule()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_schedule.html) functions while adding `lubridate` dependency
* Made a minor tweak to the returns of the [```espn_ratings_fpi()```](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html) function


# **cfbfastR v1.9.3**

* Add division parameter to the following functions:
  - [```cfbd_game_info()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.html)
  - [```cfbd_plays()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.html)
  - [```cfbd_drives()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_drives.html)
  - [```cfbd_game_media()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.html)
  - [```cfbd_game_team_stats()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.html)

# **cfbfastR v1.9.2**

* [```espn_cfb_player_stats()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats.html) function added.

# **cfbfastR v1.9.1**

* Improved drive_pts logic in play-by-play data.
* Fixed an issue that occasionally made the `cfbd_game_team_stats()` function return data in a long format
* Minor documentation and test updates

# **cfbfastR v1.9.0**

#### Added functions to access ESPN API:

* [```espn_cfb_calendar()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_calendar.html)
* [```espn_cfb_schedule()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.html)
* Added EPA and WPA processing to [```espn_cfb_pbp()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.html)
* [```espn_cfb_team_stats()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_stats.html)

#### Added functions to pull data from the data repo:

* [```load_cfb_rosters()```](https://cfbfastR.sportsdataverse.org/reference/load_cfb_rosters.html)
* [```load_cfb_schedules()```](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.html)
* [```load_cfb_teams()```](https://cfbfastR.sportsdataverse.org/reference/load_cfb_teams.html)

- Removes `furrr`, `future` dependencies, adds `Rcpp`, `RcppParallel`, and `purrr` dependencies


# **cfbfastR v1.8.0**

* All functions now default to return tibbles.
* Added S3 method to print outputs with data info and retrieval timestamps. Thank you to Tan Ho ([\@tanho36](https://github.com/tanho63)) for the idea.


# **cfbfastR v1.7.1**

* Added [```espn_ratings_fpi()```](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html) to exports.

# **cfbfastR v1.7.0**

* Added [```cfbd_recruiting_transfer_portal()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_transfer_portal.html).

# **cfbfastR v1.6.7**

* Fixed bug in `cfbd_game_team_stats()` with _allowed columns duplicating team stats instead of showing opponent stats.
* Updated tests and documentation for `cfbd_game_team_stats()`.

# **cfbfastR v1.6.6**

* Updated function `cfbd_pbp_data()` to account for additional timeout cases (namely, kickoffs/extra point attempts).

# **cfbfastR v1.6.5**

* Updated tests and documentation for `cfbd_betting_lines()`
* API call in `espn_ratings_fpi()` now requires headers in httr request

# **cfbfastR v1.6.4**

* Changed options to revert to old options on exit of function.
* Removed check_github functions.

# **cfbfastR v1.6.3**

* Switched package urls in DESCRIPTION again.

# **cfbfastR v1.6.2**

* Switched package urls in README and DESCRIPTION files to https://

# **cfbfastR v1.6.1**

* Removed source urls from many package documentation entries.
* Updated a test to skip on CRAN

# **cfbfastR v1.6.0**

* Added [```cfbd_ratings_elo()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_elo.html) function
* Fixed a bug in `update_cfb_db()` where the function failed when trying to load recent games from the data repo. (#35)
* Added the option `cfbfastR.dbdirectory` that allows to set the database directory in `update_cfb_db()` globally.

# **cfbfastR v1.5.2**

* Remove verbose parameter

# **cfbfastR v1.5.1**

##### **Minor release**
* Removed calculated columns from `cfbd_stats_season_team()` that were not behaving correctly
* Fixed bug where `only_fbs` input in `cfbd_team_info()` was ignored. It is now possible to get the team info for all the colleges in the API instead of only FBS schools.
* Removed default year from `cfbd_metrics_ppa_teams`. `cfbd_metrics_ppa_teams` and `cfbd_metrics_ppa_players_season` now require one of `team` or `year` to be specified

# **cfbfastR v1.5.0**

### Added [```espn_cfb_scoreboard()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.html)

### Added [```espn_cfb_pbp()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.html)

# **cfbfastR v1.4.0**

### Added [```cfbd_game_weather()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.html)

# **cfbfastR v1.3.3**

### Hotfix [```cfbd_game_player_stats()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.html)

# **cfbfastR v1.3.2**

### Added ID linking to [```cfbd_recruiting_players()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.html)

# **cfbfastR v1.3.0-1**

### Added three [NFL draft](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft.html) functions:
  - [```cfbd_draft_teams()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_teams.html) - **Get list of NFL teams**
  - [```cfbd_draft_positions()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_positions.html) - **Get list of NFL positions for mapping to collegiate**
  - [```cfbd_draft_picks()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_picks.html) - **Get list of NFL Draft picks**

# **cfbfastR v1.2.1**

##### **Minor release**

* Added headshot_url to outputs of [```cfbd_team_roster()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.html)

* Renamed returns in [```cfbd_game_box_advanced()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.html):
  - `rushing_line_yd_avg` to plural `rushing_line_yds_avg`
  - `rushing_second_lvl_yd_avg` to plural `rushing_second_lvl_yds_avg`
  - `rushing_open_field_yd_avg` to plural `rushing_open_field_yds_avg`

* Completed documentation for all returns except ```cfbd_pbp_data()```

* Continued work on intro vignette

# **cfbfastR v1.2.0-1**

#### **Add significant documentation to the package**

* Added mini-vignettes pertaining to CFB Data functionality:
  - [```cfbd_betting```](https://cfbfastR.sportsdataverse.org/articles/cfbd_betting.html),
  - [```cfbd_games```](https://cfbfastR.sportsdataverse.org/articles/cfbd_games.html),
  - [```cfbd_plays```](https://cfbfastR.sportsdataverse.org/articles/cfbd_plays.html),
  - [```cfbd_recruiting```](https://cfbfastR.sportsdataverse.org/articles/cfbd_recruiting.html),
  - [```cfbd_stats```](https://cfbfastR.sportsdataverse.org/articles/cfbd_stats.html),
  - [```cfbd_teams```](https://cfbfastR.sportsdataverse.org/articles/cfbd_teams.html)

* [Introductory vignette stub](https://cfbfastR.sportsdataverse.org/articles/intro.html) added

#### **ESPN/CFBD metrics function variable return standardization**

* Change `id` variable to `team_id` in [```espn_ratings_fpi()```](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html)
* Changed `espn_game_id` variable to `game_id` in [```espn_metrics_wp()```](https://cfbfastR.sportsdataverse.org/reference/espn_metrics.html), corrected the `away_win_percentage` calculation and added `tie_percentage` to the returns.
* Change `id` variable to `athlete_id` in [```cfbd_metrics_ppa_players_season()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.html)

# **cfbfastR v1.1.0**

#### **Add loading from Data Repository functionality**

* Added [```load_cfb_pbp()```](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.html) and [```update_cfb_db()```](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.html) functions. Pretty much cherry-picking the `nflfastR` methodology of loading data from the [`cfbfastR-data`](https://github.com/sportsdataverse/cfbfastR-data) repository.

#### **Add support for parallel processing and progress updates**

* Added [```furrr```](https://furrr.futureverse.org/index.html), [```future```](https://future.futureverse.org/), and [```progressr```](https://progressr.futureverse.org/) dependencies to the package to allow for parallel processing of the play-by-play data with progress updates if desired.

# **cfbfastR v1.0.0**

#### **Function Naming Convention Change**

* All functions sourced from the College Football Data API will start with `cfbd_` as opposed to `cfb_` (as in cfbscrapR). One additional `cfbd_` function has been added that corresponds to the result when [```cfbd_pbp_data()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html) has the parameter `epa_wpa=FALSE`. It has now been separated into its own function for clarity [```cfbd_plays()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_play.html). The parameter and functionality still exists in [```cfbd_pbp_data()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html) but we expect this function will still exist but made obsolete in favor of a function more closely matching `nflfastR`'s naming conventions.

* Similarly, data and metrics sourced from ESPN will begin with `espn_` as opposed to `cfb_`. In particular, the two functions are now [```espn_ratings_fpi()```](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html) and [```espn_metrics_wp()```](https://cfbfastR.sportsdataverse.org/reference/espn_metrics.html)

* Data generated from any of the ```cfbfastR``` methods will use `cfb_`

#### **College Football Data API Keys**

The [CollegeFootballData API](https://collegefootballdata.com/) now requires an API key, here's a quick run-down:

* To get an API key, follow the directions here: [College Football Data Key Registration.](https://collegefootballdata.com/key)

* Using the key: You can save the key for consistent usage by adding `CFBD_API_KEY=XXXX-YOUR-API-KEY-HERE-XXXXX` to your .Renviron file (easily accessed via [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)). Run [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html), a new script will pop open named `.Renviron`, **THEN** paste the following in the new script that pops up (with**out** quotations)
```r
CFBD_API_KEY = XXXX-YOUR-API-KEY-HERE-XXXXX
```
Save the script and restart your RStudio session, by clicking `Session` (in between `Plots` and `Build`) and click `Restart R` (n.b. there also exists the shortcut `Ctrl + Shift + F10` to restart your session). If set correctly, from then on you should be able to use any of the `cfbd_` functions without any other changes.

* For less consistent usage: At the beginning of every session or within an R environment, save your API key as the environment variable `CFBD_API_KEY` (with quotations) using a command like the following.

```{r}
Sys.setenv(CFBD_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")
```

* Added [API Key methods](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.html). If you forget to set your environment variable, functions will give you a warning and ask for one.
