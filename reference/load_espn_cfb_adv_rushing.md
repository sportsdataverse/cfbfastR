# **Load college football advanced rushing from the SportsDataverse data repo**

Loads season-level advanced rushing stats – one row per qualifying
rusher with EPA per rush, success rate, and yardage-band splits.
Published to the `espn_cfb_adv_rushing` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_adv_rushing(
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
| rusher_player_name | character | Display name of the ball carrier on a rush – the FIRST participant in that role on the play. |
| Car | integer | Rushing attempts credited to this ball carrier in the game. |
| Yds | double | Passing yards from the advanced box score. |
| Rush_TD | integer | Rushing touchdowns scored by this ball carrier in the game. |
| YPC | double | Yards per carry, the mean rushing yardage across the player's attempts in the game. |
| EPA | double |  |
| EPA_per_Play | double | EPA per play on the passer's plays. |
| WPA | double |  |
| SR | double | Success rate on the passer's plays. |
| Fum | integer | Count of the carrier's rush attempts whose play text mentions a fumble; it is a play-level flag, not a fumble charged to this player. |
| Fum_Lost | integer | Count of the carrier's rush attempts on which a fumble was lost to the opponent. |
| game_id | integer |  |
| season | integer |  |
| week | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_adv_rushing(2004))
#> ── college football advanced rushing from the SportsDataverse data repo ────────
#> ℹ Data updated: 2026-10-01 10:21:44 UTC
#> # A tibble: 4,758 × 16
#>    pos_team_id pos_team       rusher_player_name   Car   Yds Rush_TD   YPC   EPA
#>          <int> <chr>          <chr>              <int> <dbl>   <int> <dbl> <dbl>
#>  1          30 USC Trojans    LenDale White         15    73       0  4.87  0.37
#>  2         259 Virginia Tech… Bryan Randall         12   110       0  9.17  9.32
#>  3          30 USC Trojans    Reggie Bush            9    27       0  3    -2.36
#>  4         259 Virginia Tech… Cedric Humes           9    23       0  2.56 -3.15
#>  5         259 Virginia Tech… Justin Hamilton        8    32       0  4    -1.56
#>  6          30 USC Trojans    Matt Leinart           2     9       0  4.5   1.72
#>  7          30 USC Trojans    Steve Smith            1    -1       0 -1    -0.61
#>  8         254 Utah Utes      Marty Johnson         20    76       0  3.8  -4.97
#>  9         245 Texas A&M Agg… Reggie McNeal         13    96       2  7.38  6.48
#> 10         254 Utah Utes      Alex Smith            13    92       2  7.08 -0.99
#> # ℹ 4,748 more rows
#> # ℹ 8 more variables: EPA_per_Play <dbl>, WPA <dbl>, SR <dbl>, Fum <int>,
#> #   Fum_Lost <int>, game_id <int>, season <int>, week <int>
# }
```
