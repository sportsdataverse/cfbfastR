# **Get live game scoreboard information from games.**

**Get live game scoreboard information from games.**

## Usage

``` r
cfbd_live_scoreboard(division = "fbs", conference = NULL)
```

## Arguments

- division:

  (*String* optional): Division abbreviation - Select a valid division:
  fbs/fcs/ii/iii

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

## Value

A data frame with one row per game on the current CFBD scoreboard. The
quarter columns depend on how far the games have gone:
`home_team_line_scores_Q1` and `away_team_line_scores_Q1` are always
present (all NA before any game starts), `_Q2` to `_Q4` appear once any
game in the result has reached that quarter, and overtime adds `_Q5`
onward. So there are 37 variables before kickoff and 43 once a game
reaches the fourth quarter. An empty data frame is returned if the
request fails.

|  |  |  |
|----|----|----|
| col_name | type | description |
| game_id | integer | CFBD-internal game id; join key to other CFBD endpoints. |
| start_date | character | Scheduled kickoff timestamp (ISO 8601, UTC). |
| start_time_tbd | logical | TRUE if the scheduled kickoff time is still to be determined. |
| tv | character | Television network broadcasting the game (e.g. ESPNU). |
| neutral_site | logical | TRUE if the game is being played at a neutral site. |
| conference_game | logical | TRUE if the game is a conference game. |
| status | character | Game status: scheduled, in_progress or completed. |
| period | integer | Current period/quarter number (1-4, 5+ for overtime); NA before kickoff. |
| clock | character | Game clock remaining in the current period, as sent by CFBD; NA before kickoff. |
| situation | character | Free-text down-and-distance / field-position summary for the current play; NA before kickoff. |
| possession | character | Team currently in possession, as sent by CFBD; NA before kickoff. |
| last_play | character | Free-text description of the most recent play; NA before kickoff. |
| venue_name | character | Stadium / venue name. |
| venue_city | character | City where the venue is located. |
| venue_state | character | State (or province/country) where the venue is located. |
| home_team_id | integer | CFBD-internal team id for the home team. |
| home_team_name | character | Home team display name including mascot (e.g. Kansas Jayhawks). |
| home_team_conference | character | Conference name of the home team. |
| home_team_classification | character | Division classification of the home team: fbs, fcs, ii, ii/iii or iii. |
| home_team_points | integer | Current total points scored by the home team; NA before kickoff. |
| home_team_line_scores_Q1 | integer | Home team points scored in the first quarter; NA before kickoff. |
| home_team_line_scores_Q2 | integer | Home team points scored in the second quarter; present once any game in the result has reached it. |
| home_team_line_scores_Q3 | integer | Home team points scored in the third quarter; present once any game in the result has reached it. |
| home_team_line_scores_Q4 | integer | Home team points scored in the fourth quarter; present once any game in the result has reached it. |
| home_team_win_probability | double | Home team win probability reported by CFBD; NA while the game is scheduled. |
| away_team_id | integer | CFBD-internal team id for the away team. |
| away_team_name | character | Away team display name including mascot (e.g. Middle Tennessee Blue Raiders). |
| away_team_conference | character | Conference name of the away team. |
| away_team_classification | character | Division classification of the away team: fbs, fcs, ii, ii/iii or iii. |
| away_team_points | integer | Current total points scored by the away team; NA before kickoff. |
| away_team_line_scores_Q1 | integer | Away team points scored in the first quarter; NA before kickoff. |
| away_team_line_scores_Q2 | integer | Away team points scored in the second quarter; present once any game in the result has reached it. |
| away_team_line_scores_Q3 | integer | Away team points scored in the third quarter; present once any game in the result has reached it. |
| away_team_line_scores_Q4 | integer | Away team points scored in the fourth quarter; present once any game in the result has reached it. |
| away_team_win_probability | double | Away team win probability reported by CFBD; NA while the game is scheduled. |
| weather_temperature | double | Temperature at kickoff, in degrees Fahrenheit. |
| weather_description | character | Free-text weather description (e.g. Clear, Light rain). |
| weather_wind_speed | double | Wind speed, in miles per hour. |
| weather_wind_direction | integer | Wind direction, in degrees (0-360, 0 = north). |
| betting_spread | double | Pre-game point spread relative to the home team (negative = home favored). |
| betting_over_under | double | Pre-game over/under (total) line in points. |
| betting_home_moneyline | integer | American-odds moneyline for the home team. |
| betting_away_moneyline | integer | American-odds moneyline for the away team. |

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
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md)

## Examples

``` r
# \donttest{
  try(cfbd_live_scoreboard(division='fbs', conference = "B12"))
#> ── Live Scoreboard information from CollegeFootballData.com ────────────────────
#> ℹ Data updated: 2026-09-30 19:36:41 UTC
#> # A tibble: 7 × 37
#>     game_id start_date  start_time_tbd tv    neutral_site conference_game status
#>       <int> <chr>       <lgl>          <chr> <lgl>        <lgl>           <chr> 
#> 1 401856807 2026-10-03… FALSE          ESPNU FALSE        FALSE           sched…
#> 2 401856819 2026-10-03… FALSE          ESPN2 FALSE        TRUE            sched…
#> 3 401856822 2026-10-03… FALSE          TNT   FALSE        TRUE            sched…
#> 4 401856818 2026-10-03… FALSE          ESPN… FALSE        TRUE            sched…
#> 5 401856821 2026-10-03… FALSE          FOX   FALSE        TRUE            sched…
#> 6 401856817 2026-10-04… FALSE          ESPN  FALSE        TRUE            sched…
#> 7 401856820 2026-10-04… FALSE          FOX   FALSE        TRUE            sched…
#> # ℹ 30 more variables: period <lgl>, clock <lgl>, situation <lgl>,
#> #   possession <lgl>, last_play <lgl>, venue_name <chr>, venue_city <chr>,
#> #   venue_state <chr>, home_team_id <int>, home_team_name <chr>,
#> #   home_team_conference <chr>, home_team_classification <chr>,
#> #   home_team_points <lgl>, home_team_line_scores_Q1 <lgl>,
#> #   home_team_win_probability <lgl>, away_team_id <int>, away_team_name <chr>,
#> #   away_team_conference <chr>, away_team_classification <chr>, …
# }
```
