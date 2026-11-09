# **Get weather from games.**

**Get weather from games.**

## Usage

``` r
cfbd_game_weather(
  year = NULL,
  week = NULL,
  season_type = "regular",
  team = NULL,
  conference = NULL,
  division = NULL,
  game_id = NULL
)
```

## Arguments

- year:

  (*Integer* required unless `game_id` is supplied): Year, 4 digit
  format(*YYYY*)  
  Minimum value accepted: 2001

- week:

  (*Integer* optional): Week - values from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier)

- season_type:

  (*String* default regular): Select Season Type: regular, postseason,
  both, allstar, spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- division:

  (*String* optional): Division/classification filter – one of `fbs`,
  `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.

- game_id:

  (*Integer* optional): Game ID. When specified, returns weather for
  that game.

## Value

A data frame with one row per game and 22 variables. An empty data frame
is returned, with an informational message, when CFBD has no weather for
the filters yet (it backfills weather mid-week in season), and also if
the request fails.

|  |  |  |
|----|----|----|
| col_name | type | description |
| game_id | integer | Unique CFBD game identifier. |
| season | integer | Season of the game. |
| week | integer | Game week. |
| season_type | character | Season type of the game (e.g. regular, postseason). |
| start_time | character | Game start date-time (ISO 8601, UTC). |
| game_indoors | logical | TRUE/FALSE flag for if the game is indoors. |
| home_team | character | Home team name. |
| home_conference | character | Home team conference. |
| away_team | character | Away team name. |
| away_conference | character | Away team conference. |
| venue_id | integer | CFBD venue id. |
| venue | character | Venue name. |
| temperature | double | Game-time temperature, in degrees Fahrenheit. |
| dew_point | double | Dew point at kickoff, in degrees Fahrenheit. |
| humidity | integer | Relative humidity at kickoff, as a percentage (0-100). |
| precipitation | double | Precipitation at kickoff, in inches; parses as integer when every value in the result is a whole number (e.g. all 0). |
| snowfall | double | Snowfall at kickoff, in inches; parses as integer when every value in the result is a whole number (e.g. all 0). |
| wind_direction | integer | Wind direction, in degrees (0-360, 0 = north). |
| wind_speed | double | Wind speed, in miles per hour. |
| pressure | double | Barometric pressure, in millibars. |
| weather_condition_code | integer | Numeric weather condition code, labeled by `weather_condition` (e.g. 1 = Clear, 3 = Cloudy, 8 = Rain, 25 = Thunderstorm). |
| weather_condition | character | Weather condition label (e.g. Clear, Cloudy, Light Rain, Thunderstorm). |

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
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_weather(year = 2025, week = 1, conference = "SEC"))
#> Waiting 5s for retry backoff ■■■■■■■                         
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 11s for retry backoff ■■■                             
#> Waiting 11s for retry backoff ■■■■■■■■■■■                     
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 12s for retry backoff ■■■■■                           
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 17s for retry backoff ■■■■                            
#> Waiting 17s for retry backoff ■■■■■■■■■■                      
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> ✖ 2026-11-09 16:48:33.173087: Failed to fetch game weather data.Error: The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
