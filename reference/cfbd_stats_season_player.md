# **Get season statistics by player**

**Get season statistics by player**

## Usage

``` r
cfbd_stats_season_player(
  year,
  season_type = "both",
  team = NULL,
  conference = NULL,
  start_week = NULL,
  end_week = NULL,
  category = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)

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

- start_week:

  (*Integer* optional): Starting Week - values range from 1-15, 1-14 for
  seasons pre-playoff, i.e. 2013 or earlier

- end_week:

  (*Integer* optional): Ending Week - values range from 1-15, 1-14 for
  seasons pre-playoff, i.e. 2013 or earlier

- category:

  (*String* optional): Category filter (e.g defensive) Offense: passing,
  receiving, rushing Defense: defensive, fumbles, interceptions Special
  Teams: punting, puntReturns, kicking, kickReturns

## Value

`cfbd_stats_season_player()` - A data frame with 59 variables:

- `year`: integer.:

  Season of the player stats.

- `team`: character.:

  Team name.

- `conference`: character.:

  Conference of the team.

- `athlete_id`: character.:

  Athlete referencing id.

- `player`: character.:

  Player name.

- `position`: character.:

  Player position.

- `passing_completions`: double.:

  Passing completions.

- `passing_att`: double.:

  Passing attempts.

- `passing_pct`: double.:

  Passing completion percentage.

- `passing_yds`: double.:

  Passing yardage.

- `passing_td`: double.:

  Passing touchdowns.

- `passing_int`: double.:

  Passing interceptions.

- `passing_ypa`: double.:

  Passing yards per attempt.

- `rushing_car`: double.:

  Rushing yards per carry.

- `rushing_yds`: double.:

  Rushing yards total.

- `rushing_td`: double.:

  Rushing touchdowns.

- `rushing_ypc`: double.:

  Rushing yards per carry.

- `rushing_long`: double.:

  Rushing longest yardage attempt.

- `receiving_rec`: double.:

  Receiving - pass receptions.

- `receiving_yds`: double.:

  Receiving - pass reception yards.

- `receiving_td`: double.:

  Receiving - passing reception touchdowns.

- `receiving_ypr`: double.:

  Receiving - passing yards per reception.

- `receiving_long`: double.:

  Receiving - longest pass reception yardage.

- `fumbles_fum`: double.:

  Fumbles.

- `fumbles_rec`: double.:

  Fumbles recovered.

- `fumbles_lost`: double.:

  Fumbles lost.

- `defensive_solo`: double.:

  Defensive solo tackles.

- `defensive_tot`: double.:

  Defensive total tackles.

- `defensive_tfl`: double.:

  Defensive tackles for loss.

- `defensive_sacks`: double.:

  Defensive sacks.

- `defensive_qb_hur`: double.:

  Defensive quarterback hurries.

- `interceptions_int`: double.:

  Interceptions total.

- `interceptions_yds`: double.:

  Interception return yards.

- `interceptions_avg`: double.:

  Interception return yards average.

- `interceptions_td`: double.:

  Interception return touchdowns.

- `defensive_pd`: double.:

  Defense - passes defensed.

- `defensive_td`: double.:

  Defense - defensive touchdowns.

- `kicking_fgm`: double.:

  Kicking - field goals made.

- `kicking_fga`: double.:

  Kicking - field goals attempted.

- `kicking_pct`: double.:

  Kicking - field goal percentage.

- `kicking_xpa`: double.:

  Kicking - extra points attempted.

- `kicking_xpm`: double.:

  Kicking - extra points made.

- `kicking_pts`: double.:

  Kicking - total points.

- `kicking_long`: double.:

  Kicking - longest successful field goal attempt.

- `kick_returns_no`: double.:

  Kick Returns - number of kick returns.

- `kick_returns_yds`: double.:

  Kick Returns - kick return yards.

- `kick_returns_avg`: double.:

  Kick Returns - kick return average yards per return.

- `kick_returns_td`: double.:

  Kick Returns - kick return touchdowns.

- `kick_returns_long`: double.:

  Kick Returns - longest kick return yardage.

- `punting_no`: double.:

  Punting - number of punts.

- `punting_yds`: double.:

  Punting - punting yardage.

- `punting_ypp`: double.:

  Punting - yards per punt.

- `punting_long`: double.:

  Punting - longest punt yardage.

- `punting_in_20`: double.:

  Punting - punt downed inside the 20 yard line.

- `punting_tb`: double.:

  Punting - punt caused a touchback.

- `punt_returns_no`: double.:

  Punt Returns - number of punt returns.

- `punt_returns_yds`: double.:

  Punt Returns - punt return yardage total.

- `punt_returns_avg`: double.:

  Punt Returns - punt return average yards per return.

- `punt_returns_td`: double.:

  Punt Returns - punt return touchdowns.

- `punt_returns_long`: double.:

  Punt Returns - longest punt return yardage.

## See also

Other CFBD Stats:
[`cfbd_stats_categories()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_categories.md),
[`cfbd_stats_game_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.md),
[`cfbd_stats_season_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_advanced.md),
[`cfbd_stats_season_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_team.md)

## Examples

``` r
# \donttest{
   try(cfbd_stats_season_player(year = 2018, conference = "B12", start_week = 1, end_week = 7))
#> ── Advanced player season stats from CollegeFootballData.com ───────────────────
#> ℹ Data updated: 2026-01-12 06:33:54 UTC
#> # A tibble: 544 × 60
#>     year team          conference athlete_id player position passing_completions
#>    <dbl> <chr>         <chr>      <chr>      <chr>  <chr>                  <dbl>
#>  1  2018 Oklahoma      Big 12     3116367    Curti… LB                        NA
#>  2  2018 Oklahoma      Big 12     3116384    Carso… FB                        NA
#>  3  2018 TCU           Big 12     3116420    Grays… QB                         8
#>  4  2018 TCU           Big 12     3116426    Ridwa… S                         NA
#>  5  2018 TCU           Big 12     3116431    Ty Su… LB                        NA
#>  6  2018 TCU           Big 12     3116436    Trey … G                         NA
#>  7  2018 TCU           Big 12     3116449    L.J. … DE                        NA
#>  8  2018 West Virginia Big 12     3116455    Yodny… OL                        NA
#>  9  2018 West Virginia Big 12     3116461    Billy… P                         NA
#> 10  2018 Baylor        Big 12     3116715    Jalan… QB                        26
#> # ℹ 534 more rows
#> # ℹ 53 more variables: passing_att <dbl>, passing_pct <dbl>, passing_yds <dbl>,
#> #   passing_td <dbl>, passing_int <dbl>, passing_ypa <dbl>, rushing_car <dbl>,
#> #   rushing_yds <dbl>, rushing_td <dbl>, rushing_ypc <dbl>, rushing_long <dbl>,
#> #   receiving_rec <dbl>, receiving_yds <dbl>, receiving_td <dbl>,
#> #   receiving_ypr <dbl>, receiving_long <dbl>, fumbles_fum <dbl>,
#> #   fumbles_rec <dbl>, fumbles_lost <dbl>, defensive_solo <dbl>, …

   try(cfbd_stats_season_player(2019, team = "LSU", category = "passing"))
#> ── Advanced player season stats from CollegeFootballData.com ───────────────────
#> ℹ Data updated: 2026-01-12 06:33:55 UTC
#> # A tibble: 2 × 60
#>    year team  conference athlete_id player        position passing_completions
#>   <dbl> <chr> <chr>      <chr>      <chr>         <chr>                  <dbl>
#> 1  2019 LSU   SEC        3915511    Joe Burrow    QB                       402
#> 2  2019 LSU   SEC        4242210    Myles Brennan QB                        24
#> # ℹ 53 more variables: passing_att <dbl>, passing_pct <dbl>, passing_yds <dbl>,
#> #   passing_td <dbl>, passing_int <dbl>, passing_ypa <dbl>, rushing_car <dbl>,
#> #   rushing_yds <dbl>, rushing_td <dbl>, rushing_ypc <dbl>, rushing_long <dbl>,
#> #   receiving_rec <dbl>, receiving_yds <dbl>, receiving_td <dbl>,
#> #   receiving_ypr <dbl>, receiving_long <dbl>, fumbles_fum <dbl>,
#> #   fumbles_rec <dbl>, fumbles_lost <dbl>, defensive_solo <dbl>,
#> #   defensive_tot <dbl>, defensive_tfl <dbl>, defensive_sacks <dbl>, …

   try(cfbd_stats_season_player(2013, team = "Florida State", category = "passing"))
#> ── Advanced player season stats from CollegeFootballData.com ───────────────────
#> ℹ Data updated: 2026-01-12 06:33:56 UTC
#> # A tibble: 3 × 60
#>    year team          conference athlete_id player  position passing_completions
#>   <dbl> <chr>         <chr>      <chr>      <chr>   <chr>                  <dbl>
#> 1  2013 Florida State ACC        514124     Jake C… QB                        18
#> 2  2013 Florida State ACC        530299     Sean M… QB                        13
#> 3  2013 Florida State ACC        530308     Jameis… QB                       257
#> # ℹ 53 more variables: passing_att <dbl>, passing_pct <dbl>, passing_yds <dbl>,
#> #   passing_td <dbl>, passing_int <dbl>, passing_ypa <dbl>, rushing_car <dbl>,
#> #   rushing_yds <dbl>, rushing_td <dbl>, rushing_ypc <dbl>, rushing_long <dbl>,
#> #   receiving_rec <dbl>, receiving_yds <dbl>, receiving_td <dbl>,
#> #   receiving_ypr <dbl>, receiving_long <dbl>, fumbles_fum <dbl>,
#> #   fumbles_rec <dbl>, fumbles_lost <dbl>, defensive_solo <dbl>,
#> #   defensive_tot <dbl>, defensive_tfl <dbl>, defensive_sacks <dbl>, …

# }
```
