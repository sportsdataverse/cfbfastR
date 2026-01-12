# **Get stats categories**

This function identifies all Stats Categories identified in the regular
stats endpoint.

## Usage

``` r
cfbd_stats_categories()
```

## Value

`cfbd_stats_categories()` A data frame with 38 values:

- name:

  Statistics Categories

## See also

Other CFBD Stats:
[`cfbd_stats_game_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.md),
[`cfbd_stats_season_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_advanced.md),
[`cfbd_stats_season_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.md),
[`cfbd_stats_season_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_team.md)

## Examples

``` r
# \donttest{
   try(cfbd_stats_categories())
#> ── Stat categories for CollegeFootballData.com ─────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:49 UTC
#> # A tibble: 38 × 1
#>    category          
#>    <chr>             
#>  1 completionAttempts
#>  2 defensiveTDs      
#>  3 extraPoints       
#>  4 fieldGoalPct      
#>  5 fieldGoals        
#>  6 firstDowns        
#>  7 fourthDownEff     
#>  8 fumblesLost       
#>  9 fumblesRecovered  
#> 10 interceptions     
#> # ℹ 28 more rows
# }
```
