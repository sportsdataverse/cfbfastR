# **Load college football team talent composite from the SportsDataverse data repo**

Loads the 247Sports team talent composite – one row per team-season.
Published to the `cfb_team_talent` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_cfb_team_talent(
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

|                  |           |             |
|------------------|-----------|-------------|
| col_name         | types     | description |
| season           | integer   |             |
| team_id          | integer   |             |
| team             | character |             |
| talent_composite | double    |             |
| talent_rank      | integer   |             |
| blue_chip_ratio  | double    |             |
| n_recruits       | integer   |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_team_talent(2005))
#> ── college football team talent composite from the SportsDataverse data repo ───
#> ℹ Data updated: 2026-08-27 04:22:28 UTC
#> # A tibble: 120 × 7
#>    season team_id team   talent_composite talent_rank blue_chip_ratio n_recruits
#>     <int> <chr>   <chr>             <dbl>       <int>           <dbl>      <int>
#>  1   2005 52      Flori…            1344.           1           0.632         87
#>  2   2005 30      USC T…            1335.           2           0.598         82
#>  3   2005 2390    Miami…            1299.           3           0.593         86
#>  4   2005 2633    Tenne…            1275.           4           0.521         94
#>  5   2005 201     Oklah…            1261.           5           0.558         77
#>  6   2005 57      Flori…            1255.           6           0.489         88
#>  7   2005 61      Georg…            1247.           7           0.418         91
#>  8   2005 99      LSU T…            1236.           8           0.517         89
#>  9   2005 130     Michi…            1213.           9           0.525         80
#> 10   2005 194     Ohio …            1212.          10           0.544         79
#> # ℹ 110 more rows
# }
```
