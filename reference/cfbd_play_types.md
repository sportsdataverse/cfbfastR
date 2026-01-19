# **Get college football mapping for play types**

**Get college football mapping for play types**

## Usage

``` r
cfbd_play_types()
```

## Value

`cfbd_play_types()` - A data frame with 48 rows and 3 variables:

- `play_type_id`: integer:

  Referencing play type id.

- `text`: character:

  play type description.

- `abbreviation`: character:

  play type abbreviation used for function call

## See also

Other CFBD PBP:
[`cfbd_live_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.md),
[`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md),
[`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md),
[`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md),
[`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)

## Examples

``` r
# \donttest{
  try(cfbd_play_types())
#> ── Play types data from CollegeFootballData.com ────────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:22:33 UTC
#> # A tibble: 49 × 3
#>    play_type_id text              abbreviation
#>           <int> <chr>             <chr>       
#>  1            5 Rush              RUSH        
#>  2           24 Pass Reception    REC         
#>  3            3 Pass Incompletion NA          
#>  4           53 Kickoff           K           
#>  5           52 Punt              PUNT        
#>  6            8 Penalty           PEN         
#>  7           21 Timeout           TO          
#>  8            7 Sack              NA          
#>  9           68 Rushing Touchdown TD          
#> 10           67 Passing Touchdown TD          
#> # ℹ 39 more rows
# }
```
