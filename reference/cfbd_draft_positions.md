# **Get list of NFL positions**

**Get list of NFL positions**

## Usage

``` r
cfbd_draft_positions()
```

## Value

`cfbd_draft_positions()` - A data frame with 2 variables:

- `position_name`: character.:

  NFL Position group name.

- `position_abbreviation`: integer:

  NFL position group abbreviation.

## See also

Other CFBD Draft:
[`cfbd_draft_picks()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_picks.md),
[`cfbd_draft_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_teams.md)

## Examples

``` r
# \donttest{
  try(cfbd_draft_positions())
#> ── NFL positions data from CollegeFootballData.com ─────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:30 UTC
#> # A tibble: 29 × 2
#>    position_name     position_abbreviation
#>    <chr>             <chr>                
#>  1 Center            C                    
#>  2 Cornerback        CB                   
#>  3 Defensive Back    DB                   
#>  4 Defensive Edge    EDGE                 
#>  5 Defensive End     DE                   
#>  6 Defensive Lineman DL                   
#>  7 Defensive Tackle  DT                   
#>  8 Free Safety       FS                   
#>  9 Fullback          FB                   
#> 10 Inside Linebacker ILB                  
#> # ℹ 19 more rows
# }
```
