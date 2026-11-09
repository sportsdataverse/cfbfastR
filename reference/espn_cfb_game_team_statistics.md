# **ESPN College Football Game Team Statistics**

Get the full team box-score statistics for both teams in a single
college football game, in long format.

## Usage

``` r
espn_cfb_game_team_statistics(game_id = NULL, team_detail = TRUE)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per team-category-stat:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| team_id | character | ESPN team id for the team. |
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
| split_id | character | ESPN statistics-split id. |
| split_name | character | ESPN statistics-split name (e.g. `Total`). |
| split_abbreviation | character | ESPN statistics-split abbreviation. |
| category_name | character | Stat category key (e.g. `general`, `passing`). |
| category_display | character | Human-readable category name. |
| category_short_display | character | Short human-readable category name. |
| category_abbreviation | character | Stat-category abbreviation. |
| category_summary | character | ESPN's summary string for the category. |
| stat_name | character | Internal stat key (e.g. `passingYards`). |
| abbreviation | character | Stat abbreviation. |
| display_name | character | Human-readable stat name. |
| short_display_name | character | Short human-readable stat name. |
| value | numeric | Stat value. |
| display_value | character | Display-formatted stat value as shown on ESPN. |
| description | character | ESPN's description of the stat. |
| statistics_ref | character | `$ref` URL to the team's statistics resource. |
| team_ref | character | `$ref` URL to the team-in-season resource. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/competitors/{team_id}/statistics`.
This wrapper reads the teams list for the game and fetches the
statistics resource for **both** teams, flattening the nested
`splits -> categories -> stats` tree into one long frame: one row per
(team x category x stat). The long shape absorbs ESPN's habit of adding
and retiring stat keys across seasons. Pivot wider with
[`tidyr::pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
keyed on `stat_name` when a wide team box is wanted.

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to the
`team_id` column – `team_name`, `team_abbreviation`, `team_location`,
`team_display_name`, `team_short_display_name`, `team_nickname`,
`team_color`, `team_alternate_color`, `team_logo_href`, and
`team_logo_dark_href`. A catalog failure degrades to `NA` rather than
erroring the wrapper. Set `team_detail = FALSE` to skip the catalog
fetch and the join.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_game_team_statistics(game_id = 401628339))
#> ── Game team statistics data from ESPN ─────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:36 UTC
#> # A tibble: 584 × 30
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
#> # ℹ 574 more rows
#> # ℹ 24 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, home_away <chr>, split_id <chr>,
#> #   split_name <chr>, split_abbreviation <chr>, category_name <chr>,
#> #   category_display <chr>, category_short_display <chr>,
#> #   category_abbreviation <chr>, category_summary <chr>, stat_name <chr>, …
  try(espn_cfb_game_team_statistics(game_id = 401628339,
                                    team_detail = FALSE))
#> ── Game team statistics data from ESPN ─────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:37 UTC
#> # A tibble: 584 × 20
#>    game_id   team_id home_away split_id split_name split_abbreviation
#>    <chr>     <chr>   <chr>     <chr>    <chr>      <chr>             
#>  1 401628339 61      home      0        Season     Season            
#>  2 401628339 61      home      0        Season     Season            
#>  3 401628339 61      home      0        Season     Season            
#>  4 401628339 61      home      0        Season     Season            
#>  5 401628339 61      home      0        Season     Season            
#>  6 401628339 61      home      0        Season     Season            
#>  7 401628339 61      home      0        Season     Season            
#>  8 401628339 61      home      0        Season     Season            
#>  9 401628339 61      home      0        Season     Season            
#> 10 401628339 61      home      0        Season     Season            
#> # ℹ 574 more rows
#> # ℹ 14 more variables: category_name <chr>, category_display <chr>,
#> #   category_short_display <chr>, category_abbreviation <chr>,
#> #   category_summary <chr>, stat_name <chr>, abbreviation <chr>,
#> #   display_name <chr>, short_display_name <chr>, value <dbl>,
#> #   display_value <chr>, description <chr>, statistics_ref <chr>,
#> #   team_ref <chr>
# }
```
