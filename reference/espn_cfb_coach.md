# **ESPN College Football Coach Detail**

Get the ESPN core-v2 detail record for a single college football coach –
name, the team coached in the requested season, and a count of
career-record and coach-season entries ESPN has on file.

## Usage

``` r
espn_cfb_coach(coach_id = NULL, year = NULL, team_detail = TRUE)
```

## Arguments

- coach_id:

  (*Integer* required): ESPN coach id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*). Used to resolve
  the team the coach led that season.  
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

A single-row data frame:

|  |  |  |
|----|----|----|
| col_name | types | description |
| coach_id | character | ESPN coach id. |
| season | integer | Season (4-digit year) queried. |
| first_name | character | Coach first name. |
| last_name | character | Coach last name. |
| uid | character | ESPN coach UID string. |
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
| n_career_records | integer | Number of career-record entries ESPN has on file. |
| n_coach_seasons | integer | Number of coach-season entries ESPN has on file. |
| team_ref | character | `$ref` URL to the per-season team resource. |
| person_ref | character | `$ref` URL to the league-wide coach (person) resource. |

## Details

Wraps two ESPN core-v2 endpoints and merges them: the season-scoped
coach resource `seasons/{year}/coaches/{coach_id}` (supplies the team
coached that season) and the league-wide coach resource
`coaches/{coach_id}` (supplies the career-record and coach-season
counts). Returns a single-row tibble. Enumerate `coach_id`s with
[`espn_cfb_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coaches.md).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_coach(coach_id = 5120149, year = 2024))
#> ── Coach detail from ESPN ──────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:54:11 UTC
#> # A tibble: 1 × 20
#>   coach_id season first_name last_name uid   team_id team_name team_abbreviation
#>   <chr>     <int> <chr>      <chr>     <chr> <chr>   <chr>     <chr>            
#> 1 5120149    2024 Alex       Golesh    s:20… 58      Bulls     USF              
#> # ℹ 12 more variables: team_location <chr>, team_display_name <chr>,
#> #   team_short_display_name <chr>, team_nickname <chr>, team_color <chr>,
#> #   team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, n_career_records <int>, n_coach_seasons <int>,
#> #   team_ref <chr>, person_ref <chr>
  try(espn_cfb_coach(coach_id = 5120149, year = 2024, team_detail = FALSE))
#> ── Coach detail from ESPN ──────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:54:11 UTC
#> # A tibble: 1 × 10
#>   coach_id season first_name last_name uid              team_id n_career_records
#>   <chr>     <int> <chr>      <chr>     <chr>            <chr>              <int>
#> 1 5120149    2024 Alex       Golesh    s:20~l:23~co:51… 58                     2
#> # ℹ 3 more variables: n_coach_seasons <int>, team_ref <chr>, person_ref <chr>
# }
```
