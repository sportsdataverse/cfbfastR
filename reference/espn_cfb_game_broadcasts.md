# **ESPN College Football Game Broadcasts**

Get the broadcast / streaming outlets carrying a single college football
game.

## Usage

``` r
espn_cfb_game_broadcasts(game_id = NULL)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

## Value

A data frame with one row per broadcast outlet:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| type_id | character | Broadcast-type id. |
| type_name | character | Broadcast-type name (e.g. `TV`, `Streaming`, `Radio`). |
| type_slug | character | Broadcast-type slug (e.g. `streaming`, `tv`). |
| station | character | Broadcast station / network name (e.g. `ESPN+`). |
| slug | character | Broadcast outlet slug. |
| channel | character | Channel number, when published. |
| priority | integer | ESPN display priority of the outlet (1 = first). |
| partnered | logical | `TRUE` if the outlet is an ESPN broadcast partner. |
| market_id | character | Geographic market id. |
| market_type | character | Geographic market type (e.g. `National`). |
| lang | character | Broadcast language code. |
| region | character | Broadcast region code. |
| media_id | character | ESPN media id for the outlet. |
| media_name | character | ESPN media name for the outlet. |
| media_short_name | character | Short ESPN media name for the outlet. |
| media_call_letters | character | Broadcast call letters for the outlet. |
| media_slug | character | ESPN media slug for the outlet. |
| media_group_id | character | ESPN media-group id (e.g. corporate parent). |
| media_group_name | character | ESPN media-group name (e.g. `Disney`). |
| media_group_slug | character | ESPN media-group slug. |
| competition_ref | character | `$ref` URL to the competition resource. |
| media_ref | character | `$ref` URL to the media resource. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/broadcasts`. Returns one row
per broadcast outlet – a television network, streaming service, or radio
station. `type_name` distinguishes TV / streaming / radio; `market_type`
is the geographic market (e.g. `National`); `priority` is ESPN's display
ordering of the outlets.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_game_broadcasts(game_id = 401628339))
#> ── Game broadcasts data from ESPN ──────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:54:27 UTC
#> # A tibble: 2 × 23
#>   game_id   type_id type_name type_slug station slug  channel priority partnered
#>   <chr>     <chr>   <chr>     <chr>     <chr>   <chr> <chr>      <int> <lgl>    
#> 1 401628339 4       Streaming streaming ESPN+   espn… 755            1 FALSE    
#> 2 401628339 4       Streaming streaming SECN+   sec-… 701            2 FALSE    
#> # ℹ 14 more variables: market_id <chr>, market_type <chr>, lang <chr>,
#> #   region <chr>, media_id <chr>, media_name <chr>, media_short_name <chr>,
#> #   media_call_letters <chr>, media_slug <chr>, media_group_id <chr>,
#> #   media_group_name <chr>, media_group_slug <chr>, competition_ref <chr>,
#> #   media_ref <chr>
# }
```
