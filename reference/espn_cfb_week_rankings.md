# **ESPN College Football Weekly Rankings**

Get the ranked teams from every poll ESPN published in a single week of
a college football season – the AP Top 25, the Coaches Poll, the CFP
committee rankings, and the computer polls, with each team's rank,
points, and first-place votes.

## Usage

``` r
espn_cfb_week_rankings(
  year = NULL,
  week = NULL,
  season_type = 2,
  team_detail = TRUE
)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2002

- week:

  (*Integer* required): Week number within the season type.

- season_type:

  (*Integer* default 2): ESPN season type id. `2` = regular season, `3`
  = postseason.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per poll-team:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| season_type | integer | ESPN season type id queried. |
| week | integer | Week number queried. |
| ranking_id | character | ESPN poll id. |
| ranking_name | character | Poll name (e.g. `AP Top 25`). |
| ranking_type | character | Poll type code (e.g. `ap`, `coaches`, `cfp`). |
| occurrence | character | Poll occurrence label (e.g. `Week 8`, `Preseason`). |
| rank_type | character | `ranked` for ranked teams, `others` for receiving-votes teams. |
| current_rank | integer | Current rank (`0` for receiving-votes teams). |
| previous_rank | integer | Rank in the previous poll (`0` if unranked). |
| points | numeric | Poll points awarded to the team. |
| first_place_votes | integer | Number of first-place votes received. |
| trend | character | Movement vs the previous poll (e.g. `-`, `+3`). |
| record_summary | character | Team record at the time of the poll (e.g. `7-1`). |
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
| team_ref | character | `$ref` URL to the per-season team resource. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/weeks/{week}/rankings`.
The week index returns one `$ref` per poll; this wrapper dereferences
each poll and returns one row per (poll x ranked team). Both the top-25
ranked teams (`rank_type = "ranked"`) and the receiving-votes teams ESPN
lists below the cutoff (`rank_type = "others"`) are included.

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to the
`team_id` column – `team_name`, `team_abbreviation`, `team_location`,
`team_display_name`, `team_short_display_name`, `team_nickname`,
`team_color`, `team_alternate_color`, `team_logo_href`, and
`team_logo_dark_href`, inserted immediately after `team_id`. A catalog
failure degrades to `NA` rather than erroring the wrapper. Set
`team_detail = FALSE` to skip the catalog fetch and the join; teams are
then returned as ESPN team ids only.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_week_rankings(year = 2024, week = 8))
#> ── Weekly rankings from ESPN ───────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:43:05 UTC
#> # A tibble: 210 × 26
#>    season season_type  week ranking_id ranking_name ranking_type occurrence
#>     <int>       <int> <int> <chr>      <chr>        <chr>        <chr>     
#>  1   2024           2     8 1          AP Top 25    ap           Week 8    
#>  2   2024           2     8 1          AP Top 25    ap           Week 8    
#>  3   2024           2     8 1          AP Top 25    ap           Week 8    
#>  4   2024           2     8 1          AP Top 25    ap           Week 8    
#>  5   2024           2     8 1          AP Top 25    ap           Week 8    
#>  6   2024           2     8 1          AP Top 25    ap           Week 8    
#>  7   2024           2     8 1          AP Top 25    ap           Week 8    
#>  8   2024           2     8 1          AP Top 25    ap           Week 8    
#>  9   2024           2     8 1          AP Top 25    ap           Week 8    
#> 10   2024           2     8 1          AP Top 25    ap           Week 8    
#> # ℹ 200 more rows
#> # ℹ 19 more variables: rank_type <chr>, current_rank <int>,
#> #   previous_rank <int>, points <dbl>, first_place_votes <int>, trend <chr>,
#> #   record_summary <chr>, team_id <chr>, team_name <chr>,
#> #   team_abbreviation <chr>, team_location <chr>, team_display_name <chr>,
#> #   team_short_display_name <chr>, team_nickname <chr>, team_color <chr>,
#> #   team_alternate_color <chr>, team_logo_href <chr>, …
  try(espn_cfb_week_rankings(year = 2024, week = 8, team_detail = FALSE))
#> ── Weekly rankings from ESPN ───────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:43:05 UTC
#> # A tibble: 210 × 16
#>    season season_type  week ranking_id ranking_name ranking_type occurrence
#>     <int>       <int> <int> <chr>      <chr>        <chr>        <chr>     
#>  1   2024           2     8 1          AP Top 25    ap           Week 8    
#>  2   2024           2     8 1          AP Top 25    ap           Week 8    
#>  3   2024           2     8 1          AP Top 25    ap           Week 8    
#>  4   2024           2     8 1          AP Top 25    ap           Week 8    
#>  5   2024           2     8 1          AP Top 25    ap           Week 8    
#>  6   2024           2     8 1          AP Top 25    ap           Week 8    
#>  7   2024           2     8 1          AP Top 25    ap           Week 8    
#>  8   2024           2     8 1          AP Top 25    ap           Week 8    
#>  9   2024           2     8 1          AP Top 25    ap           Week 8    
#> 10   2024           2     8 1          AP Top 25    ap           Week 8    
#> # ℹ 200 more rows
#> # ℹ 9 more variables: rank_type <chr>, current_rank <int>, previous_rank <int>,
#> #   points <dbl>, first_place_votes <int>, trend <chr>, record_summary <chr>,
#> #   team_id <chr>, team_ref <chr>
# }
```
