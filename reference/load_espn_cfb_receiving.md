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
| plays | integer |  |
| games | integer |  |
| team_games | integer | Games the team played, used as the per-game denominator. |
| TEPA | double | Total EPA summed over every play. |
| EPAplay | double | EPA generated per play. |
| yards | integer |  |
| success | double | Success rate across the team plays. |
| comp | integer | Completed passes. |
| targets | integer |  |
| passing_td | double |  |
| fumbles | double | Count of the receiver's targeted pass plays across the season whose play text mentions a fumble by either team. |
| playsgame | double | Plays per game. |
| EPAgame | double | EPA generated per game. |
| yardsplay | double | Yards per play. |
| yardsgame | double | Yards per game. |
| catchpct | double | Catch rate on a 0-to-1 scale, receptions divided by targets for the season. |
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
#> ℹ Data updated: 2026-09-27 07:47:57 UTC
#> # A tibble: 1,390 × 55
#>    team_id pos_team    division conference season player_id receiver_player_name
#>    <chr>   <chr>       <chr>    <chr>       <int>     <int> <chr>               
#>  1 62      Hawai'i     fbs      Western A…   2004    107773 Michael Brewster    
#>  2 2116    UCF         fbs      Mid-Ameri…   2004    100339 Luther Huggins      
#>  3 23      San Jose S… fbs      Western A…   2004    147034 Tyson Thompson      
#>  4 58      South Flor… fbs      Conferenc…   2004    148398 Pat Julmiste        
#>  5 248     Houston     fbs      Conferenc…   2004    120418 Matt Schirmer       
#>  6 2509    Purdue      fbs      Big Ten      2004    133852 Andre Chattams      
#>  7 193     Miami (OH)  fbs      Mid-Ameri…   2004    116400 Martin Nance        
#>  8 2390    Miami       fbs      ACC          2004    120157 Kevin Everett       
#>  9 30      USC         fbs      Pac-10       2004    120528 John Walker         
#> 10 213     Penn State  fbs      Big Ten      2004    156820 Terrell Golden      
#> # ℹ 1,380 more rows
#> # ℹ 48 more variables: plays <int>, games <int>, team_games <int>, TEPA <dbl>,
#> #   EPAplay <dbl>, yards <int>, success <dbl>, comp <int>, targets <int>,
#> #   passing_td <dbl>, fumbles <dbl>, playsgame <dbl>, EPAgame <dbl>,
#> #   yardsplay <dbl>, yardsgame <dbl>, catchpct <dbl>, TEPA_rank <dbl>,
#> #   EPAgame_rank <dbl>, EPAplay_rank <dbl>, success_rank <dbl>,
#> #   comp_rank <dbl>, targets_rank <dbl>, catchpct_rank <dbl>, …
# }
```
