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

|                          |           |
|--------------------------|-----------|
| col_name                 | types     |
| game_id                  | integer   |
| start_date               | character |
| start_time_tbd           | logical   |
| tv                       | character |
| neutral_site             | logical   |
| conference_game          | logical   |
| status                   | character |
| period                   | integer   |
| clock                    | character |
| situation                | character |
| possession               | character |
| last_play                | character |
| venue_name               | character |
| venue_city               | character |
| venue_state              | character |
| home_team_id             | integer   |
| home_team_name           | character |
| home_team_conference     | character |
| home_team_classification | character |
| home_team_points         | integer   |
| home_team_line_scores_Q1 | integer   |
| home_team_line_scores_Q2 | integer   |
| home_team_line_scores_Q3 | integer   |
| home_team_line_scores_Q4 | integer   |
| away_team_id             | integer   |
| away_team_name           | character |
| away_team_conference     | character |
| away_team_classification | character |
| away_team_points         | integer   |
| away_team_line_scores_Q1 | integer   |
| away_team_line_scores_Q2 | integer   |
| away_team_line_scores_Q3 | integer   |
| away_team_line_scores_Q4 | integer   |
| weather_temperature      | numeric   |
| weather_description      | character |
| weather_wind_speed       | numeric   |
| weather_wind_direction   | integer   |
| betting_spread           | numeric   |
| betting_over_under       | numeric   |
| betting_home_moneyline   | integer   |
| betting_away_moneyline   | integer   |

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
#> ── Live Scoreboard information from CollegeFootballData.com ── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:39 UTC
#> # A tibble: 8 × 45
#>     game_id start_date  start_time_tbd tv    neutral_site conference_game status
#>       <int> <chr>       <lgl>          <chr> <lgl>        <lgl>           <chr> 
#> 1 401769071 2026-01-01… FALSE          ESPN  TRUE         FALSE           compl…
#> 2 401778319 2025-12-27… FALSE          ABC   TRUE         FALSE           compl…
#> 3 401778323 2025-12-28… FALSE          ESPN  TRUE         FALSE           compl…
#> 4 401778327 2025-12-31… FALSE          ESPN  TRUE         FALSE           compl…
#> 5 401778329 2025-12-31… FALSE          CBS   TRUE         FALSE           compl…
#> 6 401778331 2025-12-31… FALSE          ESPN  TRUE         FALSE           compl…
#> 7 401778333 2026-01-02… FALSE          ESPN  TRUE         FALSE           compl…
#> 8 401831583 2026-01-03… FALSE          FOX   TRUE         FALSE           compl…
#> # ℹ 38 more variables: period <lgl>, clock <lgl>, situation <chr>,
#> #   possession <chr>, last_play <chr>, venue_name <chr>, venue_city <chr>,
#> #   venue_state <chr>, home_team_id <int>, home_team_name <chr>,
#> #   home_team_conference <chr>, home_team_classification <chr>,
#> #   home_team_points <int>, home_team_line_scores_Q1 <int>,
#> #   home_team_line_scores_Q2 <int>, home_team_line_scores_Q3 <int>,
#> #   home_team_line_scores_Q4 <int>, home_team_line_scores_Q5 <int>, …
# }
```
