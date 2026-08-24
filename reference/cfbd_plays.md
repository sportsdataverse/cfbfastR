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

`cfbd_plays()` - A data frame with 27 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| play_id | character | CFBD play identifier (unique within a game when combined with game_id). |
| offense | character | Full name of the offense (team in possession) on the play. |
| offense_conference | character | Conference name of the offense (e.g. "SEC", "ACC"). |
| defense | character | Full name of the defense on the play. |
| defense_conference | character | Conference name of the defense (e.g. "SEC", "ACC"). |
| home | character | Full home team name for the game. |
| away | character | Full away team name for the game. |
| offense_score | integer | Offense's score after the play (points). |
| defense_score | integer | Defense's score after the play (points). |
| game_id | integer | CFBD game identifier the play belongs to. |
| drive_id | character | CFBD drive identifier the play belongs to. |
| drive_number | integer | Sequential drive number within the game (1-indexed). |
| play_number | integer | Sequential play number within the game (1-indexed). |
| period | integer | Game period / quarter (1-4 regulation, 5+ overtime). |
| offense_timeouts | integer | Timeouts remaining for the offense at the end of the play. |
| defense_timeouts | integer | Timeouts remaining for the defense at the end of the play. |
| yard_line | integer | Field-position yard line at the start of the play (0-50 scale from the offense's side). |
| yards_to_goal | integer | Distance in yards from the offense's spot to the opponent's goal line (0-100). |
| down | integer | Down of the play (1-4). |
| distance | integer | Yards to gain for a first down (or to the goal line in goal-to-go situations). |
| scoring | logical | TRUE when the play results in a score (TD, FG, safety, two-point conversion). |
| yards_gained | integer | Net yards gained by the offense on the play. |
| play_type | character | CFBD categorical label for the play type (see [`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md)). |
| play_text | character | Free-form text description of the play from the CFBD feed. |
| ppa | character | Predicted Points Added (CFBD's CFB-EPA analogue) for the play. |
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
#> ── Play-by-play data from CollegeFootballData.com ──────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 13:29:38 UTC
#> # A tibble: 15,066 × 28
#>     game_id drive_id play_id drive_number play_number offense offense_conference
#>       <int> <chr>    <chr>          <int>       <int> <chr>   <chr>             
#>  1   4.01e8 4012819… 401281…           17           3 Georgia SEC               
#>  2   4.01e8 4012819… 401281…           19           5 Georgia SEC               
#>  3   4.01e8 4012819… 401281…           19           6 Georgia SEC               
#>  4   4.01e8 4012819… 401281…           19           2 Georgia SEC               
#>  5   4.01e8 4012819… 401281…           19           3 Georgia SEC               
#>  6   4.01e8 4012819… 401281…           19           4 Georgia SEC               
#>  7   4.01e8 4012819… 401281…           21           4 Georgia SEC               
#>  8   4.01e8 4012819… 401281…           21          16 Georgia SEC               
#>  9   4.01e8 4012819… 401281…           21          13 Georgia SEC               
#> 10   4.01e8 4012819… 401281…           21          11 Georgia SEC               
#> # ℹ 15,056 more rows
#> # ℹ 21 more variables: offense_score <int>, defense <chr>,
#> #   defense_conference <chr>, defense_score <int>, home <chr>, away <chr>,
#> #   period <int>, offense_timeouts <int>, defense_timeouts <int>,
#> #   yardline <int>, yards_to_goal <int>, down <int>, distance <int>,
#> #   yards_gained <int>, scoring <lgl>, play_type <chr>, play_text <chr>,
#> #   ppa <dbl>, wallclock <chr>, clock_minutes <int>, clock_seconds <int>
# }
```
