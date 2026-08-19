# **Get core team ratings**

**Get core team ratings** CFBD's core team rating measures.

## Usage

``` r
cfbd_ratings_core(year = NULL, team = NULL, conference = NULL, proxy = NULL)
```

## Arguments

- year:

  (*Integer* optional): Season, 4 digits (YYYY).  
  Minimum value accepted: 2016

- team:

  (*String* optional): Team filter.

- conference:

  (*String* optional): Conference abbreviation filter.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_ratings_core()` - A tibble with 11 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| year | integer | Four-digit season year. |
| through_season_type | character | Season type the rating is computed through. |
| through_week | integer | Week the rating is computed through. |
| team | character | Team name. |
| conference | character | Conference name. |
| overall | numeric | Overall rating. |
| offense | numeric | Offensive rating. |
| defense | numeric | Defensive rating. |
| offense_plays | integer | Offensive plays underlying the rating. |
| defense_plays | integer | Defensive plays underlying the rating. |
| model_version | character | Version of the rating model that produced the row. |

## See also

Other CFBD Ratings Functions:
[`cfbd_ratings_srs_expanded()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs_expanded.md)

## Examples

``` r
# \donttest{
  try(cfbd_ratings_core(year = 2024))
#> ── Get core team ratings from CollegeFootballData.com ──────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 17:55:38 UTC
#> # A tibble: 134 × 11
#>     year through_season_type through_week team        conference overall offense
#>    <int> <chr>                      <int> <chr>       <chr>        <dbl>   <dbl>
#>  1  2024 postseason                     1 Ohio State  Big Ten       37.2   22.0 
#>  2  2024 postseason                     1 Notre Dame  FBS Indep…    28.5   10.6 
#>  3  2024 postseason                     1 Penn State  Big Ten       25.4   12.9 
#>  4  2024 postseason                     1 Texas       SEC           22.7    6.58
#>  5  2024 postseason                     1 Ole Miss    SEC           22.0    9.43
#>  6  2024 postseason                     1 Miami       ACC           20.6   18.2 
#>  7  2024 postseason                     1 Indiana     Big Ten       20.1   12.4 
#>  8  2024 postseason                     1 Kansas Sta… Big 12        19.4   10.8 
#>  9  2024 postseason                     1 Oregon      Big Ten       18.9   14.2 
#> 10  2024 postseason                     1 SMU         ACC           17.2    4.38
#> # ℹ 124 more rows
#> # ℹ 4 more variables: defense <dbl>, offense_plays <int>, defense_plays <int>,
#> #   model_version <chr>
# }
```
