# **ESPN College Football Groups & Conferences**

Get the full ESPN group hierarchy for a college football season – the
division roll-ups (Division I, FBS, FCS) and every conference nested
beneath them, flattened into one catalog table.

## Usage

``` r
espn_cfb_groups(year = NULL, season_type = 2)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2001

- season_type:

  (*Integer* default 2): ESPN season type id. `2` = regular season is
  the sensible default.

## Value

A data frame with one row per group:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| season_type | integer | ESPN season type id queried. |
| group_id | character | ESPN group id. |
| name | character | Group / conference name. |
| abbreviation | character | Group abbreviation. |
| short_name | character | Group short name. |
| is_conference | logical | `TRUE` for an actual conference, `FALSE` for a division roll-up. |
| parent_group_id | character | `group_id` of the parent node (`NA` at the root). |
| slug | character | Group slug. |
| group_ref | character | `$ref` URL to the group resource. |
| standings_ref | character | `$ref` URL to the group standings resource. |
| teams_ref | character | `$ref` URL to the group teams index. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/groups`.
ESPN's group index only exposes two top-level groups; the conferences
sit several levels deep under `children`. This wrapper walks the tree
recursively, dereferencing every node, and returns one row per group.
Filter `is_conference == TRUE` for the actual conferences (ACC, SEC, Big
Ten, ...); the `group_id` of a conference is what
[`espn_cfb_standings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_standings.md)
accepts as `group_id`. The `parent_group_id` column lets you reconstruct
the division -\> conference nesting.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# One request per conference and division, so this takes a while.
try(espn_cfb_groups(year = 2024))
#> ── Groups and conferences from ESPN ────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:55:03 UTC
#> # A tibble: 78 × 12
#>    season season_type group_id name        abbreviation short_name is_conference
#>     <int>       <int> <chr>    <chr>       <chr>        <chr>      <lgl>        
#>  1   2024           2 35       Division I… yy           Div II/III FALSE        
#>  2   2024           2 57       NCAA Divis… d2           NCAA Divi… FALSE        
#>  3   2024           2 104      CIAA        ciaa         CIAA       TRUE         
#>  4   2024           2 107      GLIAC       gliac        GLIAC      TRUE         
#>  5   2024           2 146      Great Amer… gamc         Great Ame… TRUE         
#>  6   2024           2 108      Great Lakes gl           Great Lak… TRUE         
#>  7   2024           2 165      Great Midw… G-MAC        Great Mid… TRUE         
#>  8   2024           2 110      Gulf South  gs           Gulf South TRUE         
#>  9   2024           2 112      Independen… ind2         Independe… TRUE         
#> 10   2024           2 116      Lone Star   lone         Lone Star  TRUE         
#> # ℹ 68 more rows
#> # ℹ 5 more variables: parent_group_id <chr>, slug <chr>, group_ref <chr>,
#> #   standings_ref <chr>, teams_ref <chr>
```
