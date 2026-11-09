# **Get team game averages for predicted points added (PPA)**

**Get team game averages for predicted points added (PPA)**

## Usage

``` r
cfbd_metrics_ppa_games(
  year,
  week = NULL,
  season_type = "both",
  team = NULL,
  conference = NULL,
  excl_garbage_time = FALSE,
  division = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2001

- week:

  (*Integer* optional): Week - values range from 1-15, 1-14 for seasons
  pre-playoff, i.e. 2013 or earlier

- season_type:

  (*String* default both): Season type - regular, postseason, both,
  allstar, spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- excl_garbage_time:

  (*Logical* default FALSE): Select whether to exclude Garbage Time
  (TRUE or FALSE)

- division:

  (*String* optional): Division/classification filter – one of `fbs`,
  `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.

## Value

`cfbd_metrics_ppa_games()` - A data frame with 19 variables:

|                 |           |                                                |
|-----------------|-----------|------------------------------------------------|
| col_name        | types     | description                                    |
| game_id         | integer   | Referencing game id.                           |
| season          | integer   | Season of the game.                            |
| week            | integer   | Game week of the season.                       |
| season_type     | character | Season type (regular, postseason, etc.).       |
| conference      | character | Conference of the team.                        |
| team            | character | Team name.                                     |
| opponent        | character | Team opponent name.                            |
| off_overall     | numeric   | Offense overall predicted points added (PPA).  |
| off_passing     | numeric   | Offense passing predicted points added (PPA).  |
| off_rushing     | numeric   | Offense rushing predicted points added (PPA).  |
| off_first_down  | numeric   | Offense 1st down predicted points added (PPA). |
| off_second_down | numeric   | Offense 2nd down predicted points added (PPA). |
| off_third_down  | numeric   | Offense 3rd down predicted points added (PPA). |
| def_overall     | numeric   | Defense overall predicted points added (PPA).  |
| def_passing     | numeric   | Defense passing predicted points added (PPA).  |
| def_rushing     | numeric   | Defense rushing predicted points added (PPA).  |
| def_first_down  | numeric   | Defense 1st down predicted points added (PPA). |
| def_second_down | numeric   | Defense 2nd down predicted points added (PPA). |
| def_third_down  | numeric   | Defense 3rd down predicted points added (PPA). |

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
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
  try(cfbd_metrics_ppa_games(year = 2019, team = "TCU"))
#> Waiting 3s for retry backoff ■■■■■■■■■■                      
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 10s for retry backoff ■■■■■■■                         
#> Waiting 10s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 10s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■      
#> Waiting 10s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 11s for retry backoff ■■■■                            
#> Waiting 11s for retry backoff ■■■■■■■■■■                      
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 47s for retry backoff ■■                              
#> Waiting 47s for retry backoff ■■■■                            
#> Waiting 47s for retry backoff ■■■■■■                          
#> Waiting 47s for retry backoff ■■■■■■■■                        
#> Waiting 47s for retry backoff ■■■■■■■■■                       
#> Waiting 47s for retry backoff ■■■■■■■■■■■                     
#> Waiting 47s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 47s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 47s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 47s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 47s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 47s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 47s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 47s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 47s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 47s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 47s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:51:58.076657: Invalid arguments or no CFBData metrics PPA games data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
