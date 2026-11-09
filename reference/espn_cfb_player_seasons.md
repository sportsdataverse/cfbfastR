# **ESPN College Football Player Seasons**

Get the list of seasons a single college football player has a
statistical record for on ESPN – one row per season, with the `$ref`
URLs to that season's statistics.

## Usage

``` r
espn_cfb_player_seasons(athlete_id = NULL, athlete_detail = TRUE)
```

## Arguments

- athlete_id:

  (*Character/Integer* required): ESPN athlete id.

- athlete_detail:

  (*Logical*): when `TRUE` (default), fetch the requested athlete's ESPN
  record once and append the `athlete_*` name columns (see *Details*).
  Set `FALSE` to skip the fetch, reproducing the prior output exactly.

## Value

A data frame with one row per season-stat-type entry:

|  |  |  |
|----|----|----|
| col_name | types | description |
| athlete_id | character | ESPN athlete id. |
| season | integer | Season (4-digit year) the player has a record in. |
| stat_type | character | Statistics type for the entry (e.g. `total`). |
| season_ref | character | `$ref` URL to the season resource. |
| statistics_ref | character | `$ref` URL to the season statistics resource. |
| athlete_display_name | character | Player display name; `athlete_detail = TRUE` only. |
| athlete_first_name | character | Player first name; `athlete_detail = TRUE` only. |
| athlete_last_name | character | Player last name; `athlete_detail = TRUE` only. |
| athlete_jersey | character | Player jersey number; `athlete_detail = TRUE` only. |
| athlete_position | character | Player position name; `athlete_detail = TRUE` only. |
| athlete_position_abbreviation | character | Player position abbreviation; `athlete_detail = TRUE` only. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/athletes/{athlete_id}/statisticslog`.
ESPN exposes no dedicated `/athletes/{id}/seasons` resource for college
football (that path 404s); the statistics log is the closest thing – it
returns one `entry` per season the player accumulated statistics in,
which is exactly the player's season list. Each entry carries the season
`$ref` and one or more statistics references (split by stat `type`, e.g.
`total`). The statistics themselves are not auto-dereferenced; use
[`espn_cfb_player_career_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_career_stats.md)
for a resolved, long-format stat table for a given season.

When `athlete_detail = TRUE` (the default) the requested athlete's ESPN
record is fetched once (from the league-wide athlete resource, since
this wrapper takes no `year`) and the human-readable name columns
`athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
`athlete_jersey`, `athlete_position`, and
`athlete_position_abbreviation` are appended to every row. This is a
single cheap fetch – the wrapper already takes one `athlete_id`. A fetch
failure degrades the name columns to `NA` rather than erroring the
wrapper. Set `athlete_detail = FALSE` to skip the fetch and reproduce
the prior output exactly.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_player_seasons(athlete_id = 102597))
#> ── Player seasons from ESPN ────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:46 UTC
#> # A tibble: 10 × 11
#>    athlete_id season stat_type season_ref    statistics_ref athlete_display_name
#>    <chr>       <int> <chr>     <chr>         <chr>          <chr>               
#>  1 102597       2024 total     http://sport… http://sports… Will Rogers         
#>  2 102597       2024 team      http://sport… http://sports… Will Rogers         
#>  3 102597       2023 total     http://sport… http://sports… Will Rogers         
#>  4 102597       2023 team      http://sport… http://sports… Will Rogers         
#>  5 102597       2022 total     http://sport… http://sports… Will Rogers         
#>  6 102597       2022 team      http://sport… http://sports… Will Rogers         
#>  7 102597       2021 total     http://sport… http://sports… Will Rogers         
#>  8 102597       2021 team      http://sport… http://sports… Will Rogers         
#>  9 102597       2020 total     http://sport… http://sports… Will Rogers         
#> 10 102597       2020 team      http://sport… http://sports… Will Rogers         
#> # ℹ 5 more variables: athlete_first_name <chr>, athlete_last_name <chr>,
#> #   athlete_jersey <chr>, athlete_position <chr>,
#> #   athlete_position_abbreviation <chr>
  try(espn_cfb_player_seasons(athlete_id = 102597, athlete_detail = FALSE))
#> ── Player seasons from ESPN ────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:46 UTC
#> # A tibble: 10 × 5
#>    athlete_id season stat_type season_ref                         statistics_ref
#>    <chr>       <int> <chr>     <chr>                              <chr>         
#>  1 102597       2024 total     http://sports.core.api.espn.com/v… http://sports…
#>  2 102597       2024 team      http://sports.core.api.espn.com/v… http://sports…
#>  3 102597       2023 total     http://sports.core.api.espn.com/v… http://sports…
#>  4 102597       2023 team      http://sports.core.api.espn.com/v… http://sports…
#>  5 102597       2022 total     http://sports.core.api.espn.com/v… http://sports…
#>  6 102597       2022 team      http://sports.core.api.espn.com/v… http://sports…
#>  7 102597       2021 total     http://sports.core.api.espn.com/v… http://sports…
#>  8 102597       2021 team      http://sports.core.api.espn.com/v… http://sports…
#>  9 102597       2020 total     http://sports.core.api.espn.com/v… http://sports…
#> 10 102597       2020 team      http://sports.core.api.espn.com/v… http://sports…
# }
```
