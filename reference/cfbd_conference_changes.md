# **Get conference realignment changes**

**Get conference realignment changes** Teams that changed conference in
a given season.

## Usage

``` r
cfbd_conference_changes(year, proxy = NULL)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digits (YYYY).  
  Minimum value accepted: 1887

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_conference_changes()` - A tibble with 11 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| team_id | integer | Referencing team id. |
| team | character | Team name. |
| from_conference_id | integer | Prior referencing conference id. |
| from_conference | character | Prior conference. |
| from_conference_abbreviation | character | Prior conference abbreviation. |
| from_classification | character | Prior division classification. |
| to_conference_id | integer | New referencing conference id. |
| to_conference | character | New conference. |
| to_conference_abbreviation | character | New conference abbreviation. |
| to_classification | character | New division classification. |
| effective_year | integer | Season the conference change takes effect. |

## See also

Other CFBD Conference Functions:
[`cfbd_conference_affiliations()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conference_affiliations.md),
[`cfbd_conferences()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conferences.md)

## Examples

``` r
# \donttest{
  try(cfbd_conference_changes(year = 2024))
#> ── Get conference realignment changes from CollegeFootballData.com ─────────────
#> ℹ Data updated: 2026-08-27 04:14:50 UTC
#> # A tibble: 36 × 11
#>    team_id team        from_conference_id from_conference from_conference_abbr…¹
#>      <int> <chr>                    <int> <chr>           <chr>                 
#>  1      12 Arizona                      9 Pac-12          PAC                   
#>  2       9 Arizona St…                  9 Pac-12          PAC                   
#>  3     349 Army                        18 FBS Independen… Ind                   
#>  4    2045 Austin                     100 American South… NA                    
#>  5  124180 Bluefield …                112 Independent DII NA                    
#>  6    2803 Bryant                     179 Big South-OVC   BSOVC                 
#>  7      25 California                   9 Pac-12          PAC                   
#>  8      38 Colorado                     9 Pac-12          PAC                   
#>  9  101784 Erskine                    139 South Atlantic  NA                    
#> 10  125974 Hilbert                    126 North Coast     NA                    
#> # ℹ 26 more rows
#> # ℹ abbreviated name: ¹​from_conference_abbreviation
#> # ℹ 6 more variables: from_classification <chr>, to_conference_id <int>,
#> #   to_conference <chr>, to_conference_abbreviation <chr>,
#> #   to_classification <chr>, effective_year <int>
# }
```
