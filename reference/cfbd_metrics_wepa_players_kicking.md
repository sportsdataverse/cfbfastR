# **Get Points Added Above Replacement (PAAR) ratings for kickers**

**Get Points Added Above Replacement (PAAR) ratings for kickers**

## Usage

``` r
cfbd_metrics_wepa_players_kicking(year = NULL, team = NULL, conference = NULL)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2016

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

## Value

`cfbd_metrics_wepa_players_kicking()` - A data frame with 7 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| year | integer | Four-digit season year (e.g. 2019). |
| athlete_id | character | CFBD athlete identifier (use with [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md)). |
| athlete_name | character | Kicker full name. |
| team | character | Full team name (e.g. "TCU"). |
| conference | character | Team conference name (e.g. "Big 12"). |
| paar | numeric | Points Added Above Replacement on field goal attempts (kicker value vs baseline). |
| attempts | integer | Total field goal attempts included in the PAAR calculation. |

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md),
[`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.md),
[`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md),
[`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md),
[`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md),
[`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md),
[`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_wepa_players_kicking(year = 2019, team = "TCU"))
#> Waiting 5s for retry backoff ■■■■■■■                         
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 9s for retry backoff ■■■■                            
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 19s for retry backoff ■■■                             
#> Waiting 19s for retry backoff ■■■■■■■■                        
#> Waiting 19s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 19s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 19s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 19s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 19s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 27s for retry backoff ■■                              
#> Waiting 27s for retry backoff ■■■■■                           
#> Waiting 27s for retry backoff ■■■■■■■■                        
#> Waiting 27s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 27s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 27s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 27s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 27s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 27s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 27s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:58:14.702065: Invalid arguments or no Points Added Above Replacement (PAAR) ratings for kicking data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
