# **ESPN College Football Game Team Records**

Get each team's win-loss records (overall, home, road, conference) as
they stood at the time of a single college football game.

## Usage

``` r
espn_cfb_game_team_records(game_id = NULL, detail = FALSE, team_detail = TRUE)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- detail:

  (*Logical*): controls the output shape. One of:

  - `FALSE` (default) – the summary output, one row per (team x record
    type), with the columns shown in the *Value* table below.

  - `TRUE` – a long frame, one row per (team x record x stat) expanding
    each record's nested `stats[]` array (see *Details*).

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog
  ([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
  once and join friendly team fields next to the `team_id` column –
  `team_name`, `team_abbreviation`, `team_location`,
  `team_display_name`, `team_short_display_name`, `team_nickname`,
  `team_color`, `team_alternate_color`, `team_logo_href`, and
  `team_logo_dark_href`, inserted immediately after `team_id`. Composes
  with `detail` – both output shapes carry `team_id`. A catalog failure
  degrades to `NA` rather than erroring the wrapper. Set `FALSE` to skip
  the catalog fetch and the join.

## Value

A data frame with one row per team-record type (when `detail = FALSE`):

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
| record_id | character | ESPN record-type id. |
| name | character | Record-type key (e.g. `overall`, `Home`, `Road`). |
| abbreviation | character | Record-type abbreviation. |
| display_name | character | Human-readable record-type name. |
| short_display_name | character | Short human-readable record-type name. |
| description | character | ESPN's description of the record type. |
| type | character | Record-type category (e.g. `total`, `home`, `road`). |
| summary | character | Win-loss summary string (e.g. `2-0`). |
| display_value | character | Display-formatted record value. |
| value | numeric | Numeric record value. |
| record_ref | character | `$ref` URL to the record resource. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/competitors/{team_id}/records`.
This wrapper reads the teams list for the game and fetches the records
resource for **both** teams, stacking the `items` arrays into one long
frame – one row per (team x record type). Each record type carries a
`summary` string (e.g. `"2-0"`). With `detail = TRUE` the per-record
statistic breakdown (points-per-game, streak, ...) nested under each
record is also expanded. `home_away` identifies which team a row belongs
to.

When `detail = TRUE` the returned frame is in long format with one row
per (team x record x stat), with columns: `game_id`, `team_id`,
`home_away`, `record_type` (the record-type key, e.g. `overall`),
`record_summary` (the record's win-loss summary string), `stat_name`,
`stat_type` (the stat-type key, e.g. `wins`), `abbreviation`,
`display_name`, `short_display_name`, `description` (ESPN's description
of the stat), `value`, and `display_value`.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_game_team_records(game_id = 401628339))
#> ── Game team records data from ESPN ────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:28 UTC
#> # A tibble: 8 × 24
#>   game_id   team_id team_name  team_abbreviation team_location team_display_name
#>   <chr>     <chr>   <chr>      <chr>             <chr>         <chr>            
#> 1 401628339 61      Bulldogs   UGA               Georgia       Georgia Bulldogs 
#> 2 401628339 61      Bulldogs   UGA               Georgia       Georgia Bulldogs 
#> 3 401628339 61      Bulldogs   UGA               Georgia       Georgia Bulldogs 
#> 4 401628339 61      Bulldogs   UGA               Georgia       Georgia Bulldogs 
#> 5 401628339 2635    Golden Ea… TNTC              Tennessee Te… Tennessee Tech G…
#> 6 401628339 2635    Golden Ea… TNTC              Tennessee Te… Tennessee Tech G…
#> 7 401628339 2635    Golden Ea… TNTC              Tennessee Te… Tennessee Tech G…
#> 8 401628339 2635    Golden Ea… TNTC              Tennessee Te… Tennessee Tech G…
#> # ℹ 18 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, home_away <chr>, record_id <chr>, name <chr>,
#> #   abbreviation <chr>, display_name <chr>, short_display_name <chr>,
#> #   description <chr>, type <chr>, summary <chr>, display_value <chr>,
#> #   value <dbl>, record_ref <chr>
  try(espn_cfb_game_team_records(game_id = 401628339, detail = TRUE))
#> ── Game team records data from ESPN ────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:28 UTC
#> # A tibble: 78 × 23
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
#> # ℹ 68 more rows
#> # ℹ 17 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, home_away <chr>, record_type <chr>,
#> #   record_summary <chr>, stat_name <chr>, stat_type <chr>, abbreviation <chr>,
#> #   display_name <chr>, short_display_name <chr>, description <chr>,
#> #   value <dbl>, display_value <chr>
  try(espn_cfb_game_team_records(game_id = 401628339,
                                 team_detail = FALSE))
#> ── Game team records data from ESPN ────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:28 UTC
#> # A tibble: 8 × 14
#>   game_id   team_id home_away record_id name      abbreviation display_name     
#>   <chr>     <chr>   <chr>     <chr>     <chr>     <chr>        <chr>            
#> 1 401628339 61      home      1         overall   Game         Record Year To D…
#> 2 401628339 61      home      9002      Home      NA           Home             
#> 3 401628339 61      home      9003      Road      NA           Road             
#> 4 401628339 61      home      9009      vs. Conf. NA           CONF             
#> 5 401628339 2635    away      1         overall   Game         Record Year To D…
#> 6 401628339 2635    away      9002      Home      NA           Home             
#> 7 401628339 2635    away      9003      Road      NA           Road             
#> 8 401628339 2635    away      9009      vs. Conf. NA           CONF             
#> # ℹ 7 more variables: short_display_name <chr>, description <chr>, type <chr>,
#> #   summary <chr>, display_value <chr>, value <dbl>, record_ref <chr>
# }
```
