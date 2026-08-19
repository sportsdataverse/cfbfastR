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

`cfbd_game_box_advanced()` - A data frame with 2 rows and 69 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| team | character | Team name. |
| plays | numeric | Number of plays. |
| ppa_overall_total | numeric | Predicted points added (PPA) overall total. |
| ppa_overall_quarter1 | numeric | Predicted points added (PPA) overall Q1. |
| ppa_overall_quarter2 | numeric | Predicted points added (PPA) overall Q2. |
| ppa_overall_quarter3 | numeric | Predicted points added (PPA) overall Q3. |
| ppa_overall_quarter4 | numeric | Predicted points added (PPA) overall Q4. |
| ppa_passing_total | numeric | Passing predicted points added (PPA) total. |
| ppa_passing_quarter1 | numeric | Passing predicted points added (PPA) Q1. |
| ppa_passing_quarter2 | numeric | Passing predicted points added (PPA) Q2. |
| ppa_passing_quarter3 | numeric | Passing predicted points added (PPA) Q3. |
| ppa_passing_quarter4 | numeric | Passing predicted points added (PPA) Q4. |
| ppa_rushing_total | numeric | Rushing predicted points added (PPA) total. |
| ppa_rushing_quarter1 | numeric | Rushing predicted points added (PPA) Q1. |
| ppa_rushing_quarter2 | numeric | Rushing predicted points added (PPA) Q2. |
| ppa_rushing_quarter3 | numeric | Rushing predicted points added (PPA) Q3. |
| ppa_rushing_quarter4 | numeric | Rushing predicted points added (PPA) Q4. |
| cumulative_ppa_plays | numeric | Cumulative predicted points added (PPA) added total. |
| cumulative_ppa_overall_total | numeric | Cumulative predicted points added (PPA) total. |
| cumulative_ppa_overall_quarter1 | numeric | Cumulative predicted points added (PPA) Q1. |
| cumulative_ppa_overall_quarter2 | numeric | Cumulative predicted points added (PPA) Q2. |
| cumulative_ppa_overall_quarter3 | numeric | Cumulative predicted points added (PPA) Q3. |
| cumulative_ppa_overall_quarter4 | numeric | Cumulative predicted points added (PPA) Q4. |
| cumulative_ppa_passing_total | numeric | Cumulative passing predicted points added (PPA) total. |
| cumulative_ppa_passing_quarter1 | numeric | Cumulative passing predicted points added (PPA) Q1. |
| cumulative_ppa_passing_quarter2 | numeric | Cumulative passing predicted points added (PPA) Q2. |
| cumulative_ppa_passing_quarter3 | numeric | Cumulative passing predicted points added (PPA) Q3. |
| cumulative_ppa_passing_quarter4 | numeric | Cumulative passing predicted points added (PPA) Q4. |
| cumulative_ppa_rushing_total | numeric | Cumulative rushing predicted points added (PPA) total. |
| cumulative_ppa_rushing_quarter1 | numeric | Cumulative rushing predicted points added (PPA) Q1. |
| cumulative_ppa_rushing_quarter2 | numeric | Cumulative rushing predicted points added (PPA) Q2. |
| cumulative_ppa_rushing_quarter3 | numeric | Cumulative rushing predicted points added (PPA) Q3. |
| cumulative_ppa_rushing_quarter4 | numeric | Cumulative rushing predicted points added (PPA) Q4. |
| success_rates_overall_total | numeric | Success rates overall total. |
| success_rates_overall_quarter1 | numeric | Success rates overall Q1. |
| success_rates_overall_quarter2 | numeric | Success rates overall Q2. |
| success_rates_overall_quarter3 | numeric | Success rates overall Q3. |
| success_rates_overall_quarter4 | numeric | Success rates overall Q4. |
| success_rates_standard_downs_total | numeric | Success rates standard downs total. |
| success_rates_standard_downs_quarter1 | numeric | Success rates standard downs Q1. |
| success_rates_standard_downs_quarter2 | numeric | Success rates standard downs Q2. |
| success_rates_standard_downs_quarter3 | numeric | Success rates standard downs Q3. |
| success_rates_standard_downs_quarter4 | numeric | Success rates standard downs Q4. |
| success_rates_passing_downs_total | numeric | Success rates passing downs total. |
| success_rates_passing_downs_quarter1 | numeric | Success rates passing downs Q1. |
| success_rates_passing_downs_quarter2 | numeric | Success rates passing downs Q2. |
| success_rates_passing_downs_quarter3 | numeric | Success rates passing downs Q3. |
| success_rates_passing_downs_quarter4 | numeric | Success rates passing downs Q4. |
| explosiveness_overall_total | numeric | Explosiveness rates overall total. |
| explosiveness_overall_quarter1 | numeric | Explosiveness rates overall Q1. |
| explosiveness_overall_quarter2 | numeric | Explosiveness rates overall Q2. |
| explosiveness_overall_quarter3 | numeric | Explosiveness rates overall Q3. |
| explosiveness_overall_quarter4 | numeric | Explosiveness rates overall Q4. |
| rushing_power_success | numeric | Rushing power success rate. |
| rushing_stuff_rate | numeric | Rushing stuff rate. |
| rushing_line_yds | numeric | Rushing offensive line yards. |
| rushing_line_yds_avg | numeric | Rushing line yards average. |
| rushing_second_lvl_yds | numeric | Rushing second-level yards. |
| rushing_second_lvl_yds_avg | numeric | Average second level yards per rush. |
| rushing_open_field_yds | numeric | Rushing open field yards. |
| rushing_open_field_yds_avg | numeric | Average rushing open field yards average. |
| havoc_total | numeric | Total havoc rate. |
| havoc_front_seven | numeric | Front-7 players havoc rate. |
| havoc_db | numeric | Defensive back players havoc rate. |
| scoring_opps_opportunities | numeric | Number of scoring opportunities. |
| scoring_opps_points | numeric | Points on scoring opportunity drives. |
| scoring_opps_pts_per_opp | numeric | Points per scoring opportunity drives. |
| field_pos_avg_start | numeric | Average starting field position. |
| field_pos_avg_starting_predicted_pts | numeric | Average starting predicted points (PP) for the average starting field position. |

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_box_advanced(game_id = 401114233))
#> ── Advanced box score data from CollegeFootballData.com ────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 17:52:13 UTC
#> # A tibble: 2 × 69
#>   team     ppa_plays ppa_overall_total ppa_overall_quarter1 ppa_overall_quarter2
#>   <chr>        <dbl>             <dbl>                <dbl>                <dbl>
#> 1 Eastern…        45            -0.201               -0.569                0.122
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
