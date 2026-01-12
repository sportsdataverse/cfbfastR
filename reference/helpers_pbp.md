# **Series of functions to help clean the play-by-play data for analysis**

- `add_play_counts()`: function:

  Adds play counts to Play-by-Play data pulled from the API's raw game
  data.

- `add_yardage()`: function:

  Add yardage extracted from play text.

- `add_player_cols()`: function:

  Add player columns extracted from play text.

- `clean_drive_dat()`: function:

  Create new Drive results and id data.

- `clean_pbp_dat()`: function:

  Clean Play-by-Play data.

- `penalty_detection()`: function:

  Adds penalty columns to Play-by-Play data pulled from the API.

- `prep_epa_df_after()`: function:

  Creates the post-play inputs for the Expected Points model to predict
  on for each game.

- `clean_drive_info()`: function:

  Cleans CFB (D-I) Drive-By-Drive Data to create `pts_drive` column.

Cleans Play-by-Play data pulled from the API's raw game data

## Usage

``` r
add_play_counts(play_df)

clean_drive_dat(play_df)

prep_epa_df_after(dat)

clean_drive_info(drive_df)

clean_play_text(play_df)

add_player_cols(pbp)

add_yardage(play_df)

clean_pbp_dat(play_df)

penalty_detection(raw_df)
```

## Arguments

- play_df:

  (*data.frame* required): Performs data cleansing on Play-by-Play
  DataFrame, as pulled from
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)

- dat:

  (*Data.Frame* required) Clean Play-by-Play DataFrame pulled from
  `cfbd_pbp_dat()`

