# **Get ESPN college football player stats data**

**Get ESPN college football player stats data**

## Usage

``` r
espn_cfb_player_stats(athlete_id, year, season_type = "regular", total = FALSE)
```

## Arguments

- athlete_id:

  Athlete ID

- year:

  Year

- season_type:

  (character, default: regular): Season type - regular or postseason

- total:

  (boolean, default: FALSE): Totals

## Value

Returns a tibble with the following columns:

|                                                 |           |
|-------------------------------------------------|-----------|
| col_name                                        | types     |
| athlete_id                                      | character |
| athlete_uid                                     | character |
| athlete_guid                                    | character |
| athlete_type                                    | character |
| sdr                                             | character |
| first_name                                      | character |
| last_name                                       | character |
| full_name                                       | character |
| display_name                                    | character |
| short_name                                      | character |
| weight                                          | numeric   |
| display_weight                                  | character |
| height                                          | numeric   |
| display_height                                  | character |
| age                                             | integer   |
| date_of_birth                                   | character |
| birth_place_city                                | character |
| birth_place_state                               | character |
| birth_place_country                             | character |
| birth_country_alternate_id                      | character |
| birth_country_abbreviation                      | character |
| slug                                            | character |
| jersey                                          | character |
| flag_href                                       | character |
| flag_alt                                        | character |
| flag_x_country_flag                             | character |
| position_id                                     | character |
| position_name                                   | character |
| position_display_name                           | character |
| position_abbreviation                           | character |
| position_leaf                                   | logical   |
| linked                                          | logical   |
| experience_years                                | integer   |
| experience_display_value                        | character |
| experience_abbreviation                         | character |
| active                                          | logical   |
| status_id                                       | character |
| status_name                                     | character |
| status_type                                     | character |
| status_abbreviation                             | character |
| headshot_href                                   | character |
| headshot_alt                                    | character |
| general_fumbles                                 | numeric   |
| general_fumbles_lost                            | numeric   |
| general_fumbles_touchdowns                      | numeric   |
| general_games_played                            | numeric   |
| general_offensive_two_pt_returns                | numeric   |
| general_offensive_fumbles_touchdowns            | numeric   |
| general_defensive_fumbles_touchdowns            | numeric   |
| passing_avg_gain                                | numeric   |
| passing_completion_pct                          | numeric   |
| passing_completions                             | numeric   |
| passing_espnqb_rating                           | numeric   |
| passing_interception_pct                        | numeric   |
| passing_interceptions                           | numeric   |
| passing_long_passing                            | numeric   |
| passing_net_passing_yards                       | numeric   |
| passing_net_passing_yards_per_game              | numeric   |
| passing_net_total_yards                         | numeric   |
| passing_net_yards_per_game                      | numeric   |
| passing_passing_attempts                        | numeric   |
| passing_passing_big_plays                       | numeric   |
| passing_passing_first_downs                     | numeric   |
| passing_passing_fumbles                         | numeric   |
| passing_passing_fumbles_lost                    | numeric   |
| passing_passing_touchdown_pct                   | numeric   |
| passing_passing_touchdowns                      | numeric   |
| passing_passing_yards                           | numeric   |
| passing_passing_yards_after_catch               | numeric   |
| passing_passing_yards_at_catch                  | numeric   |
| passing_passing_yards_per_game                  | numeric   |
| passing_qb_rating                               | numeric   |
| passing_sacks                                   | numeric   |
| passing_sack_yards_lost                         | numeric   |
| passing_team_games_played                       | numeric   |
| passing_total_offensive_plays                   | numeric   |
| passing_total_points_per_game                   | numeric   |
| passing_total_touchdowns                        | numeric   |
| passing_total_yards                             | numeric   |
| passing_total_yards_from_scrimmage              | numeric   |
| passing_two_point_pass_convs                    | numeric   |
| passing_two_pt_pass                             | numeric   |
| passing_two_pt_pass_attempts                    | numeric   |
| passing_yards_from_scrimmage_per_game           | numeric   |
| passing_yards_per_completion                    | numeric   |
| passing_yards_per_game                          | numeric   |
| passing_yards_per_pass_attempt                  | numeric   |
| passing_net_yards_per_pass_attempt              | numeric   |
| passing_qbr                                     | numeric   |
| passing_adj_qbr                                 | numeric   |
| passing_quarterback_rating                      | numeric   |
| rushing_avg_gain                                | numeric   |
| rushing_espnrb_rating                           | numeric   |
| rushing_long_rushing                            | numeric   |
| rushing_net_total_yards                         | numeric   |
| rushing_net_yards_per_game                      | numeric   |
| rushing_rushing_attempts                        | numeric   |
| rushing_rushing_big_plays                       | numeric   |
| rushing_rushing_first_downs                     | numeric   |
| rushing_rushing_fumbles                         | numeric   |
| rushing_rushing_fumbles_lost                    | numeric   |
| rushing_rushing_touchdowns                      | numeric   |
| rushing_rushing_yards                           | numeric   |
| rushing_rushing_yards_per_game                  | numeric   |
| rushing_stuffs                                  | numeric   |
| rushing_stuff_yards_lost                        | numeric   |
| rushing_team_games_played                       | numeric   |
| rushing_total_offensive_plays                   | numeric   |
| rushing_total_points_per_game                   | numeric   |
| rushing_total_touchdowns                        | numeric   |
| rushing_total_yards                             | numeric   |
| rushing_total_yards_from_scrimmage              | numeric   |
| rushing_two_point_rush_convs                    | numeric   |
| rushing_two_pt_rush                             | numeric   |
| rushing_two_pt_rush_attempts                    | numeric   |
| rushing_yards_from_scrimmage_per_game           | numeric   |
| rushing_yards_per_game                          | numeric   |
| rushing_yards_per_rush_attempt                  | numeric   |
| receiving_avg_gain                              | numeric   |
| receiving_espnwr_rating                         | numeric   |
| receiving_long_reception                        | numeric   |
| receiving_net_total_yards                       | numeric   |
| receiving_net_yards_per_game                    | numeric   |
| receiving_receiving_big_plays                   | numeric   |
| receiving_receiving_first_downs                 | numeric   |
| receiving_receiving_fumbles                     | numeric   |
| receiving_receiving_fumbles_lost                | numeric   |
| receiving_receiving_targets                     | numeric   |
| receiving_receiving_touchdowns                  | numeric   |
| receiving_receiving_yards                       | numeric   |
| receiving_receiving_yards_after_catch           | numeric   |
| receiving_receiving_yards_at_catch              | numeric   |
| receiving_receiving_yards_per_game              | numeric   |
| receiving_receptions                            | numeric   |
| receiving_team_games_played                     | numeric   |
| receiving_total_offensive_plays                 | numeric   |
| receiving_total_points_per_game                 | numeric   |
| receiving_total_touchdowns                      | numeric   |
| receiving_total_yards                           | numeric   |
| receiving_total_yards_from_scrimmage            | numeric   |
| receiving_two_point_rec_convs                   | numeric   |
| receiving_two_pt_reception                      | numeric   |
| receiving_two_pt_reception_attempts             | numeric   |
| receiving_yards_from_scrimmage_per_game         | numeric   |
| receiving_yards_per_game                        | numeric   |
| receiving_yards_per_reception                   | numeric   |
| scoring_defensive_points                        | numeric   |
| scoring_field_goals                             | numeric   |
| scoring_kick_extra_points                       | numeric   |
| scoring_kick_extra_points_made                  | numeric   |
| scoring_misc_points                             | numeric   |
| scoring_passing_touchdowns                      | numeric   |
| scoring_receiving_touchdowns                    | numeric   |
| scoring_return_touchdowns                       | numeric   |
| scoring_rushing_touchdowns                      | numeric   |
| scoring_total_points                            | numeric   |
| scoring_total_points_per_game                   | numeric   |
| scoring_total_touchdowns                        | numeric   |
| scoring_total_two_point_convs                   | numeric   |
| scoring_two_point_pass_convs                    | numeric   |
| scoring_two_point_rec_convs                     | numeric   |
| scoring_two_point_rush_convs                    | numeric   |
| scoring_one_pt_safeties_made                    | numeric   |
| general_fumbles_forced                          | logical   |
| general_fumbles_recovered                       | logical   |
| passing_misc_yards                              | logical   |
| passing_total_points                            | logical   |
| rushing_misc_yards                              | logical   |
| rushing_total_points                            | logical   |
| receiving_misc_yards                            | logical   |
| receiving_total_points                          | logical   |
| defensive_assist_tackles                        | logical   |
| defensive_avg_interception_yards                | logical   |
| defensive_avg_sack_yards                        | logical   |
| defensive_avg_stuff_yards                       | logical   |
| defensive_blocked_field_goal_touchdowns         | logical   |
| defensive_blocked_punt_touchdowns               | logical   |
| defensive_defensive_touchdowns                  | logical   |
| defensive_hurries                               | logical   |
| defensive_kicks_blocked                         | logical   |
| defensive_long_interception                     | logical   |
| defensive_misc_touchdowns                       | logical   |
| defensive_missed_field_goal_return_td           | numeric   |
| defensive_blocked_punt_ez_rec_td                | numeric   |
| defensive_passes_batted_down                    | logical   |
| defensive_passes_defended                       | logical   |
| defensive_two_pt_returns                        | logical   |
| defensive_sacks                                 | logical   |
| defensive_sack_yards                            | logical   |
| defensive_safeties                              | logical   |
| defensive_solo_tackles                          | logical   |
| defensive_stuffs                                | logical   |
| defensive_stuff_yards                           | logical   |
| defensive_tackles_for_loss                      | logical   |
| defensive_team_games_played                     | logical   |
| defensive_total_tackles                         | logical   |
| defensive_yards_allowed                         | logical   |
| defensive_points_allowed                        | logical   |
| defensive_one_pt_safeties_made                  | logical   |
| defensive_interceptions_interceptions           | logical   |
| defensive_interceptions_interception_touchdowns | logical   |
| defensive_interceptions_interception_yards      | logical   |
| kicking_avg_kickoff_return_yards                | logical   |
| kicking_avg_kickoff_yards                       | logical   |
| kicking_extra_point_attempts                    | logical   |
| kicking_extra_point_pct                         | logical   |
| kicking_extra_points_blocked                    | logical   |
| kicking_extra_points_blocked_pct                | logical   |
| kicking_extra_points_made                       | logical   |
| kicking_fair_catches                            | logical   |
| kicking_fair_catch_pct                          | logical   |
| kicking_field_goal_attempts                     | logical   |
| kicking_field_goal_attempts1_19                 | logical   |
| kicking_field_goal_attempts20_29                | logical   |
| kicking_field_goal_attempts30_39                | logical   |
| kicking_field_goal_attempts40_49                | logical   |
| kicking_field_goal_attempts50_59                | logical   |
| kicking_field_goal_attempts60_99                | logical   |
| kicking_field_goal_attempts50                   | logical   |
| kicking_field_goal_attempt_yards                | logical   |
| kicking_field_goal_pct                          | logical   |
| kicking_field_goals_blocked                     | logical   |
| kicking_field_goals_blocked_pct                 | logical   |
| kicking_field_goals_made                        | logical   |
| kicking_field_goals_made1_19                    | logical   |
| kicking_field_goals_made20_29                   | logical   |
| kicking_field_goals_made30_39                   | logical   |
| kicking_field_goals_made40_49                   | logical   |
| kicking_field_goals_made50_59                   | logical   |
| kicking_field_goals_made60_99                   | logical   |
| kicking_field_goals_made50                      | logical   |
| kicking_field_goals_made_yards                  | logical   |
| kicking_field_goals_missed_yards                | logical   |
| kicking_kickoff_returns                         | logical   |
| kicking_kickoff_return_touchdowns               | logical   |
| kicking_kickoff_return_yards                    | logical   |
| kicking_kickoffs                                | logical   |
| kicking_kickoff_yards                           | logical   |
| kicking_long_field_goal_attempt                 | logical   |
| kicking_long_field_goal_made                    | logical   |
| kicking_long_kickoff                            | logical   |
| kicking_team_games_played                       | logical   |
| kicking_total_kicking_points                    | logical   |
| kicking_touchback_pct                           | logical   |
| kicking_touchbacks                              | logical   |
| returning_def_fumble_returns                    | logical   |
| returning_def_fumble_return_yards               | logical   |
| returning_fumble_recoveries                     | logical   |
| returning_fumble_recovery_yards                 | logical   |
| returning_kick_return_fair_catches              | logical   |
| returning_kick_return_fair_catch_pct            | logical   |
| returning_kick_return_fumbles                   | logical   |
| returning_kick_return_fumbles_lost              | logical   |
| returning_kick_returns                          | logical   |
| returning_kick_return_touchdowns                | logical   |
| returning_kick_return_yards                     | logical   |
| returning_long_kick_return                      | logical   |
| returning_long_punt_return                      | logical   |
| returning_misc_fumble_returns                   | logical   |
| returning_misc_fumble_return_yards              | logical   |
| returning_opp_fumble_recoveries                 | logical   |
| returning_opp_fumble_recovery_yards             | logical   |
| returning_opp_special_team_fumble_returns       | logical   |
| returning_opp_special_team_fumble_return_yards  | logical   |
| returning_punt_return_fair_catches              | logical   |
| returning_punt_return_fair_catch_pct            | logical   |
| returning_punt_return_fumbles                   | logical   |
| returning_punt_return_fumbles_lost              | logical   |
| returning_punt_returns                          | logical   |
| returning_punt_returns_started_inside_the10     | logical   |
| returning_punt_returns_started_inside_the20     | logical   |
| returning_punt_return_touchdowns                | logical   |
| returning_punt_return_yards                     | logical   |
| returning_special_team_fumble_returns           | logical   |
| returning_special_team_fumble_return_yards      | logical   |
| returning_team_games_played                     | logical   |
| returning_yards_per_kick_return                 | logical   |
| returning_yards_per_punt_return                 | logical   |
| returning_yards_per_return                      | logical   |
| punting_avg_punt_return_yards                   | logical   |
| punting_fair_catches                            | logical   |
| punting_gross_avg_punt_yards                    | logical   |
| punting_long_punt                               | logical   |
| punting_net_avg_punt_yards                      | logical   |
| punting_punt_returns                            | logical   |
| punting_punt_return_yards                       | logical   |
| punting_punts                                   | logical   |
| punting_punts_blocked                           | logical   |
| punting_punts_blocked_pct                       | logical   |
| punting_punts_inside10                          | logical   |
| punting_punts_inside10pct                       | logical   |
| punting_punts_inside20                          | logical   |
| punting_punts_inside20pct                       | logical   |
| punting_punt_yards                              | logical   |
| punting_team_games_played                       | logical   |
| punting_touchback_pct                           | logical   |
| punting_touchbacks                              | logical   |
| miscellaneous_first_downs                       | logical   |
| miscellaneous_first_downs_passing               | logical   |
| miscellaneous_first_downs_penalty               | logical   |
| miscellaneous_first_downs_per_game              | logical   |
| miscellaneous_first_downs_rushing               | logical   |
| miscellaneous_fourth_down_attempts              | logical   |
| miscellaneous_fourth_down_conv_pct              | logical   |
| miscellaneous_fourth_down_convs                 | logical   |
| miscellaneous_fumbles_lost                      | logical   |
| miscellaneous_possession_time_seconds           | logical   |
| miscellaneous_redzone_efficiency_pct            | logical   |
| miscellaneous_redzone_field_goal_pct            | logical   |
| miscellaneous_redzone_scoring_pct               | logical   |
| miscellaneous_redzone_touchdown_pct             | logical   |
| miscellaneous_third_down_attempts               | logical   |
| miscellaneous_third_down_conv_pct               | logical   |
| miscellaneous_third_down_convs                  | logical   |
| miscellaneous_total_giveaways                   | logical   |
| miscellaneous_total_penalties                   | logical   |
| miscellaneous_total_penalty_yards               | logical   |
| miscellaneous_total_takeaways                   | logical   |
| miscellaneous_total_drives                      | logical   |
| miscellaneous_turn_over_differential            | logical   |
| team_id                                         | character |
| team_guid                                       | character |
| team_uid                                        | character |
| team_sdr                                        | character |
| team_slug                                       | character |
| team_location                                   | character |
| team_name                                       | character |
| team_nickname                                   | character |
| team_abbreviation                               | character |
| team_display_name                               | character |
| team_short_display_name                         | character |
| team_color                                      | character |
| team_alternate_color                            | character |
| is_active                                       | logical   |
| is_all_star                                     | logical   |
| logo_href                                       | character |
| logo_dark_href                                  | character |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(espn_cfb_player_stats(athlete_id = 530308, year = 2013))
#> ── CFB Player Season stats from ESPN.com ───────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:21:50 UTC
#> # A tibble: 1 × 335
#>   athlete_id athlete_uid    athlete_guid athlete_type sdr   first_name last_name
#>   <chr>      <chr>          <chr>        <chr>        <chr> <chr>      <chr>    
#> 1 530308     s:20~l:23~a:5… 57af2581-ce… football     2969… Jameis     Winston  
#> # ℹ 328 more variables: full_name <chr>, display_name <chr>, short_name <chr>,
#> #   weight <dbl>, display_weight <chr>, height <dbl>, display_height <chr>,
#> #   age <int>, date_of_birth <chr>, birth_place_city <chr>,
#> #   birth_place_state <chr>, birth_place_country <chr>,
#> #   birth_country_alternate_id <chr>, birth_country_abbreviation <chr>,
#> #   slug <chr>, jersey <chr>, flag_href <chr>, flag_alt <chr>,
#> #   flag_x_country_flag <chr>, position_id <chr>, position_name <chr>, …
  try(espn_cfb_player_stats(athlete_id = 4360799, year = 2022))
#> ── CFB Player Season stats from ESPN.com ───────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:21:50 UTC
#> # A tibble: 1 × 340
#>   athlete_id athlete_uid    athlete_guid athlete_type sdr   first_name last_name
#>   <chr>      <chr>          <chr>        <chr>        <chr> <chr>      <chr>    
#> 1 4360799    s:20~l:23~a:4… 3deb6032-be… football     4360… Jordan     Travis   
#> # ℹ 333 more variables: full_name <chr>, display_name <chr>, short_name <chr>,
#> #   weight <dbl>, display_weight <chr>, height <dbl>, display_height <chr>,
#> #   age <int>, date_of_birth <chr>, birth_place_city <chr>,
#> #   birth_place_state <chr>, birth_place_country <chr>,
#> #   birth_country_alternate_id <chr>, birth_country_abbreviation <chr>,
#> #   slug <chr>, headshot_href <chr>, headshot_alt <chr>, jersey <chr>,
#> #   flag_href <chr>, flag_alt <chr>, flag_x_country_flag <chr>, …
# }
```
