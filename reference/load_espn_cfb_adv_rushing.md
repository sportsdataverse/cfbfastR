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
#> ℹ Data updated: 2026-10-30 00:16:44 UTC
#> # A tibble: 4,758 × 16
#>    pos_team_id pos_team       rusher_player_name   Car   Yds Rush_TD   YPC   EPA
#>          <int> <chr>          <chr>              <int> <dbl>   <int> <dbl> <dbl>
#>  1          30 USC Trojans    LenDale White         15    77       0  5.13  0.36
#>  2         259 Virginia Tech… Bryan Randall         12   110       0  9.17  9.55
#>  3          30 USC Trojans    Reggie Bush            9    28       0  3.11 -2.75
#>  4         259 Virginia Tech… Cedric Humes           9    26       0  2.89 -3.74
#>  5         259 Virginia Tech… Justin Hamilton        8    33       0  4.12 -1.37
#>  6          30 USC Trojans    Matt Leinart           2     9       0  4.5   1.79
#>  7          30 USC Trojans    Steve Smith            1    -1       0 -1    -0.59
#>  8         254 Utah Utes      Marty Johnson         20    77       0  3.85 -5.57
#>  9         245 Texas A&M Agg… Reggie McNeal         13    97       2  7.46  7.16
#> 10         254 Utah Utes      Alex Smith            13    94       2  7.23 -1.23
#> # ℹ 4,748 more rows
#> # ℹ 8 more variables: EPA_per_Play <dbl>, WPA <dbl>, SR <dbl>, Fum <int>,
#> #   Fum_Lost <int>, game_id <int>, season <int>, week <int>
# }
```
