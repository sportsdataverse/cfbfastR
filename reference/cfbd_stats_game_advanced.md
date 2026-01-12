# **Get game advanced stats**

**Get game advanced stats**

## Usage

``` r
cfbd_stats_game_advanced(
  year,
  week = NULL,
  team = NULL,
  opponent = NULL,
  excl_garbage_time = FALSE,
  season_type = "both"
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format(*YYYY*)

- week:

  (*Integer* optional): Week - values from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier)

- team:

  (*String* optional): D-I Team

- opponent:

  (*String* optional): Opponent D-I Team

- excl_garbage_time:

  (*Logical* default FALSE): Select whether to exclude Garbage Time
  (TRUE/FALSE)

- season_type:

  (*String* default both): Season type - regular, postseason, both,
  allstar, spring_regular, spring_postseason

## Value

`cfbd_stats_game_advanced()` - A data frame with 60 variables:

- `game_id`: integer.:

  Referencing game id.

- `season`: integer.:

  Season of the game.

- `week`: integer.:

  Game week of the season.

- `team`: character.:

  Team name.

- `opponent`: character.:

  Opponent team name.

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

  Opponent stuff rate.

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

- `off_standard_downs_ppa`: double.:

  Offense standard downs predicted points added (PPA).

- `off_standard_downs_success_rate`: double.:

  Offense standard downs success rate.

- `off_standard_downs_explosiveness`: double.:

  Offense standard downs explosiveness rate.

- `off_passing_downs_ppa`: double.:

  Offense passing downs predicted points added (PPA).

- `off_passing_downs_success_rate`: double.:

  Offense passing downs success rate.

- `off_passing_downs_explosiveness`: double.:

  Offense passing downs explosiveness rate.

- `off_rushing_plays_ppa`: double.:

  Offense rushing plays predicted points added (PPA).

- `off_rushing_plays_total_ppa`: double.:

  Offense rushing plays total predicted points added (PPA).

- `off_rushing_plays_success_rate`: double.:

  Offense rushing plays success rate.

- `off_rushing_plays_explosiveness`: double.:

  Offense rushing plays explosiveness rate.

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

  Opponent stuff rate.

- `def_line_yds`: double.:

  Offensive line yards.

- `def_line_yds_total`: integer.:

  Offensive line yards total.

- `def_second_lvl_yds`: double.:

  Defense second-level yards.

- `def_second_lvl_yds_total`: integer.:

  Defense second-level yards total.

- `def_open_field_yds`: integer.:

  Defense open field yards.

- `def_open_field_yds_total`: integer.:

  Defense open field yards total.

- `def_standard_downs_ppa`: double.:

  Defense standard downs predicted points added (PPA).

- `def_standard_downs_success_rate`: double.:

  Defense standard downs success rate.

- `def_standard_downs_explosiveness`: double.:

  Defense standard downs explosiveness rate.

- `def_passing_downs_ppa`: double.:

  Defense passing downs predicted points added (PPA).

- `def_passing_downs_success_rate`: double.:

  Defense passing downs success rate.

- `def_passing_downs_explosiveness`: double.:

  Defense passing downs explosiveness rate.

- `def_rushing_plays_ppa`: double.:

  Defense rushing plays predicted points added (PPA).

- `def_rushing_plays_total_ppa`: double.:

  Defense rushing plays total predicted points added (PPA).

- `def_rushing_plays_success_rate`: double.:

  Defense rushing plays success rate.

- `def_rushing_plays_explosiveness`: double.:

  Defense rushing plays explosiveness rate.

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
[`cfbd_stats_season_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_advanced.md),
[`cfbd_stats_season_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.md),
[`cfbd_stats_season_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_team.md)

## Examples

