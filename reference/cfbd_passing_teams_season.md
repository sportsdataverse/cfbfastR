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

`cfbd_passing_teams_season()` - A data frame with 381 variables:

|            |           |                                     |
|------------|-----------|-------------------------------------|
| col_name   | type      | description                         |
| season     | integer   | Four-digit season year (e.g. 2025). |
| team       | character | Team name.                          |
| conference | character | Team conference name.               |

plus TWO copies of the 28-column production block, each with its seven
23-column `locations_*` repeats: `offense_*` (the team's own passing)
and `defense_*` (passing allowed). That is 3 + 2 x (28 + 7 x 23) = 381.
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
#> ℹ Data updated: 2026-10-30 00:09:43 UTC
#> # A tibble: 1 × 381
#>   season team  conference offense_ppa offense_cpoe offense_attempts
#>    <int> <chr> <chr>            <dbl>        <dbl>            <int>
#> 1   2025 Texas SEC              0.319        -0.44              415
#> # ℹ 375 more variables: offense_total_ppa <dbl>, offense_total_yards <int>,
#> #   offense_completions <int>, offense_success_rate <dbl>,
#> #   offense_explosiveness <dbl>, offense_incompletions <int>,
#> #   offense_interceptions <int>, offense_total_air_yards <int>,
#> #   offense_completion_rate <dbl>, offense_cpoe_completions <int>,
#> #   offense_successful_attempts <int>, offense_expected_completions <dbl>,
#> #   offense_average_depth_of_target <dbl>, …
# }
```
