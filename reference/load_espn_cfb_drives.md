# **Load ESPN college football drives from the SportsDataverse data repo**

Loads season-level drive summaries – one row per drive with start/end
field position, result, plays, yards, and clock. Published to the
`espn_cfb_drives` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_drives(
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
| drive_id | character |  |
| team_id | integer |  |
| result | character |  |
| display_result | character |  |
| short_display_result | character |  |
| description | character |  |
| yards | integer |  |
| offensive_plays | integer |  |
| is_score | logical |  |
| start_period | integer |  |
| start_yard_line | integer |  |
| start_clock | character |  |
| start_text | character |  |
| end_period | integer |  |
| end_yard_line | integer |  |
| end_clock | character |  |
| time_elapsed | character |  |
| n_plays | integer | Number of entries in ESPN's raw plays array for the drive, which is generally at least offensive_plays because it also counts penalties and other non-offensive snaps. |
| game_id | integer |  |
| season | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_drives(2004))
#> ── ESPN college football drives from the SportsDataverse data repo ─────────────
#> ℹ Data updated: 2026-09-03 22:41:15 UTC
#> # A tibble: 16,414 × 20
#>    drive_id team_id result display_result short_display_result description yards
#>    <chr>      <int> <chr>  <chr>          <chr>                <chr>       <int>
#>  1 2424102…     259 PUNT   Punt           PUNT                 5 plays, 6…     6
#>  2 2424102…      30 PUNT   Punt           PUNT                 8 plays, 4…    42
#>  3 2424102…     259 INT    Interception   INT                  7 plays, 4…    46
#>  4 2424102…      30 PASSI… Passing TD     PASSING TD           5 plays, 4…    46
#>  5 2424102…     259 KICKO… Kickoff        KICKOFF              NA              0
#>  6 2424102…     259 MADE … Made FG        MADE FG              9 plays, 6…    62
#>  7 2424102…      30 KICKO… Kickoff        KICKOFF              NA              0
#>  8 2424102…      30 MISSE… Missed FG      MISSED FG            11 plays, …    59
#>  9 2424102…     259 PASSI… Passing TD     PASSING TD           10 plays, …    83
#> 10 2424102…      30 KICKO… Kickoff        KICKOFF              NA              0
#> # ℹ 16,404 more rows
#> # ℹ 13 more variables: offensive_plays <int>, is_score <lgl>,
#> #   start_period <int>, start_yard_line <int>, start_clock <chr>,
#> #   start_text <chr>, end_period <int>, end_yard_line <int>, end_clock <chr>,
#> #   time_elapsed <chr>, n_plays <int>, game_id <int>, season <int>
# }
```
