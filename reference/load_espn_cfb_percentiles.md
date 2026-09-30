# **Load college football team percentile profiles from the SportsDataverse data repo**

Loads season-level team percentile profiles – one row per team with
league-percentile placements across the summary metrics. Published to
the `espn_cfb_percentiles` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_percentiles(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2004 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2004)

- ...:

  Additional arguments passed to an underlying function that writes the
  season data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble.

|  |  |  |
|----|----|----|
| col_name | types | description |
| pctile | double | Percentile bucket the row reports, from 0 to 100. |
| GEI | double | Value of game excitement index at the percentile this row reports. |
| EPAplay | double | Value of EPA generated per play at the percentile this row reports. |
| pass_success | double | Value of success rate on pass plays at the percentile this row reports. |
| rush_success | double | Value of success rate on rush plays at the percentile this row reports. |
| early_down_success | double | Value of success rate on early downs at the percentile this row reports. |
| early_down_EPA | double | Value of EPA per early-down play at the percentile this row reports. |
| late_down_success | double | Value of success rate on late downs at the percentile this row reports. |
| success | double | Value of success rate across the team plays at the percentile this row reports. |
| yardsplay | double | Value of yards per play at the percentile this row reports. |
| dropbacks | double | Value of dropbacks taken by the passer at the percentile this row reports. |
| rushes | double | Value of rushing attempts at the percentile this row reports. |
| EPAdropback | double | Value of EPA generated per dropback at the percentile this row reports. |
| EPArush | double | Value of EPA generated per rushing attempt at the percentile this row reports. |
| yardsdropback | double | Value of yards per dropback at the percentile this row reports. |
| pass_explosive | double | Value of explosive-play rate on pass plays at the percentile this row reports. |
| rush_explosive | double | Value of explosive-play rate on rush plays at the percentile this row reports. |
| explosive | double | Value of explosive-play rate at the percentile this row reports. |
| third_down_success | double | Value of success rate on third down at the percentile this row reports. |
| red_zone_success | double | Value of success rate in the red zone at the percentile this row reports. |
| play_stuffed | double | Value of stuffed-play rate at the percentile this row reports. |
| nonExplosiveEpaPerPlay | double | Value of EPA per play excluding explosive plays at the percentile this row reports. |
| havoc | double | Value of havoc rate at the percentile this row reports. |
| yardsrush | double | Value of yards per rush at the percentile this row reports. |
| lineyards | double | Value of line yards per rush at the percentile this row reports. |
| opportunity_run | double | Value of opportunity-run rate at the percentile this row reports. |
| third_down_distance | double | Value of average yards to go on third down at the percentile this row reports. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_percentiles(2004))
#> ── college football team percentile profiles from the SportsDataverse data repo 
#> ℹ Data updated: 2026-09-30 15:18:52 UTC
#> # A tibble: 99 × 27
#>    pctile   GEI EPAplay pass_success rush_success early_down_success
#>     <dbl> <dbl>   <dbl>        <dbl>        <dbl>              <dbl>
#>  1   0.01  1.73  -0.574        0.143        0.154              0.199
#>  2   0.02  1.88  -0.490        0.180        0.178              0.219
#>  3   0.03  2.18  -0.450        0.212        0.197              0.244
#>  4   0.04  2.28  -0.417        0.227        0.214              0.251
#>  5   0.05  2.41  -0.380        0.241        0.225              0.265
#>  6   0.06  2.46  -0.356        0.25         0.233              0.274
#>  7   0.07  2.50  -0.345        0.25         0.242              0.277
#>  8   0.08  2.54  -0.334        0.263        0.25               0.283
#>  9   0.09  2.56  -0.313        0.267        0.262              0.290
#> 10   0.1   2.61  -0.301        0.276        0.268              0.295
#> # ℹ 89 more rows
#> # ℹ 21 more variables: early_down_EPA <dbl>, late_down_success <dbl>,
#> #   success <dbl>, yardsplay <dbl>, dropbacks <dbl>, rushes <dbl>,
#> #   EPAdropback <dbl>, EPArush <dbl>, yardsdropback <dbl>,
#> #   pass_explosive <dbl>, rush_explosive <dbl>, explosive <dbl>,
#> #   third_down_success <dbl>, red_zone_success <dbl>, play_stuffed <dbl>,
#> #   nonExplosiveEpaPerPlay <dbl>, havoc <dbl>, yardsrush <dbl>, …
# }
```
