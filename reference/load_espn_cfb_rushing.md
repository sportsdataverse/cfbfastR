# **Load college football rushing EPA splits from the SportsDataverse data repo**

Loads season-level rushing EPA splits – one row per team (offense and
defense views) with rush EPA, success, line yards, and stuff-rate
aggregates. Published to the `espn_cfb_rushing` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_rushing(
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
| rusher_player_name | character | Display name of the ball carrier on a rush – the FIRST participant in that role on the play. |
| plays | integer |  |
| games | integer |  |
| team_games | integer | Games the team played, used as the per-game denominator. |
| TEPA | double | Total EPA summed over every play. |
| EPAplay | double | EPA generated per play. |
| yards | integer |  |
| success | double | Success rate across the team plays. |
| rushing_td | double |  |
| fumbles | double | Count of the ball carrier's rush attempts across the season whose play text mentions a fumble by either team. |
| playsgame | double | Plays per game. |
| EPAgame | double | EPA generated per game. |
| yardsplay | double | Yards per play. |
| yardsgame | double | Yards per game. |
| TEPA_rank | double | National rank of the team's total EPA summed over every play, where 1 is best. |
| EPAgame_rank | double | National rank of the team's EPA generated per game, where 1 is best. |
| EPAplay_rank | double | National rank of the team's EPA generated per play, where 1 is best. |
| success_rank | double | National rank of the team's success rate across the team plays, where 1 is best. |
| yards_rank | double | National rank of the team's total yards, where 1 is best. |
| yardsplay_rank | double | National rank of the team's yards per play, where 1 is best. |
| yardsgame_rank | double | National rank of the team's yards per game, where 1 is best. |
| fbs_class | character | Power/Group classification for the season: P4 or G6 from 2024 on, P5 or G5 through 2023, derived from conference membership. Null for teams outside FBS. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_rushing(2004))
#> ── college football rushing EPA splits from the SportsDataverse data repo ──────
#> ℹ Data updated: 2026-11-26 22:49:56 UTC
#> # A tibble: 1,122 × 78
#>    team_id pos_team      division conference season player_id rusher_player_name
#>    <chr>   <chr>         <chr>    <chr>       <int>     <int> <chr>             
#>  1 2294    Iowa          fbs      Big Ten      2004    123343 Kevin Sherlock    
#>  2 2309    Kent State    fbs      Mid-Ameri…   2004    129604 Darrell Dowery Jr.
#>  3 328     Utah State    fbs      Sun Belt     2004    149336 Matt Crivello     
#>  4 309     Louisiana     fbs      Sun Belt     2004    136559 Chester Johnson   
#>  5 57      Florida       fbs      SEC          2004    134516 Ciatrick Fason    
#>  6 228     Clemson       fbs      ACC          2004    102438 Yusef Kelly       
#>  7 23      San Jose Sta… fbs      Western A…   2004    147041 Dale Rogers       
#>  8 2306    Kansas State  fbs      Big 12       2004    136886 Donnie Anders     
#>  9 2       Auburn        fbs      SEC          2004    146370 Kody Bliss        
#> 10 130     Michigan      fbs      Big Ten      2004    102615 Tim Bracken       
#> # ℹ 1,112 more rows
#> # ℹ 71 more variables: plays <int>, games <int>, team_games <int>, TEPA <dbl>,
#> #   EPAplay <dbl>, yards <int>, success <dbl>, rushing_td <dbl>, fumbles <dbl>,
#> #   playsgame <dbl>, EPAgame <dbl>, yardsplay <dbl>, yardsgame <dbl>,
#> #   dispersion_games <int>, EPAplay_sd <dbl>, EPAplay_p10 <dbl>,
#> #   EPAplay_p90 <dbl>, boom_rate <dbl>, bust_rate <dbl>,
#> #   line_yards_share <dbl>, second_level_share <dbl>, open_field_share <dbl>, …
# }
```
