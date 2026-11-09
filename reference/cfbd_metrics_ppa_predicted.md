# **Calculate predicted points using down and distance**

**Calculate predicted points using down and distance**

## Usage

``` r
cfbd_metrics_ppa_predicted(down, distance)
```

## Arguments

- down:

  (*Integer* required): Down filter

- distance:

  (*Integer* required): Distance filter

## Value

`cfbd_metrics_ppa_predicted()` - A data frame with 2 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| yard_line | integer | Yards to goal. |
| predicted_points | numeric | Predicted points in that down-distance-yardline scenario. |

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.md),
[`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.md),
[`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md),
[`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md),
[`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md),
[`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md),
[`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_ppa_predicted(down = 1, distance = 10))
#> Waiting 6s for retry backoff ■■■■■■                          
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 12s for retry backoff ■■■■■■■■                        
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 18s for retry backoff ■■■                             
#> Waiting 18s for retry backoff ■■■■■■                          
#> Waiting 18s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 18s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 18s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 18s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 18s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:55:03.691585: Invalid arguments or no CFBData metrics PPA predicted data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows

  try(cfbd_metrics_ppa_predicted(down = 3, distance = 10))
#> Waiting 6s for retry backoff ■■■■■■                          
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 7s for retry backoff ■■■■■■■                         
#> Waiting 7s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 7s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 23s for retry backoff ■■                              
#> Waiting 23s for retry backoff ■■■■■■                          
#> Waiting 23s for retry backoff ■■■■■■■■■■                      
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 26s for retry backoff ■■■■                            
#> Waiting 26s for retry backoff ■■■■■■■■                        
#> Waiting 26s for retry backoff ■■■■■■■■■■■                     
#> Waiting 26s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 26s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 26s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 26s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 26s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 26s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:56:05.566484: Invalid arguments or no CFBData metrics PPA predicted data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
