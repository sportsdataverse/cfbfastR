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
  quarter_scores = FALSE,
  competition = NULL,
  round = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format(*YYYY*)  
  Minimum value accepted: 1869

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

- competition:

  (*String* optional): Competition filter; `cfp` restricts to College
  Football Playoff games.

- round:

  (*String* optional): Playoff round – `first_round`, `quarterfinal`,
  `semifinal`, `championship`.

## Value

A data frame with one row per game and 32 variables. With
`quarter_scores = TRUE` the per-period scores are inserted after
`home_points` and after `away_points`: one `home_scores_Q<n>` and one
`away_scores_Q<n>` column per period played by any game in the result,
so overtime adds `_Q5` onward (the seven-overtime 2018 LSU at Texas A&M
game reaches `_Q11`). An empty data frame is returned if the request
fails.

|  |  |  |
|----|----|----|
| col_name | type | description |
| game_id | integer | Unique CFBD game identifier. |
| season | integer | Season of the game. |
| week | integer | Game week (postseason games restart at week 1). |
| season_type | character | Season type of the game (e.g. regular, postseason). |
| start_date | character | Game start date-time (ISO 8601, UTC). |
| start_time_tbd | logical | TRUE/FALSE flag for if the game's start time is to be determined. |
| completed | logical | TRUE if the game has been completed. |
| neutral_site | logical | TRUE/FALSE flag for the game taking place at a neutral site. |
| conference_game | logical | TRUE/FALSE flag for this game qualifying as a conference game. |
| attendance | integer | Reported attendance at the game; NA when not reported. |
| venue_id | integer | CFBD venue id. |
| venue | character | Venue name. |
| home_id | integer | Home team CFBD id. |
| home_team | character | Home team name. |
| home_division | character | Home team division (CFBD classification): fbs, fcs, ii, ii/iii or iii. |
| home_conference | character | Home team conference. |
| home_points | integer | Home team points; NA until the game has a score. |
| home_scores_Q1 | integer | Home team points in the first quarter; present only with `quarter_scores = TRUE`. |
| home_scores_Q2 | integer | Home team points in the second quarter; present only with `quarter_scores = TRUE`. |
| home_scores_Q3 | integer | Home team points in the third quarter; present only with `quarter_scores = TRUE`. |
| home_scores_Q4 | integer | Home team points in the fourth quarter; present only with `quarter_scores = TRUE`. |
| home_post_win_prob | double | Home team post-game win probability (proportion 0-1). |
| home_pregame_elo | integer | Home team pre-game Elo rating. |
| home_postgame_elo | integer | Home team post-game Elo rating. |
| away_id | integer | Away team CFBD id. |
| away_team | character | Away team name. |
| away_division | character | Away team division (CFBD classification): fbs, fcs, ii, ii/iii or iii. |
| away_conference | character | Away team conference. |
| away_points | integer | Away team points; NA until the game has a score. |
| away_scores_Q1 | integer | Away team points in the first quarter; present only with `quarter_scores = TRUE`. |
| away_scores_Q2 | integer | Away team points in the second quarter; present only with `quarter_scores = TRUE`. |
| away_scores_Q3 | integer | Away team points in the third quarter; present only with `quarter_scores = TRUE`. |
| away_scores_Q4 | integer | Away team points in the fourth quarter; present only with `quarter_scores = TRUE`. |
| away_post_win_prob | double | Away team post-game win probability (proportion 0-1). |
| away_pregame_elo | integer | Away team pre-game Elo rating. |
| away_postgame_elo | integer | Away team post-game Elo rating. |
| excitement_index | double | Game excitement index (CFBD measure of in-game win-probability swings; higher is more exciting). |
| highlights | character | Game highlight URL; NA or empty when none. |
| notes | character | Game notes (e.g. the bowl name); NA when none. |
| playoff | data.frame | Playoff context. An all-NA logical column when no game in the result has playoff context; otherwise a nested data frame column (not flattened) of `competition`, `format`, `round`, `roundName`, `bracketSlot`, `homeSeed`, `awaySeed`, `bowlName`, NA for non-playoff games. See the `playoff_*` columns of [`cfbd_game_schedule()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_schedule.md) for their meaning. |

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
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
  try(cfbd_game_info(2018, week = 7, conference = "Ind"))
#> ── Game information from CollegeFootballData.com ──────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-01 04:38:01 UTC
#> # A tibble: 5 × 32
#>     game_id season  week season_type start_date         start_time_tbd completed
#>       <int>  <int> <int> <chr>       <chr>              <lgl>          <lgl>    
#> 1 401013452   2018     7 regular     2018-10-13T18:00:… FALSE          TRUE     
#> 2 401013148   2018     7 regular     2018-10-13T18:30:… FALSE          TRUE     
#> 3 401013370   2018     7 regular     2018-10-13T19:30:… FALSE          TRUE     
#> 4 401013442   2018     7 regular     2018-10-13T21:00:… FALSE          TRUE     
#> 5 401016408   2018     7 regular     2018-10-14T02:15:… FALSE          TRUE     
#> # ℹ 25 more variables: neutral_site <lgl>, conference_game <lgl>,
#> #   attendance <int>, venue_id <int>, venue <chr>, home_id <int>,
#> #   home_team <chr>, home_division <chr>, home_conference <chr>,
#> #   home_points <int>, home_post_win_prob <dbl>, home_pregame_elo <int>,
#> #   home_postgame_elo <int>, away_id <int>, away_team <chr>,
#> #   away_division <chr>, away_conference <chr>, away_points <int>,
#> #   away_post_win_prob <dbl>, away_pregame_elo <int>, …
# }
```
