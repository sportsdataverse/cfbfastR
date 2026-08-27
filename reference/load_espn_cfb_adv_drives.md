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
| drive_total_available_yards | double | Sum of each drive's starting distance to the opponent end zone taken across every scrimmage play, so a drive contributes its available yards once per play rather than once per drive. |
| drive_total_gained_yards | integer | Sum of ESPN's per-drive yardage repeated across every scrimmage play of that drive, so a drive contributes its yardage once per play. |
| avg_field_position | double | Mean distance to the opponent end zone at drive start averaged over the team's scrimmage plays, exactly drive_total_available_yards divided by that play count. |
| plays_per_drive | double | Mean of ESPN's per-drive offensivePlays taken over plays rather than over drives, which weights every drive by its own length. |
| yards_per_drive | double | Mean of ESPN's per-drive yardage taken over plays rather than over drives, exactly drive_total_gained_yards divided by the team's scrimmage-play count. |
| drives | integer | Number of distinct ESPN drive ids on which the team ran at least one scrimmage play. |
| drive_total_gained_yards_rate | double | Available-yards conversion as a percentage, 100 times drive_total_gained_yards over drive_total_available_yards with both sums play-weighted. |
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
#> ℹ Data updated: 2026-08-27 11:52:05 UTC
#> # A tibble: 926 × 12
#>    pos_team_id pos_team            drive_total_availabl…¹ drive_total_gained_y…²
#>          <int> <chr>                                <dbl>                  <int>
#>  1          30 USC Trojans                           4197                   2282
#>  2         259 Virginia Tech Hoki…                   4722                   2106
#>  3         245 Texas A&M Aggies                      4956                   2285
#>  4         254 Utah Utes                             5404                   3290
#>  5        2050 Ball State Cardina…                   4056                   1050
#>  6         103 Boston College Eag…                   5759                   2162
#>  7        2628 TCU Horned Frogs                      5261                   3272
#>  8          77 Northwestern Wildc…                   6368                   4875
#>  9        2638 UTEP Miners                           5329                   1477
#> 10           9 Arizona State Sun …                   5412                   3262
#> # ℹ 916 more rows
#> # ℹ abbreviated names: ¹​drive_total_available_yards, ²​drive_total_gained_yards
#> # ℹ 8 more variables: avg_field_position <dbl>, plays_per_drive <dbl>,
#> #   yards_per_drive <dbl>, drives <int>, drive_total_gained_yards_rate <dbl>,
#> #   game_id <int>, season <int>, week <int>
# }
```
