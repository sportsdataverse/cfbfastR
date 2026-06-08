# **CFBD Conferences Endpoint Overview**

- `cfbd_conferences()`: Get college football conference information.

**Get college football conference information** Pulls all college
football conferences and returns as data frame

## Usage

``` r
cfbd_conferences()
```

## Value

`cfbd_conferences()` - A data frame with 94 rows and 5 variables:

|                |           |                                                |
|----------------|-----------|------------------------------------------------|
| col_name       | types     | description                                    |
| conference_id  | integer   | Referencing conference id.                     |
| name           | character | Conference name.                               |
| long_name      | character | Long name for Conference.                      |
| abbreviation   | character | Conference abbreviation.                       |
| classification | character | Conference classification (fbs, fcs, ii, iii). |

## Details

### **Get college football conference information**

    cfbd_conferences()

## Examples

``` r
# \donttest{
  try(cfbd_conferences())
#> ── Conference data from CollegeFootballData.com ────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-08 01:41:41 UTC
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
