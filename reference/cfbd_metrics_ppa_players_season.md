# **Get player season averages for predicted points added (PPA)**

**Get player season averages for predicted points added (PPA)**

## Usage

``` r
cfbd_metrics_ppa_players_season(
  year = NULL,
  team = NULL,
  conference = NULL,
  position = NULL,
  athlete_id = NULL,
  threshold = NULL,
  excl_garbage_time = FALSE
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). Required if
  athlete_id not provided  
  Minimum value accepted: 2013

- team:

  (*String* optional): D-I Team.

- conference:

  (*String* optional): Conference abbreviation - S&P+ information by
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- position:

  (*string* optional): Position abbreviation of the player you are
  searching for. Position Group - options include:

  - Offense: QB, RB, FB, TE, OL, G, OT, C, WR

  - Defense: DB, CB, S, LB, DE, DT, NT, DL

  - Special Teams: K, P, LS, PK

- athlete_id:

  (*Integer* optional): Athlete ID filter for querying a single athlete.
  Required if year not provided Can be found using the
  [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md)
  function.

- threshold:

  (*Integer* optional): Minimum threshold of plays.

- excl_garbage_time:

  (*Logical* default FALSE): Select whether to exclude Garbage Time
  (TRUE or FALSE)

## Value

`cfbd_metrics_ppa_players_season()` - A data frame with 23 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Four-digit season year. |
| athlete_id | character | Athlete referencing id. |
| name | character | Athlete name. |
| position | character | Athlete position abbreviation (e.g. "QB", "RB"). |
| team | character | Team name. |
| conference | character | Team conference name. |
| countable_plays | integer | DEPRECATED Number of plays which can be counted. |
| avg_PPA_all | numeric | Average overall predicted points added (PPA). |
| avg_PPA_pass | numeric | Average passing predicted points added (PPA). |
| avg_PPA_rush | numeric | Average rushing predicted points added (PPA). |
| avg_PPA_first_down | numeric | Average 1st down predicted points added (PPA). |
| avg_PPA_second_down | numeric | Average 2nd down predicted points added (PPA). |
| avg_PPA_third_down | numeric | Average 3rd down predicted points added (PPA). |
| avg_PPA_standard_downs | numeric | Average standard down predicted points added (PPA). |
| avg_PPA_passing_downs | numeric | Average passing down predicted points added (PPA). |
| total_PPA_all | numeric | Total overall predicted points added (PPA). |
| total_PPA_pass | numeric | Total passing predicted points added (PPA). |
| total_PPA_rush | numeric | Total rushing predicted points added (PPA). |
| total_PPA_first_down | numeric | Total 1st down predicted points added (PPA). |
| total_PPA_second_down | numeric | Total 2nd down predicted points added (PPA). |
| total_PPA_third_down | numeric | Total 3rd down predicted points added (PPA). |
| total_PPA_standard_downs | numeric | Total standard down predicted points added (PPA). |
| total_PPA_passing_downs | numeric | Total passing down predicted points added (PPA). |

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
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
  try(cfbd_metrics_ppa_players_season(year = 2019, team = "TCU"))
#> Waiting 6s for retry backoff ■■■■■■                          
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 7s for retry backoff ■■■■■                           
#> Waiting 7s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 7s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 7s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 24s for retry backoff ■■■■                            
#> Waiting 24s for retry backoff ■■■■■■■■                        
#> Waiting 24s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 24s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 24s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 24s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 24s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 24s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 23s for retry backoff ■■                              
#> Waiting 23s for retry backoff ■■■■■                           
#> Waiting 23s for retry backoff ■■■■■■■■■                       
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:54:17.789329: Invalid arguments or no CFBData metrics PPA season-level players data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
