# **Get a pregame preview for a game**

**Returns pregame team comparisons and key players.** Analysis remains
available until the game is completed. Team statistics may use the
previous season; players and context stay in the game season.

## Usage

``` r
cfbd_game_preview(game_id, proxy = NULL)
```

## Arguments

- game_id:

  (*Integer* required): Game ID filter for querying a single game. Can
  be found using the
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  or
  [`cfbd_game_schedule()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_schedule.md)
  functions.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables.

## Value

A named list of data frames: `game`, `broadcasts`, `odds`, `teams`,
`key_players`, `recent_results`, `series`, `series_meetings`. The
sections have different row grains, so they are not joined. A section
CFBD did not fill is a 0-column tibble: once `availability` is
`metadata_only` (for example a completed game) every section except
`game` is empty. Nested objects are flattened into prefixed columns, and
a nested object CFBD sends as null (`venue`, `playoff`,
`latest_meeting`, `streak`, a statistics block) becomes one all-NA
column named after it instead of its prefixed columns. An empty list is
returned if the request fails.

**game** - one row:

|  |  |  |
|----|----|----|
| col_name | type | description |
| game_id | integer | Unique CFBD game identifier. |
| season | integer | Season of the game. |
| week | integer | Game week (postseason games restart at week 1). |
| season_type | character | Season type of the game (e.g. regular, postseason). |
| status | character | Game status: scheduled, in_progress or completed. |
| status_checked_at | character | When CFBD last checked the game status (ISO 8601, UTC). |
| start_date | character | Game start date-time (ISO 8601, UTC). |
| start_time_tbd | logical | TRUE if the start time is still to be determined. |
| neutral_site | logical | TRUE if the game is at a neutral site. |
| conference_game | logical | TRUE if the game is a conference game. |
| home_team_id | integer | Home team id. |
| home_team_name | character | Home team name. |
| home_team_conference | character | Home team conference. |
| home_team_conference_abbreviation | character | Home team conference abbreviation. |
| home_team_classification | character | Home team division classification: fbs, fcs, ii, ii/iii or iii. |
| home_team_points | integer | Home team points; NA until the game has a score. |
| away_team_id | integer | Away team id. |
| away_team_name | character | Away team name. |
| away_team_conference | character | Away team conference. |
| away_team_conference_abbreviation | character | Away team conference abbreviation. |
| away_team_classification | character | Away team division classification: fbs, fcs, ii, ii/iii or iii. |
| away_team_points | integer | Away team points; NA until the game has a score. |
| venue_id | integer | Venue id. |
| venue_name | character | Venue name. |
| venue_city | character | Venue city. |
| venue_state | character | Venue state abbreviation. |
| playoff | logical | All-NA placeholder, present only when the game is not a College Football Playoff game (the eight `playoff_*` columns replace it for CFP games). |
| playoff_competition | character | Playoff competition (cfp); present only for CFP games. |
| playoff_format | character | Playoff format (e.g. twelve_team_2025); present only for CFP games. |
| playoff_round | character | Playoff round: first_round, quarterfinal, semifinal or championship; present only for CFP games. |
| playoff_round_name | character | Display name of the round (e.g. Quarterfinal); present only for CFP games. |
| playoff_bracket_slot | character | Bracket slot code (e.g. FR4, QF1); present only for CFP games. |
| playoff_home_seed | integer | Home team playoff seed; present only for CFP games. |
| playoff_away_seed | integer | Away team playoff seed; present only for CFP games. |
| playoff_bowl_name | character | Name of the bowl hosting the game (e.g. Rose Bowl), NA when none; present only for CFP games. |
| availability | character | pregame (analysis sections filled) or metadata_only (only `game` is filled). |
| reason | character | Why analysis is not available: game_started, game_completed, kickoff_reached or kickoff_unknown; NA when `availability` is pregame. |
| assembled_at | character | When CFBD assembled the preview (ISO 8601, UTC). |

**broadcasts** - one row per broadcast:

|            |           |                                                  |
|------------|-----------|--------------------------------------------------|
| col_name   | type      | description                                      |
| media_type | character | Broadcast medium: tv, radio, web, ppv or mobile. |
| outlet     | character | Broadcast outlet (e.g. ABC).                     |

**odds** - one row, the line from the selected sportsbook:

|  |  |  |
|----|----|----|
| col_name | type | description |
| provider_id | integer | Sportsbook provider id. |
| provider | character | Sportsbook: DraftKings or Bovada. |
| spread | double | Home-relative point spread; negative favors home. Integer when every spread in the result is a whole number. |
| over_under | double | Total points line. |
| home_moneyline | integer | Home team moneyline (American odds). |
| away_moneyline | integer | Away team moneyline (American odds). |

**teams** - one row per side (home, away). The rows `ppa` through
`field_position_average_predicted_points` (metrics) and `rank` through
`percentile` (stats) are base names: each metric appears as the columns
`statistics_data_stat_rankings_<side>_<metric>_<stat>`, for `<side>`
`offense` then `defense`, every metric in row order and every stat in
row order (160 columns), except that a metric CFBD sends as null (in the
sample, `power_success`) is one all-NA
`statistics_data_stat_rankings_<side>_<metric>` column instead of four:

|  |  |  |
|----|----|----|
| col_name | type | description |
| side | character | home or away: which team of this game the row describes. |
| team_id | integer | Team id. |
| season | integer | Season of the game. |
| statistics_status | character | Status of the team statistics section: available, no_data or unavailable. |
| statistics_reason | character | Why the statistics section has no data: no_data, no_results_yet, source_error or invalid_data; NA when available. |
| statistics_assembled_at | character | When CFBD assembled the statistics section (ISO 8601, UTC). |
| statistics_source_updated_at | character | Publication time of the statistics snapshot, not a games-through cutoff (ISO 8601, UTC). |
| statistics_data_season | integer | Season the team statistics come from. |
| statistics_data_is_previous_season | logical | TRUE when the statistics come from the season before the game season. |
| statistics_data_advanced\_\* | varies | The `advanced` section of [`cfbd_team_season_overview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_season_overview.md) for `statistics_data_season` (same columns and order), prefixed `statistics_data_advanced_`; each column is defined there. |
| statistics_data_passing\_\* | varies | All columns of [`cfbd_passing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_season.md), including `season`, `team` and `conference`, in the order of the `passing` section of [`cfbd_team_season_overview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_season_overview.md), prefixed `statistics_data_passing_`; each column is defined there, see [cfbd_passing](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing.md). |
| statistics_data_rushing\_\* | varies | All columns of [`cfbd_rushing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_season.md), including `season`, `team` and `conference`, in the order of the `rushing` section of [`cfbd_team_season_overview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_season_overview.md), prefixed `statistics_data_rushing_`; each column is defined there, see [cfbd_rushing](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing.md). |
| statistics_data_stat_rankings_team_id | integer | Team id the stat rankings are for. |
| statistics_data_stat_rankings_season | integer | Season the stat rankings are computed for. |
| statistics_data_stat_rankings_division | character | Division the team is ranked within: fbs, fcs, ii, ii/iii or iii. |
| statistics_data_stat_rankings_division_team_count | integer | Number of teams in that division. |
| statistics_data_stat_rankings_calculated_at | character | When CFBD calculated the stat rankings (ISO 8601, UTC). |
| statistics_data_stat_rankings_expires_at | character | When CFBD's cached stat rankings expire (ISO 8601, UTC). |
| statistics_data_stat_rankings_source_updated_at | character | Publication time of the statistics the rankings are built from (ISO 8601, UTC). |
| ppa | varies | Metric: predicted points added (EPA) per play, `statistics_data_advanced_<side>_ppa`. |
| success_rate | varies | Metric: success rate (proportion of successful plays), `statistics_data_advanced_<side>_success_rate`. |
| explosiveness | varies | Metric: explosiveness (average PPA on successful plays), `statistics_data_advanced_<side>_explosiveness`. |
| standard_downs_success_rate | varies | Metric: success rate on standard downs, `statistics_data_advanced_<side>_standard_downs_success_rate`. |
| passing_downs_success_rate | varies | Metric: success rate on passing downs, `statistics_data_advanced_<side>_passing_downs_success_rate`. |
| passing_plays_ppa | varies | Metric: PPA per pass play, `statistics_data_advanced_<side>_passing_plays_ppa`. |
| rushing_plays_ppa | varies | Metric: PPA per rush play, `statistics_data_advanced_<side>_rushing_plays_ppa`. |
| passing_plays_explosiveness | varies | Metric: explosiveness of pass plays, `statistics_data_advanced_<side>_passing_plays_explosiveness`. |
| rushing_plays_explosiveness | varies | Metric: explosiveness of rush plays, `statistics_data_advanced_<side>_rushing_plays_explosiveness`. |
| line_yards | varies | Metric: offensive line yards per rush, `statistics_data_advanced_<side>_line_yards`. |
| second_level_yards | varies | Metric: second-level yards per rush (5-10 yards past the line of scrimmage), `statistics_data_advanced_<side>_second_level_yards`. |
| open_field_yards | varies | Metric: open-field yards per rush (yards gained more than 10 yards past the line of scrimmage), `statistics_data_advanced_<side>_open_field_yards`. |
| stuff_rate | varies | Metric: proportion of rushes stopped at or behind the line of scrimmage, `statistics_data_advanced_<side>_stuff_rate`. |
| power_success | varies | Metric: power success (proportion of short-yardage runs that convert), `statistics_data_advanced_<side>_power_success`. |
| havoc_total | varies | Metric: havoc rate (share of plays with a tackle for loss, forced fumble, interception or pass breakup), `statistics_data_advanced_<side>_havoc_total`. |
| havoc_front_seven | varies | Metric: havoc rate from front-seven players, `statistics_data_advanced_<side>_havoc_front_seven`. |
| havoc_db | varies | Metric: havoc rate from defensive backs, `statistics_data_advanced_<side>_havoc_db`. |
| points_per_opportunity | varies | Metric: points per scoring opportunity, `statistics_data_advanced_<side>_points_per_opportunity`. |
| field_position_average_start | varies | Metric: average drive start in yards to the end zone, `statistics_data_advanced_<side>_field_position_average_start`. |
| field_position_average_predicted_points | varies | Metric: average predicted points of the drive start, `statistics_data_advanced_<side>_field_position_average_predicted_points`. |
| rank | integer | Stat: the team's rank on the metric within `statistics_data_stat_rankings_division`, 1 = best for that side of the ball. |
| population | integer | Stat: number of teams ranked on the metric. |
| tied | logical | Stat: TRUE when the rank is shared with another team. |
| percentile | double | Stat: percentile of the rank within the division, 0-100 (higher is better). |
| record_status | character | Status of the record section: available, no_data or unavailable. |
| record_reason | character | Why the record section has no data: no_data, no_results_yet, source_error or invalid_data; NA when available. |
| record_assembled_at | character | When CFBD assembled the record section (ISO 8601, UTC). |
| record_source_updated_at | character | Publication time of the record snapshot (ISO 8601, UTC); NA when CFBD reports none. |
| record_data\_\* | varies | The `record` section of [`cfbd_team_season_overview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_season_overview.md), prefixed `record_data_`; each column is defined there. |
| ratings_status | character | Status of the ratings section: available, no_data or unavailable. |
| ratings_reason | character | Why the ratings section has no data: no_data, no_results_yet, source_error or invalid_data; NA when available. |
| ratings_assembled_at | character | When CFBD assembled the ratings section (ISO 8601, UTC). |
| ratings_source_updated_at | character | Publication time of the ratings snapshot (ISO 8601, UTC); NA when CFBD reports none. |
| ratings_data\_\* | varies | The `ratings` section of [`cfbd_team_season_overview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_season_overview.md) (the same padded, typed 25 columns), prefixed `ratings_data_`; each column is defined there. Absent when the ratings section has no data. |

