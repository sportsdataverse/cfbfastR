# **ESPN College Football Recruits**

Get the ESPN recruiting-class catalog for a college football signing
class – one row per recruit, with athlete identity, position, physical
measurements, ESPN grade, the overall / position / state / region
rankings, the committed school, and the recruit's hometown and high
school.

## Usage

``` r
espn_cfb_recruits(year = NULL, max_results = 100)
```

## Arguments

- year:

  (*Integer* required): Recruiting class / signing year, 4 digit format
  (*YYYY*).  
  Minimum value accepted: 2006

- max_results:

  (*Integer* default 100): Maximum number of recruits to dereference and
  return. The index is alphabetical, so this returns the
  alphabetically-first `max_results` recruits; raise it to pull more of
  the class.

## Value

A data frame with one row per recruit:

|  |  |  |
|----|----|----|
| col_name | types | description |
| recruit_id | character | ESPN recruit id. |
| recruiting_class | integer | Recruiting class / signing year. |
| athlete_id | character | ESPN athlete id. |
| alternate_athlete_id | character | ESPN alternate athlete id (recruiting feed id). |
| first_name | character | Recruit first name. |
| last_name | character | Recruit last name. |
| full_name | character | Recruit full name. |
| display_name | character | Recruit display name. |
| short_name | character | Recruit short name. |
| position_id | character | ESPN position id. |
| position_abbreviation | character | Position abbreviation (e.g. `OT`, `WR`). |
| weight | numeric | Listed weight (lbs). |
| height | numeric | Listed height (inches). |
| grade | numeric | ESPN recruit grade (0-100; `0` = not rated). |
| grade_display_value | character | Display-formatted grade (`NR` when not rated). |
| overall_rank | integer | Overall recruit ranking (top recruits only; may be `NA`). |
| position_rank | integer | Position ranking. |
| state_rank | integer | State ranking. |
| region_rank | integer | Region ranking. |
| status_id | character | ESPN commitment status id. |
| status | character | Commitment status description (e.g. `Signed`). |
| committed_team_id | character | ESPN team id of the committed school (may be `NA`). |
| hometown_city | character | Recruit hometown city. |
| hometown_state | character | Recruit hometown state. |
| hometown_state_abbreviation | character | Recruit hometown state abbreviation. |
| high_school_id | character | ESPN high-school id. |
| high_school_name | character | Recruit high-school name. |
| recruit_ref | character | `$ref` URL to the recruit resource. |
| athlete_ref | character | Player-card URL for the recruit. |
| committed_team_ref | character | `$ref` URL to the committed team-in-season resource. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/recruits`.
The season index is `$ref`-paginated and large (roughly 3,700-4,900
recruits per class), so dereferencing every recruit would be thousands
of HTTP calls. ESPN exposes no pre-expanded recruiting endpoint – the
`site.web.api.espn.com` recruiting paths all 404 – so this wrapper caps
the walk at `max_results` recruits (default 100). Raise `max_results`
(e.g. to several hundred or higher) to pull more of the class, at the
cost of one extra HTTP call per recruit.

The index is returned by ESPN in athlete-name (alphabetical) order, not
ranking order, and the `sort` query parameter is ignored upstream. The
default `max_results = 100` therefore returns the alphabetically-first
100 recruits, not the top-100 ranked recruits. To rank the class, pull a
larger slice and sort the result on `overall_rank` (lower is better);
note ESPN only publishes an `overall_rank` for the highly-rated portion
of each class, so most recruits carry `NA` there. `position_rank`,
`state_rank`, and `region_rank` are populated more widely. `grade` is
ESPN's 0-100 recruit grade (`0` / `gradeDisplayValue = "NR"` means not
rated).

`committed_team_id` / `committed_team_ref` are resolved from the
recruit's `schools` array by matching a school whose commitment status
equals the recruit's top-level status (e.g. `Signed`); recruits still
uncommitted at fetch time leave both columns `NA`.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_recruits(year = 2024, max_results = 25))
#> ── Recruiting class data from ESPN ─────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:04:01 UTC
#> # A tibble: 25 × 31
#>    season recruit_id recruiting_class athlete_id alternate_athlete_id first_name
#>     <dbl> <chr>                 <int> <chr>      <chr>                <chr>     
#>  1   2024 255473                 2024 255473     5146775              David     
#>  2   2024 254466                 2024 254466     5138455              Jide      
#>  3   2024 257502                 2024 257502     NA                   Papa      
#>  4   2024 258479                 2024 258479     NA                   Na'eem    
#>  5   2024 257649                 2024 257649     NA                   Omari     
#>  6   2024 254482                 2024 254482     5138702              Adham     
#>  7   2024 250916                 2024 250916     5079289              Tawaski   
#>  8   2024 257098                 2024 257098     5173623              Frank     
#>  9   2024 258339                 2024 258339     NA                   Collins   
#> 10   2024 255259                 2024 255259     5145820              Cooper    
#> # ℹ 15 more rows
#> # ℹ 25 more variables: last_name <chr>, full_name <chr>, display_name <chr>,
#> #   short_name <chr>, position_id <chr>, position_abbreviation <chr>,
#> #   weight <dbl>, height <dbl>, grade <dbl>, grade_display_value <chr>,
#> #   overall_rank <int>, position_rank <int>, state_rank <int>,
#> #   region_rank <int>, status_id <chr>, status <chr>, committed_team_id <chr>,
#> #   hometown_city <chr>, hometown_state <chr>, …
# }
```
