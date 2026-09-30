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

A data frame with one row per game in the slate. The slate-level fields
of the response are carried as attributes: `attr(x, "selection")`
(active, next, explicit or none), `attr(x, "window")` and
`attr(x, "following_window")` (each a list of `year`, `seasonType`,
`week`, `startDate`, `endDate`), `attr(x, "filters")` and
`attr(x, "assembled_at")`. Nested blocks are flattened into prefixed
columns; a block that no game in the slate carries collapses to one
all-NA column named after it (`playoff` in a regular-season slate, and
likewise `venue` or `odds_data`), so the column count varies by slate
(42 for 2025 regular week 1, 49 for 2024 postseason week 1). An empty
data frame is returned if the request fails.

|  |  |  |
|----|----|----|
| col_name | type | description |
| game_id | integer | Unique CFBD game identifier. |
| season | integer | Season of the game. |
| week | integer | Game week (postseason games restart at week 1). |
| season_type | character | Season type of the game: regular or postseason. |
| status | character | Game status: scheduled, in_progress or completed. |
| status_checked_at | character | When CFBD last checked the game status (ISO 8601, UTC). |
| start_date | character | Game start date-time (ISO 8601, UTC). |
| start_time_tbd | logical | TRUE if the start time is still to be determined. |
| neutral_site | logical | TRUE if the game is at a neutral site. |
| conference_game | logical | TRUE if the game is a conference game. |
| playoff | logical | All-NA placeholder, present only when no game in the slate has playoff context; otherwise the eight `playoff_*` columns after `venue_state` replace it. |
| home_team_id | integer | Home team id. |
| home_team_name | character | Home team name. |
| home_team_conference | character | Home team conference. |
| home_team_conference_abbreviation | character | Home team conference abbreviation. |
| home_team_classification | character | Home team division classification: fbs, fcs, ii, ii/iii or iii. |
| home_team_points | integer | Home team points; NA until the game has a score. |
| away_team_id | integer | Away team id. |
| away_team_name | character | Away team name. |
| away_team_conference | character | Away team conference. |
| away_team_conference_abbreviation | character | Away team conference abbreviation. |
| away_team_classification | character | Away team division classification: fbs, fcs, ii, ii/iii or iii. |
| away_team_points | integer | Away team points; NA until the game has a score. |
| venue_id | integer | Venue id. |
| venue_name | character | Venue name. |
| venue_city | character | Venue city. |
| venue_state | character | Venue state abbreviation; empty for venues outside the US. |
| playoff_competition | character | Playoff competition (cfp). Present only when at least one game in the slate has playoff context, as are the other `playoff_*` columns; NA for the other games. |
| playoff_format | character | Playoff format (e.g. twelve_team_2024). |
| playoff_round | character | Playoff round: first_round, quarterfinal, semifinal or championship. |
| playoff_round_name | character | Display name of the round (e.g. First Round). |
| playoff_bracket_slot | character | Bracket slot code (e.g. FR3). |
| playoff_home_seed | integer | Home team playoff seed. |
| playoff_away_seed | integer | Away team playoff seed. |
| playoff_bowl_name | character | Name of the bowl hosting the game; NA when none. |
| broadcasts_status | character | Broadcast section status: available, no_data or unavailable. |
| broadcasts_reason | character | Why the broadcast section has no data: no_data, no_results_yet, source_error or invalid_data; NA when available. |
| broadcasts_assembled_at | character | When CFBD assembled the broadcast section (ISO 8601, UTC). |
| broadcasts_source_updated_at | character | Publication time of the broadcast snapshot, not a games-through cutoff (ISO 8601, UTC); NA when CFBD sends none. |
| broadcasts_data | list | Broadcasts: one data frame per game of `mediaType` (tv, radio, web, ppv or mobile) and `outlet`; NULL or empty when the section has no data. |
| odds_status | character | Odds section status: available, no_data or unavailable. |
| odds_reason | character | Why the odds section has no data: no_data, no_results_yet, source_error or invalid_data; NA when available. |
| odds_assembled_at | character | When CFBD assembled the odds section (ISO 8601, UTC). |
| odds_source_updated_at | character | Publication time of the odds snapshot, not a games-through cutoff (ISO 8601, UTC); NA when CFBD sends none. |
| odds_data_provider_id | integer | Sportsbook provider id; NA when the game has no odds. |
| odds_data_provider | character | Sportsbook: DraftKings or Bovada. |
| odds_data_spread | double | Home-relative point spread; negative favors home. |
| odds_data_over_under | double | Total points line. |
| odds_data_home_moneyline | integer | Home team moneyline (American odds). |
| odds_data_away_moneyline | integer | Away team moneyline (American odds). |

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
#> ℹ Data updated: 2026-09-30 15:09:23 UTC
#> # A tibble: 96 × 42
#>      game_id season  week season_type status    status_checked_at     start_date
#>        <int>  <int> <int> <chr>       <chr>     <chr>                 <chr>     
#>  1 401756846   2025     1 regular     completed 2026-09-30T15:09:23.… 2025-08-2…
#>  2 401760371   2025     1 regular     completed 2026-09-30T15:09:23.… 2025-08-2…
#>  3 401756847   2025     1 regular     completed 2026-09-30T15:09:23.… 2025-08-2…
#>  4 401757218   2025     1 regular     completed 2026-09-30T15:09:23.… 2025-08-2…
#>  5 401754516   2025     1 regular     completed 2026-09-30T15:09:23.… 2025-08-2…
#>  6 401762522   2025     1 regular     completed 2026-09-30T15:09:23.… 2025-08-2…
#>  7 401752794   2025     1 regular     completed 2026-09-30T15:09:23.… 2025-08-2…
#>  8 401762790   2025     1 regular     completed 2026-09-30T15:09:23.… 2025-08-2…
#>  9 401754373   2025     1 regular     completed 2026-09-30T15:09:23.… 2025-08-2…
#> 10 401756848   2025     1 regular     completed 2026-09-30T15:09:23.… 2025-08-2…
#> # ℹ 86 more rows
#> # ℹ 35 more variables: start_time_tbd <lgl>, neutral_site <lgl>,
#> #   conference_game <lgl>, playoff <lgl>, home_team_id <int>,
#> #   home_team_name <chr>, home_team_conference <chr>,
#> #   home_team_conference_abbreviation <chr>, home_team_classification <chr>,
#> #   home_team_points <int>, away_team_id <int>, away_team_name <chr>,
#> #   away_team_conference <chr>, away_team_conference_abbreviation <chr>, …
# }
```