**key_players** - one row per key player, per side and category:

|  |  |  |
|----|----|----|
| col_name | type | description |
| side | character | home or away. |
| category | character | passing, rushing or receiving. |
| athlete_id | character | Player id. |
| name | character | Player name. |
| position | character | Player position. |
| usage | double | Pass/rush involvement (proportion 0-1), not receiving target share. |
| average_ppa | double | Average predicted points added per play. |
| total_ppa | double | Total predicted points added. |

**recent_results** - one row per recent game of each side:

|  |  |  |
|----|----|----|
| col_name | type | description |
| side | character | home or away: the team of this game the result belongs to. |
| game_id | integer | Game id of the recent game. |
| season | integer | Season of the recent game. |
| start_date | character | Start date-time of the recent game (ISO 8601, UTC). |
| home_away | character | Whether the side's team was home or away in that game. |
| neutral_site | logical | TRUE if that game was at a neutral site. |
| team_points | integer | Points scored by the side's team; NA when unknown. |
| opponent_points | integer | Points scored by the opponent; NA when unknown. |
| result | character | Result for the side's team: win, loss, tie or unknown. |
| opponent_id | integer | Opponent team id. |
| opponent_name | character | Opponent team name. |
| venue_id | integer | Venue id. |
| venue_name | character | Venue name. |
| venue_city | character | Venue city. |
| venue_state | character | Venue state abbreviation. |

