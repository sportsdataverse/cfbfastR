# Release-dataset loaders -- thin wrappers around rds_from_url() /
# parquet_from_url() following the wehoop load_ncaa_wbb.R shape. Backed by
# the sportsdataverse-data release tags produced by the cfbfastR-cfb-data /
# cfbfastR-cfb-raw pipelines. GENERATED once from sdv-py loader schemas
# (tools/codegen/schemas/loader_schemas.yaml) on 2026-08-24; maintained by
# hand from here on.

#' **Load ESPN college football play-by-play from the SportsDataverse data repo**
#' @name load_espn_cfb_pbp
NULL
#' @title
#' **Load ESPN college football play-by-play from the SportsDataverse data repo**
#' @rdname load_espn_cfb_pbp
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_pbp (sportsdataverse-data release). Published to the
#'   `espn_cfb_pbp` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                                |types     |description |
#'    |----------------------------------------|----------|:-----------|
#'    |season                                  |integer   | |
#'    |game_id                                 |integer   | |
#'    |game_play_number                        |integer   | |
#'    |pos_team                                |integer   | |
#'    |def_pos_team                            |integer   | |
#'    |pos_team_score                          |integer   | |
#'    |def_pos_team_score                      |integer   | |
#'    |half                                    |integer   | |
#'    |period                                  |integer   | |
#'    |down                                    |integer   | |
#'    |distance                                |integer   | |
#'    |EPA                                     |double    | |
#'    |wpa                                     |double    | |
#'    |wp_before                               |double    | |
#'    |wp_after                                |double    | |
#'    |def_wp_before                           |double    | |
#'    |def_wp_after                            |double    | |
#'    |penalty_detail                          |character | |
#'    |yds_penalty                             |character | |
#'    |penalty_1st_conv                        |logical   | |
#'    |def_EPA                                 |double    | |
#'    |rz_play                                 |logical   | |
#'    |scoring_opp                             |logical   | |
#'    |middle_8                                |logical   | |
#'    |stuffed_run                             |logical   | |
#'    |change_of_pos_team                      |logical   | |
#'    |downs_turnover                          |logical   | |
#'    |pos_score_diff_start                    |integer   | |
#'    |pos_score_pts                           |integer   | |
#'    |home_wp_before                          |double    | |
#'    |away_wp_before                          |double    | |
#'    |home_wp_after                           |double    | |
#'    |away_wp_after                           |double    | |
#'    |end_of_half                             |logical   | |
#'    |lead_pos_team                           |integer   |Value of pos_team on the next play, used for sequence-aware derivations. |
#'    |lead_play_type                          |character |Value of play_type on the next play, used for sequence-aware derivations. |
#'    |lag_pos_team                            |integer   |Value of pos_team on the previous play, used for sequence-aware derivations. |
#'    |orig_play_type                          |character | |
#'    |offense_score_play                      |logical   | |
#'    |defense_score_play                      |logical   | |
#'    |pos_score_diff                          |integer   | |
#'    |change_of_poss                          |logical   | |
#'    |rusher_player_name                      |character | |
#'    |yds_rushed                              |integer   | |
#'    |passer_player_name                      |character | |
#'    |receiver_player_name                    |character | |
#'    |yds_receiving                           |integer   | |
#'    |yds_sacked                              |integer   | |
#'    |sack_players                            |character | |
#'    |sack_player_name                        |character | |
#'    |sack_player_name2                       |character | |
#'    |pass_breakup_player_name                |character | |
#'    |interception_player_name                |character | |
#'    |yds_int_return                          |integer   | |
#'    |fumble_player_name                      |character | |
#'    |fumble_forced_player_name               |character | |
#'    |fumble_recovered_player_name            |character | |
#'    |yds_fumble_return                       |integer   | |
#'    |punter_player_name                      |character | |
#'    |yds_punted                              |integer   | |
#'    |yds_punt_return                         |integer   | |
#'    |yds_punt_gained                         |integer   | |
#'    |punt_block_player_name                  |character | |
#'    |punt_block_return_player_name           |character | |
#'    |fg_kicker_player_name                   |character | |
#'    |yds_fg                                  |integer   | |
#'    |fg_block_player_name                    |character | |
#'    |fg_return_player_name                   |character | |
#'    |kickoff_player_name                     |character | |
#'    |yds_kickoff                             |integer   | |
#'    |yds_kickoff_return                      |integer   | |
#'    |rush                                    |logical   | |
#'    |rush_td                                 |logical   | |
#'    |pass                                    |logical   | |
#'    |pass_td                                 |logical   | |
#'    |completion                              |logical   | |
#'    |pass_attempt                            |logical   | |
#'    |target                                  |logical   | |
#'    |sack_vec                                |logical   | |
#'    |sack                                    |logical   | |
#'    |int                                     |logical   | |
#'    |int_td                                  |logical   | |
#'    |turnover_vec                            |logical   | |
#'    |kickoff_play                            |logical   | |
#'    |scoring_play                            |logical   | |
#'    |td_play                                 |logical   | |
#'    |touchdown                               |logical   | |
#'    |safety                                  |logical   | |
#'    |fumble_vec                              |logical   | |
#'    |kickoff_tb                              |logical   | |
#'    |kickoff_onside                          |logical   | |
#'    |kickoff_oob                             |logical   | |
#'    |kickoff_fair_catch                      |logical   | |
#'    |kickoff_downed                          |logical   | |
#'    |kickoff_safety                          |logical   | |
#'    |kick_play                               |logical   | |
#'    |punt                                    |logical   | |
#'    |punt_play                               |logical   | |
#'    |punt_tb                                 |logical   | |
#'    |punt_oob                                |logical   | |
#'    |punt_fair_catch                         |logical   | |
#'    |punt_downed                             |logical   | |
#'    |punt_safety                             |logical   | |
#'    |punt_blocked                            |logical   | |
#'    |penalty_safety                          |logical   | |
#'    |fg_made                                 |logical   | |
#'    |fg_make_prob                            |double    | |
#'    |penalty_flag                            |logical   | |
#'    |penalty_declined                        |logical   | |
#'    |penalty_no_play                         |logical   | |
#'    |penalty_offset                          |logical   | |
#'    |penalty_text                            |character | |
#'    |lead_wp_before2                         |double    |Value of wp_before 2 plays ahead, used for sequence-aware derivations. |
#'    |lead_wp_before                          |double    |Value of wp_before on the next play, used for sequence-aware derivations. |
#'    |lead_pos_team2                          |integer   |Value of pos_team 2 plays ahead, used for sequence-aware derivations. |
#'    |lag_change_of_pos_team                  |logical   |Value of change_of_pos_team on the previous play, used for sequence-aware derivations. |
#'    |lag_pos_score_diff                      |integer   |Value of pos_score_diff on the previous play, used for sequence-aware derivations. |
#'    |id                                      |integer   | |
#'    |sequenceNumber                          |integer   | |
#'    |text                                    |character | |
#'    |awayScore                               |integer   | |
#'    |homeScore                               |integer   | |
#'    |scoringPlay                             |logical   |ESPN flag marking the play as a scoring play. |
#'    |priority                                |logical   | |
#'    |modified                                |character | |
#'    |wallclock                               |character | |
#'    |teamParticipants                        |character | |
#'    |isPenalty                               |logical   | |
#'    |statYardage                             |integer   |Yardage ESPN credits to the play for statistical purposes. |
#'    |isTurnover                              |logical   | |
#'    |type.id                                 |character |ESPN's numeric identifier for the play type. |
#'    |type.text                               |character |ESPN's text label for the play type. |
#'    |type.abbreviation                       |character |ESPN's abbreviation for the play type. |
#'    |period.number                           |integer   |Period (quarter) number in which the play occurred. |
#'    |clock.displayValue                      |character |Game clock at the play, as the displayed mm:ss string. |
#'    |start.down                              |integer   |ESPN's `down` value for the play state at the start of the play. |
#'    |start.distance                          |integer   |ESPN's `distance` value for the play state at the start of the play. |
#'    |start.yardLine                          |integer   |ESPN's `yardLine` value for the play state at the start of the play. |
#'    |start.yardsToEndzone                    |integer   |ESPN's `yardsToEndzone` value for the play state at the start of the play. |
#'    |start.team.id                           |integer   |ESPN's `team.id` value for the play state at the start of the play. |
#'    |end.down                                |integer   |ESPN's `down` value for the play state at the end of the play. |
#'    |end.distance                            |integer   |ESPN's `distance` value for the play state at the end of the play. |
#'    |end.yardLine                            |integer   |ESPN's `yardLine` value for the play state at the end of the play. |
#'    |end.yardsToEndzone                      |integer   |ESPN's `yardsToEndzone` value for the play state at the end of the play. |
#'    |end.downDistanceText                    |character |ESPN's `downDistanceText` value for the play state at the end of the play. |
#'    |end.shortDownDistanceText               |character |ESPN's `shortDownDistanceText` value for the play state at the end of the play. |
#'    |end.possessionText                      |character |ESPN's `possessionText` value for the play state at the end of the play. |
#'    |end.team.id                             |integer   |ESPN's `team.id` value for the play state at the end of the play. |
#'    |start.downDistanceText                  |character |ESPN's `downDistanceText` value for the play state at the start of the play. |
#'    |start.shortDownDistanceText             |character |ESPN's `shortDownDistanceText` value for the play state at the start of the play. |
#'    |start.possessionText                    |character |ESPN's `possessionText` value for the play state at the start of the play. |
#'    |scoringType.name                        |character |ESPN's name for the scoring type (e.g. touchdown, field goal). |
#'    |scoringType.displayName                 |character |ESPN's display label for the scoring type. |
#'    |scoringType.abbreviation                |character |ESPN's abbreviation for the scoring type. |
#'    |pointAfterAttempt.id                    |double    | |
#'    |pointAfterAttempt.text                  |character | |
#'    |pointAfterAttempt.abbreviation          |character | |
#'    |pointAfterAttempt.value                 |double    | |
#'    |drive.id                                |character |ESPN's `id` field for the drive containing this play. |
#'    |drive.displayResult                     |character |ESPN's `displayResult` field for the drive containing this play. |
#'    |drive.isScore                           |logical   |ESPN's `isScore` field for the drive containing this play. |
#'    |drive.team.shortDisplayName             |character |ESPN's `team.shortDisplayName` field for the drive containing this play. |
#'    |drive.team.displayName                  |character |ESPN's `team.displayName` field for the drive containing this play. |
#'    |drive.team.name                         |character |ESPN's `team.name` field for the drive containing this play. |
#'    |drive.team.abbreviation                 |character |ESPN's `team.abbreviation` field for the drive containing this play. |
#'    |drive.yards                             |integer   |ESPN's `yards` field for the drive containing this play. |
#'    |drive.offensivePlays                    |integer   |ESPN's `offensivePlays` field for the drive containing this play. |
#'    |drive.result                            |character |ESPN's `result` field for the drive containing this play. |
#'    |drive.description                       |character |ESPN's `description` field for the drive containing this play. |
#'    |drive.shortDisplayResult                |character |ESPN's `shortDisplayResult` field for the drive containing this play. |
#'    |drive.timeElapsed.displayValue          |character |ESPN's `timeElapsed.displayValue` field for the drive containing this play. |
#'    |drive.start.period.number               |integer   |ESPN's `start.period.number` field for the drive containing this play. |
#'    |drive.start.period.type                 |character |ESPN's `start.period.type` field for the drive containing this play. |
#'    |drive.start.yardLine                    |integer   |ESPN's `start.yardLine` field for the drive containing this play. |
#'    |drive.start.clock.displayValue          |character |ESPN's `start.clock.displayValue` field for the drive containing this play. |
#'    |drive.start.text                        |character |ESPN's `start.text` field for the drive containing this play. |
#'    |drive.end.period.number                 |integer   |ESPN's `end.period.number` field for the drive containing this play. |
#'    |drive.end.period.type                   |character |ESPN's `end.period.type` field for the drive containing this play. |
#'    |drive.end.yardLine                      |integer   |ESPN's `end.yardLine` field for the drive containing this play. |
#'    |drive.end.clock.displayValue            |character |ESPN's `end.clock.displayValue` field for the drive containing this play. |
#'    |seasonType                              |integer   |ESPN season type for the game (2 = regular season, 3 = postseason). |
#'    |week                                    |integer   | |
#'    |status_type_completed                   |logical   | |
#'    |homeTeamId                              |integer   |ESPN's home-team Id for the game, stamped on every play. |
#'    |awayTeamId                              |integer   |ESPN's away-team Id for the game, stamped on every play. |
#'    |homeTeamName                            |character |ESPN's home-team Name for the game, stamped on every play. |
#'    |awayTeamName                            |character |ESPN's away-team Name for the game, stamped on every play. |
#'    |homeTeamMascot                          |character |ESPN's home-team Mascot for the game, stamped on every play. |
#'    |awayTeamMascot                          |character |ESPN's away-team Mascot for the game, stamped on every play. |
#'    |homeTeamAbbrev                          |character |ESPN's home-team Abbrev for the game, stamped on every play. |
#'    |awayTeamAbbrev                          |character |ESPN's away-team Abbrev for the game, stamped on every play. |
#'    |homeTeamNameAlt                         |character |ESPN's home-team NameAlt for the game, stamped on every play. |
#'    |awayTeamNameAlt                         |character |ESPN's away-team NameAlt for the game, stamped on every play. |
#'    |gameSpread                              |double    |Point spread used as an input to the win-probability model. |
#'    |homeFavorite                            |logical   |True when the home team was favoured by the spread. |
#'    |gameSpreadAvailable                     |logical   |True when a spread was available for the game. |
#'    |overUnder                               |double    |Over/under total used as a model input. |
#'    |homeTeamSpread                          |double    |ESPN's home-team Spread for the game, stamped on every play. |
#'    |clock.minutes                           |integer   |Minutes remaining on the game clock at the play. |
#'    |clock.seconds                           |integer   |Seconds component of the game clock at the play. |
#'    |lag_half                                |integer   |Value of half on the previous play, used for sequence-aware derivations. |
#'    |lead_half                               |integer   |Value of half on the next play, used for sequence-aware derivations. |
#'    |start.TimeSecsRem                       |integer   |ESPN's `TimeSecsRem` value for the play state at the start of the play. |
#'    |start.adj_TimeSecsRem                   |integer   |ESPN's `adj_TimeSecsRem` value for the play state at the start of the play. |
#'    |lead_text                               |character |Value of text on the next play, used for sequence-aware derivations. |
#'    |lead_start_team                         |character |Value of start_team on the next play, used for sequence-aware derivations. |
#'    |lead_start_yardsToEndzone               |integer   |Value of start_yardsToEndzone on the next play, used for sequence-aware derivations. |
#'    |lead_start_down                         |integer   |Value of start_down on the next play, used for sequence-aware derivations. |
#'    |lead_start_distance                     |integer   |Value of start_distance on the next play, used for sequence-aware derivations. |
#'    |lead_scoringPlay                        |logical   |Value of scoringPlay on the next play, used for sequence-aware derivations. |
#'    |text_dupe                               |logical   |True when the play description duplicates the previous row's text. |
#'    |end_state_missing                       |logical   | |
#'    |start.pos_team.id                       |integer   |ESPN's `pos_team.id` value for the play state at the start of the play. |
#'    |start.def_pos_team.id                   |integer   |ESPN's `def_pos_team.id` value for the play state at the start of the play. |
#'    |end.def_pos_team.id                     |integer   |ESPN's `def_pos_team.id` value for the play state at the end of the play. |
#'    |end.pos_team.id                         |integer   |ESPN's `pos_team.id` value for the play state at the end of the play. |
#'    |start.pos_team.name                     |character |ESPN's `pos_team.name` value for the play state at the start of the play. |
#'    |start.def_pos_team.name                 |character |ESPN's `def_pos_team.name` value for the play state at the start of the play. |
#'    |end.pos_team.name                       |character |ESPN's `pos_team.name` value for the play state at the end of the play. |
#'    |end.def_pos_team.name                   |character |ESPN's `def_pos_team.name` value for the play state at the end of the play. |
#'    |start.is_home                           |logical   |ESPN's `is_home` value for the play state at the start of the play. |
#'    |end.is_home                             |logical   |ESPN's `is_home` value for the play state at the end of the play. |
#'    |homeTimeoutCalled                       |logical   |True when the home team called a timeout on the play. |
#'    |awayTimeoutCalled                       |logical   |True when the away team called a timeout on the play. |
#'    |end.homeTeamTimeouts                    |integer   |ESPN's `homeTeamTimeouts` value for the play state at the end of the play. |
#'    |end.awayTeamTimeouts                    |integer   |ESPN's `awayTeamTimeouts` value for the play state at the end of the play. |
#'    |start.homeTeamTimeouts                  |integer   |ESPN's `homeTeamTimeouts` value for the play state at the start of the play. |
#'    |start.awayTeamTimeouts                  |integer   |ESPN's `awayTeamTimeouts` value for the play state at the start of the play. |
#'    |end.TimeSecsRem                         |integer   |ESPN's `TimeSecsRem` value for the play state at the end of the play. |
#'    |end.adj_TimeSecsRem                     |integer   |ESPN's `adj_TimeSecsRem` value for the play state at the end of the play. |
#'    |start.posTeamTimeouts                   |integer   |ESPN's `posTeamTimeouts` value for the play state at the start of the play. |
#'    |start.defPosTeamTimeouts                |integer   |ESPN's `defPosTeamTimeouts` value for the play state at the start of the play. |
#'    |end.posTeamTimeouts                     |integer   |ESPN's `posTeamTimeouts` value for the play state at the end of the play. |
#'    |end.defPosTeamTimeouts                  |integer   |ESPN's `defPosTeamTimeouts` value for the play state at the end of the play. |
#'    |firstHalfKickoffTeamId                  |integer   |ESPN id of the team that received the opening kickoff. |
#'    |start.yard                              |integer   |ESPN's `yard` value for the play state at the start of the play. |
#'    |end.yard                                |integer   |ESPN's `yard` value for the play state at the end of the play. |
#'    |lag_scoringPlay                         |logical   |Value of scoringPlay on the previous play, used for sequence-aware derivations. |
#'    |down_1                                  |logical   |True when it is 1st down at the start of the play. |
#'    |down_2                                  |logical   |True when it is 2nd down at the start of the play. |
#'    |down_3                                  |logical   |True when it is 3rd down at the start of the play. |
#'    |down_4                                  |logical   |True when it is 4th down at the start of the play. |
#'    |down_1_end                              |logical   |True when it is 1st down at the end of the play. |
#'    |down_2_end                              |logical   |True when it is 2nd down at the end of the play. |
#'    |down_3_end                              |logical   |True when it is 3rd down at the end of the play. |
#'    |down_4_end                              |logical   |True when it is 4th down at the end of the play. |
#'    |td_check                                |logical   |Internal flag used while reconciling whether the play produced a touchdown. |
#'    |forced_fumble                           |logical   |True when the defense forced a fumble on the play. |
#'    |is_home                                 |logical   | |
#'    |lag_HA_score_diff                       |integer   |Value of HA_score_diff on the previous play, used for sequence-aware derivations. |
#'    |HA_score_diff                           |integer   |Home score minus away score for the play. |
#'    |net_HA_score_pts                        |integer   |Net points the play added to the home-minus-away score margin. |
#'    |H_score_diff                            |integer   |Home team's score minus the away team's, from the home perspective. |
#'    |A_score_diff                            |integer   |Away team's score minus the home team's, from the away perspective. |
#'    |lag_homeScore                           |integer   |Value of homeScore on the previous play, used for sequence-aware derivations. |
#'    |lag_awayScore                           |integer   |Value of awayScore on the previous play, used for sequence-aware derivations. |
#'    |start.homeScore                         |integer   |ESPN's `homeScore` value for the play state at the start of the play. |
#'    |start.awayScore                         |integer   |ESPN's `awayScore` value for the play state at the start of the play. |
#'    |end.homeScore                           |integer   |ESPN's `homeScore` value for the play state at the end of the play. |
#'    |end.awayScore                           |integer   |ESPN's `awayScore` value for the play state at the end of the play. |
#'    |start.pos_team_score                    |integer   |ESPN's `pos_team_score` value for the play state at the start of the play. |
#'    |start.def_pos_team_score                |integer   |ESPN's `def_pos_team_score` value for the play state at the start of the play. |
#'    |start.pos_score_diff                    |integer   |ESPN's `pos_score_diff` value for the play state at the start of the play. |
#'    |end.pos_team_score                      |integer   |ESPN's `pos_team_score` value for the play state at the end of the play. |
#'    |end.def_pos_team_score                  |integer   |ESPN's `def_pos_team_score` value for the play state at the end of the play. |
#'    |end.pos_score_diff                      |integer   |ESPN's `pos_score_diff` value for the play state at the end of the play. |
#'    |start.pos_team_receives_2H_kickoff      |logical   |ESPN's `pos_team_receives_2H_kickoff` value for the play state at the start of the play. |
#'    |end.pos_team_receives_2H_kickoff        |logical   |ESPN's `pos_team_receives_2H_kickoff` value for the play state at the end of the play. |
#'    |penalty_in_text                         |logical   |True when the play description mentions a penalty. |
#'    |pass_breakup                            |logical   |True when a defender broke up the pass. |
#'    |pass_depth                              |character | |
#'    |pass_direction                          |character | |
#'    |rush_direction                          |character | |
#'    |qb_hurry                                |logical   | |
#'    |fg_attempt                              |logical   |True when the play was a field-goal attempt. |
#'    |pos_unit                                |character | |
#'    |def_pos_unit                            |character | |
#'    |sp                                      |logical   | |
#'    |play                                    |logical   | |
#'    |cleaned_text                            |character | |
#'    |kneel_down                              |logical   | |
#'    |scrimmage_play                          |logical   |True when the play is a play from scrimmage rather than a special-teams or administrative row. |
#'    |pos_score_diff_end                      |integer   |Score differential from the possessing team's perspective at the end of the play. |
#'    |fumble_lost                             |logical   | |
#'    |fumble_recovered                        |logical   |True when a fumble on the play was recovered. |
#'    |field_goal_result                       |character | |
#'    |extra_point_result                      |character | |
#'    |two_point_conv_result                   |character | |
#'    |air_yardsToEndzone                      |integer   | |
#'    |air_yards                               |integer   | |
#'    |yards_after_catch                       |integer   | |
#'    |kicking_team                            |integer   | |
#'    |return_team                             |integer   | |
#'    |fumble_or_muff                          |logical   | |
#'    |recovery_team                           |integer   | |
#'    |recovery_team_2                         |integer   | |
#'    |fumbling_team                           |integer   | |
#'    |int_turnover                            |logical   | |
#'    |pos_fumble_lost                         |logical   | |
#'    |def_fumble_lost                         |logical   | |
#'    |is_pos_team_turnover                    |logical   | |
#'    |is_def_pos_team_turnover                |logical   | |
#'    |is_turnover                             |logical   | |
#'    |turnover_team                           |integer   | |
#'    |is_st_turnover                          |logical   | |
#'    |is_blocked_punt_turnover                |logical   | |
#'    |is_blocked_fg_turnover                  |logical   | |
#'    |sack_team                               |integer   | |
#'    |interception_team                       |integer   | |
#'    |pass_breakup_team                       |integer   | |
#'    |forced_fumble_team                      |integer   | |
#'    |fumble_recovery_team                    |integer   | |
#'    |punt_return_team                        |integer   | |
#'    |kick_return_team                        |integer   | |
#'    |fg_team                                 |integer   | |
#'    |punt_team                               |integer   | |
#'    |penalized_team                          |integer   | |
#'    |penalty_yards_signed                    |integer   | |
#'    |new_down                                |integer   |Down after the play, including any penalty enforcement. |
#'    |new_distance                            |integer   |Distance to go after the play, including any penalty enforcement. |
#'    |under_2                                 |logical   | |
#'    |goal_to_go                              |logical   | |
#'    |stopped_run                             |logical   |True when the rush was stopped at or behind the line of scrimmage. |
#'    |opportunity_run                         |logical   |True when a rush reached 4 yards -- the carries on which the blocking did its job. Matches cfbfastR's espn_cfb_15 definition. Assets published before the 2026-08 fix carry the inverted (4 yards or fewer) flag. |
#'    |highlight_run                           |logical   |True when the rush gained 8 or more yards. |
#'    |adj_rush_yardage                        |integer   |Rushing yards capped at 8, the input to the line-yards decomposition. |
#'    |line_yards                              |double    |Yards credited to the offensive line on a rush, using the standard sliding scale: 1.2x the capped yardage on a loss, all of it through 3 yards, half of each yard from 4 to 8, and a 5.5-yard ceiling beyond that. |
#'    |second_level_yards                      |double    |Rushing yards earned from 4 to 8, split evenly between line and carrier under the line-yards decomposition. |
#'    |open_field_yards                        |integer   |Rushing yards gained beyond 8, credited to the ball carrier rather than the line. |
#'    |highlight_yards                         |double    |Second-level plus open-field yards -- the yardage credited to the carrier. |
#'    |opp_highlight_yards                     |double    |Highlight yards earned on opportunity runs, isolating carrier production on carries where the blocking succeeded. Assets published before the 2026-08 fix are identically 0 here, because the inverted opportunity_run gate could never co-occur with non-zero highlight yards. |
#'    |short_rush_success                      |logical   |True when a short-yardage rush gained the yardage needed. |
#'    |short_rush_attempt                      |logical   |True when the play is a rush in a short-yardage situation. |
#'    |power_rush_success                      |logical   |True when a power rushing attempt gained the yardage needed. |
#'    |power_rush_attempt                      |logical   |True when the play is a short-yardage power rushing attempt. |
#'    |early_down                              |logical   |True when the play is a scrimmage play on first or second down. |
#'    |late_down                               |logical   |True when the play is a scrimmage play on third or fourth down. |
#'    |early_down_pass                         |logical   |True when the play is a pass on an early down. |
#'    |early_down_rush                         |logical   |True when the play is a rush on an early down. |
#'    |late_down_pass                          |logical   |True when the play is a pass on a late down. |
#'    |late_down_rush                          |logical   |True when the play is a rush on a late down. |
#'    |standard_down                           |logical   |True when the offense is on schedule for the series -- first down, second down needing fewer than 8, or third/fourth down needing fewer than 5. |
#'    |passing_down                            |logical   |True when the offense is behind schedule for the series -- second down needing 8 or more, or third/fourth down needing 5 or more. |
#'    |TFL                                     |logical   |True when the play was a tackle for loss. |
#'    |TFL_pass                                |logical   |True when the play was a tackle for loss on a pass play (a sack). |
#'    |TFL_rush                                |logical   |True when the play was a tackle for loss on a rush play. |
#'    |havoc                                   |logical   |True when the defense disrupted the play: a pass breakup, tackle for loss, interception or forced fumble. |
#'    |start.pos_team_spread                   |double    |ESPN's `pos_team_spread` value for the play state at the start of the play. |
#'    |start.elapsed_share                     |double    |ESPN's `elapsed_share` value for the play state at the start of the play. |
#'    |start.spread_time                       |double    |ESPN's `spread_time` value for the play state at the start of the play. |
#'    |end.pos_team_spread                     |double    |ESPN's `pos_team_spread` value for the play state at the end of the play. |
#'    |end.elapsed_share                       |double    |ESPN's `elapsed_share` value for the play state at the end of the play. |
#'    |end.spread_time                         |double    |ESPN's `spread_time` value for the play state at the end of the play. |
#'    |penalty_assessed_on_kickoff             |logical   | |
#'    |start.yardsToEndzone.touchback          |integer   |ESPN's `yardsToEndzone.touchback` value for the play state at the start of the play. |
#'    |EP_start_touchback                      |double    |Expected points the offense would have had from a touchback on this play. |
#'    |EP_start                                |double    |Expected points for the offense at the start of the play. |
#'    |EP_end                                  |double    |Expected points for the offense at the end of the play. |
#'    |lag_EP_end                              |double    |Value of EP_end on the previous play, used for sequence-aware derivations. |
#'    |EP_between                              |double    |Change in expected points across the play, before penalty adjustment. |
#'    |EPA_scrimmage                           |double    |EPA credited to the play on plays from scrimmage. |
#'    |EPA_rush                                |double    |EPA credited to the play on rush plays. |
#'    |EPA_pass                                |double    |EPA credited to the play on pass plays. |
#'    |EPA_explosive                           |logical   |True when the play was explosive. |
#'    |EPA_non_explosive                       |double    |EPA credited to the play on non-explosive plays. |
#'    |EPA_explosive_pass                      |logical   |True when the pass play was explosive. |
#'    |EPA_explosive_rush                      |logical   |True when the rush play was explosive. |
#'    |first_down_created                      |logical   |True when the play produced a first down for the offense. |
#'    |EPA_success                             |logical   |True when the play was successful by EPA. |
#'    |EPA_success_early_down                  |logical   |True when the play on an early down was successful by EPA. |
#'    |EPA_success_early_down_pass             |logical   |True when the pass play on an early down was successful by EPA. |
#'    |EPA_success_early_down_rush             |logical   |True when the rush play on an early down was successful by EPA. |
#'    |EPA_success_late_down                   |logical   |True when the play on a late down was successful by EPA. |
#'    |EPA_success_late_down_pass              |logical   |True when the pass play on a late down was successful by EPA. |
#'    |EPA_success_late_down_rush              |logical   |True when the rush play on a late down was successful by EPA. |
#'    |EPA_success_standard_down               |logical   |True when the play on a standard down was successful by EPA. |
#'    |EPA_success_passing_down                |logical   |True when the play on a passing down was successful by EPA. |
#'    |EPA_success_pass                        |logical   |True when the pass play was successful by EPA. |
#'    |EPA_success_rush                        |logical   |True when the rush play was successful by EPA. |
#'    |EPA_success_EPA                         |double    |EPA on successful plays. |
#'    |EPA_success_standard_down_EPA           |double    |EPA on successful plays on a standard down. |
#'    |EPA_success_passing_down_EPA            |double    |EPA on successful plays on a passing down. |
#'    |EPA_success_pass_EPA                    |double    |EPA on successful pass plays. |
#'    |EPA_success_rush_EPA                    |double    |EPA on successful rush plays. |
#'    |EPA_middle_8_success                    |logical   |True when the play in the middle eight was successful by EPA. |
#'    |EPA_middle_8_success_pass               |logical   |True when the pass play in the middle eight was successful by EPA. |
#'    |EPA_middle_8_success_rush               |logical   |True when the rush play in the middle eight was successful by EPA. |
#'    |EPA_penalty                             |double    |EPA credited to the play attributable to penalties. |
#'    |EPA_sp                                  |double    |EPA credited to the play on special-teams plays. |
#'    |EPA_fg                                  |double    |EPA credited to the play on field-goal attempts. |
#'    |EPA_punt                                |double    |EPA credited to the play on punt plays. |
#'    |EPA_kickoff                             |double    |EPA credited to the play on kickoff plays. |
#'    |start.ExpScoreDiff_touchback            |double    |ESPN's `ExpScoreDiff_touchback` value for the play state at the start of the play. |
#'    |start.ExpScoreDiff                      |double    |ESPN's `ExpScoreDiff` value for the play state at the start of the play. |
#'    |start.ExpScoreDiff_Time_Ratio_touchback |double    |ESPN's `ExpScoreDiff_Time_Ratio_touchback` value for the play state at the start of the play. |
#'    |start.ExpScoreDiff_Time_Ratio           |double    |ESPN's `ExpScoreDiff_Time_Ratio` value for the play state at the start of the play. |
#'    |end.ExpScoreDiff                        |double    |ESPN's `ExpScoreDiff` value for the play state at the end of the play. |
#'    |end.ExpScoreDiff_Time_Ratio             |double    |ESPN's `ExpScoreDiff_Time_Ratio` value for the play state at the end of the play. |
#'    |wp_touchback                            |double    |Win probability the offense would have had starting from a touchback. |
#'    |wp_before_naive                         |double    | |
#'    |wp_touchback_naive                      |double    | |
#'    |wp_after_naive                          |double    | |
#'    |def_wp_before_naive                     |double    | |
#'    |home_wp_before_naive                    |double    | |
#'    |away_wp_before_naive                    |double    | |
#'    |lead_wp_before_naive                    |double    | |
#'    |lead_wp_before2_naive                   |double    | |
#'    |def_wp_after_naive                      |double    | |
#'    |home_wp_after_naive                     |double    | |
#'    |away_wp_after_naive                     |double    | |
#'    |wpa_naive                               |double    | |
#'    |cp                                      |double    | |
#'    |cpoe                                    |double    | |
#'    |era                                     |integer   | |
#'    |xpass                                   |double    | |
#'    |pass_oe                                 |double    | |
#'    |drive_start                             |double    |Yard line at which the drive began. |
#'    |drive_stopped                           |logical   |True when the play ended the drive. |
#'    |drive_play_index                        |integer   |Sequence number of the play within its drive. |
#'    |drive_offense_plays                     |integer   |Offensive plays run on the drive. |
#'    |prog_drive_EPA                          |double    |Cumulative EPA accrued by the drive up to and including this play. |
#'    |prog_drive_WPA                          |double    |Cumulative win-probability added by the drive up to and including this play. |
#'    |drive_offense_yards                     |integer   |Offensive yards gained on the drive. |
#'    |drive_total_yards                       |integer   |Total yards gained on the drive. |
#'    |qbr_epa                                 |double    |EPA variant used as an input to the QBR calculation. |
#'    |weight                                  |double    | |
#'    |non_fumble_sack                         |logical   |True when the play was a sack that did not produce a fumble. |
#'    |sack_epa                                |double    |EPA credited to the play when it is a sack. |
#'    |pass_epa                                |double    |EPA credited to the play when it is a pass. |
#'    |rush_epa                                |double    |EPA credited to the play when it is a rush. |
#'    |pen_epa                                 |double    |EPA attributable to a penalty on the play. |
#'    |sack_weight                             |double    |Weighting applied to the sack component of the play. |
#'    |pass_weight                             |double    |Weighting applied to the pass component of the play. |
#'    |rush_weight                             |double    |Weighting applied to the rush component of the play. |
#'    |pen_weight                              |double    |Weighting applied to the penalty component of the play. |
#'    |action_play                             |logical   |True when the play advanced the game state -- excludes timeouts, end-of-period markers and other non-action rows. |
#'    |athlete_name                            |character | |
#'    |rusher_player_id                        |integer   | |
#'    |passer_player_id                        |integer   | |
#'    |receiver_player_id                      |integer   | |
#'    |fumble_player_id                        |integer   | |
#'    |sack_player_id                          |integer   | |
#'    |sack_player_id2                         |integer   | |
#'    |interception_player_id                  |integer   | |
#'    |pass_breakup_player_id                  |integer   | |
#'    |fumble_forced_player_id                 |integer   | |
#'    |fumble_recovered_player_id              |integer   | |
#'    |fg_kicker_player_id                     |integer   | |
#'    |punter_player_id                        |integer   | |
#'    |kickoff_player_id                       |integer   | |
#'    |kickoff_return_player_id                |integer   | |
#'    |punt_return_player_id                   |integer   | |
#'    |fg_block_player_id                      |integer   | |
#'    |punt_block_player_id                    |integer   | |
#'    |fg_return_player_id                     |integer   | |
#'    |punt_block_return_player_id             |character | |
#'    |go_wp                                   |double    | |
#'    |first_down_prob                         |double    | |
#'    |wp_succeed                              |double    | |
#'    |wp_fail                                 |double    | |
#'    |make_fg_wp                              |double    | |
#'    |miss_fg_wp                              |double    | |
#'    |fg_wp                                   |double    | |
#'    |punt_wp                                 |double    | |
#'    |go_boost                                |double    | |
#'    |go_wp_diff                              |double    | |
#'    |fg_wp_diff                              |double    | |
#'    |punt_wp_diff                            |double    | |
#'    |fourth_down_recommendation              |character | |
#'    |two_pt_wp                               |double    | |
#'    |xp_wp                                   |double    | |
#'    |prob_2pt                                |double    | |
#'    |two_pt_recommendation                   |character | |
#'    |two_pt_wp_diff                          |double    | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_pbp(2004))
#' }
#' @export
load_espn_cfb_pbp <- function(seasons = most_recent_cfb_season(), ...,
                              dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_pbp/play_by_play_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("ESPN college football play-by-play from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load ESPN college football schedules from the SportsDataverse data repo**
#' @name load_espn_cfb_schedules
NULL
#' @title
#' **Load ESPN college football schedules from the SportsDataverse data repo**
#' @rdname load_espn_cfb_schedules
#' @author Saiem Gilani
#' @description
#'   Loads season-level college football schedules built from the ESPN events
#'   API by the cfbfastR-cfb-data pipeline. One row per game with
#'   date/venue/broadcast metadata, team ids and names, scores, and status
#'   fields. Published to the `espn_cfb_schedules` release tag on the
#'   sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name               |types     |description |
#'    |-----------------------|----------|:-----------|
#'    |game_id                |integer   | |
#'    |season                 |integer   | |
#'    |week                   |integer   | |
#'    |season_type            |integer   | |
#'    |game_date              |character | |
#'    |neutral_site           |logical   | |
#'    |conference_competition |logical   | |
#'    |home_id                |integer   | |
#'    |away_id                |integer   | |
#'    |home_team              |character | |
#'    |away_team              |character | |
#'    |home_abbreviation      |character | |
#'    |away_abbreviation      |character | |
#'    |home_score             |character | |
#'    |away_score             |character | |
#'    |home_winner            |logical   | |
#'    |away_winner            |logical   | |
#'    |venue                  |character | |
#'    |attendance             |character | |
#'    |status                 |character | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_schedules(2004))
#' }
#' @export
load_espn_cfb_schedules <- function(seasons = most_recent_cfb_season(), ...,
                                    dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_schedules/cfb_schedule_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("ESPN college football schedules from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load ESPN college football team box scores from the SportsDataverse data repo**
#' @name load_espn_cfb_team_box
NULL
#' @title
#' **Load ESPN college football team box scores from the SportsDataverse data repo**
#' @rdname load_espn_cfb_team_box
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_team_box (sportsdataverse-data release). Published to the
#'   `espn_cfb_team_box` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name            |types     |description |
#'    |--------------------|----------|:-----------|
#'    |firstDowns          |character |Total first downs ESPN credits the team, carried verbatim from the box score as a string. |
#'    |thirdDownEff        |character |Third-down efficiency as ESPN's conversions-attempts string, for example 5-15. |
#'    |fourthDownEff       |character |Fourth-down efficiency as a conversions-attempts string, for example 3-4. |
#'    |totalYards          |character |Total offensive yards for the team, matching rushingYards plus netPassingYards in about 99.8 percent of games. |
#'    |netPassingYards     |character |Passing yards after yardage lost to sacks is deducted, the numerator behind yardsPerPass. |
#'    |completionAttempts  |character |Completions and pass attempts as a slash-separated string, for example 23/41. |
#'    |yardsPerPass        |character |Net passing yards per pass attempt, netPassingYards divided by the attempt count in completionAttempts and rounded to one decimal. |
#'    |rushingYards        |character |Net rushing yards gained. |
#'    |rushingAttempts     |character |Rushing attempts. |
#'    |yardsPerRushAttempt |character |Yards gained per rushing attempt. |
#'    |totalPenaltiesYards |character |Penalties and penalty yards as a hyphen-separated string, for example 7-64. |
#'    |turnovers           |character | |
#'    |fumblesLost         |character |Number of fumbles the team lost to the opponent, carried as a string. |
#'    |interceptions       |character | |
#'    |possessionTime      |character |Time of possession as mm:ss; the two teams' values add up to 60 minutes in a regulation game. |
#'    |team_id             |integer   | |
#'    |team_abbreviation   |character | |
#'    |team_name           |character | |
#'    |home_away           |character | |
#'    |game_id             |integer   | |
#'    |season              |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_team_box(2004))
#' }
#' @export
load_espn_cfb_team_box <- function(seasons = most_recent_cfb_season(), ...,
                                   dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_team_box/team_box_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("ESPN college football team box scores from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load ESPN college football player box scores from the SportsDataverse data repo**
#' @name load_espn_cfb_player_box
NULL
#' @title
#' **Load ESPN college football player box scores from the SportsDataverse data repo**
#' @rdname load_espn_cfb_player_box
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_player_box (sportsdataverse-data release). Published to the
#'   `espn_cfb_player_box` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                           |types     |description |
#'    |-----------------------------------|----------|:-----------|
#'    |stat_1                             |character |First value of ESPN's raw athlete stats array, written only when the category's key list does not line up with the stats list; on those rows the named per-category columns are all null. |
#'    |stat_2                             |character |Second value of ESPN's raw athlete stats array, written only on rows where the category keys did not line up and the named columns could not be filled. |
#'    |stat_3                             |character |Third value of ESPN's raw athlete stats array, written only on rows where the category keys did not line up and the named columns could not be filled. |
#'    |stat_4                             |character |Fourth value of ESPN's raw athlete stats array, written only on rows where the category keys did not line up and the named columns could not be filled. |
#'    |stat_5                             |character |Fifth value of ESPN's raw athlete stats array, written only on rows where the category keys did not line up and the named columns could not be filled. |
#'    |category                           |character | |
#'    |athlete_id                         |integer   | |
#'    |athlete_name                       |character | |
#'    |jersey                             |character | |
#'    |team_id                            |integer   | |
#'    |rushingAttempts                    |character |Rushing attempts. |
#'    |rushingYards                       |character |Net rushing yards gained. |
#'    |yardsPerRushAttempt                |character |Yards gained per rushing attempt. |
#'    |rushingTouchdowns                  |character |Rushing touchdowns. |
#'    |longRushing                        |character |Longest rush of the game, in yards. |
#'    |receptions                         |character | |
#'    |receivingYards                     |character |Receiving yards gained. |
#'    |yardsPerReception                  |character |Yards gained per reception. |
#'    |receivingTouchdowns                |character |Receiving touchdowns. |
#'    |longReception                      |character |Longest reception of the game, in yards. |
#'    |fumbles                            |character | |
#'    |fumblesLost                        |character | |
#'    |fumblesRecovered                   |character | |
#'    |kickReturns                        |character | |
#'    |kickReturnYards                    |character | |
#'    |yardsPerKickReturn                 |character | |
#'    |longKickReturn                     |character | |
#'    |kickReturnTouchdowns               |character | |
#'    |puntReturns                        |character |Punt returns attempted. |
#'    |puntReturnYards                    |character |Yards gained on punt returns. |
#'    |yardsPerPuntReturn                 |character |Yards gained per punt return. |
#'    |longPuntReturn                     |character |Longest punt return of the game, in yards. |
#'    |puntReturnTouchdowns               |character |Touchdowns scored on punt returns. |
#'    |fieldGoalsMade/fieldGoalAttempts   |character |Field goals made and attempted, as ESPN's combined string. |
#'    |fieldGoalPct                       |character |Field-goal percentage. |
#'    |longFieldGoalMade                  |character |Longest field goal made, in yards. |
#'    |extraPointsMade/extraPointAttempts |character |Extra points made and attempted, as ESPN's combined string. |
#'    |totalKickingPoints                 |character |Total points scored by kicking. |
#'    |punts                              |character |Punts attempted. |
#'    |puntYards                          |character |Total punt yards. |
#'    |grossAvgPuntYards                  |character |Gross average yards per punt, before return yardage. |
#'    |touchbacks                         |character |Punts or kickoffs that resulted in a touchback. |
#'    |puntsInside20                      |character |Punts downed inside the opponent 20-yard line. |
#'    |longPunt                           |character |Longest punt of the game, in yards. |
#'    |game_id                            |integer   | |
#'    |season                             |integer   | |
#'    |interceptions                      |character | |
#'    |interceptionYards                  |character |Yards returned on interceptions. |
#'    |interceptionTouchdowns             |character |Touchdowns scored on interception returns. |
#'    |totalTackles                       |character | |
#'    |soloTackles                        |character | |
#'    |sacks                              |character | |
#'    |tacklesForLoss                     |character | |
#'    |passesDefended                     |character | |
#'    |hurries                            |character | |
#'    |defensiveTouchdowns                |character | |
#'    |completions/passingAttempts        |character |Completions and pass attempts, as ESPN's combined string. |
#'    |passingYards                       |character |Net passing yards gained. |
#'    |yardsPerPassAttempt                |character |Yards gained per pass attempt. |
#'    |passingTouchdowns                  |character |Passing touchdowns. |
#'    |adjQBR                             |character |Adjusted Total QBR for the quarterback. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_player_box(2004))
#' }
#' @export
load_espn_cfb_player_box <- function(seasons = most_recent_cfb_season(), ...,
                                     dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_player_box/player_box_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("ESPN college football player box scores from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load ESPN college football drives from the SportsDataverse data repo**
#' @name load_espn_cfb_drives
NULL
#' @title
#' **Load ESPN college football drives from the SportsDataverse data repo**
#' @rdname load_espn_cfb_drives
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_drives (sportsdataverse-data release). Published to the
#'   `espn_cfb_drives` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name             |types     |description |
#'    |---------------------|----------|:-----------|
#'    |drive_id             |character | |
#'    |team_id              |integer   | |
#'    |result               |character | |
#'    |display_result       |character | |
#'    |short_display_result |character | |
#'    |description          |character | |
#'    |yards                |integer   | |
#'    |offensive_plays      |integer   | |
#'    |is_score             |logical   | |
#'    |start_period         |integer   | |
#'    |start_yard_line      |integer   | |
#'    |start_clock          |character | |
#'    |start_text           |character | |
#'    |end_period           |integer   | |
#'    |end_yard_line        |integer   | |
#'    |end_clock            |character | |
#'    |time_elapsed         |character | |
#'    |n_plays              |integer   |Number of entries in ESPN's raw plays array for the drive, which is generally at least offensive_plays because it also counts penalties and other non-offensive snaps. |
#'    |game_id              |integer   | |
#'    |season               |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_drives(2004))
#' }
#' @export
load_espn_cfb_drives <- function(seasons = most_recent_cfb_season(), ...,
                                 dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_drives/drives_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("ESPN college football drives from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load ESPN college football game rosters from the SportsDataverse data repo**
#' @name load_espn_cfb_game_rosters
NULL
#' @title
#' **Load ESPN college football game rosters from the SportsDataverse data repo**
#' @rdname load_espn_cfb_game_rosters
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_game_rosters (sportsdataverse-data release). Published to
#'   the `espn_cfb_game_rosters` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                   |types     |description |
#'    |---------------------------|----------|:-----------|
#'    |athlete_id                 |integer   | |
#'    |athlete_uid                |character | |
#'    |athlete_guid               |character | |
#'    |athlete_type               |character | |
#'    |first_name                 |character | |
#'    |last_name                  |character | |
#'    |full_name                  |character | |
#'    |athlete_display_name       |character | |
#'    |short_name                 |character | |
#'    |weight                     |double    | |
#'    |display_weight             |character | |
#'    |height                     |double    | |
#'    |display_height             |character | |
#'    |slug                       |character | |
#'    |jersey                     |character | |
#'    |linked                     |logical   | |
#'    |active                     |logical   | |
#'    |alternate_ids_sdr          |character | |
#'    |birth_place_city           |character | |
#'    |birth_place_state          |character | |
#'    |birth_place_country        |character | |
#'    |birth_country_alternate_id |character |ESPN's internal alternate identifier for the athlete's birth country, paired with birth_place_country and the flag fields. |
#'    |birth_country_abbreviation |character | |
#'    |headshot_href              |character | |
#'    |headshot_alt               |character | |
#'    |hand_type                  |character | |
#'    |hand_abbreviation          |character | |
#'    |hand_display_value         |character | |
#'    |flag_href                  |character |URL of the birth-country flag image hosted on ESPN's CDN under teamlogos/countries. |
#'    |flag_alt                   |character |Alt text ESPN attaches to the birth-country flag image, which is the country's name spelled out. |
#'    |flag_rel                   |character |Stringified relationship list ESPN ships with the flag image; the only non-null value observed is a single country-flag entry. |
#'    |experience_years           |double    | |
#'    |experience_display_value   |character | |
#'    |experience_abbreviation    |character | |
#'    |status_id                  |character | |
#'    |status_name                |character | |
#'    |status_type                |character | |
#'    |status_abbreviation        |character | |
#'    |middle_name                |character | |
#'    |starter                    |logical   | |
#'    |jersey_right               |character | |
#'    |valid                      |logical   | |
#'    |did_not_play               |logical   | |
#'    |display_name               |character | |
#'    |athlete_href               |character |ESPN Core v2 API reference URL for the athlete's season record, ending in the athlete id. |
#'    |position_href              |character |ESPN Core v2 API reference URL for the position resource ESPN lists the athlete at. |
#'    |statistics_href            |character |ESPN Core v2 API reference URL for this athlete's stat line in this game, null for the roughly 71 percent of listed players who recorded no stats. |
#'    |team_id                    |integer   | |
#'    |order                      |integer   | |
#'    |home_away                  |character | |
#'    |winner                     |logical   | |
#'    |team_guid                  |character | |
#'    |team_uid                   |character | |
#'    |team_slug                  |character | |
#'    |team_location              |character | |
#'    |team_name                  |character | |
#'    |team_nickname              |character | |
#'    |team_abbreviation          |character | |
#'    |team_display_name          |character | |
#'    |team_short_display_name    |character | |
#'    |team_color                 |character | |
#'    |team_alternate_color       |character | |
#'    |is_active                  |logical   | |
#'    |is_all_star                |logical   | |
#'    |team_alternate_ids_sdr     |character |The team's Sportradar alternate identifier, which maps one-to-one with team_id. |
#'    |logo_href                  |character | |
#'    |logo_dark_href             |character | |
#'    |game_id                    |integer   | |
#'    |season                     |integer   | |
#'    |week                       |integer   | |
#'    |age                        |double    | |
#'    |date_of_birth              |character | |
#'    |citizenship                |character | |
#'    |draft_display_text         |character | |
#'    |draft_round                |double    | |
#'    |draft_year                 |double    | |
#'    |draft_selection            |double    | |
#'    |draft_team_href            |character |API link to the team that drafted the player. Sparse: absent entirely from the 2023 and 2024 assets and populated on only a small share of 2025 rows. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_game_rosters(2004))
#' }
#' @export
load_espn_cfb_game_rosters <- function(seasons = most_recent_cfb_season(), ...,
                                       dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_game_rosters/game_rosters_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("ESPN college football game rosters from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load ESPN college football linescores from the SportsDataverse data repo**
#' @name load_espn_cfb_linescores
NULL
#' @title
#' **Load ESPN college football linescores from the SportsDataverse data repo**
#' @rdname load_espn_cfb_linescores
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_linescores (sportsdataverse-data release). Published to the
#'   `espn_cfb_linescores` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name |types     |description |
#'    |---------|----------|:-----------|
#'    |team_id  |integer   | |
#'    |period   |integer   | |
#'    |value    |character | |
#'    |game_id  |integer   | |
#'    |season   |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_linescores(2004))
#' }
#' @export
load_espn_cfb_linescores <- function(seasons = most_recent_cfb_season(), ...,
                                     dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- parquet_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_linescores/linescores_", seasons, ".parquet")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("ESPN college football linescores from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load ESPN college football betting lines from the SportsDataverse data repo**
#' @name load_espn_cfb_betting
NULL
#' @title
#' **Load ESPN college football betting lines from the SportsDataverse data repo**
#' @rdname load_espn_cfb_betting
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_betting (sportsdataverse-data release). Published to the
#'   `espn_cfb_betting` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name              |types     |description |
#'    |----------------------|----------|:-----------|
#'    |game_id               |integer   | |
#'    |season                |integer   | |
#'    |week                  |integer   | |
#'    |game_spread           |double    | |
#'    |over_under            |double    | |
#'    |home_favorite         |logical   | |
#'    |home_team_spread      |double    | |
#'    |game_spread_available |logical   | |
#'    |odds_source           |character | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_betting(2004))
#' }
#' @export
load_espn_cfb_betting <- function(seasons = most_recent_cfb_season(), ...,
                                  dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_betting/betting_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("ESPN college football betting lines from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load ESPN college football play participants from the SportsDataverse data repo**
#' @name load_espn_cfb_play_participants
NULL
#' @title
#' **Load ESPN college football play participants from the SportsDataverse data repo**
#' @rdname load_espn_cfb_play_participants
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_play_participants (sportsdataverse-data release). Published
#'   to the `espn_cfb_play_participants` release tag on the sportsdataverse-
#'   data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2014 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2014)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                   |types     |description |
#'    |---------------------------|----------|:-----------|
#'    |game_id                    |integer   | |
#'    |play_id                    |integer   | |
#'    |kicker_player_name         |character |Display name of the kicker -- the FIRST participant in that role on the play. |
#'    |tackler_player_name        |character |Display name of a defender credited with the tackle -- the FIRST participant in that role on the play. |
#'    |returner_player_name       |character |Display name of the player returning the kick or punt -- the FIRST participant in that role on the play. |
#'    |rusher_player_name         |character |Display name of the ball carrier on a rush -- the FIRST participant in that role on the play. |
#'    |passer_player_name         |character |Display name of the passer -- the FIRST participant in that role on the play. |
#'    |receiver_player_name       |character |Display name of the targeted receiver -- the FIRST participant in that role on the play. |
#'    |punter_player_name         |character |Display name of the punter -- the FIRST participant in that role on the play. |
#'    |assisted_by_player_name    |character |Display name of a defender credited with an assisted tackle -- the FIRST participant in that role on the play. |
#'    |penalized_player_name      |character |Display name of the penalized player -- the FIRST participant in that role on the play. |
#'    |scorer_player_name         |character |Display name of the player credited with the score -- the FIRST participant in that role on the play. |
#'    |pat_scorer_player_name     |character |Display name of the player credited with the point-after score -- the FIRST participant in that role on the play. |
#'    |sacked_by_player_name      |character |Display name of a defender credited with the sack -- the FIRST participant in that role on the play. |
#'    |kicker_player_id           |character |ESPN athlete id of the kicker -- the FIRST participant in that role on the play. |
#'    |tackler_player_id          |character |ESPN athlete id of a defender credited with the tackle -- the FIRST participant in that role on the play. |
#'    |returner_player_id         |character |ESPN athlete id of the player returning the kick or punt -- the FIRST participant in that role on the play. |
#'    |rusher_player_id           |character |ESPN athlete id of the ball carrier on a rush -- the FIRST participant in that role on the play. |
#'    |passer_player_id           |character |ESPN athlete id of the passer -- the FIRST participant in that role on the play. |
#'    |receiver_player_id         |character |ESPN athlete id of the targeted receiver -- the FIRST participant in that role on the play. |
#'    |punter_player_id           |character |ESPN athlete id of the punter -- the FIRST participant in that role on the play. |
#'    |assisted_by_player_id      |character |ESPN athlete id of a defender credited with an assisted tackle -- the FIRST participant in that role on the play. |
#'    |penalized_player_id        |character |ESPN athlete id of the penalized player -- the FIRST participant in that role on the play. |
#'    |scorer_player_id           |character |ESPN athlete id of the player credited with the score -- the FIRST participant in that role on the play. |
#'    |pat_scorer_player_id       |character |ESPN athlete id of the player credited with the point-after score -- the FIRST participant in that role on the play. |
#'    |sacked_by_player_id        |character |ESPN athlete id of a defender credited with the sack -- the FIRST participant in that role on the play. |
#'    |kicker_player_names        |character |List of the display names of EVERY participant credited as the kicker on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |tackler_player_names       |character |List of the display names of EVERY participant credited as a defender credited with the tackle on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |returner_player_names      |character |List of the display names of EVERY participant credited as the player returning the kick or punt on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |rusher_player_names        |character |List of the display names of EVERY participant credited as the ball carrier on a rush on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |passer_player_names        |character |List of the display names of EVERY participant credited as the passer on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |receiver_player_names      |character |List of the display names of EVERY participant credited as the targeted receiver on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |punter_player_names        |character |List of the display names of EVERY participant credited as the punter on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |assisted_by_player_names   |character |List of the display names of EVERY participant credited as a defender credited with an assisted tackle on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |penalized_player_names     |character |List of the display names of EVERY participant credited as the penalized player on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |scorer_player_names        |character |List of the display names of EVERY participant credited as the player credited with the score on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |pat_scorer_player_names    |character |List of the display names of EVERY participant credited as the player credited with the point-after score on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |sacked_by_player_names     |character |List of the display names of EVERY participant credited as a defender credited with the sack on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |kicker_player_ids          |character |List of the athlete ids of EVERY participant credited as the kicker on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |tackler_player_ids         |character |List of the athlete ids of EVERY participant credited as a defender credited with the tackle on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |returner_player_ids        |character |List of the athlete ids of EVERY participant credited as the player returning the kick or punt on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |rusher_player_ids          |character |List of the athlete ids of EVERY participant credited as the ball carrier on a rush on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |passer_player_ids          |character |List of the athlete ids of EVERY participant credited as the passer on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |receiver_player_ids        |character |List of the athlete ids of EVERY participant credited as the targeted receiver on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |punter_player_ids          |character |List of the athlete ids of EVERY participant credited as the punter on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |assisted_by_player_ids     |character |List of the athlete ids of EVERY participant credited as a defender credited with an assisted tackle on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |penalized_player_ids       |character |List of the athlete ids of EVERY participant credited as the penalized player on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |scorer_player_ids          |character |List of the athlete ids of EVERY participant credited as the player credited with the score on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |pat_scorer_player_ids      |character |List of the athlete ids of EVERY participant credited as the player credited with the point-after score on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |sacked_by_player_ids       |character |List of the athlete ids of EVERY participant credited as a defender credited with the sack on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |season                     |integer   | |
#'    |week                       |integer   | |
#'    |pass_defender_player_name  |character |Display name of the defender credited with defending the pass -- the FIRST participant in that role on the play. |
#'    |pass_defender_player_id    |character |ESPN athlete id of the defender credited with defending the pass -- the FIRST participant in that role on the play. |
#'    |pass_defender_player_names |character |List of the display names of EVERY participant credited as the defender credited with defending the pass on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |pass_defender_player_ids   |character |List of the athlete ids of EVERY participant credited as the defender credited with defending the pass on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |recoverer_player_name      |character |Display name of the player who recovered the fumble -- the FIRST participant in that role on the play. |
#'    |fumbler_player_name        |character | |
#'    |recoverer_player_id        |character |ESPN athlete id of the player who recovered the fumble -- the FIRST participant in that role on the play. |
#'    |fumbler_player_id          |character | |
#'    |recoverer_player_names     |character |List of the display names of EVERY participant credited as the player who recovered the fumble on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |fumbler_player_names       |character | |
#'    |recoverer_player_ids       |character |List of the athlete ids of EVERY participant credited as the player who recovered the fumble on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |fumbler_player_ids         |character | |
#'    |forced_by_player_name      |character |Display name of the defender who forced the fumble -- the FIRST participant in that role on the play. |
#'    |forced_by_player_id        |character |ESPN athlete id of the defender who forced the fumble -- the FIRST participant in that role on the play. |
#'    |forced_by_player_names     |character |List of the display names of EVERY participant credited as the defender who forced the fumble on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |forced_by_player_ids       |character |List of the athlete ids of EVERY participant credited as the defender who forced the fumble on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |pat_passer_player_name     |character |Display name of the passer on the point-after attempt -- the FIRST participant in that role on the play. |
#'    |pat_passer_player_id       |character |ESPN athlete id of the passer on the point-after attempt -- the FIRST participant in that role on the play. |
#'    |pat_passer_player_names    |character |List of the display names of EVERY participant credited as the passer on the point-after attempt on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'    |pat_passer_player_ids      |character |List of the athlete ids of EVERY participant credited as the passer on the point-after attempt on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_play_participants(2014))
#' }
#' @export
load_espn_cfb_play_participants <- function(seasons = most_recent_cfb_season(), ...,
                                            dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2014:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2014),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_play_participants/play_participants_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("ESPN college football play participants from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load ESPN college football FPI power index from the SportsDataverse data repo**
#' @name load_espn_cfb_power_index
NULL
#' @title
#' **Load ESPN college football FPI power index from the SportsDataverse data repo**
#' @rdname load_espn_cfb_power_index
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_power_index (sportsdataverse-data release). Published to the
#'   `espn_cfb_power_index` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2015 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2015)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name         |types   |description |
#'    |-----------------|--------|:-----------|
#'    |season           |integer | |
#'    |game_id          |integer | |
#'    |team_id          |integer | |
#'    |teampredptdiff   |double  |Expected margin of victory for the FPI favorite. |
#'    |gameprojection   |double  |Team's predicted win percentage in this game at time of given BPI run. |
#'    |matchupquality   |double  |A measure of projected competitiveness and excitement in the game, using a 0 to 100 scale, with 100 as the most exciting. |
#'    |teamadjgamescore |double  |A measure of how well a team performed compared to their expected performance and the expected performance of a typical top 25 team. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_power_index(2015))
#' }
#' @export
load_espn_cfb_power_index <- function(seasons = most_recent_cfb_season(), ...,
                                      dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2015:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2015),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_power_index/power_index_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("ESPN college football FPI power index from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football team percentile profiles from the SportsDataverse data repo**
#' @name load_espn_cfb_percentiles
NULL
#' @title
#' **Load college football team percentile profiles from the SportsDataverse data repo**
#' @rdname load_espn_cfb_percentiles
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_percentiles (sportsdataverse-data release). Published to the
#'   `espn_cfb_percentiles` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name               |types  |description |
#'    |-----------------------|-------|:-----------|
#'    |pctile                 |double |Percentile bucket the row reports, from 0 to 100. |
#'    |GEI                    |double |Value of game excitement index at the percentile this row reports. |
#'    |EPAplay                |double |Value of EPA generated per play at the percentile this row reports. |
#'    |pass_success           |double |Value of success rate on pass plays at the percentile this row reports. |
#'    |rush_success           |double |Value of success rate on rush plays at the percentile this row reports. |
#'    |early_down_success     |double |Value of success rate on early downs at the percentile this row reports. |
#'    |early_down_EPA         |double |Value of EPA per early-down play at the percentile this row reports. |
#'    |late_down_success      |double |Value of success rate on late downs at the percentile this row reports. |
#'    |success                |double |Value of success rate across the team plays at the percentile this row reports. |
#'    |yardsplay              |double |Value of yards per play at the percentile this row reports. |
#'    |dropbacks              |double |Value of dropbacks taken by the passer at the percentile this row reports. |
#'    |rushes                 |double |Value of rushing attempts at the percentile this row reports. |
#'    |EPAdropback            |double |Value of EPA generated per dropback at the percentile this row reports. |
#'    |EPArush                |double |Value of EPA generated per rushing attempt at the percentile this row reports. |
#'    |yardsdropback          |double |Value of yards per dropback at the percentile this row reports. |
#'    |pass_explosive         |double |Value of explosive-play rate on pass plays at the percentile this row reports. |
#'    |rush_explosive         |double |Value of explosive-play rate on rush plays at the percentile this row reports. |
#'    |explosive              |double |Value of explosive-play rate at the percentile this row reports. |
#'    |third_down_success     |double |Value of success rate on third down at the percentile this row reports. |
#'    |red_zone_success       |double |Value of success rate in the red zone at the percentile this row reports. |
#'    |play_stuffed           |double |Value of stuffed-play rate at the percentile this row reports. |
#'    |nonExplosiveEpaPerPlay |double |Value of EPA per play excluding explosive plays at the percentile this row reports. |
#'    |havoc                  |double |Value of havoc rate at the percentile this row reports. |
#'    |yardsrush              |double |Value of yards per rush at the percentile this row reports. |
#'    |lineyards              |double |Value of line yards per rush at the percentile this row reports. |
#'    |opportunity_run        |double |Value of opportunity-run rate at the percentile this row reports. |
#'    |third_down_distance    |double |Value of average yards to go on third down at the percentile this row reports. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_percentiles(2004))
#' }
#' @export
load_espn_cfb_percentiles <- function(seasons = most_recent_cfb_season(), ...,
                                      dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_percentiles/cfb_percentiles_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football team percentile profiles from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football passing EPA splits from the SportsDataverse data repo**
#' @name load_espn_cfb_passing
NULL
#' @title
#' **Load college football passing EPA splits from the SportsDataverse data repo**
#' @rdname load_espn_cfb_passing
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_passing (sportsdataverse-data release). Published to the
#'   `espn_cfb_passing` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name            |types     |description |
#'    |--------------------|----------|:-----------|
#'    |team_id             |integer   | |
#'    |pos_team            |character | |
#'    |division            |character | |
#'    |conference          |character | |
#'    |season              |integer   | |
#'    |player_id           |integer   | |
#'    |passer_player_name  |character |Display name of the passer -- the FIRST participant in that role on the play. |
#'    |plays               |integer   | |
#'    |games               |integer   | |
#'    |team_games          |integer   |Games the team played, used as the per-game denominator. |
#'    |TEPA                |double    |Total EPA summed over every play. |
#'    |EPAplay             |double    |EPA generated per play. |
#'    |yards               |double    | |
#'    |success             |double    |Success rate across the team plays. |
#'    |comp                |double    |Completed passes. |
#'    |att                 |double    |Pass attempts thrown. |
#'    |comppct             |double    |Completion percentage. |
#'    |passing_td          |double    | |
#'    |playsgame           |double    |Plays per game. |
#'    |EPAgame             |double    |EPA generated per game. |
#'    |yardsplay           |double    |Yards per play. |
#'    |yardsgame           |double    |Yards per game. |
#'    |sacked              |integer   |Times the passer was sacked. |
#'    |sack_yds            |integer   |Yards lost to sacks. |
#'    |sack_epa            |double    |EPA lost on the sacks the team's passers took -- the expected-points cost of those plays. |
#'    |pass_int            |integer   |Interceptions thrown. |
#'    |int_epa             |double    |EPA lost on the team's interceptions thrown -- the expected-points cost of the turnovers, not a count. |
#'    |detmer              |double    |Detmer rating -- the composite passing-efficiency measure this pipeline publishes, named for the college passing-efficiency tradition. |
#'    |detmergame          |double    |Detmer rating expressed per game. |
#'    |dropbacks           |double    |Dropbacks taken by the passer. |
#'    |sack_adj_yards      |double    |Passing yards adjusted for sack yardage lost. |
#'    |yardsdropback       |double    |Yards per dropback. |
#'    |TEPA_rank           |double    |National rank of the team's total EPA summed over every play, where 1 is best. |
#'    |EPAgame_rank        |double    |National rank of the team's EPA generated per game, where 1 is best. |
#'    |EPAplay_rank        |double    |National rank of the team's EPA generated per play, where 1 is best. |
#'    |success_rank        |double    |National rank of the team's success rate across the team plays, where 1 is best. |
#'    |comppct_rank        |double    |National rank of the team's completion percentage, where 1 is best. |
#'    |yards_rank          |double    |National rank of the team's total yards, where 1 is best. |
#'    |yardsplay_rank      |double    |National rank of the team's yards per play, where 1 is best. |
#'    |yardsgame_rank      |double    |National rank of the team's yards per game, where 1 is best. |
#'    |sack_adj_yards_rank |double    |National rank of the team's passing yards adjusted for sack yardage lost, where 1 is best. |
#'    |yardsdropback_rank  |double    |National rank of the team's yards per dropback, where 1 is best. |
#'    |detmer_rank         |double    |National rank of the team's detmer rating -- the composite passing-efficiency measure this pipeline publishes, named for the college passing-efficiency tradition, where 1 is best. |
#'    |detmergame_rank     |double    |National rank of the team's detmer rating expressed per game, where 1 is best. |
#'    |fbs_class           |character |Power/Group classification for the season: P4 or G6 from 2024 on, P5 or G5 through 2023, derived from conference membership. Null for teams outside FBS. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_passing(2004))
#' }
#' @export
load_espn_cfb_passing <- function(seasons = most_recent_cfb_season(), ...,
                                  dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_passing/cfb_passing_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football passing EPA splits from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football rushing EPA splits from the SportsDataverse data repo**
#' @name load_espn_cfb_rushing
NULL
#' @title
#' **Load college football rushing EPA splits from the SportsDataverse data repo**
#' @rdname load_espn_cfb_rushing
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_rushing (sportsdataverse-data release). Published to the
#'   `espn_cfb_rushing` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name           |types     |description |
#'    |-------------------|----------|:-----------|
#'    |team_id            |integer   | |
#'    |pos_team           |character | |
#'    |division           |character | |
#'    |conference         |character | |
#'    |season             |integer   | |
#'    |player_id          |integer   | |
#'    |rusher_player_name |character |Display name of the ball carrier on a rush -- the FIRST participant in that role on the play. |
#'    |plays              |integer   | |
#'    |games              |integer   | |
#'    |team_games         |integer   |Games the team played, used as the per-game denominator. |
#'    |TEPA               |double    |Total EPA summed over every play. |
#'    |EPAplay            |double    |EPA generated per play. |
#'    |yards              |integer   | |
#'    |success            |double    |Success rate across the team plays. |
#'    |rushing_td         |double    | |
#'    |fumbles            |double    |Count of the ball carrier's rush attempts across the season whose play text mentions a fumble by either team. |
#'    |playsgame          |double    |Plays per game. |
#'    |EPAgame            |double    |EPA generated per game. |
#'    |yardsplay          |double    |Yards per play. |
#'    |yardsgame          |double    |Yards per game. |
#'    |TEPA_rank          |double    |National rank of the team's total EPA summed over every play, where 1 is best. |
#'    |EPAgame_rank       |double    |National rank of the team's EPA generated per game, where 1 is best. |
#'    |EPAplay_rank       |double    |National rank of the team's EPA generated per play, where 1 is best. |
#'    |success_rank       |double    |National rank of the team's success rate across the team plays, where 1 is best. |
#'    |yards_rank         |double    |National rank of the team's total yards, where 1 is best. |
#'    |yardsplay_rank     |double    |National rank of the team's yards per play, where 1 is best. |
#'    |yardsgame_rank     |double    |National rank of the team's yards per game, where 1 is best. |
#'    |fbs_class          |character |Power/Group classification for the season: P4 or G6 from 2024 on, P5 or G5 through 2023, derived from conference membership. Null for teams outside FBS. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_rushing(2004))
#' }
#' @export
load_espn_cfb_rushing <- function(seasons = most_recent_cfb_season(), ...,
                                  dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_rushing/cfb_rushing_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football rushing EPA splits from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football receiving EPA splits from the SportsDataverse data repo**
#' @name load_espn_cfb_receiving
NULL
#' @title
#' **Load college football receiving EPA splits from the SportsDataverse data repo**
#' @rdname load_espn_cfb_receiving
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_receiving (sportsdataverse-data release). Published to the
#'   `espn_cfb_receiving` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name             |types     |description |
#'    |---------------------|----------|:-----------|
#'    |team_id              |integer   | |
#'    |pos_team             |character | |
#'    |division             |character | |
#'    |conference           |character | |
#'    |season               |integer   | |
#'    |player_id            |integer   | |
#'    |receiver_player_name |character |Display name of the targeted receiver -- the FIRST participant in that role on the play. |
#'    |plays                |integer   | |
#'    |games                |integer   | |
#'    |team_games           |integer   |Games the team played, used as the per-game denominator. |
#'    |TEPA                 |double    |Total EPA summed over every play. |
#'    |EPAplay              |double    |EPA generated per play. |
#'    |yards                |integer   | |
#'    |success              |double    |Success rate across the team plays. |
#'    |comp                 |integer   |Completed passes. |
#'    |targets              |integer   | |
#'    |passing_td           |double    | |
#'    |fumbles              |double    |Count of the receiver's targeted pass plays across the season whose play text mentions a fumble by either team. |
#'    |playsgame            |double    |Plays per game. |
#'    |EPAgame              |double    |EPA generated per game. |
#'    |yardsplay            |double    |Yards per play. |
#'    |yardsgame            |double    |Yards per game. |
#'    |catchpct             |double    |Catch rate on a 0-to-1 scale, receptions divided by targets for the season. |
#'    |TEPA_rank            |double    |National rank of the team's total EPA summed over every play, where 1 is best. |
#'    |EPAgame_rank         |double    |National rank of the team's EPA generated per game, where 1 is best. |
#'    |EPAplay_rank         |double    |National rank of the team's EPA generated per play, where 1 is best. |
#'    |success_rank         |double    |National rank of the team's success rate across the team plays, where 1 is best. |
#'    |catchpct_rank        |double    |Season rank of catchpct with the best catch rate first, computed only for receivers clearing the leaderboard minimum of 1.875 targets per team game and using averaged ranks for ties. |
#'    |yards_rank           |double    |National rank of the team's total yards, where 1 is best. |
#'    |yardsplay_rank       |double    |National rank of the team's yards per play, where 1 is best. |
#'    |yardsgame_rank       |double    |National rank of the team's yards per game, where 1 is best. |
#'    |fbs_class            |character |Power/Group classification for the season: P4 or G6 from 2024 on, P5 or G5 through 2023, derived from conference membership. Null for teams outside FBS. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_receiving(2004))
#' }
#' @export
load_espn_cfb_receiving <- function(seasons = most_recent_cfb_season(), ...,
                                    dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_receiving/cfb_receiving_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football receiving EPA splits from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football team season summaries from the SportsDataverse data repo**
#' @name load_espn_cfb_team_summaries
NULL
#' @title
#' **Load college football team season summaries from the SportsDataverse data repo**
#' @rdname load_espn_cfb_team_summaries
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_team_summaries (sportsdataverse-data release). Published to
#'   the `espn_cfb_team_summaries` release tag on the sportsdataverse-data
#'   repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                             |types     |description |
#'    |-------------------------------------|----------|:-----------|
#'    |team_id                              |integer   | |
#'    |pos_team                             |character | |
#'    |division                             |character | |
#'    |conference                           |character | |
#'    |season                               |integer   | |
#'    |plays_off                            |integer   |Plays run, with the team on offense. |
#'    |passrate_off                         |double    |Share of plays that were pass plays, with the team on offense. |
#'    |rushrate_off                         |double    |Share of plays that were rush plays, with the team on offense. |
#'    |havoc_off                            |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag, with the team on offense. |
#'    |explosive_off                        |double    |Explosive-play rate -- the share of plays carrying the explosive flag, with the team on offense. |
#'    |TEPA_off                             |double    |Total EPA summed over every play, with the team on offense. |
#'    |EPAplay_off                          |double    |EPA per play, with the team on offense. |
#'    |yards_off                            |integer   |Total yards gained, with the team on offense. |
#'    |yardsplay_off                        |double    |Yards gained per play, with the team on offense. |
#'    |play_stuffed_off                     |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag, with the team on offense. |
#'    |success_off                          |double    |Success rate -- the share of plays flagged as successful by EPA, with the team on offense. |
#'    |red_zone_success_off                 |double    |Success rate on red-zone plays, with the team on offense. |
#'    |third_down_success_off               |double    |Success rate on third-down plays, with the team on offense. |
#'    |third_down_distance_off              |double    |Average yards to go on third down, with the team on offense. |
#'    |late_down_success_off                |double    |Success rate on late-down plays, with the team on offense. |
#'    |early_down_EPA_off                   |double    |EPA per early-down play, with the team on offense. |
#'    |start_position_off                   |double    |Average drive start position, measured in yards from the opponent goal line, with the team on offense. |
#'    |nonExplosiveEpaPerPlay_off           |double    |EPA per play with explosive plays excluded, with the team on offense. |
#'    |line_yards_off                       |double    |Average line yards credited to the offensive line on rushes, with the team on offense. |
#'    |opportunity_rate_off                 |double    |Opportunity rate -- the share of rushes carrying the opportunity flag, with the team on offense. |
#'    |playsgame_off                        |double    |Plays run per game, with the team on offense. |
#'    |EPAdrive_off                         |double    |EPA per drive (total EPA divided by drives), with the team on offense. |
#'    |EPAgame_off                          |double    |EPA per game (total EPA divided by games), with the team on offense. |
#'    |yardsgame_off                        |double    |Yards gained per game, with the team on offense. |
#'    |drives_off                           |integer   |Offensive drives, with the team on offense. |
#'    |drivesgame_off                       |double    |Drives per game, with the team on offense. |
#'    |yardsdrive_off                       |double    |Yards gained per drive, with the team on offense. |
#'    |playsdrive_off                       |double    |Plays run per drive, with the team on offense. |
#'    |playsgame_off_rank                   |double    |National rank of the team's plays run per game with the team on offense, where 1 is best. |
#'    |TEPA_off_rank                        |double    |National rank of the team's total EPA summed over every play with the team on offense, where 1 is best. |
#'    |EPAgame_off_rank                     |double    |National rank of the team's EPA per game (total EPA divided by games) with the team on offense, where 1 is best. |
#'    |EPAplay_off_rank                     |double    |National rank of the team's EPA per play with the team on offense, where 1 is best. |
#'    |EPAdrive_off_rank                    |double    |National rank of the team's EPA per drive (total EPA divided by drives) with the team on offense, where 1 is best. |
#'    |early_down_EPA_off_rank              |double    |National rank of the team's EPA per early-down play with the team on offense, where 1 is best. |
#'    |success_off_rank                     |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA with the team on offense, where 1 is best. |
#'    |yards_off_rank                       |double    |National rank of the team's total yards gained with the team on offense, where 1 is best. |
#'    |yardsplay_off_rank                   |double    |National rank of the team's yards gained per play with the team on offense, where 1 is best. |
#'    |yardsgame_off_rank                   |double    |National rank of the team's yards gained per game with the team on offense, where 1 is best. |
#'    |drivesgame_off_rank                  |double    |National rank of the team's drives per game with the team on offense, where 1 is best. |
#'    |yardsdrive_off_rank                  |double    |National rank of the team's yards gained per drive with the team on offense, where 1 is best. |
#'    |playsdrive_off_rank                  |double    |National rank of the team's plays run per drive with the team on offense, where 1 is best. |
#'    |play_stuffed_off_rank                |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag with the team on offense, where 1 is best. |
#'    |red_zone_success_off_rank            |double    |National rank of the team's success rate on red-zone plays with the team on offense, where 1 is best. |
#'    |third_down_success_off_rank          |double    |National rank of the team's success rate on third-down plays with the team on offense, where 1 is best. |
#'    |late_down_success_off_rank           |double    |National rank of the team's success rate on late-down plays with the team on offense, where 1 is best. |
#'    |third_down_distance_off_rank         |double    |National rank of the team's average yards to go on third down with the team on offense, where 1 is best. |
#'    |start_position_off_rank              |double    |National rank of the team's average drive start position, measured in yards from the opponent goal line with the team on offense, where 1 is best. |
#'    |havoc_off_rank                       |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag with the team on offense, where 1 is best. |
#'    |explosive_off_rank                   |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag with the team on offense, where 1 is best. |
#'    |passrate_off_rank                    |double    |National rank of the team's share of plays that were pass plays with the team on offense, where 1 is best. |
#'    |rushrate_off_rank                    |double    |National rank of the team's share of plays that were rush plays with the team on offense, where 1 is best. |
#'    |nonExplosiveEpaPerPlay_off_rank      |double    |National rank of the team's EPA per play with explosive plays excluded with the team on offense, where 1 is best. |
#'    |line_yards_off_rank                  |double    |National rank of the team's average line yards credited to the offensive line on rushes with the team on offense, where 1 is best. |
#'    |opportunity_rate_off_rank            |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag with the team on offense, where 1 is best. |
#'    |plays_def                            |integer   |Plays run, with the team on defense (i.e. allowed to opponents). |
#'    |passrate_def                         |double    |Share of plays that were pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |rushrate_def                         |double    |Share of plays that were rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |havoc_def                            |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag, with the team on defense (i.e. allowed to opponents). |
#'    |explosive_def                        |double    |Explosive-play rate -- the share of plays carrying the explosive flag, with the team on defense (i.e. allowed to opponents). |
#'    |TEPA_def                             |double    |Total EPA summed over every play, with the team on defense (i.e. allowed to opponents). |
#'    |EPAplay_def                          |double    |EPA per play, with the team on defense (i.e. allowed to opponents). |
#'    |yards_def                            |integer   |Total yards gained, with the team on defense (i.e. allowed to opponents). |
#'    |yardsplay_def                        |double    |Yards gained per play, with the team on defense (i.e. allowed to opponents). |
#'    |play_stuffed_def                     |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag, with the team on defense (i.e. allowed to opponents). |
#'    |success_def                          |double    |Success rate -- the share of plays flagged as successful by EPA, with the team on defense (i.e. allowed to opponents). |
#'    |red_zone_success_def                 |double    |Success rate on red-zone plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_success_def               |double    |Success rate on third-down plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_distance_def              |double    |Average yards to go on third down, with the team on defense (i.e. allowed to opponents). |
#'    |late_down_success_def                |double    |Success rate on late-down plays, with the team on defense (i.e. allowed to opponents). |
#'    |early_down_EPA_def                   |double    |EPA per early-down play, with the team on defense (i.e. allowed to opponents). |
#'    |start_position_def                   |double    |Average drive start position, measured in yards from the opponent goal line, with the team on defense (i.e. allowed to opponents). |
#'    |nonExplosiveEpaPerPlay_def           |double    |EPA per play with explosive plays excluded, with the team on defense (i.e. allowed to opponents). |
#'    |line_yards_def                       |double    |Average line yards credited to the offensive line on rushes, with the team on defense (i.e. allowed to opponents). |
#'    |opportunity_rate_def                 |double    |Opportunity rate -- the share of rushes carrying the opportunity flag, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def                        |double    |Plays run per game, with the team on defense (i.e. allowed to opponents). |
#'    |EPAdrive_def                         |double    |EPA per drive (total EPA divided by drives), with the team on defense (i.e. allowed to opponents). |
#'    |EPAgame_def                          |double    |EPA per game (total EPA divided by games), with the team on defense (i.e. allowed to opponents). |
#'    |yardsgame_def                        |double    |Yards gained per game, with the team on defense (i.e. allowed to opponents). |
#'    |drives_def                           |integer   |Offensive drives, with the team on defense (i.e. allowed to opponents). |
#'    |drivesgame_def                       |double    |Drives per game, with the team on defense (i.e. allowed to opponents). |
#'    |yardsdrive_def                       |double    |Yards gained per drive, with the team on defense (i.e. allowed to opponents). |
#'    |playsdrive_def                       |double    |Plays run per drive, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def_rank                   |double    |National rank of the team's plays run per game with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_def_rank                        |double    |National rank of the team's total EPA summed over every play with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAgame_def_rank                     |double    |National rank of the team's EPA per game (total EPA divided by games) with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAplay_def_rank                     |double    |National rank of the team's EPA per play with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAdrive_def_rank                    |double    |National rank of the team's EPA per drive (total EPA divided by drives) with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |early_down_EPA_def_rank              |double    |National rank of the team's EPA per early-down play with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |success_def_rank                     |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yards_def_rank                       |double    |National rank of the team's total yards gained with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsplay_def_rank                   |double    |National rank of the team's yards gained per play with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsgame_def_rank                   |double    |National rank of the team's yards gained per game with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |drivesgame_def_rank                  |double    |National rank of the team's drives per game with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsdrive_def_rank                  |double    |National rank of the team's yards gained per drive with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |playsdrive_def_rank                  |double    |National rank of the team's plays run per drive with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |play_stuffed_def_rank                |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |red_zone_success_def_rank            |double    |National rank of the team's success rate on red-zone plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_success_def_rank          |double    |National rank of the team's success rate on third-down plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |late_down_success_def_rank           |double    |National rank of the team's success rate on late-down plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_distance_def_rank         |double    |National rank of the team's average yards to go on third down with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |start_position_def_rank              |double    |National rank of the team's average drive start position, measured in yards from the opponent goal line with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |havoc_def_rank                       |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |explosive_def_rank                   |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |passrate_def_rank                    |double    |National rank of the team's share of plays that were pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |rushrate_def_rank                    |double    |National rank of the team's share of plays that were rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |nonExplosiveEpaPerPlay_def_rank      |double    |National rank of the team's EPA per play with explosive plays excluded with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |line_yards_def_rank                  |double    |National rank of the team's average line yards credited to the offensive line on rushes with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |opportunity_rate_def_rank            |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_margin                          |double    |Margin in total EPA summed over every play: the team's offensive value minus the value it allowed on defense. |
#'    |EPAplay_margin                       |double    |Margin in EPA per play: the team's offensive value minus the value it allowed on defense. |
#'    |EPAdrive_margin                      |double    |Margin in EPA per drive (total EPA divided by drives): the team's offensive value minus the value it allowed on defense. |
#'    |EPAgame_margin                       |double    |Margin in EPA per game (total EPA divided by games): the team's offensive value minus the value it allowed on defense. |
#'    |success_margin                       |double    |Margin in success rate -- the share of plays flagged as successful by EPA: the team's offensive value minus the value it allowed on defense. |
#'    |yardsplay_margin                     |double    |Margin in yards gained per play: the team's offensive value minus the value it allowed on defense. |
#'    |TEPA_margin_rank                     |double    |Margin in total EPA summed over every play: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAplay_margin_rank                  |double    |Margin in EPA per play: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAdrive_margin_rank                 |double    |Margin in EPA per drive (total EPA divided by drives): the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAgame_margin_rank                  |double    |Margin in EPA per game (total EPA divided by games): the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |success_margin_rank                  |double    |Margin in success rate -- the share of plays flagged as successful by EPA: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |yardsplay_margin_rank                |double    |Margin in yards gained per play: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |start_position_margin                |double    |Field-position margin: the team's own average starting field position minus the average starting field position it allowed, both measured as yards gained from their own goal line. Positive means the team started closer to scoring than its opponents. |
#'    |start_position_margin_rank           |double    |Field-position margin: the team's own average starting field position minus the average starting field position it allowed, both measured as yards gained from their own goal line. Positive means the team started closer to scoring than its opponents. National rank of that margin, 1 = largest. |
#'    |total_available_yards_off            |double    |Available yards are the yards a drive could theoretically gain, summed from each drive's starting distance to the opponent goal line. Total available yards on the team's own drives. |
#'    |total_gained_yards_off               |integer   |Total yards the team actually gained across its own drives. |
#'    |available_yards_pct_off              |double    |Share of available yards the team's offense actually gained (total_gained_yards_off divided by total_available_yards_off). Higher is better. |
#'    |available_yards_pct_off_rank         |double    |National rank of the team's offensive available-yards share, where 1 is best. |
#'    |total_available_yards_def            |double    |Available yards are the yards a drive could theoretically gain, summed from each drive's starting distance to the opponent goal line. Total available yards on drives the team defended. |
#'    |total_gained_yards_def               |integer   |Total yards the team allowed across the drives it defended. |
#'    |available_yards_pct_def              |double    |Share of available yards the team's defense allowed opponents to gain. Lower is better. |
#'    |available_yards_pct_def_rank         |double    |National rank of the team's defensive available-yards share, where 1 is best. |
#'    |total_available_yards_margin         |double    |Available yards on the team's own drives minus available yards on drives it defended. |
#'    |total_gained_yards_margin            |integer   |Yards the team gained minus yards it allowed. |
#'    |available_yards_pct_margin           |double    |Available-yards share gained by the offense minus the share allowed by the defense. Higher is better. |
#'    |total_available_yards_margin_rank    |double    |National rank of total_available_yards_margin, 1 = largest margin. |
#'    |total_gained_yards_margin_rank       |double    |National rank of total_gained_yards_margin, 1 = largest margin. |
#'    |available_yards_pct_margin_rank      |double    |National rank of available_yards_pct_margin, 1 = largest margin. |
#'    |plays_off_pass                       |integer   |Plays run on pass plays, with the team on offense. |
#'    |passrate_off_pass                    |double    |Share of plays that were pass plays on pass plays, with the team on offense. |
#'    |rushrate_off_pass                    |double    |Share of plays that were rush plays on pass plays, with the team on offense. |
#'    |havoc_off_pass                       |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag on pass plays, with the team on offense. |
#'    |explosive_off_pass                   |double    |Explosive-play rate -- the share of plays carrying the explosive flag on pass plays, with the team on offense. |
#'    |TEPA_off_pass                        |double    |Total EPA summed over every play on pass plays, with the team on offense. |
#'    |EPAplay_off_pass                     |double    |EPA per play on pass plays, with the team on offense. |
#'    |yards_off_pass                       |integer   |Total yards gained on pass plays, with the team on offense. |
#'    |yardsplay_off_pass                   |double    |Yards gained per play on pass plays, with the team on offense. |
#'    |play_stuffed_off_pass                |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag on pass plays, with the team on offense. |
#'    |success_off_pass                     |double    |Success rate -- the share of plays flagged as successful by EPA on pass plays, with the team on offense. |
#'    |red_zone_success_off_pass            |double    |Success rate on red-zone plays on pass plays, with the team on offense. |
#'    |third_down_success_off_pass          |double    |Success rate on third-down plays on pass plays, with the team on offense. |
#'    |third_down_distance_off_pass         |double    |Average yards to go on third down on pass plays, with the team on offense. |
#'    |late_down_success_off_pass           |double    |Success rate on late-down plays on pass plays, with the team on offense. |
#'    |early_down_EPA_off_pass              |double    |EPA per early-down play on pass plays, with the team on offense. |
#'    |nonExplosiveEpaPerPlay_off_pass      |double    |EPA per play with explosive plays excluded on pass plays, with the team on offense. |
#'    |line_yards_off_pass                  |double    |Average line yards credited to the offensive line on rushes on pass plays, with the team on offense. |
#'    |opportunity_rate_off_pass            |double    |Opportunity rate -- the share of rushes carrying the opportunity flag on pass plays, with the team on offense. |
#'    |playsgame_off_pass                   |double    |Plays run per game on pass plays, with the team on offense. |
#'    |EPAdrive_off_pass                    |double    |EPA per drive (total EPA divided by drives) on pass plays, with the team on offense. |
#'    |EPAgame_off_pass                     |double    |EPA per game (total EPA divided by games) on pass plays, with the team on offense. |
#'    |yardsgame_off_pass                   |double    |Yards gained per game on pass plays, with the team on offense. |
#'    |drives_off_pass                      |integer   |Offensive drives on pass plays, with the team on offense. |
#'    |drivesgame_off_pass                  |double    |Drives per game on pass plays, with the team on offense. |
#'    |yardsdrive_off_pass                  |double    |Yards gained per drive on pass plays, with the team on offense. |
#'    |playsdrive_off_pass                  |double    |Plays run per drive on pass plays, with the team on offense. |
#'    |playsgame_off_pass_rank              |double    |National rank of the team's plays run per game on pass plays with the team on offense, where 1 is best. |
#'    |TEPA_off_pass_rank                   |double    |National rank of the team's total EPA summed over every play on pass plays with the team on offense, where 1 is best. |
#'    |EPAgame_off_pass_rank                |double    |National rank of the team's EPA per game (total EPA divided by games) on pass plays with the team on offense, where 1 is best. |
#'    |EPAplay_off_pass_rank                |double    |National rank of the team's EPA per play on pass plays with the team on offense, where 1 is best. |
#'    |EPAdrive_off_pass_rank               |double    |National rank of the team's EPA per drive (total EPA divided by drives) on pass plays with the team on offense, where 1 is best. |
#'    |early_down_EPA_off_pass_rank         |double    |National rank of the team's EPA per early-down play on pass plays with the team on offense, where 1 is best. |
#'    |success_off_pass_rank                |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA on pass plays with the team on offense, where 1 is best. |
#'    |yards_off_pass_rank                  |double    |National rank of the team's total yards gained on pass plays with the team on offense, where 1 is best. |
#'    |yardsplay_off_pass_rank              |double    |National rank of the team's yards gained per play on pass plays with the team on offense, where 1 is best. |
#'    |yardsgame_off_pass_rank              |double    |National rank of the team's yards gained per game on pass plays with the team on offense, where 1 is best. |
#'    |drivesgame_off_pass_rank             |double    |National rank of the team's drives per game on pass plays with the team on offense, where 1 is best. |
#'    |yardsdrive_off_pass_rank             |double    |National rank of the team's yards gained per drive on pass plays with the team on offense, where 1 is best. |
#'    |playsdrive_off_pass_rank             |double    |National rank of the team's plays run per drive on pass plays with the team on offense, where 1 is best. |
#'    |play_stuffed_off_pass_rank           |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag on pass plays with the team on offense, where 1 is best. |
#'    |red_zone_success_off_pass_rank       |double    |National rank of the team's success rate on red-zone plays on pass plays with the team on offense, where 1 is best. |
#'    |third_down_success_off_pass_rank     |double    |National rank of the team's success rate on third-down plays on pass plays with the team on offense, where 1 is best. |
#'    |late_down_success_off_pass_rank      |double    |National rank of the team's success rate on late-down plays on pass plays with the team on offense, where 1 is best. |
#'    |third_down_distance_off_pass_rank    |double    |National rank of the team's average yards to go on third down on pass plays with the team on offense, where 1 is best. |
#'    |havoc_off_pass_rank                  |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag on pass plays with the team on offense, where 1 is best. |
#'    |explosive_off_pass_rank              |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag on pass plays with the team on offense, where 1 is best. |
#'    |passrate_off_pass_rank               |double    |National rank of the team's share of plays that were pass plays on pass plays with the team on offense, where 1 is best. |
#'    |rushrate_off_pass_rank               |double    |National rank of the team's share of plays that were rush plays on pass plays with the team on offense, where 1 is best. |
#'    |nonExplosiveEpaPerPlay_off_pass_rank |double    |National rank of the team's EPA per play with explosive plays excluded on pass plays with the team on offense, where 1 is best. |
#'    |line_yards_off_pass_rank             |double    |National rank of the team's average line yards credited to the offensive line on rushes on pass plays with the team on offense, where 1 is best. |
#'    |opportunity_rate_off_pass_rank       |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag on pass plays with the team on offense, where 1 is best. |
#'    |plays_def_pass                       |integer   |Plays run on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |passrate_def_pass                    |double    |Share of plays that were pass plays on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |rushrate_def_pass                    |double    |Share of plays that were rush plays on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |havoc_def_pass                       |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |explosive_def_pass                   |double    |Explosive-play rate -- the share of plays carrying the explosive flag on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |TEPA_def_pass                        |double    |Total EPA summed over every play on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAplay_def_pass                     |double    |EPA per play on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |yards_def_pass                       |integer   |Total yards gained on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsplay_def_pass                   |double    |Yards gained per play on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |play_stuffed_def_pass                |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |success_def_pass                     |double    |Success rate -- the share of plays flagged as successful by EPA on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |red_zone_success_def_pass            |double    |Success rate on red-zone plays on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_success_def_pass          |double    |Success rate on third-down plays on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_distance_def_pass         |double    |Average yards to go on third down on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |late_down_success_def_pass           |double    |Success rate on late-down plays on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |early_down_EPA_def_pass              |double    |EPA per early-down play on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |nonExplosiveEpaPerPlay_def_pass      |double    |EPA per play with explosive plays excluded on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |line_yards_def_pass                  |double    |Average line yards credited to the offensive line on rushes on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |opportunity_rate_def_pass            |double    |Opportunity rate -- the share of rushes carrying the opportunity flag on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def_pass                   |double    |Plays run per game on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAdrive_def_pass                    |double    |EPA per drive (total EPA divided by drives) on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAgame_def_pass                     |double    |EPA per game (total EPA divided by games) on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsgame_def_pass                   |double    |Yards gained per game on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |drives_def_pass                      |integer   |Offensive drives on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |drivesgame_def_pass                  |double    |Drives per game on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsdrive_def_pass                  |double    |Yards gained per drive on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsdrive_def_pass                  |double    |Plays run per drive on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def_pass_rank              |double    |National rank of the team's plays run per game on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_def_pass_rank                   |double    |National rank of the team's total EPA summed over every play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAgame_def_pass_rank                |double    |National rank of the team's EPA per game (total EPA divided by games) on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAplay_def_pass_rank                |double    |National rank of the team's EPA per play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAdrive_def_pass_rank               |double    |National rank of the team's EPA per drive (total EPA divided by drives) on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |early_down_EPA_def_pass_rank         |double    |National rank of the team's EPA per early-down play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |success_def_pass_rank                |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yards_def_pass_rank                  |double    |National rank of the team's total yards gained on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsplay_def_pass_rank              |double    |National rank of the team's yards gained per play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsgame_def_pass_rank              |double    |National rank of the team's yards gained per game on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |drivesgame_def_pass_rank             |double    |National rank of the team's drives per game on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsdrive_def_pass_rank             |double    |National rank of the team's yards gained per drive on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |playsdrive_def_pass_rank             |double    |National rank of the team's plays run per drive on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |play_stuffed_def_pass_rank           |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |red_zone_success_def_pass_rank       |double    |National rank of the team's success rate on red-zone plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_success_def_pass_rank     |double    |National rank of the team's success rate on third-down plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |late_down_success_def_pass_rank      |double    |National rank of the team's success rate on late-down plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_distance_def_pass_rank    |double    |National rank of the team's average yards to go on third down on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |havoc_def_pass_rank                  |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |explosive_def_pass_rank              |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |passrate_def_pass_rank               |double    |National rank of the team's share of plays that were pass plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |rushrate_def_pass_rank               |double    |National rank of the team's share of plays that were rush plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |nonExplosiveEpaPerPlay_def_pass_rank |double    |National rank of the team's EPA per play with explosive plays excluded on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |line_yards_def_pass_rank             |double    |National rank of the team's average line yards credited to the offensive line on rushes on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |opportunity_rate_def_pass_rank       |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_margin_pass                     |double    |Margin in total EPA summed over every play on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAplay_margin_pass                  |double    |Margin in EPA per play on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAdrive_margin_pass                 |double    |Margin in EPA per drive (total EPA divided by drives) on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAgame_margin_pass                  |double    |Margin in EPA per game (total EPA divided by games) on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |success_margin_pass                  |double    |Margin in success rate -- the share of plays flagged as successful by EPA on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |yardsplay_margin_pass                |double    |Margin in yards gained per play on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |TEPA_margin_pass_rank                |double    |Margin in total EPA summed over every play on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAplay_margin_pass_rank             |double    |Margin in EPA per play on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAdrive_margin_pass_rank            |double    |Margin in EPA per drive (total EPA divided by drives) on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAgame_margin_pass_rank             |double    |Margin in EPA per game (total EPA divided by games) on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |success_margin_pass_rank             |double    |Margin in success rate -- the share of plays flagged as successful by EPA on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |yardsplay_margin_pass_rank           |double    |Margin in yards gained per play on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |plays_off_rush                       |integer   |Plays run on rush plays, with the team on offense. |
#'    |passrate_off_rush                    |double    |Share of plays that were pass plays on rush plays, with the team on offense. |
#'    |rushrate_off_rush                    |double    |Share of plays that were rush plays on rush plays, with the team on offense. |
#'    |havoc_off_rush                       |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag on rush plays, with the team on offense. |
#'    |explosive_off_rush                   |double    |Explosive-play rate -- the share of plays carrying the explosive flag on rush plays, with the team on offense. |
#'    |TEPA_off_rush                        |double    |Total EPA summed over every play on rush plays, with the team on offense. |
#'    |EPAplay_off_rush                     |double    |EPA per play on rush plays, with the team on offense. |
#'    |yards_off_rush                       |integer   |Total yards gained on rush plays, with the team on offense. |
#'    |yardsplay_off_rush                   |double    |Yards gained per play on rush plays, with the team on offense. |
#'    |play_stuffed_off_rush                |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag on rush plays, with the team on offense. |
#'    |success_off_rush                     |double    |Success rate -- the share of plays flagged as successful by EPA on rush plays, with the team on offense. |
#'    |red_zone_success_off_rush            |double    |Success rate on red-zone plays on rush plays, with the team on offense. |
#'    |third_down_success_off_rush          |double    |Success rate on third-down plays on rush plays, with the team on offense. |
#'    |third_down_distance_off_rush         |double    |Average yards to go on third down on rush plays, with the team on offense. |
#'    |late_down_success_off_rush           |double    |Success rate on late-down plays on rush plays, with the team on offense. |
#'    |early_down_EPA_off_rush              |double    |EPA per early-down play on rush plays, with the team on offense. |
#'    |nonExplosiveEpaPerPlay_off_rush      |double    |EPA per play with explosive plays excluded on rush plays, with the team on offense. |
#'    |line_yards_off_rush                  |double    |Average line yards credited to the offensive line on rushes on rush plays, with the team on offense. |
#'    |opportunity_rate_off_rush            |double    |Opportunity rate -- the share of rushes carrying the opportunity flag on rush plays, with the team on offense. |
#'    |playsgame_off_rush                   |double    |Plays run per game on rush plays, with the team on offense. |
#'    |EPAdrive_off_rush                    |double    |EPA per drive (total EPA divided by drives) on rush plays, with the team on offense. |
#'    |EPAgame_off_rush                     |double    |EPA per game (total EPA divided by games) on rush plays, with the team on offense. |
#'    |yardsgame_off_rush                   |double    |Yards gained per game on rush plays, with the team on offense. |
#'    |drives_off_rush                      |integer   |Offensive drives on rush plays, with the team on offense. |
#'    |drivesgame_off_rush                  |double    |Drives per game on rush plays, with the team on offense. |
#'    |yardsdrive_off_rush                  |double    |Yards gained per drive on rush plays, with the team on offense. |
#'    |playsdrive_off_rush                  |double    |Plays run per drive on rush plays, with the team on offense. |
#'    |playsgame_off_rush_rank              |double    |National rank of the team's plays run per game on rush plays with the team on offense, where 1 is best. |
#'    |TEPA_off_rush_rank                   |double    |National rank of the team's total EPA summed over every play on rush plays with the team on offense, where 1 is best. |
#'    |EPAgame_off_rush_rank                |double    |National rank of the team's EPA per game (total EPA divided by games) on rush plays with the team on offense, where 1 is best. |
#'    |EPAplay_off_rush_rank                |double    |National rank of the team's EPA per play on rush plays with the team on offense, where 1 is best. |
#'    |EPAdrive_off_rush_rank               |double    |National rank of the team's EPA per drive (total EPA divided by drives) on rush plays with the team on offense, where 1 is best. |
#'    |early_down_EPA_off_rush_rank         |double    |National rank of the team's EPA per early-down play on rush plays with the team on offense, where 1 is best. |
#'    |success_off_rush_rank                |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA on rush plays with the team on offense, where 1 is best. |
#'    |yards_off_rush_rank                  |double    |National rank of the team's total yards gained on rush plays with the team on offense, where 1 is best. |
#'    |yardsplay_off_rush_rank              |double    |National rank of the team's yards gained per play on rush plays with the team on offense, where 1 is best. |
#'    |yardsgame_off_rush_rank              |double    |National rank of the team's yards gained per game on rush plays with the team on offense, where 1 is best. |
#'    |drivesgame_off_rush_rank             |double    |National rank of the team's drives per game on rush plays with the team on offense, where 1 is best. |
#'    |yardsdrive_off_rush_rank             |double    |National rank of the team's yards gained per drive on rush plays with the team on offense, where 1 is best. |
#'    |playsdrive_off_rush_rank             |double    |National rank of the team's plays run per drive on rush plays with the team on offense, where 1 is best. |
#'    |play_stuffed_off_rush_rank           |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag on rush plays with the team on offense, where 1 is best. |
#'    |red_zone_success_off_rush_rank       |double    |National rank of the team's success rate on red-zone plays on rush plays with the team on offense, where 1 is best. |
#'    |third_down_success_off_rush_rank     |double    |National rank of the team's success rate on third-down plays on rush plays with the team on offense, where 1 is best. |
#'    |late_down_success_off_rush_rank      |double    |National rank of the team's success rate on late-down plays on rush plays with the team on offense, where 1 is best. |
#'    |third_down_distance_off_rush_rank    |double    |National rank of the team's average yards to go on third down on rush plays with the team on offense, where 1 is best. |
#'    |havoc_off_rush_rank                  |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag on rush plays with the team on offense, where 1 is best. |
#'    |explosive_off_rush_rank              |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag on rush plays with the team on offense, where 1 is best. |
#'    |passrate_off_rush_rank               |double    |National rank of the team's share of plays that were pass plays on rush plays with the team on offense, where 1 is best. |
#'    |rushrate_off_rush_rank               |double    |National rank of the team's share of plays that were rush plays on rush plays with the team on offense, where 1 is best. |
#'    |nonExplosiveEpaPerPlay_off_rush_rank |double    |National rank of the team's EPA per play with explosive plays excluded on rush plays with the team on offense, where 1 is best. |
#'    |line_yards_off_rush_rank             |double    |National rank of the team's average line yards credited to the offensive line on rushes on rush plays with the team on offense, where 1 is best. |
#'    |opportunity_rate_off_rush_rank       |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag on rush plays with the team on offense, where 1 is best. |
#'    |plays_def_rush                       |integer   |Plays run on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |passrate_def_rush                    |double    |Share of plays that were pass plays on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |rushrate_def_rush                    |double    |Share of plays that were rush plays on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |havoc_def_rush                       |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |explosive_def_rush                   |double    |Explosive-play rate -- the share of plays carrying the explosive flag on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |TEPA_def_rush                        |double    |Total EPA summed over every play on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAplay_def_rush                     |double    |EPA per play on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |yards_def_rush                       |integer   |Total yards gained on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsplay_def_rush                   |double    |Yards gained per play on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |play_stuffed_def_rush                |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |success_def_rush                     |double    |Success rate -- the share of plays flagged as successful by EPA on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |red_zone_success_def_rush            |double    |Success rate on red-zone plays on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_success_def_rush          |double    |Success rate on third-down plays on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_distance_def_rush         |double    |Average yards to go on third down on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |late_down_success_def_rush           |double    |Success rate on late-down plays on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |early_down_EPA_def_rush              |double    |EPA per early-down play on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |nonExplosiveEpaPerPlay_def_rush      |double    |EPA per play with explosive plays excluded on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |line_yards_def_rush                  |double    |Average line yards credited to the offensive line on rushes on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |opportunity_rate_def_rush            |double    |Opportunity rate -- the share of rushes carrying the opportunity flag on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def_rush                   |double    |Plays run per game on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAdrive_def_rush                    |double    |EPA per drive (total EPA divided by drives) on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAgame_def_rush                     |double    |EPA per game (total EPA divided by games) on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsgame_def_rush                   |double    |Yards gained per game on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |drives_def_rush                      |integer   |Offensive drives on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |drivesgame_def_rush                  |double    |Drives per game on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsdrive_def_rush                  |double    |Yards gained per drive on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsdrive_def_rush                  |double    |Plays run per drive on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def_rush_rank              |double    |National rank of the team's plays run per game on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_def_rush_rank                   |double    |National rank of the team's total EPA summed over every play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAgame_def_rush_rank                |double    |National rank of the team's EPA per game (total EPA divided by games) on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAplay_def_rush_rank                |double    |National rank of the team's EPA per play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAdrive_def_rush_rank               |double    |National rank of the team's EPA per drive (total EPA divided by drives) on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |early_down_EPA_def_rush_rank         |double    |National rank of the team's EPA per early-down play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |success_def_rush_rank                |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yards_def_rush_rank                  |double    |National rank of the team's total yards gained on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsplay_def_rush_rank              |double    |National rank of the team's yards gained per play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsgame_def_rush_rank              |double    |National rank of the team's yards gained per game on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |drivesgame_def_rush_rank             |double    |National rank of the team's drives per game on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsdrive_def_rush_rank             |double    |National rank of the team's yards gained per drive on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |playsdrive_def_rush_rank             |double    |National rank of the team's plays run per drive on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |play_stuffed_def_rush_rank           |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |red_zone_success_def_rush_rank       |double    |National rank of the team's success rate on red-zone plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_success_def_rush_rank     |double    |National rank of the team's success rate on third-down plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |late_down_success_def_rush_rank      |double    |National rank of the team's success rate on late-down plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_distance_def_rush_rank    |double    |National rank of the team's average yards to go on third down on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |havoc_def_rush_rank                  |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |explosive_def_rush_rank              |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |passrate_def_rush_rank               |double    |National rank of the team's share of plays that were pass plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |rushrate_def_rush_rank               |double    |National rank of the team's share of plays that were rush plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |nonExplosiveEpaPerPlay_def_rush_rank |double    |National rank of the team's EPA per play with explosive plays excluded on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |line_yards_def_rush_rank             |double    |National rank of the team's average line yards credited to the offensive line on rushes on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |opportunity_rate_def_rush_rank       |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_margin_rush                     |double    |Margin in total EPA summed over every play on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAplay_margin_rush                  |double    |Margin in EPA per play on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAdrive_margin_rush                 |double    |Margin in EPA per drive (total EPA divided by drives) on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAgame_margin_rush                  |double    |Margin in EPA per game (total EPA divided by games) on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |success_margin_rush                  |double    |Margin in success rate -- the share of plays flagged as successful by EPA on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |yardsplay_margin_rush                |double    |Margin in yards gained per play on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |TEPA_margin_rush_rank                |double    |Margin in total EPA summed over every play on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAplay_margin_rush_rank             |double    |Margin in EPA per play on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAdrive_margin_rush_rank            |double    |Margin in EPA per drive (total EPA divided by drives) on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAgame_margin_rush_rank             |double    |Margin in EPA per game (total EPA divided by games) on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |success_margin_rush_rank             |double    |Margin in success rate -- the share of plays flagged as successful by EPA on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |yardsplay_margin_rush_rank           |double    |Margin in yards gained per play on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |fbs_class                            |character |Power/Group classification for the season: P4 or G6 from 2024 on, P5 or G5 through 2023, derived from conference membership (Notre Dame is classified with the power group). Null for teams outside FBS. |
#'    |valid_games                          |integer   |Number of the team's games that produced both an offensive and a defensive adjusted-EPA value; teams below two valid games are dropped from the adjusted ratings. |
#'    |adj_off_epa                          |double    |Offensive opponent-adjusted EPA per play from the ridge (RAPM-style) regression on offense/defense team indicators plus home field -- cfbfastR's adjust_epa adjustment, fit in-sample across the season, so the value is descriptive of that window rather than predictive. |
#'    |adj_def_epa                          |double    |Defensive opponent-adjusted EPA per play from the ridge (RAPM-style) regression on offense/defense team indicators plus home field -- cfbfastR's adjust_epa adjustment, fit in-sample across the season, so the value is descriptive of that window rather than predictive. Lower is better -- it is EPA allowed. |
#'    |off_strength_faced                   |double    |Average opponent-defense strength the team's offense faced, taken as the mean of the ridge's defensive coefficients across its opponents. Higher means a tougher slate. |
#'    |def_strength_faced                   |double    |Average opponent-offense strength the team's defense faced, taken as the mean of the ridge's offensive coefficients across its opponents. Higher means a tougher slate. |
#'    |net_adj_epa                          |double    |Net opponent-adjusted EPA per play: adj_off_epa minus adj_def_epa. Higher is better. |
#'    |adj_off_epa_rank                     |double    |National rank of the team's adj_off_epa, where 1 is best. |
#'    |adj_def_epa_rank                     |double    |National rank of the team's adj_def_epa, where 1 is best (fewest EPA allowed). |
#'    |net_adj_epa_rank                     |double    |National rank of the team's net_adj_epa, 1 = largest net adjusted EPA. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_team_summaries(2004))
#' }
#' @export
load_espn_cfb_team_summaries <- function(seasons = most_recent_cfb_season(), ...,
                                         dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_team_summaries/cfb_team_summaries_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football team season summaries from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football model-enriched play-by-play from the SportsDataverse data repo**
#' @name load_espn_cfb_model_pbp
NULL
#' @title
#' **Load college football model-enriched play-by-play from the SportsDataverse data repo**
#' @rdname load_espn_cfb_model_pbp
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_model_pbp (sportsdataverse-data release). Published to the
#'   `espn_cfb_model_pbp` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name             |types     |description |
#'    |---------------------|----------|:-----------|
#'    |game_id              |integer   | |
#'    |id                   |character | |
#'    |sequenceNumber       |character | |
#'    |game_play_number     |integer   | |
#'    |drive.id             |character |ESPN's drive identifier, formed as the game id followed by the drive's sequence number within that game. |
#'    |season               |integer   | |
#'    |week                 |integer   | |
#'    |period               |integer   | |
#'    |pos_team             |integer   | |
#'    |def_pos_team         |integer   | |
#'    |start.pos_team.name  |character |School name of the team with possession at the snap, taken from ESPN's team location field so it carries no mascot. |
#'    |homeTeamId           |integer   |ESPN team id of the home team, read off the game header and stamped on every play. |
#'    |awayTeamId           |integer   |ESPN team id of the away team, read off the game header and stamped on every play. |
#'    |homeTeamName         |character |Home team's school name from ESPN's team location field, without the mascot. |
#'    |awayTeamName         |character |Away team's school name from ESPN's team location field, without the mascot. |
#'    |type.text            |character |ESPN's play-type label, for example Rush, Pass Reception, Sack, Punt, Penalty, or Timeout. |
#'    |text                 |character | |
#'    |start.down           |integer   |Down at the snap as ESPN reports it; 0 marks the small share of rows ESPN leaves without a down, overwhelmingly timeouts and penalty administrations. |
#'    |start.distance       |integer   |Yards the offense needs for a first down at the snap, carried through from ESPN without correction. |
#'    |start.yardsToEndzone |integer   |Distance in yards from the offense's spot at the snap to the opponent's end zone, ranging 0 to 100. |
#'    |pos_score_diff_start |integer   | |
#'    |start.TimeSecsRem    |integer   |Seconds remaining in the half at the snap, so it tops out at 1800 rather than counting down from a full game. |
#'    |start.is_home        |logical   |True when the team holding possession at the snap is the home team. |
#'    |passing_down         |logical   |True on second and eight or longer, third and five or longer, or fourth and five or longer, the standard obvious-passing-situation flag. |
#'    |pass                 |logical   | |
#'    |rush                 |logical   | |
#'    |completion           |logical   | |
#'    |scoring_play         |logical   | |
#'    |statYardage          |integer   |Yards gained on the play as ESPN reports it, negative on plays that lost yardage. |
#'    |passer_player_name   |character |Display name of the passer -- the FIRST participant in that role on the play. |
#'    |ep_before            |double    | |
#'    |ep_after             |double    | |
#'    |epa                  |double    | |
#'    |wp_before            |double    | |
#'    |wp_after             |double    | |
#'    |wpa                  |double    | |
#'    |completion_prob      |double    |Modelled probability the pass is completed. |
#'    |cpoe                 |double    | |
#'    |model_pbp_version    |character |Version of the model-scored play-by-play build. |
#'    |cp_model_version     |character |Version of the completion-probability model that scored the play. |
#'    |ep_model_version     |character |Version of the expected-points model that scored the play. |
#'    |wp_model_version     |character |Version of the win-probability model that scored the play. |
#'    |scored_date          |character |Date on which the play was scored by the models. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_model_pbp(2004))
#' }
#' @export
load_espn_cfb_model_pbp <- function(seasons = most_recent_cfb_season(), ...,
                                    dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_model_pbp/model_pbp_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football model-enriched play-by-play from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football advanced defensive from the SportsDataverse data repo**
#' @name load_espn_cfb_adv_defensive
NULL
#' @title
#' **Load college football advanced defensive from the SportsDataverse data repo**
#' @rdname load_espn_cfb_adv_defensive
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_adv_defensive (sportsdataverse-data release). Published to
#'   the `espn_cfb_adv_defensive` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name              |types     |description |
#'    |----------------------|----------|:-----------|
#'    |def_pos_team_id       |integer   |ESPN team id of the team on defense. Present for every season 2004+. |
#'    |def_pos_team          |character | |
#'    |scrimmage_plays       |integer   |Number of plays from scrimmage (rushes plus passes), excluding special teams. |
#'    |TFL                   |integer   |Count of scrimmage plays the defense held to negative yardage (non-penalty, non-special-teams, ESPN statYardage below zero) plus every sack. |
#'    |TFL_pass              |integer   |The TFL count restricted to plays classified as passes, so it covers sacks together with completions and laterals stopped behind the line. |
#'    |TFL_rush              |integer   |The TFL count restricted to plays classified as rushes, that is rushing attempts the defense stopped for negative yardage. |
#'    |havoc_total           |integer   | |
#'    |havoc_total_rate      |double    |Share of the defense's scrimmage plays producing a havoc event, a 0-to-1 fraction equal to havoc_total divided by scrimmage_plays. |
#'    |fumbles               |integer   |Fumbles the defense forced, counted from plays whose narrative contains the phrase forced by, not the total number of fumbles on the play. |
#'    |def_int               |integer   |Interceptions the defense recorded, counted from plays ESPN types as Interception Return or Interception Return Touchdown. |
#'    |drive_stopped_rate    |double    |Percentage from 0 to 100 of the defense's scrimmage plays that occurred on drives ending in a punt, fumble, interception, or turnover on downs; the denominator is plays, not drives. |
#'    |num_pass_plays        |integer   |Number of pass scrimmage plays the defense faced, the denominator behind havoc_total_pass_rate and sacks_rate. |
#'    |havoc_total_pass      |integer   |Havoc events (tackle for loss, sack, interception, forced fumble, or pass breakup) recorded on the pass plays the defense faced. |
#'    |havoc_total_pass_rate |double    |havoc_total_pass divided by num_pass_plays, the defense's havoc rate against the pass as a 0-to-1 fraction. |
#'    |sacks                 |integer   | |
#'    |sacks_rate            |double    |Sacks divided by pass plays faced, the defense's per-pass-play sack rate as a 0-to-1 fraction. |
#'    |pass_breakups         |integer   |Passes the defense broke up, counted from plays whose narrative contains the phrase broken up by. |
#'    |havoc_total_rush      |integer   |Havoc events recorded on the rush plays the defense faced, in practice tackles for loss and forced fumbles. |
#'    |havoc_total_rush_rate |double    |Havoc events per rush play faced, the mean of the havoc flag over the defense's rush scrimmage plays. |
#'    |game_id               |integer   | |
#'    |season                |integer   | |
#'    |week                  |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_adv_defensive(2004))
#' }
#' @export
load_espn_cfb_adv_defensive <- function(seasons = most_recent_cfb_season(), ...,
                                        dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_adv_defensive/adv_defensive_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football advanced defensive from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football advanced defensive players from the SportsDataverse data repo**
#' @name load_espn_cfb_adv_defensive_players
NULL
#' @title
#' **Load college football advanced defensive players from the SportsDataverse data repo**
#' @rdname load_espn_cfb_adv_defensive_players
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_adv_defensive_players (sportsdataverse-data release).
#'   Published to the `espn_cfb_adv_defensive_players` release tag on the
#'   sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                |types     |description |
#'    |------------------------|----------|:-----------|
#'    |def_pos_team_id         |integer   |ESPN team id of the team on defense. Present for every season 2004+. |
#'    |def_pos_team            |character |Display name of the team on defense (e.g. 'Ohio State Buckeyes'). Held an ESPN team id until the 2026-08 republish; the id now lives in def_pos_team_id. |
#'    |player_name             |character |Display name of the defender. |
#'    |sacks                   |integer   |Sacks recorded by the defender. Available from 2005 on; null for 2004. |
#'    |sacks_yards             |integer   |Yards lost by the offense on the defender's sacks. Available from 2005 on; null for 2004. |
#'    |fumble_recoveries       |integer   |Fumbles recovered by the defender. Available for every season 2004+. |
#'    |fumble_recoveries_yards |integer   |Yards returned on the defender's fumble recoveries. Available for every season 2004+. |
#'    |game_id                 |integer   | |
#'    |season                  |integer   | |
#'    |week                    |integer   | |
#'    |pass_breakups           |integer   |Passes broken up by the defender. Available from 2005 on; null for 2004. |
#'    |interceptions           |integer   |Passes intercepted by the defender. Available from 2014 on; null for 2004-2013, which ESPN ships without interception statistics in this block. |
#'    |interceptions_yards     |integer   |Yards returned on the defender's interceptions. Available from 2014 on; null for 2004-2013. |
#'    |forced_fumbles          |integer   |Fumbles forced by the defender. Available from 2005 on; null for 2004, which ESPN ships with only the fumble-recovery statistics. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_adv_defensive_players(2004))
#' }
#' @export
load_espn_cfb_adv_defensive_players <- function(seasons = most_recent_cfb_season(), ...,
                                                dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_adv_defensive_players/adv_defensive_players_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football advanced defensive players from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football advanced drives from the SportsDataverse data repo**
#' @name load_espn_cfb_adv_drives
NULL
#' @title
#' **Load college football advanced drives from the SportsDataverse data repo**
#' @rdname load_espn_cfb_adv_drives
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_adv_drives (sportsdataverse-data release). Published to the
#'   `espn_cfb_adv_drives` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                      |types     |description |
#'    |------------------------------|----------|:-----------|
#'    |pos_team_id                   |integer   |ESPN team id of the team on offense. Present for every season 2004+. |
#'    |pos_team                      |character | |
#'    |drive_total_available_yards   |double    |Sum of each drive's starting distance to the opponent end zone taken across every scrimmage play, so a drive contributes its available yards once per play rather than once per drive. |
#'    |drive_total_gained_yards      |integer   |Sum of ESPN's per-drive yardage repeated across every scrimmage play of that drive, so a drive contributes its yardage once per play. |
#'    |avg_field_position            |double    |Mean distance to the opponent end zone at drive start averaged over the team's scrimmage plays, exactly drive_total_available_yards divided by that play count. |
#'    |plays_per_drive               |double    |Mean of ESPN's per-drive offensivePlays taken over plays rather than over drives, which weights every drive by its own length. |
#'    |yards_per_drive               |double    |Mean of ESPN's per-drive yardage taken over plays rather than over drives, exactly drive_total_gained_yards divided by the team's scrimmage-play count. |
#'    |drives                        |integer   |Number of distinct ESPN drive ids on which the team ran at least one scrimmage play. |
#'    |drive_total_gained_yards_rate |double    |Available-yards conversion as a percentage, 100 times drive_total_gained_yards over drive_total_available_yards with both sums play-weighted. |
#'    |game_id                       |integer   | |
#'    |season                        |integer   | |
#'    |week                          |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_adv_drives(2004))
#' }
#' @export
load_espn_cfb_adv_drives <- function(seasons = most_recent_cfb_season(), ...,
                                     dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_adv_drives/adv_drives_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football advanced drives from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football advanced passing from the SportsDataverse data repo**
#' @name load_espn_cfb_adv_passing
NULL
#' @title
#' **Load college football advanced passing from the SportsDataverse data repo**
#' @rdname load_espn_cfb_adv_passing
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_adv_passing (sportsdataverse-data release). Published to the
#'   `espn_cfb_adv_passing` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name           |types     |description |
#'    |-------------------|----------|:-----------|
#'    |pos_team_id        |integer   |ESPN team id of the team on offense. Present for every season 2004+. |
#'    |pos_team           |character | |
#'    |passer_player_name |character |Display name of the passer -- the FIRST participant in that role on the play. |
#'    |Comp               |integer   |Completed passes recorded in the advanced box score. |
#'    |Att                |integer   |Pass attempts recorded in the advanced box score. |
#'    |xComp              |double    |Expected completions, summed from the per-play completion model. |
#'    |Yds                |double    |Passing yards from the advanced box score. |
#'    |Pass_TD            |integer   |Passing touchdowns. |
#'    |Int                |integer   |Interceptions thrown. |
#'    |YPA                |double    |Yards per pass attempt. |
#'    |EPA                |double    | |
#'    |EPA_per_Play       |double    |EPA per play on the passer's plays. |
#'    |WPA                |double    | |
#'    |SR                 |double    |Success rate on the passer's plays. |
#'    |Sck                |integer   |Times the passer was sacked. |
#'    |CompPct            |double    |Completion percentage from the advanced box score. |
#'    |xCompPct           |double    |Expected completion percentage from the per-play completion model. |
#'    |CPOE               |double    |Completion percentage over expected -- actual minus modelled completion rate. |
#'    |qbr_epa            |double    |EPA variant used as an input to the QBR calculation. |
#'    |sack_epa           |double    |EPA credited to the player's sacks taken. |
#'    |pass_epa           |double    |EPA credited to the player's pass plays. |
#'    |rush_epa           |double    |EPA credited to the player's rush plays. |
#'    |pen_epa            |double    |EPA attributable to penalties on the player's plays. |
#'    |spread             |double    | |
#'    |era0               |integer   |Rule-era indicator for the earliest modelled era. |
#'    |era1               |integer   |Rule-era indicator for the second modelled era. |
#'    |era2               |integer   |Rule-era indicator for the third modelled era. |
#'    |era3               |integer   |Rule-era indicator for the most recent modelled era. |
#'    |exp_qbr            |double    |Expected QBR for the passer. |
#'    |game_id            |integer   | |
#'    |season             |integer   | |
#'    |week               |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_adv_passing(2004))
#' }
#' @export
load_espn_cfb_adv_passing <- function(seasons = most_recent_cfb_season(), ...,
                                      dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_adv_passing/adv_passing_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football advanced passing from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football advanced receiving from the SportsDataverse data repo**
#' @name load_espn_cfb_adv_receiving
NULL
#' @title
#' **Load college football advanced receiving from the SportsDataverse data repo**
#' @rdname load_espn_cfb_adv_receiving
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_adv_receiving (sportsdataverse-data release). Published to
#'   the `espn_cfb_adv_receiving` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name             |types     |description |
#'    |---------------------|----------|:-----------|
#'    |pos_team_id          |integer   |ESPN team id of the team on offense. Present for every season 2004+. |
#'    |pos_team             |character | |
#'    |receiver_player_name |character |Display name of the targeted receiver -- the FIRST participant in that role on the play. |
#'    |Rec                  |integer   |Receptions credited to the receiver, the number of completions on plays where this player was the targeted receiver. |
#'    |Tar                  |integer   |Times the player was targeted on a pass attempt, the denominator behind YPT. |
#'    |Yds                  |double    |Passing yards from the advanced box score. |
#'    |Rec_TD               |integer   |Receiving touchdowns, the count of the player's targeted plays that ended in a passing touchdown. |
#'    |YPT                  |double    |Receiving yards per target, the mean of receiving yardage over every target rather than over receptions only. |
#'    |EPA                  |double    | |
#'    |EPA_per_Play         |double    |EPA per play on the passer's plays. |
#'    |WPA                  |double    | |
#'    |SR                   |double    |Success rate on the passer's plays. |
#'    |Fum                  |integer   |Count of the receiver's targeted pass plays whose text mentions a fumble; it is a play-level flag, not a fumble charged to this player. |
#'    |Fum_Lost             |integer   |Count of the receiver's targeted plays on which a fumble was lost to the opponent. |
#'    |game_id              |integer   | |
#'    |season               |integer   | |
#'    |week                 |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_adv_receiving(2004))
#' }
#' @export
load_espn_cfb_adv_receiving <- function(seasons = most_recent_cfb_season(), ...,
                                        dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_adv_receiving/adv_receiving_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football advanced receiving from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football advanced rushing from the SportsDataverse data repo**
#' @name load_espn_cfb_adv_rushing
NULL
#' @title
#' **Load college football advanced rushing from the SportsDataverse data repo**
#' @rdname load_espn_cfb_adv_rushing
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_adv_rushing (sportsdataverse-data release). Published to the
#'   `espn_cfb_adv_rushing` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name           |types     |description |
#'    |-------------------|----------|:-----------|
#'    |pos_team_id        |integer   |ESPN team id of the team on offense. Present for every season 2004+. |
#'    |pos_team           |character | |
#'    |rusher_player_name |character |Display name of the ball carrier on a rush -- the FIRST participant in that role on the play. |
#'    |Car                |integer   |Rushing attempts credited to this ball carrier in the game. |
#'    |Yds                |double    |Passing yards from the advanced box score. |
#'    |Rush_TD            |integer   |Rushing touchdowns scored by this ball carrier in the game. |
#'    |YPC                |double    |Yards per carry, the mean rushing yardage across the player's attempts in the game. |
#'    |EPA                |double    | |
#'    |EPA_per_Play       |double    |EPA per play on the passer's plays. |
#'    |WPA                |double    | |
#'    |SR                 |double    |Success rate on the passer's plays. |
#'    |Fum                |integer   |Count of the carrier's rush attempts whose play text mentions a fumble; it is a play-level flag, not a fumble charged to this player. |
#'    |Fum_Lost           |integer   |Count of the carrier's rush attempts on which a fumble was lost to the opponent. |
#'    |game_id            |integer   | |
#'    |season             |integer   | |
#'    |week               |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_adv_rushing(2004))
#' }
#' @export
load_espn_cfb_adv_rushing <- function(seasons = most_recent_cfb_season(), ...,
                                      dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_adv_rushing/adv_rushing_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football advanced rushing from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football advanced situational from the SportsDataverse data repo**
#' @name load_espn_cfb_adv_situational
NULL
#' @title
#' **Load college football advanced situational from the SportsDataverse data repo**
#' @rdname load_espn_cfb_adv_situational
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_adv_situational (sportsdataverse-data release). Published to
#'   the `espn_cfb_adv_situational` release tag on the sportsdataverse-data
#'   repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                         |types     |description |
#'    |---------------------------------|----------|:-----------|
#'    |pos_team_id                      |integer   |ESPN team id of the team on offense. Present for every season 2004+. |
#'    |pos_team                         |character |Display name of the team on offense (e.g. 'Ohio State Buckeyes'). |
#'    |EPA_success                      |integer   |Count of successful plays. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_rate                 |double    |Success rate -- the share of those plays ESPN scored as successful. |
#'    |EPA_success_pass                 |integer   |Count of successful plays on pass plays. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_pass_rate            |double    |Success rate on pass plays -- the share of those plays ESPN scored as successful. |
#'    |EPA_success_rush                 |integer   |Count of successful plays on rush plays. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_rush_rate            |double    |Success rate on rush plays -- the share of those plays ESPN scored as successful. |
#'    |EPA_success_rz                   |integer   |Count of successful plays on the red zone. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_rate_rz              |double    |Success rate on the red zone -- the share of those plays ESPN scored as successful. |
#'    |EPA_success_third                |integer   |Count of successful plays on third down. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_rate_third           |double    |Success rate on third down -- the share of those plays ESPN scored as successful. |
#'    |EPA_success_early_down           |integer   |Count of successful plays on early downs. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_early_down_rate      |double    |Success rate on early downs -- the share of those plays ESPN scored as successful. |
#'    |early_downs                      |integer   |Number of plays the team ran on early downs. |
#'    |early_down_pass_rate             |double    |Share of the team's plays on early downs that were pass plays. |
#'    |early_down_rush_rate             |double    |Share of the team's plays on early downs that were rush plays. |
#'    |EPA_early_down                   |double    |Total EPA the team generated on early downs. |
#'    |EPA_early_down_per_play          |double    |EPA per play on early downs. |
#'    |early_down_first_down            |integer   |Number of early-down plays that produced a first down. |
#'    |early_down_first_down_rate       |double    |Share of early-down plays that produced a first down. |
#'    |early_down_pass                  |integer   |Number of pass plays the team ran on early downs. |
#'    |EPA_early_down_pass              |double    |Total EPA the team generated on early downs on pass plays. |
#'    |EPA_early_down_pass_per_play     |double    |EPA per play on early downs on pass plays. |
#'    |EPA_success_early_down_pass      |integer   |Count of successful plays on early downs on pass plays. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_early_down_pass_rate |double    |Success rate on early downs on pass plays -- the share of those plays ESPN scored as successful. |
#'    |early_down_rush                  |integer   |Number of rush plays the team ran on early downs. |
#'    |EPA_early_down_rush              |double    |Total EPA the team generated on early downs on rush plays. |
#'    |EPA_early_down_rush_per_play     |double    |EPA per play on early downs on rush plays. |
#'    |EPA_success_early_down_rush      |integer   |Count of successful plays on early downs on rush plays. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_early_down_rush_rate |double    |Success rate on early downs on rush plays -- the share of those plays ESPN scored as successful. |
#'    |middle_8                         |integer   |Number of plays the team ran in the middle eight -- the closing minutes of the first half and opening minutes of the second. |
#'    |middle_8_pass_rate               |double    |Share of the team's plays on the middle eight -- the closing minutes of the first half and opening minutes of the second that were pass plays. |
#'    |middle_8_rush_rate               |double    |Share of the team's plays on the middle eight -- the closing minutes of the first half and opening minutes of the second that were rush plays. |
#'    |EPA_middle_8                     |double    |Total EPA the team generated on the middle eight -- the closing minutes of the first half and opening minutes of the second. |
#'    |EPA_middle_8_per_play            |double    |EPA per play on the middle eight -- the closing minutes of the first half and opening minutes of the second. |
#'    |EPA_middle_8_success             |integer   |Count of successful plays on the middle eight -- the closing minutes of the first half and opening minutes of the second. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_middle_8_success_rate        |double    |Success rate on the middle eight -- the closing minutes of the first half and opening minutes of the second -- the share of those plays ESPN scored as successful. |
#'    |middle_8_pass                    |integer   |Number of pass plays the team ran on the middle eight -- the closing minutes of the first half and opening minutes of the second. |
#'    |EPA_middle_8_pass                |double    |Total EPA the team generated on the middle eight -- the closing minutes of the first half and opening minutes of the second on pass plays. |
#'    |EPA_middle_8_pass_per_play       |double    |EPA per play on the middle eight -- the closing minutes of the first half and opening minutes of the second on pass plays. |
#'    |EPA_middle_8_success_pass        |integer   |Count of successful plays on the middle eight -- the closing minutes of the first half and opening minutes of the second on pass plays. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_middle_8_success_pass_rate   |double    |Success rate on the middle eight -- the closing minutes of the first half and opening minutes of the second on pass plays -- the share of those plays ESPN scored as successful. |
#'    |middle_8_rush                    |integer   |Number of rush plays the team ran on the middle eight -- the closing minutes of the first half and opening minutes of the second. |
#'    |EPA_middle_8_rush                |double    |Total EPA the team generated on the middle eight -- the closing minutes of the first half and opening minutes of the second on rush plays. |
#'    |EPA_middle_8_rush_per_play       |double    |EPA per play on the middle eight -- the closing minutes of the first half and opening minutes of the second on rush plays. |
#'    |EPA_middle_8_success_rush        |integer   |Count of successful plays on the middle eight -- the closing minutes of the first half and opening minutes of the second on rush plays. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_middle_8_success_rush_rate   |double    |Success rate on the middle eight -- the closing minutes of the first half and opening minutes of the second on rush plays -- the share of those plays ESPN scored as successful. |
#'    |EPA_success_late_down            |integer   |Count of successful plays on late downs. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_late_down_pass       |integer   |Count of successful plays on late downs on pass plays. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_late_down_rush       |integer   |Count of successful plays on late downs on rush plays. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |late_downs                       |integer   |Number of plays the team ran on late downs. |
#'    |late_down_pass                   |integer   |Number of pass plays the team ran on late downs. |
#'    |late_down_rush                   |integer   |Number of rush plays the team ran on late downs. |
#'    |EPA_late_down                    |double    |Total EPA the team generated on late downs. |
#'    |EPA_late_down_per_play           |double    |EPA per play on late downs. |
#'    |EPA_success_late_down_rate       |double    |Success rate on late downs -- the share of those plays ESPN scored as successful. |
#'    |EPA_success_late_down_pass_rate  |double    |Success rate on late downs on pass plays -- the share of those plays ESPN scored as successful. |
#'    |EPA_success_late_down_rush_rate  |double    |Success rate on late downs on rush plays -- the share of those plays ESPN scored as successful. |
#'    |late_down_pass_rate              |double    |Share of the team's plays on late downs that were pass plays. |
#'    |late_down_rush_rate              |double    |Share of the team's plays on late downs that were rush plays. |
#'    |EPA_success_standard_down        |integer   |Count of successful plays on standard downs (the team ahead of schedule for the series). Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_standard_down_rate   |double    |Success rate on standard downs (the team ahead of schedule for the series) -- the share of those plays ESPN scored as successful. |
#'    |EPA_standard_down                |double    |Total EPA the team generated on standard downs (the team ahead of schedule for the series). |
#'    |EPA_standard_down_per_play       |double    |EPA per play on standard downs (the team ahead of schedule for the series). |
#'    |standard_downs                   |integer   |Number of plays the team ran on standard downs (the team ahead of schedule for the series). |
#'    |EPA_success_passing_down         |integer   |Count of successful plays on passing downs (the team behind schedule for the series). Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_success_passing_down_rate    |double    |Success rate on passing downs (the team behind schedule for the series) -- the share of those plays ESPN scored as successful. |
#'    |EPA_passing_down                 |double    |Total EPA the team generated on passing downs (the team behind schedule for the series). |
#'    |EPA_passing_down_per_play        |double    |EPA per play on passing downs (the team behind schedule for the series). |
#'    |passing_downs                    |integer   |Number of plays the team ran on passing downs (the team behind schedule for the series). |
#'    |game_id                          |integer   | |
#'    |season                           |integer   | |
#'    |week                             |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_adv_situational(2004))
#' }
#' @export
load_espn_cfb_adv_situational <- function(seasons = most_recent_cfb_season(), ...,
                                          dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_adv_situational/adv_situational_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football advanced situational from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football advanced specialists from the SportsDataverse data repo**
#' @name load_espn_cfb_adv_specialists
NULL
#' @title
#' **Load college football advanced specialists from the SportsDataverse data repo**
#' @rdname load_espn_cfb_adv_specialists
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_adv_specialists (sportsdataverse-data release). Published to
#'   the `espn_cfb_adv_specialists` release tag on the sportsdataverse-data
#'   repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name           |types     |description |
#'    |-------------------|----------|:-----------|
#'    |pos_team_id        |integer   |ESPN team id of the team on offense. Present for every season 2004+. |
#'    |pos_team           |character | |
#'    |player_name        |character | |
#'    |field_goals        |integer   |Number of field-goal attempts. |
#'    |field_goals_yards  |integer   |Sum of the field-goal attempt distances parsed out of the play text; it stays at zero when no distance could be parsed from the narrative. |
#'    |punts              |integer   |Punts attempted. |
#'    |punts_yards        |integer   |Total gross punt yardage parsed from the play text for this punter, working out to roughly 42 yards per punt league-wide. |
#'    |kick_returns       |integer   | |
#'    |kick_returns_yards |integer   |Total yards the team gained returning kickoffs. |
#'    |punt_returns       |integer   | |
#'    |punt_returns_yards |integer   |Total punt-return yardage credited to this returner, with fair catches, downed punts, and out-of-bounds punts scored as zero. |
#'    |game_id            |integer   | |
#'    |season             |integer   | |
#'    |week               |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_adv_specialists(2004))
#' }
#' @export
load_espn_cfb_adv_specialists <- function(seasons = most_recent_cfb_season(), ...,
                                          dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_adv_specialists/adv_specialists_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football advanced specialists from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football advanced team from the SportsDataverse data repo**
#' @name load_espn_cfb_adv_team
NULL
#' @title
#' **Load college football advanced team from the SportsDataverse data repo**
#' @rdname load_espn_cfb_adv_team
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_adv_team (sportsdataverse-data release). Published to the
#'   `espn_cfb_adv_team` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                           |types     |description |
#'    |-----------------------------------|----------|:-----------|
#'    |pos_team_id                        |integer   |ESPN team id of the team on offense. Present for every season 2004+. |
#'    |pos_team                           |character | |
#'    |rushing_highlight_yards_per_opp    |double    |Highlight yards per rushing opportunity. |
#'    |total_pen_yards                    |integer   |Total penalty yards assessed. |
#'    |EPA_penalty                        |double    |Total EPA attributed to penalties. |
#'    |penalty_first_downs_created        |integer   |Number of first downs the team gained via opponent penalty. |
#'    |penalty_first_downs_created_rate   |double    |Share of the team's first downs that came via opponent penalty. |
#'    |penalties                          |integer   |Number of penalties assessed against the team. |
#'    |penalty_yards                      |integer   |Net penalty yardage assessed against the team; can be negative when enforcement moved the team forward on balance. |
#'    |special_teams_plays                |integer   |Number of special-teams plays. |
#'    |EPA_sp                             |double    |Total special-teams EPA, ESPN's abbreviated field for the same phase. |
#'    |EPA_special_teams                  |double    |Total EPA generated on special-teams plays. |
#'    |field_goals                        |integer   |Number of field-goal attempts. |
#'    |EPA_fg                             |double    |Total EPA on field-goal attempts. |
#'    |punt_plays                         |integer   |Number of punt plays. |
#'    |EPA_punt                           |double    |Total EPA on punt plays. |
#'    |kickoff_plays                      |integer   |Number of kickoff plays. |
#'    |EPA_kickoff                        |double    |Total EPA on kickoff plays. |
#'    |rushes                             |integer   |Number of rushing attempts. |
#'    |rush_yards                         |double    |Total yards the team gained on rush plays. |
#'    |yards_per_rush                     |double    |Yards gained per rushing attempt. |
#'    |rushing_power_rate                 |double    |Share of carries that were power rushing attempts. |
#'    |rushing_first_downs_created        |integer   |Number of first downs created on rush plays. |
#'    |rushing_first_downs_created_rate   |double    |Share of rush plays that created a first down. |
#'    |EPA_rushing_overall                |double    |Total EPA on rush plays. |
#'    |EPA_rushing_per_play               |double    |EPA per rush play. |
#'    |EPA_explosive_rushing              |integer   |Count of explosive rush plays. A play count, not an EPA total. |
#'    |EPA_explosive_rushing_rate         |double    |Explosive-play rate on rush plays, over ESPN's qualifying-play denominator. |
#'    |EPA_non_explosive_rushing          |double    |Total EPA on rush plays with explosive plays excluded. |
#'    |EPA_non_explosive_rushing_per_play |double    |EPA per rush play with explosive plays excluded. |
#'    |passes                             |integer   |Number of pass plays the team ran. |
#'    |pass_yards                         |double    |Total yards the team gained on pass plays. |
#'    |yards_per_pass                     |double    | |
#'    |passing_first_downs_created        |integer   |Number of first downs created on pass plays. |
#'    |passing_first_downs_created_rate   |double    |Share of pass plays that created a first down. |
#'    |EPA_passing_overall                |double    |Total EPA on pass plays. |
#'    |EPA_passing_per_play               |double    |EPA per pass play. |
#'    |EPA_explosive_passing              |integer   |Count of explosive pass plays. A play count, not an EPA total. |
#'    |EPA_explosive_passing_rate         |double    |Explosive-play rate on pass plays, over ESPN's qualifying-play denominator. |
#'    |EPA_non_explosive_passing          |double    |Total EPA on pass plays with explosive plays excluded. |
#'    |EPA_non_explosive_passing_per_play |double    |EPA per pass play with explosive plays excluded. |
#'    |scrimmage_plays                    |integer   |Number of plays from scrimmage (rushes plus passes), excluding special teams. |
#'    |EPA_overall_off                    |double    |Total offensive EPA for the team. Duplicated exactly by EPA_overall_offense in every published season checked -- prefer one and ignore the other. |
#'    |EPA_overall_offense                |double    |Total offensive EPA. An exact duplicate of EPA_overall_off. |
#'    |EPA_per_play                       |double    |Offensive EPA per play. |
#'    |EPA_non_explosive                  |double    |Total EPA with explosive plays excluded, isolating the team's routine-down production. |
#'    |EPA_non_explosive_per_play         |double    |EPA per play with explosive plays excluded. |
#'    |EPA_explosive                      |integer   |Count of explosive plays, per ESPN's advanced box score. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_explosive_rate                 |double    |Explosive-play rate. Note this is NOT EPA_explosive divided by EPA_plays -- ESPN divides by its own smaller qualifying-play count, so deriving it yourself will not reproduce this value. |
#'    |passes_rate                        |double    |Share of the team's plays from scrimmage that were pass plays. |
#'    |off_yards                          |integer   |Offensive yards gained from scrimmage. |
#'    |total_off_yards                    |integer   |Total offensive yards across all plays. |
#'    |yards_per_play                     |double    |Yards gained per play. |
#'    |EPA_plays                          |integer   |Number of plays ESPN's advanced box score scored for the team. |
#'    |total_yards                        |integer   |Total yards the team gained across all plays. |
#'    |EPA_overall_total                  |double    |Total EPA across all phases, which is why it differs from the offense-only EPA_overall_off. |
#'    |rushes_rate                        |double    |Share of the team's plays from scrimmage that were rush plays. |
#'    |first_downs_created                |integer   |Number of first downs the team created. |
#'    |first_downs_created_rate           |double    |Share of the team's plays that created a first down. |
#'    |EPA_rushing_power                  |double    |Total EPA on power rushing situations, as classified by ESPN's advanced box score. |
#'    |EPA_rushing_power_per_play         |double    |EPA per play on power rushing situations. |
#'    |rushing_power_success              |integer   |Count of power rushing attempts that gained the yardage needed. An integer count, not a rate -- the rate is published separately as rushing_power_success_rate. |
#'    |rushing_power_success_rate         |double    |Share of power rushing attempts that succeeded. |
#'    |rushing_power                      |integer   |Count of power rushing attempts, in short-yardage situations as classified by ESPN's advanced box score. |
#'    |rushing_stuff                      |integer   |Count of stuffed rushing attempts. |
#'    |rushing_stuff_rate                 |double    |Share of the team's carries that were stuffed at or behind the line of scrimmage. |
#'    |rushing_stopped                    |integer   |Count of rushing attempts stopped at or behind the line of scrimmage. |
#'    |rushing_stopped_rate               |double    |Share of carries stopped at or behind the line of scrimmage. |
#'    |rushing_opportunity                |integer   |Count of rushing opportunities -- carries that reached ESPN's opportunity threshold. |
#'    |rushing_opportunity_rate           |double    |Share of carries that qualified as rushing opportunities. |
#'    |rushing_highlight                  |integer   |Highlight yards -- rushing yardage credited to the back rather than the offensive line. |
#'    |rushing_highlight_rate             |double    |Share of rushing yardage that was highlight (back-credited) yardage. |
#'    |rushing_highlight_yards            |double    |Total highlight yards the team accumulated -- the yardage credited to ball carriers rather than the line. The per-carry figure is rushing_highlight_yards_per_opp. |
#'    |line_yards                         |double    |Line yards -- the portion of rushing yardage credited to the offensive line under the standard rushing decomposition. ESPN applies its own qualifying threshold for the yardage split. |
#'    |line_yards_per_carry               |double    |Line yards per rushing attempt. |
#'    |second_level_yards                 |double    |Second-level yards -- rushing yardage earned just beyond the line of scrimmage. |
#'    |open_field_yards                   |double    |Open-field yards -- rushing yardage earned well downfield, past the second level. |
#'    |game_id                            |integer   | |
#'    |season                             |integer   | |
#'    |week                               |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_adv_team(2004))
#' }
#' @export
load_espn_cfb_adv_team <- function(seasons = most_recent_cfb_season(), ...,
                                   dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_adv_team/adv_team_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football advanced team from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football advanced team gamelog from the SportsDataverse data repo**
#' @name load_espn_cfb_adv_team_gamelog
NULL
#' @title
#' **Load college football advanced team gamelog from the SportsDataverse data repo**
#' @rdname load_espn_cfb_adv_team_gamelog
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_adv_team_gamelog (sportsdataverse-data release). Published
#'   to the `espn_cfb_adv_team_gamelog` release tag on the sportsdataverse-data
#'   repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                           |types     |description |
#'    |-----------------------------------|----------|:-----------|
#'    |season                             |integer   | |
#'    |week                               |integer   | |
#'    |season_type                        |integer   | |
#'    |game_id                            |integer   | |
#'    |start_date                         |character | |
#'    |team_id                            |integer   | |
#'    |team                               |character | |
#'    |opponent_id                        |integer   | |
#'    |opponent                           |character | |
#'    |is_home                            |logical   | |
#'    |neutral_site                       |logical   | |
#'    |points_for                         |integer   | |
#'    |points_against                     |integer   | |
#'    |margin                             |integer   |Final scoring margin from this team's perspective, exactly points_for minus points_against. |
#'    |win                                |logical   | |
#'    |rushing_highlight_yards_per_opp    |double    |Highlight yards per rushing opportunity. |
#'    |total_pen_yards                    |integer   |Total penalty yards assessed. |
#'    |EPA_penalty                        |double    |Total EPA attributed to penalties. |
#'    |penalty_first_downs_created        |integer   |Number of first downs the team gained via opponent penalty. |
#'    |penalty_first_downs_created_rate   |double    |Share of the team's first downs that came via opponent penalty. |
#'    |penalties                          |integer   |Number of penalties assessed against the team. |
#'    |penalty_yards                      |integer   |Net penalty yardage assessed against the team; can be negative when enforcement moved the team forward on balance. |
#'    |special_teams_plays                |integer   |Number of special-teams plays. |
#'    |EPA_sp                             |double    |Total special-teams EPA, ESPN's abbreviated field for the same phase. |
#'    |EPA_special_teams                  |double    |Total EPA generated on special-teams plays. |
#'    |field_goals                        |integer   |Number of field-goal attempts. |
#'    |EPA_fg                             |double    |Total EPA on field-goal attempts. |
#'    |punt_plays                         |integer   |Number of punt plays. |
#'    |EPA_punt                           |double    |Total EPA on punt plays. |
#'    |kickoff_plays                      |integer   |Number of kickoff plays. |
#'    |EPA_kickoff                        |double    |Total EPA on kickoff plays. |
#'    |rushes                             |integer   |Number of rushing attempts. |
#'    |rush_yards                         |double    |Total yards the team gained on rush plays. |
#'    |yards_per_rush                     |double    |Yards gained per rushing attempt. |
#'    |rushing_power_rate                 |double    |Share of carries that were power rushing attempts. |
#'    |rushing_first_downs_created        |integer   |Number of first downs created on rush plays. |
#'    |rushing_first_downs_created_rate   |double    |Share of rush plays that created a first down. |
#'    |EPA_rushing_overall                |double    |Total EPA on rush plays. |
#'    |EPA_rushing_per_play               |double    |EPA per rush play. |
#'    |EPA_explosive_rushing              |integer   |Count of explosive rush plays. A play count, not an EPA total. |
#'    |EPA_explosive_rushing_rate         |double    |Explosive-play rate on rush plays, over ESPN's qualifying-play denominator. |
#'    |EPA_non_explosive_rushing          |double    |Total EPA on rush plays with explosive plays excluded. |
#'    |EPA_non_explosive_rushing_per_play |double    |EPA per rush play with explosive plays excluded. |
#'    |passes                             |integer   |Number of pass plays the team ran. |
#'    |pass_yards                         |double    |Total yards the team gained on pass plays. |
#'    |yards_per_pass                     |double    | |
#'    |passing_first_downs_created        |integer   |Number of first downs created on pass plays. |
#'    |passing_first_downs_created_rate   |double    |Share of pass plays that created a first down. |
#'    |EPA_passing_overall                |double    |Total EPA on pass plays. |
#'    |EPA_passing_per_play               |double    |EPA per pass play. |
#'    |EPA_explosive_passing              |integer   |Count of explosive pass plays. A play count, not an EPA total. |
#'    |EPA_explosive_passing_rate         |double    |Explosive-play rate on pass plays, over ESPN's qualifying-play denominator. |
#'    |EPA_non_explosive_passing          |double    |Total EPA on pass plays with explosive plays excluded. |
#'    |EPA_non_explosive_passing_per_play |double    |EPA per pass play with explosive plays excluded. |
#'    |scrimmage_plays                    |integer   |Number of plays from scrimmage (rushes plus passes), excluding special teams. |
#'    |EPA_overall_off                    |double    |Total offensive EPA for the team. Duplicated exactly by EPA_overall_offense in every published season checked -- prefer one and ignore the other. |
#'    |EPA_overall_offense                |double    |Total offensive EPA. An exact duplicate of EPA_overall_off. |
#'    |EPA_per_play                       |double    |Offensive EPA per play. |
#'    |EPA_non_explosive                  |double    |Total EPA with explosive plays excluded, isolating the team's routine-down production. |
#'    |EPA_non_explosive_per_play         |double    |EPA per play with explosive plays excluded. |
#'    |EPA_explosive                      |integer   |Count of explosive plays, per ESPN's advanced box score. Despite the EPA_ prefix this is a play COUNT, not an EPA total. |
#'    |EPA_explosive_rate                 |double    |Explosive-play rate. Note this is NOT EPA_explosive divided by EPA_plays -- ESPN divides by its own smaller qualifying-play count, so deriving it yourself will not reproduce this value. |
#'    |passes_rate                        |double    |Share of the team's plays from scrimmage that were pass plays. |
#'    |off_yards                          |integer   |Offensive yards gained from scrimmage. |
#'    |total_off_yards                    |integer   |Total offensive yards across all plays. |
#'    |yards_per_play                     |double    |Yards gained per play. |
#'    |EPA_plays                          |integer   |Number of plays ESPN's advanced box score scored for the team. |
#'    |total_yards                        |integer   |Total yards the team gained across all plays. |
#'    |EPA_overall_total                  |double    |Total EPA across all phases, which is why it differs from the offense-only EPA_overall_off. |
#'    |rushes_rate                        |double    |Share of the team's plays from scrimmage that were rush plays. |
#'    |first_downs_created                |integer   |Number of first downs the team created. |
#'    |first_downs_created_rate           |double    |Share of the team's plays that created a first down. |
#'    |EPA_rushing_power                  |double    |Total EPA on power rushing situations, as classified by ESPN's advanced box score. |
#'    |EPA_rushing_power_per_play         |double    |EPA per play on power rushing situations. |
#'    |rushing_power_success              |integer   |Count of power rushing attempts that gained the yardage needed. An integer count, not a rate -- the rate is published separately as rushing_power_success_rate. |
#'    |rushing_power_success_rate         |double    |Share of power rushing attempts that succeeded. |
#'    |rushing_power                      |integer   |Count of power rushing attempts, in short-yardage situations as classified by ESPN's advanced box score. |
#'    |rushing_stuff                      |integer   |Count of stuffed rushing attempts. |
#'    |rushing_stuff_rate                 |double    |Share of the team's carries that were stuffed at or behind the line of scrimmage. |
#'    |rushing_stopped                    |integer   |Count of rushing attempts stopped at or behind the line of scrimmage. |
#'    |rushing_stopped_rate               |double    |Share of carries stopped at or behind the line of scrimmage. |
#'    |rushing_opportunity                |integer   |Count of rushing opportunities -- carries that reached ESPN's opportunity threshold. |
#'    |rushing_opportunity_rate           |double    |Share of carries that qualified as rushing opportunities. |
#'    |rushing_highlight                  |integer   |Highlight yards -- rushing yardage credited to the back rather than the offensive line. |
#'    |rushing_highlight_rate             |double    |Share of rushing yardage that was highlight (back-credited) yardage. |
#'    |rushing_highlight_yards            |double    |Total highlight yards the team accumulated -- the yardage credited to ball carriers rather than the line. The per-carry figure is rushing_highlight_yards_per_opp. |
#'    |line_yards                         |double    |Line yards -- the portion of rushing yardage credited to the offensive line under the standard rushing decomposition. ESPN applies its own qualifying threshold for the yardage split. |
#'    |line_yards_per_carry               |double    |Line yards per rushing attempt. |
#'    |second_level_yards                 |double    |Second-level yards -- rushing yardage earned just beyond the line of scrimmage. |
#'    |open_field_yards                   |double    |Open-field yards -- rushing yardage earned well downfield, past the second level. |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_adv_team_gamelog(2004))
#' }
#' @export
load_espn_cfb_adv_team_gamelog <- function(seasons = most_recent_cfb_season(), ...,
                                           dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_adv_team_gamelog/adv_team_gamelog_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football advanced team gamelog from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football advanced turnover from the SportsDataverse data repo**
#' @name load_espn_cfb_adv_turnover
NULL
#' @title
#' **Load college football advanced turnover from the SportsDataverse data repo**
#' @rdname load_espn_cfb_adv_turnover
#' @author Saiem Gilani
#' @description
#'   Load espn_cfb_adv_turnover (sportsdataverse-data release). Published to
#'   the `espn_cfb_adv_turnover` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                 |types     |description |
#'    |-------------------------|----------|:-----------|
#'    |pos_team_id              |integer   |ESPN team id of the team on offense. Present for every season 2004+. |
#'    |pos_team                 |character | |
#'    |turnovers                |integer   | |
#'    |st_turnovers_lost        |integer   |Turnovers the team lost on special-teams plays. |
#'    |Int                      |integer   |Interceptions thrown. |
#'    |fumbles_lost             |integer   | |
#'    |pass_breakups            |integer   |Passes thrown by this offense that the opposing defense broke up; it equals the opponent's row in the advanced defensive table exactly. |
#'    |total_fumbles            |integer   | |
#'    |fumbles_recovered        |integer   | |
#'    |team_id                  |integer   | |
#'    |turnovers_pbp            |integer   |Turnover count derived from the play-by-play, retained unchanged so it can be reconciled against the ESPN-sourced turnovers total. |
#'    |Int_pbp                  |integer   |Interception count derived from the play-by-play, kept alongside the ESPN-sourced Int for reconciliation. |
#'    |fumbles_lost_pbp         |integer   |Fumbles-lost count derived from the play-by-play, kept alongside the ESPN-sourced fumbles_lost for reconciliation. |
#'    |espn_sourced             |logical   |CONSTANT: true on every published row. It records that the row was built from the ESPN feed rather than an alternate provider, and no other provider is currently used. |
#'    |expected_turnovers       |double    |Turnover expectation for this team, computed as half its total fumbles plus 0.22 times the sum of its pass breakups and interceptions. |
#'    |expected_turnover_margin |double    |The opponent's expected_turnovers minus this team's, so positive means the team was expected to win the turnover battle. |
#'    |turnover_margin          |integer   |The opponent's turnovers minus this team's turnovers, positive when the team gained more possessions than it gave away. |
#'    |turnover_luck            |double    |Points of scoring luck attributed to turnovers, five points per turnover times the gap between turnover_margin and expected_turnover_margin. |
#'    |takeaways                |integer   | |
#'    |st_turnovers_gained      |integer   |Special-teams turnovers this team recovered, taken as the opponent's st_turnovers_lost. |
#'    |fumble_recoveries_gained |integer   |Opponent fumbles this team recovered, taken as the opponent's fumbles_lost. |
#'    |game_id                  |integer   | |
#'    |season                   |integer   | |
#'    |week                     |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_espn_cfb_adv_turnover(2004))
#' }
#' @export
load_espn_cfb_adv_turnover <- function(seasons = most_recent_cfb_season(), ...,
                                       dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "espn_cfb_adv_turnover/adv_turnover_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football advanced turnover from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}
