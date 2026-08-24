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
#> ℹ Data updated: 2026-08-24 14:49:56 UTC
#> # A tibble: 4,690 × 16
#>    pos_team_id pos_team       rusher_player_name   Car   Yds Rush_TD   YPC   EPA
#>          <int> <chr>          <chr>              <int> <dbl>   <int> <dbl> <dbl>
#>  1          30 USC Trojans    LenDale White         14    62       0  4.43 -0.38
#>  2         259 Virginia Tech… Bryan Randall         10    83       0  8.3   6.93
#>  3         259 Virginia Tech… Cedric Humes           9    23       0  2.56 -3.15
#>  4          30 USC Trojans    Reggie Bush            9    32       0  3.56 -2.27
#>  5         259 Virginia Tech… Justin Hamilton        7    20       0  2.86 -2.46
#>  6          30 USC Trojans    Matt Leinart           2     9       0  4.5   1.72
#>  7          30 USC Trojans    Steve Smith            1     0       0  0    -0.61
#>  8         254 Utah Utes      Marty Johnson         20    80       0  4    -4.91
#>  9         245 Texas A&M Agg… Reggie McNeal         12   104       2  8.67  5.29
#> 10         254 Utah Utes      Alex Smith            12    88       2  7.33 -1.87
#> # ℹ 4,680 more rows
#> # ℹ 8 more variables: EPA_per_Play <dbl>, WPA <dbl>, SR <dbl>, Fum <int>,
#> #   Fum_Lost <int>, game_id <int>, season <int>, week <int>
# }
```
