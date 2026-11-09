# **Get team averages for predicted points added (PPA)**

**Get team averages for predicted points added (PPA)**

## Usage

``` r
cfbd_metrics_ppa_teams(
  year = NULL,
  team = NULL,
  conference = NULL,
  excl_garbage_time = FALSE,
  division = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). Required if team
  not provided  
  Minimum value accepted: 2001

- team:

  (*String* optional): D-I Team. Required if year not provided

- conference:

  (*String* optional): Conference name - select a valid FBS conference
  Conference names P5: ACC, Big 12, Big Ten, SEC, Pac-12 Conference
  names G5 and FBS Independents: Conference USA, Mid-American, Mountain
  West, FBS Independents, American Athletic

- excl_garbage_time:

  (*Logical* default FALSE): Select whether to exclude Garbage Time
  (TRUE or FALSE)

- division:

  (*String* optional): Division/classification filter – one of `fbs`,
  `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.

## Value

`cfbd_metrics_ppa_teams()` - A data frame with 21 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Four-digit season year. |
| conference | character | Team conference name. |
| team | character | Team name. |
| off_overall | numeric | Offense overall predicted points added (PPA). |
| off_passing | numeric | Offense passing predicted points added (PPA). |
| off_rushing | numeric | Offense rushing predicted points added (PPA). |
| off_first_down | numeric | Offense 1st down predicted points added (PPA). |
| off_second_down | numeric | Offense 2nd down predicted points added (PPA). |
| off_third_down | numeric | Offense 3rd down predicted points added (PPA). |
| off_cumulative_total | numeric | Offense cumulative total predicted points added (PPA). |
| off_cumulative_passing | numeric | Offense cumulative total passing predicted points added (PPA). |
| off_cumulative_rushing | numeric | Offense cumulative total rushing predicted points added (PPA). |
| def_overall | numeric | Defense overall predicted points added (PPA). |
| def_passing | numeric | Defense passing predicted points added (PPA). |
| def_rushing | numeric | Defense rushing predicted points added (PPA). |
| def_first_down | numeric | Defense 1st down predicted points added (PPA). |
| def_second_down | numeric | Defense 2nd down predicted points added (PPA). |
| def_third_down | numeric | Defense 3rd down predicted points added (PPA). |
| def_cumulative_total | numeric | Defense cumulative total predicted points added (PPA). |
| def_cumulative_passing | numeric | Defense cumulative total passing predicted points added (PPA). |
| def_cumulative_rushing | numeric | Defense cumulative total rushing predicted points added (PPA). |

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md),
[`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.md),
[`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md),
[`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md),
[`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md),
[`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md),
[`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_ppa_teams(year = 2019, team = "TCU"))
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 6s for retry backoff ■■■■■■■■■                       
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 11s for retry backoff ■■■■■■■                         
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 21s for retry backoff ■■                              
#> Waiting 21s for retry backoff ■■■■■■                          
#> Waiting 21s for retry backoff ■■■■■■■■■■■                     
#> Waiting 21s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 21s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 21s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 21s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 21s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 30s for retry backoff ■■                              
#> Waiting 30s for retry backoff ■■■■■                           
#> Waiting 30s for retry backoff ■■■■■■■■                        
#> Waiting 30s for retry backoff ■■■■■■■■■■■                     
#> Waiting 30s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 30s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 30s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 30s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 30s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 30s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 30s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:57:14.328452: Invalid arguments or no CFBData metrics PPA teams data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
