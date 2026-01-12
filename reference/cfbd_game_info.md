# **Get results information from games.**

**Get results information from games.**

## Usage

``` r
cfbd_game_info(
  year,
  week = NULL,
  season_type = "both",
  team = NULL,
  home_team = NULL,
  away_team = NULL,
  conference = NULL,
  division = "fbs",
  game_id = NULL,
  quarter_scores = FALSE
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format(*YYYY*)

- week:

  (*Integer* optional): Week - values from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier)

- season_type:

  (*String* default both): Select Season Type: regular, postseason,
  both, allstar, spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- home_team:

  (*String* optional): Home D-I Team

- away_team:

  (*String* optional): Away D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- division:

  (*String* optional): Division abbreviation - Select a valid division:
  fbs/fcs/ii/iii

- game_id:

  (*Integer* optional): Game ID filter for querying a single game

- quarter_scores:

  (*Logical* default FALSE): This is a parameter to return the list
  columns that give the score at each quarter: `home_line_scores` and
  `away_line_scores`. I have defaulted the parameter to false so that
  you will not have to go to the trouble of dropping it.

## Value

`cfbd_game_info()` - A data frame with 22 variables:

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

- `neutral_site`: logical.:

  TRUE/FALSE flag for the game taking place at a neutral site.

- `conference_game`: logical.:

  TRUE/FALSE flag for this game qualifying as a conference game.

- `attendance`: integer.:

  Reported attendance at the game.

- `venue_id`: integer.:

  Referencing venue id.

- `venue`: character.:

  Venue name.

- `home_id`: integer.:

  Home team referencing id.

- `home_team`: character.:

  Home team name.

- `home_conference`: character.:

  Home team conference.

- `home_division`: character.:

  Home team division.

- `home_points`: integer.:

  Home team points.

- `home_post_win_prob`: character.:

  Home team post-game win probability.

- `home_pregame_elo`: character.:

  Home team pre-game ELO rating.

- `home_postgame_elo`: character.:

  Home team post-game ELO rating.

- `away_id`: integer.:

  Away team referencing id.

- `away_team`: character.:

  Away team name.

- `away_conference`: character.:

  Away team conference.

- `away_division`: character.:

  Away team division.

- `away_points`: integer.:

  Away team points.

- `away_post_win_prob`: character.:

  Away team post-game win probability.

- `away_pregame_elo`: character.:

  Away team pre-game ELO rating.

- `away_postgame_elo`: character.:

  Away team post-game ELO rating.

- `excitement_index`: character.:

  Game excitement index.

- `highlights`: character.:

  Game highlight urls.

- `notes`: character.:

  Game notes.

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_info(2018, week = 7, conference = "Ind"))
#> ── Game information from CollegeFootballData.com ───────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:32:53 UTC
#> # A tibble: 5 × 31
#>     game_id season  week season_type start_date         start_time_tbd completed
#>       <int>  <int> <int> <chr>       <chr>              <lgl>          <lgl>    
#> 1 401013452   2018     7 regular     2018-10-13T18:00:… FALSE          TRUE     
#> 2 401013148   2018     7 regular     2018-10-13T18:30:… FALSE          TRUE     
#> 3 401013370   2018     7 regular     2018-10-13T19:30:… FALSE          TRUE     
#> 4 401013442   2018     7 regular     2018-10-13T21:00:… FALSE          TRUE     
#> 5 401016408   2018     7 regular     2018-10-14T02:15:… FALSE          TRUE     
#> # ℹ 24 more variables: neutral_site <lgl>, conference_game <lgl>,
#> #   attendance <int>, venue_id <int>, venue <chr>, home_id <int>,
#> #   home_team <chr>, home_division <chr>, home_conference <chr>,
#> #   home_points <int>, home_post_win_prob <dbl>, home_pregame_elo <int>,
#> #   home_postgame_elo <int>, away_id <int>, away_team <chr>,
#> #   away_division <chr>, away_conference <chr>, away_points <int>,
#> #   away_post_win_prob <dbl>, away_pregame_elo <int>, …
# }
```
