# **Get calendar of weeks by season.**

**Get calendar of weeks by season.**

## Usage

``` r
cfbd_calendar(year)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)

## Value

`cfbd_calendar()` - A data frame with 5 variables:

- `season`: character.:

  Calendar season.

- `week`: integer.:

  Calendar game week.

- `season_type`: character:

  Season type of calendar week.

- `first_game_start`: character.:

  First game start time of the calendar week.

- `last_game_start`: character.:

  Last game start time of the calendar week.

## See also

Other CFBD Games:
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_calendar(2019))
#> ── Calendar data from CollegeFootballData.com ──────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:27 UTC
#> # A tibble: 17 × 5
#>    season  week season_type first_game_start         last_game_start         
#>     <int> <int> <chr>       <chr>                    <chr>                   
#>  1   2019     1 regular     2019-07-25T07:00:00.000Z 2019-09-03T06:59:00.000Z
#>  2   2019     2 regular     2019-09-03T07:00:00.000Z 2019-09-10T06:59:00.000Z
#>  3   2019     3 regular     2019-09-10T07:00:00.000Z 2019-09-17T06:59:00.000Z
#>  4   2019     4 regular     2019-09-17T07:00:00.000Z 2019-09-24T06:59:00.000Z
#>  5   2019     5 regular     2019-09-24T07:00:00.000Z 2019-10-01T06:59:00.000Z
#>  6   2019     6 regular     2019-10-01T07:00:00.000Z 2019-10-08T06:59:00.000Z
#>  7   2019     7 regular     2019-10-08T07:00:00.000Z 2019-10-15T06:59:00.000Z
#>  8   2019     8 regular     2019-10-15T07:00:00.000Z 2019-10-22T06:59:00.000Z
#>  9   2019     9 regular     2019-10-22T07:00:00.000Z 2019-10-29T06:59:00.000Z
#> 10   2019    10 regular     2019-10-29T07:00:00.000Z 2019-11-05T07:59:00.000Z
#> 11   2019    11 regular     2019-11-05T08:00:00.000Z 2019-11-12T07:59:00.000Z
#> 12   2019    12 regular     2019-11-12T08:00:00.000Z 2019-11-19T07:59:00.000Z
#> 13   2019    13 regular     2019-11-19T08:00:00.000Z 2019-11-26T07:59:00.000Z
#> 14   2019    14 regular     2019-11-26T08:00:00.000Z 2019-12-03T07:59:00.000Z
#> 15   2019    15 regular     2019-12-03T08:00:00.000Z 2019-12-10T07:59:00.000Z
#> 16   2019    16 regular     2019-12-10T08:00:00.000Z 2019-12-16T07:59:00.000Z
#> 17   2019     1 postseason  2019-12-16T08:00:00.000Z 2020-01-15T07:59:00.000Z
# }
```
