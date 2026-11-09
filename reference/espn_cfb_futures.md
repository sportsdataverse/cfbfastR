# **ESPN College Football Betting Futures (Long Format)**

Get ESPN's full futures-betting board for a college football season –
national championship, conference, and award markets with the American
odds each sportsbook is offering on every team or player.

## Usage

``` r
espn_cfb_futures(year = NULL)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2014

## Value

A data frame with one row per market-provider-entry:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| market_id | character | ESPN futures-market identifier. |
| market_name | character | Internal market name (e.g. `NCAA(F) - Championship`). |
| market_type | character | Market type code (e.g. `winLeague`). |
| market_display | character | Human-readable market name (e.g. `National Championship Winner`). |
| provider_id | character | Sportsbook / provider identifier. |
| provider_name | character | Sportsbook / provider name (e.g. `ESPN BET`). |
| team_id | character | ESPN team id (parsed from `team_ref`); `NA` for player markets. |
| athlete_id | character | ESPN athlete id (parsed from `athlete_ref`); `NA` for team markets. |
| odds_value | character | American odds for the entry (e.g. `-400`, `+150`). |
| team_ref | character | `$ref` URL to the per-season team resource (may be `NA`). |
| athlete_ref | character | `$ref` URL to the per-season athlete resource (may be `NA`). |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/futures`.
The season index returns one `$ref` per futures market; this wrapper
dereferences each market and flattens the nested
`market -> provider -> books` tree into long format: one row per (market
x provider x entry). Most markets are team markets (national
championship, conference winners) and populate `team_id`; player markets
(e.g. the Heisman) populate `athlete_id` instead, with the other id
column left `NA`. `odds_value` is the raw American-odds string ESPN
returns (e.g. `-400`, `+150`).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_futures(year = 2024))
#> ── Betting futures data from ESPN ──────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:04 UTC
#> # A tibble: 916 × 12
#>    season market_id market_name           market_type market_display provider_id
#>     <int> <chr>     <chr>                 <chr>       <chr>          <chr>      
#>  1   2024 2758      NCAA(F) - Championsh… winLeague   National Cham… 58         
#>  2   2024 2758      NCAA(F) - Championsh… winLeague   National Cham… 58         
#>  3   2024 2758      NCAA(F) - Championsh… winLeague   National Cham… 58         
#>  4   2024 2758      NCAA(F) - Championsh… winLeague   National Cham… 58         
#>  5   2024 2758      NCAA(F) - Championsh… winLeague   National Cham… 58         
#>  6   2024 2758      NCAA(F) - Championsh… winLeague   National Cham… 58         
#>  7   2024 2758      NCAA(F) - Championsh… winLeague   National Cham… 58         
#>  8   2024 2758      NCAA(F) - Championsh… winLeague   National Cham… 58         
#>  9   2024 2758      NCAA(F) - Championsh… winLeague   National Cham… 58         
#> 10   2024 2758      NCAA(F) - Championsh… winLeague   National Cham… 58         
#> # ℹ 906 more rows
#> # ℹ 6 more variables: provider_name <chr>, team_id <chr>, athlete_id <chr>,
#> #   odds_value <chr>, team_ref <chr>, athlete_ref <chr>
# }
```
