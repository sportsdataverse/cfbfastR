# **Get player success rates by season**

**Get player success rates by season** Season-level player success-rate
metrics.

## Usage

``` r
cfbd_stats_player_success(
  year = NULL,
  conference = NULL,
  team = NULL,
  athlete_id = NULL,
  season_type = "regular",
  start_week = NULL,
  end_week = NULL,
  threshold = NULL,
  excl_garbage_time = NULL,
  proxy = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Season, 4 digits (YYYY).  
  Minimum value accepted: 2013

- conference:

  (*String* optional): Conference abbreviation filter.

- team:

  (*String* optional): Team filter.

- athlete_id:

  (*Integer* optional): Player identifier.

- season_type:

  (*String* optional): Season type – `regular`, `postseason`, `both`,
  `allstar`, `spring_regular` or `spring_postseason`.

- start_week:

  (*Integer* optional): First week to include.

- end_week:

  (*Integer* optional): Last week to include.

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

`cfbd_stats_player_success()` - A tibble with 12 columns:

|                      |           |                         |
|----------------------|-----------|-------------------------|
| col_name             | types     | description             |
| season               | integer   | Four-digit season year. |
| id                   | character | Record identifier.      |
| name                 | character | Display name.           |
| position             | character | Position.               |
| team                 | character | Team name.              |
| conference           | character | Conference name.        |
| passing_plays        | integer   | Passing plays.          |
| passing_successes    | integer   | Passing successes.      |
| passing_success_rate | numeric   | Passing success rate.   |
| rushing_plays        | integer   | Rushing plays.          |
| rushing_successes    | integer   | Rushing successes.      |
| rushing_success_rate | numeric   | Rushing success rate.   |

## See also

Other CFBD Stats Functions:
[`cfbd_stats_player_success_game()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_player_success_game.md)

## Examples

``` r
# \donttest{
  try(cfbd_stats_player_success(year = 2024, team = "Georgia"))
#> ── Get player success rates by season from CollegeFootballData.com ─────────────
#> ℹ Data updated: 2026-08-27 10:57:34 UTC
#> # A tibble: 17 × 12
#>    season id     name  position team  conference passing_plays passing_successes
#>     <int> <chr>  <chr> <chr>    <chr> <chr>              <int>             <int>
#>  1   2024 49076… Anth… WR       Geor… SEC                    0                 0
#>  2   2024 44291… Aria… WR       Geor… SEC                    1                 1
#>  3   2024 47134… Bran… RB       Geor… SEC                    0                 0
#>  4   2024 44308… Cars… QB       Geor… SEC                  459               213
#>  5   2024 48818… Cash… RB       Geor… SEC                    0                 0
#>  6   2024 50793… Chau… RB       Geor… SEC                    0                 0
#>  7   2024 47125… Dill… WR       Geor… SEC                    1                 1
#>  8   2024 45964… Domi… WR       Geor… SEC                    1                 1
#>  9   2024 48963… Drew… OL       Geor… SEC                    1                 1
#> 10   2024 50795… Dwig… RB       Geor… SEC                    0                 0
#> 11   2024 46855… Gunn… QB       Geor… SEC                   34                15
#> 12   2024 48708… Laws… TE       Geor… SEC                    1                 1
#> 13   2024 50784… Lond… WR       Geor… SEC                    1                 1
#> 14   2024 50840… Nate… RB       Geor… SEC                    0                 0
#> 15   2024 49181… Rode… RB       Geor… SEC                    0                 0
#> 16   2024 46853… Trev… RB       Geor… SEC                    0                 0
#> 17   2024 52185… Wade… RB       Geor… SEC                    0                 0
#> # ℹ 4 more variables: passing_success_rate <dbl>, rushing_plays <int>,
#> #   rushing_successes <int>, rushing_success_rate <dbl>
# }
```
