# **Get game advanced box score information.**

**Get game advanced box score information.**

## Usage

``` r
cfbd_game_box_advanced(game_id, long = FALSE)
```

## Arguments

- game_id:

  (*Integer* required): Game ID filter for querying a single game Can be
  found using the
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  function

- long:

  (*Logical* default `FALSE`): Return the data in a long format.

## Value

A data frame with two rows, one per team, and 69 variables, all double
except `team`. Each CFBD section is matched to the teams by name, in the
team order of its `ppa` section, so every value on a row belongs to that
row's team (CFBD lists `havoc` in the opposite order to the other
sections). From 2025 on, CFBD also sends `passing` and `rushingAdvanced`
sections; they are not returned here – the same data comes from
[`cfbd_passing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_games.md)
and
[`cfbd_rushing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_games.md).
PPA is predicted points added. An empty data frame is returned if the
request fails.

**wide** (`long = FALSE`, the default) - one row per team:

|  |  |  |
|----|----|----|
| col_name | type | description |
| team | character | Team name. |
| ppa_plays | double | Number of plays in the team's PPA sample. |
| ppa_overall_total | double | Average PPA per play, whole game. |
| ppa_overall_quarter1 | double | Average PPA per play, first quarter. |
| ppa_overall_quarter2 | double | Average PPA per play, second quarter. |
| ppa_overall_quarter3 | double | Average PPA per play, third quarter. |
| ppa_overall_quarter4 | double | Average PPA per play, fourth quarter. |
| ppa_passing_total | double | Average PPA per pass play, whole game. |
| ppa_passing_quarter1 | double | Average PPA per pass play, first quarter. |
| ppa_passing_quarter2 | double | Average PPA per pass play, second quarter. |
| ppa_passing_quarter3 | double | Average PPA per pass play, third quarter. |
| ppa_passing_quarter4 | double | Average PPA per pass play, fourth quarter. |
| ppa_rushing_total | double | Average PPA per rush, whole game. |
| ppa_rushing_quarter1 | double | Average PPA per rush, first quarter. |
| ppa_rushing_quarter2 | double | Average PPA per rush, second quarter. |
| ppa_rushing_quarter3 | double | Average PPA per rush, third quarter. |
| ppa_rushing_quarter4 | double | Average PPA per rush, fourth quarter. |
| cumulative_ppa_plays | double | Number of plays in the cumulative PPA sample (same as `ppa_plays`). |
| cumulative_ppa_overall_total | double | Total PPA summed over all plays, whole game. |
| cumulative_ppa_overall_quarter1 | double | Total PPA, first quarter. |
| cumulative_ppa_overall_quarter2 | double | Total PPA, second quarter. |
| cumulative_ppa_overall_quarter3 | double | Total PPA, third quarter. |
| cumulative_ppa_overall_quarter4 | double | Total PPA, fourth quarter. |
| cumulative_ppa_passing_total | double | Total PPA on pass plays, whole game. |
| cumulative_ppa_passing_quarter1 | double | Total PPA on pass plays, first quarter. |
| cumulative_ppa_passing_quarter2 | double | Total PPA on pass plays, second quarter. |
| cumulative_ppa_passing_quarter3 | double | Total PPA on pass plays, third quarter. |
| cumulative_ppa_passing_quarter4 | double | Total PPA on pass plays, fourth quarter. |
| cumulative_ppa_rushing_total | double | Total PPA on rushes, whole game. |
| cumulative_ppa_rushing_quarter1 | double | Total PPA on rushes, first quarter. |
| cumulative_ppa_rushing_quarter2 | double | Total PPA on rushes, second quarter. |
| cumulative_ppa_rushing_quarter3 | double | Total PPA on rushes, third quarter. |
| cumulative_ppa_rushing_quarter4 | double | Total PPA on rushes, fourth quarter. |
| success_rates_overall_total | double | Success rate (proportion 0-1 of plays that were successful), whole game. |
| success_rates_overall_quarter1 | double | Success rate, first quarter; NA when the team had no plays in the quarter. |
| success_rates_overall_quarter2 | double | Success rate, second quarter; NA when the team had no plays in the quarter. |
| success_rates_overall_quarter3 | double | Success rate, third quarter; NA when the team had no plays in the quarter. |
| success_rates_overall_quarter4 | double | Success rate, fourth quarter; NA when the team had no plays in the quarter. |
| success_rates_standard_downs_total | double | Success rate on standard downs, whole game. |
| success_rates_standard_downs_quarter1 | double | Success rate on standard downs, first quarter; NA when there were none. |
| success_rates_standard_downs_quarter2 | double | Success rate on standard downs, second quarter; NA when there were none. |
| success_rates_standard_downs_quarter3 | double | Success rate on standard downs, third quarter; NA when there were none. |
| success_rates_standard_downs_quarter4 | double | Success rate on standard downs, fourth quarter; NA when there were none. |
| success_rates_passing_downs_total | double | Success rate on passing downs, whole game. |
| success_rates_passing_downs_quarter1 | double | Success rate on passing downs, first quarter; NA when there were none. |
| success_rates_passing_downs_quarter2 | double | Success rate on passing downs, second quarter; NA when there were none. |
| success_rates_passing_downs_quarter3 | double | Success rate on passing downs, third quarter; NA when there were none. |
| success_rates_passing_downs_quarter4 | double | Success rate on passing downs, fourth quarter; NA when there were none. |
| explosiveness_overall_total | double | Explosiveness (average PPA on successful plays), whole game. |
| explosiveness_overall_quarter1 | double | Explosiveness, first quarter; NA when the team had no successful plays. |
| explosiveness_overall_quarter2 | double | Explosiveness, second quarter; NA when the team had no successful plays. |
| explosiveness_overall_quarter3 | double | Explosiveness, third quarter; NA when the team had no successful plays. |
| explosiveness_overall_quarter4 | double | Explosiveness, fourth quarter; NA when the team had no successful plays. |
| rushing_power_success | double | Proportion of short-yardage runs (third or fourth down, 2 yards or fewer to go) that gained a first down or touchdown. |
| rushing_stuff_rate | double | Proportion of rushes stopped at or behind the line of scrimmage. |
| rushing_line_yds | double | Total offensive line yards (Football Outsiders line-yards method). |
| rushing_line_yds_avg | double | Offensive line yards per rush. |
| rushing_second_lvl_yds | double | Total second-level yards: rushing yards gained 5 to 10 yards past the line of scrimmage. |
| rushing_second_lvl_yds_avg | double | Second-level yards per rush. |
| rushing_open_field_yds | double | Total open-field yards: rushing yards gained more than 10 yards past the line of scrimmage. |
| rushing_open_field_yds_avg | double | Open-field yards per rush. |
| havoc_total | double | Havoc rate created by the team's defense: proportion of the opponent's plays with a tackle for loss, forced fumble, interception or pass breakup. |
| havoc_front_seven | double | Havoc rate created by the team's front seven (defensive linemen and linebackers). |
| havoc_db | double | Havoc rate created by the team's defensive backs. |
| scoring_opps_opportunities | double | Scoring opportunities: drives with a first down inside the opponent 40. |
| scoring_opps_points | double | Points scored on scoring-opportunity drives. |
| scoring_opps_pts_per_opp | double | Points per scoring opportunity. |
| field_pos_avg_start | double | Average drive start, in yards to the end zone being attacked (70 = own 30). |
| field_pos_avg_starting_predicted_pts | double | Average predicted points of the team's drive starts. |