**series** - one row, the all-time series between the two teams:

|  |  |  |
|----|----|----|
| col_name | type | description |
| home_team_id | integer | Team id of this game's home team. |
| away_team_id | integer | Team id of this game's away team. |
| meetings | integer | Number of all-time meetings. |
| known_results | integer | Meetings with a known result. |
| unknown_results | integer | Meetings with an unknown result. |
| home_wins | integer | Series wins by this game's home team, wherever played. |
| away_wins | integer | Series wins by this game's away team, wherever played. |
| ties | integer | Tied meetings. |
| first_season | integer | Season of the first meeting; NA when the teams have not met. |
| last_season | integer | Season of the most recent meeting; NA when the teams have not met. |
| latest_meeting_game_id | integer | Game id of the most recent meeting. |
| latest_meeting_season | integer | Season of the most recent meeting. |
| latest_meeting_start_date | character | Start date-time of the most recent meeting (ISO 8601, UTC). |
| latest_meeting_home_team_id | integer | Home team id in the most recent meeting. |
| latest_meeting_home_team | character | Home team name in the most recent meeting. |
| latest_meeting_away_team_id | integer | Away team id in the most recent meeting. |
| latest_meeting_away_team | character | Away team name in the most recent meeting. |
| latest_meeting_neutral_site | logical | TRUE if the most recent meeting was at a neutral site. |
| latest_meeting_venue_id | integer | Venue id of the most recent meeting. |
| latest_meeting_venue_name | character | Venue name of the most recent meeting. |
| latest_meeting_venue_city | character | Venue city of the most recent meeting. |
| latest_meeting_venue_state | character | Venue state abbreviation of the most recent meeting. |
| latest_meeting_home_points | integer | Home team points in the most recent meeting. |
| latest_meeting_away_points | integer | Away team points in the most recent meeting. |
| latest_meeting_winner_team_id | integer | Winning team id in the most recent meeting; NA for a tie or unknown result. |
| latest_meeting_result | character | Result of the most recent meeting: win (see winner id), tie or unknown. |
| streak_team_id | integer | Team id holding the current series winning streak. |
| streak_wins | integer | Length of that winning streak, in consecutive meetings won. |

