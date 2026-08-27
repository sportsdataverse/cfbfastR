# **Load college football advanced specialists from the SportsDataverse data repo**

Loads season-level specialist stats – one row per kicker/punter/returner
with kicking EPA, field-goal profile, and return aggregates. Published
to the `espn_cfb_adv_specialists` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_adv_specialists(
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
| player_name | character |  |
| field_goals | integer | Number of field-goal attempts. |
| field_goals_yards | integer | Sum of the field-goal attempt distances parsed out of the play text; it stays at zero when no distance could be parsed from the narrative. |
| punts | integer | Punts attempted. |
| punts_yards | integer | Total gross punt yardage parsed from the play text for this punter, working out to roughly 42 yards per punt league-wide. |
| kick_returns | integer |  |
| kick_returns_yards | integer | Total yards the team gained returning kickoffs. |
| punt_returns | integer |  |
| punt_returns_yards | integer | Total punt-return yardage credited to this returner, with fair catches, downed punts, and out-of-bounds punts scored as zero. |
| game_id | integer |  |
| season | integer |  |
| week | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_adv_specialists(2004))
#> ── college football advanced specialists from the SportsDataverse data repo ────
#> ℹ Data updated: 2026-08-27 20:31:20 UTC
#> # A tibble: 5,184 × 14
#>    pos_team_id pos_team             player_name   punts punts_yards kick_returns
#>          <int> <chr>                <chr>         <int>       <int>        <int>
#>  1          30 USC Trojans          Tom Malone  …     4           0            0
#>  2         259 Virginia Tech Hokies Vinnie Burns…     1           0            0
#>  3          30 USC Trojans          Tom Malone  y     1           0            0
#>  4         259 Virginia Tech Hokies Vinnie Burns      2           0            0
#>  5         259 Virginia Tech Hokies Vinnie Burns…     2           0            0
#>  6          30 USC Trojans          Reggie Bush       0           0            3
#>  7         259 Virginia Tech Hokies Eddie Royal       0           0            1
#>  8         259 Virginia Tech Hokies Josh Hyman        0           0            1
#>  9         259 Virginia Tech Hokies Hokies.           0           0            2
#> 10          30 USC Trojans          Trojans.          0           0            0
#> # ℹ 5,174 more rows
#> # ℹ 8 more variables: kick_returns_yards <int>, punt_returns <int>,
#> #   punt_returns_yards <int>, game_id <int>, season <int>, week <int>,
#> #   field_goals <int>, field_goals_yards <int>
# }
```
