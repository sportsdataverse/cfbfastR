# **Get team season rushing production for and against, split by run direction**

**Get team season rushing production for and against, split by run
direction**

## Usage

``` r
cfbd_rushing_teams_season(
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

`cfbd_rushing_teams_season()` - A data frame with 175 variables:

|            |           |                                     |
|------------|-----------|-------------------------------------|
| col_name   | types     | description                         |
| season     | integer   | Four-digit season year (e.g. 2025). |
| team       | character | Team name.                          |
| conference | character | Team conference name.               |

plus TWO copies of the 26-column production block, each with its four
15-column `directions_*` repeats: `offense_*` (the team's own rushing)
and `defense_*` (rushing allowed). That is 3 + 2 x (26 + 4 x 15) = 175.
See
[cfbd_rushing](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing.md).
So `offense_ppa` is PPA per carry run and `defense_ppa` is PPA per carry
allowed – a *lower* `defense_ppa` is better.

## See also

Other CFBD Rushing:
[`cfbd_rushing_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_players_games.md),
[`cfbd_rushing_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_players_season.md),
[`cfbd_rushing_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_plays.md),
[`cfbd_rushing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_games.md)

## Examples

``` r
# \donttest{
  try(cfbd_rushing_teams_season(year = 2025, team = "Texas"))
#> ── Team season rushing data from CollegeFootballData.com ───────────────────────
#> ℹ Data updated: 2026-09-10 05:44:33 UTC
#> # A tibble: 1 × 175
#>   season team  conference offense_attempts offense_rushing_yards_available
#>    <int> <chr> <chr>                 <int>                           <int>
#> 1   2025 Texas SEC                     411                             407
#> # ℹ 170 more variables: offense_total_rushing_yards <int>,
#> #   offense_yards_per_carry <dbl>, offense_individual_attempts <int>,
#> #   offense_unattributed_attempts <int>, offense_sacks <int>,
#> #   offense_kneels <int>, offense_team_rushes <int>,
#> #   offense_multi_carrier_attempts <int>,
#> #   offense_direction_eligible_attempts <int>,
#> #   offense_direction_available_attempts <int>, offense_success_rate <dbl>, …
# }
```
