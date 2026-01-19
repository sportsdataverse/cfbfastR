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

- `game_id`: integer.:

  Referencing game id.

- `season`: integer.:

  Season of the game.

- `week`: integer.:

  Game week.

- `season_type`: character.:

  Season type of the game.

- `start_time`: character.:

  Game start time.

- `is_start_time_tbd`: logical.:

  TRUE/FALSE flag for if the start time is still to be determined.

- `home_team`: character.:

  Home team of the game.

- `home_conference`: character.:

  Conference of the home team.

- `away_team`: character.:

  Away team of the game.

- `away_conference`: character.:

  Conference of the away team.

- `tv`: list.:

  TV broadcast networks.

- `radio`: logical.:

  Radio broadcast networks.

- `web`: list.:

  Web viewing platforms carrying the game.

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_media(2019, week = 4, conference = "ACC"))
#> ── Game media data from CollegeFootballData.com ────────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:21:52 UTC
#> # A tibble: 10 × 13
#>      game_id season  week season_type start_time     is_start_time_tbd home_team
#>        <int>  <int> <int> <chr>       <chr>          <lgl>             <chr>    
#>  1 401112462   2019     4 regular     2019-09-21T16… FALSE             Syracuse 
#>  2 401112464   2019     4 regular     2019-09-21T16… FALSE             Wake For…
#>  3 401112265   2019     4 regular     2019-09-21T16… FALSE             Rutgers  
#>  4 401112461   2019     4 regular     2019-09-21T19… FALSE             Pittsbur…
#>  5 401112459   2019     4 regular     2019-09-21T19… FALSE             North Ca…
#>  6 401112457   2019     4 regular     2019-09-21T19… FALSE             Florida …
#>  7 401112458   2019     4 regular     2019-09-21T20… FALSE             Miami    
#>  8 401112460   2019     4 regular     2019-09-21T23… FALSE             NC State 
#>  9 401112463   2019     4 regular     2019-09-21T23… FALSE             Virginia 
#> 10 401112456   2019     4 regular     2019-09-21T23… FALSE             Clemson  
#> # ℹ 6 more variables: home_conference <chr>, away_team <chr>,
#> #   away_conference <chr>, tv <list>, radio <lgl>, web <list>
# }
```
