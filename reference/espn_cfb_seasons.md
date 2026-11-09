# **ESPN College Football Seasons Index**

Get the index of every college football season ESPN tracks in its
core-v2 API, with each season's start and end dates.

## Usage

``` r
espn_cfb_seasons()
```

## Value

A data frame with one row per season:

|              |           |                                         |
|--------------|-----------|-----------------------------------------|
| col_name     | types     | description                             |
| season       | integer   | Season (4-digit year).                  |
| display_name | character | ESPN display name for the season.       |
| start_date   | character | Season start timestamp (ISO 8601, UTC). |
| end_date     | character | Season end timestamp (ISO 8601, UTC).   |
| season_ref   | character | `$ref` URL to the season resource.      |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons`.
The index is `$ref`-paginated; this wrapper walks every page,
dereferences each season `$ref`, and returns one row per season. ESPN's
CFB season coverage runs back to the early 1900s, so the table is long –
filter on `season` for the years you need. Use
[`espn_cfb_season_info()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_info.md)
for the full per-season detail (season types, rankings, awards, futures
refs).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# One request per season back to the early 1900s (about 150), so this takes
# a while.
try(espn_cfb_seasons())
#> ── Seasons index from ESPN ─────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:13:13 UTC
#> # A tibble: 155 × 5
#>    season display_name start_date        end_date          season_ref           
#>     <int> <chr>        <chr>             <chr>             <chr>                
#>  1   2026 2026         2026-02-01T08:00Z 2027-01-28T07:59Z http://sports.core.a…
#>  2   2025 2025         2025-02-01T08:00Z 2026-01-21T07:59Z http://sports.core.a…
#>  3   2024 2024         2024-07-01T07:00Z 2025-01-22T07:59Z http://sports.core.a…
#>  4   2023 2023         2023-07-01T07:00Z 2024-01-10T07:59Z http://sports.core.a…
#>  5   2022 2022         2022-07-01T07:00Z 2023-01-11T07:59Z http://sports.core.a…
#>  6   2021 2021         2021-07-01T07:00Z 2022-01-12T07:59Z http://sports.core.a…
#>  7   2020 2020         2020-08-01T07:00Z 2021-01-31T07:59Z http://sports.core.a…
#>  8   2019 2019         2019-07-01T07:00Z 2020-01-15T07:59Z http://sports.core.a…
#>  9   2018 2018         2018-07-01T07:00Z 2019-01-16T07:59Z http://sports.core.a…
#> 10   2017 2017         2017-07-01T07:00Z 2018-01-17T07:59Z http://sports.core.a…
#> # ℹ 145 more rows
```
