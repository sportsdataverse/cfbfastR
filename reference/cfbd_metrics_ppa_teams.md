# **Get team averages for predicted points added (PPA)**

**Get team averages for predicted points added (PPA)**

## Usage

``` r
cfbd_metrics_ppa_teams(
  year = NULL,
  team = NULL,
  conference = NULL,
  excl_garbage_time = FALSE
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). Required if team
  not provided

- team:

  (*String* optional): D-I Team. Required if year not provided

- conference:

  (*String* optional): Conference name - select a valid FBS conference
  Conference names P5: ACC, Big 12, Big Ten, SEC, Pac-12 Conference
  names G5 and FBS Independents: Conference USA, Mid-American, Mountain
  West, FBS Independents, American Athletic

- excl_garbage_time:

  (*Logical* default FALSE): Select whether to exclude Garbage Time
  (TRUE or FALSE)

## Value

`cfbd_metrics_ppa_teams()` - A data frame with 21 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Four-digit season year. |
| conference | character | Team conference name. |
| team | character | Team name. |
| off_overall | numeric | Offense overall predicted points added (PPA). |
| off_passing | numeric | Offense passing predicted points added (PPA). |
| off_rushing | numeric | Offense rushing predicted points added (PPA). |
| off_first_down | numeric | Offense 1st down predicted points added (PPA). |
| off_second_down | numeric | Offense 2nd down predicted points added (PPA). |
| off_third_down | numeric | Offense 3rd down predicted points added (PPA). |
| off_cumulative_total | numeric | Offense cumulative total predicted points added (PPA). |
| off_cumulative_passing | numeric | Offense cumulative total passing predicted points added (PPA). |
| off_cumulative_rushing | numeric | Offense cumulative total rushing predicted points added (PPA). |
| def_overall | numeric | Defense overall predicted points added (PPA). |
| def_passing | numeric | Defense passing predicted points added (PPA). |
| def_rushing | numeric | Defense rushing predicted points added (PPA). |
| def_first_down | numeric | Defense 1st down predicted points added (PPA). |
| def_second_down | numeric | Defense 2nd down predicted points added (PPA). |
| def_third_down | numeric | Defense 3rd down predicted points added (PPA). |
| def_cumulative_total | numeric | Defense cumulative total predicted points added (PPA). |
| def_cumulative_passing | numeric | Defense cumulative total passing predicted points added (PPA). |
| def_cumulative_rushing | numeric | Defense cumulative total rushing predicted points added (PPA). |

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md),
[`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.md),
[`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md),
[`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md),
[`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md),
[`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md),
[`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_ppa_teams(year = 2019, team = "TCU"))
#> ── Team PPA data from CollegeFootballData.com ──────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 03:12:37 UTC
#> # A tibble: 1 × 21
#>   season conference team  off_overall off_passing off_rushing off_first_down
#>    <int> <chr>      <chr>       <dbl>       <dbl>       <dbl>          <dbl>
#> 1   2019 Big 12     TCU          0.13        0.06        0.23           0.01
#> # ℹ 14 more variables: off_second_down <dbl>, off_third_down <dbl>,
#> #   off_cumulative_total <dbl>, off_cumulative_passing <dbl>,
#> #   off_cumulative_rushing <dbl>, def_overall <dbl>, def_passing <dbl>,
#> #   def_rushing <dbl>, def_first_down <dbl>, def_second_down <dbl>,
#> #   def_third_down <dbl>, def_cumulative_total <dbl>,
#> #   def_cumulative_passing <int>, def_cumulative_rushing <dbl>
# }
```
