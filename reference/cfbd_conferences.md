# **CFBD Conferences Endpoint Overview**

**Get college football conference information** Pulls all college
football conferences and returns as data frame

## Usage

``` r
cfbd_conferences()
```

## Value

`cfbd_conferences()` - A data frame with 94 rows and 5 variables:

- `conference_id`::

  Referencing conference id.

- `name`::

  Conference name.

- `long_name`::

  Long name for Conference.

- `abbreviation`::

  Conference abbreviation.

- `classification`::

  Conference classification (fbs,fcs,ii,iii)

## Examples

``` r
# \donttest{
  try(cfbd_conferences())
#> ── Conference data from CollegeFootballData.com ────────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:21:47 UTC
#> # A tibble: 106 × 5
#>    conference_id name          long_name             abbreviation classification
#>            <int> <chr>         <chr>                 <chr>        <chr>         
#>  1           187 Carolinas     Conference Carolinas  NA           ii            
#>  2            22 Ivy           Ivy League            NA           fcs           
#>  3            15 Mid-American  Mid-American Confere… MAC          fbs           
#>  4            17 Mountain West Mountain West Confer… MWC          fbs           
#>  5             9 Pac-12        Pac-12 Conference     PAC          fbs           
#>  6             8 SEC           Southeastern Confere… SEC          fbs           
#>  7           220 Pac-10        Pacific 10            Pac-10       fbs           
#>  8           175 AWC           ASUN-WAC Challenge    NA           fcs           
#>  9            20 Big Sky       Big Sky Conference    NA           fcs           
#> 10            40 Big South     Big South Conference  NA           fcs           
#> # ℹ 96 more rows
# }
```
