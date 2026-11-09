# **Get player game averages for predicted points added (PPA)**

**Get player game averages for predicted points added (PPA)**

## Usage

``` r
cfbd_metrics_ppa_players_games(
  year = NULL,
  week = NULL,
  season_type = "both",
  team = NULL,
  position = NULL,
  athlete_id = NULL,
  threshold = NULL,
  excl_garbage_time = FALSE
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*).  
  Minimum value accepted: 2013

- week:

  (*Integer* optional): Week - values range from 1-15, 1-14 for seasons
  pre-playoff, i.e. 2013 or earlier. Required if team not provided.

- season_type:

  (*String* default both): Season type - regular, postseason, both,
  allstar, spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team. Required if week not provided.

- position:

  (*string* optional): Position abbreviation of the player you are
  searching for. Position Group - options include:

  - Offense: QB, RB, FB, TE, OL, G, OT, C, WR

  - Defense: DB, CB, S, LB, DE, DT, NT, DL

  - Special Teams: K, P, LS, PK

- athlete_id:

  (*Integer* optional): Athlete ID filter for querying a single athlete
  Can be found using the
  [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md)
  function.

- threshold:

  (*Integer* optional): Minimum threshold of plays.

- excl_garbage_time:

  (*Logical* default FALSE): Select whether to exclude Garbage Time
  (TRUE or FALSE)

## Value

`cfbd_metrics_ppa_players_games()` - A data frame with 10 variables:

|              |           |                                               |
|--------------|-----------|-----------------------------------------------|
| col_name     | types     | description                                   |
| season       | integer   | Season of the game.                           |
| week         | integer   | Game week of the season.                      |
| athlete_id   | character | Athlete referencing id.                       |
| name         | character | Athlete name.                                 |
| position     | character | Athlete position.                             |
| team         | character | Team name.                                    |
| opponent     | character | Team opponent name.                           |
| avg_PPA_all  | numeric   | Average overall predicted points added (PPA). |
| avg_PPA_pass | numeric   | Average passing predicted points added (PPA). |
| avg_PPA_rush | numeric   | Average rushing predicted points added (PPA). |

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
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
  try(cfbd_metrics_ppa_players_games(year = 2019, week = 3, team = "TCU"))
#> Waiting 6s for retry backoff ■■■■■■                          
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 11s for retry backoff ■■■■■■■■■                       
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■      
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 10s for retry backoff ■■■■                            
#> Waiting 10s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 10s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 10s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 45s for retry backoff ■■                              
#> Waiting 45s for retry backoff ■■■                             
#> Waiting 45s for retry backoff ■■■■■                           
#> Waiting 45s for retry backoff ■■■■■■■                         
#> Waiting 45s for retry backoff ■■■■■■■■■                       
#> Waiting 45s for retry backoff ■■■■■■■■■■■                     
#> Waiting 45s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 45s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 45s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 45s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 45s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 45s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 45s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 45s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 45s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 45s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 45s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:53:16.257282: Invalid arguments or no CFBData metrics PPA game-level players data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
