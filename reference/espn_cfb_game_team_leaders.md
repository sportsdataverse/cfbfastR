# **ESPN College Football Game Team Leaders**

Get each team's statistical leaders (passing, rushing, receiving, ...)
for a single college football game.

## Usage

``` r
espn_cfb_game_team_leaders(game_id = NULL, team_detail = TRUE)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` and
  `leader_team_id` columns (see *Details*). Set `FALSE` to skip the
  catalog fetch and the join.

## Value

A data frame with one row per team-category-leader:

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
| category_name | character | Leader category key (e.g. `passingLeader`). |
| category_display | character | Human-readable category name. |
| category_short_display | character | Short human-readable category name. |
| category_abbrev | character | Category abbreviation. |
| rank | integer | Leader rank within the category (1 = top performer). |
| athlete_id | character | ESPN athlete id (parsed from `athlete_ref`). |
| leader_team_id | character | ESPN team id of the leader (parsed from `leader_team_ref`). |
| leader_team_name | character | Leader's team nickname; `team_detail = TRUE` only. |
| leader_team_abbreviation | character | Leader's team abbreviation; `team_detail = TRUE` only. |
| leader_team_location | character | Leader's team location; `team_detail = TRUE` only. |
| leader_team_display_name | character | Leader's team full display name; `team_detail = TRUE` only. |
| leader_team_short_display_name | character | Leader's team short display name; `team_detail = TRUE` only. |
| leader_team_nickname | character | Leader's team nickname label; `team_detail = TRUE` only. |
| leader_team_color | character | Leader's team primary color; `team_detail = TRUE` only. |
| leader_team_alternate_color | character | Leader's team alternate color; `team_detail = TRUE` only. |
| leader_team_logo_href | character | Leader's team default logo URL; `team_detail = TRUE` only. |
| leader_team_logo_dark_href | character | Leader's team dark logo URL; `team_detail = TRUE` only. |
| value | numeric | Leading statistic value. |
| display_value | character | ESPN's pre-formatted stat line for the leader. |
| athlete_ref | character | `$ref` URL to the athlete-in-event resource. |
| leader_team_ref | character | `$ref` URL to the leader's team resource. |
| statistics_ref | character | `$ref` URL to the leader's game-statistics resource. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/competitors/{team_id}/leaders`.
This wrapper reads the teams list for the game and fetches the leaders
resource for **both** teams, flattening the nested
`categories -> leaders` tree into one long frame: one row per (team x
category x leader). `rank` is the leader's position within the category
(1 = top performer). `display_value` is ESPN's pre-formatted stat line
(e.g. `"18/25, 242 YDS, 5 TD"`).

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to both
team-id columns – `team_id` gains `team_name`, `team_abbreviation`, ...,
and `leader_team_id` gains `leader_team_name`,
`leader_team_abbreviation`, .... A catalog failure degrades to `NA`
rather than erroring the wrapper. Set `team_detail = FALSE` to skip the
catalog fetch and the join.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_game_team_leaders(game_id = 401628339))
#> ── Game team leaders data from ESPN ────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:03:38 UTC
#> # A tibble: 193 × 35
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
#> # ℹ 183 more rows
#> # ℹ 29 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, home_away <chr>, category_name <chr>,
#> #   category_display <chr>, category_short_display <chr>,
#> #   category_abbrev <chr>, rank <int>, athlete_id <chr>, leader_team_id <chr>,
#> #   leader_team_name <chr>, leader_team_abbreviation <chr>, …
  try(espn_cfb_game_team_leaders(game_id = 401628339,
                                 team_detail = FALSE))
#> ── Game team leaders data from ESPN ────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:03:38 UTC
#> # A tibble: 193 × 15
#>    game_id   team_id home_away category_name   category_display
#>    <chr>     <chr>   <chr>     <chr>           <chr>           
#>  1 401628339 61      home      passingLeader   Passing Leader  
#>  2 401628339 61      home      passingLeader   Passing Leader  
#>  3 401628339 61      home      rushingLeader   Rushing Leader  
#>  4 401628339 61      home      rushingLeader   Rushing Leader  
#>  5 401628339 61      home      rushingLeader   Rushing Leader  
#>  6 401628339 61      home      rushingLeader   Rushing Leader  
#>  7 401628339 61      home      rushingLeader   Rushing Leader  
#>  8 401628339 61      home      rushingLeader   Rushing Leader  
#>  9 401628339 61      home      rushingLeader   Rushing Leader  
#> 10 401628339 61      home      receivingLeader Receiving Leader
#> # ℹ 183 more rows
#> # ℹ 10 more variables: category_short_display <chr>, category_abbrev <chr>,
#> #   rank <int>, athlete_id <chr>, leader_team_id <chr>, value <dbl>,
#> #   display_value <chr>, athlete_ref <chr>, leader_team_ref <chr>,
#> #   statistics_ref <chr>
# }
```
