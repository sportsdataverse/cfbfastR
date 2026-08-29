# **ESPN College Football Player Game Log**

Get a single college football player's game-by-game statistical log for
a season – one row per game, with the player's stat line joined to
opponent, score, and result metadata.

## Usage

``` r
espn_cfb_player_gamelog(
  athlete_id = NULL,
  year = NULL,
  team_detail = TRUE,
  athlete_detail = TRUE
)
```

## Arguments

- athlete_id:

  (*Character/Integer* required): ESPN athlete id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2004

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

- athlete_detail:

  (*Logical*): when `TRUE` (default), fetch the requested athlete's ESPN
  record once and append the `athlete_*` name columns (see *Details*).
  Set `FALSE` to skip the fetch, reproducing the prior output exactly.

## Value

A data frame with one row per game. The leading columns are fixed; the
trailing stat columns vary by position:

|  |  |  |
|----|----|----|
| col_name | types | description |
| athlete_id | character | ESPN athlete id. |
| season | integer | Season (4-digit year). |
| season_type | character | Season-type label (e.g. `2024 Regular Season`). |
| game_id | character | ESPN event (game) id. |
| game_date | character | Game date (ISO 8601). |
| week | integer | Week number. |
| at_vs | character | `vs` (home) or `@` (away). |
| opponent_id | character | ESPN team id of the opponent. |
| opponent_name | character | Opponent display name. |
| opponent_abbr | character | Opponent abbreviation. |
| team_id | character | ESPN team id the player played for. |
| team_name | character | Team nickname; `team_detail = TRUE` only. |
| team_abbreviation | character | Team abbreviation; `team_detail = TRUE` only. |
| team_location | character | Team location / school name; `team_detail = TRUE` only. |
| team_display_name | character | Full team display name; `team_detail = TRUE` only. |
| team_short_display_name | character | Short team display name; `team_detail = TRUE` only. |
| team_nickname | character | Team nickname label; `team_detail = TRUE` only. |
| team_color | character | Primary team color; `team_detail = TRUE` only. |
| team_alternate_color | character | Alternate team color; `team_detail = TRUE` only. |
| team_logo_href | character | Default team logo URL; `team_detail = TRUE` only. |
| team_logo_dark_href | character | Dark-variant team logo URL; `team_detail = TRUE` only. |
| home_team_score | character | Home team final score. |
| away_team_score | character | Away team final score. |
| game_result | character | Game result for the player's team (`W`/`L`). |
| score | character | Final score string. |
| athlete_display_name | character | Player display name; `athlete_detail = TRUE` only. |
| athlete_first_name | character | Player first name; `athlete_detail = TRUE` only. |
| athlete_last_name | character | Player last name; `athlete_detail = TRUE` only. |
| athlete_jersey | character | Player jersey number; `athlete_detail = TRUE` only. |
| athlete_position | character | Player position name; `athlete_detail = TRUE` only. |
| athlete_position_abbreviation | character | Player position abbreviation; `athlete_detail = TRUE` only. |
| ... | character | One column per stat in the `names` array (varies). |

## Details

