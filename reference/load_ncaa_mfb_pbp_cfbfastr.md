# **Load NCAA men's football play-by-play, cfbfastR-shaped from the SportsDataverse data repo**

Loads the cfbfastR-schema-shaped variant of the stats.ncaa.org men's
football play-by-play – the same plays as
[`load_ncaa_mfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_ncaa_mfb_pbp.md)
reshaped onto cfbfastR pbp column conventions for cross-source binds.
Published to the `ncaa_mfb_pbp_cfbfastr` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_ncaa_mfb_pbp_cfbfastr(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2013 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2013)

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
| game_id | integer |  |
| id_play | character | Play id, returned as character (the release stores it as Int64) to match the other pbp loaders. |
| drive_id | integer |  |
| game_play_number | integer |  |
| half_play_number | integer |  |
| drive_play_number | integer |  |
| drive_number | integer |  |
| season | integer |  |
| year | integer |  |
| week | integer |  |
| period | integer |  |
| half | integer |  |
| clock.minutes | integer |  |
| clock.seconds | integer |  |
| TimeSecsRem | integer |  |
| Under_two | logical |  |
| pos_team | character |  |
| def_pos_team | character |  |
| offense_play | character |  |
| defense_play | character |  |
| home | character |  |
| away | character |  |
| pos_team_score | integer |  |
| def_pos_team_score | integer |  |
| offense_score | integer |  |
| defense_score | integer |  |
| pos_score_diff | integer |  |
| score_pts | integer |  |
| scoring_play | logical |  |
| scoring | logical |  |
| down | integer |  |
| distance | integer |  |
| yard_line | character |  |
| yards_to_goal | integer |  |
| yards_to_goal_end | integer |  |
| Goal_To_Go | logical |  |
| log_ydstogo | double |  |
| yards_gained | integer |  |
| play_type | character |  |
| orig_play_type | character |  |
| play_text | character |  |
| rush | logical |  |
| rush_td | logical |  |
| pass | logical |  |
| pass_td | logical |  |
| pass_attempt | logical |  |
| completion | logical |  |
| target | logical |  |
| sack | logical |  |
| sack_vec | logical |  |
| int | logical |  |
| int_td | logical |  |
| turnover_vec | logical |  |
| downs_turnover | logical |  |
| touchdown | logical |  |
| td_play | logical |  |
| safety | logical |  |
| fumble_vec | logical |  |
| punt | logical |  |
| punt_play | logical |  |
| kickoff_play | logical |  |
| kick_play | logical |  |
| fg_inds | logical |  |
| fg_made | logical |  |
| punt_blocked | logical |  |
| punt_fair_catch | logical |  |
| firstD_by_yards | logical |  |
| firstD_by_penalty | logical |  |
| penalty_flag | logical |  |
| penalty_no_play | logical |  |
| penalty_declined | logical |  |
| penalty_offset | logical |  |
| penalty_text | character |  |
| yds_penalty | integer |  |
| rusher_player_name | character |  |
| passer_player_name | character |  |
| receiver_player_name | character |  |
| interception_player_name | character |  |
| punter_player_name | character |  |
| punt_returner_player_name | character |  |
| fg_kicker_player_name | character |  |
| kickoff_player_name | character |  |
| kickoff_returner_player_name | character |  |
| yds_rushed | integer |  |
| yds_receiving | integer |  |
| yds_sacked | integer |  |
| yds_punted | integer |  |
| yds_punt_return | integer |  |
| yds_kickoff | integer |  |
| yds_kickoff_return | integer |  |
| yds_int_return | integer |  |
| yds_fg | integer |  |
| drive_result | character |  |
| drive_scoring | logical |  |
| ot_synthesized | logical |  |
| lag_pos_team | character |  |
| lead_pos_team | character |  |
| lag_play_type | character |  |
| lead_play_type | character |  |
| lag_play_text | character |  |
| lead_play_text | character |  |
| change_of_pos_team | logical |  |
| play_after_turnover | logical |  |
| n_plays_in_game | integer |  |
| espn_game_id | character |  |

## Author

Saiem Gilani

## Examples

``` r
if (FALSE) { # interactive()
# Downloads and parses a whole season of play-by-play.
try(load_ncaa_mfb_pbp_cfbfastr(2013))
}
```
