# **Get game media information (TV, radio, etc).**

**Get game media information (TV, radio, etc).**

## Usage

``` r
cfbd_game_media(
  year,
  week = NULL,
  season_type = "both",
  team = NULL,
  conference = NULL,
  media_type = NULL,
  division = "fbs"
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2003

- week:

  (*Integer* optional): Week, values from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier)

- season_type:

  (*String* default both): Select Season Type, regular, postseason,
  both, allstar, spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- media_type:

  (*String* optional): Media type filter: tv, radio, web, ppv, or mobile

- division:

  (*String* optional): Division abbreviation - Select a valid division:
  fbs/fcs/ii/iii

## Value

`cfbd_game_media()` - A data frame with 13 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | integer | Referencing game id. |
| season | integer | Season of the game. |
| week | integer | Game week. |
| season_type | character | Season type of the game. |
| start_time | character | Game start time. |
| is_start_time_tbd | logical | TRUE/FALSE flag for if the start time is still to be determined. |
| home_team | character | Home team of the game. |
| home_conference | character | Conference of the home team. |
| away_team | character | Away team of the game. |
| away_conference | character | Conference of the away team. |
| tv | list | TV broadcast networks. |
| radio | logical | Radio broadcast networks. |
| web | list | Web viewing platforms carrying the game. |

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_preview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_preview.md),
[`cfbd_game_preview_adjusted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_preview_adjusted.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_schedule()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_schedule.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_media(2019, week = 4, conference = "ACC"))
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 6s for retry backoff ■■■■■■                          
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 10s for retry backoff ■■■■                            
#> Waiting 10s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 10s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 10s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 22s for retry backoff ■■                              
#> Waiting 22s for retry backoff ■■■■■■                          
#> Waiting 22s for retry backoff ■■■■■■■■■■                      
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■      
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 17s for retry backoff ■■■■■                           
#> Waiting 17s for retry backoff ■■■■■■■■■■■                     
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:37:08.821885: Invalid arguments or no game media data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
