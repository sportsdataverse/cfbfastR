# **ESPN College Football Single-Team Power Index (Long Format)**

Get ESPN's College Football Power Index (FPI) detail for a single
team-season – the full set of predictive metrics and efficiency
components ESPN attaches to one team.

## Usage

``` r
espn_cfb_team_powerindex(team_id = NULL, year = NULL, team_detail = TRUE)
```

## Arguments

- team_id:

  (*Integer* required): ESPN team id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2005

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per metric:

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
| team_ref | character | `$ref` URL to the team-in-season resource. |
| last_updated | character | Timestamp ESPN last refreshed the power index. |
| metric_group | character | `predictive` or `efficiency`. |
| stat_name | character | Internal metric key (e.g. `fpi`, `offefficiency`). |
| abbreviation | character | Metric abbreviation. |
| display_name | character | Human-readable metric name. |
| value | numeric | Metric value. |
| display_value | character | Display-formatted metric value as shown on ESPN. |
| description | character | ESPN's description of the metric. |

## Details

Wraps the ESPN core-v2 single-team power-index endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/powerindex/{team_id}`.
Where
[`espn_cfb_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_powerindex.md)
returns the league-wide index, this wrapper drills into one team and
returns one row per metric in long format: every predictive metric (FPI,
projected wins, strength of record, ...) and every efficiency component
(offensive, defensive, special-teams efficiency, ...). The long shape is
deliberate – ESPN adds and retires metrics across seasons, and a long
frame absorbs that drift. Pivot wider with
[`tidyr::pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
keyed on `stat_name` for a wide table.

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
  try(espn_cfb_team_powerindex(team_id = 61, year = 2024))
#> ── Team Power Index data from ESPN ─────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:13:20 UTC
#> # A tibble: 43 × 21
#>    season team_id team_name team_abbreviation team_location team_display_name
#>     <int> <chr>   <chr>     <chr>             <chr>         <chr>            
#>  1   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  2   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  3   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  4   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  5   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  6   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  7   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  8   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  9   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 10   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 33 more rows
#> # ℹ 15 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, team_ref <chr>, last_updated <chr>,
#> #   metric_group <chr>, stat_name <chr>, abbreviation <chr>,
#> #   display_name <chr>, value <dbl>, display_value <chr>, description <chr>
  try(espn_cfb_team_powerindex(team_id = 61, year = 2024,
                               team_detail = FALSE))
#> ── Team Power Index data from ESPN ─────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:13:20 UTC
#> # A tibble: 43 × 11
#>    season team_id team_ref      last_updated metric_group stat_name abbreviation
#>     <int> <chr>   <chr>         <chr>        <chr>        <chr>     <chr>       
#>  1   2024 61      http://sport… 2024-12-15T… predictive   fpi       FPI         
#>  2   2024 61      http://sport… 2024-12-15T… predictive   fpirank   FPI         
#>  3   2024 61      http://sport… 2024-12-15T… predictive   projecte… PROJ W      
#>  4   2024 61      http://sport… 2024-12-15T… predictive   projecte… PROJ L      
#>  5   2024 61      http://sport… 2024-12-15T… predictive   projecte… PROJ TIE    
#>  6   2024 61      http://sport… 2024-12-15T… predictive   projecte… PROJ WIN% R…
#>  7   2024 61      http://sport… 2024-12-15T… predictive   probwino… WIN OUT%    
#>  8   2024 61      http://sport… 2024-12-15T… predictive   probwinc… WIN CONF%   
#>  9   2024 61      http://sport… 2024-12-15T… predictive   sosremai… REM SOS RNK 
#> 10   2024 61      http://sport… 2024-12-15T… predictive   accompli… SOR         
#> # ℹ 33 more rows
#> # ℹ 4 more variables: display_name <chr>, value <dbl>, display_value <chr>,
#> #   description <chr>
# }
```
