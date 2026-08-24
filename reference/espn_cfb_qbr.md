# **ESPN College Football Total Quarterback Rating (QBR)**

Get ESPN's Total Quarterback Rating (QBR) and its full set of
clutch-weighted EPA components for a college football season.

## Usage

``` r
espn_cfb_qbr(year = NULL, group = 80, athlete_detail = FALSE)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2004

- group:

  (*Integer* default 80): ESPN group id. `80` = all FBS. Conference
  group ids (e.g. `4` ACC, `8` Big 12, `12` SEC, `21` Big Ten) also
  work.

- athlete_detail:

  (*Logical*): when `TRUE`, dereference each quarterback and append the
  `athlete_*` name columns (see *Details*). This costs one HTTP call per
  quarterback, so it defaults to `FALSE`; setting it `FALSE` reproduces
  the prior output exactly.

## Value

A data frame with one row per quarterback:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| season_type | integer | ESPN season type (2 = regular season). |
| group_id | character | ESPN group id queried (`80` = all FBS). |
| athlete_id | character | ESPN athlete id (parsed from `athlete_ref`). |
| team_id | character | ESPN team id (parsed from `team_ref`). |
| qbpaa | numeric | QB Points Added Above Average. |
| cwepa_passes_condensed | numeric | Clutch-weighted EPA from passes (condensed). |
| cwepa_rushes | numeric | Clutch-weighted EPA from designed rushes. |
| cwepa_sacked_condensed | numeric | Clutch-weighted EPA lost to sacks (condensed). |
| cwepa_penalties | numeric | Clutch-weighted EPA from penalties. |
| cwepa_total | numeric | Total clutch-weighted EPA. |
| action_plays | numeric | Action plays charged to the quarterback. |
| cw_average | numeric | Clutch-weighted average win value per play. |
| qbr | numeric | Total Quarterback Rating (0-100). |
| cwepa_passes | numeric | Clutch-weighted EPA from pass attempts. |
| cwepa_interceptions | numeric | Clutch-weighted EPA lost to interceptions. |
| cwepa_yards_after_carry | numeric | Clutch-weighted EPA from yards after carry. |
| cwepa_runs | numeric | Clutch-weighted EPA from runs. |
| cwepa_scrambles | numeric | Clutch-weighted EPA from scrambles. |
| cwepa_sacked | numeric | Clutch-weighted EPA lost to sacks. |
| cwepa_fumbles | numeric | Clutch-weighted EPA lost to fumbles. |
| avg_opp_dqbr | numeric | Average opponent defensive QBR faced. |
| sched_adj_qbr | numeric | Schedule-adjusted QBR. |
| unqualified_rank | numeric | QBR rank including unqualified passers. |
| athlete_ref | character | `$ref` URL to the athlete-in-season resource. |
| team_ref | character | `$ref` URL to the team-in-season resource. |
| athlete_display_name | character | Player display name; `athlete_detail = TRUE` only. |
| athlete_first_name | character | Player first name; `athlete_detail = TRUE` only. |
| athlete_last_name | character | Player last name; `athlete_detail = TRUE` only. |
| athlete_jersey | character | Player jersey number; `athlete_detail = TRUE` only. |
| athlete_position | character | Player position name; `athlete_detail = TRUE` only. |
| athlete_position_abbreviation | character | Player position abbreviation; `athlete_detail = TRUE` only. |

## Details

Wraps the ESPN core-v2 QBR endpoint
`seasons/{year}/types/2/groups/{group}/qbr/0`. It returns season-to-date
regular-season QBR for every qualified passer in the requested `group`
(conference / division). `group = 80` is the all-FBS bucket and is the
sensible default; conference group ids (e.g. `4` ACC, `8` Big 12, `12`
SEC, `21` Big Ten) also work.

Two parameters ESPN's QBR path technically accepts are deliberately
**not** exposed, because neither carries data for college football:

- The `.../weeks/{week}/qbr/...` path returns the same season aggregate
  for every week – use
  [`espn_cfb_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats.md)
  for week-resolved passing production instead.

