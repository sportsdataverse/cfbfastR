# **ESPN College Football Player Stats (web v3, all categories)**

Get a single college football player's web-common-v3 statistics from
ESPN – the comprehensive `/athletes/{id}/stats` payload (every category:
passing, rushing, receiving, defensive, etc.) in long format (one row
per stat). This is the richer "v3" companion to
[`espn_cfb_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats.md)
(core-v2 season statistics) and
[`espn_cfb_player_career_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_career_stats.md).

## Usage

``` r
espn_cfb_player_stats_v3(athlete_id = NULL, year = NULL, athlete_detail = TRUE)
```

## Arguments

- athlete_id:

  (*Character/Integer* required): ESPN athlete id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2004

- athlete_detail:

  (*Logical*): when `TRUE` (default), append the `athlete_*` name
  columns via one extra athlete fetch.

## Value

A data frame with one row per (category x team-season x stat):

|                   |           |                                          |
|-------------------|-----------|------------------------------------------|
| col_name          | types     | description                              |
| athlete_id        | character | ESPN athlete id.                         |
| season            | integer   | Requested season (4-digit year).         |
| category          | character | Stat category key (e.g. `passing`).      |
| category_display  | character | Human-readable category name.            |
| team_id           | character | ESPN team id for the stat row.           |
| team_slug         | character | Team slug for the stat row.              |
| stat_season       | integer   | Season of the stat row (per ESPN).       |
| position          | character | Player position for the stat row.        |
| stat_name         | character | Stat key (from the category `names`).    |
| stat_label        | character | Stat short label (from `labels`).        |
| stat_display_name | character | Stat display name (from `displayNames`). |
| value             | character | Stat value (as published).               |

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_player_stats_v3(athlete_id = 4431611, year = 2023))
#> ── Player web-v3 statistics from ESPN ──────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:49 UTC
#> # A tibble: 190 × 18
#>    athlete_id season category category_display team_id team_slug     stat_season
#>    <chr>       <int> <chr>    <chr>            <chr>   <chr>               <int>
#>  1 4431611      2023 passing  Passing          201     oklahoma-soo…        2021
#>  2 4431611      2023 passing  Passing          201     oklahoma-soo…        2021
#>  3 4431611      2023 passing  Passing          201     oklahoma-soo…        2021
#>  4 4431611      2023 passing  Passing          201     oklahoma-soo…        2021
#>  5 4431611      2023 passing  Passing          201     oklahoma-soo…        2021
#>  6 4431611      2023 passing  Passing          201     oklahoma-soo…        2021
#>  7 4431611      2023 passing  Passing          201     oklahoma-soo…        2021
#>  8 4431611      2023 passing  Passing          201     oklahoma-soo…        2021
#>  9 4431611      2023 passing  Passing          201     oklahoma-soo…        2021
#> 10 4431611      2023 passing  Passing          201     oklahoma-soo…        2021
#> # ℹ 180 more rows
#> # ℹ 11 more variables: position <chr>, stat_name <chr>, stat_label <chr>,
#> #   stat_display_name <chr>, value <chr>, athlete_display_name <chr>,
#> #   athlete_first_name <chr>, athlete_last_name <chr>, athlete_jersey <chr>,
#> #   athlete_position <chr>, athlete_position_abbreviation <chr>
# }
```
