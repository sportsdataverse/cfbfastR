# **ESPN College Football Award Detail**

Get the ESPN core-v2 detail record for a single college football award
in a given season – name, description, history, and the athlete (and
team) that won it.

## Usage

``` r
espn_cfb_award(award_id = NULL, year = NULL, team_detail = TRUE)
```

## Arguments

- award_id:

  (*Integer* required): ESPN award id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*). Minimum value
  accepted: 1935

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

A data frame with one row per award-winner:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year) queried. |
| award_id | character | ESPN award id. |
| name | character | Award name (e.g. `Buck Buchanan Award`). |
| description | character | ESPN's short description of the award. |
| history | character | ESPN's long-form history text for the award. |
| athlete_id | character | ESPN id of the winning athlete (parsed from `athlete_ref`); `NA` if none. |
| team_id | character | ESPN id of the winner's team (parsed from `team_ref`); `NA` if none. |
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
| award_ref | character | `$ref` URL to the award resource. |
| athlete_ref | character | `$ref` URL to the winning athlete resource (may be `NA`). |
| team_ref | character | `$ref` URL to the winner's team resource (may be `NA`). |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/awards/{award_id}`.
[`espn_cfb_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_awards.md)
returns the season award index; this wrapper returns the single-award
detail (including the long-form `history` text) for one id. Returns one
row per (award x winner) – most awards have a single winner, so the
table is typically one row. An award with no winner recorded yet still
contributes one row with `athlete_id`/`team_id` left `NA`. Winners are
returned as ESPN athlete and team ids only – join to an athlete source
for names. Enumerate `award_id`s with
[`espn_cfb_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_awards.md).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_award(award_id = 1, year = 2024))
#> ── Award detail from ESPN ──────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:11:41 UTC
#> # A tibble: 1 × 20
#>   season award_id name          description history athlete_id team_id team_name
#>    <int> <chr>    <chr>         <chr>       <chr>   <chr>      <chr>   <chr>    
#> 1   2024 1        Buck Buchana… I-AA Defen… "The S… 5085355    2110    Bears    
#> # ℹ 12 more variables: team_abbreviation <chr>, team_location <chr>,
#> #   team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, award_ref <chr>,
#> #   athlete_ref <chr>, team_ref <chr>
  try(espn_cfb_award(award_id = 1, year = 2024, team_detail = FALSE))
#> ── Award detail from ESPN ──────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:11:41 UTC
#> # A tibble: 1 × 10
#>   season award_id name          description history athlete_id team_id award_ref
#>    <int> <chr>    <chr>         <chr>       <chr>   <chr>      <chr>   <chr>    
#> 1   2024 1        Buck Buchana… I-AA Defen… "The S… 5085355    2110    http://s…
#> # ℹ 2 more variables: athlete_ref <chr>, team_ref <chr>
# }
```
