# **ESPN College Football Recruits**

Get the ESPN recruiting-class catalog for a college football signing
class – one row per recruit, with athlete identity, position, physical
measurements, ESPN grade, the overall / position / state / region
rankings, the committed school, and the recruit's hometown and high
school.

## Usage

``` r
espn_cfb_recruits(year = NULL, max_results = 100)
```

## Arguments

- year:

  (*Integer* required): Recruiting class / signing year, 4 digit format
  (*YYYY*).

- max_results:

  (*Integer* default 100): Maximum number of recruits to dereference and
  return. The index is alphabetical, so this returns the
  alphabetically-first `max_results` recruits; raise it to pull more of
  the class.

## Value

A data frame with one row per recruit:

|  |  |  |
|----|----|----|
| col_name | types | description |
| recruit_id | character | ESPN recruit id. |
| recruiting_class | integer | Recruiting class / signing year. |
| athlete_id | character | ESPN athlete id. |
| alternate_athlete_id | character | ESPN alternate athlete id (recruiting feed id). |
| first_name | character | Recruit first name. |
| last_name | character | Recruit last name. |
| full_name | character | Recruit full name. |
| display_name | character | Recruit display name. |
| short_name | character | Recruit short name. |
| position_id | character | ESPN position id. |
| position_abbreviation | character | Position abbreviation (e.g. `OT`, `WR`). |
| weight | numeric | Listed weight (lbs). |
| height | numeric | Listed height (inches). |
| grade | numeric | ESPN recruit grade (0-100; `0` = not rated). |
| grade_display_value | character | Display-formatted grade (`NR` when not rated). |
| overall_rank | integer | Overall recruit ranking (top recruits only; may be `NA`). |
| position_rank | integer | Position ranking. |
| state_rank | integer | State ranking. |
| region_rank | integer | Region ranking. |
| status_id | character | ESPN commitment status id. |
| status | character | Commitment status description (e.g. `Signed`). |
| committed_team_id | character | ESPN team id of the committed school (may be `NA`). |
| hometown_city | character | Recruit hometown city. |
| hometown_state | character | Recruit hometown state. |
| hometown_state_abbreviation | character | Recruit hometown state abbreviation. |
| high_school_id | character | ESPN high-school id. |
| high_school_name | character | Recruit high-school name. |
| recruit_ref | character | `$ref` URL to the recruit resource. |
| athlete_ref | character | Player-card URL for the recruit. |
| committed_team_ref | character | `$ref` URL to the committed team-in-season resource. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/recruits`.
The season index is `$ref`-paginated and large (roughly 3,700-4,900
recruits per class), so dereferencing every recruit would be thousands
of HTTP calls. ESPN exposes no pre-expanded recruiting endpoint – the
`site.web.api.espn.com` recruiting paths all 404 – so this wrapper caps
the walk at `max_results` recruits (default 100). Raise `max_results`
(e.g. to several hundred or higher) to pull more of the class, at the
cost of one extra HTTP call per recruit.

The index is returned by ESPN in athlete-name (alphabetical) order, not
ranking order, and the `sort` query parameter is ignored upstream. The
default `max_results = 100` therefore returns the alphabetically-first
100 recruits, not the top-100 ranked recruits. To rank the class, pull a
larger slice and sort the result on `overall_rank` (lower is better);
note ESPN only publishes an `overall_rank` for the highly-rated portion
of each class, so most recruits carry `NA` there. `position_rank`,
`state_rank`, and `region_rank` are populated more widely. `grade` is
ESPN's 0-100 recruit grade (`0` / `gradeDisplayValue = "NR"` means not
rated).

`committed_team_id` / `committed_team_ref` are resolved from the
recruit's `schools` array by matching a school whose commitment status
equals the recruit's top-level status (e.g. `Signed`); recruits still
uncommitted at fetch time leave both columns `NA`.

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
[`espn_cfb_qbr()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_qbr.md),
[`espn_cfb_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_rankings.md),
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
  try(espn_cfb_recruits(year = 2024, max_results = 25))
#> ── Recruiting class data from ESPN ─────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 12:30:23 UTC
#> # A tibble: 25 × 31
#>    season recruit_id recruiting_class athlete_id alternate_athlete_id first_name
#>     <dbl> <chr>                 <int> <chr>      <chr>                <chr>     
#>  1   2024 255473                 2024 255473     5146775              David     
#>  2   2024 254466                 2024 254466     5138455              Jide      
#>  3   2024 257502                 2024 257502     NA                   Papa      
#>  4   2024 258479                 2024 258479     NA                   Na'eem    
#>  5   2024 257649                 2024 257649     NA                   Omari     
#>  6   2024 254482                 2024 254482     5138702              Adham     
#>  7   2024 250916                 2024 250916     5079289              Tawaski   
#>  8   2024 257098                 2024 257098     5173623              Frank     
#>  9   2024 258339                 2024 258339     NA                   Collins   
#> 10   2024 255259                 2024 255259     5145820              Cooper    
#> # ℹ 15 more rows
#> # ℹ 25 more variables: last_name <chr>, full_name <chr>, display_name <chr>,
#> #   short_name <chr>, position_id <chr>, position_abbreviation <chr>,
#> #   weight <dbl>, height <dbl>, grade <dbl>, grade_display_value <chr>,
#> #   overall_rank <int>, position_rank <int>, state_rank <int>,
#> #   region_rank <int>, status_id <chr>, status <chr>, committed_team_id <chr>,
#> #   hometown_city <chr>, hometown_state <chr>, …
# }
```