- drive_df:

  (*data.frame* required) Drive dataframe pulled from API via the
  [`cfbd_drives()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_drives.md)
  function

- raw_df:

  (*data.frame* required): Performs data cleansing on Play-by-Play
  DataFrame, as pulled from
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)

## Value

The original `play_df` with the following columns appended/redefined:

- `game_play_number`.:

  .

- `half_clock_minutes`.:

  .

- `TimeSecsRem`.:

  .

- `Under_two`.:

  .

- `half`.:

  .

- `kickoff_play`.:

  .

- `pos_team`.:

  .

- `def_pos_team`.:

  .

- `receives_2H_kickoff`.:

  .

- `pos_score_diff`.:

  .

- `lag_pos_score_diff`.:

  .

- `lag_pos_team`.:

  .

- `lead_pos_team`.:

  .

- `lead_pos_team2`.:

  .

- `pos_score_pts`.:

  .

- `pos_score_diff_start`.:

  .

- `score_diff`.:

  .

- `lag_score_diff`.:

  .

- `lag_offense_play`.:

  .

- `lead_offense_play`.:

  .

- `lead_offense_play2`.:

  .

- `score_pts`.:

  .

- `score_diff_start`.:

  .

- `offense_receives_2H_kickoff`.:

  .

- `half_play_number`.:

  .

- `lag_off_timeouts`.:

  .

- `lag_def_timeouts`.:

  .

- `off_timeouts_rem_before`.:

  .

- `def_timeouts_rem_before`.:

  .

- `off_timeout_called`.:

  .

- `def_timeout_called`.:

  .

- `lead_TimeSecsRem`.:

  .

- `lead_TimeSecsRem2`.:

  .

- `lead_yards_to_goal`.:

  .

- `lead_yards_to_goal2`.:

  .

- `lead_down`.:

  .

- `lead_down2`.:

  .

- `lag_distance3`.:

  .

- `lag_distance2`.:

  .

- `lag_distance`.:

  .

- `lead_distance`.:

  .

- `lead_distance2`.:

  .

- `end_of_half`.:

  .

- `lag_play_type3`.:

  .

- `lag_play_type2`.:

  .

- `lag_play_type`.:

  .

- `lead_play_type`.:

  .

- `lead_play_type2`.:

  .

- `lead_play_type3`.:

  .

- `change_of_poss`.:

  .

- `change_of_pos_team`.:

  .

- `pos_team_timeouts`.:

  .

- `def_pos_team_timeouts`.:

  .

- `pos_team_timeouts_rem_before`.:

  .

- `def_pos_team_timeouts_rem_before`.:

  .

The original `play_df` with the following columns appended/redefined:

- `lag_change_of_poss`.:

  .

- `lag_punt`.:

  .

- `lag_scoring_play`.:

  .

- `lag_turnover_vec`.:

  .

- `lag_downs_turnover`.:

  .

- `lead_play_type`.:

  .

- `lead_play_type2`.:

  .

- `lead_play_type3`.:

  .

- `drive_numbers`.:

  .

- `number_of_drives`.:

  .

- `pts_scored`.:

  .

- `drive_result_detailed`.:

  .

- `drive_result_detailed_flag`.:

  .

- `drive_result2`.:

  .

- `lag_new_drive_pts`.:

  .

- `lag_drive_result_detailed`.:

  .

- `lead_drive_result_detailed`.:

  .

- `new_drive_pts`.:

  .

- `drive_scoring`.:

  .

- `drive_play`.:

  .

- `drive_play_number`.:

  .

- `drive_event`.:

  .

- `drive_event_number`.:

  .

- `new_id`.:

  .

- `log_ydstogo`.:

  .

- `down`.:

  .

- `distance`.:

  .

- `yards_to_goal`.:

  .

- `yards_gained`.:

  .

- `Goal_To_Go`.:

  .

`dat` with the following columns appended/modified:

- `turnover_indicator`.:

  .

- `down`.:

  .

- `new_id`.:

  .

- `new_down`.:

  .

- `distance`.:

  .

- `yards_to_goal`.:

  .

- `yards_gained`.:

  .

- `turnover`.:

  .

- `drive_start_yards_to_goal`.:

  .

- `end_of_half`.:

  .

- `new_yardline`.:

  .

- `new_distance`.:

  .

- `new_log_ydstogo`.:

  .

- `new_Goal_To_Go`.:

  .

- `new_TimeSecsRem`.:

  .

- `new_Under_two`.:

  .

- `first_by_penalty`.:

  .

- `lag_first_by_penalty`.:

  .

- `lag_first_by_penalty2`.:

  .

- `first_by_yards`.:

  .

- `lag_first_by_yards`.:

  .

- `lag_first_by_yards2`.:

  .

- `row`.:

  .

- `new_series`.:

  .

- `firstD_by_kickoff`.:

  .

- `firstD_by_poss`.:

  .

- `firstD_by_yards`.:

  .

- `firstD_by_penalty`.:

  .

- `yds_punted`.:

  .

- `yds_punt_gained`.:

  .

- `missing_yard_flag`.:

  .

The original `drive_df` with the following columns appended to it:

- `drive_id`: Returned as `drive_id` from original variable `drive_id`:

  .

- `pts_drive`: End result of the drive:

  .

- `scoring`: Logical flag for if drive was a scoring drive updated:

  .

The original `play_df` with the following columns appended to it:

- `cleaned_text`: `play_text` with miscellanous items removed: pass
  depth/location, clock timestamps, No Huddle/Shotgun status, etc.:

  .

The original `pbp` with the following columns appended to it:

- `rusher_player_name`:

  .

- `receiver_player_name`:

  .

- `passer_player_name`:

  .

- `sack_player_name`:

  .

- `sack_player_name2`:

  .

- `pass_breakup_player_name`:

  .

- `interception_player_name`:

  .

- `fg_kicker_player_name`:

  .

- `fg_block_player_name`:

  .

- `fg_return_player_name`:

  .

- `kickoff_player_name`:

  .

- `kickoff_returner_player_name`:

  .

- `punter_player_name`:

  .

- `punt_block_player_name`:

  .

- `punt_returner_player_name`:

  .

- `punt_block_return_player_name`:

  .

- `fumble_player_name`:

  .

- `fumble_forced_player_name`:

  .

- `fumble_recovered_player_name`:

  .

The original `play_df` with the following columns appended to it:

- `yds_rushed`:

  .

- `yds_receiving`:

  .

- `yds_int_return`:

  .

- `yds_kickoff`:

  .

- `yds_kickoff_return`:

  .

- `yds_punted`:

  .

- `yds_fumble_return`:

  .

- `yds_sacked`:

  .

- `yds_penalty`:

  .

The original `play_df` with the following columns appended/redefined:

- scoring_play:

  .

- td_play:

  .

- touchdown:

  .

- safety:

  .

- fumble_vec:

  .

- kickoff_play:

  .

- kickoff_tb:

  .

- kickoff_onside:

  .

- kickoff_oob:

  .

- kickoff_fair_catch:

  .

- kickoff_downed:

  .

- kick_play:

  .

- kickoff_safety:

  .

- punt:

  .

- punt_play:

  .

- punt_tb:

  .

- punt_oob:

  .

- punt_fair_catch:

  .

- punt_downed:

  .

- rush:

  .

- pass:

  .

- sack_vec:

  .

- play_type:

  .

- td_check:

  .

- id_play:

  .

- sack:

  .

- int:

  .

- int_td:

  .

- completion:

  .

- pass_attempt:

  .

- target:

  .

- pass_td:

  .

- rush_td:

  .

- turnover_vec:

  .

- offense_score_play:

  .

- defense_score_play:

  .

- downs_turnover:

  .

- scoring_play:

  .

- fg_inds:

  .

- yds_fg:

  .

- yards_to_goal:

  .

- lag_play_type3:

  .

- lag_play_type2:

  .

- lag_play_type:

  .

- lead_play_type:

  .

- lead_play_type2:

  .

- lead_play_type3:

  .

The original `raw_df` with the following columns appended/redefined:

- `penalty_flag`: TRUE/FALSE flag for penalty play types or penalty in
  play text plays.:

  .

- `penalty_declined`: TRUE/FALSE flag for 'declined' in penalty play
  types or penalty in play text plays.:

  .

- `penalty_no_play`: TRUE/FALSE flag for 'no play' in penalty play types
  or penalty in play text plays.:

  .

- `penalty_offset`: TRUE/FALSE flag for 'off-setting' in penalty play
  types or penalty in play text plays.:

  .

- `penalty_1st_conv`: TRUE/FALSE flag for 1st Down in penalty play types
  or penalty in play text plays.:

  .

- `penalty_text`: TRUE/FALSE flag for penalty in text but not a penalty
  play type.:

  .

- `orig_play_type`: Copy of original play_type label prior to any
  changes by the proceeding functions:

  .

- `down`: Defines kickoff downs and penalties on kickoffs and converts
  them from 5 (as from the API) to 1.:

  .

- `play_type`: Defines `play_type`, "Penalty (Kickoff)", penalties on
  kickoffs with a repeat kick.:

  .

- `half`: Defines the half variable (1, 2).:

  .

## Details

Requires the following columns to be present

- `game_id`:

  .

- `id_play`:

  .

- `clock_minutes`:

  .

- `clock_seconds`:

  .

- `half`:

  .

- `period`:

  .

- `offense_play`:

  .

- `defense_play`:

  .

- `home`:

  .

- `away`:

  .

- `offense_score`:

  .

- `defense_score`:

  .

- `offense_timeouts`:

  .

- `defense_timeouts`:

  .

- `play_text`:

  .

- `play_type`:

  .

Prep for EPA calculations at the end of the play. Requires the following
columns be present:

- `game_id`.:

  .

- `id_play`.:

  .

- `drive_id`.:

  .

- `down`.:

  .

- `distance`.:

  .

- `period`.:

  .

- `yards_to_goal`.:

  .

- `play_type`.:

  .

Cleans CFB (D-I) Drive-By-Drive Data to create `pts_drive` column.
Requires the following columns be present:

- `drive_id`: Returned as `drive_id`:

  .

- `drive_result`: End result of the drive:

  .

- `scoring`: Logical flag for if drive was a scoring drive:

  .

- `game_id`: Unique game identifier:

  .

Cleans CFB play-by-play text to be compliant with existing play-by-play
parsing. Generally not recommended for standalone use. This method
exists due to ESPN PBP changes midway through the 2025 season.

- `play_text`: Returned as `play_text`:

  .

Cleans CFB (D-I) player Data to create player name columns. Requires the
following columns be present:

- `rush`:

  .

- `pass`:

  .

- `play_text`:

  .

- `play_type`:

  .

- `sack`:

  .

- `fumble_vec`:

  .

Cleans CFB (D-I) Drive-By-Drive Data to create yardage column. Requires
the following columns be present:

- `play_text`:

  .

- `play_type`:

  .

- `rush`:

  .

- `pass`:

  .

- `int`:

  .

- `int_td`:

  .

- `kickoff_play`:

  .

- `kickoff_tb`:

  .

- `kickoff_downed`:

  .

- `kickoff_fair_catch`:

  .

- `fumble_vec`:

  .

- `sack`:

  .

- `punt`:

  .

- `punt_tb`:

  .

- `punt_downed`:

  .

- `punt_fair_catch`:

  .

- `punt_oob`:

  .

- `punt_blocked`:

  .

- `penalty_detail`:

  .

Requires the following columns to be present

- game_id:

  .

- id_play:

  .

- offense_play:

  .

- defense_play:

  .

- home:

  .

- away:

  .

- play_type:

  .

- play_text:

  .

- kickoff_play:

  .

- down:

  .

- distance:

  .

- yards_gained:

  .

- yards_to_goal:

  .

- change_of_poss:

  .

- penalty_1st_conv:

  .

- off_timeouts_rem_before:

  .

- def_timeouts_rem_before:

  .

Runs penalty detection on the play text and play types. Requires the
following columns be present:

- `game_id`:

  Referencing game id.

- `period`:

  Game period (quarter).

- `down`:

  Down of the play.

- `play_type`:

  Categorical play type.

- `play_text`:

  A description of the play.
