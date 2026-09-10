# **Get team game passing production for and against, split by pass location**

**Get team game passing production for and against, split by pass
location**

## Usage

``` r
cfbd_passing_teams_games(
  year = NULL,
  week = NULL,
  season_type = NULL,
  team = NULL,
  conference = NULL,
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

- classification:

  (*String* optional): Division classification - fbs, fcs, ii, ii/iii,
  iii

## Value

`cfbd_passing_teams_games()` - A data frame with 375 variables:

|             |           |                                         |
|-------------|-----------|-----------------------------------------|
| col_name    | types     | description                             |
| game_id     | integer   | Unique game identifier - `game_id`.     |
| season      | integer   | Four-digit season year (e.g. 2025).     |
| week        | integer   | Week of the season.                     |
| season_type | character | Season type (regular, postseason, ...). |
| team        | character | Team name.                              |
| conference  | character | Team conference name.                   |
| opponent    | character | Opposing team name.                     |

plus the `offense_*` and `defense_*` production and `locations_*` blocks
– see
[cfbd_passing](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing.md)
and
[cfbd_passing_teams_season](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_season.md).

## See also

Other CFBD Passing:
[`cfbd_passing_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_players_games.md),
[`cfbd_passing_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_players_season.md),
[`cfbd_passing_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_plays.md),
[`cfbd_passing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_passing_teams_games(year = 2025, week = 5))
#> ── Team game passing data from CollegeFootballData.com ── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-10 05:40:58 UTC
#> # A tibble: 104 × 375
#>      game_id season  week season_type team  conference opponent offense_attempts
#>        <int>  <int> <int> <chr>       <chr> <chr>      <chr>               <int>
#>  1 401752717   2025     5 regular     Arka… SEC        Notre D…               32
#>  2 401752717   2025     5 regular     Notr… Ind        Arkansas               32
#>  3 401752718   2025     5 regular     Alab… SEC        Georgia                39
#>  4 401752718   2025     5 regular     Geor… SEC        Alabama                20
#>  5 401752719   2025     5 regular     LSU   SEC        Ole Miss               34
#>  6 401752719   2025     5 regular     Ole … SEC        LSU                    39
#>  7 401752720   2025     5 regular     Miss… SEC        Tenness…               29
#>  8 401752720   2025     5 regular     Tenn… SEC        Mississ…               37
#>  9 401752721   2025     5 regular     Mass… MAC        Missouri               36
#> 10 401752721   2025     5 regular     Miss… SEC        Massach…               32
#> # ℹ 94 more rows
#> # ℹ 367 more variables: offense_completions <int>, offense_incompletions <int>,
#> #   offense_interceptions <int>, offense_completion_rate <dbl>,
#> #   offense_air_yards_attempts_available <int>, offense_total_air_yards <int>,
#> #   offense_average_depth_of_target <int>,
#> #   offense_total_yards_attempts_available <int>, offense_total_yards <int>,
#> #   offense_yards_after_catch_attempts_available <int>, …
# }
```
