# **Get College Football Playoff participants**

**Get College Football Playoff participants** Returns the teams that
participated in the College Football Playoff for a season.

## Usage

``` r
cfbd_playoffs_cfp_participants(year, proxy = NULL)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digits (YYYY).  
  Minimum value accepted: 2014

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_playoffs_cfp_participants()` - A tibble with 12 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| committee_rank | integer | Selection-committee rank. |
| seed | integer | Seed in the bracket. |
| bid_type | character | How the team qualified (`automatic` or `at_large`). |
| qualification_reason | character | Stated reason the team qualified. |
| conference_champion | logical | TRUE if the team won its conference. |
| qualifying_conference | character | Conference through which the team qualified. |
| first_round_bye | logical | TRUE if the team received a first-round bye. |
| outcome | character | Outcome of the team's playoff run. |
| eliminated_round | character | Round in which the team was eliminated. |
| team_id | integer | Referencing team id. |
| team_school | character | School name of the team. |
| team_conference | character | Conference the team belongs to. |

## See also

Other CFBD Playoff Functions:
[`cfbd_playoffs_cfp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs_cfp.md),
[`cfbd_playoffs_cfp_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs_cfp_games.md)

## Examples

``` r
# \donttest{
  try(cfbd_playoffs_cfp_participants(year = 2024))
#> ── Get College Football Playoff participants from CollegeFootballData.com ──────
#> ℹ Data updated: 2026-08-27 20:25:57 UTC
#> # A tibble: 12 × 12
#>    committee_rank  seed bid_type  qualification_reason       conference_champion
#>             <int> <int> <chr>     <chr>                      <lgl>              
#>  1              1     1 automatic Conference champion autom… TRUE               
#>  2              2     2 automatic Conference champion autom… TRUE               
#>  3              9     3 automatic Conference champion autom… TRUE               
#>  4             12     4 automatic Conference champion autom… TRUE               
#>  5              3     5 at_large  CFP selection committee a… FALSE              
#>  6              4     6 at_large  CFP selection committee a… FALSE              
#>  7              5     7 at_large  CFP selection committee a… FALSE              
#>  8              6     8 at_large  CFP selection committee a… FALSE              
#>  9              7     9 at_large  CFP selection committee a… FALSE              
#> 10              8    10 at_large  CFP selection committee a… FALSE              
#> 11             10    11 at_large  CFP selection committee a… FALSE              
#> 12             16    12 automatic Conference champion autom… TRUE               
#> # ℹ 7 more variables: qualifying_conference <chr>, first_round_bye <lgl>,
#> #   outcome <chr>, eliminated_round <chr>, team_id <int>, team_school <chr>,
#> #   team_conference <chr>
# }
```
