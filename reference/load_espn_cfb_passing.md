# **Load college football passing EPA splits from the SportsDataverse data repo**

Loads season-level passing EPA splits – one row per team (offense and
defense views) with dropback EPA, success, and explosiveness aggregates.
Published to the `espn_cfb_passing` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_passing(
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
| passer_player_name | character | Display name of the passer – the FIRST participant in that role on the play. |
| plays | integer |  |
| games | integer |  |
| team_games | integer | Games the team played, used as the per-game denominator. |
| TEPA | double | Total EPA summed over every play. |
| EPAplay | double | EPA generated per play. |
| yards | double |  |
| success | double | Success rate across the team plays. |
| comp | double | Completed passes. |
| att | double | Pass attempts thrown. |
| comppct | double | Completion percentage. |
| passing_td | double |  |
| playsgame | double | Plays per game. |
| EPAgame | double | EPA generated per game. |
| yardsplay | double | Yards per play. |
| yardsgame | double | Yards per game. |
| sacked | integer | Times the passer was sacked. |
| sack_yds | integer | Yards lost to sacks. |
| sack_epa | double | EPA lost on the sacks the team's passers took – the expected-points cost of those plays. |
| pass_int | integer | Interceptions thrown. |
| int_epa | double | EPA lost on the team's interceptions thrown – the expected-points cost of the turnovers, not a count. |
| detmer | double | Detmer rating – the composite passing-efficiency measure this pipeline publishes, named for the college passing-efficiency tradition. |
| detmergame | double | Detmer rating expressed per game. |
| dropbacks | double | Dropbacks taken by the passer. |
| sack_adj_yards | double | Passing yards adjusted for sack yardage lost. |
| yardsdropback | double | Yards per dropback. |
| TEPA_rank | double | National rank of the team's total EPA summed over every play, where 1 is best. |
| EPAgame_rank | double | National rank of the team's EPA generated per game, where 1 is best. |
| EPAplay_rank | double | National rank of the team's EPA generated per play, where 1 is best. |
| success_rank | double | National rank of the team's success rate across the team plays, where 1 is best. |
| comppct_rank | double | National rank of the team's completion percentage, where 1 is best. |
| yards_rank | double | National rank of the team's total yards, where 1 is best. |
| yardsplay_rank | double | National rank of the team's yards per play, where 1 is best. |
| yardsgame_rank | double | National rank of the team's yards per game, where 1 is best. |
| sack_adj_yards_rank | double | National rank of the team's passing yards adjusted for sack yardage lost, where 1 is best. |
| yardsdropback_rank | double | National rank of the team's yards per dropback, where 1 is best. |
| detmer_rank | double | National rank of the team's detmer rating – the composite passing-efficiency measure this pipeline publishes, named for the college passing-efficiency tradition, where 1 is best. |
| detmergame_rank | double | National rank of the team's detmer rating expressed per game, where 1 is best. |
| fbs_class | character | Power/Group classification for the season: P4 or G6 from 2024 on, P5 or G5 through 2023, derived from conference membership. Null for teams outside FBS. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_passing(2004))
#> ── college football passing EPA splits from the SportsDataverse data repo ──────
#> ℹ Data updated: 2026-08-27 16:44:42 UTC
#> # A tibble: 349 × 45
#>    team_id pos_team      division conference season player_id passer_player_name
#>    <chr>   <chr>         <chr>    <chr>       <int>     <int> <chr>             
#>  1 242     Rice          fbs      Western A…   2004    149925 Joel Armstrong    
#>  2 120     Maryland      fbs      ACC          2004    116034 Derrick Fenner    
#>  3 59      Georgia Tech  fbs      ACC          2004    145781 Reggie Ball       
#>  4 50      Florida A&M   fbs      FBS Indep…   2004    116652 Josh Driscoll     
#>  5 2653    Troy          fbs      Sun Belt     2004    129586 Jason Samples     
#>  6 252     BYU           fbs      Mountain …   2004    148066 John Beck         
#>  7 38      Colorado      fbs      Big 12       2004    145302 Jarrad Jackson    
#>  8 166     New Mexico S… fbs      Sun Belt     2004    112487 Paul Dombrowski   
#>  9 2572    Southern Miss fbs      Conferenc…   2004    147910 Damion Carter     
#> 10 2572    Southern Miss fbs      Conferenc…   2004    129234 Dustin Almond     
#> # ℹ 339 more rows
#> # ℹ 38 more variables: plays <int>, games <int>, team_games <int>, TEPA <dbl>,
#> #   EPAplay <dbl>, yards <dbl>, success <dbl>, comp <dbl>, att <dbl>,
#> #   comppct <dbl>, passing_td <dbl>, playsgame <dbl>, EPAgame <dbl>,
#> #   yardsplay <dbl>, yardsgame <dbl>, sacked <int>, sack_yds <int>,
#> #   sack_epa <dbl>, pass_int <int>, int_epa <dbl>, detmer <dbl>,
#> #   detmergame <dbl>, dropbacks <dbl>, sack_adj_yards <dbl>, …
# }
```
