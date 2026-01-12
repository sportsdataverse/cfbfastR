# **Get team statistics by game**

**Get team statistics by game**

## Usage

``` r
cfbd_game_team_stats(
  year,
  week = NULL,
  season_type = "regular",
  team = NULL,
  conference = NULL,
  game_id = NULL,
  division = "fbs",
  rows_per_team = 1
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*). Required year
  filter (along with one of `week`, `team`, or `conference`), unless
  `game_id` is specified

- week:

  (*Integer* optional): Week - values range from 1-15, 1-14 for seasons
  pre-playoff, i.e. 2013 or earlier. Required if `team` and `conference`
  not specified.

- season_type:

  (*String* default: regular): Select Season Type - regular, postseason,
  both, allstar, spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team. Required if `week` and `conference` not
  specified.

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC Required if `week` and `team` not specified.

- game_id:

  (*Integer* optional): Game ID filter for querying a single game Can be
  found using the
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  function

- division:

  (*String* optional): Division abbreviation - Select a valid division:
  fbs/fcs/ii/iii

- rows_per_team:

  (*Integer* default 1): Both Teams for each game on one or two row(s),
  Options: 1 or 2

## Value

`cfbd_game_team_stats()` - A data frame with 78 variables:

- `game_id`: integer.:

  Referencing game id.

- `team`: character.:

  Team name.

- `conference`: character.:

  Conference of the team.

- `home_away`: character.:

  Home/Away Flag.

- `opponent`: character.:

  Opponent team name.

- `opponent_conference`: character.:

  Conference of the opponent team.

- `points`: integer.:

  Team points.

- `total_yards`: character.:

  Team total yards.

- `net_passing_yards`: character.:

  Team net passing yards.

- `completion_attempts`:character.:

  Team completion attempts.

- `passing_tds`: character.:

  Team passing touchdowns.

- `yards_per_pass`: character.:

  Team game yards per pass.

- `passes_intercepted`: character.:

  Team passes intercepted.

- `interception_yards`: character.:

  Interception yards.

- `interception_tds`: character.:

  Interceptions returned for a touchdown.

- `rushing_attempts`: character.:

  Team rushing attempts. see also: ESTABLISH IT.

- `rushing_yards`: character.:

  Team rushing yards.

- `rush_tds`: character.:

  Team rushing touchdowns.

- `yards_per_rush_attempt`: character.:

  Team yards per rush attempt.

- `first_downs`: character.:

  First downs earned by the team.

- `third_down_eff`: character.:

  Third down efficiency.

- `fourth_down_eff`: character.:

  Fourth down efficiency.

- `punt_returns`: character.:

  Team punt returns.

- `punt_return_yards`: character.:

  Team punt return yards.

- `punt_return_tds`: character.:

  Team punt return touchdowns.

- `kick_return_yards`: character.:

  Team kick return yards.

- `kick_return_tds`: character.:

  Team kick return touchdowns.

- `kick_returns`: character.:

  Team kick returns.

- `kicking_points`: character.:

  Team points from kicking the ball.

- `fumbles_recovered`: character.:

  Team fumbles recovered.

- `fumbles_lost`: character.:

  Team fumbles lost.

- `total_fumbles`: character.:

  Team total fumbles.

- `tackles`: character.:

  Team tackles.

- `tackles_for_loss`: character.:

  Team tackles for a loss.

- `sacks`: character.:

  Team sacks.

- `qb_hurries`: character.:

  Team QB hurries.

- `interceptions`: character.:

  Team interceptions.

- `passes_deflected`: character.:

  Team passes deflected.

- `turnovers`: character.:

  Team turnovers.

- `defensive_tds`: character.:

  Team defensive touchdowns.

- `total_penalties_yards`: character.:

  Team total penalty yards.

- `possession_time`: character.:

  Team time of possession.

- `points_allowed`: integer.:

  Points for the opponent.

- `total_yards_allowed`: character.:

  Opponent total yards.

- `net_passing_yards_allowed`: character.:

  Opponent net passing yards.

- `completion_attempts_allowed`: character.:

  Oppponent completion attempts.

- `passing_tds_allowed`: character.:

  Opponent passing TDs.

- `yards_per_pass_allowed`: character.:

  Opponent yards per pass allowed.

- `passes_intercepted_allowed`: character.:

  Opponent passes intercepted.

- `interception_yards_allowed`: character.:

  Opponent interception yards.

- `interception_tds_allowed`: character.:

  Opponent interception TDs.

- `rushing_attempts_allowed`: character.:

  Opponent rushing attempts.

- `rushing_yards_allowed`: character.:

  Opponent rushing yards.

- `rush_tds_allowed`: character.:

  Opponent rushing touchdowns.

- `yards_per_rush_attempt_allowed`: character.:

  Opponent rushing yards per attempt.

- `first_downs_allowed`: character.:

  Opponent first downs.

- `third_down_eff_allowed`: character.:

  Opponent third down efficiency.

- `fourth_down_eff_allowed`: character.:

  Opponent fourth down efficiency.

- `punt_returns_allowed`: character.:

  Opponent punt returns.

- `punt_return_yards_allowed`: character.:

  Opponent punt return yards.

- `punt_return_tds_allowed`: character.:

  Opponent punt return touchdowns.

- `kick_return_yards_allowed`: character.:

  Opponent kick return yards.

- `kick_return_tds_allowed`: character.:

  Opponent kick return touchdowns.

- `kick_returns_allowed`: character.:

  Opponent kick returns.

- `kicking_points_allowed`: character.:

  Opponent points from kicking.

- `fumbles_recovered_allowed`: character.:

  Opponent fumbles recovered.

- `fumbles_lost_allowed`: character.:

  Opponent fumbles lost.

- `total_fumbles_allowed`:character.:

  Opponent total number of fumbles.

- `tackles_allowed`:character.:

  Opponent tackles.

- `tackles_for_loss_allowed`: character.:

  Opponent tackles for loss.

- `sacks_allowed`: character.:

  Opponent sacks.

- `qb_hurries_allowed`: character.:

  Opponent quarterback hurries.

- `interceptions_allowed`: character.:

  Opponent interceptions.

- `passes_deflected_allowed`: character.:

  Opponent passes deflected.

- `turnovers_allowed`: character.:

  Opponent turnovers.

- `defensive_tds_allowed`: character.:

  Opponent defensive touchdowns.

- `total_penalties_yards_allowed`: character.:

  Opponent total penalty yards.

- `possession_time_allowed`: character.:

  Opponent time of possession.

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_team_stats(2022, team = "LSU"))
#> ── Team stats data from CollegeFootballData.com ────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:37 UTC
#> # A tibble: 26 × 78
#>      game_id school     conference home_away opponent opponent_conference points
#>        <int> <chr>      <chr>      <chr>     <chr>    <chr>                <int>
#>  1 401403923 LSU        SEC        home      Ole Miss SEC                     45
#>  2 401403923 Ole Miss   SEC        away      LSU      SEC                     20
#>  3 401403939 Arkansas   SEC        home      LSU      SEC                     10
#>  4 401403939 LSU        SEC        away      Arkansas SEC                     13
#>  5 401403963 Texas A&M  SEC        home      LSU      SEC                     38
#>  6 401403963 LSU        SEC        away      Texas A… SEC                     23
#>  7 401403885 LSU        SEC        home      Mississ… SEC                     31
#>  8 401403885 Mississip… SEC        away      LSU      SEC                     16
#>  9 401403867 Florida S… ACC        home      LSU      SEC                     24
#> 10 401403867 LSU        SEC        away      Florida… ACC                     23
#> # ℹ 16 more rows
#> # ℹ 71 more variables: total_yards <chr>, net_passing_yards <chr>,
#> #   completion_attempts <chr>, passing_tds <chr>, yards_per_pass <chr>,
#> #   passes_intercepted <chr>, interception_yards <chr>, interception_tds <chr>,
#> #   rushing_attempts <chr>, rushing_yards <chr>, rush_tds <chr>,
#> #   yards_per_rush_attempt <chr>, first_downs <chr>, third_down_eff <chr>,
#> #   fourth_down_eff <chr>, punt_returns <chr>, punt_return_yards <chr>, …

  try(cfbd_game_team_stats(2013, team = "Florida State"))
#> ── Team stats data from CollegeFootballData.com ────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:37 UTC
#> # A tibble: 26 × 78
#>      game_id school     conference home_away opponent opponent_conference points
#>        <int> <chr>      <chr>      <chr>     <chr>    <chr>                <int>
#>  1 332640052 Florida S… ACC        home      Bethune… MEAC                    54
#>  2 332640052 Bethune-C… MEAC       away      Florida… ACC                      6
#>  3 332450221 Pittsburgh ACC        home      Florida… ACC                     13
#>  4 332450221 Florida S… ACC        away      Pittsbu… ACC                     41
#>  5 332990052 Florida S… ACC        home      NC State ACC                     49
#>  6 332990052 NC State   ACC        away      Florida… ACC                     17
#>  7 333060052 Florida S… ACC        home      Miami    ACC                     41
#>  8 333060052 Miami      ACC        away      Florida… ACC                     14
#>  9 333130154 Florida S… ACC        away      Wake Fo… ACC                     59
#> 10 333130154 Wake Fore… ACC        home      Florida… ACC                      3
#> # ℹ 16 more rows
#> # ℹ 71 more variables: total_yards <chr>, net_passing_yards <chr>,
#> #   completion_attempts <chr>, passing_tds <chr>, yards_per_pass <chr>,
#> #   passes_intercepted <chr>, interception_yards <chr>, interception_tds <chr>,
#> #   rushing_attempts <chr>, rushing_yards <chr>, rush_tds <chr>,
#> #   yards_per_rush_attempt <chr>, first_downs <chr>, third_down_eff <chr>,
#> #   fourth_down_eff <chr>, punt_returns <chr>, punt_return_yards <chr>, …
# }
```
