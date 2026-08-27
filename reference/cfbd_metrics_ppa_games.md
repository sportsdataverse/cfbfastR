# **Get team game averages for predicted points added (PPA)**

**Get team game averages for predicted points added (PPA)**

## Usage

``` r
cfbd_metrics_ppa_games(
  year,
  week = NULL,
  season_type = "both",
  team = NULL,
  conference = NULL,
  excl_garbage_time = FALSE,
  division = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2001

- week:

  (*Integer* optional): Week - values range from 1-15, 1-14 for seasons
  pre-playoff, i.e. 2013 or earlier

- season_type:

  (*String* default both): Season type - regular, postseason, both,
  allstar, spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- excl_garbage_time:

  (*Logical* default FALSE): Select whether to exclude Garbage Time
  (TRUE or FALSE)

- division:

  (*String* optional): Division/classification filter – one of `fbs`,
  `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.

## Value

`cfbd_metrics_ppa_games()` - A data frame with 19 variables:

|                 |           |                                                |
|-----------------|-----------|------------------------------------------------|
| col_name        | types     | description                                    |
| game_id         | integer   | Referencing game id.                           |
| season          | integer   | Season of the game.                            |
| week            | integer   | Game week of the season.                       |
| season_type     | character | Season type (regular, postseason, etc.).       |
| conference      | character | Conference of the team.                        |
| team            | character | Team name.                                     |
| opponent        | character | Team opponent name.                            |
| off_overall     | numeric   | Offense overall predicted points added (PPA).  |
| off_passing     | numeric   | Offense passing predicted points added (PPA).  |
| off_rushing     | numeric   | Offense rushing predicted points added (PPA).  |
| off_first_down  | numeric   | Offense 1st down predicted points added (PPA). |
| off_second_down | numeric   | Offense 2nd down predicted points added (PPA). |
| off_third_down  | numeric   | Offense 3rd down predicted points added (PPA). |
| def_overall     | numeric   | Defense overall predicted points added (PPA).  |
| def_passing     | numeric   | Defense passing predicted points added (PPA).  |
| def_rushing     | numeric   | Defense rushing predicted points added (PPA).  |
| def_first_down  | numeric   | Defense 1st down predicted points added (PPA). |
| def_second_down | numeric   | Defense 2nd down predicted points added (PPA). |
| def_third_down  | numeric   | Defense 3rd down predicted points added (PPA). |

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md),
[`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.md),
[`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.md),
[`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md),
[`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md),
[`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md),
[`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md),
[`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_ppa_games(year = 2019, team = "TCU"))
#> ── PPA data from CollegeFootballData.com ───────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 20:22:39 UTC
#> # A tibble: 12 × 19
#>      game_id season  week season_type team  conference opponent      off_overall
#>        <int>  <int> <int> <chr>       <chr> <chr>      <chr>               <dbl>
#>  1 401112129   2019     1 regular     TCU   Big 12     Arkansas-Pin…        0.07
#>  2 401112130   2019     3 regular     TCU   Big 12     Purdue               0.08
#>  3 401112131   2019     4 regular     TCU   Big 12     SMU                  0.13
#>  4 401112100   2019     5 regular     TCU   Big 12     Kansas               0.39
#>  5 401112088   2019     6 regular     TCU   Big 12     Iowa State           0.23
#>  6 401112109   2019     8 regular     TCU   Big 12     Kansas State         0.16
#>  7 401112132   2019     9 regular     TCU   Big 12     Texas                0.21
#>  8 401112127   2019    10 regular     TCU   Big 12     Oklahoma Sta…        0.12
#>  9 401112081   2019    11 regular     TCU   Big 12     Baylor              -0.06
#> 10 401112133   2019    12 regular     TCU   Big 12     Texas Tech           0.2 
#> 11 401112120   2019    13 regular     TCU   Big 12     Oklahoma            -0.03
#> 12 401112134   2019    14 regular     TCU   Big 12     West Virginia        0.01
#> # ℹ 11 more variables: off_passing <dbl>, off_rushing <dbl>,
#> #   off_first_down <dbl>, off_second_down <dbl>, off_third_down <dbl>,
#> #   def_overall <dbl>, def_passing <dbl>, def_rushing <dbl>,
#> #   def_first_down <dbl>, def_second_down <dbl>, def_third_down <dbl>
# }
```
