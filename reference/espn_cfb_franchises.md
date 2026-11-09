# **ESPN College Football Franchises Index**

Get the catalog of college football franchises ESPN tracks – the stable
program identities (~797) that underpin ESPN's team resources.

## Usage

``` r
espn_cfb_franchises()
```

## Value

A data frame with one row per franchise:

|               |           |                                                  |
|---------------|-----------|--------------------------------------------------|
| col_name      | types     | description                                      |
| franchise_id  | character | ESPN franchise id (parsed from `franchise_ref`). |
| franchise_ref | character | `$ref` URL to the franchise detail resource.     |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/franchises`.
A franchise is the stable program identity, distinct from `/teams`
(which is season-scoped). The index is `$ref`-paginated and large (~797
franchises); dereferencing every franchise would be hundreds of HTTP
calls, so this wrapper returns the lightweight index instead – one row
per franchise with the `franchise_id` parsed from each `$ref`. Pass an
id to
[`espn_cfb_franchise()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchise.md)
to dereference the full detail record (slug, location, nickname,
division, venue, colors, logos).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_franchises())
#> ── Franchises index from ESPN ──────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:02 UTC
#> # A tibble: 808 × 2
#>    franchise_id franchise_ref                                                   
#>    <chr>        <chr>                                                           
#>  1 2            http://sports.core.api.espn.com/v2/sports/football/leagues/coll…
#>  2 5            http://sports.core.api.espn.com/v2/sports/football/leagues/coll…
#>  3 6            http://sports.core.api.espn.com/v2/sports/football/leagues/coll…
#>  4 7            http://sports.core.api.espn.com/v2/sports/football/leagues/coll…
#>  5 8            http://sports.core.api.espn.com/v2/sports/football/leagues/coll…
#>  6 9            http://sports.core.api.espn.com/v2/sports/football/leagues/coll…
#>  7 11           http://sports.core.api.espn.com/v2/sports/football/leagues/coll…
#>  8 12           http://sports.core.api.espn.com/v2/sports/football/leagues/coll…
#>  9 13           http://sports.core.api.espn.com/v2/sports/football/leagues/coll…
#> 10 16           http://sports.core.api.espn.com/v2/sports/football/leagues/coll…
#> # ℹ 798 more rows
# }
```
