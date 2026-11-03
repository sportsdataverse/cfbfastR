# **Get team season punting production, kicking and receiving**

**Get team season punting production, kicking and receiving**

## Usage

``` r
cfbd_punting_teams_season(
  year = NULL,
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

`cfbd_punting_teams_season()` - A data frame with 51 variables:

|            |           |                                     |
|------------|-----------|-------------------------------------|
| col_name   | type      | description                         |
| season     | integer   | Four-digit season year (e.g. 2025). |
| team       | character | Team name.                          |
| conference | character | Team conference name.               |

plus TWO copies of the 24-column team punting block: `punting_*` (the
team's own punts) and `returning_*` (the punts it received). That is 3 +
2 x 24 = 51. See **The team punting block** in
[cfbd_punting](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting.md).

## See also

Other CFBD Punting:
[`cfbd_punting_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_players_games.md),
[`cfbd_punting_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_players_season.md),
[`cfbd_punting_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_plays.md),
[`cfbd_punting_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_teams_games.md)

## Examples

``` r
# \donttest{
  try(cfbd_punting_teams_season(year = 2025, team = "Texas"))
#> ── Team season punting data from CollegeFootballData.com ───── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-03 18:51:50 UTC
#> # A tibble: 1 × 51
#>   season team  conference punting_punts punting_punt_yards_available
#>    <int> <chr> <chr>              <int>                        <int>
#> 1   2025 Texas SEC                   59                           58
#> # ℹ 46 more variables: punting_punt_yards <int>, punting_yards_per_punt <dbl>,
#> #   punting_longest_punt <int>, punting_punts50plus <int>,
#> #   punting_net_punt_yards_available <int>, punting_net_punt_yards <int>,
#> #   punting_net_yards_per_punt <dbl>, punting_touchbacks <int>,
#> #   punting_fair_catches <int>, punting_out_of_bounds <int>,
#> #   punting_downed <int>, punting_inside20 <int>, punting_blocked <int>,
#> #   punting_returns <int>, punting_return_yards_available <int>, …
# }
```
