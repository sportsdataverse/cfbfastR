# **Get team game punting production, kicking and receiving**

**Get team game punting production, kicking and receiving**

## Usage

``` r
cfbd_punting_teams_games(
  year = NULL,
  week = NULL,
  season_type = NULL,
  team = NULL,
  conference = NULL,
  classification = NULL,
  proxy = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2015

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

  (*String* optional): Division classification - fbs, fcs, ii,
  ii/iii, iii. CFBD defaults to fbs.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_punting_teams_games()` - A data frame with 55 variables:

|             |           |                                         |
|-------------|-----------|-----------------------------------------|
| col_name    | type      | description                             |
| game_id     | integer   | Unique game identifier - `game_id`.     |
| season      | integer   | Four-digit season year (e.g. 2025).     |
| week        | integer   | Week of the season.                     |
| season_type | character | Season type (regular, postseason, ...). |
| team        | character | Team name.                              |
| conference  | character | Team conference name.                   |
| opponent    | character | Opposing team name.                     |

plus TWO copies of the 24-column team punting block, `punting_*` and
`returning_*`: 7 + 2 x 24 = 55. See
[cfbd_punting](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting.md).

## See also

Other CFBD Punting:
[`cfbd_punting_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_players_games.md),
[`cfbd_punting_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_players_season.md),
[`cfbd_punting_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_plays.md),
[`cfbd_punting_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_punting_teams_games(year = 2025, week = 5))
#> ── Team game punting data from CollegeFootballData.com ─────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-03 23:26:20 UTC
#> # A tibble: 104 × 55
#>      game_id season  week season_type team     conference opponent punting_punts
#>        <int>  <int> <int> <chr>       <chr>    <chr>      <chr>            <int>
#>  1 401762471   2025     5 regular     Army     AAC        East Ca…             3
#>  2 401762471   2025     5 regular     East Ca… AAC        Army                 2
#>  3 401754543   2025     5 regular     Florida… ACC        Virginia             1
#>  4 401754543   2025     5 regular     Virginia ACC        Florida…             3
#>  5 401756902   2025     5 regular     Arizona… B12        TCU                  2
#>  6 401756902   2025     5 regular     TCU      B12        Arizona…             5
#>  7 401752939   2025     5 regular     Houston  B12        Oregon …             8
#>  8 401752939   2025     5 regular     Oregon … PAC        Houston              6
#>  9 401752717   2025     5 regular     Arkansas SEC        Notre D…             2
#> 10 401752717   2025     5 regular     Notre D… Ind        Arkansas             0
#> # ℹ 94 more rows
#> # ℹ 47 more variables: punting_punt_yards_available <int>,
#> #   punting_punt_yards <int>, punting_yards_per_punt <dbl>,
#> #   punting_longest_punt <int>, punting_punts50plus <int>,
#> #   punting_net_punt_yards_available <int>, punting_net_punt_yards <int>,
#> #   punting_net_yards_per_punt <dbl>, punting_touchbacks <int>,
#> #   punting_fair_catches <int>, punting_out_of_bounds <int>, …
# }
```
