# **Get weather from games.**

**Get weather from games.**

## Usage

``` r
cfbd_game_weather(
  year,
  week = NULL,
  season_type = "regular",
  team = NULL,
  conference = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format(*YYYY*)

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

## Value

`cfbd_game_weather()` - A data frame with 23 variables:

- `game_id`: integer.:

  Referencing game id.

- `season`: integer.:

  Season of the game.

- `week`: integer.:

  Game week.

- `season_type`: character.:

  Season type of the game.

- `start_date`: character.:

  Game date.

- `start_time_tbd`: logical.:

  TRUE/FALSE flag for if the game's start time is to be determined.

- `game_indoors`: logical.:

  TRUE/FALSE flag for if the game is indoors

- `home_team`: character.:

  Home team name.

- `home_conference`: character.:

  Home team conference.

- `away_team`: character.:

  Away team name.

- `away_conference`: character.:

  Away team conference.

- `venue_id`: integer.:

  Referencing venue id.

- `venue`: character.:

  Venue name.

- `temperature`: integer.:

  Temperature.

- `dew_point`: integer.:

  Dew Point.

- `humidity`: integer.:

  Humidity.

- `precipitation`: integer.:

  Precipitation.

- `snowfall`: integer.:

  Snowfall.

- `wind_direction`: integer.:

  Wind direction.

- `wind_speed`: integer.:

  Wind Speed.

- `pressure`: integer.:

  Pressure.

- `weather_condition_code`: integer.:

  Weather condition code.

- `weather_condition`: character.:

  Weather condition.

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)
