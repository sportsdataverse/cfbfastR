# **Get player game punting and punt return production**

**Get player game punting and punt return production**

## Usage

``` r
cfbd_punting_players_games(
  year = NULL,
  week = NULL,
  season_type = NULL,
  team = NULL,
  conference = NULL,
  player_id = NULL,
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

- player_id:

  (*String* optional): CFBD athlete id of the player to filter on.

- classification:

  (*String* optional): Division classification - fbs, fcs, ii,
  ii/iii, iii. CFBD defaults to fbs.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_punting_players_games()` - A data frame with 34 variables:

|             |           |                                         |
|-------------|-----------|-----------------------------------------|
| col_name    | type      | description                             |
| game_id     | integer   | Unique game identifier - `game_id`.     |
| season      | integer   | Four-digit season year (e.g. 2025).     |
| week        | integer   | Week of the season.                     |
| season_type | character | Season type (regular, postseason, ...). |
| player_id   | character | CFBD athlete identifier.                |
| player      | character | Player full name.                       |
| team        | character | Team name.                              |
| conference  | character | Team conference name.                   |
| opponent    | character | Opposing team name.                     |

plus the 15-column `punting_*` block and the 10-column `returning_*`
block – see
[cfbd_punting](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting.md).

## See also

Other CFBD Punting:
[`cfbd_punting_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_players_season.md),
[`cfbd_punting_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_plays.md),
[`cfbd_punting_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_teams_games.md),
[`cfbd_punting_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_punting_players_games(year = 2025, week = 5))
#> ── Player game punting data from CollegeFootballData.com ───── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-03 10:08:05 UTC
#> # A tibble: 207 × 34
#>      game_id season  week season_type player_id player team  conference opponent
#>        <int>  <int> <int> <chr>       <chr>     <chr>  <chr> <chr>      <chr>   
#>  1 401762471   2025     5 regular     5150302   James… Army  AAC        East Ca…
#>  2 401762471   2025     5 regular     5150311   Tre B… Army  AAC        East Ca…
#>  3 401762471   2025     5 regular     4430798   Kyler… East… AAC        Army    
#>  4 401762471   2025     5 regular     4695272   Ryan … East… AAC        Army    
#>  5 401754543   2025     5 regular     5081075   Mac C… Flor… ACC        Virginia
#>  6 401754543   2025     5 regular     5081368   Squir… Flor… ACC        Virginia
#>  7 401754543   2025     5 regular     4569001   Camer… Virg… ACC        Florida…
#>  8 401754543   2025     5 regular     5092258   Elija… Virg… ACC        Florida…
#>  9 401756902   2025     5 regular     5093004   Keith… Ariz… B12        TCU     
#> 10 401756902   2025     5 regular     5296141   Matt … Ariz… B12        TCU     
#> # ℹ 197 more rows
#> # ℹ 25 more variables: punting_punts <int>, punting_punt_yards_available <int>,
#> #   punting_punt_yards <int>, punting_yards_per_punt <dbl>,
#> #   punting_longest_punt <int>, punting_punts50plus <int>,
#> #   punting_net_punt_yards_available <int>, punting_net_punt_yards <int>,
#> #   punting_net_yards_per_punt <dbl>, punting_touchbacks <int>,
#> #   punting_fair_catches <int>, punting_out_of_bounds <int>, …
# }
```
