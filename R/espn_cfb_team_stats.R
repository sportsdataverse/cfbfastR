
#' @title
#' **Get ESPN college football team stats data**
#' @author Saiem Gilani
#' @param team_id Team ID
#' @param year Year
#' @param season_type (character, default: regular): Season type - regular or postseason
#' @param total (boolean, default: FALSE): Totals
#' @keywords CFB Team Stats
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows
#' @importFrom tidyr unnest unnest_wider everything
#' @export
#' @return Returns a tibble with the following columns:
#'
#'    |col_name                                        |types   |
#'    |:-----------------------------------------------|:-------|
#'    |general_fumbles                                 |numeric |
#'    |general_fumbles_lost                            |numeric |
#'    |general_fumbles_forced                          |numeric |
#'    |general_fumbles_recovered                       |numeric |
#'    |general_fumbles_touchdowns                      |numeric |
#'    |general_games_played                            |numeric |
#'    |general_offensive_two_pt_returns                |numeric |
#'    |general_offensive_fumbles_touchdowns            |numeric |
#'    |general_defensive_fumbles_touchdowns            |numeric |
#'    |passing_avg_gain                                |numeric |
#'    |passing_completion_pct                          |numeric |
#'    |passing_completions                             |numeric |
#'    |passing_espnqb_rating                           |numeric |
#'    |passing_interception_pct                        |numeric |
#'    |passing_interceptions                           |numeric |
#'    |passing_long_passing                            |numeric |
#'    |passing_misc_yards                              |numeric |
#'    |passing_net_passing_yards                       |numeric |
#'    |passing_net_passing_yards_per_game              |numeric |
#'    |passing_net_total_yards                         |numeric |
#'    |passing_net_yards_per_game                      |numeric |
#'    |passing_passing_attempts                        |numeric |
#'    |passing_passing_big_plays                       |numeric |
#'    |passing_passing_first_downs                     |numeric |
#'    |passing_passing_fumbles                         |numeric |
#'    |passing_passing_fumbles_lost                    |numeric |
#'    |passing_passing_touchdown_pct                   |numeric |
#'    |passing_passing_touchdowns                      |numeric |
#'    |passing_passing_yards                           |numeric |
#'    |passing_passing_yards_after_catch               |numeric |
#'    |passing_passing_yards_at_catch                  |numeric |
#'    |passing_passing_yards_per_game                  |numeric |
#'    |passing_qb_rating                               |numeric |
#'    |passing_sacks                                   |numeric |
#'    |passing_sack_yards_lost                         |numeric |
#'    |passing_team_games_played                       |numeric |
#'    |passing_total_offensive_plays                   |numeric |
#'    |passing_total_points                            |numeric |
#'    |passing_total_points_per_game                   |numeric |
#'    |passing_total_touchdowns                        |numeric |
#'    |passing_total_yards                             |numeric |
#'    |passing_total_yards_from_scrimmage              |numeric |
#'    |passing_two_point_pass_convs                    |numeric |
#'    |passing_two_pt_pass                             |numeric |
#'    |passing_two_pt_pass_attempts                    |numeric |
#'    |passing_yards_from_scrimmage_per_game           |numeric |
#'    |passing_yards_per_completion                    |numeric |
#'    |passing_yards_per_game                          |numeric |
#'    |passing_yards_per_pass_attempt                  |numeric |
#'    |passing_net_yards_per_pass_attempt              |numeric |
#'    |passing_quarterback_rating                      |numeric |
#'    |rushing_avg_gain                                |numeric |
#'    |rushing_espnrb_rating                           |numeric |
#'    |rushing_long_rushing                            |numeric |
#'    |rushing_misc_yards                              |numeric |
#'    |rushing_net_total_yards                         |numeric |
#'    |rushing_net_yards_per_game                      |numeric |
#'    |rushing_rushing_attempts                        |numeric |
#'    |rushing_rushing_big_plays                       |numeric |
#'    |rushing_rushing_first_downs                     |numeric |
#'    |rushing_rushing_fumbles                         |numeric |
#'    |rushing_rushing_fumbles_lost                    |numeric |
#'    |rushing_rushing_touchdowns                      |numeric |
#'    |rushing_rushing_yards                           |numeric |
#'    |rushing_rushing_yards_per_game                  |numeric |
#'    |rushing_stuffs                                  |numeric |
#'    |rushing_stuff_yards_lost                        |numeric |
#'    |rushing_team_games_played                       |numeric |
#'    |rushing_total_offensive_plays                   |numeric |
#'    |rushing_total_points                            |numeric |
#'    |rushing_total_points_per_game                   |numeric |
#'    |rushing_total_touchdowns                        |numeric |
#'    |rushing_total_yards                             |numeric |
#'    |rushing_total_yards_from_scrimmage              |numeric |
#'    |rushing_two_point_rush_convs                    |numeric |
#'    |rushing_two_pt_rush                             |numeric |
#'    |rushing_two_pt_rush_attempts                    |numeric |
#'    |rushing_yards_from_scrimmage_per_game           |numeric |
#'    |rushing_yards_per_game                          |numeric |
#'    |rushing_yards_per_rush_attempt                  |numeric |
#'    |receiving_avg_gain                              |numeric |
#'    |receiving_espnwr_rating                         |numeric |
#'    |receiving_long_reception                        |numeric |
#'    |receiving_misc_yards                            |numeric |
#'    |receiving_net_total_yards                       |numeric |
#'    |receiving_net_yards_per_game                    |numeric |
#'    |receiving_receiving_big_plays                   |numeric |
#'    |receiving_receiving_first_downs                 |numeric |
#'    |receiving_receiving_fumbles                     |numeric |
#'    |receiving_receiving_fumbles_lost                |numeric |
#'    |receiving_receiving_targets                     |numeric |
#'    |receiving_receiving_touchdowns                  |numeric |
#'    |receiving_receiving_yards                       |numeric |
#'    |receiving_receiving_yards_after_catch           |numeric |
#'    |receiving_receiving_yards_at_catch              |numeric |
#'    |receiving_receiving_yards_per_game              |numeric |
#'    |receiving_receptions                            |numeric |
#'    |receiving_team_games_played                     |numeric |
#'    |receiving_total_offensive_plays                 |numeric |
#'    |receiving_total_points                          |numeric |
#'    |receiving_total_points_per_game                 |numeric |
#'    |receiving_total_touchdowns                      |numeric |
#'    |receiving_total_yards                           |numeric |
#'    |receiving_total_yards_from_scrimmage            |numeric |
#'    |receiving_two_point_rec_convs                   |numeric |
#'    |receiving_two_pt_reception                      |numeric |
#'    |receiving_two_pt_reception_attempts             |numeric |
#'    |receiving_yards_from_scrimmage_per_game         |numeric |
#'    |receiving_yards_per_game                        |numeric |
#'    |receiving_yards_per_reception                   |numeric |
#'    |defensive_assist_tackles                        |numeric |
#'    |defensive_avg_interception_yards                |numeric |
#'    |defensive_avg_sack_yards                        |numeric |
#'    |defensive_avg_stuff_yards                       |numeric |
#'    |defensive_blocked_field_goal_touchdowns         |numeric |
#'    |defensive_blocked_punt_touchdowns               |numeric |
#'    |defensive_defensive_touchdowns                  |numeric |
#'    |defensive_hurries                               |numeric |
#'    |defensive_kicks_blocked                         |numeric |
#'    |defensive_long_interception                     |numeric |
#'    |defensive_misc_touchdowns                       |numeric |
#'    |defensive_passes_batted_down                    |numeric |
#'    |defensive_passes_defended                       |numeric |
#'    |defensive_two_pt_returns                        |numeric |
#'    |defensive_sacks                                 |numeric |
#'    |defensive_sack_yards                            |numeric |
#'    |defensive_safeties                              |numeric |
#'    |defensive_solo_tackles                          |numeric |
#'    |defensive_stuffs                                |numeric |
#'    |defensive_stuff_yards                           |numeric |
#'    |defensive_tackles_for_loss                      |numeric |
#'    |defensive_team_games_played                     |numeric |
#'    |defensive_total_tackles                         |numeric |
#'    |defensive_yards_allowed                         |numeric |
#'    |defensive_points_allowed                        |numeric |
#'    |defensive_one_pt_safeties_made                  |numeric |
#'    |defensive_interceptions_interceptions           |numeric |
#'    |defensive_interceptions_interception_touchdowns |numeric |
#'    |defensive_interceptions_interception_yards      |numeric |
#'    |kicking_avg_kickoff_return_yards                |numeric |
#'    |kicking_avg_kickoff_yards                       |numeric |
#'    |kicking_extra_point_attempts                    |numeric |
#'    |kicking_extra_point_pct                         |numeric |
#'    |kicking_extra_points_blocked                    |numeric |
#'    |kicking_extra_points_blocked_pct                |numeric |
#'    |kicking_extra_points_made                       |numeric |
#'    |kicking_fair_catches                            |numeric |
#'    |kicking_fair_catch_pct                          |numeric |
#'    |kicking_field_goal_attempts                     |numeric |
#'    |kicking_field_goal_attempts1_19                 |numeric |
#'    |kicking_field_goal_attempts20_29                |numeric |
#'    |kicking_field_goal_attempts30_39                |numeric |
#'    |kicking_field_goal_attempts40_49                |numeric |
#'    |kicking_field_goal_attempts50_59                |numeric |
#'    |kicking_field_goal_attempts60_99                |numeric |
#'    |kicking_field_goal_attempts50                   |numeric |
#'    |kicking_field_goal_attempt_yards                |numeric |
#'    |kicking_field_goal_pct                          |numeric |
#'    |kicking_field_goals_blocked                     |numeric |
#'    |kicking_field_goals_blocked_pct                 |numeric |
#'    |kicking_field_goals_made                        |numeric |
#'    |kicking_field_goals_made1_19                    |numeric |
#'    |kicking_field_goals_made20_29                   |numeric |
#'    |kicking_field_goals_made30_39                   |numeric |
#'    |kicking_field_goals_made40_49                   |numeric |
#'    |kicking_field_goals_made50_59                   |numeric |
#'    |kicking_field_goals_made60_99                   |numeric |
#'    |kicking_field_goals_made50                      |numeric |
#'    |kicking_field_goals_made_yards                  |numeric |
#'    |kicking_field_goals_missed_yards                |numeric |
#'    |kicking_kickoff_returns                         |numeric |
#'    |kicking_kickoff_return_touchdowns               |numeric |
#'    |kicking_kickoff_return_yards                    |numeric |
#'    |kicking_kickoffs                                |numeric |
#'    |kicking_kickoff_yards                           |numeric |
#'    |kicking_long_field_goal_attempt                 |numeric |
#'    |kicking_long_field_goal_made                    |numeric |
#'    |kicking_long_kickoff                            |numeric |
#'    |kicking_team_games_played                       |numeric |
#'    |kicking_total_kicking_points                    |numeric |
#'    |kicking_touchback_pct                           |numeric |
#'    |kicking_touchbacks                              |numeric |
#'    |returning_def_fumble_returns                    |numeric |
#'    |returning_def_fumble_return_yards               |numeric |
#'    |returning_fumble_recoveries                     |numeric |
#'    |returning_fumble_recovery_yards                 |numeric |
#'    |returning_kick_return_fair_catches              |numeric |
#'    |returning_kick_return_fair_catch_pct            |numeric |
#'    |returning_kick_return_fumbles                   |numeric |
#'    |returning_kick_return_fumbles_lost              |numeric |
#'    |returning_kick_returns                          |numeric |
#'    |returning_kick_return_touchdowns                |numeric |
#'    |returning_kick_return_yards                     |numeric |
#'    |returning_long_kick_return                      |numeric |
#'    |returning_long_punt_return                      |numeric |
#'    |returning_misc_fumble_returns                   |numeric |
#'    |returning_misc_fumble_return_yards              |numeric |
#'    |returning_opp_fumble_recoveries                 |numeric |
#'    |returning_opp_fumble_recovery_yards             |numeric |
#'    |returning_opp_special_team_fumble_returns       |numeric |
#'    |returning_opp_special_team_fumble_return_yards  |numeric |
#'    |returning_punt_return_fair_catches              |numeric |
#'    |returning_punt_return_fair_catch_pct            |numeric |
#'    |returning_punt_return_fumbles                   |numeric |
#'    |returning_punt_return_fumbles_lost              |numeric |
#'    |returning_punt_returns                          |numeric |
#'    |returning_punt_returns_started_inside_the10     |numeric |
#'    |returning_punt_returns_started_inside_the20     |numeric |
#'    |returning_punt_return_touchdowns                |numeric |
#'    |returning_punt_return_yards                     |numeric |
#'    |returning_special_team_fumble_returns           |numeric |
#'    |returning_special_team_fumble_return_yards      |numeric |
#'    |returning_team_games_played                     |numeric |
#'    |returning_yards_per_kick_return                 |numeric |
#'    |returning_yards_per_punt_return                 |numeric |
#'    |returning_yards_per_return                      |numeric |
#'    |punting_avg_punt_return_yards                   |numeric |
#'    |punting_fair_catches                            |numeric |
#'    |punting_gross_avg_punt_yards                    |numeric |
#'    |punting_long_punt                               |numeric |
#'    |punting_net_avg_punt_yards                      |numeric |
#'    |punting_punt_returns                            |numeric |
#'    |punting_punt_return_yards                       |numeric |
#'    |punting_punts                                   |numeric |
#'    |punting_punts_blocked                           |numeric |
#'    |punting_punts_blocked_pct                       |numeric |
#'    |punting_punts_inside10                          |numeric |
#'    |punting_punts_inside10pct                       |numeric |
#'    |punting_punts_inside20                          |numeric |
#'    |punting_punts_inside20pct                       |numeric |
#'    |punting_punt_yards                              |numeric |
#'    |punting_team_games_played                       |numeric |
#'    |punting_touchback_pct                           |numeric |
#'    |punting_touchbacks                              |numeric |
#'    |scoring_defensive_points                        |numeric |
#'    |scoring_field_goals                             |numeric |
#'    |scoring_kick_extra_points                       |numeric |
#'    |scoring_misc_points                             |numeric |
#'    |scoring_passing_touchdowns                      |numeric |
#'    |scoring_receiving_touchdowns                    |numeric |
#'    |scoring_return_touchdowns                       |numeric |
#'    |scoring_rushing_touchdowns                      |numeric |
#'    |scoring_total_points                            |numeric |
#'    |scoring_total_points_per_game                   |numeric |
#'    |scoring_total_touchdowns                        |numeric |
#'    |scoring_total_two_point_convs                   |numeric |
#'    |scoring_two_point_pass_convs                    |numeric |
#'    |scoring_two_point_rec_convs                     |numeric |
#'    |scoring_two_point_rush_convs                    |numeric |
#'    |scoring_one_pt_safeties_made                    |numeric |
#'    |miscellaneous_first_downs                       |numeric |
#'    |miscellaneous_first_downs_passing               |numeric |
#'    |miscellaneous_first_downs_penalty               |numeric |
#'    |miscellaneous_first_downs_per_game              |numeric |
#'    |miscellaneous_first_downs_rushing               |numeric |
#'    |miscellaneous_fourth_down_attempts              |numeric |
#'    |miscellaneous_fourth_down_conv_pct              |numeric |
#'    |miscellaneous_fourth_down_convs                 |numeric |
#'    |miscellaneous_fumbles_lost                      |numeric |
#'    |miscellaneous_possession_time_seconds           |numeric |
#'    |miscellaneous_redzone_efficiency_pct            |numeric |
#'    |miscellaneous_redzone_field_goal_pct            |numeric |
#'    |miscellaneous_redzone_scoring_pct               |numeric |
#'    |miscellaneous_redzone_touchdown_pct             |numeric |
#'    |miscellaneous_third_down_attempts               |numeric |
#'    |miscellaneous_third_down_conv_pct               |numeric |
#'    |miscellaneous_third_down_convs                  |numeric |
#'    |miscellaneous_total_giveaways                   |numeric |
#'    |miscellaneous_total_penalties                   |numeric |
#'    |miscellaneous_total_penalty_yards               |numeric |
#'    |miscellaneous_total_takeaways                   |numeric |
#'    |miscellaneous_total_drives                      |numeric |
#'    |miscellaneous_turn_over_differential            |numeric |
#'
#' @examples
#' \donttest{
#'   try(espn_cfb_team_stats(team_id = 52, year = 2020))
#' }
#'
espn_cfb_team_stats <- function(team_id, year, season_type='regular', total=FALSE){
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
    '/teams/',team_id,
    '/statistics/', totals
  )

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- httr::RETRY("GET", full_url)

      # Check the result
      check_status(res)

      # Get the content and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        purrr::pluck("splits") %>%
        purrr::pluck("categories") %>%
        tidyr::unnest(.data$stats, names_sep="_")
      df <- df %>%
        dplyr::mutate(
          stats_category_name = glue::glue("{.data$name}_{.data$stats_name}")) %>%
        dplyr::select(.data$stats_category_name, .data$stats_value) %>%
        tidyr::pivot_wider(names_from = .data$stats_category_name,
                           values_from = .data$stats_value,
                           values_fn = dplyr::first) %>%
        janitor::clean_names()

      df <- df %>%
        make_cfbfastR_data("Season stats from ESPN.com",Sys.time())

    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no season team stats data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
