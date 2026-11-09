# **ESPN College Football Positions Index**

Get the catalog of player positions ESPN tracks for college football –
the position names, abbreviations, and ids used throughout ESPN's
athlete and roster resources.

## Usage

``` r
espn_cfb_positions()
```

## Value

A data frame with one row per position:

|              |           |                                                    |
|--------------|-----------|----------------------------------------------------|
| col_name     | types     | description                                        |
| position_id  | character | ESPN position id.                                  |
| name         | character | Position name (e.g. `Quarterback`).                |
| display_name | character | Human-readable position name.                      |
| abbreviation | character | Position abbreviation (e.g. `QB`).                 |
| leaf         | logical   | `TRUE` for a most-specific (leaf) position.        |
| parent_id    | character | ESPN id of the parent position (`NA` at the root). |
| position_ref | character | `$ref` URL to the position resource.               |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/positions`.
The index returns one `$ref` per position (~74); this wrapper
dereferences each and returns one row per position. ESPN's position
table is a tree – specific positions (e.g. left tackle) roll up under
broader ones (e.g. offensive line). The `leaf` flag marks the most
specific positions; `parent_id` (when present) reconstructs the
grouping.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# One request per position (about 75), so this takes several seconds.
try(espn_cfb_positions())
#> ── Positions index from ESPN ───────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:55:23 UTC
#> # A tibble: 74 × 7
#>    position_id name       display_name abbreviation leaf  parent_id position_ref
#>    <chr>       <chr>      <chr>        <chr>        <lgl> <chr>     <chr>       
#>  1 0           "Unknown"  Unknown      -            FALSE NA        http://spor…
#>  2 1           "Wide Rec… Wide Receiv… WR           TRUE  70        http://spor…
#>  3 2           "Left Tac… Left Tackle  LT           TRUE  46        http://spor…
#>  4 3           "Left Gua… Left Guard   LG           TRUE  47        http://spor…
#>  5 4           "Center"   Center       C            TRUE  70        http://spor…
#>  6 5           "Right Gu… Right Guard  RG           TRUE  46        http://spor…
#>  7 6           "Right Ta… Right Tackle RT           TRUE  47        http://spor…
#>  8 7           "Tight En… Tight End    TE           TRUE  70        http://spor…
#>  9 8           "Quarterb… Quarterback  QB           TRUE  70        http://spor…
#> 10 9           "Running … Running Back RB           TRUE  70        http://spor…
#> # ℹ 64 more rows
```
