# **Read the published contract for a CFB model**

Each model in the `cfb_model_artifacts` bundle ships a
`<model>.card.json` carrying the ordered `features` array it was trained
with and, where the model consumes one, an `era_contract`. Reading that
contract lets a caller's frame be validated against the artifact itself
rather than a feature list restated in this package – the duplication
that produced cfbfastR-cfb-data#70, where this package kept a private
2017 era cut the trainer never used and 2018-2020 scored an era off the
models trained with them.

- `cfb_model_card()`: the parsed card.

- `cfb_card_features()`: the model's feature names, in trained order.

- `cfb_card_era_contract()`: the era encoding, or `NULL`.

- `cfb_card_reset_cache()`: drop the in-session card cache.

## Usage

``` r
cfb_model_card(model)

cfb_card_features(model)

cfb_card_era_contract(model)

cfb_card_reset_cache()
```

## Arguments

- model:

  (*String* required): Bundle stem, e.g. `"ep_model"` or `"wp_spread"`.

## Value

`cfb_model_card()` - A list with the card's fields, including:

|  |  |  |
|----|----|----|
| col_name | types | description |
| model_type | character | Model family, e.g. "ep", "fg", "xpass". |
| label | character | Training label the model was fit against. |
| features | character | Ordered feature names the booster was trained with. |
| era_contract | list | Era encoding and cutpoints, or `NULL` when the model uses no era. |

`cfb_card_features()` - A character vector of feature names in the order
the booster was trained with. Order is load-bearing: xgboost aligns a
DMatrix by position, so a sorted or re-derived list scores against the
wrong columns without ever erroring.

`cfb_card_era_contract()` - A list with `encoding` (`"ordinal"` or
`"one_hot"`), `columns` and `cuts`, or `NULL` when the model consumes no
era feature. `NULL` is correct for `ep_model`, `wp_naive`, `wp_spread`
and `cfb_cp_model`.

`cfb_card_reset_cache()` - Invisibly `NULL`, called for its effect.

## See also

Other CFB Model Calculators:
[`calculate_cfb_models`](https://cfbfastR.sportsdataverse.org/reference/calculate_cfb_models.md)

## Examples

``` r
# \donttest{
  try(cfb_card_features("ep_model"))
#> [1] "TimeSecsRem"          "yards_to_goal"        "distance"            
#> [4] "down_1"               "down_2"               "down_3"              
#> [7] "down_4"               "pos_score_diff_start"
# }
```
