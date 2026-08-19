# **Get Fox Sports college football play-by-play**

Flattens the Bifrost `event/{id}/data` play-by-play layout (quarters -\>
drives -\> plays) into one tidy play-level tibble.

## Usage

``` r
fox_cfb_pbp(game_id)
```

## Arguments

- game_id:

  (character/numeric, required): Fox Bifrost event id (e.g. `"41616"`).
  This is the Fox event id, not the ESPN game id.

## Value

A `cfbfastR`-tagged tibble with one row per play:

- `game_id`: character.: Fox event id echoed back.

- `quarter`: character.: Period title (e.g. "1ST QUARTER", "OVERTIME").

- `drive_id`: character.: Drive identifier within the game.

- `drive_result`: character.: Drive outcome (e.g. "TOUCHDOWN", "PUNT").

- `drive_summary`: character.: Drive summary ("4 plays, 65 yards,
  1:21").

- `drive_team`: character.: Team on offense for the drive.

- `play_id`: character.: Play identifier.

- `period`: character.: Period of the play ("1ST", "OT").

- `clock`: character.: Game clock at the play ("15:00").

- `field_position`: character.: Field-position label ("KENT 35").

- `play_text`: character.: Full play description.

- `play_team`: character.: Team credited with the play.

## Examples

``` r
# \donttest{
  try(fox_cfb_pbp(game_id = "41616"))
#> ── Play-by-play data from Fox Sports (Bifrost) ─────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 12:31:38 UTC
#> # A tibble: 180 × 12
#>    game_id quarter drive_id drive_result drive_summary drive_team play_id period
#>    <chr>   <chr>   <chr>    <chr>        <chr>         <chr>      <chr>   <chr> 
#>  1 41616   1ST QU… 45532    TOUCHDOWN    4 plays · 65… FLORIDA S… 1       1ST   
#>  2 41616   1ST QU… 45532    TOUCHDOWN    4 plays · 65… FLORIDA S… 2       1ST   
#>  3 41616   1ST QU… 45532    TOUCHDOWN    4 plays · 65… FLORIDA S… 3       1ST   
#>  4 41616   1ST QU… 45532    TOUCHDOWN    4 plays · 65… FLORIDA S… 4       1ST   
#>  5 41616   1ST QU… 45532    TOUCHDOWN    4 plays · 65… FLORIDA S… 5       1ST   
#>  6 41616   1ST QU… 45532    TOUCHDOWN    4 plays · 65… FLORIDA S… 6       1ST   
#>  7 41616   1ST QU… 45539    PUNT         3 plays · 7 … KENT STAT… 7       1ST   
#>  8 41616   1ST QU… 45539    PUNT         3 plays · 7 … KENT STAT… 8       1ST   
#>  9 41616   1ST QU… 45539    PUNT         3 plays · 7 … KENT STAT… 9       1ST   
#> 10 41616   1ST QU… 45539    PUNT         3 plays · 7 … KENT STAT… 10      1ST   
#> # ℹ 170 more rows
#> # ℹ 4 more variables: clock <chr>, field_position <chr>, play_text <chr>,
#> #   play_team <chr>
# }
```
