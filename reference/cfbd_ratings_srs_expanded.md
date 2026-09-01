# **Get expanded SRS ratings**

**Get expanded SRS ratings** Simple Rating System with its component
breakdown.

## Usage

``` r
cfbd_ratings_srs_expanded(
  year = NULL,
  team = NULL,
  conference = NULL,
  division = NULL,
  proxy = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Season, 4 digits (YYYY).  
  Minimum value accepted: 2003

- team:

  (*String* optional): Team filter.

- conference:

  (*String* optional): Conference abbreviation filter.

- division:

  (*String* optional): Division/classification filter – `fbs`, `fcs`,
  `ii`, `ii/iii`, `iii`.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_ratings_srs_expanded()` - A tibble with 7 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| year | integer | Four-digit season year. |
| team | character | Team name. |
| classification | character | Division classification (fbs, fcs, ii, ii/iii, iii). |
| conference | character | Conference name. |
| division | logical | Division. |
| ranking | integer | Rank by rating. |
| rating | numeric | Rating value. |

## See also

Other CFBD Ratings Functions:
[`cfbd_ratings_core()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_core.md)

## Examples

``` r
# \donttest{
  try(cfbd_ratings_srs_expanded(year = 2024))
#> ── Get expanded SRS ratings from CollegeFootballData.com ───────────────────────
#> ℹ Data updated: 2026-09-01 11:23:43 UTC
#> # A tibble: 264 × 7
#>     year team           classification conference       division ranking rating
#>    <int> <chr>          <chr>          <chr>            <chr>      <int>  <dbl>
#>  1  2024 Ohio State     fbs            Big Ten          NA             1   24.6
#>  2  2024 Notre Dame     fbs            FBS Independents NA             2   22  
#>  3  2024 Texas          fbs            SEC              NA             3   19.4
#>  4  2024 Penn State     fbs            Big Ten          NA             4   19.3
#>  5  2024 Ole Miss       fbs            SEC              NA             5   19.2
#>  6  2024 Alabama        fbs            SEC              NA             6   18.1
#>  7  2024 Indiana        fbs            Big Ten          NA             7   17.7
#>  8  2024 Oregon         fbs            Big Ten          NA             8   17.1
#>  9  2024 Georgia        fbs            SEC              NA             9   16.3
#> 10  2024 South Carolina fbs            SEC              NA            10   15.8
#> # ℹ 254 more rows
# }
```
