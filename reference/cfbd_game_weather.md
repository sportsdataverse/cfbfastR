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
| weather_condition_code | integer | Numeric weather condition code, labelled by `weather_condition` (e.g. 1 = Clear, 3 = Cloudy, 8 = Rain, 25 = Thunderstorm). |
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
#> ── Game weather data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-09 03:12:56 UTC
#> # A tibble: 16 × 22
#>      game_id season  week season_type start_time          game_indoors home_team
#>        <int>  <int> <int> <chr>       <chr>               <lgl>        <chr>    
#>  1 401752665   2025     1 regular     2025-08-30T19:30:0… FALSE        Florida …
#>  2 401752666   2025     1 regular     2025-08-30T20:15:0… FALSE        Arkansas 
#>  3 401752675   2025     1 regular     2025-08-30T22:00:0… FALSE        Oklahoma 
#>  4 401752670   2025     1 regular     2025-08-30T16:45:0… FALSE        Kentucky 
#>  5 401752673   2025     1 regular     2025-08-30T16:00:0… FALSE        Southern…
#>  6 401752677   2025     1 regular     2025-08-30T16:00:0… FALSE        Ohio Sta…
#>  7 401752679   2025     1 regular     2025-08-30T23:00:0… FALSE        Vanderbi…
#>  8 401752667   2025     1 regular     2025-08-30T00:00:0… FALSE        Baylor   
#>  9 401752676   2025     1 regular     2025-08-30T16:00:0… TRUE         Tennessee
#> 10 401752674   2025     1 regular     2025-08-28T23:30:0… FALSE        Missouri 
#> 11 401752680   2025     1 regular     2025-08-31T19:00:0… TRUE         South Ca…
#> 12 401752668   2025     1 regular     2025-08-30T23:00:0… FALSE        Florida  
#> 13 401752678   2025     1 regular     2025-08-30T23:00:0… FALSE        Texas A&M
#> 14 401752671   2025     1 regular     2025-08-30T23:30:0… FALSE        Clemson  
#> 15 401752669   2025     1 regular     2025-08-30T19:30:0… FALSE        Georgia  
#> 16 401752672   2025     1 regular     2025-08-30T23:45:0… FALSE        Ole Miss 
#> # ℹ 15 more variables: home_conference <chr>, away_team <chr>,
#> #   away_conference <chr>, venue_id <int>, venue <chr>, temperature <dbl>,
#> #   dew_point <dbl>, humidity <int>, precipitation <int>, snowfall <int>,
#> #   wind_direction <int>, wind_speed <dbl>, pressure <dbl>,
#> #   weather_condition_code <int>, weather_condition <chr>
# }
```
