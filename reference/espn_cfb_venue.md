# **ESPN College Football Venue Detail**

Get the ESPN core-v2 detail record for a single college football venue –
full name, address, playing-surface and indoor flags.

## Usage

``` r
espn_cfb_venue(venue_id = NULL)
```

## Arguments

- venue_id:

  (*Integer* required): ESPN venue id.

## Value

A single-row data frame:

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
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/venues/{venue_id}`.
[`espn_cfb_venues()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venues.md)
returns the venue index; this wrapper returns the single-venue detail
for one id. Returns a single-row tibble. Enumerate `venue_id`s with
[`espn_cfb_venues()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venues.md).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_venue(venue_id = 3785))
#> ── Venue detail from ESPN ──────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:13:36 UTC
#> # A tibble: 1 × 9
#>   venue_id full_name         city  state zip_code country grass indoor venue_ref
#>   <chr>    <chr>             <chr> <chr> <chr>    <chr>   <lgl> <lgl>  <chr>    
#> 1 3785     Jordan-Hare Stad… Aubu… AL    36849    USA     TRUE  FALSE  http://s…
# }
```