``` r
# \donttest{
   try(cfbd_stats_game_advanced(year = 2018, week = 12, team = "Texas A&M"))
#> ── Advanced game stats from CollegeFootballData.com ────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:50 UTC
#> # A tibble: 1 × 62
#>     game_id season season_type  week team  opponent off_plays off_drives off_ppa
#>       <int>  <int> <chr>       <int> <chr> <chr>        <int>      <int>   <dbl>
#> 1 401012347   2018 regular        12 Texa… UAB             56         11   0.408
#> # ℹ 53 more variables: off_total_ppa <dbl>, off_success_rate <dbl>,
#> #   off_explosiveness <dbl>, off_power_success <dbl>, off_stuff_rate <dbl>,
#> #   off_line_yds <dbl>, off_line_yds_total <int>, off_second_lvl_yds <dbl>,
#> #   off_second_lvl_yds_total <int>, off_open_field_yds <dbl>,
#> #   off_open_field_yds_total <int>, off_standard_downs_ppa <dbl>,
#> #   off_standard_downs_success_rate <dbl>,
#> #   off_standard_downs_explosiveness <dbl>, off_passing_downs_ppa <dbl>, …

   try(cfbd_stats_game_advanced(2019, team = "LSU"))
#> ── Advanced game stats from CollegeFootballData.com ────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:50 UTC
#> # A tibble: 15 × 62
#>     game_id season season_type  week team  opponent off_plays off_drives off_ppa
#>       <int>  <int> <chr>       <int> <chr> <chr>        <int>      <int>   <dbl>
#>  1   4.01e8   2019 regular         1 LSU   Georgia…        73         13   0.377
#>  2   4.01e8   2019 regular         2 LSU   Texas           70         12   0.484
#>  3   4.01e8   2019 regular         3 LSU   Northwe…        69         12   0.598
#>  4   4.01e8   2019 regular         4 LSU   Vanderb…        74         17   0.286
#>  5   4.01e8   2019 regular         6 LSU   Utah St…        90         13   0.331
#>  6   4.01e8   2019 regular         7 LSU   Florida         48         11   0.736
#>  7   4.01e8   2019 regular         8 LSU   Mississ…        63         13   0.215
#>  8   4.01e8   2019 regular         9 LSU   Auburn          88         15   0.119
#>  9   4.01e8   2019 regular        11 LSU   Alabama         82         14   0.285
#> 10   4.01e8   2019 regular        12 LSU   Ole Miss        83         14   0.493
#> 11   4.01e8   2019 regular        13 LSU   Arkansas        48         12   0.796
#> 12   4.01e8   2019 regular        14 LSU   Texas A…        77         13   0.422
#> 13   4.01e8   2019 regular        15 LSU   Georgia         77         11   0.323
#> 14   4.01e8   2019 postseason      1 LSU   Oklahoma        73         12   0.632
#> 15   4.01e8   2019 postseason      1 LSU   Clemson         80         15   0.423
#> # ℹ 53 more variables: off_total_ppa <dbl>, off_success_rate <dbl>,
#> #   off_explosiveness <dbl>, off_power_success <dbl>, off_stuff_rate <dbl>,
#> #   off_line_yds <dbl>, off_line_yds_total <int>, off_second_lvl_yds <dbl>,
#> #   off_second_lvl_yds_total <int>, off_open_field_yds <dbl>,
#> #   off_open_field_yds_total <int>, off_standard_downs_ppa <dbl>,
#> #   off_standard_downs_success_rate <dbl>,
#> #   off_standard_downs_explosiveness <dbl>, off_passing_downs_ppa <dbl>, …

   try(cfbd_stats_game_advanced(2013, team = "Florida State"))
#> ── Advanced game stats from CollegeFootballData.com ────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:50 UTC
#> # A tibble: 14 × 62
#>    game_id season season_type  week team  opponent off_plays off_drives  off_ppa
#>      <int>  <int> <chr>       <int> <chr> <chr>        <int>      <int>    <dbl>
#>  1  3.32e8   2013 regular         1 Flor… Pittsbu…        58         10  4.46e-1
#>  2  3.33e8   2013 regular         3 Flor… Nevada          56         12  4.37e-1
#>  3  3.33e8   2013 regular         4 Flor… Bethune…        55         11  3.34e-1
#>  4  3.33e8   2013 regular         5 Flor… Boston …        56         12  2.23e-1
#>  5  3.33e8   2013 regular         6 Flor… Maryland        72         12  2.76e-1
#>  6  3.33e8   2013 regular         8 Flor… Clemson         68         12  2.40e-1
#>  7  3.33e8   2013 regular         9 Flor… NC State        58         14  3.53e-1
#>  8  3.33e8   2013 regular        10 Flor… Miami           69         11  3.07e-1
#>  9  3.33e8   2013 regular        11 Flor… Wake Fo…        64         14 -4.27e-4
#> 10  3.33e8   2013 regular        12 Flor… Syracuse        36         10  4.50e-1
#> 11  3.33e8   2013 regular        13 Flor… Idaho           68         14  2.12e-1
#> 12  3.33e8   2013 regular        14 Flor… Florida         60         11  2.12e-1
#> 13  3.33e8   2013 regular        15 Flor… Duke            69         15  2.31e-1
#> 14  3.40e8   2013 postseason      1 Flor… Auburn          61         12  2.20e-1
#> # ℹ 53 more variables: off_total_ppa <dbl>, off_success_rate <dbl>,
#> #   off_explosiveness <dbl>, off_power_success <dbl>, off_stuff_rate <dbl>,
#> #   off_line_yds <dbl>, off_line_yds_total <int>, off_second_lvl_yds <dbl>,
#> #   off_second_lvl_yds_total <int>, off_open_field_yds <dbl>,
#> #   off_open_field_yds_total <int>, off_standard_downs_ppa <dbl>,
#> #   off_standard_downs_success_rate <dbl>,
#> #   off_standard_downs_explosiveness <dbl>, off_passing_downs_ppa <dbl>, …
# }
```