**long** (`long = TRUE`) - a plain data frame (not `cfbfastR_data`), one
row per statistic in CFBD order:

|  |  |  |
|----|----|----|
| col_name | type | description |
| stat | character | Statistic name, as in the wide columns except that the three rushing averages end in `_yd_avg` (e.g. `rushing_line_yd_avg`), plus one `<section>_team` row per section (e.g. `havoc_team`) naming the team whose values fill `team1` and `team2` for that section. |
| team1 | character | Value for the first team of CFBD's `ppa` section (every section is aligned to it), as text. |
| team2 | character | Value for the second team of CFBD's `ppa` section, as text. |

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
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
  try(cfbd_game_box_advanced(game_id = 401114233))
#> ── Advanced box score data from CollegeFootballData.com ────────────────────────
#> ℹ Data updated: 2026-09-30 09:39:54 UTC
#> # A tibble: 2 × 69
#>   team     ppa_plays ppa_overall_total ppa_overall_quarter1 ppa_overall_quarter2
#>   <chr>        <dbl>             <dbl>                <dbl>                <dbl>
#> 1 Eastern…        45            -0.272               -0.745                0.122
#> 2 Washing…        56             0.999                1.08                 0.741
#> # ℹ 64 more variables: ppa_overall_quarter3 <dbl>, ppa_overall_quarter4 <dbl>,
#> #   ppa_passing_total <dbl>, ppa_passing_quarter1 <dbl>,
#> #   ppa_passing_quarter2 <dbl>, ppa_passing_quarter3 <dbl>,
#> #   ppa_passing_quarter4 <dbl>, ppa_rushing_total <dbl>,
#> #   ppa_rushing_quarter1 <dbl>, ppa_rushing_quarter2 <dbl>,
#> #   ppa_rushing_quarter3 <dbl>, ppa_rushing_quarter4 <dbl>,
#> #   cumulative_ppa_plays <dbl>, cumulative_ppa_overall_total <dbl>, …
# }
```
