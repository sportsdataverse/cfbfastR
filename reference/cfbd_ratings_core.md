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
#> ── Get core team ratings from CollegeFootballData.com ─── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-26 06:47:56 UTC
#> # A tibble: 134 × 11
#>     year through_season_type through_week team        conference overall offense
#>    <int> <chr>                      <int> <chr>       <chr>        <dbl>   <dbl>
#>  1  2024 postseason                     1 Ohio State  Big Ten       39.0   24.7 
#>  2  2024 postseason                     1 Notre Dame  FBS Indep…    35.4   12.0 
#>  3  2024 postseason                     1 Texas       SEC           27.4    7.05
#>  4  2024 postseason                     1 Penn State  Big Ten       27.2   14.5 
#>  5  2024 postseason                     1 Ole Miss    SEC           26.1   12.0 
#>  6  2024 postseason                     1 Indiana     Big Ten       25.9   13.7 
#>  7  2024 postseason                     1 Miami       ACC           25.0   20.7 
#>  8  2024 postseason                     1 Oregon      Big Ten       22.3   17.2 
#>  9  2024 postseason                     1 SMU         ACC           19.2    3.99
#> 10  2024 postseason                     1 Kansas Sta… Big 12        19.0    9.05
#> # ℹ 124 more rows
#> # ℹ 4 more variables: defense <dbl>, offense_plays <int>, defense_plays <int>,
#> #   model_version <chr>
# }
```
