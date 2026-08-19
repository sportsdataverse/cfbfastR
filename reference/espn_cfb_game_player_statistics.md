# **ESPN College Football Game Player Statistics (Single Athlete)**

Get one athlete's box-score line for a single college football game –
one row per stat, in long format.

## Usage

``` r
espn_cfb_game_player_statistics(
  game_id = NULL,
  athlete_id = NULL,
  position_detail = TRUE,
  team_detail = TRUE
)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- athlete_id:

  (*Integer* required): ESPN athlete id (from
  [`espn_cfb_game_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_leaders.md)
  or a roster wrapper).

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

A data frame with one row per stat for the athlete:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| athlete_id | character | ESPN athlete id. |
| team_id | character | ESPN team id of the athlete's team (competitor id). |
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
| athlete_display_name | character | Athlete display name (from the roster entry). |
| jersey | character | Athlete jersey number (from the roster entry). |
| starter | logical | `TRUE` if the athlete started the game. |
| did_not_play | logical | `TRUE` if the athlete did not play. |
| position_id | character | ESPN position id (from the roster entry; `NA` if none). |
| category_name | character | Stat-category key (e.g. `passing`, `rushing`). |
| category_display_name | character | Human-readable stat-category name. |
| category_short_display_name | character | Short human-readable stat-category name. |
| category_summary | character | ESPN's summary string for the category. |
| stat_name | character | Stat key (e.g. `completions`, `rushingYards`). |
| stat_display_name | character | Human-readable stat name. |
| stat_short_display_name | character | Short human-readable stat name. |
| abbreviation | character | Stat abbreviation. |
| value | numeric | Numeric stat value. |
| display_value | character | Display-formatted stat value. |
| description | character | ESPN's description of the stat. |
| position_name | character | Position name (e.g. `Quarterback`); `position_detail = TRUE` only. |
| position_display_name | character | Human-readable position name; `position_detail = TRUE` only. |
| position_abbreviation | character | Position abbreviation (e.g. `QB`); `position_detail = TRUE` only. |
| position_leaf | logical | `TRUE` for a most-specific (leaf) position; `position_detail = TRUE` only. |
| position_parent_id | character | ESPN id of the parent position; `position_detail = TRUE` only. |

## Details

Wraps the ESPN core-v2 per-game, per-player statistics resource
`events/{game_id}/competitions/{game_id}/competitors/{t}/roster/{a}/statistics/{s}`.
The competition id always equals the game id.

ESPN reaches per-player game stats through the competitor roster tree –
dereferencing all ~250 athletes on the two rosters per game is
impractical, so this wrapper is **scoped to one athlete**. It fetches
the two competitor rosters, finds the entry whose `athlete_id` matches
the supplied `athlete_id`, follows that athlete's `statistics` `$ref`,
and returns that player's stat line in long format – one row per stat,
with the stat category, name, value, and display value.

For a full all-players game box score, the **site-v2 game-summary feed
is the better source** – it returns every player's box line in one call.
Use this core-v2 wrapper when you need a single athlete's stats in the
core-v2 id space, e.g. drilling down from
[`espn_cfb_game_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_leaders.md).

If the athlete is not found on either roster, or did not record stats
for the game (no `statistics` `$ref`), an empty data frame is returned.

When `position_detail = TRUE` (the default) the ESPN position catalog
([`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md))
is fetched once and joined onto the athlete's `position_id`, so the
output carries the full position name / abbreviation (see *Details*).

