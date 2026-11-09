# **ESPN College Football Coaches Index**

Get every head coach ESPN tracks for a college football season, with
their name, ESPN ids, and the team they coached that year.

## Usage

``` r
espn_cfb_coaches(year = NULL, team_detail = TRUE)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2001

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

A data frame with one row per coach:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| coach_id | character | ESPN coach id. |
| first_name | character | Coach first name. |
| last_name | character | Coach last name. |
| team_id | character | ESPN id of the team coached that season (parsed from `team_ref`). |
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
| coach_ref | character | `$ref` URL to the season-scoped coach resource. |
| person_ref | character | `$ref` URL to the league-wide coach (person) resource. |
| team_ref | character | `$ref` URL to the per-season team resource. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/coaches`.
The index is `$ref`-paginated (~268 coaches across three pages); this
wrapper walks every page and dereferences each coach `$ref`, returning
one row per coach. The `coach_id` column is the value
[`espn_cfb_coach()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach.md)
accepts for the full per-coach detail (date of birth, birthplace,
career-record / coach-season counts).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# One request per coach (about 270 for a season), so this takes a while.
try(espn_cfb_coaches(year = 2024, team_detail = FALSE))
#> ── Coaches index from ESPN ─────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:00 UTC
#> # A tibble: 268 × 8
#>    season coach_id first_name last_name   team_id coach_ref  person_ref team_ref
#>     <int> <chr>    <chr>      <chr>       <chr>   <chr>      <chr>      <chr>   
#>  1   2024 5120149  Alex       Golesh      58      http://sp… http://sp… http://…
#>  2   2024 162030   Alex       Mortensen   NA      http://sp… http://sp… NA      
#>  3   2024 1954365  Major      Applewhite  6       http://sp… http://sp… http://…
#>  4   2024 4606657  Ryan       Silverfield 235     http://sp… http://sp… http://…
#>  5   2024 5119667  Kenny      Dillingham  9       http://sp… http://sp… http://…
#>  6   2024 4077317  Brent      Brennan     12      http://sp… http://sp… http://…
#>  7   2024 5218798  Tim        Skipper     278     http://sp… http://sp… http://…
#>  8   2024 5345545  Alonzo     Carter      NA      http://sp… http://sp… NA      
#>  9   2024 156919   Sean       Lewis       21      http://sp… http://sp… http://…
#> 10   2024 559953   Ken        Niumatalolo 23      http://sp… http://sp… http://…
#> # ℹ 258 more rows
```