**series_meetings** - one row per recent meeting of the two teams:

|  |  |  |
|----|----|----|
| col_name | type | description |
| game_id | integer | Game id of the meeting. |
| season | integer | Season of the meeting. |
| start_date | character | Start date-time of the meeting (ISO 8601, UTC). |
| home_team_id | integer | Home team id in the meeting. |
| home_team | character | Home team name in the meeting. |
| away_team_id | integer | Away team id in the meeting. |
| away_team | character | Away team name in the meeting. |
| neutral_site | logical | TRUE if the meeting was at a neutral site. |
| home_points | integer | Home team points; NA when unknown. |
| away_points | integer | Away team points; NA when unknown. |
| winner_team_id | integer | Winning team id; NA for a tie or unknown result. |
| result | character | Result of the meeting: win (see `winner_team_id`), tie or unknown. |
| venue_id | integer | Venue id. |
| venue_name | character | Venue name. |
| venue_city | character | Venue city. |
| venue_state | character | Venue state abbreviation. |

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_preview_adjusted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_preview_adjusted.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_schedule()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_schedule.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_preview(game_id = 401114233))
#> $game
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-01 00:08:22 UTC
#> # A tibble: 1 × 30
#>     game_id season  week season_type status    status_checked_at      start_date
#>       <int>  <int> <int> <chr>       <chr>     <chr>                  <chr>     
#> 1 401114233   2019     1 regular     completed 2026-10-01T00:08:19.4… 2019-08-3…
#> # ℹ 23 more variables: start_time_tbd <lgl>, neutral_site <lgl>,
#> #   conference_game <lgl>, home_team_id <int>, home_team_name <chr>,
#> #   home_team_conference <chr>, home_team_conference_abbreviation <chr>,
#> #   home_team_classification <chr>, home_team_points <int>, away_team_id <int>,
#> #   away_team_name <chr>, away_team_conference <chr>,
#> #   away_team_conference_abbreviation <chr>, away_team_classification <chr>,
#> #   away_team_points <int>, venue_id <int>, venue_name <chr>, …
#> 
#> $broadcasts
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-01 00:08:22 UTC
#> # A tibble: 0 × 0
#> 
#> $odds
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-01 00:08:22 UTC
#> # A tibble: 0 × 0
#> 
#> $teams
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-01 00:08:22 UTC
#> # A tibble: 0 × 0
#> 
#> $key_players
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-01 00:08:22 UTC
#> # A tibble: 0 × 0
#> 
#> $recent_results
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-01 00:08:22 UTC
#> # A tibble: 0 × 0
#> 
#> $series
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-01 00:08:22 UTC
#> # A tibble: 0 × 0
#> 
#> $series_meetings
#> ── Game preview data from CollegeFootballData.com ─────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-01 00:08:22 UTC
#> # A tibble: 0 × 0
#> 
# }
```
