# **ESPN College Football Game Player Box Score**

Get the full per-player box score for both teams in a single college
football game – one row per (team x athlete x category x stat), in long
format.

## Usage

``` r
espn_cfb_game_player_box(
  game_id = NULL,
  position_detail = TRUE,
  team_detail = TRUE
)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- position_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN position catalog
  once and join it onto `position_id`, appending the five `position_*`
  detail columns shown in the *Value* table. A catalog failure degrades
  to `NA` rather than erroring the wrapper. Set `FALSE` to skip the
  extra fetch and the join.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog
  ([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
  once and join friendly team fields next to the `team_id` column –
  `team_name`, `team_abbreviation`, `team_location`,
  `team_display_name`, `team_short_display_name`, `team_nickname`,
  `team_color`, `team_alternate_color`, `team_logo_href`, and
  `team_logo_dark_href`, inserted immediately after `team_id`. A catalog
  failure degrades to `NA` rather than erroring the wrapper. Set `FALSE`
  to skip the catalog fetch and the join.

## Value

A data frame with one row per team-athlete-category-stat:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| team_id | character | ESPN team id (competitor id) for the team. |
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
| home_away | character | `home` or `away`. |
| athlete_id | character | ESPN athlete id (parsed from the athlete `$ref`). |
| athlete_name | character | Athlete display name (roster-joined). |
| position_id | character | ESPN position id (roster-joined; `NA` if unmatched). |
| category_name | character | Stat category key (e.g. `passing`, `rushing`). |
| category_display | character | Human-readable category name. |
| category_short_display | character | Short human-readable category name. |
| category_summary | character | ESPN's summary string for the category. |
| stat_name | character | Internal stat key (e.g. `passingYards`). |
| abbreviation | character | Stat abbreviation. |
| display_name | character | Human-readable stat name. |
| short_display_name | character | Short human-readable stat name. |
| description | character | ESPN's description of the stat. |
| value | numeric | Stat value. |
| display_value | character | Display-formatted stat value as shown on ESPN. |
| statistics_ref | character | `$ref` URL to the athlete's game-statistics resource. |
| position_name | character | Position name (e.g. `Quarterback`); `position_detail = TRUE` only. |
| position_display_name | character | Human-readable position name; `position_detail = TRUE` only. |
| position_abbreviation | character | Position abbreviation (e.g. `QB`); `position_detail = TRUE` only. |
| position_leaf | logical | `TRUE` for a most-specific (leaf) position; `position_detail = TRUE` only. |
| position_parent_id | character | ESPN id of the parent position; `position_detail = TRUE` only. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/competitors/{team_id}/statistics`.
This wrapper reads the teams list for the game, fetches the team
statistics resource for **both** teams, and walks the per-category
`splits -> categories -> athletes` arrays – the per-player box-score
tree that the team-level
[`espn_cfb_game_team_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_statistics.md)
wrapper (which walks `categories -> stats`) drops entirely.

Each athlete entry under a category carries only a `$ref` to that
athlete's per-game statistics resource; this wrapper dereferences each
unique athlete statistics `$ref` and flattens the nested
`splits -> categories -> stats` tree into one long frame: one row per
(team x athlete x category x stat). Athlete display names and position
ids are joined from
[`espn_cfb_game_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_roster.md);
a roster failure degrades to `NA` names rather than erroring. The long
shape absorbs ESPN's habit of adding and retiring stat keys across
seasons.

When `position_detail = TRUE` (the default) the ESPN position catalog
([`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md))
is fetched once and joined onto `position_id`, so the output carries the
full position name / abbreviation (see *Details*).

When `position_detail = TRUE` (the default), the `position_id` column
(roster-joined per athlete) is enriched with five columns from the ESPN
position catalog
([`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md)):
`position_name`, `position_display_name`, `position_abbreviation`,
`position_leaf`, and `position_parent_id`. The catalog is fetched once
per call. A row whose `position_id` is missing or unmatched receives
`NA` for all five, and a catalog-fetch failure degrades the whole set to
`NA` rather than erroring the wrapper. With `position_detail = FALSE`
the five columns (and the catalog fetch) are skipped.

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
  try(espn_cfb_game_player_box(game_id = 401628339))
#> ── Game player box score data from ESPN ────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 17:57:48 UTC
#> # A tibble: 6,083 × 33
#>    game_id   team_id team_name team_abbreviation team_location team_display_name
#>    <chr>     <chr>   <chr>     <chr>             <chr>         <chr>            
#>  1 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  2 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  3 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  4 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  5 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  6 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  7 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  8 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  9 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 10 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 6,073 more rows
#> # ℹ 27 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, home_away <chr>, athlete_id <chr>,
#> #   athlete_name <chr>, position_id <chr>, category_name <chr>,
#> #   category_display <chr>, category_short_display <chr>,
#> #   category_summary <chr>, stat_name <chr>, abbreviation <chr>, …
  try(espn_cfb_game_player_box(game_id = 401628339,
                               position_detail = FALSE))
#> ── Game player box score data from ESPN ────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 17:57:58 UTC
#> # A tibble: 6,083 × 28
#>    game_id   team_id team_name team_abbreviation team_location team_display_name
#>    <chr>     <chr>   <chr>     <chr>             <chr>         <chr>            
#>  1 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  2 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  3 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  4 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  5 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  6 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  7 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  8 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  9 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 10 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 6,073 more rows
#> # ℹ 22 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, home_away <chr>, athlete_id <chr>,
#> #   athlete_name <chr>, position_id <chr>, category_name <chr>,
#> #   category_display <chr>, category_short_display <chr>,
#> #   category_summary <chr>, stat_name <chr>, abbreviation <chr>, …
  try(espn_cfb_game_player_box(game_id = 401628339,
                               team_detail = FALSE))
#> ── Game player box score data from ESPN ────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 17:58:09 UTC
#> # A tibble: 6,083 × 23
#>    game_id   team_id home_away athlete_id athlete_name position_id category_name
#>    <chr>     <chr>   <chr>     <chr>      <chr>        <chr>       <chr>        
#>  1 401628339 61      home      4429105    A. Smith     1           general      
#>  2 401628339 61      home      4429105    A. Smith     1           general      
#>  3 401628339 61      home      4429105    A. Smith     1           general      
#>  4 401628339 61      home      4429105    A. Smith     1           general      
#>  5 401628339 61      home      4429105    A. Smith     1           general      
#>  6 401628339 61      home      4429105    A. Smith     1           general      
#>  7 401628339 61      home      4429105    A. Smith     1           general      
#>  8 401628339 61      home      4429105    A. Smith     1           passing      
#>  9 401628339 61      home      4429105    A. Smith     1           passing      
#> 10 401628339 61      home      4429105    A. Smith     1           passing      
#> # ℹ 6,073 more rows
#> # ℹ 16 more variables: category_display <chr>, category_short_display <chr>,
#> #   category_summary <chr>, stat_name <chr>, abbreviation <chr>,
#> #   display_name <chr>, short_display_name <chr>, description <chr>,
#> #   value <dbl>, display_value <chr>, statistics_ref <chr>,
#> #   position_name <chr>, position_display_name <chr>,
#> #   position_abbreviation <chr>, position_leaf <lgl>, …
# }
```
