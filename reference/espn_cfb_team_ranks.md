# **ESPN College Football Team Poll Rank History**

Get a college football team's poll-rank history for a season – one row
per poll (AP, Coaches, CFP Committee, ...) the team appeared in, with
current/previous rank, trend, and record.

## Usage

``` r
espn_cfb_team_ranks(
  team_id = NULL,
  year = NULL,
  week = NULL,
  team_detail = TRUE
)
```

## Arguments

- team_id:

  (*Integer* required): ESPN team id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2000

- week:

  (*Integer* optional): Regular-season week. When supplied, the team's
  rank at that specific week is returned.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per poll-rank:

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
| week | integer | Week of the rank occurrence. |
| poll_id | character | ESPN poll id (e.g. `21` = CFP Committee Rankings). |
| poll_name | character | Poll display name. |
| poll_short_name | character | Poll short name. |
| poll_type | character | Poll type code (e.g. `cfp`, `ap`, `usa`). |
| headline | character | Headline ESPN attaches to the poll release. |
| date | character | Date of the poll release. |
| current_rank | integer | Team's rank in this poll. |
| previous_rank | integer | Team's rank in the prior release of this poll. |
| trend | character | Rank movement string (e.g. `+3`, `-1`). |
| points | numeric | Voting points the team received. |
| first_place_votes | integer | First-place votes the team received. |
| record_summary | character | Team's win-loss record at the time of the poll. |

## Details

Wraps the ESPN core-v2 team ranks endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}/ranks`.
When a `week` is supplied the week-resolved variant is used instead:
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/2/weeks/{week}/teams/{team_id}/ranks`.
The index endpoint returns a `$ref` list of poll-rank resources; this
wrapper dereferences each one and returns a single row per poll with the
rank detail flattened. Without a `week`, ESPN returns the season's final
poll positions (one row per poll, plus postseason polls).

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
  try(espn_cfb_team_ranks(team_id = 61, year = 2024))
#> ── Team poll rank history from ESPN ────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:04:11 UTC
#> # A tibble: 4 × 25
#>   season team_id team_name team_abbreviation team_location team_display_name
#>    <int> <chr>   <chr>     <chr>             <chr>         <chr>            
#> 1   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 2   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 3   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 4   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 19 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, week <int>, poll_id <chr>, poll_name <chr>,
#> #   poll_short_name <chr>, poll_type <chr>, headline <chr>, date <chr>,
#> #   current_rank <int>, previous_rank <int>, trend <chr>, points <dbl>,
#> #   first_place_votes <int>, record_summary <chr>
  try(espn_cfb_team_ranks(team_id = 61, year = 2024,
                          team_detail = FALSE))
#> ── Team poll rank history from ESPN ────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:04:11 UTC
#> # A tibble: 4 × 15
#>   season team_id  week poll_id poll_name      poll_short_name poll_type headline
#>    <int> <chr>   <int> <chr>   <chr>          <chr>           <chr>     <chr>   
#> 1   2024 61         16 21      Playoff Commi… CFP Rankings    cfp       2024 NC…
#> 2   2024 61         16 22      College Footb… CFP Seedings    tourname… 2024 NC…
#> 3   2024 61          1 1       AP Top 25      AP Poll         ap        2024 NC…
#> 4   2024 61          1 2       AFCA Coaches … AFCA Coaches P… usa       2024 NC…
#> # ℹ 7 more variables: date <chr>, current_rank <int>, previous_rank <int>,
#> #   trend <chr>, points <dbl>, first_place_votes <int>, record_summary <chr>
# }
```
