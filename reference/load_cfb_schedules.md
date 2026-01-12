# Load CFB Game/Schedule Data from data repo

This function returns game/schedule information for the specified
season(s). This function wraps the
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
function sourced from the College Football Data API.

## Usage

``` r
load_cfb_schedules(seasons = most_recent_cfb_season())
```

## Arguments

- seasons:

  a numeric vector of seasons to return, default `TRUE` returns all
  available data.

## Value

A tibble of game information for past and/or future games.

## See also

[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)

Issues with this data should be filed here:
<https://github.com/sportsdataverse/cfbfastR-data>

Other loaders:
[`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md),
[`load_cfb_rosters()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_rosters.md),
[`load_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_teams.md),
[`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md)

## Examples

``` r
# \donttest{
  try(load_cfb_schedules(2024))
#> ── Games and schedules from CollegeFootballData.com ────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:22:01 UTC
#> # A tibble: 3,801 × 31
#>      game_id season  week season_type start_date        start_time_tbd completed
#>        <int>  <int> <int> <chr>       <chr>             <lgl>          <lgl>    
#>  1 401693677   2024     1 regular     2024-08-24T04:00… TRUE           TRUE     
#>  2 401635525   2024     1 regular     2024-08-24T16:00… FALSE          TRUE     
#>  3 401654665   2024     1 regular     2024-08-24T19:30… FALSE          TRUE     
#>  4 401643697   2024     1 regular     2024-08-24T20:00… FALSE          TRUE     
#>  5 401654662   2024     1 regular     2024-08-24T23:00… FALSE          TRUE     
#>  6 401636372   2024     1 regular     2024-08-24T23:30… FALSE          TRUE     
#>  7 401643696   2024     1 regular     2024-08-25T00:00… FALSE          TRUE     
#>  8 401643858   2024     1 regular     2024-08-25T03:59… FALSE          TRUE     
#>  9 401675545   2024     1 regular     2024-08-29T04:00… TRUE           TRUE     
#> 10 401628580   2024     1 regular     2024-08-29T22:00… FALSE          TRUE     
#> # ℹ 3,791 more rows
#> # ℹ 24 more variables: neutral_site <lgl>, conference_game <lgl>,
#> #   attendance <int>, venue_id <int>, venue <chr>, home_id <int>,
#> #   home_team <chr>, home_division <chr>, home_conference <chr>,
#> #   home_points <int>, home_post_win_prob <dbl>, home_pregame_elo <int>,
#> #   home_postgame_elo <int>, away_id <int>, away_team <chr>,
#> #   away_division <chr>, away_conference <chr>, away_points <int>, …
# }
```
