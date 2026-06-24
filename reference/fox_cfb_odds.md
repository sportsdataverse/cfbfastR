# **Get Fox Sports college football game odds**

Flattens the Bifrost `event/{id}/odds` matchup six-pack (spread / to win
/ total).

## Usage

``` r
fox_cfb_odds(game_id)
```

## Arguments

- game_id:

  (character/numeric, required): Fox Bifrost event id (e.g. `"41616"`).

## Value

A `cfbfastR`-tagged tibble with one row per team:

- `game_id`: character.: Fox event id echoed back.

- `team`: character.: Team full name.

- `spread`: character.: Point spread.

- `to_win`: character.: Moneyline ("to win").

- `total`: character.: Over/under total.

Returns an empty tibble when no market is posted for the game.

## Examples

``` r
# \donttest{
  try(fox_cfb_odds(game_id = "41616"))
#> ── Game odds from Fox Sports (Bifrost) ─────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-24 02:08:38 UTC
#> # A tibble: 2 × 5
#>   game_id team                      spread to_win total 
#>   <chr>   <chr>                     <chr>  <chr>  <chr> 
#> 1 41616   Kent State Golden Flashes +44.5  +2500  O 56.5
#> 2 41616   Florida State Seminoles   -44.5  -10000 U 56.5
# }
```
