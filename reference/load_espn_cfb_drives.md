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
#> Warning: cannot open URL 'https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_drives/drives_2004.rds': HTTP status was '404 Not Found'
#> Warning: Failed to readRDS from
#> <https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_drives/drives_2004.rds>
#> ── ESPN college football drives from the SportsDataverse data repo ─────────────
#> ℹ Data updated: 2026-08-27 11:52:14 UTC
#> # A tibble: 0 × 0
# }
```
