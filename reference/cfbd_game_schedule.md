# **Get the active or next game schedule slate**

**Returns the active or next calendar slate, including completed
games.** Explicit windows require `year`, `season_type`, and `week`
together; with none of them CFBD picks the slate itself and says which
in the `selection` attribute.

## Usage

``` r
cfbd_game_schedule(
  year = NULL,
  season_type = NULL,
  week = NULL,
  division = NULL,
  conference = NULL,
  proxy = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). Explicit windows
  require `year`, `season_type`, and `week` together. Minimum value
  accepted: 2002

- season_type:

  (*String* optional): Season type: regular or postseason.

- week:

  (*Integer* optional): Week.

- division:

  (*String* optional): Division of either participant: fbs or fcs. CFBD
  defaults to fbs. Sent to CFBD as `classification`.

- conference:

  (*String* optional): Conference abbreviation of either participant.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables.

## Value

`cfbd_game_schedule()` - A data frame with one row per game in the
slate. The slate-level fields of the response are carried as attributes:
`attr(x, "selection")` (active, next, explicit or none),
`attr(x, "window")` and `attr(x, "following_window")` (each a list of
`year`, `seasonType`, `week`, `startDate`, `endDate`),
`attr(x, "filters")` and `attr(x, "assembled_at")`. Nested blocks
(`venue`, `playoff`, `odds`) are flattened into prefixed columns when at
least one game in the slate carries them.

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
| venue_id | integer | Referencing venue id. |
| venue_name | character | Venue name. |
| venue_city | character | Venue city. |
| venue_state | character | Venue state. |
| home_team_id | integer | Home team id. |
| home_team_name | character | Home team name. |
| home_team_conference | character | Home team conference. |
| home_team_conference_abbreviation | character | Home team conference abbreviation. |
| home_team_classification | character | Home team division classification. |
| home_team_points | integer | Home team points. |
| away_team_id | integer | Away team id. |
| away_team_name | character | Away team name. |
| away_team_conference | character | Away team conference. |
| away_team_conference_abbreviation | character | Away team conference abbreviation. |
| away_team_classification | character | Away team division classification. |
| away_team_points | integer | Away team points. |
| playoff_competition | character | Playoff competition. |
| playoff_format | character | Playoff format. |
| playoff_round | character | Playoff round. |
| playoff_round_name | character | Playoff round name. |
| playoff_bracket_slot | character | Playoff bracket slot. |
| playoff_home_seed | integer | Home team playoff seed. |
| playoff_away_seed | integer | Away team playoff seed. |
| playoff_bowl_name | character | Bowl name. |
| broadcasts_status | character | Broadcast section status: available, no_data or unavailable. |
| broadcasts_reason | character | Why the broadcast section is not available. |
| broadcasts_assembled_at | character | When the broadcast section was assembled. |
| broadcasts_source_updated_at | character | Broadcast snapshot publication time. |
| broadcasts_data | list | Broadcasts: one data frame of `mediaType`, `outlet` per game. |
| odds_status | character | Odds section status: available, no_data or unavailable. |
| odds_reason | character | Why the odds section is not available. |
| odds_assembled_at | character | When the odds section was assembled. |
| odds_source_updated_at | character | Odds snapshot publication time. |
| odds_data_provider_id | integer | Odds provider id. |
| odds_data_provider | character | Odds provider (DraftKings, Bovada). |
| odds_data_spread | numeric | Home-relative spread; negative favors home. |
| odds_data_over_under | numeric | Over/under. |
| odds_data_home_moneyline | numeric | Home team moneyline. |
| odds_data_away_moneyline | numeric | Away team moneyline. |

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_preview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_preview.md),
[`cfbd_game_preview_adjusted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_preview_adjusted.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_schedule(year = 2025, season_type = "regular", week = 1))
#> ── Game schedule data from CollegeFootballData.com ────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-27 07:37:36 UTC
#> # A tibble: 96 × 42
#>      game_id season  week season_type status    status_checked_at     start_date
#>        <int>  <int> <int> <chr>       <chr>     <chr>                 <chr>     
#>  1 401756846   2025     1 regular     completed 2026-09-27T07:36:43.… 2025-08-2…
#>  2 401760371   2025     1 regular     completed 2026-09-27T07:36:43.… 2025-08-2…
#>  3 401756847   2025     1 regular     completed 2026-09-27T07:36:43.… 2025-08-2…
#>  4 401757218   2025     1 regular     completed 2026-09-27T07:36:43.… 2025-08-2…
#>  5 401754516   2025     1 regular     completed 2026-09-27T07:36:43.… 2025-08-2…
#>  6 401762522   2025     1 regular     completed 2026-09-27T07:36:43.… 2025-08-2…
#>  7 401752794   2025     1 regular     completed 2026-09-27T07:36:43.… 2025-08-2…
#>  8 401762790   2025     1 regular     completed 2026-09-27T07:36:43.… 2025-08-2…
#>  9 401754373   2025     1 regular     completed 2026-09-27T07:36:43.… 2025-08-2…
#> 10 401756848   2025     1 regular     completed 2026-09-27T07:36:43.… 2025-08-2…
#> # ℹ 86 more rows
#> # ℹ 35 more variables: start_time_tbd <lgl>, neutral_site <lgl>,
#> #   conference_game <lgl>, playoff <lgl>, home_team_id <int>,
#> #   home_team_name <chr>, home_team_conference <chr>,
#> #   home_team_conference_abbreviation <chr>, home_team_classification <chr>,
#> #   home_team_points <int>, away_team_id <int>, away_team_name <chr>,
#> #   away_team_conference <chr>, away_team_conference_abbreviation <chr>, …
# }
```
