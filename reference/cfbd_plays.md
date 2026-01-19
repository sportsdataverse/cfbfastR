# **Get college football play-by-play data.**

**Get college football play-by-play data.**

## Usage

``` r
cfbd_plays(
  year = 2020,
  season_type = "regular",
  week = 1,
  team = NULL,
  offense = NULL,
  defense = NULL,
  conference = NULL,
  offense_conference = NULL,
  defense_conference = NULL,
  play_type = NULL,
  division = "fbs"
)
```

## Arguments

- year:

  Select year, (example: 2018)

- season_type:

  (*String* default regular): Season type - regular, postseason, both,
  allstar, spring_regular, spring_postseason

- week:

  Select week, this is optional (also numeric)

- team:

  Select team name (example: Texas, Texas A&M, Clemson)

- offense:

  Select offense name (example: Texas, Texas A&M, Clemson)

- defense:

  Select defense name (example: Texas, Texas A&M, Clemson)

- conference:

  Select conference name (example: ACC, B1G, B12, SEC, PAC, MAC, MWC,
  CUSA, Ind, SBC, AAC, Western, MVIAA, SWC, PCC, Big 6, etc.)

- offense_conference:

  Select conference name (example: ACC, B1G, B12, SEC, PAC, MAC, MWC,
  CUSA, Ind, SBC, AAC, Western, MVIAA, SWC, PCC, Big 6, etc.)

- defense_conference:

  Select conference name (example: ACC, B1G, B12, SEC, PAC, MAC, MWC,
  CUSA, Ind, SBC, AAC, Western, MVIAA, SWC, PCC, Big 6, etc.)

- play_type:

  Select play type (example: see the
  [cfbd_play_type_df](https://cfbfastR.sportsdataverse.org/reference/data.md))

- division:

  (*String* optional): Division abbreviation - Select a valid division:
  fbs/fcs/ii/iii

## Value

`cfbd_plays()` - A data frame with 29 columns:

- `play_id`: character.:

  Referencing play id.

- `offense`: character.:

  Offense on the field.

- `offense_conference`: character.:

  Conference of the offense on the field.

- `defense`: character.:

  Defense on the field.

- `defense_conference`: character.:

  Conference of the defense on the field.

- `home`: character.:

  Home team.

- `away`: character.:

  Away team.

- `offense_score`: integer.:

  Offense's post-play score.

- `defense_score`: integer.:

  Defense's post-play score.

- `game_id`: integer.:

  Referencing game id.

- `drive_id`: character.:

  Referencing drive id.

- `drive_number`: integer.:

  Drive number in the game.

- `play_number`: integer.:

  Play number in the game.

- `period`: integer.:

  Game period (quarter).

- `offense_timeouts`: integer.:

  Timeouts for the offense at the end of the play.

- `defense_timeouts`: integer.:

  Timeouts for the defense at the end of the play.

- `yard_line`: integer.:

  Yard line (~0-50) of the play.

- `yards_to_goal`: integer.:

  Yards to the goal line (~0-100).

- `down`: integer.:

  Down of the play.

- `distance`: integer.:

  Distance to the sticks, i.e. 1st down or goal-line in goal-to-go
  situations.

- `scoring`: logical.:

  Scoring play flag.

- `yards_gained`: integer.:

  Yards net gained by the offense on the play.

- `play_type`: character.:

  Categorical label of the type of the play.

- `play_text`: character.:

  A text description of the play.

- `ppa`: character.:

  Predicted Points Added (calculated by CFBD).

- `clock_minutes`: integer.:

  Minutes left on the clock.

- `clock_seconds`: integer.:

  Seconds left on the clock.

## See also

Other CFBD PBP:
[`cfbd_live_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.md),
[`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md),
[`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md),
[`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md),
[`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md)

## Examples

``` r
# \donttest{
  try(cfbd_plays(year = 2021, week = 1))
#> ── Play-by-play data from CollegeFootballData.com ──────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:22:37 UTC
#> # A tibble: 15,066 × 28
#>     game_id drive_id play_id drive_number play_number offense offense_conference
#>       <int> <chr>    <chr>          <int>       <int> <chr>   <chr>             
#>  1   4.01e8 4012827… 401282…            1           1 Illino… Big Ten           
#>  2   4.01e8 4012827… 401282…            1           7 Nebras… Big Ten           
#>  3   4.01e8 4012827… 401282…            1           6 Nebras… Big Ten           
#>  4   4.01e8 4012827… 401282…            1           5 Nebras… Big Ten           
#>  5   4.01e8 4012827… 401282…            1           4 Nebras… Big Ten           
#>  6   4.01e8 4012827… 401282…            1           3 Nebras… Big Ten           
#>  7   4.01e8 4012827… 401282…            1           2 Nebras… Big Ten           
#>  8   4.01e8 4012827… 401282…            2           5 Illino… Big Ten           
#>  9   4.01e8 4012827… 401282…            2           4 Illino… Big Ten           
#> 10   4.01e8 4012827… 401282…            2           3 Illino… Big Ten           
#> # ℹ 15,056 more rows
#> # ℹ 21 more variables: offense_score <int>, defense <chr>,
#> #   defense_conference <chr>, defense_score <int>, home <chr>, away <chr>,
#> #   period <int>, offense_timeouts <int>, defense_timeouts <int>,
#> #   yardline <int>, yards_to_goal <int>, down <int>, distance <int>,
#> #   yards_gained <int>, scoring <lgl>, play_type <chr>, play_text <chr>,
#> #   ppa <dbl>, wallclock <chr>, clock_minutes <int>, clock_seconds <int>
# }
```
