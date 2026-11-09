# **ESPN College Football Venues Index**

Get the catalog of stadiums and venues ESPN tracks for college football,
with location, capacity-related flags, and addresses.

## Usage

``` r
espn_cfb_venues(max_results = 200)
```

## Arguments

- max_results:

  (*Integer* default 200): Maximum number of venues to dereference and
  return.

## Value

A data frame with one row per venue:

|           |           |                                          |
|-----------|-----------|------------------------------------------|
| col_name  | types     | description                              |
| venue_id  | character | ESPN venue id.                           |
| full_name | character | Venue full name (e.g. `Tenney Stadium`). |
| city      | character | Venue city.                              |
| state     | character | Venue state.                             |
| zip_code  | character | Venue postal code.                       |
| country   | character | Venue country.                           |
| grass     | logical   | `TRUE` if the playing surface is grass.  |
| indoor    | logical   | `TRUE` if the venue is indoors.          |
| venue_ref | character | `$ref` URL to the venue resource.        |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/venues`.
The index is `$ref`-paginated and large (~911 venues). Dereferencing
every venue is hundreds of HTTP calls, so this wrapper caps the walk at
`max_results` venues (default 200) – raise it to pull more, or set it
high enough to harvest the whole catalog in one (slow) call. Pages are
walked in id order, so the same `max_results` always returns the same
prefix of the catalog.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_venues(max_results = 50))
#> ── Venues index from ESPN ──────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:04:17 UTC
#> # A tibble: 50 × 9
#>    venue_id full_name        city  state zip_code country grass indoor venue_ref
#>    <chr>    <chr>            <chr> <chr> <chr>    <chr>   <lgl> <lgl>  <chr>    
#>  1 36       Tenney Stadium … Poug… NY    12601    USA     FALSE FALSE  http://s…
#>  2 150      Moglia Stadium … Bronx NY    10458    USA     FALSE FALSE  http://s…
#>  3 218      Riccardo Silva … Miami FL    33199    USA     FALSE FALSE  http://s…
#>  4 347      Camp Randall St… Madi… WI    53711    USA     FALSE FALSE  http://s…
#>  5 453      Robertson Stadi… Hous… TX    77004    USA     FALSE TRUE   http://s…
#>  6 477      Los Angeles Mem… Los … CA    90037    USA     TRUE  FALSE  http://s…
#>  7 487      Saint Mary's St… Mora… CA    NA       USA     FALSE FALSE  http://s…
#>  8 499      Cotton Bowl      Dall… TX    75215    USA     TRUE  FALSE  http://s…
#>  9 538      Dignity Health … Cars… CA    90746    USA     TRUE  FALSE  http://s…
#> 10 587      Rice-Eccles Sta… Salt… UT    84112    USA     FALSE FALSE  http://s…
#> # ℹ 40 more rows
# }
```
