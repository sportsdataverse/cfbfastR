# **CFBD Venues Endpoint Overview**

Pulls all college football venues and data on capacity, grass,
city/state, location, elevation, dome, timezone and construction year.

## Usage

``` r
cfbd_venues()
```

## Value

A data frame with 337 rows and 13 variables:

- `venue_id`:integer.:

  Referencing venue ID.

- `name`:character.:

  Venue name.

- `capacity`:integer.:

  Stadium capacity.

- `grass`:logical.:

  TRUE/FALSE response on whether the field is grass or not (oh, and
  there are so many others).

- `city`:character.:

  Venue city.

- `state`:character.:

  Venue state.

- `zip`:character.:

  Venue zip.

- `country_code`:character.:

  Venue country code.

- `latitude`:double.:

  Venue latitude.

- `longitude`: double.:

  Venue longitude.

- `elevation`:character.:

  Venue elevation.

- `year_constructed`:integer.:

  Year in which the venue was constructed.

- `dome`:logical.:

  TRUE/FALSE response to whether the venue has a dome or not.

- `timezone`:character.:

  Time zone in which the venue resides (i.e. Eastern Time -\>
  "America/New York").

## Details

CFB Venue Information

     cfbd_venues()

## Examples

``` r
# \donttest{
  try(cfbd_venues())
#> ── Venue data from CollegeFootballData.com ─────────────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:23:07 UTC
#> # A tibble: 837 × 14
#>    venue_id name    capacity grass dome  city  state zip   country_code timezone
#>       <int> <chr>      <int> <lgl> <lgl> <chr> <chr> <chr> <chr>        <chr>   
#>  1     5938 Al Whi…     4000 NA    FALSE Port… "NM"  88130 US           NA      
#>  2      218 FIU St…    20000 FALSE FALSE Miami "FL"  33199 US           America…
#>  3     4779 Thomas…    15000 TRUE  FALSE Nass… ""    NA    BS           NA      
#>  4    11591 Lokken…       NA NA    FALSE Vall… "ND"  NA    US           NA      
#>  5     5220 Garris…     5000 NA    FALSE Murf… "TN"  NA    US           NA      
#>  6     3884 RAM St…       NA NA    FALSE East… "GA"  NA    US           NA      
#>  7    11589 Hinchl…       NA NA    TRUE  Pate… "NJ"  NA    US           NA      
#>  8     6043 Bethpa…     6000 FALSE FALSE Broo… "NY"  11545 US           America…
#>  9    11539 Charlo…       NA NA    FALSE Jame… "ND"  NA    US           NA      
#> 10    11488 Centre…       NA TRUE  NA    Pawt… "RI"  NA    USA          NA      
#> # ℹ 827 more rows
#> # ℹ 4 more variables: latitude <dbl>, longitude <dbl>, elevation <chr>,
#> #   year_constructed <int>
# }
```