When `position_detail = TRUE` (the default), the athlete's `position_id`
(read from the roster entry) is enriched with five columns from the ESPN
position catalog
([`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md)):
`position_name`, `position_display_name`, `position_abbreviation`,
`position_leaf`, and `position_parent_id`. The catalog is fetched once
per call. If the athlete carries no `position_id` or it is unmatched,
all five are `NA`, and a catalog-fetch failure degrades the whole set to
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
[`espn_cfb_game_player_box()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_player_box.md),
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
  try(espn_cfb_game_player_statistics(game_id = 401628339,
                                      athlete_id = 4429105))
#> ── Game player statistics data from ESPN ───────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 17:58:10 UTC
#> # A tibble: 141 × 34
#>    game_id   athlete_id team_id team_name team_abbreviation team_location
#>    <chr>     <chr>      <chr>   <chr>     <chr>             <chr>        
#>  1 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  2 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  3 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  4 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  5 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  6 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  7 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  8 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  9 401628339 4429105    61      Bulldogs  UGA               Georgia      
#> 10 401628339 4429105    61      Bulldogs  UGA               Georgia      
#> # ℹ 131 more rows
#> # ℹ 28 more variables: team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>,
#> #   athlete_display_name <chr>, jersey <chr>, starter <lgl>,
#> #   did_not_play <lgl>, position_id <chr>, category_name <chr>,
#> #   category_display_name <chr>, category_short_display_name <chr>, …
  try(espn_cfb_game_player_statistics(game_id = 401628339,
                                      athlete_id = 4429105,
                                      position_detail = FALSE))
#> ── Game player statistics data from ESPN ───────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 17:58:10 UTC
#> # A tibble: 141 × 29
#>    game_id   athlete_id team_id team_name team_abbreviation team_location
#>    <chr>     <chr>      <chr>   <chr>     <chr>             <chr>        
#>  1 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  2 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  3 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  4 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  5 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  6 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  7 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  8 401628339 4429105    61      Bulldogs  UGA               Georgia      
#>  9 401628339 4429105    61      Bulldogs  UGA               Georgia      
#> 10 401628339 4429105    61      Bulldogs  UGA               Georgia      
#> # ℹ 131 more rows
#> # ℹ 23 more variables: team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>,
#> #   athlete_display_name <chr>, jersey <chr>, starter <lgl>,
#> #   did_not_play <lgl>, position_id <chr>, category_name <chr>,
#> #   category_display_name <chr>, category_short_display_name <chr>, …
  try(espn_cfb_game_player_statistics(game_id = 401628339,
                                      athlete_id = 4429105,
                                      team_detail = FALSE))
#> ── Game player statistics data from ESPN ───────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 17:58:11 UTC
#> # A tibble: 141 × 24
#>    game_id   athlete_id team_id athlete_display_name jersey starter did_not_play
#>    <chr>     <chr>      <chr>   <chr>                <chr>  <lgl>   <lgl>       
#>  1 401628339 4429105    61      A. Smith             11     FALSE   FALSE       
#>  2 401628339 4429105    61      A. Smith             11     FALSE   FALSE       
#>  3 401628339 4429105    61      A. Smith             11     FALSE   FALSE       
#>  4 401628339 4429105    61      A. Smith             11     FALSE   FALSE       
#>  5 401628339 4429105    61      A. Smith             11     FALSE   FALSE       
#>  6 401628339 4429105    61      A. Smith             11     FALSE   FALSE       
#>  7 401628339 4429105    61      A. Smith             11     FALSE   FALSE       
#>  8 401628339 4429105    61      A. Smith             11     FALSE   FALSE       
#>  9 401628339 4429105    61      A. Smith             11     FALSE   FALSE       
#> 10 401628339 4429105    61      A. Smith             11     FALSE   FALSE       
#> # ℹ 131 more rows
#> # ℹ 17 more variables: position_id <chr>, category_name <chr>,
#> #   category_display_name <chr>, category_short_display_name <chr>,
#> #   category_summary <chr>, stat_name <chr>, stat_display_name <chr>,
#> #   stat_short_display_name <chr>, abbreviation <chr>, value <dbl>,
#> #   display_value <chr>, description <chr>, position_name <chr>,
#> #   position_display_name <chr>, position_abbreviation <chr>, …
# }
```
