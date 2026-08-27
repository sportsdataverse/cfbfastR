# **ESPN College Football Player Season Statistics (Long Format)**

Get a single college football player's full season statistics from ESPN
– every published stat across every category, in long format (one row
per stat).

## Usage

``` r
espn_cfb_player_career_stats(
  athlete_id = NULL,
  year = NULL,
  season_type = 2,
  athlete_detail = TRUE
)
```

## Arguments

- athlete_id:

  (*Character/Integer* required): ESPN athlete id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2004

- season_type:

  (*Integer* optional, default 2): ESPN season type. `2` = regular
  season, `3` = postseason.

- athlete_detail:

  (*Logical*): when `TRUE` (default), fetch the requested athlete's ESPN
  record once and append the `athlete_*` name columns (see *Details*).
  Set `FALSE` to skip the fetch, reproducing the prior output exactly.

## Value

A data frame with one row per stat:

|  |  |  |
|----|----|----|
| col_name | types | description |
| athlete_id | character | ESPN athlete id. |
| season | integer | Season (4-digit year). |
| season_type | integer | ESPN season type (2 = regular, 3 = postseason). |
| category | character | Stat category (e.g. `passing`, `rushing`). |
| category_display | character | Human-readable category name. |
| stat_name | character | Internal stat key (e.g. `passingYards`). |
| display_name | character | Human-readable stat name. |
| abbreviation | character | Stat abbreviation. |
| description | character | ESPN's description of the stat. |
| value | numeric | Season-total value of the stat. |
| display_value | character | Display-formatted season-total value. |
| per_game_value | numeric | Per-game value of the stat. |
| per_game_display_value | character | Display-formatted per-game value. |
| athlete_display_name | character | Player display name; `athlete_detail = TRUE` only. |
| athlete_first_name | character | Player first name; `athlete_detail = TRUE` only. |
| athlete_last_name | character | Player last name; `athlete_detail = TRUE` only. |
| athlete_jersey | character | Player jersey number; `athlete_detail = TRUE` only. |
| athlete_position | character | Player position name; `athlete_detail = TRUE` only. |
| athlete_position_abbreviation | character | Player position abbreviation; `athlete_detail = TRUE` only. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/athletes/{athlete_id}/statistics`.
ESPN nests a player's season stats under
`splits -> categories[] -> stats[]`; this wrapper flattens that tree to
long format – each row is one stat, tagged with its `category` (e.g.
`passing`, `rushing`, `defensive`). The long shape is deliberate: ESPN
adds and retires stats and whole categories across positions and
seasons, and a long frame absorbs that drift without breaking column
expectations. Pivot wider with
[`tidyr::pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
keyed on `stat_name` for a wide table. Each stat carries both a
season-total value (`value`) and a per-game value (`per_game_value`).

When `athlete_detail = TRUE` (the default) the requested athlete's ESPN
record is fetched once and the human-readable name columns
`athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
`athlete_jersey`, `athlete_position`, and
`athlete_position_abbreviation` are appended to every row. This is a
single cheap fetch – the wrapper already takes one `athlete_id`. A fetch
failure degrades the name columns to `NA` rather than erroring the
wrapper. Set `athlete_detail = FALSE` to skip the fetch and reproduce
the prior output exactly.

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
  try(espn_cfb_player_career_stats(athlete_id = 102597, year = 2024))
#> ── Player season statistics from ESPN ──────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 11:50:10 UTC
#> # A tibble: 163 × 19
#>    athlete_id season season_type category category_display stat_name            
#>    <chr>       <int>       <int> <chr>    <chr>            <chr>                
#>  1 102597       2024           2 general  General          fumbles              
#>  2 102597       2024           2 general  General          fumblesLost          
#>  3 102597       2024           2 general  General          fumblesForced        
#>  4 102597       2024           2 general  General          defensiveFumblesForc…
#>  5 102597       2024           2 general  General          miscFumblesForced    
#>  6 102597       2024           2 general  General          specialTeamsFumblesF…
#>  7 102597       2024           2 general  General          fumblesRecovered     
#>  8 102597       2024           2 general  General          fumblesRecoveredYards
#>  9 102597       2024           2 general  General          fumblesTouchdowns    
#> 10 102597       2024           2 general  General          gamesPlayed          
#> # ℹ 153 more rows
#> # ℹ 13 more variables: display_name <chr>, abbreviation <chr>,
#> #   description <chr>, value <dbl>, display_value <chr>, per_game_value <dbl>,
#> #   per_game_display_value <chr>, athlete_display_name <chr>,
#> #   athlete_first_name <chr>, athlete_last_name <chr>, athlete_jersey <chr>,
#> #   athlete_position <chr>, athlete_position_abbreviation <chr>
  try(espn_cfb_player_career_stats(athlete_id = 102597, year = 2024,
                                 athlete_detail = FALSE))
#> ── Player season statistics from ESPN ──────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 11:50:10 UTC
#> # A tibble: 163 × 13
#>    athlete_id season season_type category category_display stat_name            
#>    <chr>       <int>       <int> <chr>    <chr>            <chr>                
#>  1 102597       2024           2 general  General          fumbles              
#>  2 102597       2024           2 general  General          fumblesLost          
#>  3 102597       2024           2 general  General          fumblesForced        
#>  4 102597       2024           2 general  General          defensiveFumblesForc…
#>  5 102597       2024           2 general  General          miscFumblesForced    
#>  6 102597       2024           2 general  General          specialTeamsFumblesF…
#>  7 102597       2024           2 general  General          fumblesRecovered     
#>  8 102597       2024           2 general  General          fumblesRecoveredYards
#>  9 102597       2024           2 general  General          fumblesTouchdowns    
#> 10 102597       2024           2 general  General          gamesPlayed          
#> # ℹ 153 more rows
#> # ℹ 7 more variables: display_name <chr>, abbreviation <chr>,
#> #   description <chr>, value <dbl>, display_value <chr>, per_game_value <dbl>,
#> #   per_game_display_value <chr>
# }
```
