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
#> ℹ Data updated: 2026-10-01 10:21:46 UTC
#> # A tibble: 5,878 × 14
#>    pos_team_id pos_team          player_name field_goals field_goals_yards punts
#>          <int> <chr>             <chr>             <int>             <int> <int>
#>  1          30 USC Trojans       Reggie Bush           0                 0     0
#>  2          30 USC Trojans       Ryan Kille…           2                75     0
#>  3          30 USC Trojans       Tom Malone…           0                 0     4
#>  4          30 USC Trojans       Tom Malone…           0                 0     1
#>  5          30 USC Trojans       Trojans.              0                 0     0
#>  6         259 Virginia Tech Ho… Brandon Pa…           2                77     0
#>  7         259 Virginia Tech Ho… Eddie Royal           0                 0     0
#>  8         259 Virginia Tech Ho… Hokies.               0                 0     0
#>  9         259 Virginia Tech Ho… Josh Hyman            0                 0     0
#> 10         259 Virginia Tech Ho… Richard Jo…           0                 0     0
#> # ℹ 5,868 more rows
#> # ℹ 8 more variables: punts_yards <int>, kick_returns <int>,
#> #   kick_returns_yards <int>, punt_returns <int>, punt_returns_yards <int>,
#> #   game_id <int>, season <int>, week <int>
# }
```
