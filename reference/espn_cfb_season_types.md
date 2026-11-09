# **ESPN College Football Season Types**

Get the set of season types (preseason, regular season, postseason,
off-season) ESPN tracks for a college football season, including each
type's date window and capability flags.

## Usage

``` r
espn_cfb_season_types(year = NULL)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 1872

## Value

A data frame with one row per season type:

|               |           |                                                    |
|---------------|-----------|----------------------------------------------------|
| col_name      | types     | description                                        |
| season        | integer   | Season (4-digit year).                             |
| season_type   | integer   | ESPN season type id (1 pre, 2 reg, 3 post, 4 off). |
| type          | integer   | Season type code (mirrors `season_type`).          |
| name          | character | Season type name (e.g. `Regular Season`).          |
| abbreviation  | character | Season type abbreviation (e.g. `reg`).             |
| slug          | character | Season type slug (e.g. `regular-season`).          |
| start_date    | character | Season type start timestamp (ISO 8601, UTC).       |
| end_date      | character | Season type end timestamp (ISO 8601, UTC).         |
| has_groups    | logical   | Whether the season type exposes a groups resource. |
| has_standings | logical   | Whether the season type exposes standings.         |
| type_ref      | character | `$ref` URL to the season type resource.            |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types`.
The index returns one `$ref` per season type; this wrapper dereferences
each and returns one row per type (typically four: `1` preseason, `2`
regular season, `3` postseason, `4` off-season). The `season_type` ids
returned here are the values other Batch 5 wrappers
([`espn_cfb_season_weeks()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_weeks.md),
[`espn_cfb_groups()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_groups.md),
[`espn_cfb_standings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_standings.md),
[`espn_cfb_week_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_week_rankings.md))
accept as their `season_type` argument.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_season_types(year = 2024))
#> ── Season types from ESPN ──────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:04:03 UTC
#> # A tibble: 4 × 11
#>   season season_type  type name           abbreviation slug  start_date end_date
#>    <int>       <int> <int> <chr>          <chr>        <chr> <chr>      <chr>   
#> 1   2024           1     1 Preseason      pre          pres… 2024-07-0… 2024-08…
#> 2   2024           2     2 Regular Season reg          regu… 2024-08-2… 2024-12…
#> 3   2024           3     3 Postseason     post         post… 2024-12-1… 2025-01…
#> 4   2024           4     4 Off Season     off          off-… 2025-01-2… 2025-02…
#> # ℹ 3 more variables: has_groups <lgl>, has_standings <lgl>, type_ref <chr>
# }
```
