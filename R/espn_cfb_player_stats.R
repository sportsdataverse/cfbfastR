
#' @title
#' **Get ESPN college football player stats data**
#' @author Saiem Gilani
#' @param athlete_id Athlete ID
#' @param year Year
#' @param season_type (character, default: regular): Season type - regular or postseason
#' @param total (boolean, default: FALSE): Totals
#' @keywords CFB Player Stats
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows
#' @importFrom tidyr unnest unnest_wider everything
#' @export
#' @return Returns a tibble with the following columns:
#'
#'   |col_name                                        |types     |
#'   |:-----------------------------------------------|:---------|
#'   |athlete_id                                      |character |
#'   |athlete_uid                                     |character |
#'   |athlete_guid                                    |character |
#'   |athlete_type                                    |character |
#'   |sdr                                             |character |
#'   |first_name                                      |character |
#'   |last_name                                       |character |
#'   |full_name                                       |character |
#'   |display_name                                    |character |
#'   |short_name                                      |character |
#'   |weight                                          |numeric   |
#'   |display_weight                                  |character |
#'   |height                                          |numeric   |
#'   |display_height                                  |character |
#'   |age                                             |integer   |
#'   |date_of_birth                                   |character |
#'   |birth_place_city                                |character |
#'   |birth_place_state                               |character |
#'   |birth_place_country                             |character |
#'   |slug                                            |character |
#'   |jersey                                          |character |
#'   |position_id                                     |character |
#'   |position_name                                   |character |
#'   |position_display_name                           |character |
#'   |position_abbreviation                           |character |
#'   |position_leaf                                   |logical   |
#'   |linked                                          |logical   |
#'   |experience_years                                |integer   |
#'   |experience_display_value                        |character |
#'   |experience_abbreviation                         |character |
#'   |active                                          |logical   |
#'   |status_id                                       |character |
#'   |status_name                                     |character |
#'   |status_type                                     |character |
#'   |status_abbreviation                             |character |
#'   |headshot_href                                   |character |
#'   |headshot_alt                                    |character |
#'   |general_fumbles                                 |numeric   |
#'   |general_fumbles_lost                            |numeric   |
#'   |general_fumbles_touchdowns                      |numeric   |
#'   |general_games_played                            |numeric   |
#'   |general_offensive_two_pt_returns                |numeric   |
#'   |general_offensive_fumbles_touchdowns            |numeric   |
#'   |general_defensive_fumbles_touchdowns            |numeric   |
#'   |passing_avg_gain                                |numeric   |
#'   |passing_completion_pct                          |numeric   |
#'   |passing_completions                             |numeric   |
#'   |passing_espnqb_rating                           |numeric   |
#'   |passing_interception_pct                        |numeric   |
#'   |passing_interceptions                           |numeric   |
#'   |passing_long_passing                            |numeric   |
#'   |passing_net_passing_yards                       |numeric   |
#'   |passing_net_passing_yards_per_game              |numeric   |
#'   |passing_net_total_yards                         |numeric   |
#'   |passing_net_yards_per_game                      |numeric   |
#'   |passing_passing_attempts                        |numeric   |
#'   |passing_passing_big_plays                       |numeric   |
#'   |passing_passing_first_downs                     |numeric   |
#'   |passing_passing_fumbles                         |numeric   |
#'   |passing_passing_fumbles_lost                    |numeric   |
#'   |passing_passing_touchdown_pct                   |numeric   |
#'   |passing_passing_touchdowns                      |numeric   |
#'   |passing_passing_yards                           |numeric   |
#'   |passing_passing_yards_after_catch               |numeric   |
#'   |passing_passing_yards_at_catch                  |numeric   |
#'   |passing_passing_yards_per_game                  |numeric   |
#'   |passing_qb_rating                               |numeric   |
#'   |passing_sacks                                   |numeric   |
#'   |passing_sack_yards_lost                         |numeric   |
#'   |passing_team_games_played                       |numeric   |
#'   |passing_total_offensive_plays                   |numeric   |
#'   |passing_total_points_per_game                   |numeric   |
#'   |passing_total_touchdowns                        |numeric   |
#'   |passing_total_yards                             |numeric   |
#'   |passing_total_yards_from_scrimmage              |numeric   |
#'   |passing_two_point_pass_convs                    |numeric   |
#'   |passing_two_pt_pass                             |numeric   |
#'   |passing_two_pt_pass_attempts                    |numeric   |
#'   |passing_yards_from_scrimmage_per_game           |numeric   |
#'   |passing_yards_per_completion                    |numeric   |
#'   |passing_yards_per_game                          |numeric   |
#'   |passing_yards_per_pass_attempt                  |numeric   |
#'   |passing_net_yards_per_pass_attempt              |numeric   |
#'   |passing_qbr                                     |numeric   |
#'   |passing_adj_qbr                                 |numeric   |
#'   |passing_quarterback_rating                      |numeric   |
#'   |rushing_avg_gain                                |numeric   |
#'   |rushing_espnrb_rating                           |numeric   |
#'   |rushing_long_rushing                            |numeric   |
#'   |rushing_net_total_yards                         |numeric   |
#'   |rushing_net_yards_per_game                      |numeric   |
#'   |rushing_rushing_attempts                        |numeric   |
#'   |rushing_rushing_big_plays                       |numeric   |
#'   |rushing_rushing_first_downs                     |numeric   |
#'   |rushing_rushing_fumbles                         |numeric   |
#'   |rushing_rushing_fumbles_lost                    |numeric   |
#'   |rushing_rushing_touchdowns                      |numeric   |
#'   |rushing_rushing_yards                           |numeric   |
#'   |rushing_rushing_yards_per_game                  |numeric   |
#'   |rushing_stuffs                                  |numeric   |
#'   |rushing_stuff_yards_lost                        |numeric   |
#'   |rushing_team_games_played                       |numeric   |
#'   |rushing_total_offensive_plays                   |numeric   |
#'   |rushing_total_points_per_game                   |numeric   |
#'   |rushing_total_touchdowns                        |numeric   |
#'   |rushing_total_yards                             |numeric   |
#'   |rushing_total_yards_from_scrimmage              |numeric   |
#'   |rushing_two_point_rush_convs                    |numeric   |
#'   |rushing_two_pt_rush                             |numeric   |
#'   |rushing_two_pt_rush_attempts                    |numeric   |
#'   |rushing_yards_from_scrimmage_per_game           |numeric   |
#'   |rushing_yards_per_game                          |numeric   |
#'   |rushing_yards_per_rush_attempt                  |numeric   |
#'   |receiving_avg_gain                              |numeric   |
#'   |receiving_espnwr_rating                         |numeric   |
#'   |receiving_long_reception                        |numeric   |
#'   |receiving_net_total_yards                       |numeric   |
#'   |receiving_net_yards_per_game                    |numeric   |
#'   |receiving_receiving_big_plays                   |numeric   |
#'   |receiving_receiving_first_downs                 |numeric   |
#'   |receiving_receiving_fumbles                     |numeric   |
#'   |receiving_receiving_fumbles_lost                |numeric   |
#'   |receiving_receiving_targets                     |numeric   |
#'   |receiving_receiving_touchdowns                  |numeric   |
#'   |receiving_receiving_yards                       |numeric   |
#'   |receiving_receiving_yards_after_catch           |numeric   |
#'   |receiving_receiving_yards_at_catch              |numeric   |
#'   |receiving_receiving_yards_per_game              |numeric   |
#'   |receiving_receptions                            |numeric   |
#'   |receiving_team_games_played                     |numeric   |
#'   |receiving_total_offensive_plays                 |numeric   |
#'   |receiving_total_points_per_game                 |numeric   |
#'   |receiving_total_touchdowns                      |numeric   |
#'   |receiving_total_yards                           |numeric   |
#'   |receiving_total_yards_from_scrimmage            |numeric   |
#'   |receiving_two_point_rec_convs                   |numeric   |
#'   |receiving_two_pt_reception                      |numeric   |
#'   |receiving_two_pt_reception_attempts             |numeric   |
#'   |receiving_yards_from_scrimmage_per_game         |numeric   |
#'   |receiving_yards_per_game                        |numeric   |
#'   |receiving_yards_per_reception                   |numeric   |
#'   |scoring_defensive_points                        |numeric   |
#'   |scoring_field_goals                             |numeric   |
#'   |scoring_kick_extra_points                       |numeric   |
#'   |scoring_misc_points                             |numeric   |
#'   |scoring_passing_touchdowns                      |numeric   |
#'   |scoring_receiving_touchdowns                    |numeric   |
#'   |scoring_return_touchdowns                       |numeric   |
#'   |scoring_rushing_touchdowns                      |numeric   |
#'   |scoring_total_points                            |numeric   |
#'   |scoring_total_points_per_game                   |numeric   |
#'   |scoring_total_touchdowns                        |numeric   |
#'   |scoring_total_two_point_convs                   |numeric   |
#'   |scoring_two_point_pass_convs                    |numeric   |
#'   |scoring_two_point_rec_convs                     |numeric   |
#'   |scoring_two_point_rush_convs                    |numeric   |
#'   |scoring_one_pt_safeties_made                    |numeric   |
#'   |general_fumbles_forced                          |logical   |
#'   |general_fumbles_recovered                       |logical   |
#'   |passing_misc_yards                              |logical   |
#'   |passing_total_points                            |logical   |
#'   |rushing_misc_yards                              |logical   |
#'   |rushing_total_points                            |logical   |
#'   |receiving_misc_yards                            |logical   |
#'   |receiving_total_points                          |logical   |
#'   |defensive_assist_tackles                        |logical   |
#'   |defensive_avg_interception_yards                |logical   |
#'   |defensive_avg_sack_yards                        |logical   |
#'   |defensive_avg_stuff_yards                       |logical   |
#'   |defensive_blocked_field_goal_touchdowns         |logical   |
#'   |defensive_blocked_punt_touchdowns               |logical   |
#'   |defensive_defensive_touchdowns                  |logical   |
#'   |defensive_hurries                               |logical   |
#'   |defensive_kicks_blocked                         |logical   |
#'   |defensive_long_interception                     |logical   |
#'   |defensive_misc_touchdowns                       |logical   |
#'   |defensive_passes_batted_down                    |logical   |
#'   |defensive_passes_defended                       |logical   |
#'   |defensive_two_pt_returns                        |logical   |
#'   |defensive_sacks                                 |logical   |
#'   |defensive_sack_yards                            |logical   |
#'   |defensive_safeties                              |logical   |
#'   |defensive_solo_tackles                          |logical   |
#'   |defensive_stuffs                                |logical   |
#'   |defensive_stuff_yards                           |logical   |
#'   |defensive_tackles_for_loss                      |logical   |
#'   |defensive_team_games_played                     |logical   |
#'   |defensive_total_tackles                         |logical   |
#'   |defensive_yards_allowed                         |logical   |
#'   |defensive_points_allowed                        |logical   |
#'   |defensive_one_pt_safeties_made                  |logical   |
#'   |defensive_interceptions_interceptions           |logical   |
#'   |defensive_interceptions_interception_touchdowns |logical   |
#'   |defensive_interceptions_interception_yards      |logical   |
#'   |kicking_avg_kickoff_return_yards                |logical   |
#'   |kicking_avg_kickoff_yards                       |logical   |
#'   |kicking_extra_point_attempts                    |logical   |
#'   |kicking_extra_point_pct                         |logical   |
#'   |kicking_extra_points_blocked                    |logical   |
#'   |kicking_extra_points_blocked_pct                |logical   |
#'   |kicking_extra_points_made                       |logical   |
#'   |kicking_fair_catches                            |logical   |
#'   |kicking_fair_catch_pct                          |logical   |
#'   |kicking_field_goal_attempts                     |logical   |
#'   |kicking_field_goal_attempts1_19                 |logical   |
#'   |kicking_field_goal_attempts20_29                |logical   |
#'   |kicking_field_goal_attempts30_39                |logical   |
#'   |kicking_field_goal_attempts40_49                |logical   |
#'   |kicking_field_goal_attempts50_59                |logical   |
#'   |kicking_field_goal_attempts60_99                |logical   |
#'   |kicking_field_goal_attempts50                   |logical   |
#'   |kicking_field_goal_attempt_yards                |logical   |
#'   |kicking_field_goal_pct                          |logical   |
#'   |kicking_field_goals_blocked                     |logical   |
#'   |kicking_field_goals_blocked_pct                 |logical   |
#'   |kicking_field_goals_made                        |logical   |
#'   |kicking_field_goals_made1_19                    |logical   |
#'   |kicking_field_goals_made20_29                   |logical   |
#'   |kicking_field_goals_made30_39                   |logical   |
#'   |kicking_field_goals_made40_49                   |logical   |
#'   |kicking_field_goals_made50_59                   |logical   |
#'   |kicking_field_goals_made60_99                   |logical   |
#'   |kicking_field_goals_made50                      |logical   |
#'   |kicking_field_goals_made_yards                  |logical   |
#'   |kicking_field_goals_missed_yards                |logical   |
#'   |kicking_kickoff_returns                         |logical   |
#'   |kicking_kickoff_return_touchdowns               |logical   |
#'   |kicking_kickoff_return_yards                    |logical   |
#'   |kicking_kickoffs                                |logical   |
#'   |kicking_kickoff_yards                           |logical   |
#'   |kicking_long_field_goal_attempt                 |logical   |
#'   |kicking_long_field_goal_made                    |logical   |
#'   |kicking_long_kickoff                            |logical   |
#'   |kicking_team_games_played                       |logical   |
#'   |kicking_total_kicking_points                    |logical   |
#'   |kicking_touchback_pct                           |logical   |
#'   |kicking_touchbacks                              |logical   |
#'   |returning_def_fumble_returns                    |logical   |
#'   |returning_def_fumble_return_yards               |logical   |
#'   |returning_fumble_recoveries                     |logical   |
#'   |returning_fumble_recovery_yards                 |logical   |
#'   |returning_kick_return_fair_catches              |logical   |
#'   |returning_kick_return_fair_catch_pct            |logical   |
#'   |returning_kick_return_fumbles                   |logical   |
#'   |returning_kick_return_fumbles_lost              |logical   |
#'   |returning_kick_returns                          |logical   |
#'   |returning_kick_return_touchdowns                |logical   |
#'   |returning_kick_return_yards                     |logical   |
#'   |returning_long_kick_return                      |logical   |
#'   |returning_long_punt_return                      |logical   |
#'   |returning_misc_fumble_returns                   |logical   |
#'   |returning_misc_fumble_return_yards              |logical   |
#'   |returning_opp_fumble_recoveries                 |logical   |
#'   |returning_opp_fumble_recovery_yards             |logical   |
#'   |returning_opp_special_team_fumble_returns       |logical   |
#'   |returning_opp_special_team_fumble_return_yards  |logical   |
#'   |returning_punt_return_fair_catches              |logical   |
#'   |returning_punt_return_fair_catch_pct            |logical   |
#'   |returning_punt_return_fumbles                   |logical   |
#'   |returning_punt_return_fumbles_lost              |logical   |
#'   |returning_punt_returns                          |logical   |
#'   |returning_punt_returns_started_inside_the10     |logical   |
#'   |returning_punt_returns_started_inside_the20     |logical   |
#'   |returning_punt_return_touchdowns                |logical   |
#'   |returning_punt_return_yards                     |logical   |
#'   |returning_special_team_fumble_returns           |logical   |
#'   |returning_special_team_fumble_return_yards      |logical   |
#'   |returning_team_games_played                     |logical   |
#'   |returning_yards_per_kick_return                 |logical   |
#'   |returning_yards_per_punt_return                 |logical   |
#'   |returning_yards_per_return                      |logical   |
#'   |punting_avg_punt_return_yards                   |logical   |
#'   |punting_fair_catches                            |logical   |
#'   |punting_gross_avg_punt_yards                    |logical   |
#'   |punting_long_punt                               |logical   |
#'   |punting_net_avg_punt_yards                      |logical   |
#'   |punting_punt_returns                            |logical   |
#'   |punting_punt_return_yards                       |logical   |
#'   |punting_punts                                   |logical   |
#'   |punting_punts_blocked                           |logical   |
#'   |punting_punts_blocked_pct                       |logical   |
#'   |punting_punts_inside10                          |logical   |
#'   |punting_punts_inside10pct                       |logical   |
#'   |punting_punts_inside20                          |logical   |
#'   |punting_punts_inside20pct                       |logical   |
#'   |punting_punt_yards                              |logical   |
#'   |punting_team_games_played                       |logical   |
#'   |punting_touchback_pct                           |logical   |
#'   |punting_touchbacks                              |logical   |
#'   |miscellaneous_first_downs                       |logical   |
#'   |miscellaneous_first_downs_passing               |logical   |
#'   |miscellaneous_first_downs_penalty               |logical   |
#'   |miscellaneous_first_downs_per_game              |logical   |
#'   |miscellaneous_first_downs_rushing               |logical   |
#'   |miscellaneous_fourth_down_attempts              |logical   |
#'   |miscellaneous_fourth_down_conv_pct              |logical   |
#'   |miscellaneous_fourth_down_convs                 |logical   |
#'   |miscellaneous_fumbles_lost                      |logical   |
#'   |miscellaneous_possession_time_seconds           |logical   |
#'   |miscellaneous_redzone_efficiency_pct            |logical   |
#'   |miscellaneous_redzone_field_goal_pct            |logical   |
#'   |miscellaneous_redzone_scoring_pct               |logical   |
#'   |miscellaneous_redzone_touchdown_pct             |logical   |
#'   |miscellaneous_third_down_attempts               |logical   |
#'   |miscellaneous_third_down_conv_pct               |logical   |
#'   |miscellaneous_third_down_convs                  |logical   |
#'   |miscellaneous_total_giveaways                   |logical   |
#'   |miscellaneous_total_penalties                   |logical   |
#'   |miscellaneous_total_penalty_yards               |logical   |
#'   |miscellaneous_total_takeaways                   |logical   |
#'   |miscellaneous_total_drives                      |logical   |
#'   |miscellaneous_turn_over_differential            |logical   |
#'   |team_id                                         |character |
#'   |team_guid                                       |character |
#'   |team_uid                                        |character |
#'   |team_sdr                                        |character |
#'   |team_slug                                       |character |
#'   |team_location                                   |character |
#'   |team_name                                       |character |
#'   |team_nickname                                   |character |
#'   |team_abbreviation                               |character |
#'   |team_display_name                               |character |
#'   |team_short_display_name                         |character |
#'   |team_color                                      |character |
#'   |team_alternate_color                            |character |
#'   |is_active                                       |logical   |
#'   |is_all_star                                     |logical   |
#'   |logo_href                                       |character |
#'   |logo_dark_href                                  |character |
#'
#' @examples
#' \donttest{
#'   try(espn_cfb_player_stats(athlete_id = 530308, year = 2013))
#'   try(espn_cfb_player_stats(athlete_id = 4360799, year = 2022))
#' }
#'
espn_cfb_player_stats <- function(athlete_id, year, season_type='regular', total=FALSE){
  if (!(tolower(season_type) %in% c("regular","postseason"))) {
    # Check if season_type is appropriate, if not regular
    cli::cli_abort("Enter valid season_type: regular or postseason")
  }
  s_type <- ifelse(season_type == "postseason", 3, 2)

  base_url <- "https://sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/"

  totals <- ifelse(total == TRUE, 0, "")
  full_url <- paste0(
    base_url,
    year,
    '/types/',s_type,
    '/athletes/', athlete_id,
    '/statistics/', totals
  )
  athlete_url <- paste0(
    base_url,
    year,
    '/athletes/', athlete_id
  )
  cols <- c(
    "general_fumbles",
    "general_fumbles_lost",
    "general_fumbles_forced",
    "general_fumbles_recovered",
    "general_fumbles_touchdowns",
    "general_games_played",
    "general_offensive_two_pt_returns",
    "general_offensive_fumbles_touchdowns",
    "general_defensive_fumbles_touchdowns",
    "passing_avg_gain",
    "passing_completion_pct",
    "passing_completions",
    "passing_espnqb_rating",
    "passing_interception_pct",
    "passing_interceptions",
    "passing_long_passing",
    "passing_misc_yards",
    "passing_net_passing_yards",
    "passing_net_passing_yards_per_game",
    "passing_net_total_yards",
    "passing_net_yards_per_game",
    "passing_passing_attempts",
    "passing_passing_big_plays",
    "passing_passing_first_downs",
    "passing_passing_fumbles",
    "passing_passing_fumbles_lost",
    "passing_passing_touchdown_pct",
    "passing_passing_touchdowns",
    "passing_passing_yards",
    "passing_passing_yards_after_catch",
    "passing_passing_yards_at_catch",
    "passing_passing_yards_per_game",
    "passing_qb_rating",
    "passing_sacks",
    "passing_sack_yards_lost",
    "passing_team_games_played",
    "passing_total_offensive_plays",
    "passing_total_points",
    "passing_total_points_per_game",
    "passing_total_touchdowns",
    "passing_total_yards",
    "passing_total_yards_from_scrimmage",
    "passing_two_point_pass_convs",
    "passing_two_pt_pass",
    "passing_two_pt_pass_attempts",
    "passing_yards_from_scrimmage_per_game",
    "passing_yards_per_completion",
    "passing_yards_per_game",
    "passing_yards_per_pass_attempt",
    "passing_net_yards_per_pass_attempt",
    "passing_quarterback_rating",
    "rushing_avg_gain",
    "rushing_espnrb_rating",
    "rushing_long_rushing",
    "rushing_misc_yards",
    "rushing_net_total_yards",
    "rushing_net_yards_per_game",
    "rushing_rushing_attempts",
    "rushing_rushing_big_plays",
    "rushing_rushing_first_downs",
    "rushing_rushing_fumbles",
    "rushing_rushing_fumbles_lost",
    "rushing_rushing_touchdowns",
    "rushing_rushing_yards",
    "rushing_rushing_yards_per_game",
    "rushing_stuffs",
    "rushing_stuff_yards_lost",
    "rushing_team_games_played",
    "rushing_total_offensive_plays",
    "rushing_total_points",
    "rushing_total_points_per_game",
    "rushing_total_touchdowns",
    "rushing_total_yards",
    "rushing_total_yards_from_scrimmage",
    "rushing_two_point_rush_convs",
    "rushing_two_pt_rush",
    "rushing_two_pt_rush_attempts",
    "rushing_yards_from_scrimmage_per_game",
    "rushing_yards_per_game",
    "rushing_yards_per_rush_attempt",
    "receiving_avg_gain",
    "receiving_espnwr_rating",
    "receiving_long_reception",
    "receiving_misc_yards",
    "receiving_net_total_yards",
    "receiving_net_yards_per_game",
    "receiving_receiving_big_plays",
    "receiving_receiving_first_downs",
    "receiving_receiving_fumbles",
    "receiving_receiving_fumbles_lost",
    "receiving_receiving_targets",
    "receiving_receiving_touchdowns",
    "receiving_receiving_yards",
    "receiving_receiving_yards_after_catch",
    "receiving_receiving_yards_at_catch",
    "receiving_receiving_yards_per_game",
    "receiving_receptions",
    "receiving_team_games_played",
    "receiving_total_offensive_plays",
    "receiving_total_points",
    "receiving_total_points_per_game",
    "receiving_total_touchdowns",
    "receiving_total_yards",
    "receiving_total_yards_from_scrimmage",
    "receiving_two_point_rec_convs",
    "receiving_two_pt_reception",
    "receiving_two_pt_reception_attempts",
    "receiving_yards_from_scrimmage_per_game",
    "receiving_yards_per_game",
    "receiving_yards_per_reception",
    "defensive_assist_tackles",
    "defensive_avg_interception_yards",
    "defensive_avg_sack_yards",
    "defensive_avg_stuff_yards",
    "defensive_blocked_field_goal_touchdowns",
    "defensive_blocked_punt_touchdowns",
    "defensive_defensive_touchdowns",
    "defensive_hurries",
    "defensive_kicks_blocked",
    "defensive_long_interception",
    "defensive_misc_touchdowns",
    "defensive_passes_batted_down",
    "defensive_passes_defended",
    "defensive_two_pt_returns",
    "defensive_sacks",
    "defensive_sack_yards",
    "defensive_safeties",
    "defensive_solo_tackles",
    "defensive_stuffs",
    "defensive_stuff_yards",
    "defensive_tackles_for_loss",
    "defensive_team_games_played",
    "defensive_total_tackles",
    "defensive_yards_allowed",
    "defensive_points_allowed",
    "defensive_one_pt_safeties_made",
    "defensive_interceptions_interceptions",
    "defensive_interceptions_interception_touchdowns",
    "defensive_interceptions_interception_yards",
    "kicking_avg_kickoff_return_yards",
    "kicking_avg_kickoff_yards",
    "kicking_extra_point_attempts",
    "kicking_extra_point_pct",
    "kicking_extra_points_blocked",
    "kicking_extra_points_blocked_pct",
    "kicking_extra_points_made",
    "kicking_fair_catches",
    "kicking_fair_catch_pct",
    "kicking_field_goal_attempts",
    "kicking_field_goal_attempts1_19",
    "kicking_field_goal_attempts20_29",
    "kicking_field_goal_attempts30_39",
    "kicking_field_goal_attempts40_49",
    "kicking_field_goal_attempts50_59",
    "kicking_field_goal_attempts60_99",
    "kicking_field_goal_attempts50",
    "kicking_field_goal_attempt_yards",
    "kicking_field_goal_pct",
    "kicking_field_goals_blocked",
    "kicking_field_goals_blocked_pct",
    "kicking_field_goals_made",
    "kicking_field_goals_made1_19",
    "kicking_field_goals_made20_29",
    "kicking_field_goals_made30_39",
    "kicking_field_goals_made40_49",
    "kicking_field_goals_made50_59",
    "kicking_field_goals_made60_99",
    "kicking_field_goals_made50",
    "kicking_field_goals_made_yards",
    "kicking_field_goals_missed_yards",
    "kicking_kickoff_returns",
    "kicking_kickoff_return_touchdowns",
    "kicking_kickoff_return_yards",
    "kicking_kickoffs",
    "kicking_kickoff_yards",
    "kicking_long_field_goal_attempt",
    "kicking_long_field_goal_made",
    "kicking_long_kickoff",
    "kicking_team_games_played",
    "kicking_total_kicking_points",
    "kicking_touchback_pct",
    "kicking_touchbacks",
    "returning_def_fumble_returns",
    "returning_def_fumble_return_yards",
    "returning_fumble_recoveries",
    "returning_fumble_recovery_yards",
    "returning_kick_return_fair_catches",
    "returning_kick_return_fair_catch_pct",
    "returning_kick_return_fumbles",
    "returning_kick_return_fumbles_lost",
    "returning_kick_returns",
    "returning_kick_return_touchdowns",
    "returning_kick_return_yards",
    "returning_long_kick_return",
    "returning_long_punt_return",
    "returning_misc_fumble_returns",
    "returning_misc_fumble_return_yards",
    "returning_opp_fumble_recoveries",
    "returning_opp_fumble_recovery_yards",
    "returning_opp_special_team_fumble_returns",
    "returning_opp_special_team_fumble_return_yards",
    "returning_punt_return_fair_catches",
    "returning_punt_return_fair_catch_pct",
    "returning_punt_return_fumbles",
    "returning_punt_return_fumbles_lost",
    "returning_punt_returns",
    "returning_punt_returns_started_inside_the10",
    "returning_punt_returns_started_inside_the20",
    "returning_punt_return_touchdowns",
    "returning_punt_return_yards",
    "returning_special_team_fumble_returns",
    "returning_special_team_fumble_return_yards",
    "returning_team_games_played",
    "returning_yards_per_kick_return",
    "returning_yards_per_punt_return",
    "returning_yards_per_return",
    "punting_avg_punt_return_yards",
    "punting_fair_catches",
    "punting_gross_avg_punt_yards",
    "punting_long_punt",
    "punting_net_avg_punt_yards",
    "punting_punt_returns",
    "punting_punt_return_yards",
    "punting_punts",
    "punting_punts_blocked",
    "punting_punts_blocked_pct",
    "punting_punts_inside10",
    "punting_punts_inside10pct",
    "punting_punts_inside20",
    "punting_punts_inside20pct",
    "punting_punt_yards",
    "punting_team_games_played",
    "punting_touchback_pct",
    "punting_touchbacks",
    "scoring_defensive_points",
    "scoring_field_goals",
    "scoring_kick_extra_points",
    "scoring_misc_points",
    "scoring_passing_touchdowns",
    "scoring_receiving_touchdowns",
    "scoring_return_touchdowns",
    "scoring_rushing_touchdowns",
    "scoring_total_points",
    "scoring_total_points_per_game",
    "scoring_total_touchdowns",
    "scoring_total_two_point_convs",
    "scoring_two_point_pass_convs",
    "scoring_two_point_rec_convs",
    "scoring_two_point_rush_convs",
    "scoring_one_pt_safeties_made",
    "miscellaneous_first_downs",
    "miscellaneous_first_downs_passing",
    "miscellaneous_first_downs_penalty",
    "miscellaneous_first_downs_per_game",
    "miscellaneous_first_downs_rushing",
    "miscellaneous_fourth_down_attempts",
    "miscellaneous_fourth_down_conv_pct",
    "miscellaneous_fourth_down_convs",
    "miscellaneous_fumbles_lost",
    "miscellaneous_possession_time_seconds",
    "miscellaneous_redzone_efficiency_pct",
    "miscellaneous_redzone_field_goal_pct",
    "miscellaneous_redzone_scoring_pct",
    "miscellaneous_redzone_touchdown_pct",
    "miscellaneous_third_down_attempts",
    "miscellaneous_third_down_conv_pct",
    "miscellaneous_third_down_convs",
    "miscellaneous_total_giveaways",
    "miscellaneous_total_penalties",
    "miscellaneous_total_penalty_yards",
    "miscellaneous_total_takeaways",
    "miscellaneous_total_drives",
    "miscellaneous_turn_over_differential"
  )

  athlete_cols <- c(
    "athlete_id",
    "athlete_uid",
    "athlete_guid",
    "athlete_type",
    "sdr",
    "first_name",
    "last_name",
    "full_name",
    "display_name",
    "short_name",
    "weight",
    "display_weight",
    "height",
    "display_height",
    "birth_place_city",
    "birth_place_state",
    "birth_place_country",
    "date_of_birth",
    "age",
    "slug",
    "headshot_href",
    "headshot_alt",
    "jersey",
    "position_id",
    "position_name",
    "position_display_name",
    "position_abbreviation",
    "position_leaf",
    "linked",
    "experience_years",
    "experience_display_value",
    "experience_abbreviation",
    "active",
    "status_id",
    "status_name",
    "status_type",
    "status_abbreviation"
  )

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- httr::RETRY("GET", full_url)

      # Check the result
      check_status(res)
      # Create the GET request and set response as res
      athlete_res <- httr::RETRY("GET", athlete_url)

      # Check the result
      check_status(athlete_res)

      athlete_df <- athlete_res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)

      team_url <- athlete_df[["team"]][["$ref"]]

      # Create the GET request and set response as res
      team_res <- httr::RETRY("GET", team_url)

      # Check the result
      check_status(team_res)

      team_df <- team_res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)

      team_df[["links"]] <- NULL
      team_df[["injuries"]] <- NULL
      team_df[["record"]] <- NULL
      team_df[["athletes"]] <- NULL
      team_df[["venue"]] <- NULL
      team_df[["groups"]] <- NULL
      team_df[["ranks"]] <- NULL
      team_df[["statistics"]] <- NULL
      team_df[["leaders"]] <- NULL
      team_df[["links"]] <- NULL
      team_df[["notes"]] <- NULL
      team_df[["franchise"]] <- NULL
      team_df[["againstTheSpreadRecords"]] <- NULL
      team_df[["oddsRecords"]] <- NULL
      team_df[["college"]] <- NULL
      team_df[["transactions"]] <- NULL
      team_df[["leaders"]] <- NULL
      team_df[["depthCharts"]] <- NULL
      team_df[["awards"]] <- NULL
      team_df[["events"]] <- NULL


      team_df <- team_df %>%
        purrr::map_if(is.list,as.data.frame) %>%
        as.data.frame() %>%
        dplyr::select(
          -dplyr::any_of(
            c("logos.width",
              "logos.height",
              "logos.alt",
              "logos.rel..full.",
              "logos.rel..default.",
              "logos.rel..scoreboard.",
              "logos.rel..scoreboard..1",
              "logos.rel..scoreboard.2",
              "logos.lastUpdated",
              "logos.width.1",
              "logos.height.1",
              "logos.alt.1",
              "logos.rel..full..1",
              "logos.rel..dark.",
              "logos.rel..dark..1",
              "logos.lastUpdated.1",
              "logos.width.2",
              "logos.height.2",
              "logos.alt.2",
              "logos.rel..full..2",
              "logos.rel..scoreboard.",
              "logos.lastUpdated.2",
              "logos.width.3",
              "logos.height.3",
              "logos.alt.3",
              "logos.rel..full..3",
              "logos.lastUpdated.3",
              "X.ref",
              "X.ref.1",
              "X.ref.2"))) %>%
        janitor::clean_names()
      colnames(team_df)[1:13] <- paste0("team_",colnames(team_df)[1:13])

      team_df <- team_df %>%
        dplyr::rename(
          "logo_href" = "logos_href",
          "logo_dark_href" = "logos_href_1")

      athlete_df[["links"]] <- NULL
      athlete_df[["injuries"]] <- NULL

      athlete_df <- athlete_df %>%
        purrr::map_if(is.list, as.data.frame) %>%
        tibble::tibble(data=.data$.)

      athlete_df <- athlete_df$data %>%
        as.data.frame() %>%
        dplyr::select(-dplyr::any_of(c("X.ref","X.ref.1","X.ref.2","X.ref.3","X.ref.4","X.ref.5","X.ref.6","X.ref.7","X.ref.8",
                                       "position.X.ref","position.X.ref.1",
                                       "contract.x.ref","contract.x.ref.1","contract.x.ref.2",
                                       "draft.x.ref","draft.x.ref.1"))) %>%
        janitor::clean_names() %>%
        dplyr::rename(
          "athlete_id" = "id",
          "athlete_uid" = "uid",
          "athlete_guid" = "guid",
          "athlete_type" = "type")


      # Get the content and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        purrr::pluck("splits") %>%
        purrr::pluck("categories") %>%
        tidyr::unnest("stats", names_sep="_")
      df <- df %>%
        dplyr::mutate(
          stats_category_name = glue::glue("{.data$name}_{.data$stats_name}")) %>%
        dplyr::select("stats_category_name", "stats_value") %>%
        tidyr::pivot_wider(names_from = "stats_category_name",
                           values_from = "stats_value",
                           values_fn = dplyr::first) %>%
        janitor::clean_names()

      df[cols[!(cols %in% colnames(df))]] <- NA
      athlete_df[athlete_cols[!(athlete_cols %in% colnames(athlete_df))]] <- NA

      df <- athlete_df %>%
        dplyr::bind_cols(df) %>%
        dplyr::bind_cols(team_df)

      df <- df %>%
        make_cfbfastR_data("CFB Player Season stats from ESPN.com",Sys.time())

    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no season player stats data available!"))
    },
    finally = {
    }
  )
  return(df)
}
