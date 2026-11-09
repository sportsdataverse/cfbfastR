# Get ESPN college football PBP data

Get ESPN college football PBP data

## Usage

``` r
espn_cfb_pbp(game_id, epa_wpa = FALSE, engine = NULL, output = "default")
```

## Arguments

- game_id:

  Game ID

- epa_wpa:

  Logical parameter (TRUE/FALSE) to return the Expected Points Added/Win
  Probability Added variables

- engine:

  (*Character* optional): which play-by-play engine to run. One of
  `"v2"`, `"legacy"` or `"auto"`; `NULL` (default) resolves from
  `getOption("cfbfastR.pbp_engine")`, which itself defaults to `"v2"` as
  of this release. `"legacy"` is the escape hatch that reproduces the
  pre-2.3.0 frame; `"auto"` means whatever this version of the package
  considers current, so it is carried forward by future default flips.

- output:

  (*Character*): modeled-output column set, one of `"default"`, `"lean"`
  or `"full"`. Only meaningful when the call reaches the v2 engine; it
  is accepted here so a delegating caller can reach the tier selector
  without switching to the
  [`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md)
  name.

## Value

A data frame with college football play-by-play data

## Author

Saiem Gilani

## Examples

``` r
if (FALSE) { # interactive()
# Parsing one game takes several seconds of CPU, and `epa_wpa = TRUE` also
# downloads the EP and WP models on first use.
try(espn_cfb_pbp(game_id = 401282614, epa_wpa = TRUE))
}
```
