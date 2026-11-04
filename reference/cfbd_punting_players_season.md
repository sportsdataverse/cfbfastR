# **Get player season punting and punt return production**

**Get player season punting and punt return production**

## Usage

``` r
cfbd_punting_players_season(
  year = NULL,
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

- season_type:

  (*String* optional): Season type - regular, postseason, both, allstar,
  spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

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

`cfbd_punting_players_season()` - A data frame with 30 variables:

|  |  |  |
|----|----|----|
| col_name | type | description |
| season | integer | Four-digit season year (e.g. 2025). |
| player_id | character | CFBD athlete identifier (use with [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md)). |
| player | character | Player full name. |
| team | character | Team name. |
| conference | character | Team conference name. |

plus the 15-column `punting_*` block and the 10-column `returning_*`
block, both described under **The player punting and return blocks** in
[cfbd_punting](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting.md).

## See also

Other CFBD Punting:
[`cfbd_punting_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_players_games.md),
[`cfbd_punting_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_plays.md),
[`cfbd_punting_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_teams_games.md),
[`cfbd_punting_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_punting_players_season(year = 2025, team = "Texas"))
#> ── Player season punting data from CollegeFootballData.com ─── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-04 03:39:31 UTC
#> # A tibble: 4 × 30
#>   season player_id player  team  conference punting_punts punting_punt_yards_a…¹
#>    <int> <chr>     <chr>   <chr> <chr>              <int>                  <int>
#> 1   2025 5141575   Daylan… Texas SEC                   NA                     NA
#> 2   2025 4870860   DeAndr… Texas SEC                   NA                     NA
#> 3   2025 4426752   Jack B… Texas SEC                   58                     58
#> 4   2025 4899367   Ryan N… Texas SEC                   NA                     NA
#> # ℹ abbreviated name: ¹​punting_punt_yards_available
#> # ℹ 23 more variables: punting_punt_yards <int>, punting_yards_per_punt <dbl>,
#> #   punting_longest_punt <int>, punting_punts50plus <int>,
#> #   punting_net_punt_yards_available <int>, punting_net_punt_yards <int>,
#> #   punting_net_yards_per_punt <dbl>, punting_touchbacks <int>,
#> #   punting_fair_catches <int>, punting_out_of_bounds <int>,
#> #   punting_downed <int>, punting_inside20 <int>, punting_blocked <int>, …
# }
```
