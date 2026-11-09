# **ESPN College Football Ranking Sources**

Get the index of poll / ranking sources ESPN publishes for a college
football season – the AP Top 25, the Coaches Poll, the CFP committee
rankings, and the computer-derived polls.

## Usage

``` r
espn_cfb_rankings(year = NULL)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2000

## Value

A data frame with one row per ranking source:

|             |           |                                                     |
|-------------|-----------|-----------------------------------------------------|
| col_name    | types     | description                                         |
| season      | integer   | Season (4-digit year).                              |
| ranking_id  | character | ESPN ranking source id.                             |
| name        | character | Ranking source name (e.g. `AP Top 25`).             |
| short_name  | character | Ranking source short name (e.g. `AP Poll`).         |
| type        | character | Ranking source type code (e.g. `ap`, `cfp`).        |
| n_snapshots | integer   | Number of weekly snapshots published by the source. |
| ranking_ref | character | `$ref` URL to the ranking source resource.          |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/rankings`.
The index returns one `$ref` per ranking source (~6-7); this wrapper
dereferences each and returns one row per source, with a count of how
many weekly snapshots that source published in the season. To pull the
actual ranked teams for a given week, feed `season`, `season_type`, and
a `week` to
[`espn_cfb_week_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_week_rankings.md).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_rankings(year = 2024))
#> ── Ranking sources from ESPN ───────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:49 UTC
#> # A tibble: 7 × 7
#>   season ranking_id name                short_name type  n_snapshots ranking_ref
#>    <int> <chr>      <chr>               <chr>      <chr>       <int> <chr>      
#> 1   2024 21         Playoff Committee … CFP Ranki… cfp             6 http://spo…
#> 2   2024 22         College Football P… CFP Seedi… tour…           1 http://spo…
#> 3   2024 1          AP Top 25           AP Poll    ap             17 http://spo…
#> 4   2024 2          AFCA Coaches Poll   AFCA Coac… usa            17 http://spo…
#> 5   2024 20         FCS Coaches Poll    FCS Coach… fcs            15 http://spo…
#> 6   2024 11         AFCA Division II C… AFCA Div … afca           13 http://spo…
#> 7   2024 12         AFCA Division III … AFCA Div … afca           13 http://spo…
# }
```
