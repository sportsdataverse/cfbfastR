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

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
if (FALSE) { # interactive()
# One request per player in the game, so this takes a while.
try(espn_cfb_game_player_box(game_id = 401628339,
                             position_detail = FALSE, team_detail = FALSE))
}
```
