# **Get ESPN college football team stats data**

**Get ESPN college football team stats data**

## Usage

``` r
espn_cfb_team_stats(team_id, year, season_type = "regular", total = FALSE)
```

## Arguments

- team_id:

  Team ID

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
| general_fumbles                                 | numeric   |
| general_fumbles_lost                            | numeric   |
| general_fumbles_forced                          | numeric   |
| general_fumbles_recovered                       | numeric   |
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
| passing_misc_yards                              | numeric   |
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
| passing_total_points                            | numeric   |
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
| passing_quarterback_rating                      | numeric   |
| rushing_avg_gain                                | numeric   |
| rushing_espnrb_rating                           | numeric   |
| rushing_long_rushing                            | numeric   |
| rushing_misc_yards                              | numeric   |
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
| rushing_total_points                            | numeric   |
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
| receiving_misc_yards                            | numeric   |
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
| receiving_total_points                          | numeric   |
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
| defensive_assist_tackles                        | numeric   |
| defensive_avg_interception_yards                | numeric   |
| defensive_avg_sack_yards                        | numeric   |
| defensive_avg_stuff_yards                       | numeric   |
| defensive_blocked_field_goal_touchdowns         | numeric   |
| defensive_blocked_punt_touchdowns               | numeric   |
| defensive_defensive_touchdowns                  | numeric   |
| defensive_hurries                               | numeric   |
| defensive_kicks_blocked                         | numeric   |
| defensive_long_interception                     | numeric   |
| defensive_misc_touchdowns                       | numeric   |
| defensive_passes_batted_down                    | numeric   |
| defensive_passes_defended                       | numeric   |
| defensive_two_pt_returns                        | numeric   |
| defensive_sacks                                 | numeric   |
| defensive_sack_yards                            | numeric   |
| defensive_safeties                              | numeric   |
| defensive_solo_tackles                          | numeric   |
| defensive_stuffs                                | numeric   |
| defensive_stuff_yards                           | numeric   |
| defensive_tackles_for_loss                      | numeric   |
| defensive_team_games_played                     | numeric   |
| defensive_total_tackles                         | numeric   |
| defensive_yards_allowed                         | numeric   |
| defensive_points_allowed                        | numeric   |
| defensive_one_pt_safeties_made                  | numeric   |
| defensive_interceptions_interceptions           | numeric   |
| defensive_interceptions_interception_touchdowns | numeric   |
| defensive_interceptions_interception_yards      | numeric   |
| kicking_avg_kickoff_return_yards                | numeric   |
| kicking_avg_kickoff_yards                       | numeric   |
| kicking_extra_point_attempts                    | numeric   |
| kicking_extra_point_pct                         | numeric   |
| kicking_extra_points_blocked                    | numeric   |
| kicking_extra_points_blocked_pct                | numeric   |
| kicking_extra_points_made                       | numeric   |
| kicking_fair_catches                            | numeric   |
| kicking_fair_catch_pct                          | numeric   |
| kicking_field_goal_attempts                     | numeric   |
| kicking_field_goal_attempts1_19                 | numeric   |
| kicking_field_goal_attempts20_29                | numeric   |
| kicking_field_goal_attempts30_39                | numeric   |
| kicking_field_goal_attempts40_49                | numeric   |
| kicking_field_goal_attempts50_59                | numeric   |
| kicking_field_goal_attempts60_99                | numeric   |
| kicking_field_goal_attempts50                   | numeric   |
| kicking_field_goal_attempt_yards                | numeric   |
| kicking_field_goal_pct                          | numeric   |
| kicking_field_goals_blocked                     | numeric   |
| kicking_field_goals_blocked_pct                 | numeric   |
| kicking_field_goals_made                        | numeric   |
| kicking_field_goals_made1_19                    | numeric   |
| kicking_field_goals_made20_29                   | numeric   |
| kicking_field_goals_made30_39                   | numeric   |
| kicking_field_goals_made40_49                   | numeric   |
| kicking_field_goals_made50_59                   | numeric   |
| kicking_field_goals_made60_99                   | numeric   |
| kicking_field_goals_made50                      | numeric   |
| kicking_field_goals_made_yards                  | numeric   |
| kicking_field_goals_missed_yards                | numeric   |
| kicking_kickoff_returns                         | numeric   |
| kicking_kickoff_return_touchdowns               | numeric   |
| kicking_kickoff_return_yards                    | numeric   |
| kicking_kickoffs                                | numeric   |
| kicking_kickoff_yards                           | numeric   |
| kicking_long_field_goal_attempt                 | numeric   |
| kicking_long_field_goal_made                    | numeric   |
| kicking_long_kickoff                            | numeric   |
| kicking_team_games_played                       | numeric   |
| kicking_total_kicking_points                    | numeric   |
| kicking_touchback_pct                           | numeric   |
| kicking_touchbacks                              | numeric   |
| returning_def_fumble_returns                    | numeric   |
| returning_def_fumble_return_yards               | numeric   |
| returning_fumble_recoveries                     | numeric   |
| returning_fumble_recovery_yards                 | numeric   |
| returning_kick_return_fair_catches              | numeric   |
| returning_kick_return_fair_catch_pct            | numeric   |
| returning_kick_return_fumbles                   | numeric   |
| returning_kick_return_fumbles_lost              | numeric   |
| returning_kick_returns                          | numeric   |
| returning_kick_return_touchdowns                | numeric   |
| returning_kick_return_yards                     | numeric   |
| returning_long_kick_return                      | numeric   |
| returning_long_punt_return                      | numeric   |
| returning_misc_fumble_returns                   | numeric   |
| returning_misc_fumble_return_yards              | numeric   |
| returning_opp_fumble_recoveries                 | numeric   |
| returning_opp_fumble_recovery_yards             | numeric   |
| returning_opp_special_team_fumble_returns       | numeric   |
| returning_opp_special_team_fumble_return_yards  | numeric   |
| returning_punt_return_fair_catches              | numeric   |
| returning_punt_return_fair_catch_pct            | numeric   |
| returning_punt_return_fumbles                   | numeric   |
| returning_punt_return_fumbles_lost              | numeric   |
| returning_punt_returns                          | numeric   |
| returning_punt_returns_started_inside_the10     | numeric   |
| returning_punt_returns_started_inside_the20     | numeric   |
| returning_punt_return_touchdowns                | numeric   |
| returning_punt_return_yards                     | numeric   |
| returning_special_team_fumble_returns           | numeric   |
| returning_special_team_fumble_return_yards      | numeric   |
| returning_team_games_played                     | numeric   |
| returning_yards_per_kick_return                 | numeric   |
| returning_yards_per_punt_return                 | numeric   |
| returning_yards_per_return                      | numeric   |
| punting_avg_punt_return_yards                   | numeric   |
| punting_fair_catches                            | numeric   |
| punting_gross_avg_punt_yards                    | numeric   |
| punting_long_punt                               | numeric   |
| punting_net_avg_punt_yards                      | numeric   |
| punting_punt_returns                            | numeric   |
| punting_punt_return_yards                       | numeric   |
| punting_punts                                   | numeric   |
| punting_punts_blocked                           | numeric   |
| punting_punts_blocked_pct                       | numeric   |
| punting_punts_inside10                          | numeric   |
| punting_punts_inside10pct                       | numeric   |
| punting_punts_inside20                          | numeric   |
| punting_punts_inside20pct                       | numeric   |
| punting_punt_yards                              | numeric   |
| punting_team_games_played                       | numeric   |
| punting_touchback_pct                           | numeric   |
| punting_touchbacks                              | numeric   |
| scoring_defensive_points                        | numeric   |
| scoring_field_goals                             | numeric   |
| scoring_kick_extra_points                       | numeric   |
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
| miscellaneous_first_downs                       | numeric   |
| miscellaneous_first_downs_passing               | numeric   |
| miscellaneous_first_downs_penalty               | numeric   |
| miscellaneous_first_downs_per_game              | numeric   |
| miscellaneous_first_downs_rushing               | numeric   |
| miscellaneous_fourth_down_attempts              | numeric   |
| miscellaneous_fourth_down_conv_pct              | numeric   |
| miscellaneous_fourth_down_convs                 | numeric   |
| miscellaneous_fumbles_lost                      | numeric   |
| miscellaneous_possession_time_seconds           | numeric   |
| miscellaneous_redzone_efficiency_pct            | numeric   |
| miscellaneous_redzone_field_goal_pct            | numeric   |
| miscellaneous_redzone_scoring_pct               | numeric   |
| miscellaneous_redzone_touchdown_pct             | numeric   |
| miscellaneous_third_down_attempts               | numeric   |
| miscellaneous_third_down_conv_pct               | numeric   |
| miscellaneous_third_down_convs                  | numeric   |
| miscellaneous_total_giveaways                   | numeric   |
| miscellaneous_total_penalties                   | numeric   |
| miscellaneous_total_penalty_yards               | numeric   |
| miscellaneous_total_takeaways                   | numeric   |
| miscellaneous_total_drives                      | numeric   |
| miscellaneous_turn_over_differential            | numeric   |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(espn_cfb_team_stats(team_id = 52, year = 2020))
#> ── CFB Team Season stats from ESPN.com ─────────────────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:23:18 UTC
#> # A tibble: 1 × 341
#>   team_id team_guid          team_uid team_sdr team_slug team_location team_name
#>   <chr>   <chr>              <chr>    <chr>    <chr>     <chr>         <chr>    
#> 1 52      fa181128-4809-a20… s:20~l:… 5995     florida-… Florida State Seminoles
#> # ℹ 334 more variables: team_nickname <chr>, team_abbreviation <chr>,
#> #   team_display_name <chr>, team_short_display_name <chr>, team_color <chr>,
#> #   team_alternate_color <chr>, is_active <lgl>, is_all_star <lgl>,
#> #   logo_href <chr>, logo_dark_href <chr>, logos_href_2 <chr>,
#> #   logos_rel_primary_logo_on_white_color <chr>, logos_href_3 <chr>,
#> #   logos_rel_primary_logo_on_black_color <chr>, logos_href_4 <chr>,
#> #   logos_width_4 <int>, logos_height_4 <int>, logos_alt_4 <chr>, …
# }
```