- The home/away game-location split (`.../qbr/1`, `.../qbr/2`) responds
  `200` but is empty for college football; only the total (`.../qbr/0`)
  is populated.

The result is wide – one row per quarterback – with the headline `qbr`
column plus the 18 component metrics ESPN derives it from. Players are
returned as ESPN athlete ids only (`athlete_id`) unless name resolution
is requested.

When `athlete_detail = TRUE` the human-readable name columns
`athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
`athlete_jersey`, `athlete_position`, and
`athlete_position_abbreviation` are appended. There is no bulk
athlete-name catalog, so resolving names here costs **one HTTP call per
quarterback** – roughly 130 extra requests for an all-FBS pull. It
therefore defaults to `FALSE`. A per-athlete fetch failure leaves that
quarterback's name columns `NA` rather than erroring the wrapper. To
resolve names without these extra calls, join `athlete_id` to another
athlete source (e.g.
[`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.md)).

## See also

Other ESPN CFB Functions:
[`espn_cfb_award()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_award.md),
[`espn_cfb_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_awards.md),
[`espn_cfb_clear_cache()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_clear_cache.md),
[`espn_cfb_coach()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach.md),
[`espn_cfb_coach_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach_record.md),
[`espn_cfb_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coaches.md),
[`espn_cfb_franchise()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchise.md),
[`espn_cfb_franchises()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchises.md),
[`espn_cfb_futures()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_futures.md),
[`espn_cfb_game_broadcasts()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_broadcasts.md),
[`espn_cfb_game_drive_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drive_plays.md),
[`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md),
[`espn_cfb_game_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_leaders.md),
[`espn_cfb_game_odds()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_odds.md),
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md),
[`espn_cfb_game_play()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_play.md),
[`espn_cfb_game_player_box()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_player_box.md),
[`espn_cfb_game_player_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_player_statistics.md),
[`espn_cfb_game_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_powerindex.md),
[`espn_cfb_game_predictor()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_predictor.md),
[`espn_cfb_game_probabilities()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_probabilities.md),
[`espn_cfb_game_situation()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_situation.md),
[`espn_cfb_game_status()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_status.md),
[`espn_cfb_game_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_leaders.md),
[`espn_cfb_game_team_linescores()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_linescores.md),
[`espn_cfb_game_team_records()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_records.md),
[`espn_cfb_game_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_roster.md),
[`espn_cfb_game_team_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_statistics.md),
[`espn_cfb_game_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_teams.md),
[`espn_cfb_groups()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_groups.md),
[`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md),
[`espn_cfb_player()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player.md),
[`espn_cfb_player_career_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_career_stats.md),
[`espn_cfb_player_eventlog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_eventlog.md),
[`espn_cfb_player_gamelog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_gamelog.md),
[`espn_cfb_player_overview()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_overview.md),
[`espn_cfb_player_seasons()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_seasons.md),
[`espn_cfb_player_splits()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_splits.md),
[`espn_cfb_player_stats_v3()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats_v3.md),
[`espn_cfb_players()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_players.md),
[`espn_cfb_position()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_position.md),
[`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md),
[`espn_cfb_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_powerindex.md),
[`espn_cfb_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_rankings.md),
[`espn_cfb_recruits()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_recruits.md),
[`espn_cfb_season_info()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_info.md),
[`espn_cfb_season_types()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_types.md),
[`espn_cfb_season_weeks()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_weeks.md),
[`espn_cfb_seasons()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_seasons.md),
[`espn_cfb_standings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_standings.md),
[`espn_cfb_team()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team.md),
[`espn_cfb_team_ats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_ats.md),
[`espn_cfb_team_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_awards.md),
[`espn_cfb_team_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_coaches.md),
[`espn_cfb_team_events()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_events.md),
[`espn_cfb_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_leaders.md),
[`espn_cfb_team_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_powerindex.md),
[`espn_cfb_team_ranks()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_ranks.md),
[`espn_cfb_team_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_record.md),
[`espn_cfb_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_roster.md),
[`espn_cfb_team_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_schedule.md),
[`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md),
[`espn_cfb_unnest_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_unnest_plays.md),
[`espn_cfb_venue()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venue.md),
[`espn_cfb_venues()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venues.md),
[`espn_cfb_week_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_week_rankings.md)

## Examples

``` r
# \donttest{
  try(espn_cfb_qbr(year = 2024))
#> ── QBR data from ESPN ──────────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 13:04:07 UTC
#> # A tibble: 129 × 26
#>    season season_type group_id athlete_id team_id  qbpaa cwepa_passes_condensed
#>     <int>       <int> <chr>    <chr>      <chr>    <dbl>                  <dbl>
#>  1   2024           2 80       102597     264      7.86                    41.7
#>  2   2024           2 80       4360480    328      4.01                    24.6
#>  3   2024           2 80       4360689    97      39.8                     61.1
#>  4   2024           2 80       4360890    326     69.0                     70.7
#>  5   2024           2 80       4362159    197     22.3                     37.5
#>  6   2024           2 80       4373895    309     48.0                     51.4
#>  7   2024           2 80       4426430    113      0.339                   17.9
#>  8   2024           2 80       4426444    189     24.2                     61.1
#>  9   2024           2 80       4426499    154      9.62                    38.5
#> 10   2024           2 80       4427238    2483    86.3                     87.0
#> # ℹ 119 more rows
#> # ℹ 19 more variables: cwepa_rushes <dbl>, cwepa_sacked_condensed <dbl>,
#> #   cwepa_penalties <dbl>, cwepa_total <dbl>, action_plays <dbl>,
#> #   cw_average <dbl>, qbr <dbl>, cwepa_passes <dbl>, cwepa_interceptions <dbl>,
#> #   cwepa_yards_after_carry <dbl>, cwepa_runs <dbl>, cwepa_scrambles <dbl>,
#> #   cwepa_sacked <dbl>, cwepa_fumbles <dbl>, avg_opp_dqbr <dbl>,
#> #   sched_adj_qbr <dbl>, unqualified_rank <dbl>, athlete_ref <chr>, …
  try(espn_cfb_qbr(year = 2024, athlete_detail = TRUE))
#> ── QBR data from ESPN ──────────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 13:04:11 UTC
#> # A tibble: 129 × 32
#>    season season_type group_id athlete_id team_id  qbpaa cwepa_passes_condensed
#>     <int>       <int> <chr>    <chr>      <chr>    <dbl>                  <dbl>
#>  1   2024           2 80       102597     264      7.86                    41.7
#>  2   2024           2 80       4360480    328      4.01                    24.6
#>  3   2024           2 80       4360689    97      39.8                     61.1
#>  4   2024           2 80       4360890    326     69.0                     70.7
#>  5   2024           2 80       4362159    197     22.3                     37.5
#>  6   2024           2 80       4373895    309     48.0                     51.4
#>  7   2024           2 80       4426430    113      0.339                   17.9
#>  8   2024           2 80       4426444    189     24.2                     61.1
#>  9   2024           2 80       4426499    154      9.62                    38.5
#> 10   2024           2 80       4427238    2483    86.3                     87.0
#> # ℹ 119 more rows
#> # ℹ 25 more variables: cwepa_rushes <dbl>, cwepa_sacked_condensed <dbl>,
#> #   cwepa_penalties <dbl>, cwepa_total <dbl>, action_plays <dbl>,
#> #   cw_average <dbl>, qbr <dbl>, cwepa_passes <dbl>, cwepa_interceptions <dbl>,
#> #   cwepa_yards_after_carry <dbl>, cwepa_runs <dbl>, cwepa_scrambles <dbl>,
#> #   cwepa_sacked <dbl>, cwepa_fumbles <dbl>, avg_opp_dqbr <dbl>,
#> #   sched_adj_qbr <dbl>, unqualified_rank <dbl>, athlete_ref <chr>, …
# }
```
