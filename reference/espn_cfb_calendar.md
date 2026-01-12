# ESPN Calendar

look up the men's college football calendar for a given season

## Usage

``` r
espn_cfb_calendar(year = NULL, groups = NULL)
```

## Arguments

- year:

  (int): Used to define different seasons. 2002 is the earliest
  available season.

- groups:

  (string): Used to define different divisions. FBS or FCS.

## Value

`espn_cfb_calendar()` - A data frame with 8 variables:

- `season`: character.:

  .

- `season_type`: character.:

  .

- `label`: character.:

  .

- `alternate_label`: character.:

  .

- `detail`: character.:

  .

- `week`: character.:

  .

- `start_date`: character.:

  .

- `end_date`: character.:

  .

## Examples

``` r
# \donttest{
  try(espn_cfb_calendar(2021))
#> ── Calendar Data from ESPN ─────────────────────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:08 UTC
#> # A tibble: 17 × 8
#>    season season_type    label  alternate_label detail week  start_date end_date
#>    <chr>  <chr>          <chr>  <chr>           <chr>  <chr> <chr>      <chr>   
#>  1 2021   Regular Season Week 1 Week 1          Jul 2… 1     2021-07-2… 2021-09…
#>  2 2021   Regular Season Week 2 Week 2          Sep 7… 2     2021-09-0… 2021-09…
#>  3 2021   Regular Season Week 3 Week 3          Sep 1… 3     2021-09-1… 2021-09…
#>  4 2021   Regular Season Week 4 Week 4          Sep 2… 4     2021-09-2… 2021-09…
#>  5 2021   Regular Season Week 5 Week 5          Sep 2… 5     2021-09-2… 2021-10…
#>  6 2021   Regular Season Week 6 Week 6          Oct 5… 6     2021-10-0… 2021-10…
#>  7 2021   Regular Season Week 7 Week 7          Oct 1… 7     2021-10-1… 2021-10…
#>  8 2021   Regular Season Week 8 Week 8          Oct 1… 8     2021-10-1… 2021-10…
#>  9 2021   Regular Season Week 9 Week 9          Oct 2… 9     2021-10-2… 2021-11…
#> 10 2021   Regular Season Week … Week 10         Nov 2… 10    2021-11-0… 2021-11…
#> 11 2021   Regular Season Week … Week 11         Nov 9… 11    2021-11-0… 2021-11…
#> 12 2021   Regular Season Week … Week 12         Nov 1… 12    2021-11-1… 2021-11…
#> 13 2021   Regular Season Week … Week 13         Nov 2… 13    2021-11-2… 2021-11…
#> 14 2021   Regular Season Week … Week 14         Nov 3… 14    2021-11-3… 2021-12…
#> 15 2021   Regular Season Week … Week 15         Dec 7… 15    2021-12-0… 2021-12…
#> 16 2021   Postseason     Bowls  Bowls           Dec 1… 1     2021-12-1… 2022-01…
#> 17 2021   Off Season     All-S… All-Star        Jan 1… 1     2022-01-1… 2022-07…
# }
```
