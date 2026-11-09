# **ESPN College Football Player Statistical Splits**

Get a single college football player's statistical splits for a season –
stat lines broken out by situation (by month, by quarter, by half, by
down, by field position, and more).

## Usage

``` r
espn_cfb_player_splits(athlete_id = NULL, year = NULL, athlete_detail = TRUE)
```

## Arguments

- athlete_id:

  (*Character/Integer* required): ESPN athlete id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2004

- athlete_detail:

  (*Logical*): when `TRUE` (default), fetch the requested athlete's ESPN
  record once and append the `athlete_*` name columns (see *Details*).
  Set `FALSE` to skip the fetch, reproducing the prior output exactly.

## Value

A data frame with one row per split. The leading columns are fixed; the
trailing stat columns vary by position:

|  |  |  |
|----|----|----|
| col_name | types | description |
| athlete_id | character | ESPN athlete id. |
| season | integer | Season (4-digit year). |
| category | character | Split category key (e.g. `byQuarter`, `byDown`). |
| category_display | character | Human-readable split category name. |
| split_name | character | Individual split name (e.g. `1st Quarter`). |
| split_abbr | character | Individual split abbreviation. |
| athlete_display_name | character | Player display name; `athlete_detail = TRUE` only. |
| athlete_first_name | character | Player first name; `athlete_detail = TRUE` only. |
| athlete_last_name | character | Player last name; `athlete_detail = TRUE` only. |
| athlete_jersey | character | Player jersey number; `athlete_detail = TRUE` only. |
| athlete_position | character | Player position name; `athlete_detail = TRUE` only. |
| athlete_position_abbreviation | character | Player position abbreviation; `athlete_detail = TRUE` only. |
| ... | character | One column per stat in the `names` array (varies). |

## Details

Wraps the ESPN web-v3 endpoint
`site.web.api.espn.com/apis/common/v3/sports/football/college-football/athletes/{athlete_id}/splits`.
ESPN groups splits under `splitCategories[]` (e.g. `byMonth`,
`byQuarter`, `byDown`, `byFieldPosition`); each category holds one or
more individual `splits` (e.g. the rows under `byQuarter` are
`1st Quarter`, `2nd Quarter`, ...). This wrapper returns one row per
individual split, tagged with its parent category, and joins the split's
stat values to the top-level `names` array for column names. Stat
columns vary by the player's position.

When `athlete_detail = TRUE` (the default) the requested athlete's ESPN
record is fetched once and the human-readable name columns
`athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
`athlete_jersey`, `athlete_position`, and
`athlete_position_abbreviation` are appended to every row. This is a
single cheap fetch – the wrapper already takes one `athlete_id`. A fetch
failure degrades the name columns to `NA` rather than erroring the
wrapper. Set `athlete_detail = FALSE` to skip the fetch and reproduce
the prior output exactly.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_player_splits(athlete_id = 102597, year = 2024))
#> ── Player statistical splits from ESPN ─────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:47 UTC
#> # A tibble: 60 × 27
#>    athlete_id season category category_display split_name split_abbr completions
#>    <chr>       <int> <chr>    <chr>            <chr>      <chr>      <chr>      
#>  1 102597       2024 split    split            Season     Season     220        
#>  2 102597       2024 split    split            Home       Home       143        
#>  3 102597       2024 split    split            Away       Away       77         
#>  4 102597       2024 byMonth  Month            September  Sept       90         
#>  5 102597       2024 byMonth  Month            October    Oct        62         
#>  6 102597       2024 byMonth  Month            November   Nov        48         
#>  7 102597       2024 byQuart… Quarter          1st        1st Qtr    66         
#>  8 102597       2024 byQuart… Quarter          2nd        2nd Qtr    66         
#>  9 102597       2024 byQuart… Quarter          3rd        3rd Qtr    49         
#> 10 102597       2024 byQuart… Quarter          4th        4th Qtr    39         
#> # ℹ 50 more rows
#> # ℹ 20 more variables: passing_attempts <chr>, passing_yards <chr>,
#> #   completion_pct <chr>, yards_per_pass_attempt <chr>,
#> #   passing_touchdowns <chr>, interceptions <chr>, long_passing <chr>,
#> #   sacks <chr>, qb_rating <chr>, rushing_attempts <chr>, rushing_yards <chr>,
#> #   yards_per_rush_attempt <chr>, rushing_touchdowns <chr>, long_rushing <chr>,
#> #   athlete_display_name <chr>, athlete_first_name <chr>, …
  try(espn_cfb_player_splits(athlete_id = 102597, year = 2024,
                             athlete_detail = FALSE))
#> ── Player statistical splits from ESPN ─────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:47 UTC
#> # A tibble: 60 × 21
#>    athlete_id season category category_display split_name split_abbr completions
#>    <chr>       <int> <chr>    <chr>            <chr>      <chr>      <chr>      
#>  1 102597       2024 split    split            Season     Season     220        
#>  2 102597       2024 split    split            Home       Home       143        
#>  3 102597       2024 split    split            Away       Away       77         
#>  4 102597       2024 byMonth  Month            September  Sept       90         
#>  5 102597       2024 byMonth  Month            October    Oct        62         
#>  6 102597       2024 byMonth  Month            November   Nov        48         
#>  7 102597       2024 byQuart… Quarter          1st        1st Qtr    66         
#>  8 102597       2024 byQuart… Quarter          2nd        2nd Qtr    66         
#>  9 102597       2024 byQuart… Quarter          3rd        3rd Qtr    49         
#> 10 102597       2024 byQuart… Quarter          4th        4th Qtr    39         
#> # ℹ 50 more rows
#> # ℹ 14 more variables: passing_attempts <chr>, passing_yards <chr>,
#> #   completion_pct <chr>, yards_per_pass_attempt <chr>,
#> #   passing_touchdowns <chr>, interceptions <chr>, long_passing <chr>,
#> #   sacks <chr>, qb_rating <chr>, rushing_attempts <chr>, rushing_yards <chr>,
#> #   yards_per_rush_attempt <chr>, rushing_touchdowns <chr>, long_rushing <chr>
# }
```
