# **Get player season passing production, split by pass location**

**Get player season passing production, split by pass location**

## Usage

``` r
cfbd_passing_players_season(
  year = NULL,
  season_type = NULL,
  team = NULL,
  conference = NULL,
  passer_id = NULL,
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
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- passer_id:

  (*String* optional): CFBD athlete id of the passer to filter on.

- classification:

  (*String* optional): Division classification - fbs, fcs, ii, ii/iii,
  iii

## Value

`cfbd_passing_players_season()` - A data frame with 189 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Four-digit season year (e.g. 2025). |
| player_id | character | CFBD athlete identifier (use with [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md)). |
| player | character | Player full name. |
| team | character | Team name. |
| conference | character | Team conference name. |

plus the 23-column passing production block and its seven `locations_*`
repeats – both described under **The passing production block** and
**Location splits** in
[cfbd_passing](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing.md).

## See also

Other CFBD Passing:
[`cfbd_passing_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_players_games.md),
[`cfbd_passing_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_plays.md),
[`cfbd_passing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_games.md),
[`cfbd_passing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_passing_players_season(year = 2025, team = "Texas"))
#> ── Player season passing data from CollegeFootballData.com ─────────────────────
#> ℹ Data updated: 2026-09-10 05:40:55 UTC
#> # A tibble: 7 × 189
#>   season player_id player    team  conference attempts completions incompletions
#>    <int> <chr>     <chr>     <chr> <chr>         <int>       <int>         <int>
#> 1   2025 4870906   Arch Man… Texas SEC             399         242           149
#> 2   2025 5079613   Emmett M… Texas SEC               2           2             0
#> 3   2025 5141524   Kaliq Lo… Texas SEC               1           1             0
#> 4   2025 5141509   Karle La… Texas SEC               1           1             0
#> 5   2025 4877717   Matthew … Texas SEC               7           5             2
#> 6   2025 5079556   Parker L… Texas SEC               2           2             0
#> 7   2025 5218633   Ryan Win… Texas SEC               2           0             2
#> # ℹ 181 more variables: interceptions <int>, completion_rate <dbl>,
#> #   air_yards_attempts_available <int>, total_air_yards <int>,
#> #   average_depth_of_target <dbl>, total_yards_attempts_available <int>,
#> #   total_yards <int>, yards_after_catch_attempts_available <int>,
#> #   total_yards_after_catch <int>, average_yards_after_catch <dbl>,
#> #   success_rate <dbl>, ppa <dbl>, total_ppa <dbl>, explosiveness <dbl>,
#> #   ppa_attempts_available <int>, success_attempts_available <int>, …
# }
```
