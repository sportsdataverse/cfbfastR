# **Load ESPN college football play-by-play from the SportsDataverse data repo**

Loads season-level ESPN-derived college football play-by-play – one row
per play with the full EPA/WPA model columns and participant ids,
covering 2004 to present. Published to the `espn_cfb_pbp` release tag on
the sportsdataverse-data repo.

Delineation from the sibling pbp loaders:
[`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md)
is the classic cfbfastR EPA/WPA pbp (FBS, 2014+, unchanged);
`load_espn_cfb_pbp()` is this ESPN-derived build with deeper history;
[`load_ncaa_mfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_ncaa_mfb_pbp.md)
is the stats.ncaa.org parse covering FCS and lower divisions (2013+).

## Usage

``` r
load_espn_cfb_pbp(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2004 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2004)

- ...:

  Additional arguments passed to an underlying function that writes the
  season data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble.

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer |  |
| game_id | integer |  |
| game_play_number | integer |  |
| pos_team | integer |  |
| def_pos_team | integer |  |
| pos_team_score | integer |  |
| def_pos_team_score | integer |  |
| half | integer |  |
| period | integer |  |
| down | integer |  |
| distance | integer |  |
| EPA | double |  |
| wpa | double |  |
| wp_before | double |  |
| wp_after | double |  |
| def_wp_before | double |  |
| def_wp_after | double |  |
| penalty_detail | character |  |
| yds_penalty | character |  |
| penalty_1st_conv | logical |  |
| def_EPA | double |  |
| rz_play | logical |  |
| scoring_opp | logical |  |
| middle_8 | logical |  |
| stuffed_run | logical |  |
| change_of_pos_team | logical |  |
| downs_turnover | logical |  |
| pos_score_diff_start | integer |  |
| pos_score_pts | integer |  |
| home_wp_before | double |  |
| away_wp_before | double |  |
| home_wp_after | double |  |
| away_wp_after | double |  |
| end_of_half | logical |  |
| lead_pos_team | integer | Value of pos_team on the next play, used for sequence-aware derivations. |
| lead_play_type | character | Value of play_type on the next play, used for sequence-aware derivations. |
| lag_pos_team | integer | Value of pos_team on the previous play, used for sequence-aware derivations. |
| orig_play_type | character |  |
| offense_score_play | logical |  |
| defense_score_play | logical |  |
| pos_score_diff | integer |  |
| change_of_poss | logical |  |
| rusher_player_name | character |  |
| yds_rushed | integer |  |
| passer_player_name | character |  |
| receiver_player_name | character |  |
| yds_receiving | integer |  |
| yds_sacked | integer |  |
| sack_players | character |  |
| sack_player_name | character |  |
| sack_player_name2 | character |  |
| pass_breakup_player_name | character |  |
| interception_player_name | character |  |
| yds_int_return | integer |  |
| fumble_player_name | character |  |
| fumble_forced_player_name | character |  |
| fumble_recovered_player_name | character |  |
| yds_fumble_return | integer |  |
| punter_player_name | character |  |
| yds_punted | integer |  |
| yds_punt_return | integer |  |
| yds_punt_gained | integer |  |
| punt_block_player_name | character |  |
| punt_block_return_player_name | character |  |
| fg_kicker_player_name | character |  |
| yds_fg | integer |  |
| fg_block_player_name | character |  |
| fg_return_player_name | character |  |
| kickoff_player_name | character |  |
| yds_kickoff | integer |  |
| yds_kickoff_return | integer |  |
| rush | logical |  |
| rush_td | logical |  |
| pass | logical |  |
| pass_td | logical |  |
| completion | logical |  |
| pass_attempt | logical |  |
| target | logical |  |
| sack_vec | logical |  |
| sack | logical |  |
| int | logical |  |
| int_td | logical |  |
| turnover_vec | logical |  |
| kickoff_play | logical |  |
| scoring_play | logical |  |
| td_play | logical |  |
| touchdown | logical |  |
| safety | logical |  |
| fumble_vec | logical |  |
| kickoff_tb | logical |  |
| kickoff_onside | logical |  |
| kickoff_oob | logical |  |
| kickoff_fair_catch | logical |  |
| kickoff_downed | logical |  |
| kickoff_safety | logical |  |
| kick_play | logical |  |
| punt | logical |  |
| punt_play | logical |  |
| punt_tb | logical |  |
| punt_oob | logical |  |
| punt_fair_catch | logical |  |
| punt_downed | logical |  |
| punt_safety | logical |  |
| punt_blocked | logical |  |
| penalty_safety | logical |  |
| fg_made | logical |  |
| fg_make_prob | double |  |
| penalty_flag | logical |  |
| penalty_declined | logical |  |
| penalty_no_play | logical |  |
| penalty_offset | logical |  |
| penalty_text | character |  |
| lead_wp_before2 | double | Value of wp_before 2 plays ahead, used for sequence-aware derivations. |
| lead_wp_before | double | Value of wp_before on the next play, used for sequence-aware derivations. |
| lead_pos_team2 | integer | Value of pos_team 2 plays ahead, used for sequence-aware derivations. |
| lag_change_of_pos_team | logical | Value of change_of_pos_team on the previous play, used for sequence-aware derivations. |
| lag_pos_score_diff | integer | Value of pos_score_diff on the previous play, used for sequence-aware derivations. |
| id | integer |  |
| sequenceNumber | integer |  |
| text | character |  |
| awayScore | integer |  |
| homeScore | integer |  |
| scoringPlay | logical | ESPN flag marking the play as a scoring play. |
| priority | logical |  |
| modified | character |  |
| wallclock | character |  |
| teamParticipants | character |  |
| isPenalty | logical |  |
| statYardage | integer | Yardage ESPN credits to the play for statistical purposes. |
| isTurnover | logical |  |
| type.id | character | ESPN's numeric identifier for the play type. |
| type.text | character | ESPN's text label for the play type. |
| type.abbreviation | character | ESPN's abbreviation for the play type. |
| period.number | integer | Period (quarter) number in which the play occurred. |
| clock.displayValue | character | Game clock at the play, as the displayed mm:ss string. |
| start.down | integer | ESPN's `down` value for the play state at the start of the play. |
| start.distance | integer | ESPN's `distance` value for the play state at the start of the play. |
| start.yardLine | integer | ESPN's `yardLine` value for the play state at the start of the play. |
| start.yardsToEndzone | integer | ESPN's `yardsToEndzone` value for the play state at the start of the play. |
| start.team.id | integer | ESPN's `team.id` value for the play state at the start of the play. |
| end.down | integer | ESPN's `down` value for the play state at the end of the play. |
| end.distance | integer | ESPN's `distance` value for the play state at the end of the play. |
| end.yardLine | integer | ESPN's `yardLine` value for the play state at the end of the play. |
| end.yardsToEndzone | integer | ESPN's `yardsToEndzone` value for the play state at the end of the play. |
| end.downDistanceText | character | ESPN's `downDistanceText` value for the play state at the end of the play. |
| end.shortDownDistanceText | character | ESPN's `shortDownDistanceText` value for the play state at the end of the play. |
| end.possessionText | character | ESPN's `possessionText` value for the play state at the end of the play. |
| end.team.id | integer | ESPN's `team.id` value for the play state at the end of the play. |
| start.downDistanceText | character | ESPN's `downDistanceText` value for the play state at the start of the play. |
| start.shortDownDistanceText | character | ESPN's `shortDownDistanceText` value for the play state at the start of the play. |
| start.possessionText | character | ESPN's `possessionText` value for the play state at the start of the play. |
| scoringType.name | character | ESPN's name for the scoring type (e.g. touchdown, field goal). |
| scoringType.displayName | character | ESPN's display label for the scoring type. |
| scoringType.abbreviation | character | ESPN's abbreviation for the scoring type. |
| pointAfterAttempt.id | double |  |
| pointAfterAttempt.text | character |  |
| pointAfterAttempt.abbreviation | character |  |
| pointAfterAttempt.value | double |  |
| drive.id | character | ESPN's `id` field for the drive containing this play. |
| drive.displayResult | character | ESPN's `displayResult` field for the drive containing this play. |
| drive.isScore | logical | ESPN's `isScore` field for the drive containing this play. |
| drive.team.shortDisplayName | character | ESPN's `team.shortDisplayName` field for the drive containing this play. |
| drive.team.displayName | character | ESPN's `team.displayName` field for the drive containing this play. |
| drive.team.name | character | ESPN's `team.name` field for the drive containing this play. |
| drive.team.abbreviation | character | ESPN's `team.abbreviation` field for the drive containing this play. |
| drive.yards | integer | ESPN's `yards` field for the drive containing this play. |
| drive.offensivePlays | integer | ESPN's `offensivePlays` field for the drive containing this play. |
| drive.result | character | ESPN's `result` field for the drive containing this play. |
| drive.description | character | ESPN's `description` field for the drive containing this play. |
| drive.shortDisplayResult | character | ESPN's `shortDisplayResult` field for the drive containing this play. |
| drive.timeElapsed.displayValue | character | ESPN's `timeElapsed.displayValue` field for the drive containing this play. |
| drive.start.period.number | integer | ESPN's `start.period.number` field for the drive containing this play. |
| drive.start.period.type | character | ESPN's `start.period.type` field for the drive containing this play. |
| drive.start.yardLine | integer | ESPN's `start.yardLine` field for the drive containing this play. |
| drive.start.clock.displayValue | character | ESPN's `start.clock.displayValue` field for the drive containing this play. |
| drive.start.text | character | ESPN's `start.text` field for the drive containing this play. |
| drive.end.period.number | integer | ESPN's `end.period.number` field for the drive containing this play. |
| drive.end.period.type | character | ESPN's `end.period.type` field for the drive containing this play. |
| drive.end.yardLine | integer | ESPN's `end.yardLine` field for the drive containing this play. |
| drive.end.clock.displayValue | character | ESPN's `end.clock.displayValue` field for the drive containing this play. |
| seasonType | integer | ESPN season type for the game (2 = regular season, 3 = postseason). |
| week | integer |  |
| status_type_completed | logical |  |
| homeTeamId | integer | ESPN's home-team Id for the game, stamped on every play. |
| awayTeamId | integer | ESPN's away-team Id for the game, stamped on every play. |
| homeTeamName | character | ESPN's home-team Name for the game, stamped on every play. |
| awayTeamName | character | ESPN's away-team Name for the game, stamped on every play. |
| homeTeamMascot | character | ESPN's home-team Mascot for the game, stamped on every play. |
| awayTeamMascot | character | ESPN's away-team Mascot for the game, stamped on every play. |
| homeTeamAbbrev | character | ESPN's home-team Abbrev for the game, stamped on every play. |
| awayTeamAbbrev | character | ESPN's away-team Abbrev for the game, stamped on every play. |
| homeTeamNameAlt | character | ESPN's home-team NameAlt for the game, stamped on every play. |
| awayTeamNameAlt | character | ESPN's away-team NameAlt for the game, stamped on every play. |
| gameSpread | double | Point spread used as an input to the win-probability model. |
| homeFavorite | logical | True when the home team was favoured by the spread. |
| gameSpreadAvailable | logical | True when a spread was available for the game. |
| overUnder | double | Over/under total used as a model input. |
| homeTeamSpread | double | ESPN's home-team Spread for the game, stamped on every play. |
| clock.minutes | integer | Minutes remaining on the game clock at the play. |
| clock.seconds | integer | Seconds component of the game clock at the play. |
| lag_half | integer | Value of half on the previous play, used for sequence-aware derivations. |
| lead_half | integer | Value of half on the next play, used for sequence-aware derivations. |
| start.TimeSecsRem | integer | ESPN's `TimeSecsRem` value for the play state at the start of the play. |
| start.adj_TimeSecsRem | integer | ESPN's `adj_TimeSecsRem` value for the play state at the start of the play. |
| lead_text | character | Value of text on the next play, used for sequence-aware derivations. |
| lead_start_team | character | Value of start_team on the next play, used for sequence-aware derivations. |
| lead_start_yardsToEndzone | integer | Value of start_yardsToEndzone on the next play, used for sequence-aware derivations. |
| lead_start_down | integer | Value of start_down on the next play, used for sequence-aware derivations. |
| lead_start_distance | integer | Value of start_distance on the next play, used for sequence-aware derivations. |
| lead_scoringPlay | logical | Value of scoringPlay on the next play, used for sequence-aware derivations. |
| text_dupe | logical | True when the play description duplicates the previous row's text. |
| end_state_missing | logical |  |
| start.pos_team.id | integer | ESPN's `pos_team.id` value for the play state at the start of the play. |
| start.def_pos_team.id | integer | ESPN's `def_pos_team.id` value for the play state at the start of the play. |
| end.def_pos_team.id | integer | ESPN's `def_pos_team.id` value for the play state at the end of the play. |
| end.pos_team.id | integer | ESPN's `pos_team.id` value for the play state at the end of the play. |
| start.pos_team.name | character | ESPN's `pos_team.name` value for the play state at the start of the play. |
| start.def_pos_team.name | character | ESPN's `def_pos_team.name` value for the play state at the start of the play. |
| end.pos_team.name | character | ESPN's `pos_team.name` value for the play state at the end of the play. |
| end.def_pos_team.name | character | ESPN's `def_pos_team.name` value for the play state at the end of the play. |
| start.is_home | logical | ESPN's `is_home` value for the play state at the start of the play. |
| end.is_home | logical | ESPN's `is_home` value for the play state at the end of the play. |
| homeTimeoutCalled | logical | True when the home team called a timeout on the play. |
| awayTimeoutCalled | logical | True when the away team called a timeout on the play. |
| end.homeTeamTimeouts | integer | ESPN's `homeTeamTimeouts` value for the play state at the end of the play. |
| end.awayTeamTimeouts | integer | ESPN's `awayTeamTimeouts` value for the play state at the end of the play. |
| start.homeTeamTimeouts | integer | ESPN's `homeTeamTimeouts` value for the play state at the start of the play. |
| start.awayTeamTimeouts | integer | ESPN's `awayTeamTimeouts` value for the play state at the start of the play. |
| end.TimeSecsRem | integer | ESPN's `TimeSecsRem` value for the play state at the end of the play. |
| end.adj_TimeSecsRem | integer | ESPN's `adj_TimeSecsRem` value for the play state at the end of the play. |
| start.posTeamTimeouts | integer | ESPN's `posTeamTimeouts` value for the play state at the start of the play. |
| start.defPosTeamTimeouts | integer | ESPN's `defPosTeamTimeouts` value for the play state at the start of the play. |
| end.posTeamTimeouts | integer | ESPN's `posTeamTimeouts` value for the play state at the end of the play. |
| end.defPosTeamTimeouts | integer | ESPN's `defPosTeamTimeouts` value for the play state at the end of the play. |
| firstHalfKickoffTeamId | integer | ESPN id of the team that received the opening kickoff. |
| start.yard | integer | ESPN's `yard` value for the play state at the start of the play. |
| end.yard | integer | ESPN's `yard` value for the play state at the end of the play. |
| lag_scoringPlay | logical | Value of scoringPlay on the previous play, used for sequence-aware derivations. |
| down_1 | logical | True when it is 1st down at the start of the play. |
| down_2 | logical | True when it is 2nd down at the start of the play. |
| down_3 | logical | True when it is 3rd down at the start of the play. |
| down_4 | logical | True when it is 4th down at the start of the play. |
| down_1_end | logical | True when it is 1st down at the end of the play. |
| down_2_end | logical | True when it is 2nd down at the end of the play. |
| down_3_end | logical | True when it is 3rd down at the end of the play. |
| down_4_end | logical | True when it is 4th down at the end of the play. |
| td_check | logical | Internal flag used while reconciling whether the play produced a touchdown. |
| forced_fumble | logical | True when the defense forced a fumble on the play. |
| is_home | logical |  |
| lag_HA_score_diff | integer | Value of HA_score_diff on the previous play, used for sequence-aware derivations. |
| HA_score_diff | integer | Home score minus away score for the play. |
| net_HA_score_pts | integer | Net points the play added to the home-minus-away score margin. |
| H_score_diff | integer | Home team's score minus the away team's, from the home perspective. |
| A_score_diff | integer | Away team's score minus the home team's, from the away perspective. |
| lag_homeScore | integer | Value of homeScore on the previous play, used for sequence-aware derivations. |
| lag_awayScore | integer | Value of awayScore on the previous play, used for sequence-aware derivations. |
| start.homeScore | integer | ESPN's `homeScore` value for the play state at the start of the play. |
| start.awayScore | integer | ESPN's `awayScore` value for the play state at the start of the play. |
| end.homeScore | integer | ESPN's `homeScore` value for the play state at the end of the play. |
| end.awayScore | integer | ESPN's `awayScore` value for the play state at the end of the play. |
| start.pos_team_score | integer | ESPN's `pos_team_score` value for the play state at the start of the play. |
| start.def_pos_team_score | integer | ESPN's `def_pos_team_score` value for the play state at the start of the play. |
| start.pos_score_diff | integer | ESPN's `pos_score_diff` value for the play state at the start of the play. |
| end.pos_team_score | integer | ESPN's `pos_team_score` value for the play state at the end of the play. |
| end.def_pos_team_score | integer | ESPN's `def_pos_team_score` value for the play state at the end of the play. |
| end.pos_score_diff | integer | ESPN's `pos_score_diff` value for the play state at the end of the play. |
| start.pos_team_receives_2H_kickoff | logical | ESPN's `pos_team_receives_2H_kickoff` value for the play state at the start of the play. |
| end.pos_team_receives_2H_kickoff | logical | ESPN's `pos_team_receives_2H_kickoff` value for the play state at the end of the play. |
| penalty_in_text | logical | True when the play description mentions a penalty. |
| pass_breakup | logical | True when a defender broke up the pass. |
| pass_depth | character |  |
| pass_direction | character |  |
| rush_direction | character |  |
| qb_hurry | logical |  |
| fg_attempt | logical | True when the play was a field-goal attempt. |
| pos_unit | character |  |
| def_pos_unit | character |  |
| sp | logical |  |
| play | logical |  |
| cleaned_text | character |  |
| kneel_down | logical |  |
| scrimmage_play | logical | True when the play is a play from scrimmage rather than a special-teams or administrative row. |
| pos_score_diff_end | integer | Score differential from the possessing team's perspective at the end of the play. |
| fumble_lost | logical |  |
| fumble_recovered | logical | True when a fumble on the play was recovered. |
| field_goal_result | character |  |
| extra_point_result | character |  |
| two_point_conv_result | character |  |
| air_yardsToEndzone | integer |  |
| air_yards | integer |  |
| yards_after_catch | integer |  |
| kicking_team | integer |  |
| return_team | integer |  |
| fumble_or_muff | logical |  |
| recovery_team | integer |  |
| recovery_team_2 | integer |  |
| fumbling_team | integer |  |
| int_turnover | logical |  |
| pos_fumble_lost | logical |  |
| def_fumble_lost | logical |  |
| is_pos_team_turnover | logical |  |
| is_def_pos_team_turnover | logical |  |
| is_turnover | logical |  |
| turnover_team | integer |  |
| is_st_turnover | logical |  |
| is_blocked_punt_turnover | logical |  |
| is_blocked_fg_turnover | logical |  |
| sack_team | integer |  |
| interception_team | integer |  |
| pass_breakup_team | integer |  |
| forced_fumble_team | integer |  |
| fumble_recovery_team | integer |  |
| punt_return_team | integer |  |
| kick_return_team | integer |  |
| fg_team | integer |  |
| punt_team | integer |  |
| penalized_team | integer |  |
| penalty_yards_signed | integer |  |
| new_down | integer | Down after the play, including any penalty enforcement. |
| new_distance | integer | Distance to go after the play, including any penalty enforcement. |
| under_2 | logical |  |
| goal_to_go | logical |  |
| stopped_run | logical | True when the rush was stopped at or behind the line of scrimmage. |
| opportunity_run | logical | True when a rush reached 4 yards – the carries on which the blocking did its job. Matches cfbfastR's espn_cfb_15 definition. Assets published before the 2026-08 fix carry the inverted (4 yards or fewer) flag. |
| highlight_run | logical | True when the rush gained 8 or more yards. |
| adj_rush_yardage | integer | Rushing yards capped at 8, the input to the line-yards decomposition. |
| line_yards | double | Yards credited to the offensive line on a rush, using the standard sliding scale: 1.2x the capped yardage on a loss, all of it through 3 yards, half of each yard from 4 to 8, and a 5.5-yard ceiling beyond that. |
| second_level_yards | double | Rushing yards earned from 4 to 8, split evenly between line and carrier under the line-yards decomposition. |
| open_field_yards | integer | Rushing yards gained beyond 8, credited to the ball carrier rather than the line. |
| highlight_yards | double | Second-level plus open-field yards – the yardage credited to the carrier. |
| opp_highlight_yards | double | Highlight yards earned on opportunity runs, isolating carrier production on carries where the blocking succeeded. Assets published before the 2026-08 fix are identically 0 here, because the inverted opportunity_run gate could never co-occur with non-zero highlight yards. |
| short_rush_success | logical | True when a short-yardage rush gained the yardage needed. |
| short_rush_attempt | logical | True when the play is a rush in a short-yardage situation. |
| power_rush_success | logical | True when a power rushing attempt gained the yardage needed. |
| power_rush_attempt | logical | True when the play is a short-yardage power rushing attempt. |
| early_down | logical | True when the play is a scrimmage play on first or second down. |
| late_down | logical | True when the play is a scrimmage play on third or fourth down. |
| early_down_pass | logical | True when the play is a pass on an early down. |
| early_down_rush | logical | True when the play is a rush on an early down. |
| late_down_pass | logical | True when the play is a pass on a late down. |
| late_down_rush | logical | True when the play is a rush on a late down. |
| standard_down | logical | True when the offense is on schedule for the series – first down, second down needing fewer than 8, or third/fourth down needing fewer than 5. |
| passing_down | logical | True when the offense is behind schedule for the series – second down needing 8 or more, or third/fourth down needing 5 or more. |
| TFL | logical | True when the play was a tackle for loss. |
| TFL_pass | logical | True when the play was a tackle for loss on a pass play (a sack). |
| TFL_rush | logical | True when the play was a tackle for loss on a rush play. |
| havoc | logical | True when the defense disrupted the play: a pass breakup, tackle for loss, interception or forced fumble. |
| start.pos_team_spread | double | ESPN's `pos_team_spread` value for the play state at the start of the play. |
| start.elapsed_share | double | ESPN's `elapsed_share` value for the play state at the start of the play. |
| start.spread_time | double | ESPN's `spread_time` value for the play state at the start of the play. |
| end.pos_team_spread | double | ESPN's `pos_team_spread` value for the play state at the end of the play. |
| end.elapsed_share | double | ESPN's `elapsed_share` value for the play state at the end of the play. |
| end.spread_time | double | ESPN's `spread_time` value for the play state at the end of the play. |
| penalty_assessed_on_kickoff | logical |  |
| start.yardsToEndzone.touchback | integer | ESPN's `yardsToEndzone.touchback` value for the play state at the start of the play. |
| EP_start_touchback | double | Expected points the offense would have had from a touchback on this play. |
| EP_start | double | Expected points for the offense at the start of the play. |
| EP_end | double | Expected points for the offense at the end of the play. |
| lag_EP_end | double | Value of EP_end on the previous play, used for sequence-aware derivations. |
| EP_between | double | Change in expected points across the play, before penalty adjustment. |
| EPA_scrimmage | double | EPA credited to the play on plays from scrimmage. |
| EPA_rush | double | EPA credited to the play on rush plays. |
| EPA_pass | double | EPA credited to the play on pass plays. |
| EPA_explosive | logical | True when the play was explosive. |
| EPA_non_explosive | double | EPA credited to the play on non-explosive plays. |
| EPA_explosive_pass | logical | True when the pass play was explosive. |
| EPA_explosive_rush | logical | True when the rush play was explosive. |
| first_down_created | logical | True when the play produced a first down for the offense. |
| EPA_success | logical | True when the play was successful by EPA. |
| EPA_success_early_down | logical | True when the play on an early down was successful by EPA. |
| EPA_success_early_down_pass | logical | True when the pass play on an early down was successful by EPA. |
| EPA_success_early_down_rush | logical | True when the rush play on an early down was successful by EPA. |
| EPA_success_late_down | logical | True when the play on a late down was successful by EPA. |
| EPA_success_late_down_pass | logical | True when the pass play on a late down was successful by EPA. |
| EPA_success_late_down_rush | logical | True when the rush play on a late down was successful by EPA. |
| EPA_success_standard_down | logical | True when the play on a standard down was successful by EPA. |
| EPA_success_passing_down | logical | True when the play on a passing down was successful by EPA. |
| EPA_success_pass | logical | True when the pass play was successful by EPA. |
| EPA_success_rush | logical | True when the rush play was successful by EPA. |
| EPA_success_EPA | double | EPA on successful plays. |
| EPA_success_standard_down_EPA | double | EPA on successful plays on a standard down. |
| EPA_success_passing_down_EPA | double | EPA on successful plays on a passing down. |
| EPA_success_pass_EPA | double | EPA on successful pass plays. |
| EPA_success_rush_EPA | double | EPA on successful rush plays. |
| EPA_middle_8_success | logical | True when the play in the middle eight was successful by EPA. |
| EPA_middle_8_success_pass | logical | True when the pass play in the middle eight was successful by EPA. |
| EPA_middle_8_success_rush | logical | True when the rush play in the middle eight was successful by EPA. |
| EPA_penalty | double | EPA credited to the play attributable to penalties. |
| EPA_sp | double | EPA credited to the play on special-teams plays. |
| EPA_fg | double | EPA credited to the play on field-goal attempts. |
| EPA_punt | double | EPA credited to the play on punt plays. |
| EPA_kickoff | double | EPA credited to the play on kickoff plays. |
| start.ExpScoreDiff_touchback | double | ESPN's `ExpScoreDiff_touchback` value for the play state at the start of the play. |
| start.ExpScoreDiff | double | ESPN's `ExpScoreDiff` value for the play state at the start of the play. |
| start.ExpScoreDiff_Time_Ratio_touchback | double | ESPN's `ExpScoreDiff_Time_Ratio_touchback` value for the play state at the start of the play. |
| start.ExpScoreDiff_Time_Ratio | double | ESPN's `ExpScoreDiff_Time_Ratio` value for the play state at the start of the play. |
| end.ExpScoreDiff | double | ESPN's `ExpScoreDiff` value for the play state at the end of the play. |
| end.ExpScoreDiff_Time_Ratio | double | ESPN's `ExpScoreDiff_Time_Ratio` value for the play state at the end of the play. |
| wp_touchback | double | Win probability the offense would have had starting from a touchback. |
| wp_before_naive | double |  |
| wp_touchback_naive | double |  |
| wp_after_naive | double |  |
| def_wp_before_naive | double |  |
| home_wp_before_naive | double |  |
| away_wp_before_naive | double |  |
| lead_wp_before_naive | double |  |
| lead_wp_before2_naive | double |  |
| def_wp_after_naive | double |  |
| home_wp_after_naive | double |  |
| away_wp_after_naive | double |  |
| wpa_naive | double |  |
| cp | double |  |
| cpoe | double |  |
| era | integer |  |
| xpass | double |  |
| pass_oe | double |  |
| drive_start | double | Yard line at which the drive began. |
| drive_stopped | logical | True when the play ended the drive. |
| drive_play_index | integer | Sequence number of the play within its drive. |
| drive_offense_plays | integer | Offensive plays run on the drive. |
| prog_drive_EPA | double | Cumulative EPA accrued by the drive up to and including this play. |
| prog_drive_WPA | double | Cumulative win-probability added by the drive up to and including this play. |
| drive_offense_yards | integer | Offensive yards gained on the drive. |
| drive_total_yards | integer | Total yards gained on the drive. |
| qbr_epa | double | EPA variant used as an input to the QBR calculation. |
| weight | double |  |
| non_fumble_sack | logical | True when the play was a sack that did not produce a fumble. |
| sack_epa | double | EPA credited to the play when it is a sack. |
| pass_epa | double | EPA credited to the play when it is a pass. |
| rush_epa | double | EPA credited to the play when it is a rush. |
| pen_epa | double | EPA attributable to a penalty on the play. |
| sack_weight | double | Weighting applied to the sack component of the play. |
| pass_weight | double | Weighting applied to the pass component of the play. |
| rush_weight | double | Weighting applied to the rush component of the play. |
| pen_weight | double | Weighting applied to the penalty component of the play. |
| action_play | logical | True when the play advanced the game state – excludes timeouts, end-of-period markers and other non-action rows. |
| athlete_name | character |  |
| rusher_player_id | integer |  |
| passer_player_id | integer |  |
| receiver_player_id | integer |  |
| fumble_player_id | integer |  |
| sack_player_id | integer |  |
| sack_player_id2 | integer |  |
| interception_player_id | integer |  |
| pass_breakup_player_id | integer |  |
| fumble_forced_player_id | integer |  |
| fumble_recovered_player_id | integer |  |
| fg_kicker_player_id | integer |  |
| punter_player_id | integer |  |
| kickoff_player_id | integer |  |
| kickoff_return_player_id | integer |  |
| punt_return_player_id | integer |  |
| fg_block_player_id | integer |  |
| punt_block_player_id | integer |  |
| fg_return_player_id | integer |  |
| punt_block_return_player_id | character |  |
| go_wp | double |  |
| first_down_prob | double |  |
| wp_succeed | double |  |
| wp_fail | double |  |
| fourth_down_fg_make_prob | double |  |
| make_fg_wp | double |  |
| miss_fg_wp | double |  |
| fg_wp | double |  |
| punt_wp | double |  |
| go_boost | double |  |
| go_wp_diff | double |  |
| fg_wp_diff | double |  |
| punt_wp_diff | double |  |
| fourth_down_recommendation | character |  |
| two_pt_wp | double |  |
| xp_wp | double |  |
| prob_2pt | double |  |
| two_pt_recommendation | character |  |
| two_pt_wp_diff | double |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_pbp(2004))
#> ── ESPN college football play-by-play from the SportsDataverse data repo ───────
#> ℹ Data updated: 2026-08-29 13:17:26 UTC
#> # A tibble: 83,210 × 469
#>    season   game_id game_play_number pos_team_id pos_team        def_pos_team_id
#>     <int>     <int>            <int>       <int> <chr>                     <int>
#>  1   2004 242410259                1         259 Virginia Tech …              30
#>  2   2004 242410259                2         259 Virginia Tech …              30
#>  3   2004 242410259                3         259 Virginia Tech …              30
#>  4   2004 242410259                4         259 Virginia Tech …              30
#>  5   2004 242410259                5         259 Virginia Tech …              30
#>  6   2004 242410259                6         259 Virginia Tech …              30
#>  7   2004 242410259                7         259 Virginia Tech …              30
#>  8   2004 242410259                8         259 Virginia Tech …              30
#>  9   2004 242410259                9         259 Virginia Tech …              30
#> 10   2004 242410259               10          30 USC Trojans                 259
#> # ℹ 83,200 more rows
#> # ℹ 463 more variables: def_pos_team <chr>, pos_team_score <int>,
#> #   def_pos_team_score <int>, half <int>, period <int>, down <int>,
#> #   distance <int>, EPA <dbl>, wpa <dbl>, wp_before <dbl>, wp_after <dbl>,
#> #   def_wp_before <dbl>, def_wp_after <dbl>, penalty_detail <chr>,
#> #   yds_penalty <chr>, penalty_1st_conv <lgl>, def_EPA <dbl>, rz_play <lgl>,
#> #   scoring_opp <lgl>, middle_8 <lgl>, stuffed_run <lgl>, …
# }
```
