# **Get calendar of weeks by season.**

**Get calendar of weeks by season.**

## Usage

``` r
cfbd_calendar(year)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2002

## Value

`cfbd_calendar()` - A data frame with 5 variables:

|                  |           |                                             |
|------------------|-----------|---------------------------------------------|
| col_name         | types     | description                                 |
| season           | character | Calendar season.                            |
| week             | integer   | Calendar game week.                         |
| season_type      | character | Season type of calendar week.               |
| first_game_start | character | First game start time of the calendar week. |
| last_game_start  | character | Last game start time of the calendar week.  |

## See also

Other CFBD Games:
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
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
  try(cfbd_calendar(2019))
#> Waiting 4s for retry backoff ■■■■■■■■■                       
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 8s for retry backoff ■■■■■                           
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■      
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 12s for retry backoff ■■■■■■                          
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 29s for retry backoff ■■■■                            
#> Waiting 29s for retry backoff ■■■■■■■                         
#> Waiting 29s for retry backoff ■■■■■■■■■■                      
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:20:15.304345:Invalid arguments or no calendar data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
