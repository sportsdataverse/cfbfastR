# **ESPN College Football Position Detail**

Get the ESPN core-v2 detail record for a single college football player
position – name, display name, abbreviation, leaf flag, and the parent
position id.

## Usage

``` r
espn_cfb_position(position_id = NULL)
```

## Arguments

- position_id:

  (*Integer* required): ESPN position id.

## Value

A single-row data frame:

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
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/positions/{position_id}`.
[`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md)
returns the position index; this wrapper returns the single-position
detail for one id. ESPN's position table is a tree – specific positions
roll up under broader ones; the `leaf` flag marks the most specific
positions and `parent_id` (when present) reconstructs the grouping.
Returns a single-row tibble. Enumerate `position_id`s with
[`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_position(position_id = 8))
#> ── Position detail from ESPN ───────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:45 UTC
#> # A tibble: 1 × 7
#>   position_id name        display_name abbreviation leaf  parent_id position_ref
#>   <chr>       <chr>       <chr>        <chr>        <lgl> <chr>     <chr>       
#> 1 8           Quarterback Quarterback  QB           TRUE  70        http://spor…
# }
```
