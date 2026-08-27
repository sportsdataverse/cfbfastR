# **Load college football advanced defensive players from the SportsDataverse data repo**

Loads season-level advanced defensive player stats – one row per player
with tackles, TFL, sacks, pressures, and coverage counting stats.
Published to the `espn_cfb_adv_defensive_players` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_adv_defensive_players(
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
| def_pos_team | character | Display name of the team on defense (e.g. 'Ohio State Buckeyes'). Held an ESPN team id until the 2026-08 republish; the id now lives in def_pos_team_id. |
| player_name | character | Display name of the defender. |
| sacks | integer | Sacks recorded by the defender. Available from 2005 on; null for 2004. |
| sacks_yards | integer | Yards lost by the offense on the defender's sacks. Available from 2005 on; null for 2004. |
| fumble_recoveries | integer | Fumbles recovered by the defender. Available for every season 2004+. |
| fumble_recoveries_yards | integer | Yards returned on the defender's fumble recoveries. Available for every season 2004+. |
| game_id | integer |  |
| season | integer |  |
| week | integer |  |
| pass_breakups | integer | Passes broken up by the defender. Available from 2005 on; null for 2004. |
| interceptions | integer | Passes intercepted by the defender. Available from 2014 on; null for 2004-2013, which ESPN ships without interception statistics in this block. |
| interceptions_yards | integer | Yards returned on the defender's interceptions. Available from 2014 on; null for 2004-2013. |
| forced_fumbles | integer | Fumbles forced by the defender. Available from 2005 on; null for 2004, which ESPN ships with only the fumble-recovery statistics. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_adv_defensive_players(2004))
#> ── college football advanced defensive players from the SportsDataverse data rep
#> ℹ Data updated: 2026-08-27 15:30:50 UTC
#> # A tibble: 926 × 8
#>    def_pos_team_id def_pos_team             player_name        fumble_recoveries
#>              <int> <chr>                    <chr>                          <int>
#>  1              30 USC Trojans              Ronald Nunn                        1
#>  2              30 USC Trojans              Alex Holmes (USC)…                 1
#>  3              77 Northwestern Wildcats    Dominique Price                    1
#>  4            2628 TCU Horned Frogs         Robert Merrill (T…                 1
#>  5               9 Arizona State Sun Devils Josh Barrett                       1
#>  6             265 Washington State Cougars Husain Abdullah                    1
#>  7             201 Oklahoma Sooners         Adrian Peterson (…                 1
#>  8             189 Bowling Green Falcons    Cole Magner (BGSU…                 1
#>  9             189 Bowling Green Falcons    Omar Jacobs (BGSU…                 1
#> 10             201 Oklahoma Sooners         Rufus Alexander                    1
#> # ℹ 916 more rows
#> # ℹ 4 more variables: fumble_recoveries_yards <int>, game_id <int>,
#> #   season <int>, week <int>
# }
```
