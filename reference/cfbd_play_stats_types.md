# **Get college football mapping for play stats types**

**Get college football mapping for play stats types**

## Usage

``` r
cfbd_play_stats_types()
```

## Value

`cfbd_play_stats_types()` - A data frame with 25 rows and 2 variables:

- `play_stat_type_id`: integer:

  Referencing play stat type ID.

- `name`: character:

  Type of play stats.

## See also

Other CFBD PBP:
[`cfbd_live_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.md),
[`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md),
[`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md),
[`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md),
[`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)

## Examples

``` r
# \donttest{
  try(cfbd_play_stats_types())
#> ── Play stats type data from CollegeFootballData.com ───────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:22:33 UTC
#> # A tibble: 26 × 2
#>    play_stat_type_id name            
#>                <int> <chr>           
#>  1                 1 Incompletion    
#>  2                 2 Target          
#>  3                 3 Pass Breakup    
#>  4                 4 Completion      
#>  5                 5 Reception       
#>  6                 6 Tackle          
#>  7                 7 Rush            
#>  8                 8 Fumble          
#>  9                 9 Fumble Forced   
#> 10                10 Fumble Recovered
#> # ℹ 16 more rows
# }
```
