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

`cfbd_live_scoreboard()` - A data frame with 41 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | integer | CFBD-internal game id; join key to other CFBD endpoints. |
| start_date | character | Scheduled kickoff timestamp (ISO 8601, UTC). |
| start_time_tbd | logical | TRUE if the scheduled kickoff time is still to be determined. |
| tv | character | Television network broadcasting the game (e.g. "ESPN", "ABC"). |
| neutral_site | logical | TRUE if the game is being played at a neutral site. |
| conference_game | logical | TRUE if both teams are in the same conference. |
| status | character | Game status (e.g. "scheduled", "in_progress", "completed"). |
| period | integer | Current period/quarter number (1-4, 5+ for overtime). |
| clock | character | Game clock display as "MM:SS" remaining in the current period. |
| situation | character | Free-text down-and-distance / field-position summary for the current play. |
| possession | character | Abbreviation of the team currently in possession. |
| last_play | character | Free-text description of the most recent play. |
| venue_name | character | Stadium / venue name. |
| venue_city | character | City where the venue is located. |
| venue_state | character | State (or province/country) where the venue is located. |
| home_team_id | integer | CFBD-internal team id for the home team. |
| home_team_name | character | Full home team name (e.g. "Georgia"). |
| home_team_conference | character | Conference name of the home team. |
| home_team_classification | character | Division classification of the home team (fbs/fcs/ii/iii). |
| home_team_points | integer | Current total points scored by the home team. |
| home_team_line_scores_Q1 | integer | Home team points scored in the first quarter. |
| home_team_line_scores_Q2 | integer | Home team points scored in the second quarter. |
| home_team_line_scores_Q3 | integer | Home team points scored in the third quarter. |
| home_team_line_scores_Q4 | integer | Home team points scored in the fourth quarter. |
| away_team_id | integer | CFBD-internal team id for the away team. |
| away_team_name | character | Full away team name (e.g. "Auburn"). |
| away_team_conference | character | Conference name of the away team. |
| away_team_classification | character | Division classification of the away team (fbs/fcs/ii/iii). |
| away_team_points | integer | Current total points scored by the away team. |
| away_team_line_scores_Q1 | integer | Away team points scored in the first quarter. |
| away_team_line_scores_Q2 | integer | Away team points scored in the second quarter. |
| away_team_line_scores_Q3 | integer | Away team points scored in the third quarter. |
| away_team_line_scores_Q4 | integer | Away team points scored in the fourth quarter. |
| weather_temperature | numeric | Temperature at kickoff, in degrees Fahrenheit. |
| weather_description | character | Free-text weather description (e.g. "Clear", "Light rain"). |
| weather_wind_speed | numeric | Wind speed, in miles per hour. |
| weather_wind_direction | integer | Wind direction, in degrees (0-360, 0 = north). |
| betting_spread | numeric | Pre-game point spread relative to the home team (negative = home favored). |
| betting_over_under | numeric | Pre-game over/under (total) line in points. |
| betting_home_moneyline | integer | American-odds moneyline for the home team. |
| betting_away_moneyline | integer | American-odds moneyline for the away team. |

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md)

## Examples

``` r
# \donttest{
  try(cfbd_live_scoreboard(division='fbs', conference = "B12"))
#> ── Live Scoreboard information from CollegeFootballData.com ── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 14:16:26 UTC
#> # A tibble: 120 × 37
#>      game_id start_date start_time_tbd tv    neutral_site conference_game status
#>        <int> <chr>      <lgl>          <chr> <lgl>        <lgl>           <chr> 
#>  1 401856636 2026-09-0… FALSE          ABC   TRUE         FALSE           sched…
#>  2 401856670 2026-09-1… TRUE           NA    FALSE        FALSE           sched…
#>  3 401856678 2026-09-1… TRUE           NA    FALSE        FALSE           sched…
#>  4 401856683 2026-09-1… TRUE           NA    FALSE        FALSE           sched…
#>  5 401856766 2026-08-2… FALSE          ESPN  TRUE         FALSE           sched…
#>  6 401856767 2026-09-0… TRUE           NA    FALSE        FALSE           sched…
#>  7 401856768 2026-09-0… TRUE           NA    FALSE        FALSE           sched…
#>  8 401856769 2026-09-0… TRUE           NA    FALSE        FALSE           sched…
#>  9 401856770 2026-09-0… TRUE           NA    FALSE        FALSE           sched…
#> 10 401856771 2026-09-0… TRUE           NA    FALSE        FALSE           sched…
#> # ℹ 110 more rows
#> # ℹ 30 more variables: period <lgl>, clock <lgl>, situation <lgl>,
#> #   possession <lgl>, last_play <lgl>, venue_name <chr>, venue_city <chr>,
#> #   venue_state <chr>, home_team_id <int>, home_team_name <chr>,
#> #   home_team_conference <chr>, home_team_classification <chr>,
#> #   home_team_points <lgl>, home_team_line_scores_Q1 <lgl>,
#> #   home_team_win_probability <lgl>, away_team_id <int>, …
# }
```
