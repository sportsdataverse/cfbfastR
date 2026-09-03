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
#> ℹ Data updated: 2026-09-03 22:41:04 UTC
#> # A tibble: 1,590 × 10
#>    def_pos_team_id def_pos_team    player_name interceptions interceptions_yards
#>              <int> <chr>           <chr>               <int>               <int>
#>  1              30 USC Trojans     Ronald Nunn             0                   0
#>  2              30 USC Trojans     Lofa Tatupu             1                  32
#>  3            2050 Ball State Car… Donta Smith             0                   0
#>  4            2050 Ball State Car… David Gater             1                  29
#>  5              77 Northwestern W… Dominique …             1                   0
#>  6            2628 TCU Horned Fro… Marvin God…             1                  32
#>  7               9 Arizona State … Emmanuel F…             2                  75
#>  8               9 Arizona State … Mike Davis…             1                   8
#>  9            2638 UTEP Miners     James Delg…             1                   0
#> 10               9 Arizona State … Quency Dar…             1                   5
#> # ℹ 1,580 more rows
#> # ℹ 5 more variables: fumble_recoveries <int>, fumble_recoveries_yards <int>,
#> #   game_id <int>, season <int>, week <int>
# }
```
