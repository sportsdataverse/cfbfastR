# **Get team game rushing production for and against, split by run direction**

**Get team game rushing production for and against, split by run
direction**

## Usage

``` r
cfbd_rushing_teams_games(
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

`cfbd_rushing_teams_games()` - A data frame with 179 variables:

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

plus the `offense_*` and `defense_*` production blocks with their four
15-column `directions_*` repeats – 7 + 2 x (26 + 4 x 15) = 179. See
[cfbd_rushing](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing.md)
and
[cfbd_rushing_teams_season](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_season.md).

## See also

Other CFBD Rushing:
[`cfbd_rushing_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_players_games.md),
[`cfbd_rushing_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_players_season.md),
[`cfbd_rushing_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_plays.md),
[`cfbd_rushing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_rushing_teams_games(year = 2025, week = 5))
#> ── Team game rushing data from CollegeFootballData.com ── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-10 05:44:32 UTC
#> # A tibble: 104 × 179
#>      game_id season  week season_type team  conference opponent offense_attempts
#>        <int>  <int> <int> <chr>       <chr> <chr>      <chr>               <int>
#>  1 401752717   2025     5 regular     Arka… SEC        Notre D…               30
#>  2 401752717   2025     5 regular     Notr… Ind        Arkansas               40
#>  3 401752718   2025     5 regular     Alab… SEC        Georgia                38
#>  4 401752718   2025     5 regular     Geor… SEC        Alabama                33
#>  5 401752719   2025     5 regular     LSU   SEC        Ole Miss               22
#>  6 401752719   2025     5 regular     Ole … SEC        LSU                    45
#>  7 401752720   2025     5 regular     Miss… SEC        Tenness…               54
#>  8 401752720   2025     5 regular     Tenn… SEC        Mississ…               31
#>  9 401752721   2025     5 regular     Mass… MAC        Missouri               15
#> 10 401752721   2025     5 regular     Miss… SEC        Massach…               51
#> # ℹ 94 more rows
#> # ℹ 171 more variables: offense_rushing_yards_available <int>,
#> #   offense_total_rushing_yards <int>, offense_yards_per_carry <dbl>,
#> #   offense_individual_attempts <int>, offense_unattributed_attempts <int>,
#> #   offense_sacks <int>, offense_kneels <int>, offense_team_rushes <int>,
#> #   offense_multi_carrier_attempts <int>,
#> #   offense_direction_eligible_attempts <int>, …
# }
```
