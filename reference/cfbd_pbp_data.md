# **Get college football play by play data with cfbfastR expected points/win probability added**

Extract college football (D-I) play by play Data - for plays

## Usage

``` r
cfbd_pbp_data(
  year,
  season_type = "regular",
  week = 1,
  team = NULL,
  play_type = NULL,
  epa_wpa = FALSE,
  engine = NULL,
  ...,
  defense = NULL,
  offense_conference = NULL,
  defense_conference = NULL,
  conference = NULL,
  division = NULL,
  offense = NULL
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

- play_type:

  Select play type (example: see the
  [cfbd_play_type_df](https://cfbfastR.sportsdataverse.org/reference/data.md))

- epa_wpa:

  Logical parameter (TRUE/FALSE) to return the Expected Points Added/Win
  Probability Added variables

- engine:

  (*Character* optional): which play-by-play engine to run. One of
  `"v2"`, `"legacy"` or `"auto"`; `NULL` (default) resolves from
  `getOption("cfbfastR.pbp_engine")`, which itself defaults to `"v2"` as
  of this release. On `"v2"` this delegates to
  [`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md),
  which adds penalty enforcement resolution, ESPN-resolved player names,
  the `*_player_id` columns and team attribution. `"legacy"` reproduces
  the pre-2.3.0 frame unchanged.

- ...:

  Additional arguments passed to
  [`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md)
  when the call delegates – notably `output`, the `"default"` / `"lean"`
  / `"full"` modeled column-set selector. Ignored on the legacy path.

- defense:

  (*String* optional): Defensive team filter.

- offense_conference:

  (*String* optional): Offensive team conference filter.

- defense_conference:

  (*String* optional): Defensive team conference filter.

- conference:

  (*String* optional): Conference filter (either side of the ball).

- division:

  (*String* optional): Division/classification filter – `fbs`, `fcs`,
  `ii`, `ii/iii`, `iii`.

- offense:

  (*String* optional): Offensive team filter.

## Value

A `cfbfastR_data` data frame of plays, or `NULL` when CFBD returns no
plays. With `epa_wpa = TRUE` and the default `output = "default"` it has
the 368 columns in the first table (364 when the four betting columns
`provider`, `spread`, `formatted_spread` and `over_under` are not
joined: before 2013, or if the betting-lines request fails); games with
fewer than 20 plays are skipped. `output = "lean"` drops the 12 WPA
scratchpad columns `lead_wp_before2` through `lead_pos_team2`;
`output = "full"` also keeps the 91 pipeline columns in the second
table, interleaved with the first. With `epa_wpa = FALSE` (the argument
default) no modeling runs and only 60 columns of the first table are
returned: these 54 in CFBD order (`yards_to_goal`, `down`, `distance`,
`yards_gained` and `drive_start_yards_to_goal` stay integer and
`drive_scoring` is logical): `game_id`, `drive_id`, `id_play`,
`drive_number`, `play_number`, `offense_play`, `offense_conference`,
`offense_score`, `defense_play`, `defense_conference`, `defense_score`,
`home`, `away`, `period`, `clock_minutes`, `clock_seconds`,
`offense_timeouts`, `defense_timeouts`, `yard_line`, `yards_to_goal`,
`down`, `distance`, `yards_gained`, `scoring`, `play_type`, `play_text`,
`ppa`, `wallclock`, `provider`, `spread`, `formatted_spread`,
`over_under`, `orig_drive_number`, `drive_scoring`,
`drive_start_period`, `drive_start_yards_to_goal`, `drive_end_period`,
`drive_end_yards_to_goal`, `drive_yards`, `drive_result`,
`drive_is_home_offense`, `drive_start_offense_score`,
`drive_start_defense_score`, `drive_end_offense_score`,
`drive_end_defense_score`, `drive_time_minutes_start`,
`drive_time_seconds_start`, `drive_time_minutes_end`,
`drive_time_seconds_end`, `drive_time_minutes_elapsed`,
`drive_time_seconds_elapsed`, `drive_pts`, `season`, `wk`, then the six
team-identity columns `home_team_id`, `away_team_id`,
`home_team_abbreviation`, `away_team_abbreviation`, `offense_play_id`
and `defense_play_id`. As on the modeled path, `provider`, `spread`,
`formatted_spread` and `over_under` are absent when betting lines are
not joined. `engine = "legacy"` returns the older pre-v2 frame, which
these tables do not describe. Team and player ids come from CFBD
`/games`, `/teams` and the season `/roster`. The `/teams` and `/roster`
lookups are cached per season until the next UTC midnight (the
`cfbfastR.cache_duration` window), so a season sweep requests each once;
[`espn_cfb_clear_cache()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_clear_cache.md)
refetches them, and `options(cfbfastR.cache = "off")` set before loading
the package disables it.

**Default columns** - one row per play (`epa_wpa = TRUE`,
`output = "default"`):

