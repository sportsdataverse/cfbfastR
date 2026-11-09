# **ESPN College Football Season Detail**

Get the ESPN core-v2 detail record for a single college football season
– start / end dates, the active season type, and the `$ref` links to
that season's types, rankings, athletes, awards, and futures
sub-resources.

## Usage

``` r
espn_cfb_season_info(year = NULL)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 1872

## Value

A single-row data frame:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| display_name | character | ESPN display name for the season. |
| start_date | character | Season start timestamp (ISO 8601, UTC). |
| end_date | character | Season end timestamp (ISO 8601, UTC). |
| active_type_id | integer | ESPN id of the currently active season type. |
| active_type | integer | Active season type code (1 pre, 2 reg, 3 post). |
| active_type_name | character | Active season type name (e.g. `Regular Season`). |
| types_ref | character | `$ref` URL to the season types index. |
| rankings_ref | character | `$ref` URL to the season rankings index. |
| athletes_ref | character | `$ref` URL to the season athletes index. |
| awards_ref | character | `$ref` URL to the season awards index. |
| futures_ref | character | `$ref` URL to the season betting-futures index. |
| leaders_ref | character | `$ref` URL to the season leaders resource. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}`.
Returns a single-row tibble. The `*_ref` columns are the season-scoped
sub-resource entry points – feed `types_ref` to
[`espn_cfb_season_types()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_types.md),
`rankings_ref` to
[`espn_cfb_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_rankings.md),
and so on. `active_type_*` describes the season type ESPN currently
considers "live" for the year (preseason / regular / postseason /
off-season).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_season_info(year = 2024))
#> ── Season detail from ESPN ─────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:13:02 UTC
#> # A tibble: 1 × 13
#>   season display_name start_date        end_date      active_type_id active_type
#>    <int> <chr>        <chr>             <chr>                  <int>       <int>
#> 1   2024 2024         2024-07-01T07:00Z 2025-01-22T0…              3           3
#> # ℹ 7 more variables: active_type_name <chr>, types_ref <chr>,
#> #   rankings_ref <chr>, athletes_ref <chr>, awards_ref <chr>,
#> #   futures_ref <chr>, leaders_ref <chr>
# }
```
