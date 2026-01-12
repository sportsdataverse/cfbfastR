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

|                                  |           |
|----------------------------------|-----------|
| col_name                         | types     |
| game_id                          | integer   |
| home_team_id                     | integer   |
| home_team                        | character |
| away_team_id                     | integer   |
| away_team                        | character |
| play_id                          | character |
| home_score                       | integer   |
| away_score                       | integer   |
| period                           | integer   |
| clock                            | character |
| wall_clock                       | character |
| offense_team_id                  | integer   |
| offense_team                     | character |
| down                             | integer   |
| distance                         | integer   |
| yards_to_goal                    | integer   |
| yards_gained                     | integer   |
| play_type_id                     | integer   |
| play_type                        | character |
| ppa                              | numeric   |
| garbage_time                     | logical   |
| success                          | logical   |
| rush_pass                        | character |
| down_type                        | character |
| play_text                        | character |
| drive_id                         | character |
| drive_offense_id                 | integer   |
| drive_offense_team               | character |
| drive_defense_id                 | integer   |
| drive_defense_team               | character |
| drive_play_count                 | integer   |
| drive_yards_gained               | integer   |
| drive_start_period               | integer   |
| drive_start_clock                | character |
| drive_start_yards_to_goal        | integer   |
| drive_end_period                 | integer   |
| drive_end_clock                  | character |
| drive_end_yards_to_goal          | integer   |
| drive_duration                   | character |
| drive_scoring_opportunity        | logical   |
| drive_result                     | character |
| drive_points_gained              | integer   |
| current_clock                    | character |
| current_possession               | character |
| home_line_scores_q1              | integer   |
| home_line_scores_q2              | integer   |
| home_line_scores_q3              | integer   |
| home_line_scores_q4              | integer   |
| home_points                      | integer   |
| home_drives                      | integer   |
| home_scoring_opportunities       | integer   |
| home_points_per_opportunity      | numeric   |
| home_average_start_yard_line     | numeric   |
| home_plays                       | integer   |
| home_line_yards                  | numeric   |
| home_line_yards_per_rush         | numeric   |
| home_second_level_yards          | integer   |
| home_second_level_yards_per_rush | numeric   |
| home_open_field_yards            | integer   |
| home_open_field_yards_per_rush   | numeric   |
| home_ppa_per_play                | numeric   |
| home_total_ppa                   | numeric   |
| home_passing_ppa                 | numeric   |
| home_ppa_per_pass                | numeric   |
| home_rushing_ppa                 | numeric   |
| home_ppa_per_rush                | numeric   |
| home_success_rate                | numeric   |
| home_standard_down_success_rate  | numeric   |
| home_passing_down_success_rate   | numeric   |
| home_explosiveness               | numeric   |
| home_deserve_to_win              | numeric   |
| away_line_scores_q1              | integer   |
| away_line_scores_q2              | integer   |
| away_line_scores_q3              | integer   |
| away_line_scores_q4              | integer   |
| away_points                      | integer   |
| away_drives                      | integer   |
| away_scoring_opportunities       | integer   |
| away_points_per_opportunity      | numeric   |
| away_average_start_yard_line     | numeric   |
| away_plays                       | integer   |
| away_line_yards                  | numeric   |
| away_line_yards_per_rush         | numeric   |
| away_second_level_yards          | integer   |
| away_second_level_yards_per_rush | numeric   |
| away_open_field_yards            | integer   |
| away_open_field_yards_per_rush   | numeric   |
| away_ppa_per_play                | numeric   |
| away_total_ppa                   | numeric   |
| away_passing_ppa                 | numeric   |
| away_ppa_per_pass                | numeric   |
| away_rushing_ppa                 | numeric   |
| away_ppa_per_rush                | numeric   |
| away_success_rate                | numeric   |
| away_standard_down_success_rate  | numeric   |
| away_passing_down_success_rate   | numeric   |
| away_explosiveness               | numeric   |
| away_deserve_to_win              | numeric   |

## See also

Other CFBD PBP:
[`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md),
[`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md),
[`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md),
[`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md),
[`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)

## Examples

``` r
# \donttest{
  try(cfbd_live_plays(game_id=401520182))
#> ── Live play-by-play data from CollegeFootballData.com ─────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:32:59 UTC
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
