# **Load college football advanced receiving from the SportsDataverse data repo**

Loads season-level advanced receiving stats – one row per qualifying
receiver with target share, EPA per target, and YAC splits. Published to
the `espn_cfb_adv_receiving` release tag on the sportsdataverse-data
repo.

## Usage

``` r
load_espn_cfb_adv_receiving(
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
| receiver_player_name | character | Display name of the targeted receiver – the FIRST participant in that role on the play. |
| Rec | integer | Receptions credited to the receiver, the number of completions on plays where this player was the targeted receiver. |
| Tar | integer | Times the player was targeted on a pass attempt, the denominator behind YPT. |
| Yds | double | Passing yards from the advanced box score. |
| Rec_TD | integer | Receiving touchdowns, the count of the player's targeted plays that ended in a passing touchdown. |
| YPT | double | Receiving yards per target, the mean of receiving yardage over every target rather than over receptions only. |
| EPA | double |  |
| EPA_per_Play | double | EPA per play on the passer's plays. |
| WPA | double |  |
| SR | double | Success rate on the passer's plays. |
| Fum | integer | Count of the receiver's targeted pass plays whose text mentions a fumble; it is a play-level flag, not a fumble charged to this player. |
| Fum_Lost | integer | Count of the receiver's targeted plays on which a fumble was lost to the opponent. |
| game_id | integer |  |
| season | integer |  |
| week | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_adv_receiving(2004))
#> ── college football advanced receiving from the SportsDataverse data repo ──────
#> ℹ Data updated: 2026-08-27 20:31:17 UTC
#> # A tibble: 6,992 × 17
#>    pos_team_id pos_team      receiver_player_name   Rec   Tar   Yds Rec_TD   YPT
#>          <int> <chr>         <chr>                <int> <int> <dbl>  <int> <dbl>
#>  1         259 Virginia Tec… NA                       0    14     0      0  0   
#>  2          30 USC Trojans   NA                       0    10     0      0  0   
#>  3          30 USC Trojans   Reggie Bush              5     5    10      3  2   
#>  4         259 Virginia Tec… Richard Johnson          3     3    27      0  9   
#>  5         259 Virginia Tec… Jeff King                3     3    48      0 16   
#>  6          30 USC Trojans   David Kirtman            3     3    32      0 10.7 
#>  7          30 USC Trojans   Steve Smith              3     3    22      0  7.33
#>  8          30 USC Trojans   Alex Holmes              2     2    11      0  5.5 
#>  9          30 USC Trojans   Dwayne Jarrett           2     2    10      0  5   
#> 10          30 USC Trojans   Chris McFoy              2     2    11      0  5.5 
#> # ℹ 6,982 more rows
#> # ℹ 9 more variables: EPA <dbl>, EPA_per_Play <dbl>, WPA <dbl>, SR <dbl>,
#> #   Fum <int>, Fum_Lost <int>, game_id <int>, season <int>, week <int>
# }
```
