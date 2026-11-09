# **ESPN College Football Team Coaches**

Get the coach associated with a college football team for the current
season – one row per coach, with name, birth detail, and experience.

## Usage

``` r
espn_cfb_team_coaches(
  team_id = NULL,
  year = most_recent_cfb_season(),
  team_detail = TRUE
)
```

## Arguments

- team_id:

  (*Integer* required): ESPN team id.

- year:

  DEPRECATED. (*Integer*): Season, 4 digit format (*YYYY*). Defaults to
  most recent CFB season.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per coach:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| team_id | character | ESPN team id. |
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
| coach_id | character | ESPN coach id. |
| first_name | character | Coach's first name. |
| last_name | character | Coach's last name. |
| date_of_birth | character | Coach's date of birth. |
| birth_city | character | City of birth. |
| birth_state | character | State of birth. |
| birth_country | character | Country of birth. |
| experience | integer | Years of experience ESPN credits the coach. |
| coach_ref | character | `$ref` URL to the core-v2 coach-in-season resource. |

## Details

Wraps the ESPN core-v2 team coaches endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}/coaches`.
The index endpoint returns a `$ref` list of coach resources; this
wrapper dereferences each one and returns a row per coach with the coach
detail flattened. Most teams list a single head coach per season.

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
  try(espn_cfb_team_coaches(team_id = 61))
#> ── Team coaches from ESPN ──────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:13:18 UTC
#> # A tibble: 1 × 21
#>   season team_id team_name team_abbreviation team_location team_display_name
#>    <int> <chr>   <chr>     <chr>             <chr>         <chr>            
#> 1   2026 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 15 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, coach_id <chr>, first_name <chr>,
#> #   last_name <chr>, date_of_birth <chr>, birth_city <chr>, birth_state <chr>,
#> #   birth_country <chr>, experience <int>, coach_ref <chr>
  try(espn_cfb_team_coaches(team_id = 61, team_detail = FALSE))
#> ── Team coaches from ESPN ──────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:13:18 UTC
#> # A tibble: 1 × 11
#>   season team_id coach_id first_name last_name date_of_birth     birth_city
#>    <int> <chr>   <chr>    <chr>      <chr>     <chr>             <chr>     
#> 1   2026 61      3960423  Kirby      Smart     1975-12-23T08:00Z Montgomery
#> # ℹ 4 more variables: birth_state <chr>, birth_country <chr>, experience <int>,
#> #   coach_ref <chr>
# }
```
