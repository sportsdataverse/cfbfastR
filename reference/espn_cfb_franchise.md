# **ESPN College Football Franchise Detail**

Get the ESPN core-v2 detail record for a single college football
franchise – location, nickname, abbreviation, color, the associated
venue and current team, and active status.

## Usage

``` r
espn_cfb_franchise(franchise_id = NULL, team_detail = TRUE)
```

## Arguments

- franchise_id:

  (*Integer* required): ESPN franchise id.

- team_detail:

  (*Logical*): when `TRUE` (default), the ESPN team catalog
  ([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
  is fetched once and friendly team fields are joined in next to the
  `team_id` column. The sibling columns `team_name`,
  `team_abbreviation`, `team_location`, `team_display_name`,
  `team_short_display_name`, `team_nickname`, `team_color`,
  `team_alternate_color`, `team_logo_href`, `team_logo_dark_href` are
  inserted immediately after `team_id`. A catalog failure degrades to
  `NA` rather than erroring the wrapper. Set `FALSE` to skip the catalog
  fetch and the join, reproducing the prior output exactly.

## Value

A single-row data frame:

|  |  |  |
|----|----|----|
| col_name | types | description |
| franchise_id | character | ESPN franchise id. |
| uid | character | ESPN franchise UID string. |
| slug | character | Franchise slug (e.g. `auburn-tigers`). |
| location | character | Franchise location (e.g. `Auburn`). |
| name | character | Franchise name (e.g. `Tigers`). |
| nickname | character | Franchise nickname (e.g. `Auburn`). |
| abbreviation | character | Franchise abbreviation (e.g. `AUB`). |
| display_name | character | Full display name (e.g. `Auburn Tigers`). |
| short_display_name | character | Short display name (e.g. `Auburn`). |
| color | character | Primary team color (hex, no `#`). |
| is_active | logical | `TRUE` if the franchise is currently active. |
| venue_id | character | ESPN id of the franchise's venue (`NA` if none). |
| venue_name | character | Full name of the franchise's venue. |
| team_id | character | ESPN id of the current team (parsed from `team_ref`). |
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
| team_ref | character | `$ref` URL to the current team-in-season resource. |
| franchise_ref | character | `$ref` URL to the franchise resource. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/franchises/{franchise_id}`.
A franchise is the stable program identity, distinct from `/teams`
(which is season-scoped). Returns a single-row tibble. Enumerate
`franchise_id`s with
[`espn_cfb_franchises()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchises.md).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_franchise(franchise_id = 2))
#> ── Franchise detail from ESPN ──────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:01 UTC
#> # A tibble: 1 × 26
#>   franchise_id uid       slug  location name  nickname abbreviation display_name
#>   <chr>        <chr>     <chr> <chr>    <chr> <chr>    <chr>        <chr>       
#> 1 2            s:20~l:2… aubu… Auburn   Tige… Auburn   AUB          Auburn Tige…
#> # ℹ 18 more variables: short_display_name <chr>, color <chr>, is_active <lgl>,
#> #   venue_id <chr>, venue_name <chr>, team_id <chr>, team_name <chr>,
#> #   team_abbreviation <chr>, team_location <chr>, team_display_name <chr>,
#> #   team_short_display_name <chr>, team_nickname <chr>, team_color <chr>,
#> #   team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, team_ref <chr>, franchise_ref <chr>
  try(espn_cfb_franchise(franchise_id = 2, team_detail = FALSE))
#> ── Franchise detail from ESPN ──────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:01 UTC
#> # A tibble: 1 × 16
#>   franchise_id uid       slug  location name  nickname abbreviation display_name
#>   <chr>        <chr>     <chr> <chr>    <chr> <chr>    <chr>        <chr>       
#> 1 2            s:20~l:2… aubu… Auburn   Tige… Auburn   AUB          Auburn Tige…
#> # ℹ 8 more variables: short_display_name <chr>, color <chr>, is_active <lgl>,
#> #   venue_id <chr>, venue_name <chr>, team_id <chr>, team_ref <chr>,
#> #   franchise_ref <chr>
# }
```
