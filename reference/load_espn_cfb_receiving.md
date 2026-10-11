# **Load college football receiving EPA splits from the SportsDataverse data repo**

Loads season-level receiving EPA splits – one row per team with target,
catch, and yards-after-catch aggregates. Published to the
`espn_cfb_receiving` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_receiving(
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
| team_id | integer |  |
| pos_team | character |  |
| division | character |  |
| conference | character |  |
| season | integer |  |
| player_id | integer |  |
| receiver_player_name | character | Display name of the targeted receiver – the FIRST participant in that role on the play. |
| plays | integer | Attributed targets: pass plays naming the receiver as the target or the catcher. |
| games | integer |  |
| team_games | integer | Games the team played, used as the per-game denominator. |
| TEPA | double | Total EPA summed over every play. |
| EPAplay | double | EPA per target. Null, with any \_rank, \_pct and \_pos_pct, in seasons where more than 30% of incompletions name no receiver (2021-2024): those throws drop out of every receiver's targets, so per-target rates would read high. |
| yards | integer |  |
| success | double | Success rate over the receiver's targets. Null, with any \_rank, \_pct and \_pos_pct, in seasons where more than 30% of incompletions name no receiver (2021-2024): those throws drop out of every receiver's targets, so per-target rates would read high. |
| comp | integer | Completed passes. |
| targets | integer | Attributed targets: passes ESPN charts to this receiver. An incompletion that names no receiver counts for nobody, so this undercounts real targets: 22-24% of incompletions name no receiver in 2014-2020, 42-77% in 2021-2024 and under 10% from 2025. |
| passing_td | double |  |
| fumbles | double | Count of the receiver's targeted pass plays across the season whose play text mentions a fumble by either team. |
| playsgame | double | Plays per game. |
| EPAgame | double | EPA generated per game. |
| yardsplay | double | Yards per target. Null, with any \_rank, \_pct and \_pos_pct, in seasons where more than 30% of incompletions name no receiver (2021-2024): those throws drop out of every receiver's targets, so per-target rates would read high. |
| yardsgame | double | Yards per game. |
| catchpct | double | Catch rate on a 0-to-1 scale, receptions divided by targets for the season. Null, with any \_rank, \_pct and \_pos_pct, in seasons where more than 30% of incompletions name no receiver (2021-2024): those throws drop out of every receiver's targets, so per-target rates would read high. |
| TEPA_rank | double | National rank of the team's total EPA summed over every play, where 1 is best. |
| EPAgame_rank | double | National rank of the team's EPA generated per game, where 1 is best. |
| EPAplay_rank | double | National rank of the team's EPA generated per play, where 1 is best. |
| success_rank | double | National rank of the team's success rate across the team plays, where 1 is best. |
| catchpct_rank | double | Season rank of catchpct with the best catch rate first, computed only for receivers clearing the leaderboard minimum of 1.875 targets per team game and using averaged ranks for ties. |
| yards_rank | double | National rank of the team's total yards, where 1 is best. |
| yardsplay_rank | double | National rank of the team's yards per play, where 1 is best. |
| yardsgame_rank | double | National rank of the team's yards per game, where 1 is best. |
| fbs_class | character | Power/Group classification for the season: P4 or G6 from 2024 on, P5 or G5 through 2023, derived from conference membership. Null for teams outside FBS. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_receiving(2004))
#> ── college football receiving EPA splits from the SportsDataverse data repo ────
#> ℹ Data updated: 2026-10-11 01:11:12 UTC
#> # A tibble: 1,418 × 77
#>    team_id pos_team    division conference season player_id receiver_player_name
#>    <chr>   <chr>       <chr>    <chr>       <int>     <int> <chr>               
#>  1 197     Oklahoma S… fbs      Big 12       2004    135622 Julius Crosslin     
#>  2 356     Illinois    fbs      Big Ten      2004    133661 Zach Gray           
#>  3 2572    Southern M… fbs      Conferenc…   2004    116114 Patrick Corbett     
#>  4 2641    Texas Tech  fbs      Big 12       2004    135873 Jarrett Hicks       
#>  5 221     Pittsburgh  fbs      Big East     2004    134927 Steve Buches        
#>  6 252     BYU         fbs      Mountain …   2004     36262 Chris Hale          
#>  7 235     Memphis     fbs      Conferenc…   2004    133397 John Doucette       
#>  8 2393    Middle Ten… fbs      Sun Belt     2004    133319 Eugene Gross        
#>  9 264     Washington  fbs      Pac-10       2004    120846 Shelton Sampson     
#> 10 23      San Jose S… fbs      Western A…   2004    148346 Casey Miranda       
#> # ℹ 1,408 more rows
#> # ℹ 70 more variables: plays <int>, games <int>, team_games <int>, TEPA <dbl>,
#> #   EPAplay <dbl>, yards <int>, success <dbl>, comp <int>, targets <int>,
#> #   passing_td <dbl>, fumbles <dbl>, playsgame <dbl>, EPAgame <dbl>,
#> #   yardsplay <dbl>, yardsgame <dbl>, catchpct <dbl>, dispersion_games <int>,
#> #   EPAplay_sd <dbl>, EPAplay_p10 <dbl>, EPAplay_p90 <dbl>, boom_rate <dbl>,
#> #   bust_rate <dbl>, TEPA_rank <dbl>, EPAgame_rank <dbl>, EPAplay_rank <dbl>, …
# }
```
