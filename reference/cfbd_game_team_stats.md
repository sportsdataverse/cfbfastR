# **Get team statistics by game**

**Get team statistics by game**

## Usage

``` r
cfbd_game_team_stats(
  year = NULL,
  week = NULL,
  season_type = "regular",
  team = NULL,
  conference = NULL,
  game_id = NULL,
  division = "fbs",
  rows_per_team = 1
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*). Required year
  filter (along with one of `week`, `team`, or `conference`), unless
  `game_id` is specified  
  Minimum value accepted: 2004

- week:

  (*Integer* optional): Week - values range from 1-15, 1-14 for seasons
  pre-playoff, i.e. 2013 or earlier. Required if `team` and `conference`
  not specified.

- season_type:

  (*String* default: regular): Select Season Type - regular, postseason,
  both, allstar, spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team. Required if `week` and `conference` not
  specified.

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC Required if `week` and `team` not specified.

- game_id:

  (*Integer* optional): Game ID filter for querying a single game. When
  supplied it is sent alone as `id`; `year`, `week`, `season_type`,
  `team` and `conference` are omitted (CFBD rejects them alongside
  `id`). Can be found using the
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  function

- division:

  (*String* optional): Division abbreviation - Select a valid division:
  fbs/fcs/ii/iii

- rows_per_team:

  (*Integer* default 1): Both Teams for each game on one or two row(s),
  Options: 1 or 2

## Value

A data frame with one row per team per game and 78 variables. A `team`
query keeps only that team's rows (CFBD returns both teams of each
game); a `conference` query keeps only the rows of that conference's
teams. The box-score statistics are character, as CFBD sends them, and
NA when CFBD has no value for that team. Every column from `points` to
`possession_time` is repeated with the suffix `_allowed`, holding the
opponent's value from the same game. With `rows_per_team = 2`,
`opponent`, `opponent_conference` and the `_allowed` columns are dropped
(40 variables). `NULL` is returned with a warning when CFBD returns no
games (e.g. a bye week), and an empty data frame if the request fails.

|  |  |  |
|----|----|----|
| col_name | type | description |
| game_id | integer | Unique CFBD game identifier. |
| school | character | Team name (CFBD `team`, renamed). |
| conference | character | Conference of the team. |
| home_away | character | home or away. |
| opponent | character | Opponent team name; absent with `rows_per_team = 2`. |
| opponent_conference | character | Conference of the opponent; absent with `rows_per_team = 2`. |
| points | integer | Team points. |
| total_yards | character | Total offensive yards. |
| net_passing_yards | character | Net passing yards. |
| completion_attempts | character | Completions and pass attempts as completions-attempts text (e.g. 21-28). |
| passing_tds | character | Passing touchdowns. |
| yards_per_pass | character | Yards per pass attempt. |
| passes_intercepted | character | Opponent passes the team intercepted; NA when none recorded. |
| interception_yards | character | Return yards on the team's interceptions. |
| interception_tds | character | Interceptions the team returned for a touchdown. |
| rushing_attempts | character | Rushing attempts. |
| rushing_yards | character | Rushing yards. |
| rush_tds | character | Rushing touchdowns. |
| yards_per_rush_attempt | character | Yards per rushing attempt. |
| first_downs | character | First downs. |
| third_down_eff | character | Third-down conversions as conversions-attempts text (e.g. 6-11). |
| fourth_down_eff | character | Fourth-down conversions as conversions-attempts text (e.g. 1-1). |
| punt_returns | character | Punt returns; NA when none recorded. |
| punt_return_yards | character | Punt return yards. |
| punt_return_tds | character | Punt return touchdowns. |
| kick_return_yards | character | Kickoff return yards. |
| kick_return_tds | character | Kickoff return touchdowns. |
| kick_returns | character | Kickoff returns. |
| kicking_points | character | Points from kicking (field goals and extra points). |
| fumbles_recovered | character | Fumbles recovered. |
| fumbles_lost | character | Fumbles lost to the opponent. |
| total_fumbles | character | Total fumbles; NA when none recorded. |
| tackles | character | Tackles. |
| tackles_for_loss | character | Tackles for loss. |
| sacks | character | Sacks by the team's defense. |
| qb_hurries | character | Quarterback hurries by the team's defense. |
| interceptions | character | Interceptions thrown by the team (counted in `turnovers`). |
| passes_deflected | character | Passes deflected by the team's defense. |
| turnovers | character | Turnovers committed. |
| defensive_tds | character | Defensive touchdowns. |
| total_penalties_yards | character | Penalties and penalty yards as penalties-yards text (e.g. 8-71). |
| possession_time | character | Time of possession as minutes:seconds text (e.g. 36:19). |
| points_allowed | integer | Points scored by the opponent. |
| total_yards_allowed | character | Opponent total offensive yards. |
| net_passing_yards_allowed | character | Opponent net passing yards. |
| completion_attempts_allowed | character | Opponent completions and pass attempts as completions-attempts text. |
| passing_tds_allowed | character | Opponent passing touchdowns. |
| yards_per_pass_allowed | character | Opponent yards per pass attempt. |
| passes_intercepted_allowed | character | Team passes the opponent intercepted; NA when none recorded. |
| interception_yards_allowed | character | Return yards on the opponent's interceptions. |
| interception_tds_allowed | character | Interceptions the opponent returned for a touchdown. |
| rushing_attempts_allowed | character | Opponent rushing attempts. |
| rushing_yards_allowed | character | Opponent rushing yards. |
| rush_tds_allowed | character | Opponent rushing touchdowns. |
| yards_per_rush_attempt_allowed | character | Opponent yards per rushing attempt. |
| first_downs_allowed | character | Opponent first downs. |
| third_down_eff_allowed | character | Opponent third-down conversions as conversions-attempts text. |
| fourth_down_eff_allowed | character | Opponent fourth-down conversions as conversions-attempts text. |
| punt_returns_allowed | character | Opponent punt returns; NA when none recorded. |
| punt_return_yards_allowed | character | Opponent punt return yards. |
| punt_return_tds_allowed | character | Opponent punt return touchdowns. |
| kick_return_yards_allowed | character | Opponent kickoff return yards. |
| kick_return_tds_allowed | character | Opponent kickoff return touchdowns. |
| kick_returns_allowed | character | Opponent kickoff returns. |
| kicking_points_allowed | character | Opponent points from kicking. |
| fumbles_recovered_allowed | character | Opponent fumbles recovered. |
| fumbles_lost_allowed | character | Fumbles the opponent lost. |
| total_fumbles_allowed | character | Opponent total fumbles; NA when none recorded. |
| tackles_allowed | character | Opponent tackles. |
| tackles_for_loss_allowed | character | Opponent tackles for loss. |
| sacks_allowed | character | Sacks by the opponent's defense. |
| qb_hurries_allowed | character | Quarterback hurries by the opponent's defense. |
| interceptions_allowed | character | Interceptions thrown by the opponent. |
| passes_deflected_allowed | character | Passes deflected by the opponent's defense. |
| turnovers_allowed | character | Turnovers committed by the opponent. |
| defensive_tds_allowed | character | Opponent defensive touchdowns. |
| total_penalties_yards_allowed | character | Opponent penalties and penalty yards as penalties-yards text. |
| possession_time_allowed | character | Opponent time of possession. |

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_preview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_preview.md),
[`cfbd_game_preview_adjusted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_preview_adjusted.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_schedule()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_schedule.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_team_stats(2022, team = "LSU"))
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 8s for retry backoff ■■■■■                           
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 23s for retry backoff ■■■■                            
#> Waiting 23s for retry backoff ■■■■■■■■                        
#> Waiting 23s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 23s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 48s for retry backoff ■■                              
#> Waiting 48s for retry backoff ■■■                             
#> Waiting 48s for retry backoff ■■■■■                           
#> Waiting 48s for retry backoff ■■■■■■■                         
#> Waiting 48s for retry backoff ■■■■■■■■■                       
#> Waiting 48s for retry backoff ■■■■■■■■■■■                     
#> Waiting 48s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 48s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 48s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 48s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 48s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 48s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 48s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 48s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■      
#> Waiting 48s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 48s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 48s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:46:26.587962: Invalid arguments or no team stats data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows

  try(cfbd_game_team_stats(2013, team = "Florida State"))
#> Waiting 3s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 5s for retry backoff ■■■■■■■■■                       
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 11s for retry backoff ■■■■■■■■■                       
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 24s for retry backoff ■■■                             
#> Waiting 24s for retry backoff ■■■■■■■                         
#> Waiting 24s for retry backoff ■■■■■■■■■■                      
#> Waiting 24s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 24s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 24s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 24s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 24s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 24s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 39s for retry backoff ■■                              
#> Waiting 39s for retry backoff ■■■■                            
#> Waiting 39s for retry backoff ■■■■■■■                         
#> Waiting 39s for retry backoff ■■■■■■■■■                       
#> Waiting 39s for retry backoff ■■■■■■■■■■■                     
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:47:46.991126: Invalid arguments or no team stats data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
