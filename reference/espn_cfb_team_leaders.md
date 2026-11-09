# **ESPN College Football Team Statistical Leaders**

Get a college football team's season statistical leaders – the top
athletes in each ESPN leader category (passing, rushing, receiving,
tackles, ...).

## Usage

``` r
espn_cfb_team_leaders(
  team_id = NULL,
  year = NULL,
  season_type = 2,
  team_detail = TRUE
)
```

## Arguments

- team_id:

  (*Integer* required): ESPN team id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2004

- season_type:

  (*Integer* default 2): ESPN season type. `2` = regular season, `3` =
  postseason.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per category-leader:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| season_type | integer | ESPN season type (2 = regular, 3 = postseason). |
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
| category_name | character | Leader category key (e.g. `passingLeader`). |
| category_display | character | Leader category display name. |
| leader_rank | integer | Rank of the athlete within the category (1 = top). |
| athlete_id | character | ESPN athlete id (parsed from `athlete_ref`). |
| value | numeric | Leading stat value. |
| display_value | character | Display-formatted stat line. |
| athlete_ref | character | `$ref` URL to the athlete-in-season resource. |

## Details

Wraps the ESPN core-v2 team leaders endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/teams/{team_id}/leaders`.
ESPN groups leaders into categories and ranks several athletes within
each. This wrapper flattens that to long format: one row per (category x
ranked athlete), with `leader_rank` preserving the order ESPN returns.
Athletes are returned as ESPN athlete ids; join to
[`espn_cfb_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_roster.md)
for names.

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
  try(espn_cfb_team_leaders(team_id = 61, year = 2024))
#> ── Team statistical leaders from ESPN ──────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:58 UTC
#> # A tibble: 176 × 20
#>    season season_type team_id team_name team_abbreviation team_location
#>     <int>       <int> <chr>   <chr>     <chr>             <chr>        
#>  1   2024           2 61      Bulldogs  UGA               Georgia      
#>  2   2024           2 61      Bulldogs  UGA               Georgia      
#>  3   2024           2 61      Bulldogs  UGA               Georgia      
#>  4   2024           2 61      Bulldogs  UGA               Georgia      
#>  5   2024           2 61      Bulldogs  UGA               Georgia      
#>  6   2024           2 61      Bulldogs  UGA               Georgia      
#>  7   2024           2 61      Bulldogs  UGA               Georgia      
#>  8   2024           2 61      Bulldogs  UGA               Georgia      
#>  9   2024           2 61      Bulldogs  UGA               Georgia      
#> 10   2024           2 61      Bulldogs  UGA               Georgia      
#> # ℹ 166 more rows
#> # ℹ 14 more variables: team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, category_name <chr>,
#> #   category_display <chr>, leader_rank <int>, athlete_id <chr>, value <dbl>,
#> #   display_value <chr>, athlete_ref <chr>
  try(espn_cfb_team_leaders(team_id = 61, year = 2024,
                            team_detail = FALSE))
#> ── Team statistical leaders from ESPN ──────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:58 UTC
#> # A tibble: 176 × 10
#>    season season_type team_id category_name category_display leader_rank
#>     <int>       <int> <chr>   <chr>         <chr>                  <int>
#>  1   2024           2 61      passingLeader Passing Leader             1
#>  2   2024           2 61      passingLeader Passing Leader             2
#>  3   2024           2 61      passingLeader Passing Leader             3
#>  4   2024           2 61      rushingLeader Rushing Leader             1
#>  5   2024           2 61      rushingLeader Rushing Leader             2
#>  6   2024           2 61      rushingLeader Rushing Leader             3
#>  7   2024           2 61      rushingLeader Rushing Leader             4
#>  8   2024           2 61      rushingLeader Rushing Leader             5
#>  9   2024           2 61      rushingLeader Rushing Leader             6
#> 10   2024           2 61      rushingLeader Rushing Leader             7
#> # ℹ 166 more rows
#> # ℹ 4 more variables: athlete_id <chr>, value <dbl>, display_value <chr>,
#> #   athlete_ref <chr>
# }
```
