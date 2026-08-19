# **Get live college football play-by-play data.**

**Get live college football play-by-play data.**

## Usage

``` r
cfbd_live_plays(game_id)
```

## Arguments

- game_id:

  (*Integer* Required): Game ID filter for querying a single game Can be
  found using the
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  function

## Value

`cfbd_live_plays()` - A data frame with 94 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | integer | CFBD game id for the live game. |
| home_team_id | integer | CFBD team id of the home team. |
| home_team | character | Name of the home team. |
| away_team_id | integer | CFBD team id of the away team. |
| away_team | character | Name of the away team. |
| play_id | character | Unique CFBD play id for this play. |
| home_score | integer | Home team score at the conclusion of the play. |
| away_score | integer | Away team score at the conclusion of the play. |
| period | integer | Quarter (1-4, or overtime period) in which the play occurred. |
| clock | character | Game clock at the snap, formatted as "MM:SS". |
| wall_clock | character | Real-world UTC timestamp when the play was recorded. |
| offense_team_id | integer | CFBD team id of the team on offense for this play. |
| offense_team | character | Name of the team on offense for this play. |
| down | integer | Down (1-4) at the start of the play. |
| distance | integer | Yards to gain for a first down at the snap. |
| yards_to_goal | integer | Yards from the offense to the opponent's end zone at the snap (0-100). |
| yards_gained | integer | Net yards gained by the offense on the play. |
| play_type_id | integer | CFBD play_type identifier; see [`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md). |
| play_type | character | Play type label (e.g. "Rush", "Pass Reception", "Punt"). |
| ppa | numeric | Predicted Points Added (CFBD PPA/EPA) value for the play. |
| garbage_time | logical | TRUE if the play occurred during garbage time. |
| success | logical | TRUE if the play met CFBD success-rate criteria. |
| rush_pass | character | Classification of the play as "Rush" or "Pass". |
| down_type | character | Down/distance classification (e.g. "standard" vs "passing" down). |
| play_text | character | Free-text narrative description of the play. |
| drive_id | character | CFBD drive identifier for the drive containing this play. |
| drive_offense_id | integer | CFBD team id of the offense on the drive. |
| drive_offense_team | character | Name of the offensive team on the drive. |
| drive_defense_id | integer | CFBD team id of the defense on the drive. |
| drive_defense_team | character | Name of the defensive team on the drive. |
| drive_play_count | integer | Number of plays in the drive. |
| drive_yards_gained | integer | Total net yards gained on the drive. |
| drive_start_period | integer | Quarter in which the drive started. |
| drive_start_clock | character | Game clock ("MM:SS") when the drive started. |
| drive_start_yards_to_goal | integer | Yards to opponent's end zone at drive start (0-100). |
| drive_end_period | integer | Quarter in which the drive ended. |
| drive_end_clock | character | Game clock ("MM:SS") when the drive ended. |
| drive_end_yards_to_goal | integer | Yards to opponent's end zone at drive end (0-100). |
| drive_duration | character | Drive duration measured in elapsed game clock. |
| drive_scoring_opportunity | logical | TRUE if the drive reached scoring territory. |
| drive_result | character | Outcome of the drive (e.g. "TD", "FG", "PUNT", "INT"). |
| drive_points_gained | integer | Points scored by the offense on the drive. |
| current_clock | character | Current game clock at the time of the live API snapshot. |
| current_possession | character | Team currently in possession at the snapshot time. |
| home_line_scores_q1 | integer | Home team points scored in the first quarter. |
| home_line_scores_q2 | integer | Home team points scored in the second quarter. |
| home_line_scores_q3 | integer | Home team points scored in the third quarter. |
| home_line_scores_q4 | integer | Home team points scored in the fourth quarter. |
| home_points | integer | Home team total points scored in the game so far. |
| home_drives | integer | Number of offensive drives by the home team. |
| home_scoring_opportunities | integer | Number of home drives that reached scoring territory. |
| home_points_per_opportunity | numeric | Home points scored per scoring opportunity. |
| home_average_start_yard_line | numeric | Average starting field position (yards from own goal) for home drives. |
| home_plays | integer | Total offensive plays run by the home team. |
| home_line_yards | numeric | Total offensive line yards credited to the home team's rushing attack. |
| home_line_yards_per_rush | numeric | Home offensive line yards per rush attempt. |
| home_second_level_yards | integer | Home rushing yards gained at the second level (5-10 yards past the line). |
| home_second_level_yards_per_rush | numeric | Home second-level rushing yards per rush attempt. |
| home_open_field_yards | integer | Home rushing yards gained in the open field (10+ yards past the line). |
| home_open_field_yards_per_rush | numeric | Home open-field rushing yards per rush attempt. |
| home_ppa_per_play | numeric | Average PPA per play for the home team (CFBD renames `epa_per_play`). |
| home_total_ppa | numeric | Cumulative PPA for the home team across all plays. |
| home_passing_ppa | numeric | Cumulative passing PPA for the home team. |
| home_ppa_per_pass | numeric | Average PPA per pass attempt for the home team. |
| home_rushing_ppa | numeric | Cumulative rushing PPA for the home team. |
| home_ppa_per_rush | numeric | Average PPA per rush attempt for the home team. |
| home_success_rate | numeric | Home team overall success rate (0-1). |
| home_standard_down_success_rate | numeric | Home success rate on standard downs (0-1). |
| home_passing_down_success_rate | numeric | Home success rate on passing downs (0-1). |
| home_explosiveness | numeric | Home explosiveness metric (average PPA on successful plays). |
| home_deserve_to_win | numeric | Home team "deserve-to-win" probability metric (0-1). |
| away_line_scores_q1 | integer | Away team points scored in the first quarter. |
| away_line_scores_q2 | integer | Away team points scored in the second quarter. |
| away_line_scores_q3 | integer | Away team points scored in the third quarter. |
| away_line_scores_q4 | integer | Away team points scored in the fourth quarter. |
| away_points | integer | Away team total points scored in the game so far. |
| away_drives | integer | Number of offensive drives by the away team. |
| away_scoring_opportunities | integer | Number of away drives that reached scoring territory. |
| away_points_per_opportunity | numeric | Away points scored per scoring opportunity. |
| away_average_start_yard_line | numeric | Average starting field position (yards from own goal) for away drives. |
| away_plays | integer | Total offensive plays run by the away team. |
| away_line_yards | numeric | Total offensive line yards credited to the away team's rushing attack. |
| away_line_yards_per_rush | numeric | Away offensive line yards per rush attempt. |
| away_second_level_yards | integer | Away rushing yards gained at the second level (5-10 yards past the line). |
| away_second_level_yards_per_rush | numeric | Away second-level rushing yards per rush attempt. |
| away_open_field_yards | integer | Away rushing yards gained in the open field (10+ yards past the line). |
| away_open_field_yards_per_rush | numeric | Away open-field rushing yards per rush attempt. |
| away_ppa_per_play | numeric | Average PPA per play for the away team (CFBD renames `epa_per_play`). |
| away_total_ppa | numeric | Cumulative PPA for the away team across all plays. |
| away_passing_ppa | numeric | Cumulative passing PPA for the away team. |
| away_ppa_per_pass | numeric | Average PPA per pass attempt for the away team. |
| away_rushing_ppa | numeric | Cumulative rushing PPA for the away team. |
| away_ppa_per_rush | numeric | Average PPA per rush attempt for the away team. |
| away_success_rate | numeric | Away team overall success rate (0-1). |
| away_standard_down_success_rate | numeric | Away success rate on standard downs (0-1). |
| away_passing_down_success_rate | numeric | Away success rate on passing downs (0-1). |
| away_explosiveness | numeric | Away explosiveness metric (average PPA on successful plays). |
| away_deserve_to_win | numeric | Away team "deserve-to-win" probability metric (0-1). |

## See also

Other CFBD PBP:
[`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md),
[`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md),
[`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md),
[`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md),
[`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md),
[`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)

## Examples

``` r
# \donttest{
  try(cfbd_live_plays(game_id=401520182))
#> ── Live play-by-play data from CollegeFootballData.com ─────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 17:35:19 UTC
#> # A tibble: 164 × 98
#>      game_id home_team_id home_team    away_team_id away_team play_id home_score
#>        <int>        <int> <chr>               <int> <chr>     <chr>        <int>
#>  1 401520182           52 Florida Sta…           99 LSU       401520…          0
#>  2 401520182           52 Florida Sta…           99 LSU       401520…          0
#>  3 401520182           52 Florida Sta…           99 LSU       401520…          0
#>  4 401520182           52 Florida Sta…           99 LSU       401520…          0
#>  5 401520182           52 Florida Sta…           99 LSU       401520…          0
#>  6 401520182           52 Florida Sta…           99 LSU       401520…          0
#>  7 401520182           52 Florida Sta…           99 LSU       401520…          0
#>  8 401520182           52 Florida Sta…           99 LSU       401520…          0
#>  9 401520182           52 Florida Sta…           99 LSU       401520…          0
#> 10 401520182           52 Florida Sta…           99 LSU       401520…          0
#> # ℹ 154 more rows
#> # ℹ 91 more variables: away_score <int>, period <int>, clock <chr>,
#> #   wall_clock <chr>, offense_team_id <int>, offense_team <chr>, down <int>,
#> #   distance <int>, yards_to_goal <int>, yards_gained <int>,
#> #   play_type_id <int>, play_type <chr>, ppa <dbl>, garbage_time <lgl>,
#> #   success <lgl>, rush_pass <chr>, down_type <chr>, play_text <chr>,
#> #   drive_id <chr>, drive_offense_id <int>, drive_offense_team <chr>, …
# }
```
