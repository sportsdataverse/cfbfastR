# **ESPN College Football Player Statistics Overview**

Get the season-by-season statistics overview ESPN shows on a college
football player's player page – one row per season the player has
played, with the headline stat line for each.

## Usage

``` r
espn_cfb_player_overview(athlete_id = NULL, year = NULL, athlete_detail = TRUE)
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

A data frame with one row per season in the player's career table. The
leading columns are fixed; the trailing stat columns vary by position:

|  |  |  |
|----|----|----|
| col_name | types | description |
| athlete_id | character | ESPN athlete id. |
| season | integer | Season passed as the player-page context argument. |
| stat_season | character | Season this row's stat line describes. |
| athlete_display_name | character | Player display name; `athlete_detail = TRUE` only. |
| athlete_first_name | character | Player first name; `athlete_detail = TRUE` only. |
| athlete_last_name | character | Player last name; `athlete_detail = TRUE` only. |
| athlete_jersey | character | Player jersey number; `athlete_detail = TRUE` only. |
| athlete_position | character | Player position name; `athlete_detail = TRUE` only. |
| athlete_position_abbreviation | character | Player position abbreviation; `athlete_detail = TRUE` only. |
| ... | character | One column per stat in the `names` array (varies). |

## Details

Wraps the ESPN web-v3 endpoint
`site.web.api.espn.com/apis/common/v3/sports/football/college-football/athletes/{athlete_id}/overview`.
The overview payload's `statistics` block is the player's career summary
table: it carries a `splits` array with one entry per season the player
has played (most recent first), plus the `names` array of stat keys.
This wrapper returns that career table – one row per season – joining
each season's stat values to the `names` columns. Note that the `season`
argument selects the player's player-page context but the `statistics`
block is *always* the player's full multi-season career table; the
returned `stat_season` column identifies which season each row
describes. Stat columns vary by the player's position. For game-by-game
data use
[`espn_cfb_player_gamelog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_gamelog.md).

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
  try(espn_cfb_player_overview(athlete_id = 102597, year = 2024))
#> ── Player statistics overview from ESPN ────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:46 UTC
#> # A tibble: 5 × 24
#>   athlete_id season stat_season completions passing_attempts completion_pct
#>   <chr>       <int> <chr>       <chr>       <chr>            <chr>         
#> 1 102597       2024 2024        220         311              70.7          
#> 2 102597       2024 2023        142         237              59.9          
#> 3 102597       2024 2022        415         610              68.0          
#> 4 102597       2024 2021        505         683              73.9          
#> 5 102597       2024 2020        239         346              69.1          
#> # ℹ 18 more variables: passing_yards <chr>, yards_per_pass_attempt <chr>,
#> #   passing_touchdowns <chr>, interceptions <chr>, long_passing <chr>,
#> #   sacks <chr>, qb_rating <chr>, rushing_attempts <chr>, rushing_yards <chr>,
#> #   yards_per_rush_attempt <chr>, rushing_touchdowns <chr>, long_rushing <chr>,
#> #   athlete_display_name <chr>, athlete_first_name <chr>,
#> #   athlete_last_name <chr>, athlete_jersey <chr>, athlete_position <chr>,
#> #   athlete_position_abbreviation <chr>
  try(espn_cfb_player_overview(athlete_id = 102597, year = 2024,
                               athlete_detail = FALSE))
#> ── Player statistics overview from ESPN ────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:46 UTC
#> # A tibble: 5 × 18
#>   athlete_id season stat_season completions passing_attempts completion_pct
#>   <chr>       <int> <chr>       <chr>       <chr>            <chr>         
#> 1 102597       2024 2024        220         311              70.7          
#> 2 102597       2024 2023        142         237              59.9          
#> 3 102597       2024 2022        415         610              68.0          
#> 4 102597       2024 2021        505         683              73.9          
#> 5 102597       2024 2020        239         346              69.1          
#> # ℹ 12 more variables: passing_yards <chr>, yards_per_pass_attempt <chr>,
#> #   passing_touchdowns <chr>, interceptions <chr>, long_passing <chr>,
#> #   sacks <chr>, qb_rating <chr>, rushing_attempts <chr>, rushing_yards <chr>,
#> #   yards_per_rush_attempt <chr>, rushing_touchdowns <chr>, long_rushing <chr>
# }
```
