# **Clear the cfbfastR lookup cache**

The ESPN college football game wrappers enrich their output with team
and position detail drawn from two static catalogs –
[`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md)
(~750 teams) and
[`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md)
(~74 positions). Because those catalogs do not change often, the
internal lookups built from them are memoized with `cachem` + `memoise`,
so a loop over many games does not re-hit ESPN for the catalogs on every
call.

`espn_cfb_clear_cache()` forgets those memoized lookups, and also the
per-season CFBD team catalog and roster that
[`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
memoizes to attach team and player ids. The next call that needs one
fetches it again. Use it when you want to force a refresh – for example
after a long-running session, or when debugging.

## Usage

``` r
espn_cfb_clear_cache()
```

## Value

Invisibly returns `NULL`. Called for its side effect of forgetting the
memoized catalog lookups.

## Details

**Clear the cfbfastR lookup cache**

Caching is configured at package load via two
[`options()`](https://rdrr.io/r/base/options.html):

- `cfbfastR.cache` – cache backend. One of `"memory"` (default;
  in-memory
  [`cachem::cache_mem()`](https://cachem.r-lib.org/reference/cache_mem.html),
  cleared when the session ends), `"filesystem"` (persistent on-disk
  [`cachem::cache_disk()`](https://cachem.r-lib.org/reference/cache_disk.html)
  under [`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html)),
  or `"off"` (no memoization – every lookup hits the API).

- `cfbfastR.cache_duration` – cache time-to-live in seconds. Defaults to
  `86400` (24 hours).

Set these with [`options()`](https://rdrr.io/r/base/options.html)
*before* the package is loaded, e.g.
`options(cfbfastR.cache = "filesystem")`. When `cfbfastR.cache` is
`"off"`, the catalog helpers are never memoized and
`espn_cfb_clear_cache()` is a no-op (it still returns invisibly without
error).

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  # Force the team / position catalogs to be re-fetched on next use
  espn_cfb_clear_cache()
# }
```
