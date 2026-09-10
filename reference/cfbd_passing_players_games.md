# **Get player game passing production, split by pass location**

**Get player game passing production, split by pass location**

## Usage

``` r
cfbd_passing_players_games(
  year = NULL,
  week = NULL,
  season_type = NULL,
  team = NULL,
  conference = NULL,
  passer_id = NULL,
  classification = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2025

- week:

  (*Integer* optional): Week - values range from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier)

- season_type:

  (*String* optional): Season type - regular, postseason, both, allstar,
  spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference

- passer_id:

  (*String* optional): CFBD athlete id of the passer to filter on.

- classification:

  (*String* optional): Division classification - fbs, fcs, ii, ii/iii,
  iii

## Value

`cfbd_passing_players_games()` - A data frame with 193 variables:

|             |           |                                         |
|-------------|-----------|-----------------------------------------|
| col_name    | types     | description                             |
| game_id     | integer   | Unique game identifier - `game_id`.     |
| season      | integer   | Four-digit season year (e.g. 2025).     |
| week        | integer   | Week of the season.                     |
| season_type | character | Season type (regular, postseason, ...). |
| player_id   | character | CFBD athlete identifier.                |
| player      | character | Player full name.                       |
| team        | character | Team name.                              |
| conference  | character | Team conference name.                   |
| opponent    | character | Opposing team name.                     |

plus the 23-column passing production block and its seven `locations_*`
repeats – see
[cfbd_passing](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing.md).

## See also

Other CFBD Passing:
[`cfbd_passing_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_players_season.md),
[`cfbd_passing_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_plays.md),
[`cfbd_passing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_games.md),
[`cfbd_passing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_passing_players_games(year = 2025, week = 5))
#> ── Player game passing data from CollegeFootballData.com ───────────────────────
#> ℹ Data updated: 2026-09-10 05:40:54 UTC
#> # A tibble: 183 × 193
#>      game_id season  week season_type player_id player team  conference opponent
#>        <int>  <int> <int> <chr>       <chr>     <chr>  <chr> <chr>      <chr>   
#>  1 401752717   2025     5 regular     4431325   Tayle… Arka… SEC        Notre D…
#>  2 401752717   2025     5 regular     5079369   C.J. … Notr… Ind        Arkansas
#>  3 401752717   2025     5 regular     5150424   Jorda… Notr… Ind        Arkansas
#>  4 401752717   2025     5 regular     4918099   Kenny… Notr… Ind        Arkansas
#>  5 401752718   2025     5 regular     4685261   Germi… Alab… SEC        Georgia 
#>  6 401752718   2025     5 regular     4685522   Ty Si… Alab… SEC        Georgia 
#>  7 401752718   2025     5 regular     4685578   Gunne… Geor… SEC        Alabama 
#>  8 401752719   2025     5 regular     4567747   Garre… LSU   SEC        Ole Miss
#>  9 401752719   2025     5 regular     4911529   Trini… Ole … SEC        LSU     
#> 10 401752720   2025     5 regular     4565315   Blake… Miss… SEC        Tenness…
#> # ℹ 173 more rows
#> # ℹ 184 more variables: attempts <int>, completions <int>, incompletions <int>,
#> #   interceptions <int>, completion_rate <dbl>,
#> #   air_yards_attempts_available <int>, total_air_yards <int>,
#> #   average_depth_of_target <int>, total_yards_attempts_available <int>,
#> #   total_yards <int>, yards_after_catch_attempts_available <int>,
#> #   total_yards_after_catch <lgl>, average_yards_after_catch <lgl>, …
# }
```
