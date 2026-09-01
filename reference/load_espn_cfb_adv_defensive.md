# **Load college football advanced defensive from the SportsDataverse data repo**

Loads season-level advanced defensive team stats – one row per defense
with havoc, TFL, drive-stop, and pass-rush aggregates. Published to the
`espn_cfb_adv_defensive` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_adv_defensive(
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
| def_pos_team_id | integer | ESPN team id of the team on defense. Present for every season 2004+. |
| def_pos_team | character |  |
| scrimmage_plays | integer | Number of plays from scrimmage (rushes plus passes), excluding special teams. |
| TFL | integer | Count of scrimmage plays the defense held to negative yardage (non-penalty, non-special-teams, ESPN statYardage below zero) plus every sack. |
| TFL_pass | integer | The TFL count restricted to plays classified as passes, so it covers sacks together with completions and laterals stopped behind the line. |
| TFL_rush | integer | The TFL count restricted to plays classified as rushes, that is rushing attempts the defense stopped for negative yardage. |
| havoc_total | integer |  |
| havoc_total_rate | double | Share of the defense's scrimmage plays producing a havoc event, a 0-to-1 fraction equal to havoc_total divided by scrimmage_plays. |
| fumbles | integer | Fumbles the defense forced, counted from plays whose narrative contains the phrase forced by, not the total number of fumbles on the play. |
| def_int | integer | Interceptions the defense recorded, counted from plays ESPN types as Interception Return or Interception Return Touchdown. |
| drive_stopped_rate | double | Percentage from 0 to 100 of the defense's scrimmage plays that occurred on drives ending in a punt, fumble, interception, or turnover on downs; the denominator is plays, not drives. |
| num_pass_plays | integer | Number of pass scrimmage plays the defense faced, the denominator behind havoc_total_pass_rate and sacks_rate. |
| havoc_total_pass | integer | Havoc events (tackle for loss, sack, interception, forced fumble, or pass breakup) recorded on the pass plays the defense faced. |
| havoc_total_pass_rate | double | havoc_total_pass divided by num_pass_plays, the defense's havoc rate against the pass as a 0-to-1 fraction. |
| sacks | integer |  |
| sacks_rate | double | Sacks divided by pass plays faced, the defense's per-pass-play sack rate as a 0-to-1 fraction. |
| pass_breakups | integer | Passes the defense broke up, counted from plays whose narrative contains the phrase broken up by. |
| havoc_total_rush | integer | Havoc events recorded on the rush plays the defense faced, in practice tackles for loss and forced fumbles. |
| havoc_total_rush_rate | double | Havoc events per rush play faced, the mean of the havoc flag over the defense's rush scrimmage plays. |
| game_id | integer |  |
| season | integer |  |
| week | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_adv_defensive(2004))
#> ── college football advanced defensive from the SportsDataverse data repo ──────
#> ℹ Data updated: 2026-09-01 11:28:39 UTC
#> # A tibble: 926 × 22
#>    def_pos_team_id def_pos_team          scrimmage_plays   TFL TFL_pass TFL_rush
#>              <int> <chr>                           <int> <int>    <int>    <int>
#>  1             259 Virginia Tech Hokies               57     6        3        3
#>  2              30 USC Trojans                        61     9        5        4
#>  3             245 Texas A&M Aggies                   76     5        0        5
#>  4             254 Utah Utes                          67     7        1        6
#>  5            2050 Ball State Cardinals               70     6        1        4
#>  6             103 Boston College Eagles              63     8        6        2
#>  7            2628 TCU Horned Frogs                   93     6        0        6
#>  8              77 Northwestern Wildcats              77     7        0        7
#>  9               9 Arizona State Sun De…              71     9        3        6
#> 10            2638 UTEP Miners                        80    10        3        7
#> # ℹ 916 more rows
#> # ℹ 16 more variables: havoc_total <int>, havoc_total_rate <dbl>,
#> #   fumbles <int>, def_int <int>, drive_stopped_rate <dbl>,
#> #   num_pass_plays <int>, havoc_total_pass <int>, havoc_total_pass_rate <dbl>,
#> #   sacks <int>, sacks_rate <dbl>, pass_breakups <int>, havoc_total_rush <int>,
#> #   havoc_total_rush_rate <dbl>, game_id <int>, season <int>, week <int>
# }
```
