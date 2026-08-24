# **Load NCAA men's football schedules (stats.ncaa.org) from the SportsDataverse data repo**

Loads season-level NCAA men's football schedules from stats.ncaa.org;
one row per game. Published to the `ncaa_mfb_schedule` release tag on
the sportsdataverse-data repo.

## Usage

``` r
load_ncaa_mfb_schedule(
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

|                |           |             |
|----------------|-----------|-------------|
| col_name       | types     | description |
| team_id        | character |             |
| team_name      | character |             |
| date           | character |             |
| opponent_id    | character |             |
| opponent       | character |             |
| result         | character |             |
| outcome        | character |             |
| team_score     | integer   |             |
| opponent_score | integer   |             |
| contest_id     | character |             |
| attendance     | integer   |             |
| academic_year  | integer   |             |
| espn_game_id   | character |             |
| season         | integer   |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_ncaa_mfb_schedule(2013))
#> ── NCAA men's football schedules (stats.ncaa.org) from the SportsDataverse data 
#> ℹ Data updated: 2026-08-24 14:50:34 UTC
#> # A tibble: 3,349 × 13
#>    team_id team_name  date       opponent_id opponent  result outcome team_score
#>    <chr>   <chr>      <chr>      <chr>       <chr>     <chr>  <chr>        <int>
#>  1 62681   Akron Zips Date       NA          Opponent  Result NA              NA
#>  2 62681   Akron Zips 08/29/2013 62700       @ UCF     L 7 -… NA              NA
#>  3 62681   Akron Zips 09/07/2013 62857       James Ma… W 35 … NA              NA
#>  4 62681   Akron Zips 09/14/2013 62739       @ Michig… L 24 … NA              NA
#>  5 62681   Akron Zips 09/21/2013 62778       Louisiana L 30 … NA              NA
#>  6 62681   Akron Zips 09/28/2013 62694       @ Bowlin… L 14 … NA              NA
#>  7 62681   Akron Zips 10/05/2013 62758       Ohio      L 3 -… NA              NA
#>  8 62681   Akron Zips 10/12/2013 62754       @ NIU     L 20 … NA              NA
#>  9 62681   Akron Zips 10/19/2013 62736       @ Miami … W 24 … NA              NA
#> 10 62681   Akron Zips 10/26/2013 62690       Ball St.  L 24 … NA              NA
#> # ℹ 3,339 more rows
#> # ℹ 5 more variables: opponent_score <int>, contest_id <chr>, attendance <int>,
#> #   academic_year <int>, season <int>
# }
```
