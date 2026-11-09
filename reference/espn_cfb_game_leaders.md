# **ESPN College Football Game Leaders**

Get the per-game statistical leaders for a single college football game
– one row per leader within each statistical category, both teams
combined.

## Usage

``` r
espn_cfb_game_leaders(game_id = NULL, team_detail = TRUE)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per leader-in-category:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| category_name | character | Leader-category key (e.g. `passingLeader`). |
| category_display_name | character | Human-readable leader-category name. |
| category_short_display_name | character | Short human-readable leader-category name. |
| category_abbreviation | character | Leader-category abbreviation. |
| leader_rank | integer | Rank of the athlete within the category (1 = top). |
| athlete_id | character | ESPN athlete id (parsed from `athlete_ref`). |
| team_id | character | ESPN team id of the athlete's team (parsed from `team_ref`). |
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
| display_value | character | Display-formatted stat line for the leader. |
| value | numeric | Numeric leading-stat value. |
| athlete_ref | character | `$ref` URL to the athlete resource. |
| team_ref | character | `$ref` URL to the team resource. |
| statistics_ref | character | `$ref` URL to the athlete's game-statistics resource. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/leaders`. The competition id
always equals the game id. Returns one row per leader within each leader
category (passing, rushing, receiving, ...). ESPN publishes roughly 22
categories per game; each category lists a small number of leading
athletes. This is the game-wide leaders resource – distinct from
[`espn_cfb_game_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_leaders.md),
which returns the leaders for a single competitor (team).

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to the
`team_id` column – `team_name`, `team_abbreviation`, `team_location`,
`team_display_name`, `team_short_display_name`, `team_nickname`,
`team_color`, `team_alternate_color`, `team_logo_href`, and
`team_logo_dark_href`, inserted immediately after `team_id`. A catalog
failure degrades to `NA` rather than erroring the wrapper. Set
`team_detail = FALSE` to skip the catalog fetch and the join.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_game_leaders(game_id = 401628339))
#> ── Game leaders data from ESPN ─────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:54:30 UTC
#> # A tibble: 162 × 23
#>    game_id   category_name category_display_name category_short_display_name
#>    <chr>     <chr>         <chr>                 <chr>                      
#>  1 401628339 passingLeader Passing Leader        PASS                       
#>  2 401628339 passingLeader Passing Leader        PASS                       
#>  3 401628339 passingLeader Passing Leader        PASS                       
#>  4 401628339 rushingLeader Rushing Leader        RUSH                       
#>  5 401628339 rushingLeader Rushing Leader        RUSH                       
#>  6 401628339 rushingLeader Rushing Leader        RUSH                       
#>  7 401628339 rushingLeader Rushing Leader        RUSH                       
#>  8 401628339 rushingLeader Rushing Leader        RUSH                       
#>  9 401628339 rushingLeader Rushing Leader        RUSH                       
#> 10 401628339 rushingLeader Rushing Leader        RUSH                       
#> # ℹ 152 more rows
#> # ℹ 19 more variables: category_abbreviation <chr>, leader_rank <int>,
#> #   athlete_id <chr>, team_id <chr>, team_name <chr>, team_abbreviation <chr>,
#> #   team_location <chr>, team_display_name <chr>,
#> #   team_short_display_name <chr>, team_nickname <chr>, team_color <chr>,
#> #   team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, display_value <chr>, value <dbl>, …
  try(espn_cfb_game_leaders(game_id = 401628339, team_detail = FALSE))
#> ── Game leaders data from ESPN ─────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:54:31 UTC
#> # A tibble: 162 × 13
#>    game_id   category_name category_display_name category_short_display_name
#>    <chr>     <chr>         <chr>                 <chr>                      
#>  1 401628339 passingLeader Passing Leader        PASS                       
#>  2 401628339 passingLeader Passing Leader        PASS                       
#>  3 401628339 passingLeader Passing Leader        PASS                       
#>  4 401628339 rushingLeader Rushing Leader        RUSH                       
#>  5 401628339 rushingLeader Rushing Leader        RUSH                       
#>  6 401628339 rushingLeader Rushing Leader        RUSH                       
#>  7 401628339 rushingLeader Rushing Leader        RUSH                       
#>  8 401628339 rushingLeader Rushing Leader        RUSH                       
#>  9 401628339 rushingLeader Rushing Leader        RUSH                       
#> 10 401628339 rushingLeader Rushing Leader        RUSH                       
#> # ℹ 152 more rows
#> # ℹ 9 more variables: category_abbreviation <chr>, leader_rank <int>,
#> #   athlete_id <chr>, team_id <chr>, display_value <chr>, value <dbl>,
#> #   athlete_ref <chr>, team_ref <chr>, statistics_ref <chr>
# }
```
