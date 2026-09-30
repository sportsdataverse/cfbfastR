# **Get API key usage information**

**Get API key usage information** Call volume and remaining quota for
the configured CFBD API key.

## Usage

``` r
cfbd_info_usage(days = NULL, limit = NULL, api = NULL, proxy = NULL)
```

## Arguments

- days:

  (*Integer* optional): Look-back window in days.

- limit:

  (*Integer* optional): Maximum rows to return.

- api:

  (*String* optional): API filter – `all`, `cfb` or `cbb`.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_info_usage()` - A tibble with 11 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| api | character | API the request was made against (`cfb` or `cbb`). |
| endpoint | character | API endpoint path. |
| kind | character | Row type – `top_endpoint` (aggregated count) or `recent_request` (single event). |
| requests | integer | Number of requests recorded. |
| occurred_at | character | Timestamp for the row (last use for `top_endpoint`, request time for `recent_request`). |
| window_start | character | Start of the reporting window (ISO 8601). |
| window_end | character | End of the reporting window (ISO 8601). |
| total_requests | integer | Total requests in the window. |
| total_cfb_requests | integer | College football requests in the window. |
| total_cbb_requests | integer | College basketball requests in the window. |
| unique_endpoints | integer | Distinct endpoints called in the window. |

## Examples

``` r
# \donttest{
  try(cfbd_info_usage())
#> ── Get API key usage information from CollegeFootballData.com ──────────────────
#> ℹ Data updated: 2026-09-30 20:28:15 UTC
#> # A tibble: 20 × 11
#>    api   endpoint            kind   requests occurred_at window_start window_end
#>    <chr> <chr>               <chr>     <int> <chr>       <chr>        <chr>     
#>  1 cfb   /drives             top_e…     3340 2026-09-30… 2026-09-23T… 2026-09-3…
#>  2 cfb   /lines              top_e…     3271 2026-09-30… 2026-09-23T… 2026-09-3…
#>  3 cfb   /plays              top_e…     2993 2026-09-30… 2026-09-23T… 2026-09-3…
#>  4 cfb   /plays/stats        top_e…     2697 2026-09-30… 2026-09-23T… 2026-09-3…
#>  5 cfb   /games              top_e…     2251 2026-09-30… 2026-09-23T… 2026-09-3…
#>  6 cfb   /recruiting/players top_e…     1842 2026-09-30… 2026-09-23T… 2026-09-3…
#>  7 cfb   /roster             top_e…     1220 2026-09-30… 2026-09-23T… 2026-09-3…
#>  8 cfb   /teams/matchup      top_e…     1175 2026-09-30… 2026-09-23T… 2026-09-3…
#>  9 cfb   /recruiting/teams   top_e…     1047 2026-09-30… 2026-09-23T… 2026-09-3…
#> 10 cfb   /recruiting/groups  top_e…      892 2026-09-30… 2026-09-23T… 2026-09-3…
#> 11 cfb   /info/usage         recen…       NA 2026-09-30… 2026-09-23T… 2026-09-3…
#> 12 cfb   /games/players      recen…       NA 2026-09-30… 2026-09-23T… 2026-09-3…
#> 13 cfb   /games/players      recen…       NA 2026-09-30… 2026-09-23T… 2026-09-3…
#> 14 cfb   /games/media        recen…       NA 2026-09-30… 2026-09-23T… 2026-09-3…
#> 15 cfb   /games/weather      recen…       NA 2026-09-30… 2026-09-23T… 2026-09-3…
#> 16 cfb   /games              recen…       NA 2026-09-30… 2026-09-23T… 2026-09-3…
#> 17 cfb   /games/teams        recen…       NA 2026-09-30… 2026-09-23T… 2026-09-3…
#> 18 cfb   /games/teams        recen…       NA 2026-09-30… 2026-09-23T… 2026-09-3…
#> 19 cfb   /game/box/advanced  recen…       NA 2026-09-30… 2026-09-23T… 2026-09-3…
#> 20 cfb   /games/schedule     recen…       NA 2026-09-30… 2026-09-23T… 2026-09-3…
#> # ℹ 4 more variables: total_requests <int>, total_cfb_requests <int>,
#> #   total_cbb_requests <int>, unique_endpoints <int>
# }
```