|  |  |  |
|----|----|----|
| col_name | type | description |
| season | double | Four-digit season year (e.g. 2024). |
| wk | double | Season week number (1-15 regular season, 1 for bowl/postseason week). |
| id_play | character | Unique CFBD play identifier (concatenates game_id and play index). |
| game_id | integer | CFBD-internal game identifier. |
| game_play_number | double | Sequential play number within the game (excludes timeouts/end markers). |
| half_play_number | double | Sequential play number within the current half. |
| drive_play_number | double | Sequential play number within the current drive. |
| pos_team | character | Team name in possession at the start of the play (offense, kickoff-aware). |
| def_pos_team | character | Team name on defense at the start of the play. |
| pos_team_score | integer | Score for the team in possession after the play (includes points scored on it). |
| def_pos_team_score | integer | Score for the defensive team after the play. |
| half | factor | Half indicator (1 or 2). |
| period | integer | Quarter number (1-4, 5+ for overtime). |
| clock_minutes | integer | Minutes remaining on the period clock at the start of the play. |
| clock_seconds | integer | Seconds remaining on the period clock at the start of the play. |
| play_type | character | CFBD play type label (e.g. "Rush", "Pass Reception", "Field Goal Good"). |
| play_text | character | Free-text description of the play from CFBD. |
| down | double | Down number at the start of the play (1-4). |
| distance | double | Yards to gain for a first down at the start of the play; on goal-to-go downs the yards to the goal line (a 0 the feed sends on a down ESPN labels Goal, or that CFBD sends at the 10 or closer, is replaced). |
| yards_to_goal | double | Yards from the offense to the opponent's end zone at the start of the play. |
| yards_gained | double | Yards gained (or lost) by the offense on the play. |
| EPA | double | Expected Points Added on the play (cfbfastR EPA model output). |
| ep_before | double | Expected points value before the play (cfbfastR EPA model). |
| ep_after | double | Expected points value after the play (cfbfastR EPA model). |
| wpa | double | Win Probability Added on the play (cfbfastR WP model output). |
| wp_before | double | Win probability for the possession team before the play (0-1). |
| wp_after | double | Win probability for the possession team after the play (0-1). |
| def_wp_before | double | Win probability for the defensive team before the play (0-1). |
| def_wp_after | double | Win probability for the defensive team after the play (0-1). |
| penalty_detail | character | Parsed penalty description extracted from play text. |
| yds_penalty | double | Yardage assessed on the penalty. |
| penalty_1st_conv | logical | TRUE when the penalty resulted in a first down conversion. |
| penalty_count | integer | Number of penalties on the play (count of "penalty" in the play text); 0 when none. |
| penalty_declined_count | integer | Number of declined penalties on the play (count of "declined" in the play text). |
| penalty_all_declined | logical | TRUE only when the play has at least one penalty and every one was declined, so the play stood. |
| penalty_enforcement | character | How the penalty was enforced: `no_play`, `declined`, `offsetting`, `negating_foul`, `play_stands` or `unknown`; NA on plays without a penalty. |
| penalty_negated_play | logical | TRUE when a penalty wiped out the play (`no_play`, `offsetting`, `negating_foul`), FALSE when the play stood or had no penalty; NA when enforcement is `unknown`. |
| rusher_player_id | character | ESPN athlete id of `rusher_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| passer_player_id | character | ESPN athlete id of `passer_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| receiver_player_id | character | ESPN athlete id of `receiver_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| fumble_player_id | character | ESPN athlete id of `fumble_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| sack_player_id | character | ESPN athlete id of `sack_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| sack_player_id2 | character | ESPN athlete id of `sack_player_name2`. NA when the name does not match a player on either team's CFBD season roster. |
| interception_player_id | character | ESPN athlete id of `interception_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| pass_breakup_player_id | character | ESPN athlete id of `pass_breakup_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| fumble_forced_player_id | character | ESPN athlete id of `fumble_forced_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| fumble_recovered_player_id | character | ESPN athlete id of `fumble_recovered_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| fg_kicker_player_id | character | ESPN athlete id of `fg_kicker_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| punter_player_id | character | ESPN athlete id of `punter_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| kickoff_player_id | character | ESPN athlete id of `kickoff_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| kickoff_return_player_id | character | ESPN athlete id of `kickoff_return_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| punt_return_player_id | character | ESPN athlete id of `punt_return_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| fg_block_player_id | character | ESPN athlete id of `fg_block_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| punt_block_player_id | character | ESPN athlete id of `punt_block_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| fg_return_player_id | character | ESPN athlete id of `fg_return_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| punt_block_return_player_id | character | ESPN athlete id of `punt_block_return_player_name`. NA when the name does not match a player on either team's CFBD season roster. |
| pos_team_id | character | ESPN team id of `pos_team`. |
| def_pos_team_id | character | ESPN team id of `def_pos_team`. |
| kicking_team | character | Team id of the kicking team on kickoffs, punts and field goals; NA on other plays. |
| return_team | character | Team id of the receiving team on kickoffs, punts and field goals; NA on other plays. |
| punt_return_team | character | Team id of the punt-returning team (copy of `return_team`). |
| kick_return_team | character | Team id of the kick-returning team (copy of `return_team`). |
| fg_team | character | Team id of the field-goal kicking team (copy of `kicking_team`). |
| punt_team | character | Team id of the punting team (copy of `kicking_team`). |
| sack_team | character | Team id credited with a sack (the defense, `def_pos_team_id`). |
| interception_team | character | Team id credited with an interception (the defense, `def_pos_team_id`). |
| pass_breakup_team | character | Team id credited with a pass breakup (the defense, `def_pos_team_id`). |
| forced_fumble_team | character | Team id credited with a forced fumble (the defense, `def_pos_team_id`). |
| fumble_recovery_team | character | Team id that recovered a fumble or muff: the first `recovered by` team in the text, else inferred from the turnover. |
| fumble_or_muff | logical | TRUE when the play has a fumble (`fumble_vec`) or the play text mentions a muff. |
| fumbling_team | character | Team id that fumbled or muffed; NA when `fumble_or_muff` is FALSE. |
| recovery_team | character | Team id from the first `recovered by` clause in the play text. |
| recovery_team_2 | character | Team id from a second `recovered by` clause (the ball changed hands twice). |
| int_turnover | logical | TRUE when the play is an interception (from `int`). |
| pos_fumble_lost | logical | TRUE when the team in possession lost a fumble. |
| def_fumble_lost | logical | TRUE when the defense recovered and then lost a fumble on the same play. |
| is_pos_team_turnover | logical | TRUE when the team in possession gave the ball away (`int_turnover` or `pos_fumble_lost`). |
| is_def_pos_team_turnover | logical | TRUE when the defense gave the ball back on the same play (`def_fumble_lost`). |
| is_turnover | logical | TRUE when either side gave the ball away (interceptions and lost fumbles; blocked kicks excluded). |
| turnover_team | character | Team id that gave the ball away; NA when `is_turnover` is FALSE. |
| is_st_turnover | logical | TRUE when a lost fumble happened on a special-teams play. |
| is_blocked_punt_turnover | logical | TRUE on a blocked punt returned for a touchdown or that changed possession; not counted in `is_turnover`. |
| is_blocked_fg_turnover | logical | TRUE on a blocked field goal returned for a touchdown or that changed possession; not counted in `is_turnover`. |
| penalized_team | character | Team id charged with the penalty; NA on plays without a penalty. |
| penalty_team_id | character | Copy of `penalized_team`. |
| penalty_yards_signed | integer | Penalty yardage parsed from `yds_penalty` as an integer, 0 when none. The magnitude is reliable; the sign is not a dependable direction. |
| air_yardsToEndzone | integer | Catch point in yards from the end zone, parsed from `caught at` or `thrown to` in the play text. NA when the play text names no catch spot, which is most plays. |
| air_yards | integer | Air yards: `yards_to_goal` minus `air_yardsToEndzone`; NA whenever `air_yardsToEndzone` is NA. |
| yards_after_catch | integer | Yards after the catch on completions: `yards_gained` minus `air_yards`; NA on other plays or when `air_yards` is NA. |
| pass_depth | character | Pass depth stated in the text of a pass play (`short` or `deep`); NA when not stated or not a pass. |
| pass_direction | character | Pass direction stated in the text of a pass play (`left`, `middle` or `right`); NA when not stated or not a pass. |
| rush_direction | character | Run direction stated in the text of a rushing play (`left`, `middle` or `right`); NA when not stated or not a rush. |
| qb_hurry | logical | TRUE when the play text says the passer was hurried ("hurried by"). |
| new_series | double | Binary flag for the start of a new series of downs. |
| firstD_by_kickoff | double | Binary flag for a new first down arising from a kickoff. |
| firstD_by_poss | double | Binary flag for a new first down via change of possession. |
| firstD_by_penalty | double | Binary flag for a new first down via penalty. |
| firstD_by_yards | double | Binary flag for a new first down via yards gained. |
| def_EPA | double | EPA for the defensive team on the play (sign-flipped offense EPA). |
| home_EPA | double | EPA for the home team on the play. |
| away_EPA | double | EPA for the away team on the play. |
| home_EPA_rush | double | Rushing EPA for the home team on the play. |
| away_EPA_rush | double | Rushing EPA for the away team on the play. |
| home_EPA_pass | double | Passing EPA for the home team on the play. |
| away_EPA_pass | double | Passing EPA for the away team on the play. |
| total_home_EPA | double | Cumulative total EPA for the home team through the play. |
| total_away_EPA | double | Cumulative total EPA for the away team through the play. |
| total_home_EPA_rush | double | Cumulative rushing EPA for the home team through the play. |
| total_away_EPA_rush | double | Cumulative rushing EPA for the away team through the play. |
| total_home_EPA_pass | double | Cumulative passing EPA for the home team through the play. |
| total_away_EPA_pass | double | Cumulative passing EPA for the away team through the play. |
| net_home_EPA | double | Net EPA differential (home minus away) through the play. |
| net_away_EPA | double | Net EPA differential (away minus home) through the play. |
| net_home_EPA_rush | double | Net rushing EPA differential for the home team through the play. |
| net_away_EPA_rush | double | Net rushing EPA differential for the away team through the play. |
| net_home_EPA_pass | double | Net passing EPA differential for the home team through the play. |
| net_away_EPA_pass | double | Net passing EPA differential for the away team through the play. |
| success | double | Binary success-rate flag using the 50/70/100 percent down-state thresholds. |
| epa_success | double | Binary flag for plays with positive EPA (EPA \> 0). |
| rz_play | double | Binary flag for a red-zone play (yards_to_goal \<= 20). |
| scoring_opp | double | Binary flag for a scoring opportunity (yards_to_goal \<= 40). |
| middle_8 | logical | TRUE for plays in the middle-8 window (final 4 min of 1H, first 4 min of 2H). |
| stuffed_run | double | Binary flag for a stuffed run (zero or negative yards gained). |
| change_of_pos_team | double | Binary flag for change of possession-team on the play. |
| downs_turnover | double | Binary flag for a turnover on downs. |
| turnover | double | Binary flag for any turnover on the play. |
| pos_score_diff_start | double | Score differential for the possession team at the start of the play. |
| pos_score_pts | double | Points scored on the play attributed to the possession team. |
| log_ydstogo | double | Natural log of distance-to-go (model feature). |
| ExpScoreDiff | double | Expected score differential at the start of the play (EPA-adjusted). |
| ExpScoreDiff_Time_Ratio | double | `ExpScoreDiff` divided by (`adj_TimeSecsRem` + 1) (WP model input). |
| half_clock_minutes | double | Minutes remaining in the half (15 + clock_minutes when in Q1/Q3). |
| TimeSecsRem | double | Seconds remaining in the half at the start of the play. |
| adj_TimeSecsRem | double | Seconds remaining in regulation: `TimeSecsRem` plus 1800 in the first half (WP model input). |
| Goal_To_Go | logical | TRUE when the offense is in a goal-to-go situation. |
| Under_two | logical | TRUE when under two minutes remain in the half. |
| home | character | Home team name. |
| away | character | Away team name. |
| home_wp_before | double | Home team win probability before the play (0-1). |
| away_wp_before | double | Away team win probability before the play (0-1). |
| home_wp_after | double | Home team win probability after the play (0-1). |
| away_wp_after | double | Away team win probability after the play (0-1). |
| end_of_half | double | Binary flag for the last play of a half. |
| pos_team_receives_2H_kickoff | double | Binary flag indicating possession team receives the second-half kickoff. |
| orig_play_type | character | Original CFBD play type label before cfbfastR cleaning. |
| Under_three | logical | TRUE when under three minutes remain in the half. |
| down_end | factor | Down number at the end of the play (post-play state). |
| distance_end | double | Distance-to-go at the end of the play (post-play state). |
| log_ydstogo_end | double | Natural log of post-play distance-to-go (model feature). |
| yards_to_goal_end | double | Yards to opponent end zone at the end of the play. |
| TimeSecsRem_end | double | Seconds remaining in the half at the end of the play. |
| Goal_To_Go_end | logical | TRUE when the post-play state is goal-to-go. |
| Under_two_end | logical | TRUE when the post-play state is under two minutes. |
| offense_score_play | double | Binary flag for an offensive scoring play. |
| defense_score_play | double | Binary flag for a defensive scoring play. |
| ppa | double | CFBD's own Predicted Points Added for the play (the `ppa` field of the CFBD plays payload). |
| yard_line | integer | Yard line where the play started (raw CFBD yardline field). |
| scoring | logical | TRUE when the play resulted in a score (CFBD scoring flag). |
| pos_team_timeouts_rem_before | double | Possession team timeouts remaining before the play. |
| def_pos_team_timeouts_rem_before | double | Defensive team timeouts remaining before the play. |
| pos_team_timeouts | integer | Possession team timeouts remaining after the play. |
| def_pos_team_timeouts | integer | Defensive team timeouts remaining after the play. |
| pos_score_diff | integer | Score differential from the possession team's perspective after the play; `pos_score_diff_start` is the pre-play value. |
| pos_score_diff_start_end | double | Score differential for the post-play EP state: `pos_score_diff`, negated when possession changed on the play. |
| offense_play | character | Offensive team name as labeled by CFBD on the play. |
| defense_play | character | Defensive team name as labeled by CFBD on the play. |
| offense_receives_2H_kickoff | double | Binary flag indicating offense receives the second-half kickoff. |
| change_of_poss | double | Binary flag for change of possession on the play (CFBD offense field). |
| score_pts | double | Points scored on the play. |
| score_diff_start | double | Score differential at the start of the play. |
| score_diff | integer | Score differential (offense_score - defense_score) after the play; `score_diff_start` is the pre-play value. |
| offense_score | integer | Offense team score after the play (includes points scored on it). |
| defense_score | integer | Defense team score after the play. |
| offense_conference | character | Conference name of the offensive team. |
| defense_conference | character | Conference name of the defensive team. |
| off_timeout_called | double | Binary flag for an offensive timeout called during the play. |
| def_timeout_called | double | Binary flag for a defensive timeout called during the play. |
| offense_timeouts | integer | Offense timeouts remaining after the play (CFBD field). |
| defense_timeouts | integer | Defense timeouts remaining after the play (CFBD field). |
| off_timeouts_rem_before | double | Offense timeouts remaining before the play. |
| def_timeouts_rem_before | double | Defense timeouts remaining before the play. |
| rusher_player_name | character | Name of the rusher on a rushing play. |
| yds_rushed | double | Rushing yards gained on the play. |
| passer_player_name | character | Name of the passer on a passing play. |
| receiver_player_name | character | Name of the receiver on a passing play. |
| yds_receiving | double | Receiving yards gained on the play. |
| yds_sacked | double | Yards lost on the sack. |
| sack_players | character | Combined names of all sack participants. |
| sack_player_name | character | Primary sack player name. |
| sack_player_name2 | character | Secondary sack player name (when split between two defenders). |
| pass_breakup_player_name | character | Name of the defender credited with the pass breakup. |
| interception_player_name | character | Name of the defender credited with the interception. |
| yds_int_return | double | Yards gained on an interception return. |
| fumble_player_name | character | Name of the player who fumbled. |
| fumble_forced_player_name | character | Name of the player who forced the fumble. |
| fumble_recovered_player_name | character | Name of the player who recovered the fumble. |
| yds_fumble_return | double | Yards gained on a fumble return. |
| punter_player_name | character | Name of the punter. |
| yds_punted | double | Yards the ball traveled on the punt. |
| punt_returner_player_name | character | Name of the punt returner. |
| yds_punt_return | double | Yards gained on the punt return. |
| yds_punt_gained | double | The play's `yards_gained` on punt plays; NA otherwise. |
| punt_block_player_name | character | Name of the player credited with blocking the punt. |
| punt_block_return_player_name | character | Name of the player returning a blocked punt. |
| fg_kicker_player_name | character | Name of the field goal kicker. |
| yds_fg | double | Distance of the field goal attempt in yards; NA on other plays. |
| fg_block_player_name | character | Name of the player credited with blocking the field goal. |
| fg_return_player_name | character | Name of the player returning the blocked/missed field goal. |
| kickoff_player_name | character | Name of the kickoff specialist. |
| yds_kickoff | double | Yards the ball traveled on the kickoff. |
| kickoff_returner_player_name | character | Name of the kickoff returner. |
| yds_kickoff_return | double | Yards gained on the kickoff return. |
| new_id | double | Numeric play index within the game (id_play with game_id stripped). |
| orig_drive_number | integer | Original CFBD drive number for the play. |
| drive_number | integer | cfbfastR-cleaned drive number for the play. |
| drive_result_detailed | character | Detailed drive result label (e.g. "Punt", "Passing Touchdown", "Downs Turnover"). |
| new_drive_pts | double | Points scored on the drive (signed for offense/defense). |
| drive_id | double | CFBD drive identifier. |
| drive_result | character | CFBD drive result label. |
| drive_start_yards_to_goal | double | Yards to goal at the start of the drive. |
| drive_end_yards_to_goal | integer | Yards to goal at the end of the drive. |
| drive_yards | integer | Net yards gained on the drive. |
| drive_scoring | double | Binary flag for a scoring drive. |
| drive_pts | double | Points scored on the drive (CFBD/cfbfastR reconciled value). |
| drive_start_period | integer | Period (quarter) at the start of the drive. |
| drive_end_period | integer | Period (quarter) at the end of the drive. |
| drive_time_minutes_start | integer | Minutes on the clock at the start of the drive. |
| drive_time_seconds_start | integer | Seconds on the clock at the start of the drive. |
| drive_time_minutes_end | integer | Minutes on the clock at the end of the drive. |
| drive_time_seconds_end | integer | Seconds on the clock at the end of the drive. |
| drive_time_minutes_elapsed | integer | Minutes elapsed during the drive. |
| drive_time_seconds_elapsed | integer | Seconds elapsed during the drive. |
| drive_numbers | double | Binary flag marking the first play of a new drive. |
| number_of_drives | double | Cumulative count of drives in the game. |
| pts_scored | double | Points scored on the play, signed by play_type rule. |
| drive_num | double | Game-scoped drive sequence number. |
| id_drive | character | Composite drive identifier (game_id concatenated with drive_num). |
| rush | double | Binary flag for a rushing play. |
| rush_td | double | Binary flag for a rushing touchdown. |
| pass | double | Binary flag for a passing play (includes sacks). |
| pass_td | double | Binary flag for a passing touchdown. |
| completion | double | Binary flag for a completed pass. |
| pass_attempt | double | Binary flag for a pass attempt. |
| target | double | Binary flag for a targeted receiver on the play. |
| sack | double | Binary flag for a sack; unlike `sack_vec`, excludes sack and fumble-return touchdowns. |
| int | double | Binary flag for an interception. |
| int_td | double | Binary flag for an interception returned for a touchdown. |
| turnover_vec | double | Binary flag for any play classified as a turnover. |
| kickoff_play | double | Binary flag for a kickoff play. |
| receives_2H_kickoff | double | Binary flag for the team receiving the second-half kickoff. |
| scoring_play | double | Binary flag for any scoring play. |
| td_play | double | Binary flag for a touchdown play. |
| touchdown | double | Binary flag: 1 when `play_type` contains Touchdown (`td_play` reads `play_text` instead). |
| safety | double | Binary flag for a safety. |
| fumble_vec | double | Binary flag for a play involving a fumble. |
| kickoff_tb | double | Binary flag for a kickoff touchback. |
| kickoff_onside | double | Binary flag for an onside kickoff attempt. |
| kickoff_oob | double | Binary flag for a kickoff out of bounds. |
| kickoff_fair_catch | double | Binary flag for a kickoff fair catch. |
| kickoff_downed | double | Binary flag for a kickoff downed in the field of play. |
| kickoff_safety | double | Binary flag for a kickoff safety. |
| punt | double | Binary flag for a punt play. |
| punt_play | double | Binary flag for any punt-related play (includes blocks/returns). |
| punt_tb | double | Binary flag for a punt touchback. |
| punt_oob | double | Binary flag for a punt out of bounds. |
| punt_fair_catch | double | Binary flag for a punt fair catch. |
| punt_downed | double | Binary flag for a punt downed in the field of play. |
| punt_safety | double | Binary flag for a punt safety. |
| punt_blocked | double | Binary flag for a blocked punt. |
| penalty_safety | double | Binary flag for a safety scored on a penalty. |
| fg_inds | double | Binary flag for a field goal attempt. |
| fg_made | logical | TRUE when the field goal attempt was successful. |
| fg_make_prob | double | Predicted probability of making the field goal (cfbfastR FG model, 0-1); NA on plays that are not field goal attempts. |
| No_Score_before | double | Pre-play predicted probability of no score before end of half (cfbfastR EP model, 0-1). |
| FG_before | double | Pre-play predicted probability of a posteam field goal next (0-1). |
| Opp_FG_before | double | Pre-play predicted probability of a defteam field goal next (0-1). |
| Opp_Safety_before | double | Pre-play predicted probability of a defteam safety next (0-1). |
| Opp_TD_before | double | Pre-play predicted probability of a defteam touchdown next (0-1). |
| Safety_before | double | Pre-play predicted probability of a posteam safety next (0-1). |
| TD_before | double | Pre-play predicted probability of a posteam touchdown next (0-1). |
| No_Score_after | double | Post-play predicted probability of no score before end of half (0-1). |
| FG_after | double | Post-play predicted probability of a posteam field goal next (0-1). |
| Opp_FG_after | double | Post-play predicted probability of a defteam field goal next (0-1). |
| Opp_Safety_after | double | Post-play predicted probability of a defteam safety next (0-1). |
| Opp_TD_after | double | Post-play predicted probability of a defteam touchdown next (0-1). |
| Safety_after | double | Post-play predicted probability of a posteam safety next (0-1). |
| TD_after | double | Post-play predicted probability of a posteam touchdown next (0-1). |
| penalty_flag | logical | TRUE when a penalty was flagged on the play. |
| penalty_declined | logical | TRUE when the penalty was declined. |
| penalty_no_play | logical | TRUE when the penalty nullified the play (no play counted). |
| penalty_offset | logical | TRUE when offsetting penalties were called. |
| penalty_text | logical | TRUE when penalty information is detectable in the play text. |
| penalty_play_text | character | Penalty-related substring extracted from the play text. |
| lead_wp_before2 | double | Win probability two plays ahead (lead 2 of wp_before). |
| wpa_half_end | double | WPA contribution from the end-of-half adjustment. |
| wpa_base | double | Base WPA component used to assemble the final wpa value. |
| wpa_base_nxt | double | WPA base component looking ahead one play. |
| wpa_change | double | WPA change-of-possession component for the current play. |
| wpa_change_nxt | double | WPA change-of-possession component for the next play. |
| wpa_base_ind | double | Indicator selecting the wpa_base path for the current play. |
| wpa_base_nxt_ind | double | Indicator selecting the wpa_base_nxt path for the next play. |
| wpa_change_ind | double | Indicator selecting the wpa_change path for the current play. |
| wpa_change_nxt_ind | double | Indicator selecting the wpa_change_nxt path for the next play. |
| lead_wp_before | double | Win probability on the next play (lead of wp_before). |
| lead_pos_team2 | character | Possession team two plays ahead (lead 2 of pos_team). |
| row | integer | Row index within the game half (sequencing helper). |
| drive_event_number | double | Sequential event number within the current drive. |
| first_by_penalty | double | Binary flag for a first down earned by penalty on the play. |
| first_by_yards | double | Binary flag for a first down earned by yards on the play. |
| play_after_turnover | double | Binary flag indicating the play immediately following a turnover. |
| play_number | integer | CFBD-supplied play number within the drive (1-indexed); `game_play_number` is the game-level sequence. |
| wallclock | character | ISO 8601 wall-clock timestamp from CFBD for the play. |
| provider | character | Sportsbook provider used for spread/over_under joined onto the play. Present only when `year >= 2013`. |
| spread | double | Pre-game point spread from the selected provider (negative when the home team is favored). Present only when `year >= 2013`; NA when no line was found. |
| formatted_spread | character | Human-readable formatted spread string from the betting provider. Present only when `year >= 2013`. |
| over_under | double | Pre-game over/under total from the selected provider. Present only when `year >= 2013`. |
| drive_is_home_offense | logical | TRUE when the home team is on offense for the drive. |
| drive_start_offense_score | integer | Offense score at the start of the drive. |
| drive_start_defense_score | integer | Defense score at the start of the drive. |
| drive_end_offense_score | integer | Offense score at the end of the drive. |
| drive_end_defense_score | integer | Defense score at the end of the drive. |
| home_team_id | character | Home team id (CFBD /games `homeId`; CFBD team ids are ESPN team ids); NA when the game is not in CFBD /games. |
| away_team_id | character | Away team id (CFBD /games `awayId`); NA when the game is not in CFBD /games. |
| home_team_abbreviation | character | Home team abbreviation from CFBD /teams; NA when the team is not in /teams. |
| away_team_abbreviation | character | Away team abbreviation from CFBD /teams; NA when the team is not in /teams. |
| offense_play_id | character | Team id of the offense on the play; NA when `offense_play` names neither team in the game. |
| defense_play_id | character | Team id of the defense on the play; NA when `defense_play` names neither team in the game. |
| cleaned_text | character | `play_text` with the leading clock stamp, the first pass depth and direction words, and No Huddle/Shotgun tags removed. |
| play | double | Binary flag indicating the row is a counted play (excludes end markers/timeouts/penalties). |
| event | double | Binary flag indicating the row is a counted game event (excludes end markers). |
| game_event_number | double | Sequential event number within the game. |
| game_row_number | integer | Row index within the game grouping. |
| half_play | double | Binary flag indicating a counted play within the half. |
| half_event | double | Binary flag indicating a counted event within the half. |
| half_event_number | double | Sequential event number within the half. |
| half_row_number | integer | Row index within the half grouping. |
| pos_unit | character | Unit of the team in possession: `Offense`, `Punt Offense`, `Kickoff Return` or `Field Goal Offense`. |
| def_pos_unit | character | Unit of the defending team: `Defense`, `Punt Return`, `Kickoff Defense` or `Field Goal Defense`. |
| drive_play | double | Binary flag indicating a counted play within the drive. |
| drive_event | double | Binary flag indicating a counted event within the drive. |
| punt_return_player_name | character | Name of the punt returner (same as `punt_returner_player_name`). |
| kickoff_return_player_name | character | Name of the kickoff returner (same as `kickoff_returner_player_name`). |
| vegas_wp | double | Spread-aware win probability for the team in possession before the play (proportion 0-1); NA when the game has no pre-game spread (always before 2013). |
| vegas_wpa | double | Change in `vegas_wp` over the play, with the same possession-change handling as `wpa`; NA on the final rows of a game. |
| vegas_wp_after | double | Spread-aware win probability after the play (`vegas_wp` plus `vegas_wpa`). |
| cp | double | Modeled completion probability of the pass (proportion 0-1, cfbfastR CP model); NA on non-pass plays. |
| cpoe | double | Completion percentage over expected, in percentage points: `100 * (completion - cp)`; NA on non-pass plays. |
| xpass | double | Modeled probability that the play is a pass given down, distance, field position, score, time and era (proportion 0-1); NA on non-scrimmage plays. |
| pass_oe | double | Pass over expected, in percentage points: `100 * (pass - xpass)`; NA on non-scrimmage plays. |
| prob_2pt | double | Modeled probability of converting a two-point try (proportion 0-1). Set only on offensive-touchdown rows of games with a pre-game line; NA elsewhere. |
| two_pt_wp | double | Win probability for the scoring team if it goes for two, weighting the make and miss outcomes by `prob_2pt`; offensive-touchdown rows only. |
| xp_wp | double | Win probability for the scoring team if it kicks the extra point; offensive-touchdown rows only. |
| two_pt_wp_diff | double | `two_pt_wp` minus `xp_wp`; positive favors going for two. |
| two_pt_recommendation | character | `go_for_2` when `two_pt_wp` exceeds `xp_wp`, otherwise `kick_xp`; NA off offensive-touchdown rows. Use `two_pt_wp_diff` to apply a threshold. |
| go_wp | double | Win probability for the team in possession if it goes for it on fourth down (proportion 0-1). The fourth-down columns are set only on fourth downs in periods 1-4 with more than 30 seconds left in the game; NA elsewhere. |
| first_down_prob | double | Modeled probability that going for it on fourth down converts (first down or score). |
| wp_succeed | double | Win probability if the fourth-down attempt converts; NA when that outcome has no probability. |
| wp_fail | double | Win probability if the fourth-down attempt fails; NA when that outcome has no probability. |
| fourth_down_fg_make_prob | double | Probability of making a field goal from the current spot, set to 0 beyond 42 yards to goal and scaled by 0.9 from 35 to 42 (not the same as `fg_make_prob`). |
| make_fg_wp | double | Win probability for the kicking team if the fourth-down field goal is made. |
| miss_fg_wp | double | Win probability for the kicking team if the fourth-down field goal is missed. |
| fg_wp | double | Expected win probability of attempting the field goal: `make_fg_wp` and `miss_fg_wp` weighted by `fourth_down_fg_make_prob`. |
| punt_wp | double | Expected win probability of punting; NA when `yards_to_goal` is under 31, where the bundled punt distribution has no data. |
| go_boost | double | Win probability gained by going for it over the better of the field goal and the punt, in percentage points. |
| go_wp_diff | double | `go_wp` minus the win probability of the recommended option (0 when going for it is recommended). |
| fg_wp_diff | double | `fg_wp` minus the win probability of the recommended option (0 when the field goal is recommended). |
| punt_wp_diff | double | `punt_wp` minus the win probability of the recommended option (0 when the punt is recommended). |
| fourth_down_recommendation | character | Fourth-down option with the highest win probability: `go`, `field_goal` or `punt`; NA off fourth-down rows. |

**Columns added by `output = "full"`** - one row per play; lag/lead
pipeline intermediates, redundant alternates and drive-result aliases,
each defined below:

|  |  |  |
|----|----|----|
| col_name | type | description |
| lead_pos_team | character | Possession team on the next play (lead value). |
| lead_play_type | character | Play type on the next play (lead value). |
| lag_pos_team | character | Possession team on the previous play (lag value). |
| lag_play_type | character | Play type on the previous play (lag value). |
| drive_result_detailed_flag | character | Pre-fill copy of drive_result_detailed used during drive reconciliation. |
| drive_result2 | character | Short-form drive result label (e.g. "TD", "PUNT", "DOWNS"). |
| lag_drive_result_detailed | character | Drive result detailed on the previous play (lag value). |
| lead_drive_result_detailed | character | Drive result detailed on the next play (lead value). |
| lag_new_drive_pts | double | Drive points on the previous play (lag value). |
| sack_vec | double | Binary flag for a sack play. |
| turnover_vec_lag | double | Lag of turnover_vec (previous-play turnover flag). |
| turnover_indicator | double | Composite turnover indicator including failed 4th downs. |
| missing_yard_flag | logical | TRUE when post-play yardage had to be imputed. |
| kick_play | double | Binary flag for a play whose text mentions a kick (kickoffs, extra points, field goals). |
| lag_play_type2 | character | Play type two plays prior (lag 2 of play_type). |
| lag_play_type3 | character | Play type three plays prior (lag 3 of play_type). |
| lag_play_text | character | Play text from the previous play (lag value). |
| lag_play_text2 | character | Play text from two plays prior (lag 2 value). |
| lead_play_text | character | Play text from the next play (lead value). |
| lag_first_by_penalty | double | First-down-by-penalty flag from the previous play (lag value). |
| lag_first_by_penalty2 | double | First-down-by-penalty flag from two plays prior (lag 2 value). |
| lag_first_by_yards | double | First-down-by-yards flag from the previous play (lag value). |
| lag_first_by_yards2 | double | First-down-by-yards flag from two plays prior (lag 2 value). |
| lag_change_of_poss | double | change_of_poss from the previous play (lag value). |
| lag_change_of_pos_team | double | change_of_pos_team from the previous play (lag value). |
| lag_change_of_pos_team2 | double | change_of_pos_team from two plays prior (lag 2 value). |
| lag_kickoff_play | double | kickoff_play flag from the previous play (lag value). |
| lag_punt | double | punt flag from the previous play (lag value). |
| lag_punt2 | double | punt flag from two plays prior (lag 2 value). |
| lag_scoring_play | double | scoring_play flag from the previous play (lag value). |
| lag_turnover_vec | double | turnover_vec flag from the previous play (lag value). |
| lag_downs_turnover | double | downs_turnover flag from the previous play (lag value). |
| lag_defense_score_play | double | defense_score_play flag from the previous play (lag value). |
| lag_score_diff | double | score_diff from the previous play (lag value). |
| lag_offense_play | character | offense_play from the previous play (lag value). |
| lead_offense_play | character | offense_play from the next play (lead value). |
| lead_offense_play2 | character | offense_play from two plays ahead (lead 2 value). |
| lag_pos_score_diff | double | pos_score_diff from the previous play (lag value). |
| lag_off_timeouts | double | offense_timeouts from the previous play (lag value). |
| lag_def_timeouts | double | defense_timeouts from the previous play (lag value). |
| lag_TimeSecsRem2 | double | TimeSecsRem from two plays prior (lag 2 value). |
| lag_TimeSecsRem | double | TimeSecsRem from the previous play (lag value). |
| lead_TimeSecsRem | double | TimeSecsRem from the next play (lead value). |
| lead_TimeSecsRem2 | double | TimeSecsRem from two plays ahead (lead 2 value). |
| lag_yards_to_goal2 | integer | yards_to_goal from two plays prior (lag 2 value). |
| lag_yards_to_goal | integer | yards_to_goal from the previous play (lag value). |
| lead_yards_to_goal | double | yards_to_goal from the next play (lead value). |
| lead_yards_to_goal2 | integer | yards_to_goal from two plays ahead (lead 2 value). |
| lag_down2 | integer | Down number two plays prior (lag 2 value). |
| lag_down | integer | Down number from the previous play (lag value). |
| lead_down | double | Down number on the next play (lead value). |
| lead_down2 | double | Down number two plays ahead (lead 2 value). |
| lead_distance | double | Distance to go on the next play (lead value). |
| lead_distance2 | integer | Distance to go two plays ahead (lead 2 value). |
| lead_play_type2 | character | Play type two plays ahead (lead 2 value). |
| lead_play_type3 | character | Play type three plays ahead (lead 3 value). |
| lag_ep_before3 | double | ep_before from three plays prior (lag 3 value). |
| lag_ep_before2 | double | ep_before from two plays prior (lag 2 value). |
| lag_ep_before | double | ep_before from the previous play (lag value). |
| lead_ep_before | double | ep_before on the next play (lead value). |
| lead_ep_before2 | double | ep_before two plays ahead (lead 2 value). |
| lag_ep_after | double | ep_after from the previous play (lag value). |
| lag_ep_after2 | double | ep_after from two plays prior (lag 2 value). |
| lag_ep_after3 | double | ep_after from three plays prior (lag 3 value). |
| lead_ep_after | double | ep_after on the next play (lead value). |
| lead_ep_after2 | double | ep_after two plays ahead (lead 2 value). |
| lag_distance3 | integer | distance three plays prior (lag 3 value). |
| lag_distance2 | integer | distance two plays prior (lag 2 value). |
| lag_distance | integer | distance from the previous play (lag value). |
| lag_yards_gained3 | integer | yards_gained three plays prior (lag 3 value). |
| lag_yards_gained2 | integer | yards_gained two plays prior (lag 2 value). |
| lag_yards_gained | integer | yards_gained from the previous play (lag value). |
| lead_yards_gained | integer | yards_gained on the next play (lead value). |
| lead_yards_gained2 | integer | yards_gained two plays ahead (lead 2 value). |
| lag_play_text3 | character | Play text from three plays prior (lag 3 value). |
| lead_play_text2 | character | Play text from two plays ahead (lead 2 value). |
| lead_play_text3 | character | Play text from three plays ahead (lead 3 value). |
| lag_change_of_poss2 | double | change_of_poss from two plays prior (lag 2 value). |
| lag_change_of_poss3 | double | change_of_poss from three plays prior (lag 3 value). |
| lag_change_of_pos_team3 | double | change_of_pos_team from three plays prior (lag 3 value). |
| lag_kickoff_play2 | double | kickoff_play flag from two plays prior (lag 2 value). |
| lag_kickoff_play3 | double | kickoff_play flag from three plays prior (lag 3 value). |
| lag_punt3 | double | punt flag from three plays prior (lag 3 value). |
| lag_scoring_play2 | double | scoring_play flag from two plays prior (lag 2 value). |
| lag_scoring_play3 | double | scoring_play flag from three plays prior (lag 3 value). |
| lag_turnover_vec2 | double | turnover_vec flag from two plays prior (lag 2 value). |
| lag_turnover_vec3 | double | turnover_vec flag from three plays prior (lag 3 value). |
| lag_downs_turnover2 | double | downs_turnover flag from two plays prior (lag 2 value). |
| lag_downs_turnover3 | double | downs_turnover flag from three plays prior (lag 3 value). |
| lag_first_by_penalty3 | double | first_by_penalty flag from three plays prior (lag 3 value). |
| lag_first_by_yards3 | double | first_by_yards flag from three plays prior (lag 3 value). |

## Details

     # Get play by play data for 2025 regular season week 1
     cfbd_pbp_data(year = 2025, week = 1, season_type = 'regular', epa_wpa = TRUE)

## See also

Other CFBD PBP:
[`cfbd_live_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.md),
[`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md),
[`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md),
[`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md),
[`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md),
[`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)
