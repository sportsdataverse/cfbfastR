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
if (FALSE) { # interactive()
# One request per position (about 75), so this takes several seconds.
try(espn_cfb_positions())
}
```
