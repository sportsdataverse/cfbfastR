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

- `team`: character.:

  Team name.

- `plays`: double.:

  Number of plays.

- `ppa_overall_total`: double.:

  Predicted points added (PPA) overall total.

- `ppa_overall_quarter1`: double.:

  Predicted points added (PPA) overall Q1.

- `ppa_overall_quarter2`: double.:

  Predicted points added (PPA) overall Q2.

- `ppa_overall_quarter3`: double.:

  Predicted points added (PPA) overall Q3.

- `ppa_overall_quarter4`: double.:

  Predicted points added (PPA) overall Q4.

- `ppa_passing_total`: double.:

  Passing predicted points added (PPA) total.

- `ppa_passing_quarter1`: double.:

  Passing predicted points added (PPA) Q1.

- `ppa_passing_quarter2`: double.:

  Passing predicted points added (PPA) Q2.

- `ppa_passing_quarter3`: double.:

  Passing predicted points added (PPA) Q3.

- `ppa_passing_quarter4`: double.:

  Passing predicted points added (PPA) Q4.

- `ppa_rushing_total`: double.:

  Rushing predicted points added (PPA) total.

- `ppa_rushing_quarter1`: double.:

  Rushing predicted points added (PPA) Q1.

- `ppa_rushing_quarter2`: double.:

  Rushing predicted points added (PPA) Q2.

- `ppa_rushing_quarter3`: double.:

  Rushing predicted points added (PPA) Q3.

- `ppa_rushing_quarter4`: double.:

  Rushing predicted points added (PPA) Q4.

- `cumulative_ppa_plays`: double.:

  Cumulative predicted points added (PPA) added total.

- `cumulative_ppa_overall_total`: double.:

  Cumulative predicted points added (PPA) total.

- `cumulative_ppa_overall_quarter1`: double.:

  Cumulative predicted points added (PPA) Q1.

- `cumulative_ppa_overall_quarter2`: double.:

  Cumulative predicted points added (PPA) Q2.

- `cumulative_ppa_overall_quarter3`: double.:

  Cumulative predicted points added (PPA) Q3.

- `cumulative_ppa_overall_quarter4`: double.:

  Cumulative predicted points added (PPA) Q4.

- `cumulative_ppa_passing_total`: double.:

  Cumulative passing predicted points added (PPA) total.

- `cumulative_ppa_passing_quarter1`: double.:

  Cumulative passing predicted points added (PPA) Q1.

- `cumulative_ppa_passing_quarter2`: double.:

  Cumulative passing predicted points added (PPA) Q2.

- `cumulative_ppa_passing_quarter3`: double.:

  Cumulative passing predicted points added (PPA) Q3.

- `cumulative_ppa_passing_quarter4`: double.:

  Cumulative passing predicted points added (PPA) Q4.

- `cumulative_ppa_rushing_total`: double.:

  Cumulative rushing predicted points added (PPA) total.

- `cumulative_ppa_rushing_quarter1`: double.:

  Cumulative rushing predicted points added (PPA) Q1.

- `cumulative_ppa_rushing_quarter2`: double.:

  Cumulative rushing predicted points added (PPA) Q2.

- `cumulative_ppa_rushing_quarter3`: double.:

  Cumulative rushing predicted points added (PPA) Q3.

- `cumulative_ppa_rushing_quarter4`: double.:

  Cumulative rushing predicted points added (PPA) Q4.

- `success_rates_overall_total`: double.:

  Success rates overall total.

- `success_rates_overall_quarter1`: double.:

  Success rates overall Q1.

- `success_rates_overall_quarter2`: double.:

  Success rates overall Q2.

- `success_rates_overall_quarter3`: double.:

  Success rates overall Q3.

- `success_rates_overall_quarter4`: double.:

  Success rates overall Q4.

- `success_rates_standard_downs_total`: double.:

  Success rates standard downs total.

- `success_rates_standard_downs_quarter1`: double.:

  Success rates standard downs Q1.

- `success_rates_standard_downs_quarter2`: double.:

  Success rates standard downs Q2.

- `success_rates_standard_downs_quarter3`: double.:

  Success rates standard downs Q3.

- `success_rates_standard_downs_quarter4`: double.:

  Success rates standard downs Q4.

- `success_rates_passing_downs_total`: double.:

  Success rates passing downs total.

- `success_rates_passing_downs_quarter1`: double.:

  Success rates passing downs Q1.

- `success_rates_passing_downs_quarter2`: double.:

  Success rates passing downs Q2.

- `success_rates_passing_downs_quarter3`: double.:

  Success rates passing downs Q3.

- `success_rates_passing_downs_quarter4`: double.:

  Success rates passing downs Q4.

- `explosiveness_overall_total`: double.:

  Explosiveness rates overall total.

- `explosiveness_overall_quarter1`: double.:

  Explosiveness rates overall Q1.

- `explosiveness_overall_quarter2`: double.:

  Explosiveness rates overall Q2.

- `explosiveness_overall_quarter3`: double.:

  Explosiveness rates overall Q3.

- `explosiveness_overall_quarter4`: double.:

  Explosiveness rates overall Q4.

- `rushing_power_success`: double.:

  Rushing power success rate.

- `rushing_stuff_rate`: double.:

  Rushing stuff rate.

- `rushing_line_yds`: double.:

  Rushing offensive line yards.

- `rushing_line_yds_avg`: double.:

  Rushing line yards average.

- `rushing_second_lvl_yds`: double.:

  Rushing second-level yards.

- `rushing_second_lvl_yds_avg`: double.:

  Average second level yards per rush.

- `rushing_open_field_yds`: double.:

  Rushing open field yards.

- `rushing_open_field_yds_avg`: double.:

  Average rushing open field yards average.

- `havoc_total`: double.:

  Total havoc rate.

- `havoc_front_seven`: double.:

  Front-7 players havoc rate.

- `havoc_db`: double.:

  Defensive back players havoc rate.

- `scoring_opps_opportunities`: double.:

  Number of scoring opportunities.

- `scoring_opps_points`: double.:

  Points on scoring opportunity drives.

- `scoring_opps_pts_per_opp`: double.:

  Points per scoring opportunity drives.

- `field_pos_avg_start`: double.:

  Average starting field position.

- `field_pos_avg_starting_predicted_pts`: double.:

  Average starting predicted points (PP) for the average starting field
  position.

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
#> ── Advanced box score data from CollegeFootballData.com ────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:33 UTC
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
