# **ESPN College Football Season Weeks**

Get the calendar of weeks ESPN tracks for a college football season type
– each week's number, label, and start / end dates.

## Usage

``` r
espn_cfb_season_weeks(year = NULL, season_type = 2)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 1999

- season_type:

  (*Integer* default 2): ESPN season type id. `2` = regular season (the
  only type with a meaningful week calendar), `3` = postseason, `1` =
  preseason.

## Value

A data frame with one row per week:

|             |           |                                       |
|-------------|-----------|---------------------------------------|
| col_name    | types     | description                           |
| season      | integer   | Season (4-digit year).                |
| season_type | integer   | ESPN season type id queried.          |
| week        | integer   | Week number.                          |
| text        | character | Week label (e.g. `Week 1`, `Bowls`).  |
| start_date  | character | Week start timestamp (ISO 8601, UTC). |
| end_date    | character | Week end timestamp (ISO 8601, UTC).   |
| week_ref    | character | `$ref` URL to the week resource.      |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/weeks`.
The index returns one `$ref` per week; this wrapper dereferences each
and returns one row per week (~15-16 for a regular season). The `week`
numbers returned here are the values
[`espn_cfb_week_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_week_rankings.md)
accepts.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_season_weeks(year = 2024))
#> ── Season weeks from ESPN ──────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:04:05 UTC
#> # A tibble: 16 × 7
#>    season season_type  week text    start_date        end_date          week_ref
#>     <int>       <int> <int> <chr>   <chr>             <chr>             <chr>   
#>  1   2024           2     1 Week 1  2024-08-24T07:00Z 2024-09-03T06:59Z http://…
#>  2   2024           2     2 Week 2  2024-09-03T07:00Z 2024-09-09T06:59Z http://…
#>  3   2024           2     3 Week 3  2024-09-09T07:00Z 2024-09-16T06:59Z http://…
#>  4   2024           2     4 Week 4  2024-09-16T07:00Z 2024-09-23T06:59Z http://…
#>  5   2024           2     5 Week 5  2024-09-23T07:00Z 2024-09-30T06:59Z http://…
#>  6   2024           2     6 Week 6  2024-09-30T07:00Z 2024-10-07T06:59Z http://…
#>  7   2024           2     7 Week 7  2024-10-07T07:00Z 2024-10-14T06:59Z http://…
#>  8   2024           2     8 Week 8  2024-10-14T07:00Z 2024-10-21T06:59Z http://…
#>  9   2024           2     9 Week 9  2024-10-21T07:00Z 2024-10-28T06:59Z http://…
#> 10   2024           2    10 Week 10 2024-10-28T07:00Z 2024-11-04T07:59Z http://…
#> 11   2024           2    11 Week 11 2024-11-04T08:00Z 2024-11-11T07:59Z http://…
#> 12   2024           2    12 Week 12 2024-11-11T08:00Z 2024-11-18T07:59Z http://…
#> 13   2024           2    13 Week 13 2024-11-18T08:00Z 2024-11-25T07:59Z http://…
#> 14   2024           2    14 Week 14 2024-11-25T08:00Z 2024-12-02T07:59Z http://…
#> 15   2024           2    15 Week 15 2024-12-02T08:00Z 2024-12-09T07:59Z http://…
#> 16   2024           2    16 Week 16 2024-12-09T08:00Z 2024-12-14T07:59Z http://…
# }
```
