# **Load college football returning production from the SportsDataverse data repo**

Loads returning production shares – one row per team-season with the
share of prior-season production returning, overall and by unit.
Published to the `cfb_returning_production` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_cfb_returning_production(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2005 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2005)

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

|                   |         |             |
|-------------------|---------|-------------|
| col_name          | types   | description |
| season            | integer |             |
| team_id           | integer |             |
| off_returning     | double  |             |
| def_returning     | double  |             |
| overall_returning | double  |             |
| n_returning       | integer |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_returning_production(2005))
#> ── college football returning production from the SportsDataverse data repo ────
#> ℹ Data updated: 2026-08-24 13:32:55 UTC
#> # A tibble: 161 × 6
#>    season team_id off_returning def_returning overall_returning n_returning
#>     <int> <chr>           <dbl>         <dbl>             <dbl>       <int>
#>  1   2005 2460            1                NA             1               5
#>  2   2005 113             1                NA             1               4
#>  3   2005 2464            1                NA             1               4
#>  4   2005 2026            1                NA             1               5
#>  5   2005 2466            1                NA             1               5
#>  6   2005 311             1                NA             1               6
#>  7   2005 2502            1                NA             1               3
#>  8   2005 2630            0.997            NA             0.997           6
#>  9   2005 221             0.992            NA             0.992          14
#> 10   2005 2546            0.986            NA             0.986           6
#> # ℹ 151 more rows
# }
```
