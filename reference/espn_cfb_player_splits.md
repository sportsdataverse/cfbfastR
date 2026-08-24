# **ESPN College Football Player Statistical Splits**

Get a single college football player's statistical splits for a season –
stat lines broken out by situation (by month, by quarter, by half, by
down, by field position, and more).

## Usage

``` r
espn_cfb_player_splits(athlete_id = NULL, year = NULL, athlete_detail = TRUE)
```

## Arguments

- athlete_id:

  (*Character/Integer* required): ESPN athlete id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2004

- athlete_detail:

  (*Logical*): when `TRUE` (default), fetch the requested athlete's ESPN
  record once and append the `athlete_*` name columns (see *Details*).
  Set `FALSE` to skip the fetch, reproducing the prior output exactly.

## Value

A data frame with one row per split. The leading columns are fixed; the
trailing stat columns vary by position:

|  |  |  |
|----|----|----|
| col_name | types | description |
| athlete_id | character | ESPN athlete id. |
| season | integer | Season (4-digit year). |
| category | character | Split category key (e.g. `byQuarter`, `byDown`). |
| category_display | character | Human-readable split category name. |
| split_name | character | Individual split name (e.g. `1st Quarter`). |
| split_abbr | character | Individual split abbreviation. |
| athlete_display_name | character | Player display name; `athlete_detail = TRUE` only. |
| athlete_first_name | character | Player first name; `athlete_detail = TRUE` only. |
| athlete_last_name | character | Player last name; `athlete_detail = TRUE` only. |
| athlete_jersey | character | Player jersey number; `athlete_detail = TRUE` only. |
| athlete_position | character | Player position name; `athlete_detail = TRUE` only. |
| athlete_position_abbreviation | character | Player position abbreviation; `athlete_detail = TRUE` only. |
| ... | character | One column per stat in the `names` array (varies). |

## Details

Wraps the ESPN web-v3 endpoint
`site.web.api.espn.com/apis/common/v3/sports/football/college-football/athletes/{athlete_id}/splits`.
ESPN groups splits under `splitCategories[]` (e.g. `byMonth`,
`byQuarter`, `byDown`, `byFieldPosition`); each category holds one or
more individual `splits` (e.g. the rows under `byQuarter` are
`1st Quarter`, `2nd Quarter`, ...). This wrapper returns one row per
individual split, tagged with its parent category, and joins the split's
stat values to the top-level `names` array for column names. Stat
columns vary by the player's position.

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
[`espn_cfb_player_career_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_career_stats.md),
[`espn_cfb_player_eventlog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_eventlog.md),
[`espn_cfb_player_gamelog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_gamelog.md),
[`espn_cfb_player_overview()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_overview.md),
[`espn_cfb_player_seasons()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_seasons.md),
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
  try(espn_cfb_player_splits(athlete_id = 102597, year = 2024))
#> ── Player statistical splits from ESPN ─────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 14:47:39 UTC
#> # A tibble: 60 × 27
#>    athlete_id season category category_display split_name split_abbr completions
#>    <chr>       <int> <chr>    <chr>            <chr>      <chr>      <chr>      
#>  1 102597       2024 split    split            Season     Season     220        
#>  2 102597       2024 split    split            Home       Home       143        
#>  3 102597       2024 split    split            Away       Away       77         
#>  4 102597       2024 byMonth  Month            September  Sept       90         
#>  5 102597       2024 byMonth  Month            October    Oct        62         
#>  6 102597       2024 byMonth  Month            November   Nov        48         
#>  7 102597       2024 byQuart… Quarter          1st        1st Qtr    66         
#>  8 102597       2024 byQuart… Quarter          2nd        2nd Qtr    66         
#>  9 102597       2024 byQuart… Quarter          3rd        3rd Qtr    49         
#> 10 102597       2024 byQuart… Quarter          4th        4th Qtr    39         
#> # ℹ 50 more rows
#> # ℹ 20 more variables: passing_attempts <chr>, passing_yards <chr>,
#> #   completion_pct <chr>, yards_per_pass_attempt <chr>,
#> #   passing_touchdowns <chr>, interceptions <chr>, long_passing <chr>,
#> #   sacks <chr>, qb_rating <chr>, rushing_attempts <chr>, rushing_yards <chr>,
#> #   yards_per_rush_attempt <chr>, rushing_touchdowns <chr>, long_rushing <chr>,
#> #   athlete_display_name <chr>, athlete_first_name <chr>, …
  try(espn_cfb_player_splits(athlete_id = 102597, year = 2024,
                             athlete_detail = FALSE))
#> ── Player statistical splits from ESPN ─────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 14:47:39 UTC
#> # A tibble: 60 × 21
#>    athlete_id season category category_display split_name split_abbr completions
#>    <chr>       <int> <chr>    <chr>            <chr>      <chr>      <chr>      
#>  1 102597       2024 split    split            Season     Season     220        
#>  2 102597       2024 split    split            Home       Home       143        
#>  3 102597       2024 split    split            Away       Away       77         
#>  4 102597       2024 byMonth  Month            September  Sept       90         
#>  5 102597       2024 byMonth  Month            October    Oct        62         
#>  6 102597       2024 byMonth  Month            November   Nov        48         
#>  7 102597       2024 byQuart… Quarter          1st        1st Qtr    66         
#>  8 102597       2024 byQuart… Quarter          2nd        2nd Qtr    66         
#>  9 102597       2024 byQuart… Quarter          3rd        3rd Qtr    49         
#> 10 102597       2024 byQuart… Quarter          4th        4th Qtr    39         
#> # ℹ 50 more rows
#> # ℹ 14 more variables: passing_attempts <chr>, passing_yards <chr>,
#> #   completion_pct <chr>, yards_per_pass_attempt <chr>,
#> #   passing_touchdowns <chr>, interceptions <chr>, long_passing <chr>,
#> #   sacks <chr>, qb_rating <chr>, rushing_attempts <chr>, rushing_yards <chr>,
#> #   yards_per_rush_attempt <chr>, rushing_touchdowns <chr>, long_rushing <chr>
# }
```
