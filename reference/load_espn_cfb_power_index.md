# **Load ESPN college football FPI power index from the SportsDataverse data repo**

Loads season-level ESPN FPI power-index snapshots – one row per team
with FPI rating, projected wins, and efficiency components. Published to
the `espn_cfb_power_index` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_power_index(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2015 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2015)

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
| season | integer |  |
| game_id | integer |  |
| team_id | integer |  |
| teampredptdiff | double | Expected margin of victory for the FPI favorite. |
| gameprojection | double | Team's predicted win percentage in this game at time of given BPI run. |
| matchupquality | double | A measure of projected competitiveness and excitement in the game, using a 0 to 100 scale, with 100 as the most exciting. |
| teamadjgamescore | double | A measure of how well a team performed compared to their expected performance and the expected performance of a typical top 25 team. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_power_index(2015))
#> ── ESPN college football FPI power index from the SportsDataverse data repo ────
#> ℹ Data updated: 2026-08-27 16:44:52 UTC
#> # A tibble: 1,746 × 7
#>    season   game_id team_id teampredptdiff gameprojection matchupquality
#>     <int>     <int>   <int>          <dbl>          <dbl>          <dbl>
#>  1   2015 400603827     275          -11.8           20             88.4
#>  2   2015 400603827     333           11.8           80             88.4
#>  3   2015 400603828       8           37.6           98.8           47.3
#>  4   2015 400603828    2638          -37.6            1.2           47.3
#>  5   2015 400603829       2           10.0           76.4           72.2
#>  6   2015 400603829      97          -10.0           23.6           72.2
#>  7   2015 400603830      57           31.1           97.5           43.3
#>  8   2015 400603830     166          -31.1            2.5           43.3
#>  9   2015 400603831      61           38.5           98.9           46.1
#> 10   2015 400603831    2433          -38.5            1.1           46.1
#> # ℹ 1,736 more rows
#> # ℹ 1 more variable: teamadjgamescore <dbl>
# }
```
