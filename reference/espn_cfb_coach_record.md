# **ESPN College Football Coach Season Record**

Get a college football coach's win/loss record for a single season – the
headline summary plus every stat category ESPN publishes for that
coach-season (wins, losses, ties, overtime wins/losses), in long format.

## Usage

``` r
espn_cfb_coach_record(coach_id = NULL, year = NULL, season_type = 2)
```

## Arguments

- coach_id:

  (*Integer* required): ESPN coach id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2001

- season_type:

  (*Integer* default 2): ESPN season type – `2` for regular season, `3`
  for postseason.

## Value

A data frame with one row per stat category:

|  |  |  |
|----|----|----|
| col_name | types | description |
| coach_id | character | ESPN coach id queried. |
| season | integer | Season (4-digit year) queried. |
| season_type | integer | ESPN season type queried (`2` regular, `3` post). |
| record_id | character | ESPN record id (season-type id, e.g. `2`). |
| record_name | character | Record name (e.g. `Regular Season`). |
| record_type | character | Record type (e.g. `Regular Season`). |
| record_summary | character | Season record summary (e.g. `7-6-0`). |
| record_value | numeric | Season win-percentage value (may be `NA`). |
| stat_name | character | Stat key (e.g. `wins`, `losses`, `OTWins`). |
| display_name | character | Human-readable stat name (e.g. `Wins`). |
| short_display_name | character | Short stat name (e.g. `W`). |
| abbreviation | character | Stat abbreviation (e.g. `W`). |
| stat_type | character | Internal stat type key (e.g. `wins`). |
| description | character | ESPN's description of the stat. |
| value | numeric | Stat value. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/coaches/{coach_id}/record`.
The `records` block is otherwise only reachable nested inside
[`espn_cfb_coach()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach.md);
this wrapper exposes it tabular. Returns one row per stat category. Each
row carries the season-level `summary`/`value` alongside the per-stat
fields, so the table is self-describing. Enumerate `coach_id`s with
[`espn_cfb_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coaches.md).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_coach_record(coach_id = 5120149, year = 2024))
#> ── Coach season record from ESPN ───────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:03:21 UTC
#> # A tibble: 5 × 15
#>   coach_id season season_type record_id record_name   record_type record_summary
#>   <chr>     <int>       <int> <chr>     <chr>         <chr>       <chr>         
#> 1 5120149    2024           2 2         Regular Seas… Regular Se… 7-6-0         
#> 2 5120149    2024           2 2         Regular Seas… Regular Se… 7-6-0         
#> 3 5120149    2024           2 2         Regular Seas… Regular Se… 7-6-0         
#> 4 5120149    2024           2 2         Regular Seas… Regular Se… 7-6-0         
#> 5 5120149    2024           2 2         Regular Seas… Regular Se… 7-6-0         
#> # ℹ 8 more variables: record_value <dbl>, stat_name <chr>, display_name <chr>,
#> #   short_display_name <chr>, abbreviation <chr>, stat_type <chr>,
#> #   description <chr>, value <dbl>
# }
```
