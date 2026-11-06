# **Clear the cached CFB models**

The expected points, win probability, field goal and other models that
[calculate_cfb_models](https://cfbfastR.sportsdataverse.org/reference/calculate_cfb_models.md),
[`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
and
[`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
score with are downloaded from the `cfb_model_artifacts` release on
first use and cached in
`file.path(tools::R_user_dir("cfbfastR", "cache"), "models")`. A cached
copy is re-downloaded once it is older than
`getOption("cfbfastR.cache_duration")` seconds (default one day). Under
`R CMD check` the cache is in
[`tempdir()`](https://rdrr.io/r/base/tempfile.html) instead.

`cfb_clear_model_cache()` deletes that directory and drops the models
already loaded in this session, so the next call downloads them again.
The ESPN request cache is separate; see
[`espn_cfb_clear_cache()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_clear_cache.md).

## Usage

``` r
cfb_clear_model_cache()
```

## Value

Invisibly, the path of the directory that was cleared.

## See also

Other CFB Model Calculators:
[`calculate_cfb_models`](https://cfbfastR.sportsdataverse.org/reference/calculate_cfb_models.md),
[`cfb_model_card()`](https://cfbfastR.sportsdataverse.org/reference/cfb_model_card.md)

## Examples

``` r
cfb_clear_model_cache()
```
