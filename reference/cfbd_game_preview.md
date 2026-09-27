# **Get a pregame preview for a game**

**Returns pregame team comparisons and key players.** Analysis remains
available until the game is completed. Team statistics may use the
previous season; players and context stay in the game season.

## Usage

``` r
cfbd_game_preview(game_id, proxy = NULL)
```

## Arguments

- game_id:

  (*Integer* required): Game ID filter for querying a single game. Can
  be found using the
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  or
  [`cfbd_game_schedule()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_schedule.md)
  functions.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables.

## Value

`cfbd_game_preview()` - A named list of tibbles: `game`, `broadcasts`,
`odds`, `teams`, `key_players`, `recent_results`, `series`,
`series_meetings`. The sections have different row grains, so they are
not joined. A section CFBD did not fill (for example every analysis
section once `availability` is `metadata_only`) is a 0-column tibble.
Nested objects are flattened into prefixed columns.

**game** - one row:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | integer | Referencing game id. |
| season | integer | Season of the game. |
| week | integer | Game week. |
| season_type | character | Season type of the game. |
| start_date | character | Game start date-time (ISO 8601, UTC). |
| start_time_tbd | logical | TRUE if the start time is still to be determined. |
| status | character | Game status. |
| status_checked_at | character | When CFBD last checked the game status. |
| neutral_site | logical | TRUE if the game is at a neutral site. |
| conference_game | logical | TRUE if the game is a conference game. |
| venue_id, venue_name, venue_city, venue_state | mixed | Venue (a single `venue` NA column when absent). |
| home_team_id | integer | Home team id. |
| home_team_name | character | Home team name. |
| home_team_conference | character | Home team conference. |
| home_team_conference_abbreviation | character | Home team conference abbreviation. |
| home_team_classification | character | Home team division classification. |
| home_team_points | integer | Home team points. |
| away_team\_\* | mixed | The same six columns for the away team. |
| playoff\_\* | mixed | `competition`, `format`, `round`, `round_name`, `bracket_slot`, `home_seed`, `away_seed`, `bowl_name` (a single `playoff` NA column when absent). |
| availability | character | pregame or metadata_only. |
| reason | character | Why analysis is not available. |
| assembled_at | character | When the preview was assembled. |

**broadcasts** - one row per broadcast: `media_type` (character),
`outlet` (character).

**odds** - one row: `provider_id` (integer), `provider` (character),
`spread` (numeric, home-relative; negative favors home), `over_under`,
`home_moneyline`, `away_moneyline` (numeric).

**teams** - one row per side (`side` = home or away), then `team_id`
(integer) and `season` (integer). Each of the `record`, `ratings` and
`statistics` sections contributes `<section>_status`,
`<section>_reason`, `<section>_assembled_at`,
`<section>_source_updated_at` and its payload as `<section>_data_*`:
`record_data_*` carries the `record` section of
[`cfbd_team_season_overview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_season_overview.md);
`ratings_data_*` is that function's padded `ratings` section (`elo`,
then `<system>_<unit>_rating` / `_rank` for `srs`, `sp`, `fpi`, `core`),
typed and present even when CFBD omits a system; `statistics_data_*`
holds `season`, `is_previous_season`, `advanced_*` (the `advanced`
section of
[`cfbd_team_season_overview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_season_overview.md)),
`passing_*` (the passing production block of
[`cfbd_passing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_season.md),
per side of the ball, including `locations_<bucket>_*`) and `rushing_*`
(the rushing production block of
[`cfbd_rushing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_season.md)).

**key_players** - one row per player:

|             |           |                                                    |
|-------------|-----------|----------------------------------------------------|
| col_name    | types     | description                                        |
| side        | character | home or away.                                      |
| category    | character | passing, rushing or receiving.                     |
| athlete_id  | character | Player id.                                         |
| name        | character | Player name.                                       |
| position    | character | Player position.                                   |
| usage       | numeric   | Pass/rush involvement, not receiving target share. |
| average_ppa | numeric   | Average predicted points added.                    |
| total_ppa   | numeric   | Total predicted points added.                      |

**recent_results** - one row per recent game: `side`, `game_id`,
`season`, `start_date`, `opponent_id`, `opponent_name`, `home_away`
(home, away), `neutral_site`, `venue_*`, `team_points`,
`opponent_points`, `result` (win, loss, tie, unknown).

**series** - one row: `home_team_id`, `away_team_id`, `meetings`,
`known_results`, `unknown_results`, `home_wins`, `away_wins`, `ties`,
`first_season`, `last_season` (integer), `latest_meeting_*` (the columns
of `series_meetings`) and `streak_team_id`, `streak_wins`.

**series_meetings** - one row per recent meeting: `game_id`, `season`,
`start_date`, `home_team_id`, `home_team`, `away_team_id`, `away_team`,
`neutral_site`, `venue_*`, `home_points`, `away_points`,
`winner_team_id`, `result` (win, tie, unknown).

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_preview_adjusted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_preview_adjusted.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_schedule()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_schedule.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_preview(game_id = 401114233))
#> $game
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-27 07:37:33 UTC
#> # A tibble: 1 × 30
#>     game_id season  week season_type status    status_checked_at      start_date
#>       <int>  <int> <int> <chr>       <chr>     <chr>                  <chr>     
#> 1 401114233   2019     1 regular     completed 2026-09-27T07:37:33.1… 2019-08-3…
#> # ℹ 23 more variables: start_time_tbd <lgl>, neutral_site <lgl>,
#> #   conference_game <lgl>, home_team_id <int>, home_team_name <chr>,
#> #   home_team_conference <chr>, home_team_conference_abbreviation <chr>,
#> #   home_team_classification <chr>, home_team_points <int>, away_team_id <int>,
#> #   away_team_name <chr>, away_team_conference <chr>,
#> #   away_team_conference_abbreviation <chr>, away_team_classification <chr>,
#> #   away_team_points <int>, venue_id <int>, venue_name <chr>, …
#> 
#> $broadcasts
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-27 07:37:33 UTC
#> # A tibble: 0 × 0
#> 
#> $odds
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-27 07:37:33 UTC
#> # A tibble: 0 × 0
#> 
#> $teams
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-27 07:37:33 UTC
#> # A tibble: 0 × 0
#> 
#> $key_players
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-27 07:37:33 UTC
#> # A tibble: 0 × 0
#> 
#> $recent_results
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-27 07:37:33 UTC
#> # A tibble: 0 × 0
#> 
#> $series
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-27 07:37:33 UTC
#> # A tibble: 0 × 0
#> 
#> $series_meetings
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-27 07:37:33 UTC
#> # A tibble: 0 × 0
#> 
# }
```
