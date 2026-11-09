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

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  # position_detail = FALSE skips the position catalog (about 75 requests).
  try(espn_cfb_game_player_statistics(game_id = 401628339,
                                      athlete_id = 4429105,
                                      position_detail = FALSE))
#> ── Game player statistics data from ESPN ───────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:29 UTC
#> # A tibble: 143 × 29
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
#> # ℹ 133 more rows
#> # ℹ 23 more variables: team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>,
#> #   athlete_display_name <chr>, jersey <chr>, starter <lgl>,
#> #   did_not_play <lgl>, position_id <chr>, category_name <chr>,
#> #   category_display_name <chr>, category_short_display_name <chr>, …
# }
```
