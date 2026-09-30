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
  Minimum value accepted: 2001

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

A data frame with one row per play and 28 variables. An empty data frame
is returned if the request fails.

|  |  |  |
|----|----|----|
| col_name | type | description |
| game_id | integer | CFBD game identifier the play belongs to. |
| drive_id | character | CFBD drive identifier the play belongs to. |
| play_id | character | CFBD play identifier; unique across games, as it begins with the game id. |
| drive_number | integer | Sequential drive number within the game (1-indexed). |
| play_number | integer | Sequential play number within the drive (1-indexed). |
| offense | character | Full name of the offense (team in possession) on the play. |
| offense_conference | character | Conference name of the offense (e.g. SEC, ACC). |
| offense_score | integer | Offense's score after the play (points). |
| defense | character | Full name of the defense on the play. |
| defense_conference | character | Conference name of the defense (e.g. SEC, ACC). |
| defense_score | integer | Defense's score after the play (points). |
| home | character | Full home team name for the game. |
| away | character | Full away team name for the game. |
| period | integer | Game period / quarter (1-4 regulation, 5+ overtime). |
| offense_timeouts | integer | Timeouts remaining for the offense at the end of the play. |
| defense_timeouts | integer | Timeouts remaining for the defense at the end of the play. |
| yardline | integer | Field position on a 0-100 scale measured from the home team's goal line, so it equals `yards_to_goal` when the away team has the ball. |
| yards_to_goal | integer | Distance in yards from the offense's spot to the opponent's goal line (0-100). |
| down | integer | Down of the play (1-4); 0 on kickoffs and period-end rows. |
| distance | integer | Yards to gain for a first down (or to the goal line in goal-to-go situations). |
| yards_gained | integer | Net yards gained by the offense on the play. |
| scoring | logical | TRUE when the play results in a score (TD, FG, safety, two-point conversion). |
| play_type | character | CFBD categorical label for the play type (see [`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md)). |
| play_text | character | Free-form text description of the play from the CFBD feed. |
| ppa | double | Predicted Points Added (CFBD's CFB-EPA analogue) for the play; NA for most kickoffs, punts, penalties, timeouts and period-end rows. |
| wallclock | character | Wall-clock time of the play (ISO 8601, UTC); NA when CFBD has no wall-clock data for the game. |
| clock_minutes | integer | Minutes remaining on the game clock at the start of the play. |
| clock_seconds | integer | Seconds remaining on the game clock at the start of the play. |

## See also

Other CFBD PBP:
[`cfbd_live_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.md),
[`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md),
[`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md),
[`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md),
[`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md),
[`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md)

## Examples

``` r
# \donttest{
  try(cfbd_plays(year = 2021, week = 1))
#> ── Play-by-play data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-30 21:53:57 UTC
#> # A tibble: 15,066 × 28
#>     game_id drive_id play_id drive_number play_number offense offense_conference
#>       <int> <chr>    <chr>          <int>       <int> <chr>   <chr>             
#>  1   4.01e8 4012819… 401281…            1           1 Auburn  SEC               
#>  2   4.01e8 4012819… 401281…            1           4 Auburn  SEC               
#>  3   4.01e8 4012819… 401281…            1           6 Akron   Mid-American      
#>  4   4.01e8 4012819… 401281…            1          15 Akron   Mid-American      
#>  5   4.01e8 4012819… 401281…            1           9 Akron   Mid-American      
#>  6   4.01e8 4012819… 401281…            1           7 Akron   Mid-American      
#>  7   4.01e8 4012819… 401281…            1           5 Akron   Mid-American      
#>  8   4.01e8 4012819… 401281…            1           2 Akron   Mid-American      
#>  9   4.01e8 4012819… 401281…            1          10 Akron   Mid-American      
#> 10   4.01e8 4012819… 401281…            1          11 Akron   Mid-American      
#> # ℹ 15,056 more rows
#> # ℹ 21 more variables: offense_score <int>, defense <chr>,
#> #   defense_conference <chr>, defense_score <int>, home <chr>, away <chr>,
#> #   period <int>, offense_timeouts <int>, defense_timeouts <int>,
#> #   yardline <int>, yards_to_goal <int>, down <int>, distance <int>,
#> #   yards_gained <int>, scoring <lgl>, play_type <chr>, play_text <chr>,
#> #   ppa <dbl>, wallclock <chr>, clock_minutes <int>, clock_seconds <int>
# }
```