Wraps the ESPN web-v3 endpoint
`site.web.api.espn.com/apis/common/v3/sports/football/college-football/athletes/{athlete_id}/gamelog`.
Unlike the core-v2
[`espn_cfb_player_eventlog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_eventlog.md)
(which returns only `$ref` URLs), this endpoint ships fully-resolved
per-game stat lines. The wrapper joins three blocks of the payload: the
`events` map (game metadata – opponent, date, score, result), the
`seasonTypes` -\> `categories` -\> `events` block (the per-game stat
values), and the top-level `labels` / `names` arrays (the stat column
names). Stat columns are named from the `names` array (e.g.
`completions`, `passing_yards`); they vary by the player's position. If
the player did not play in the requested season ESPN returns only a
`filters` object and this wrapper returns an empty data frame.

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to the
`team_id` column – `team_name`, `team_abbreviation`, `team_location`,
`team_display_name`, `team_short_display_name`, `team_nickname`,
`team_color`, `team_alternate_color`, `team_logo_href`, and
`team_logo_dark_href`, inserted immediately after `team_id`. A catalog
failure degrades to `NA` rather than erroring the wrapper. Set
`team_detail = FALSE` to skip the catalog fetch and the join.

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
  try(espn_cfb_player_gamelog(athlete_id = 102597, year = 2024))
#> ── Player game log from ESPN ──────────────────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-08-29 13:14:48 UTC
#> # A tibble: 11 × 46
#>    athlete_id season season_type       game_id game_date  week at_vs opponent_id
#>    <chr>       <int> <chr>             <chr>   <chr>     <int> <chr> <chr>      
#>  1 102597       2024 2024 Regular Sea… 401628… 2024-11-…    12 vs    26         
#>  2 102597       2024 2024 Regular Sea… 401628… 2024-11-…    11 @     213        
#>  3 102597       2024 2024 Regular Sea… 401628… 2024-11-…    10 vs    30         
#>  4 102597       2024 2024 Regular Sea… 401628… 2024-10-…     9 @     84         
#>  5 102597       2024 2024 Regular Sea… 401628… 2024-10-…     7 @     2294       
#>  6 102597       2024 2024 Regular Sea… 401628… 2024-10-…     6 vs    130        
#>  7 102597       2024 2024 Regular Sea… 401628… 2024-09-…     5 @     164        
#>  8 102597       2024 2024 Regular Sea… 401628… 2024-09-…     4 vs    77         
#>  9 102597       2024 2024 Regular Sea… 401628… 2024-09-…     3 vs    265        
#> 10 102597       2024 2024 Regular Sea… 401628… 2024-09-…     2 vs    2199       
#> 11 102597       2024 2024 Regular Sea… 401628… 2024-09-…     1 vs    2692       
#> # ℹ 38 more variables: opponent_name <chr>, opponent_abbr <chr>, team_id <chr>,
#> #   team_name <chr>, team_abbreviation <chr>, team_location <chr>,
#> #   team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, home_team_score <chr>,
#> #   away_team_score <chr>, game_result <chr>, score <chr>, completions <chr>,
#> #   passing_attempts <chr>, passing_yards <chr>, completion_pct <chr>, …
  try(espn_cfb_player_gamelog(athlete_id = 102597, year = 2024,
                              team_detail = FALSE,
                              athlete_detail = FALSE))
#> ── Player game log from ESPN ──────────────────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-08-29 13:14:48 UTC
#> # A tibble: 11 × 30
#>    athlete_id season season_type       game_id game_date  week at_vs opponent_id
#>    <chr>       <int> <chr>             <chr>   <chr>     <int> <chr> <chr>      
#>  1 102597       2024 2024 Regular Sea… 401628… 2024-11-…    12 vs    26         
#>  2 102597       2024 2024 Regular Sea… 401628… 2024-11-…    11 @     213        
#>  3 102597       2024 2024 Regular Sea… 401628… 2024-11-…    10 vs    30         
#>  4 102597       2024 2024 Regular Sea… 401628… 2024-10-…     9 @     84         
#>  5 102597       2024 2024 Regular Sea… 401628… 2024-10-…     7 @     2294       
#>  6 102597       2024 2024 Regular Sea… 401628… 2024-10-…     6 vs    130        
#>  7 102597       2024 2024 Regular Sea… 401628… 2024-09-…     5 @     164        
#>  8 102597       2024 2024 Regular Sea… 401628… 2024-09-…     4 vs    77         
#>  9 102597       2024 2024 Regular Sea… 401628… 2024-09-…     3 vs    265        
#> 10 102597       2024 2024 Regular Sea… 401628… 2024-09-…     2 vs    2199       
#> 11 102597       2024 2024 Regular Sea… 401628… 2024-09-…     1 vs    2692       
#> # ℹ 22 more variables: opponent_name <chr>, opponent_abbr <chr>, team_id <chr>,
#> #   home_team_score <chr>, away_team_score <chr>, game_result <chr>,
#> #   score <chr>, completions <chr>, passing_attempts <chr>,
#> #   passing_yards <chr>, completion_pct <chr>, passing_touchdowns <chr>,
#> #   interceptions <chr>, long_passing <chr>, sacks <chr>, qb_rating <chr>,
#> #   adj_qbr <chr>, rushing_attempts <chr>, rushing_yards <chr>,
#> #   yards_per_rush_attempt <chr>, rushing_touchdowns <chr>, …
# }
```
