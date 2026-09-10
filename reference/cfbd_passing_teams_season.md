# **Get team season passing production for and against, split by pass location**

**Get team season passing production for and against, split by pass
location**

## Usage

``` r
cfbd_passing_teams_season(
  year = NULL,
  season_type = NULL,
  team = NULL,
  conference = NULL,
  classification = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2025

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

`cfbd_passing_teams_season()` - A data frame with 371 variables:

|            |           |                                     |
|------------|-----------|-------------------------------------|
| col_name   | types     | description                         |
| season     | integer   | Four-digit season year (e.g. 2025). |
| team       | character | Team name.                          |
| conference | character | Team conference name.               |

plus TWO copies of the 23-column production block, each with its seven
23-column `locations_*` repeats: `offense_*` (the team's own passing)
and `defense_*` (passing allowed). That is 3 + 2 x (23 + 7 x 23) = 371.
See
[cfbd_passing](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing.md).
So `offense_ppa` is PPA per attempt thrown and `defense_ppa` is PPA per
attempt allowed – a *lower* `defense_ppa` is better.

## See also

Other CFBD Passing:
[`cfbd_passing_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_players_games.md),
[`cfbd_passing_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_players_season.md),
[`cfbd_passing_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_plays.md),
[`cfbd_passing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_games.md)

## Examples

``` r
# \donttest{
  try(cfbd_passing_teams_season(year = 2025, team = "Texas"))
#> ── Team season passing data from CollegeFootballData.com ───────────────────────
#> ℹ Data updated: 2026-09-10 05:40:59 UTC
#> # A tibble: 1 × 371
#>   season team  conference offense_attempts offense_completions
#>    <int> <chr> <chr>                 <int>               <int>
#> 1   2025 Texas SEC                     415                 254
#> # ℹ 366 more variables: offense_incompletions <int>,
#> #   offense_interceptions <int>, offense_completion_rate <dbl>,
#> #   offense_air_yards_attempts_available <int>, offense_total_air_yards <int>,
#> #   offense_average_depth_of_target <dbl>,
#> #   offense_total_yards_attempts_available <int>, offense_total_yards <int>,
#> #   offense_yards_after_catch_attempts_available <int>,
#> #   offense_total_yards_after_catch <int>, …
# }
```
