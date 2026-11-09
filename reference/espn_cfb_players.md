# **ESPN College Football Players Index**

Get a paginated index of ESPN college football players for a season.
Each row is one player reference (id + `$ref` URL); dereference a row
with
[`espn_cfb_player()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player.md)
to retrieve the full player record.

## Usage

``` r
espn_cfb_players(
  year = NULL,
  page = 1,
  max_pages = 1,
  limit = 100,
  athlete_detail = FALSE
)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 1936

- page:

  (*Integer* optional, default 1): First page of the index to fetch.

- max_pages:

  (*Integer* optional, default 1): Number of consecutive pages to fetch
  starting at `page`. Each page holds `limit` players.

- limit:

  (*Integer* optional, default 100): Players per page (ESPN page size).

- athlete_detail:

  (*Logical*): when `TRUE`, dereference each player returned and append
  the `athlete_*` name columns (see *Details*). This costs one HTTP call
  per player, so it defaults to `FALSE`; setting it `FALSE` reproduces
  the prior output exactly.

## Value

A data frame with one row per player reference:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| athlete_id | character | ESPN athlete id (parsed from `athlete_ref`). |
| athlete_ref | character | `$ref` URL to the athlete-in-season resource. |
| page | integer | Index page this player was returned on. |
| page_count | integer | Total number of pages in the season index. |
| count | integer | Total number of players in the season index. |
| athlete_display_name | character | Player display name; `athlete_detail = TRUE` only. |
| athlete_first_name | character | Player first name; `athlete_detail = TRUE` only. |
| athlete_last_name | character | Player last name; `athlete_detail = TRUE` only. |
| athlete_jersey | character | Player jersey number; `athlete_detail = TRUE` only. |
| athlete_position | character | Player position name; `athlete_detail = TRUE` only. |
| athlete_position_abbreviation | character | Player position abbreviation; `athlete_detail = TRUE` only. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/athletes`.
The season-scoped index contains roughly 99,500 players, returned in
fixed-size pages – this wrapper deliberately returns *id + `$ref` rows
only* and never dereferences the individual player records, because a
full crawl would be tens of thousands of HTTP calls. Walk the index a
page at a time with `page`, and cap how far a single call goes with
`max_pages`. The total page count for the season is reported in the
`page_count` column so a caller can drive its own pagination loop. To
resolve an individual player to a full record, pass its `athlete_id` to
[`espn_cfb_player()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player.md).

When `athlete_detail = TRUE` the index is enriched with the
human-readable name columns `athlete_display_name`,
`athlete_first_name`, `athlete_last_name`, `athlete_jersey`,
`athlete_position`, and `athlete_position_abbreviation`. There is no
bulk athlete-name catalog, so resolving names here costs **one HTTP call
per player returned** – with the default `limit = 100` that is 100 extra
requests per page. It therefore defaults to `FALSE`. A per-athlete fetch
failure leaves that player's name columns `NA` rather than erroring the
wrapper. Keep `limit` small (or `athlete_detail = FALSE`) when walking
many pages.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_players(year = 2024, page = 1, max_pages = 1))
#> ── Players index from ESPN ─────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:50 UTC
#> # A tibble: 100 × 6
#>    season athlete_id athlete_ref                          page page_count  count
#>     <int> <chr>      <chr>                               <int>      <int>  <int>
#>  1   2024 2027901    http://sports.core.api.espn.com/v2…     1       1038 103740
#>  2   2024 2488274    http://sports.core.api.espn.com/v2…     1       1038 103740
#>  3   2024 2586732    http://sports.core.api.espn.com/v2…     1       1038 103740
#>  4   2024 2586749    http://sports.core.api.espn.com/v2…     1       1038 103740
#>  5   2024 2586765    http://sports.core.api.espn.com/v2…     1       1038 103740
#>  6   2024 2586812    http://sports.core.api.espn.com/v2…     1       1038 103740
#>  7   2024 2988219    http://sports.core.api.espn.com/v2…     1       1038 103740
#>  8   2024 2988246    http://sports.core.api.espn.com/v2…     1       1038 103740
#>  9   2024 539758     http://sports.core.api.espn.com/v2…     1       1038 103740
#> 10   2024 3145545    http://sports.core.api.espn.com/v2…     1       1038 103740
#> # ℹ 90 more rows
  try(espn_cfb_players(year = 2024, page = 1, max_pages = 1, limit = 5,
                       athlete_detail = TRUE))
#> ── Players index from ESPN ─────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:51 UTC
#> # A tibble: 5 × 12
#>   season athlete_id athlete_ref      page page_count  count athlete_display_name
#>    <int> <chr>      <chr>           <int>      <int>  <int> <chr>               
#> 1   2024 2027901    http://sports.…     1      20748 103740 NA                  
#> 2   2024 2488274    http://sports.…     1      20748 103740 NA                  
#> 3   2024 2586732    http://sports.…     1      20748 103740 NA                  
#> 4   2024 2586749    http://sports.…     1      20748 103740 NA                  
#> 5   2024 2586765    http://sports.…     1      20748 103740 NA                  
#> # ℹ 5 more variables: athlete_first_name <chr>, athlete_last_name <chr>,
#> #   athlete_jersey <chr>, athlete_position <chr>,
#> #   athlete_position_abbreviation <chr>
# }
```
