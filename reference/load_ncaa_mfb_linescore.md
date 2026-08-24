# **Load NCAA men's football linescores (stats.ncaa.org) from the SportsDataverse data repo**

Loads season-level NCAA men's football period linescores parsed from
stats.ncaa.org; one row per team-period. Published to the
`ncaa_mfb_linescore` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_ncaa_mfb_linescore(
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

|              |           |             |
|--------------|-----------|-------------|
| col_name     | types     | description |
| contest_id   | character |             |
| team         | character |             |
| home_away    | character |             |
| period       | character |             |
| points       | integer   |             |
| final        | integer   |             |
| game_date    | character |             |
| venue        | character |             |
| attendance   | integer   |             |
| espn_game_id | character |             |
| season       | integer   |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_ncaa_mfb_linescore(2013))
#> ── NCAA men's football linescores (stats.ncaa.org) from the SportsDataverse data
#> ℹ Data updated: 2026-08-24 14:50:23 UTC
#> # A tibble: 12,496 × 11
#>    contest_id team      home_away period points final game_date venue attendance
#>    <chr>      <chr>     <chr>     <chr>   <int> <int> <chr>     <chr>      <int>
#>  1 688871     Akron     away      1           0     7 08/29/20… NA         35115
#>  2 688871     Akron     away      2           0     7 08/29/20… NA         35115
#>  3 688871     Akron     away      3           0     7 08/29/20… NA         35115
#>  4 688871     Akron     away      4           7     7 08/29/20… NA         35115
#>  5 688871     UCF       home      1          14    38 08/29/20… NA         35115
#>  6 688871     UCF       home      2          10    38 08/29/20… NA         35115
#>  7 688871     UCF       home      3          14    38 08/29/20… NA         35115
#>  8 688871     UCF       home      4           0    38 08/29/20… NA         35115
#>  9 688872     Sacramen… away      1           0     0 08/29/20… NA         13136
#> 10 688872     Sacramen… away      2           0     0 08/29/20… NA         13136
#> # ℹ 12,486 more rows
#> # ℹ 2 more variables: espn_game_id <chr>, season <int>
# }
```
