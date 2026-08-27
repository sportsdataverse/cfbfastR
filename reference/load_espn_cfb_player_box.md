# **Load ESPN college football player box scores from the SportsDataverse data repo**

Loads season-level player box scores – one row per player-game- category
with the stat lines ESPN publishes per game. Published to the
`espn_cfb_player_box` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_player_box(
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
| stat_1 | character | First value of ESPN's raw athlete stats array, written only when the category's key list does not line up with the stats list; on those rows the named per-category columns are all null. |
| stat_2 | character | Second value of ESPN's raw athlete stats array, written only on rows where the category keys did not line up and the named columns could not be filled. |
| stat_3 | character | Third value of ESPN's raw athlete stats array, written only on rows where the category keys did not line up and the named columns could not be filled. |
| stat_4 | character | Fourth value of ESPN's raw athlete stats array, written only on rows where the category keys did not line up and the named columns could not be filled. |
| stat_5 | character | Fifth value of ESPN's raw athlete stats array, written only on rows where the category keys did not line up and the named columns could not be filled. |
| category | character |  |
| athlete_id | integer |  |
| athlete_name | character |  |
| jersey | character |  |
| team_id | integer |  |
| rushingAttempts | character | Rushing attempts. |
| rushingYards | character | Net rushing yards gained. |
| yardsPerRushAttempt | character | Yards gained per rushing attempt. |
| rushingTouchdowns | character | Rushing touchdowns. |
| longRushing | character | Longest rush of the game, in yards. |
| receptions | character |  |
| receivingYards | character | Receiving yards gained. |
| yardsPerReception | character | Yards gained per reception. |
| receivingTouchdowns | character | Receiving touchdowns. |
| longReception | character | Longest reception of the game, in yards. |
| fumbles | character |  |
| fumblesLost | character |  |
| fumblesRecovered | character |  |
| kickReturns | character |  |
| kickReturnYards | character |  |
| yardsPerKickReturn | character |  |
| longKickReturn | character |  |
| kickReturnTouchdowns | character |  |
| puntReturns | character | Punt returns attempted. |
| puntReturnYards | character | Yards gained on punt returns. |
| yardsPerPuntReturn | character | Yards gained per punt return. |
| longPuntReturn | character | Longest punt return of the game, in yards. |
| puntReturnTouchdowns | character | Touchdowns scored on punt returns. |
| fieldGoalsMade/fieldGoalAttempts | character | Field goals made and attempted, as ESPN's combined string. |
| fieldGoalPct | character | Field-goal percentage. |
| longFieldGoalMade | character | Longest field goal made, in yards. |
| extraPointsMade/extraPointAttempts | character | Extra points made and attempted, as ESPN's combined string. |
| totalKickingPoints | character | Total points scored by kicking. |
| punts | character | Punts attempted. |
| puntYards | character | Total punt yards. |
| grossAvgPuntYards | character | Gross average yards per punt, before return yardage. |
| touchbacks | character | Punts or kickoffs that resulted in a touchback. |
| puntsInside20 | character | Punts downed inside the opponent 20-yard line. |
| longPunt | character | Longest punt of the game, in yards. |
| game_id | integer |  |
| season | integer |  |
| interceptions | character |  |
| interceptionYards | character | Yards returned on interceptions. |
| interceptionTouchdowns | character | Touchdowns scored on interception returns. |
| totalTackles | character |  |
| soloTackles | character |  |
| sacks | character |  |
| tacklesForLoss | character |  |
| passesDefended | character |  |
| hurries | character |  |
| defensiveTouchdowns | character |  |
| completions/passingAttempts | character | Completions and pass attempts, as ESPN's combined string. |
| passingYards | character | Net passing yards gained. |
| yardsPerPassAttempt | character | Yards gained per pass attempt. |
| passingTouchdowns | character | Passing touchdowns. |
| adjQBR | character | Adjusted Total QBR for the quarterback. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_player_box(2004))
#> Warning: cannot open URL 'https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_player_box/player_box_2004.rds': HTTP status was '404 Not Found'
#> Warning: Failed to readRDS from
#> <https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_player_box/player_box_2004.rds>
#> ── ESPN college football player box scores from the SportsDataverse data repo ──
#> ℹ Data updated: 2026-08-27 16:44:50 UTC
#> # A tibble: 0 × 0
# }
```
