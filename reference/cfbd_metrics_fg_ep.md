# **Get FG expected points from CFBD API**

**Get FG expected points from CFBD API**

## Usage

``` r
cfbd_metrics_fg_ep()
```

## Value

`cfbd_metrics_fg_ep()` - A data frame with 3 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| yards_to_goal | integer | Yards to the goal line (0-100). |
| distance | integer | Distance to goal posts from kicking location (17 yds further than yards to goal). |
| expected_points | numeric | Expected points given yards to goal / distance. |

## See also

Other CFBD Metrics:
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md),
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
  try(cfbd_metrics_fg_ep())
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■      
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 11s for retry backoff ■■■■■■■■                        
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 10s for retry backoff ■■■■                            
#> Waiting 10s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 10s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 10s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 44s for retry backoff ■■                              
#> Waiting 44s for retry backoff ■■■                             
#> Waiting 44s for retry backoff ■■■■■                           
#> Waiting 44s for retry backoff ■■■■■■■                         
#> Waiting 44s for retry backoff ■■■■■■■■■                       
#> Waiting 44s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 44s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 44s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 44s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 44s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 44s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 44s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 44s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■      
#> Waiting 44s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 44s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 44s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:50:43.869653: Invalid arguments or no CFBData metrics FG expected points data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
