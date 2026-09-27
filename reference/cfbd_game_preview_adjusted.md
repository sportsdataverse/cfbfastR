# **Get an adjusted-metrics pregame preview for a game**

**Returns stored adjusted team and player metrics until game
completion.** Requires a CFBD Patreon Tier 1 key; other keys receive an
error and an empty list. Team metrics may use the previous season;
players remain current-season.

## Usage

``` r
cfbd_game_preview_adjusted(game_id, proxy = NULL)
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

`cfbd_game_preview_adjusted()` - A named list of tibbles: `game`,
`team_metrics`, `passing`, `rushing`, `kicking`. A section CFBD did not
fill is a 0-column tibble.

**game** - one row, the same columns as the `game` section of
[`cfbd_game_preview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_preview.md).

**team_metrics** - one row per side (`side` = home or away): `team_id`,
`season` (integer), `metrics_status`, `metrics_reason`,
`metrics_assembled_at`, `metrics_source_updated_at` (character),
`metrics_data_season` (integer), `metrics_data_is_previous_season`
(logical) and `metrics_data_metrics_*`: `year`, `team_id`, `team`,
`conference`, `epa_*` and `epa_allowed_*` (`total`, `passing`,
`rushing`), `success_rate_*` and `success_rate_allowed_*` (`total`,
`standard_downs`, `passing_downs`), `rushing_*` and `rushing_allowed_*`
(`line_yards`, `second_level_yards`, `open_field_yards`,
`highlight_yards`), `explosiveness`, `explosiveness_allowed` (numeric;
see
[`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md)
for the adjusted metrics).

**passing**, **rushing** - one row per player:

|              |           |                                 |
|--------------|-----------|---------------------------------|
| col_name     | types     | description                     |
| side         | character | home or away.                   |
| team         | character | Team name.                      |
| year         | integer   | Season.                         |
| athlete_id   | character | Player id.                      |
| athlete_name | character | Player name.                    |
| position     | character | Player position.                |
| conference   | character | Conference.                     |
| wepa         | numeric   | Opponent-adjusted EPA per play. |
| plays        | integer   | Plays.                          |

**kicking** - one row per kicker: `side`, `team`, `year`, `athlete_id`,
`athlete_name`, `conference`, `paar` (numeric, points added above
replacement), `attempts` (integer).

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_preview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_preview.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_schedule()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_schedule.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_preview_adjusted(game_id = 401114233))
#> $game
#> ── Adjusted game preview data from CollegeFootballData.com ─────────────────────
#> ℹ Data updated: 2026-09-27 07:37:34 UTC
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
#> $team_metrics
#> ── Adjusted game preview data from CollegeFootballData.com ─────────────────────
#> ℹ Data updated: 2026-09-27 07:37:34 UTC
#> # A tibble: 0 × 0
#> 
#> $passing
#> ── Adjusted game preview data from CollegeFootballData.com ─────────────────────
#> ℹ Data updated: 2026-09-27 07:37:34 UTC
#> # A tibble: 0 × 0
#> 
#> $rushing
#> ── Adjusted game preview data from CollegeFootballData.com ─────────────────────
#> ℹ Data updated: 2026-09-27 07:37:34 UTC
#> # A tibble: 0 × 0
#> 
#> $kicking
#> ── Adjusted game preview data from CollegeFootballData.com ─────────────────────
#> ℹ Data updated: 2026-09-27 07:37:34 UTC
#> # A tibble: 0 × 0
#> 
# }
```
