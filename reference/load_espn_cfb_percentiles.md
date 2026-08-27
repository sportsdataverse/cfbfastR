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
#> ℹ Data updated: 2026-08-27 11:02:12 UTC
#> # A tibble: 99 × 27
#>    pctile   GEI EPAplay pass_success rush_success early_down_success
#>     <dbl> <dbl>   <dbl>        <dbl>        <dbl>              <dbl>
#>  1   0.01  1.80  -0.545        0.120        0.131              0.153
#>  2   0.02  2.20  -0.492        0.167        0.156              0.176
#>  3   0.03  2.34  -0.442        0.183        0.169              0.194
#>  4   0.04  2.44  -0.425        0.193        0.182              0.205
#>  5   0.05  2.53  -0.396        0.209        0.191              0.217
#>  6   0.06  2.56  -0.376        0.222        0.208              0.227
#>  7   0.07  2.59  -0.351        0.231        0.214              0.233
#>  8   0.08  2.66  -0.338        0.235        0.222              0.242
#>  9   0.09  2.71  -0.324        0.239        0.231              0.25 
#> 10   0.1   2.80  -0.307        0.245        0.238              0.254
#> # ℹ 89 more rows
#> # ℹ 21 more variables: early_down_EPA <dbl>, late_down_success <dbl>,
#> #   success <dbl>, yardsplay <dbl>, dropbacks <dbl>, rushes <dbl>,
#> #   EPAdropback <dbl>, EPArush <dbl>, yardsdropback <dbl>,
#> #   pass_explosive <dbl>, rush_explosive <dbl>, explosive <dbl>,
#> #   third_down_success <dbl>, red_zone_success <dbl>, play_stuffed <dbl>,
#> #   nonExplosiveEpaPerPlay <dbl>, havoc <dbl>, yardsrush <dbl>, …
# }
```
