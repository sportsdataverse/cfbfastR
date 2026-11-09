# **ESPN College Football Standings (Long Format)**

Get ESPN's standings for a college football group – the full set of
record splits (overall, home, away, conference, ...) and every standings
statistic (wins, losses, point differential, streak, ...) for every team
in the group.

## Usage

``` r
espn_cfb_standings(
  year = NULL,
  group_id = 90,
  season_type = 2,
  team_detail = TRUE
)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2001

- group_id:

  (*Integer* default 90): ESPN group id. `90` = NCAA Division I (all D-I
  teams). Conference group ids also work.

- season_type:

  (*Integer* default 2): ESPN season type id. `2` = regular season.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per team-record-statistic:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| season_type | integer | ESPN season type id queried. |
| group_id | character | ESPN group id queried. |
| team_id | character | ESPN team id (parsed from `team_ref`). |
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
| record_type | character | Record split type code (e.g. `total`, `homerecord`). |
| record_name | character | Record split name (e.g. `Overall`, `Home`). |
| record_summary | character | Record split summary (e.g. `14-0`). |
| stat_name | character | Standings statistic key (e.g. `wins`, `streak`). |
| abbreviation | character | Statistic abbreviation. |
| display_name | character | Human-readable statistic name. |
| value | numeric | Statistic value. |
| display_value | character | Display-formatted statistic value. |
| team_ref | character | `$ref` URL to the per-season team resource. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/groups/{group_id}/standings`.
The standings resource nests three levels deep – team -\> record split
-\> statistic – so this wrapper returns long format: one row per (team x
record split x statistic). The long shape absorbs ESPN's habit of adding
standings stats across seasons. Pivot wider keyed on `stat_name` (within
a `record_type`) when a wide table is wanted.

`group_id = 90` (NCAA Division I) is the sensible default and yields
every D-I team in one call. Conference-level `group_id`s – enumerate
them with
[`espn_cfb_groups()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_groups.md)
– restrict the table to that conference.

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
  # One conference (group 8, the SEC) keeps the request small.
  try(espn_cfb_standings(year = 2024, group_id = 8, team_detail = FALSE))
#> ── Standings data from ESPN ────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:13:15 UTC
#> # A tibble: 2,304 × 13
#>    season season_type group_id team_id record_type record_name record_summary
#>     <int>       <int> <chr>    <chr>   <chr>       <chr>       <chr>         
#>  1   2024           2 8        251     total       overall     11-2          
#>  2   2024           2 8        251     total       overall     11-2          
#>  3   2024           2 8        251     total       overall     11-2          
#>  4   2024           2 8        251     total       overall     11-2          
#>  5   2024           2 8        251     total       overall     11-2          
#>  6   2024           2 8        251     total       overall     11-2          
#>  7   2024           2 8        251     total       overall     11-2          
#>  8   2024           2 8        251     total       overall     11-2          
#>  9   2024           2 8        251     total       overall     11-2          
#> 10   2024           2 8        251     total       overall     11-2          
#> # ℹ 2,294 more rows
#> # ℹ 6 more variables: stat_name <chr>, abbreviation <chr>, display_name <chr>,
#> #   value <dbl>, display_value <chr>, team_ref <chr>
# }
```
