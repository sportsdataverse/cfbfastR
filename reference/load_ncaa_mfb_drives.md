# **Load NCAA men's football drives (stats.ncaa.org) from the SportsDataverse data repo**

Loads season-level NCAA men's football drive summaries parsed from
stats.ncaa.org; one row per drive. Published to the `ncaa_mfb_drives`
release tag on the sportsdataverse-data repo.

## Usage

``` r
load_ncaa_mfb_drives(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2013 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2013)

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

|                 |           |             |
|-----------------|-----------|-------------|
| col_name        | types     | description |
| contest_id      | character |             |
| drive_number    | integer   |             |
| quarter         | integer   |             |
| period          | integer   |             |
| team            | character |             |
| start_period    | integer   |             |
| start_how       | character |             |
| start_clock     | character |             |
| start_yard_line | character |             |
| end_period      | integer   |             |
| end_how         | character |             |
| end_clock       | character |             |
| end_yard_line   | character |             |
| n_plays         | integer   |             |
| yards           | integer   |             |
| espn_game_id    | character |             |
| season          | integer   |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_ncaa_mfb_drives(2013))
#> ── NCAA men's football drives (stats.ncaa.org) from the SportsDataverse data rep
#> ℹ Data updated: 2026-08-24 12:13:42 UTC
#> # A tibble: 42,185 × 17
#>    contest_id drive_number quarter period team  start_period start_how
#>    <chr>             <int>   <int>  <int> <chr>        <int> <chr>    
#>  1 688871                1       1      1 UCF              1 KO       
#>  2 688871                2       1      1 Akron            1 KO       
#>  3 688871                3       1      1 UCF              1 PUNT     
#>  4 688871                4       1      1 Akron            1 KO       
#>  5 688871                5       2      2 UCF              2 PUNT     
#>  6 688871                6       2      2 Akron            2 PUNT     
#>  7 688871                7       2      2 UCF              2 FUMB     
#>  8 688871                8       2      2 Akron            2 PUNT     
#>  9 688871                9       2      2 UCF              2 PUNT     
#> 10 688871               10       2      2 Akron            2 KO       
#> # ℹ 42,175 more rows
#> # ℹ 10 more variables: start_clock <chr>, start_yard_line <chr>,
#> #   end_period <int>, end_how <chr>, end_clock <chr>, end_yard_line <chr>,
#> #   n_plays <int>, yards <int>, espn_game_id <chr>, season <int>
# }
```
