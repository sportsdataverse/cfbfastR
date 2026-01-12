# **Get season statistics by team**

**Get season statistics by team**

## Usage

``` r
cfbd_stats_season_team(
  year,
  season_type = "both",
  team = NULL,
  conference = NULL,
  start_week = NULL,
  end_week = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)

- season_type:

  (*String* default: both): Select Season Type - regular, postseason, or
  both

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- start_week:

  (*Integer* optional): Starting Week - values range from 1-15, 1-14 for
  seasons pre-playoff, i.e. 2013 or earlier

- end_week:

  (*Integer* optional): Ending Week - values range from 1-15, 1-14 for
  seasons pre-playoff, i.e. 2013 or earlier

## Value

`cfbd_stats_season_team()` - A data frame with 32 variables:

- `season`: integer:

  Season for stats.

- `team`: character.:

  Team name.

- `conference`: character.:

  Conference of team.

- `games`: integer.:

  Number of games.

- `time_of_poss_total`: integer.:

  Time of possession total.

- `time_of_poss_pg`: double.:

  Time of possession per game.

- `pass_comps`: integer.:

  Total number of pass completions.

- `pass_atts`: integer.:

  Total number of pass attempts.

- `completion_pct`: double.:

  Passing completion percentage.

- `net_pass_yds`: integer.:

  Net passing yards.

- `pass_ypa`: double.:

  Passing yards per attempt.

- `pass_ypr`: double.:

  Passing yards per reception.

- `pass_TDs`: integer.:

  Passing touchdowns.

- `interceptions`: integer.:

  Passing interceptions.

- `int_pct`: double.:

  Interception percentage (of attempts).

- `rush_atts`: integer.:

  Rushing attempts.

- `rush_yds`: integer.:

  Rushing yards.

- `rush_TDs`: integer.:

  Rushing touchdowns.

- `rush_ypc`: double.:

  Rushing yards per carry.

- `total_yds`: integer.:

  Rushing total yards.

- `fumbles_lost`: integer.:

  Fumbles lost.

- `turnovers`: integer.:

  Turnovers total.

- `turnovers_pg`: double.:

  Turnovers per game.

- `first_downs`: integer.:

  Number of first downs.

- `third_downs`: integer.:

  Number of third downs.

- `third_down_convs`: integer.:

  Number of third down conversions.

- `third_conv_rate`: double.:

  Third down conversion rate.

- `fourth_down_convs`: integer.:

  Fourth down conversions.

- `fourth_downs`: integer.:

  Fourth downs.

- `fourth_conv_rate`: double.:

  Fourth down conversion rate.

- `penalties`: integer.:

  Total number of penalties.

- `penalty_yds`: integer.:

  Penalty yards total.

- `penalties_pg`: double.:

  Penalties per game.

- `penalty_yds_pg`: double.:

  Penalty yardage per game.

- `yards_per_penalty`: double.:

  Average yards per penalty.

- `kick_returns`: integer.:

  Number of kick returns.

- `kick_return_yds`: integer.:

  Total kick return yards.

- `kick_return_TDs`: integer.:

  Total kick return touchdowns.

- `kick_return_avg`: double.:

  Kick return yards average.

- `punt_returns`: integer.:

  Number of punt returns.

- `punt_return_yds`: integer.:

  Punt return total yards.

- `punt_return_TDs`: integer.:

  Punt return total touchdowns.

- `punt_return_avg`: double.:

  Punt return yards average.

- `passes_intercepted`: integer.:

  Passes intercepted.

- `passes_intercepted_yds`: integer.:

  Pass interception return yards.

- `passes_intercepted_TDs`: integer.:

  Pass interception return touchdowns.

## See also

Other CFBD Stats:
[`cfbd_stats_categories()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_categories.md),
[`cfbd_stats_game_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.md),
[`cfbd_stats_season_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_advanced.md),
[`cfbd_stats_season_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.md)

## Examples

``` r
# \donttest{
   try(cfbd_stats_season_team(year = 2018, conference = "B12", start_week = 1, end_week = 8))
#> ── Season stats from CollegeFootballData.com ───────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:58 UTC
#> # A tibble: 10 × 32
#>    season team          conference games time_of_poss_total pass_comps pass_atts
#>     <int> <chr>         <chr>      <int>              <int>      <int>     <int>
#>  1   2018 Baylor        Big 12         7              13974        179       288
#>  2   2018 Iowa State    Big 12         6              10683        121       179
#>  3   2018 Kansas        Big 12         7              12405        133       224
#>  4   2018 Kansas State  Big 12         7              11392         91       170
#>  5   2018 Oklahoma      Big 12         7              11600        125       176
#>  6   2018 Oklahoma Sta… Big 12         7              11418        136       232
#>  7   2018 TCU           Big 12         7              12200        137       239
#>  8   2018 Texas         Big 12         7              13593        160       246
#>  9   2018 Texas Tech    Big 12         7              14014        220       319
#> 10   2018 West Virginia Big 12         6              10212        138       196
#> # ℹ 25 more variables: net_pass_yds <int>, pass_TDs <int>, interceptions <int>,
#> #   rush_atts <int>, rush_yds <int>, rush_TDs <int>, total_yds <int>,
#> #   fumbles_lost <int>, turnovers <int>, first_downs <int>, third_downs <int>,
#> #   third_down_convs <int>, fourth_down_convs <int>, fourth_downs <int>,
#> #   penalties <int>, penalty_yds <int>, kick_returns <int>,
#> #   kick_return_yds <int>, kick_return_TDs <int>, punt_returns <int>,
#> #   punt_return_yds <int>, punt_return_TDs <int>, passes_intercepted <int>, …

   try(cfbd_stats_season_team(2019, team = "LSU"))
#> ── Season stats from CollegeFootballData.com ───────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:59 UTC
#> # A tibble: 1 × 32
#>   season team  conference games time_of_poss_total pass_comps pass_atts
#>    <int> <chr> <chr>      <int>              <int>      <int>     <int>
#> 1   2019 LSU   SEC           15              27200        426       567
#> # ℹ 25 more variables: net_pass_yds <int>, pass_TDs <int>, interceptions <int>,
#> #   rush_atts <int>, rush_yds <int>, rush_TDs <int>, total_yds <int>,
#> #   fumbles_lost <int>, turnovers <int>, first_downs <int>, third_downs <int>,
#> #   third_down_convs <int>, fourth_down_convs <int>, fourth_downs <int>,
#> #   penalties <int>, penalty_yds <int>, kick_returns <int>,
#> #   kick_return_yds <int>, kick_return_TDs <int>, punt_returns <int>,
#> #   punt_return_yds <int>, punt_return_TDs <int>, passes_intercepted <int>, …

   try(cfbd_stats_season_team(2013, team = "Florida State"))
#> ── Season stats from CollegeFootballData.com ───────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:00 UTC
#> # A tibble: 1 × 32
#>   season team          conference games time_of_poss_total pass_comps pass_atts
#>    <int> <chr>         <chr>      <int>              <int>      <int>     <int>
#> 1   2013 Florida State ACC           14              24612        288       442
#> # ℹ 25 more variables: net_pass_yds <int>, pass_TDs <int>, interceptions <int>,
#> #   rush_atts <int>, rush_yds <int>, rush_TDs <int>, total_yds <int>,
#> #   fumbles_lost <int>, turnovers <int>, first_downs <int>, third_downs <int>,
#> #   third_down_convs <int>, fourth_down_convs <int>, fourth_downs <int>,
#> #   penalties <int>, penalty_yds <int>, kick_returns <int>,
#> #   kick_return_yds <int>, kick_return_TDs <int>, punt_returns <int>,
#> #   punt_return_yds <int>, punt_return_TDs <int>, passes_intercepted <int>, …
# }
```
