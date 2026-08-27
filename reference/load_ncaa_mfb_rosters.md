# **Load NCAA men's football rosters (stats.ncaa.org) from the SportsDataverse data repo**

Loads season-level NCAA men's football rosters from stats.ncaa.org; one
row per player-team-season. Published to the `ncaa_mfb_rosters` release
tag on the sportsdataverse-data repo.

## Usage

``` r
load_ncaa_mfb_rosters(
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
| team_id         | character |             |
| team_name       | character |             |
| player_id       | character |             |
| player_name     | character |             |
| jersey          | character |             |
| statcrew_jersey | character |             |
| player_class    | character |             |
| position        | character |             |
| height          | character |             |
| weight          | integer   |             |
| hometown        | character |             |
| high_school     | character |             |
| games_played    | integer   |             |
| games_started   | integer   |             |
| academic_year   | integer   |             |
| season          | integer   |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_ncaa_mfb_rosters(2013))
#> ── NCAA men's football rosters (stats.ncaa.org) from the SportsDataverse data re
#> ℹ Data updated: 2026-08-27 11:02:34 UTC
#> # A tibble: 25,041 × 16
#>    team_id team_name  player_id player_name  jersey statcrew_jersey player_class
#>    <chr>   <chr>      <chr>     <chr>        <chr>  <chr>           <chr>       
#>  1 62681   Akron Zips 4188918   Emmanuel La… 31     NA              Sr.         
#>  2 62681   Akron Zips 4188920   Jarrod Pugh… 76     NA              Sr.         
#>  3 62681   Akron Zips 4188921   Dee Frieson  83     NA              Sr.         
#>  4 62681   Akron Zips 4188925   Jerrod Dill… 88     NA              Sr.         
#>  5 62681   Akron Zips 4188926   Jon Root     86     NA              Sr.         
#>  6 62681   Akron Zips 4244986   Nick Rossi   44     NA              Jr.         
#>  7 62681   Akron Zips 4243814   Bill Alexan… 21     NA              Sr.         
#>  8 62681   Akron Zips 4243815   Broderick A… 2      NA              Sr.         
#>  9 62681   Akron Zips 4243816   Andrew Bohan 85     NA              So.         
#> 10 62681   Akron Zips 4243817   Dylan Brumb… 75     NA              So.         
#> # ℹ 25,031 more rows
#> # ℹ 9 more variables: position <chr>, height <chr>, weight <int>,
#> #   hometown <chr>, high_school <chr>, games_played <int>, games_started <int>,
#> #   academic_year <int>, season <int>
# }
```
