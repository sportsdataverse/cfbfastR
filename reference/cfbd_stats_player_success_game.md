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
#> ── Get player success rates by game from CollegeFootballData.com ───────────────
#> ℹ Data updated: 2026-09-01 11:24:25 UTC
#> # A tibble: 1,052 × 16
#>    season season_type  week   game_id id      name     position team  conference
#>     <int> <chr>       <int>     <int> <chr>   <chr>    <chr>    <chr> <chr>     
#>  1   2024 regular         5 401632103 4686606 Isaiah … RB       Abil… UAC       
#>  2   2024 regular         5 401632103 4701592 Jordon … RB       Abil… UAC       
#>  3   2024 regular         5 401632103 4427966 Maveric… QB       Abil… UAC       
#>  4   2024 regular         5 401632103 5086218 Sam Hic… RB       Abil… UAC       
#>  5   2024 regular         5 401643718 5085138 Aiden C… RB       Air … MWC       
#>  6   2024 regular         5 401643718 5085137 Cade Ha… WR       Air … MWC       
#>  7   2024 regular         5 401643718 5151903 Christo… RB       Air … MWC       
#>  8   2024 regular         5 401643718 5151906 Dylan C… RB       Air … MWC       
#>  9   2024 regular         5 401643718 5151904 John Bu… QB       Air … MWC       
#> 10   2024 regular         5 401643718 5223112 Kemper … QB       Air … MWC       
#> # ℹ 1,042 more rows
#> # ℹ 7 more variables: opponent <chr>, passing_plays <int>,
#> #   passing_successes <int>, passing_success_rate <dbl>, rushing_plays <int>,
#> #   rushing_successes <int>, rushing_success_rate <dbl>
# }
```
