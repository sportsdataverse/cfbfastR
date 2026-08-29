# Calculate QBR for each quarterback in a modeled play-by-play frame

Aggregates a modeled play-by-play frame into the per-quarterback,
per-game weighted EPA components the bundled `qbr_model` takes, and
scores it.

The five EPA components are leverage-weighted means over the plays a
quarterback was involved in: every play (`qbr_epa`), non-fumble sacks
(`sack_epa`), passes (`pass_epa`), rushes (`rush_epa`) and penalties
(`pen_epa`). The weight discounts garbage time: a play taken with the
game already decided (`home_wp_before` below 0.1 or above 0.9) counts
0.6, one taken while it is nearly decided (0.1 to 0.2, or 0.8 to 0.9)
counts 0.9, and everything in the competitive middle counts fully. The
EPA feeding them is clipped at -5, with a flat -3.5 charged for a
fumble.

Only players who actually threw a pass are included; a running back's
carries are aggregated into the quarterback's line only when that player
also attempted a pass in the game.

## Usage

``` r
create_qbr(play_df, qbr_model = NULL, season = NULL)
```

## Arguments

- play_df:

  A modeled play-by-play data frame, as returned by
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
  or
  [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md).
  Must carry `EPA`, `home_wp_before`, the `pass` / `rush` / `sack_vec` /
  `fumble_vec` / `penalty_flag` play flags, `passer_player_name` /
  `rusher_player_name` and `pos_team`. `spread` and `home` are
  additionally needed for the `spread` feature.

- qbr_model:

  Optional pre-loaded `xgb.Booster`. Defaults to the bundled
  `qbr_model.ubj` from the shared `cfb_model_artifacts` release.

- season:

  Optional season, used for the one-hot rule era when the frame carries
  no `season` column.

## Value

A data frame, one row per quarterback per game, with:

|              |           |
|--------------|-----------|
| col_name     | types     |
| game_id      | character |
| pos_team     | character |
| athlete_name | character |
| plays        | integer   |
| qbr_epa      | double    |
| sack_epa     | double    |
| pass_epa     | double    |
| rush_epa     | double    |
| pen_epa      | double    |
| spread       | double    |
| era0         | double    |
| era1         | double    |
| era2         | double    |
| era3         | double    |
| exp_qbr      | double    |

A component with no qualifying plays is `NA` rather than 0 – that is the
missing-value branch the model was trained against. `exp_qbr` is `NA`
when the bundled model or `xgboost` is unavailable; probabilities and
ratings are never fabricated. A frame with no identifiable quarterbacks
returns a zero-row frame carrying this schema.

## Examples

``` r
# \donttest{
  try({
    pbp <- cfbfastR::cfbd_pbp_data(2021, week = 6, team = "Texas", epa_wpa = TRUE)
    create_qbr(pbp)
  })
#> ── QBR data ───────────────────────────────────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-08-29 13:13:09 UTC
#> # A tibble: 3 × 15
#>   game_id pos_team athlete_name plays qbr_epa sack_epa pass_epa rush_epa pen_epa
#>   <chr>   <chr>    <chr>        <int>   <dbl>    <dbl>    <dbl>    <dbl>   <dbl>
#> 1 401287… Oklahoma Caleb Willi…    29   0.611       NA    0.321     2.79   NA   
#> 2 401287… Oklahoma Spencer Rat…    20  -0.556       NA   -0.381    -1.34   NA   
#> 3 401287… Texas    Casey Thomp…    39   0.153       NA    0.258    -1.28   -1.08
#> # ℹ 6 more variables: spread <dbl>, era0 <dbl>, era1 <dbl>, era2 <dbl>,
#> #   era3 <dbl>, exp_qbr <dbl>
# }
```
