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
#> 2026-10-22 17:19:44.323481: Invalid arguments or no game info data available! The CFBD API returned HTTP 502 (Bad Gateway)
#> ── Games and schedules from CollegeFootballData.com ───── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-22 17:19:44 UTC
#> # A tibble: 0 × 0
# }
```
