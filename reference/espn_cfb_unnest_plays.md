# **Unnest ESPN CFB drive plays into a flat play-by-play table**

Turn a
[`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)
result carrying a `plays` list-column (produced with `plays = "list"`)
into the flat one-row-per-play table – every play in the full
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
schema with its drive-level columns carried alongside, prefixed
`drive_`.

## Usage

``` r
espn_cfb_unnest_plays(drives)
```

## Arguments

- drives:

  (*data.frame* required): a data frame produced by
  `espn_cfb_game_drives(..., plays = "list")` – i.e. carrying a `plays`
  list-column of full-schema play tibbles.

## Value

A data frame with one row per play:

|  |  |  |
|----|----|----|
| col_name | types | description |
| drive_game_id | character | ESPN game identifier (drive-level column, `drive_`-prefixed). |
| drive_id | character | ESPN drive id the play belongs to (`drive_`-prefixed). |
| drive_result | character | Drive result code (`drive_`-prefixed; every drive-level column is carried with this prefix). |
| game_id | character | ESPN game identifier (play-level column). |
| play_id | character | ESPN play id. |
| ... |  | Every remaining [`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md) play column, plus any optional participant columns present in the embedded tibbles. |

## Details

Pure transform – no HTTP. `espn_cfb_unnest_plays()` unnests the `plays`
list-column appended by `espn_cfb_game_drives(..., plays = "list")` and
carries every drive-level column alongside each play, prefixed `drive_`
(e.g. `drive_id`, `drive_result`, `drive_yards`,
`drive_start_yard_line`) so it never collides with the play's own
columns. The result is identical in shape to
`espn_cfb_game_drives(..., plays = "expand")` – the same flat table, one
route via the `plays` argument, the other via this auxiliary function.

If `drives` does not carry a `plays` list-column the function aborts
with a message telling the caller to run
`espn_cfb_game_drives(..., plays = "list")` first.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_unnest_plays(espn_cfb_game_drives(401628339,
                                                 plays = "list")))
#> ── Game drive plays (unnested) data from ESPN ──────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:04:14 UTC
#> # A tibble: 156 × 106
#>    drive_game_id drive_drive_id drive_sequence_number drive_description     
#>    <chr>         <chr>          <chr>                 <chr>                 
#>  1 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  2 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  3 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  4 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  5 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  6 401628339     4016283391     1                     3 plays, 6 yards, 2:27
#>  7 401628339     4016283392     2                     1 play, 22 yards, 0:06
#>  8 401628339     4016283393     3                     3 plays, 1 yard, 2:06 
#>  9 401628339     4016283393     3                     3 plays, 1 yard, 2:06 
#> 10 401628339     4016283393     3                     3 plays, 1 yard, 2:06 
#> # ℹ 146 more rows
#> # ℹ 102 more variables: drive_team_id <chr>, drive_team_name <chr>,
#> #   drive_team_abbreviation <chr>, drive_team_location <chr>,
#> #   drive_team_display_name <chr>, drive_team_short_display_name <chr>,
#> #   drive_team_nickname <chr>, drive_team_color <chr>,
#> #   drive_team_alternate_color <chr>, drive_team_logo_href <chr>,
#> #   drive_team_logo_dark_href <chr>, drive_end_team_id <chr>, …
# }
```
