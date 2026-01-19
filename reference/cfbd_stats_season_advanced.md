# **Get season advanced statistics by team**

**Get season advanced statistics by team**

## Usage

``` r
cfbd_stats_season_advanced(
  year,
  team = NULL,
  excl_garbage_time = FALSE,
  start_week = NULL,
  end_week = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)

- team:

  (*String* optional): D-I Team

- excl_garbage_time:

  (*Logical* default FALSE): Select whether to exclude Garbage Time
  (TRUE/FALSE)

- start_week:

  (*Integer* optional): Starting Week - values range from 1-15, 1-14 for
  seasons pre-playoff, i.e. 2013 or earlier

- end_week:

  (*Integer* optional): Ending Week - values range from 1-15, 1-14 for
  seasons pre-playoff, i.e. 2013 or earlier

## Value

`cfbd_stats_season_advanced()` - A data frame with 82 variables:

- `season`: integer.:

  Season of the statistics.

- `team`: character.:

  Team name.

- `conference`: character.:

  Conference of the team.

- `off_plays`: integer.:

  Offense plays in the game.

- `off_drives`: integer.:

  Offense drives in the game.

- `off_ppa`: double.:

  Offense predicted points added (PPA).

- `off_total_ppa`: double.:

  Offense total predicted points added (PPA).

- `off_success_rate`: double.:

  Offense success rate.

- `off_explosiveness`: double.:

  Offense explosiveness rate.

- `off_power_success`: double.:

  Offense power success rate.

- `off_stuff_rate`: double.:

  Offense rushing stuff rate.

- `off_line_yds`: double.:

  Offensive line yards.

- `off_line_yds_total`: integer.:

  Offensive line yards total.

- `off_second_lvl_yds`: double.:

  Offense second-level yards.

- `off_second_lvl_yds_total`: integer.:

  Offense second-level yards total.

- `off_open_field_yds`: integer.:

  Offense open field yards.

- `off_open_field_yds_total`: integer.:

  Offense open field yards total.

- `off_total_opportunities`: integer.:

  Offense opportunities.

- `off_pts_per_opp`: double.:

  Offense points per scoring opportunity.

- `off_field_pos_avg_start`: double.:

  Offense starting average field position.

- `off_field_pos_avg_predicted_points`: double.:

  Offense starting average field position predicted points (PP).

- `off_havoc_total`: double.:

  Offense havoc rate total.

- `off_havoc_front_seven`: double.:

  Offense front-7 havoc rate.

- `off_havoc_db`: double.:

  Offense defensive back havoc rate.

- `off_standard_downs_rate`: double.:

  Offense standard downs rate.

- `off_standard_downs_ppa`: double.:

  Offense standard downs predicted points added (PPA).

- `off_standard_downs_success_rate`: double.:

  Offense standard downs success rate.

- `off_standard_downs_explosiveness`: double.:

  Offense standard downs explosiveness rate.

- `off_passing_downs_rate`: double.:

  Offense passing downs rate.

- `off_passing_downs_ppa`: double.:

  Offense passing downs predicted points added (PPA).

- `off_passing_downs_success_rate`: double.:

  Offense passing downs success rate.

- `off_passing_downs_explosiveness`: double.:

  Offense passing downs explosiveness rate.

- `off_rushing_plays_rate`: double.:

  Offense rushing plays rate.

- `off_rushing_plays_ppa`: double.:

  Offense rushing plays predicted points added (PPA).

- `off_rushing_plays_total_ppa`: double.:

  Offense rushing plays total predicted points added (PPA).

- `off_rushing_plays_success_rate`: double.:

  Offense rushing plays success rate.

- `off_rushing_plays_explosiveness`: double.:

  Offense rushing plays explosiveness rate.

- `off_passing_plays_rate`: double.:

  Offense passing plays rate.

- `off_passing_plays_ppa`: double.:

  Offense passing plays predicted points added (PPA).

- `off_passing_plays_total_ppa`: double.:

  Offense passing plays total predicted points added (PPA).

- `off_passing_plays_success_rate`: double.:

  Offense passing plays success rate.

- `off_passing_plays_explosiveness`: double.:

  Offense passing plays explosiveness rate.

- `def_plays`: integer.:

  Defense plays in the game.

- `def_drives`: integer.:

  Defense drives in the game.

- `def_ppa`: double.:

  Defense predicted points added (PPA).

- `def_total_ppa`: double.:

  Defense total predicted points added (PPA).

- `def_success_rate`: double.:

  Defense success rate.

- `def_explosiveness`: double.:

  Defense explosiveness rate.

- `def_power_success`: double.:

  Defense power success rate.

- `def_stuff_rate`: double.:

  Defense rushing stuff rate.

- `def_line_yds`: double.:

  Defense Offensive line yards allowed.

- `def_line_yds_total`: integer.:

  Defense Offensive line yards total allowed.

- `def_second_lvl_yds`: double.:

  Defense second-level yards.

- `def_second_lvl_yds_total`: integer.:

  Defense second-level yards total.

- `def_open_field_yds`: integer.:

  Defense open field yards.

- `def_open_field_yds_total`: integer.:

  Defense open field yards total.

- `def_total_opportunities`: integer.:

  Defense opportunities.

- `def_pts_per_opp`: double.:

  Defense points per scoring opportunity.

- `def_field_pos_avg_start`: double.:

  Defense starting average field position.

- `def_field_pos_avg_predicted_points`: double.:

  Defense starting average field position predicted points (PP).

- `def_havoc_total`: double.:

  Defense havoc rate total.

- `def_havoc_front_seven`: double.:

  Defense front-7 havoc rate.

- `def_havoc_db`: double.:

  Defense defensive back havoc rate.

- `def_standard_downs_rate`: double.:

  Defense standard downs rate.

- `def_standard_downs_ppa`: double.:

  Defense standard downs predicted points added (PPA).

- `def_standard_downs_success_rate`: double.:

  Defense standard downs success rate.

- `def_standard_downs_explosiveness`: double.:

  Defense standard downs explosiveness rate.

- `def_passing_downs_rate`: double.:

  Defense passing downs rate.

- `def_passing_downs_ppa`: double.:

  Defense passing downs predicted points added (PPA).

- `def_passing_downs_success_rate`: double.:

  Defense passing downs success rate.

- `def_passing_downs_explosiveness`: double.:

  Defense passing downs explosiveness rate.

- `def_rushing_plays_rate`: double.:

  Defense rushing plays rate.

- `def_rushing_plays_ppa`: double.:

  Defense rushing plays predicted points added (PPA).

- `def_rushing_plays_total_ppa`: double.:

  Defense rushing plays total predicted points added (PPA).

- `def_rushing_plays_success_rate`: double.:

  Defense rushing plays success rate.

- `def_rushing_plays_explosiveness`: double.:

  Defense rushing plays explosiveness rate.

- `def_passing_plays_rate`: double.:

  Defense passing plays rate.

- `def_passing_plays_ppa`: double.:

  Defense passing plays predicted points added (PPA).

- `def_passing_plays_total_ppa`: double.:

  Defense passing plays total predicted points added (PPA).

- `def_passing_plays_success_rate`: double.:

  Defense passing plays success rate.

- `def_passing_plays_explosiveness`: double.:

  Defense passing plays explosiveness rate.

## See also

Other CFBD Stats:
[`cfbd_stats_categories()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_categories.md),
[`cfbd_stats_game_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.md),
[`cfbd_stats_season_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.md),
[`cfbd_stats_season_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_team.md)

## Examples

``` r
# \donttest{
   try(cfbd_stats_season_advanced(2019, team = "LSU"))
#> ── Advanced season stats from CollegeFootballData.com ──────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:22:49 UTC
#> # A tibble: 1 × 82
#>   season team  conference off_plays off_drives off_ppa off_total_ppa
#>    <int> <chr> <chr>          <int>      <int>   <dbl>         <dbl>
#> 1   2019 LSU   SEC             1095        197   0.414          453.
#> # ℹ 75 more variables: off_success_rate <dbl>, off_explosiveness <dbl>,
#> #   off_power_success <dbl>, off_stuff_rate <dbl>, off_line_yds <dbl>,
#> #   off_line_yds_total <int>, off_second_lvl_yds <dbl>,
#> #   off_second_lvl_yds_total <int>, off_open_field_yds <dbl>,
#> #   off_open_field_yds_total <int>, off_total_opportunities <int>,
#> #   off_pts_per_opp <dbl>, off_field_pos_avg_start <dbl>,
#> #   off_field_pos_avg_predicted_points <dbl>, off_havoc_total <dbl>, …
# }
```
