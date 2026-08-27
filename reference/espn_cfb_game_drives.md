# **ESPN College Football Game Drives**

Get the per-game drive log for a single college football game – one row
per drive, with start/end field position, yardage, play count, result,
and a `$ref` to that drive's plays. Optionally embed each drive's
full-schema play-by-play as a nested list-column or as a flat
one-row-per-play table.

## Usage

``` r
espn_cfb_game_drives(
  game_id = NULL,
  plays = c("none", "list", "expand"),
  participants = c("none", "wide", "long"),
  participants_list = FALSE,
  team_participants = c("none", "wide"),
  team_participants_list = FALSE,
  position_detail = TRUE,
  team_detail = TRUE
)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- plays:

  (*Character*): controls whether each drive's plays are embedded. One
  of `"none"` (default), `"list"`, or `"expand"` – see *Details*.

- participants:

  (*Character*): participant-flattening mode for the embedded plays –
  one of `"none"` (default), `"wide"`, or `"long"`. Consulted only when
  `plays != "none"`. See
  [`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md).

- participants_list:

  (*Logical*): when `TRUE`, append the `participants` list-column to
  each embedded play. Defaults to `FALSE`. Consulted only when
  `plays != "none"`.

- team_participants:

  (*Character*): team-participant-flattening mode for the embedded plays
  – one of `"none"` (default) or `"wide"`. Consulted only when
  `plays != "none"`.

- team_participants_list:

  (*Logical*): when `TRUE`, append the `team_participants` list-column
  to each embedded play. Defaults to `FALSE`. Consulted only when
  `plays != "none"`.

- position_detail:

  (*Logical*): when `TRUE` (default), the embedded plays'
  `participants = "wide"` output carries position detail joined from the
  ESPN position catalog. Consulted only when `plays != "none"` and
  `participants = "wide"`.

