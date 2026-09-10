# **Get player game rushing production, split by run direction**

**Get player game rushing production, split by run direction**

## Usage

``` r
cfbd_rushing_players_games(
  year = NULL,
  week = NULL,
  season_type = NULL,
  team = NULL,
  conference = NULL,
  rusher_id = NULL,
  classification = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*)  
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

- rusher_id:

  (*String* optional): CFBD athlete id of the rusher to filter on.

- classification:

  (*String* optional): Division classification - fbs, fcs, ii, ii/iii,
  iii

## Value

`cfbd_rushing_players_games()` - A data frame with 93 variables:

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

plus the 24-column rushing production block and its four `directions_*`
repeats – see
[cfbd_rushing](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing.md).

## See also

Other CFBD Rushing:
[`cfbd_rushing_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_players_season.md),
[`cfbd_rushing_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_plays.md),
[`cfbd_rushing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_games.md),
[`cfbd_rushing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_rushing_players_games(year = 2025, week = 5))
#> ── Player game rushing data from CollegeFootballData.com ───────────────────────
#> ℹ Data updated: 2026-09-10 05:44:28 UTC
#> # A tibble: 526 × 93
#>      game_id season  week season_type player_id player team  conference opponent
#>        <int>  <int> <int> <chr>       <chr>     <chr>  <chr> <chr>      <chr>   
#>  1 401752717   2025     5 regular     5079589   Brayl… Arka… SEC        Notre D…
#>  2 401752717   2025     5 regular     5079586   JacQa… Arka… SEC        Notre D…
#>  3 401752717   2025     5 regular     4686658   Micha… Arka… SEC        Notre D…
#>  4 401752717   2025     5 regular     4431325   Tayle… Arka… SEC        Notre D…
#>  5 401752717   2025     5 regular     5079742   Aneya… Notr… Ind        Arkansas
#>  6 401752717   2025     5 regular     5079369   C.J. … Notr… Ind        Arkansas
#>  7 401752717   2025     5 regular     4685509   Gi'Br… Notr… Ind        Arkansas
#>  8 401752717   2025     5 regular     4685512   Jadar… Notr… Ind        Arkansas
#>  9 401752717   2025     5 regular     4870808   Jerem… Notr… Ind        Arkansas
#> 10 401752717   2025     5 regular     4918099   Kenny… Notr… Ind        Arkansas
#> # ℹ 516 more rows
#> # ℹ 84 more variables: attempts <int>, rushing_yards_available <int>,
#> #   total_rushing_yards <int>, yards_per_carry <dbl>,
#> #   individual_attempts <int>, unattributed_attempts <int>, sacks <int>,
#> #   kneels <int>, team_rushes <int>, multi_carrier_attempts <int>,
#> #   direction_eligible_attempts <int>, direction_available_attempts <int>,
#> #   success_rate <dbl>, ppa <dbl>, total_ppa <dbl>, line_yards <dbl>, …
# }
```
