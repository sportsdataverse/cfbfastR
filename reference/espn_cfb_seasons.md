# **ESPN College Football Seasons Index**

Get the index of every college football season ESPN tracks in its
core-v2 API, with each season's start and end dates.

## Usage

``` r
espn_cfb_seasons()
```

## Value

A data frame with one row per season:

|              |           |                                         |
|--------------|-----------|-----------------------------------------|
| col_name     | types     | description                             |
| season       | integer   | Season (4-digit year).                  |
| display_name | character | ESPN display name for the season.       |
| start_date   | character | Season start timestamp (ISO 8601, UTC). |
| end_date     | character | Season end timestamp (ISO 8601, UTC).   |
| season_ref   | character | `$ref` URL to the season resource.      |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons`.
The index is `$ref`-paginated; this wrapper walks every page,
dereferences each season `$ref`, and returns one row per season. ESPN's
CFB season coverage runs back to the early 1900s, so the table is long –
filter on `season` for the years you need. Use
[`espn_cfb_season_info()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_info.md)
for the full per-season detail (season types, rankings, awards, futures
refs).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
if (FALSE) { # interactive()
# One request per season back to the early 1900s (about 150), so this takes
# a while.
try(espn_cfb_seasons())
}
```