- team_detail:

  (*Logical*): when `TRUE` (default), the ESPN team catalog
  ([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
  is fetched once and friendly team fields are joined in next to the
  drive-level team-id columns – `team_id` and `end_team_id` (which
  become `drive_team_id` / `drive_end_team_id` in `plays = "expand"`
  mode). For each id column `X_id` the sibling columns `X_name`,
  `X_abbreviation`, `X_location`, `X_display_name`,
  `X_short_display_name`, `X_nickname`, `X_color`, `X_alternate_color`,
  `X_logo_href`, `X_logo_dark_href` are inserted immediately after it.
  The embedded play tibbles keep the base
  [`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
  schema (not team-enriched), so a `plays = "expand"` result matches
  [`espn_cfb_unnest_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_unnest_plays.md)
  of a `plays = "list"` result. A catalog failure degrades to `NA`
  rather than erroring the wrapper. Set `FALSE` to skip the catalog
  fetch and the join.

## Value

A data frame with one row per drive:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| drive_id | character | ESPN drive id. |
| sequence_number | character | Drive sequence number within the game. |
| description | character | Drive summary text (e.g. `9 plays, 75 yards, 4:12`). |
| team_id | character | ESPN team id of the offensive team (parsed from `team_ref`). |
| end_team_id | character | ESPN team id of the team in possession at drive end. |
| start_period | integer | Period (quarter) at the start of the drive. |
| start_period_type | character | Period type at the start of the drive (e.g. `quarter`). |
| start_clock | character | Game clock display value at the start of the drive. |
| start_clock_seconds | numeric | Game clock value in seconds at the start of the drive. |
| start_yard_line | integer | Yard line at the start of the drive. |
| start_text | character | Field-position text at the start of the drive. |
| end_period | integer | Period (quarter) at the end of the drive. |
| end_period_type | character | Period type at the end of the drive (e.g. `quarter`). |
| end_clock | character | Game clock display value at the end of the drive. |
| end_clock_seconds | numeric | Game clock value in seconds at the end of the drive. |
| end_yard_line | integer | Yard line at the end of the drive. |
| end_text | character | Field-position text at the end of the drive. |
| time_elapsed | character | Elapsed game time for the drive (`MM:SS`). |
| time_elapsed_seconds | numeric | Elapsed game time for the drive, in seconds. |
| yards | integer | Total yards gained on the drive. |
| offensive_plays | integer | Number of offensive plays on the drive. |
| is_score | logical | `TRUE` if the drive resulted in a score. |
| result | character | Drive result code (e.g. `PUNT`, `TD`). |
| short_display_result | character | Short drive-result label. |
| display_result | character | Drive-result label (e.g. `Punt`, `Touchdown`). |
| source_id | character | ESPN data-source id for the drive. |
| source_description | character | ESPN data-source description (e.g. `Feed`). |
| drive_ref | character | `$ref` URL to the drive resource itself. |
| team_ref | character | `$ref` URL to the offensive team resource. |
| end_team_ref | character | `$ref` URL to the team in possession at drive end. |
| plays_ref | character | `$ref` URL to the drive's plays resource. |

When `plays = "list"`, an additional `plays` list-column is appended –
each cell a tibble in the full
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
schema. When `plays = "expand"`, the flat one-row-per-play table is
returned instead: every column of
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
plus the drive-level columns above carried alongside each play with a
`drive_` prefix.

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/drives`. The competition id
always equals the game id. Returns one row per drive (typically 18-24
drives per game). Each drive carries the offensive team, the start and
end period/clock/yard-line, total yards, offensive play count, the drive
result, and a scoring flag. The `plays_ref` column is the `$ref` URL to
that drive's plays – pass the `drive_id` to
[`espn_cfb_game_drive_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drive_plays.md)
to fetch the play-by-play partitioned to a single drive. This is the
richest drive resource ESPN exposes; the site-v2 summary feed only
carries a flattened subset.

The `plays` argument controls whether each drive's plays are embedded:

- `"none"` (default) – the drives output is returned unchanged, one row
  per drive, with no embedded plays.

- `"list"` – a `plays` **list-column** is appended; each cell is that
  drive's plays as a tibble in the **full**
  [`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
  schema (~54 base columns plus any optional participant columns). A
  drive with no matched plays gets an empty 0-row tibble, never `NULL`.

- `"expand"` – the **flat one-row-per-play** table is returned: every
  play in the full
  [`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
  schema, with that play's drive-level columns carried alongside,
  prefixed `drive_` (e.g. `drive_id`, `drive_result`, `drive_yards`,
  `drive_start_yard_line`) to avoid collision with the play's own
  columns. This is the
  [`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
  expanded form enriched with drive context.

The `participants`, `participants_list`, `team_participants`,
`team_participants_list`, and `position_detail` arguments shape the
embedded plays and are consulted **only** when `plays != "none"`. They
have the same meaning as the identically named arguments on
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
– e.g. `participants = "wide"` appends the type-keyed `{type}_player_*`
columns to every embedded play tibble. See
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
for the full description of each.

To get the plays efficiently the wrapper first probes the drives
endpoint for inline plays (`items[].plays.items[]`); when ESPN embeds
them, no extra request is made. When only a `plays.$ref` is present, the
competition-level `/plays` feed is fetched **once** and the plays are
partitioned into drives by matching each play's drive id. Per-drive
`plays_ref` URLs are never dereferenced individually.

[`espn_cfb_unnest_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_unnest_plays.md)
turns a `plays = "list"` result into the same flat table as
`plays = "expand"` without any further HTTP.

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
  try(espn_cfb_game_drives(game_id = 401628339))
#> ── Game drives data from ESPN ──────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 16:41:30 UTC
#> # A tibble: 20 × 52
#>    game_id   drive_id    sequence_number description           team_id team_name
#>    <chr>     <chr>       <chr>           <chr>                 <chr>   <chr>    
#>  1 401628339 4016283391  1               3 plays, 6 yards, 2:… 2635    Golden E…
#>  2 401628339 4016283392  2               1 play, 22 yards, 0:… 61      Bulldogs 
#>  3 401628339 4016283393  3               3 plays, 1 yard, 2:06 2635    Golden E…
#>  4 401628339 4016283394  4               7 plays, 58 yards, 3… 61      Bulldogs 
#>  5 401628339 4016283395  5               7 plays, 5 yards, 4:… 2635    Golden E…
#>  6 401628339 4016283396  6               14 plays, 71 yards, … 61      Bulldogs 
#>  7 401628339 4016283397  7               11 plays, 34 yards, … 2635    Golden E…
#>  8 401628339 4016283398  8               7 plays, 80 yards, 3… 61      Bulldogs 
#>  9 401628339 4016283399  9               3 plays, 1 yard, 0:26 2635    Golden E…
#> 10 401628339 40162833910 10              5 plays, 14 yards, 0… 61      Bulldogs 
#> 11 401628339 40162833911 11              5 plays, 75 yards, 2… 61      Bulldogs 
#> 12 401628339 40162833912 12              1 play, 2 yards, 0:10 2635    Golden E…
#> 13 401628339 40162833913 13              1 play, 27 yards, 0:… 61      Bulldogs 
#> 14 401628339 40162833914 14              3 plays, 3 yards, 1:… 2635    Golden E…
#> 15 401628339 40162833915 15              10 plays, 69 yards, … 61      Bulldogs 
#> 16 401628339 40162833916 16              8 plays, 37 yards, 5… 2635    Golden E…
#> 17 401628339 40162833917 17              6 plays, 25 yards, 8… 61      Bulldogs 
#> 18 401628339 40162833918 18              3 plays, -6 yards, 1… 2635    Golden E…
#> 19 401628339 40162833919 19              7 plays, 37 yards, 2… 61      Bulldogs 
#> 20 401628339 40162833920 20              7 plays, 60 yards, 3… 2635    Golden E…
#> # ℹ 46 more variables: team_abbreviation <chr>, team_location <chr>,
#> #   team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, end_team_id <chr>,
#> #   end_team_name <chr>, end_team_abbreviation <chr>, end_team_location <chr>,
#> #   end_team_display_name <chr>, end_team_short_display_name <chr>,
#> #   end_team_nickname <chr>, end_team_color <chr>, …
  try(espn_cfb_game_drives(game_id = 401628339, plays = "list"))
#> ── Game drives data from ESPN ──────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 16:41:30 UTC
#> # A tibble: 20 × 53
#>    game_id   drive_id    sequence_number description           team_id team_name
#>    <chr>     <chr>       <chr>           <chr>                 <chr>   <chr>    
#>  1 401628339 4016283391  1               3 plays, 6 yards, 2:… 2635    Golden E…
#>  2 401628339 4016283392  2               1 play, 22 yards, 0:… 61      Bulldogs 
#>  3 401628339 4016283393  3               3 plays, 1 yard, 2:06 2635    Golden E…
#>  4 401628339 4016283394  4               7 plays, 58 yards, 3… 61      Bulldogs 
#>  5 401628339 4016283395  5               7 plays, 5 yards, 4:… 2635    Golden E…
#>  6 401628339 4016283396  6               14 plays, 71 yards, … 61      Bulldogs 
#>  7 401628339 4016283397  7               11 plays, 34 yards, … 2635    Golden E…
#>  8 401628339 4016283398  8               7 plays, 80 yards, 3… 61      Bulldogs 
#>  9 401628339 4016283399  9               3 plays, 1 yard, 0:26 2635    Golden E…
#> 10 401628339 40162833910 10              5 plays, 14 yards, 0… 61      Bulldogs 
#> 11 401628339 40162833911 11              5 plays, 75 yards, 2… 61      Bulldogs 
#> 12 401628339 40162833912 12              1 play, 2 yards, 0:10 2635    Golden E…
#> 13 401628339 40162833913 13              1 play, 27 yards, 0:… 61      Bulldogs 
#> 14 401628339 40162833914 14              3 plays, 3 yards, 1:… 2635    Golden E…
#> 15 401628339 40162833915 15              10 plays, 69 yards, … 61      Bulldogs 
#> 16 401628339 40162833916 16              8 plays, 37 yards, 5… 2635    Golden E…
#> 17 401628339 40162833917 17              6 plays, 25 yards, 8… 61      Bulldogs 
#> 18 401628339 40162833918 18              3 plays, -6 yards, 1… 2635    Golden E…
#> 19 401628339 40162833919 19              7 plays, 37 yards, 2… 61      Bulldogs 
#> 20 401628339 40162833920 20              7 plays, 60 yards, 3… 2635    Golden E…
#> # ℹ 47 more variables: team_abbreviation <chr>, team_location <chr>,
#> #   team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, end_team_id <chr>,
#> #   end_team_name <chr>, end_team_abbreviation <chr>, end_team_location <chr>,
#> #   end_team_display_name <chr>, end_team_short_display_name <chr>,
#> #   end_team_nickname <chr>, end_team_color <chr>, …
  try(espn_cfb_game_drives(game_id = 401628339, plays = "expand"))
#> ── Game drive plays (expanded) data from ESPN ──────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 16:41:31 UTC
#> # A tibble: 156 × 106
#>    drive_game_id drive_drive_id drive_sequence_number drive_description     
#>    <chr>         <chr>          <chr>                 <chr>                 
#>  1 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  2 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  3 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  4 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  5 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  6 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  7 401628339     4016283392     2                     1 play, 22 yards, 0:06
#>  8 401628339     4016283393     3                     3 plays, 1 yard, 2:06 
#>  9 401628339     4016283393     3                     3 plays, 1 yard, 2:06 
#> 10 401628339     4016283393     3                     3 plays, 1 yard, 2:06 
#> # ℹ 146 more rows
#> # ℹ 102 more variables: drive_team_id <chr>, drive_team_name <chr>,
#> #   drive_team_abbreviation <chr>, drive_team_location <chr>,
#> #   drive_team_display_name <chr>, drive_team_short_display_name <chr>,
#> #   drive_team_nickname <chr>, drive_team_color <chr>,
#> #   drive_team_alternate_color <chr>, drive_team_logo_href <chr>,
#> #   drive_team_logo_dark_href <chr>, drive_end_team_id <chr>, …
  try(espn_cfb_game_drives(game_id = 401628339, team_detail = FALSE))
#> ── Game drives data from ESPN ──────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 16:41:31 UTC
#> # A tibble: 20 × 32
#>    game_id drive_id sequence_number description team_id end_team_id start_period
#>    <chr>   <chr>    <chr>           <chr>       <chr>   <chr>              <int>
#>  1 401628… 4016283… 1               3 plays, 6… 2635    2635                   1
#>  2 401628… 4016283… 2               1 play, 22… 61      61                     1
#>  3 401628… 4016283… 3               3 plays, 1… 2635    2635                   1
#>  4 401628… 4016283… 4               7 plays, 5… 61      61                     1
#>  5 401628… 4016283… 5               7 plays, 5… 2635    2635                   1
#>  6 401628… 4016283… 6               14 plays, … 61      61                     1
#>  7 401628… 4016283… 7               11 plays, … 2635    2635                   2
#>  8 401628… 4016283… 8               7 plays, 8… 61      61                     2
#>  9 401628… 4016283… 9               3 plays, 1… 2635    2635                   2
#> 10 401628… 4016283… 10              5 plays, 1… 61      61                     2
#> 11 401628… 4016283… 11              5 plays, 7… 61      61                     3
#> 12 401628… 4016283… 12              1 play, 2 … 2635    2635                   3
#> 13 401628… 4016283… 13              1 play, 27… 61      61                     3
#> 14 401628… 4016283… 14              3 plays, 3… 2635    2635                   3
#> 15 401628… 4016283… 15              10 plays, … 61      61                     3
#> 16 401628… 4016283… 16              8 plays, 3… 2635    2635                   3
#> 17 401628… 4016283… 17              6 plays, 2… 61      61                     3
#> 18 401628… 4016283… 18              3 plays, -… 2635    2635                   4
#> 19 401628… 4016283… 19              7 plays, 3… 61      61                     4
#> 20 401628… 4016283… 20              7 plays, 6… 2635    2635                   4
#> # ℹ 25 more variables: start_period_type <chr>, start_clock <chr>,
#> #   start_clock_seconds <dbl>, start_yard_line <int>, start_text <chr>,
#> #   end_period <int>, end_period_type <chr>, end_clock <chr>,
#> #   end_clock_seconds <dbl>, end_yard_line <int>, end_text <chr>,
#> #   time_elapsed <chr>, time_elapsed_seconds <dbl>, yards <int>,
#> #   offensive_plays <int>, is_score <lgl>, result <chr>,
#> #   short_display_result <chr>, display_result <chr>, source_id <chr>, …
# }
```
