# **Load college football advanced drives from the SportsDataverse data repo**

Loads season-level advanced drive aggregates – one row per team with
drive-level scoring, efficiency, and field-position splits. Published to
the `espn_cfb_adv_drives` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_adv_drives(
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
| pos_team_id | integer | ESPN team id of the team on offense. Present for every season 2004+. |
| pos_team | character |  |
| drive_total_available_yards | double | Sum over the team's drives of each drive's starting distance to the opponent end zone, one row per drive. A drive counts under ESPN's drive team (all its snaps when none are that team's), and a start of 0 counts as missing. |
| drive_total_gained_yards | integer | Sum of ESPN's per-drive yardage over the team's drives, one row per drive. |
| avg_field_position | double | Mean distance to the opponent end zone at drive start over the team's drives with a known start, one row per drive. |
| plays_per_drive | double | Mean of ESPN's per-drive offensivePlays over the team's drives, one row per drive. |
| yards_per_drive | double | Mean of ESPN's per-drive yardage over the team's drives, one row per drive. |
| drives | integer | Number of distinct ESPN drive ids credited to the team: drives ESPN labels with the team on which it ran at least one scrimmage play. |
| drive_total_gained_yards_rate | double | Available-yards conversion as a percentage from 0 to 100: each drive's yardage capped at its available yards, summed over the team's drives and divided by drive_total_available_yards. Null when no drive start is known. |
| game_id | integer |  |
| season | integer |  |
| week | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_adv_drives(2004))
#> ── college football advanced drives from the SportsDataverse data repo ─────────
#> ℹ Data updated: 2026-10-12 12:28:28 UTC
#> # A tibble: 926 × 12
#>    pos_team_id pos_team            drive_total_availabl…¹ drive_total_gained_y…²
#>          <int> <chr>                                <dbl>                  <int>
#>  1         259 Virginia Tech Hoki…                    904                    295
#>  2          30 USC Trojans                            759                    370
#>  3         254 Utah Utes                             1038                    538
#>  4         245 Texas A&M Aggies                      1112                    400
#>  5        2050 Ball State Cardina…                    896                    207
#>  6         103 Boston College Eag…                   1117                    305
#>  7        2628 TCU Horned Frogs                      1164                    514
#>  8          77 Northwestern Wildc…                    946                    655
#>  9           9 Arizona State Sun …                   1055                    484
#> 10        2638 UTEP Miners                           1363                    350
#> # ℹ 916 more rows
#> # ℹ abbreviated names: ¹​drive_total_available_yards, ²​drive_total_gained_yards
#> # ℹ 8 more variables: avg_field_position <dbl>, plays_per_drive <dbl>,
#> #   yards_per_drive <dbl>, drives <int>, drive_total_gained_yards_rate <dbl>,
#> #   game_id <int>, season <int>, week <int>
# }
```
