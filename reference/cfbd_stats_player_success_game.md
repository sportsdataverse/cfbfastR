# **Get player success rates by game**

**Get player success rates by game** Game-level player success-rate
metrics.

## Usage

``` r
cfbd_stats_player_success_game(
  year,
  week = NULL,
  season_type = "regular",
  conference = NULL,
  team = NULL,
  athlete_id = NULL,
  threshold = NULL,
  excl_garbage_time = NULL,
  proxy = NULL
)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digits (YYYY).  
  Minimum value accepted: 2013

- week:

  (*Integer* optional): Week filter.

- season_type:

  (*String* optional): Season type – `regular`, `postseason`, `both`,
  `allstar`, `spring_regular` or `spring_postseason`.

- conference:

  (*String* optional): Conference abbreviation filter.

- team:

  (*String* optional): Team filter.

- athlete_id:

  (*Integer* optional): Player identifier.

- threshold:

  (*Numeric* optional): Minimum success-rate threshold.

- excl_garbage_time:

  (*Logical* optional): Exclude garbage-time plays.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_stats_player_success_game()` - A tibble with 16 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Four-digit season year. |
| season_type | character | Season type (regular, postseason, both, allstar, spring_regular, spring_postseason). |
| week | integer | Week of the season. |
| game_id | integer | Referencing game id. |
| id | character | Record identifier. |
| name | character | Display name. |
| position | character | Position. |
| team | character | Team name. |
| conference | character | Conference name. |
| opponent | character | Opponent. |
| passing_plays | integer | Passing plays. |
| passing_successes | integer | Passing successes. |
| passing_success_rate | numeric | Passing success rate. |
| rushing_plays | integer | Rushing plays. |
| rushing_successes | integer | Rushing successes. |
| rushing_success_rate | numeric | Rushing success rate. |

## See also

Other CFBD Stats Functions:
[`cfbd_stats_player_success()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_player_success.md)

## Examples

``` r
# \donttest{
  try(cfbd_stats_player_success_game(year = 2024, week = 5))
#> 2026-10-11 01:06:59.371786: Invalid arguments or no stats data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
