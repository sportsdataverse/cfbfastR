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
#> ℹ Data updated: 2026-09-27 07:37:40 UTC
#> # A tibble: 20 × 11
#>    api   endpoint             kind  requests occurred_at window_start window_end
#>    <chr> <chr>                <chr>    <int> <chr>       <chr>        <chr>     
#>  1 cfb   /plays/stats         top_…     2143 2026-09-27… 2026-09-20T… 2026-09-2…
#>  2 cfb   /drives              top_…     1236 2026-09-27… 2026-09-20T… 2026-09-2…
#>  3 cfb   /lines               top_…     1211 2026-09-27… 2026-09-20T… 2026-09-2…
#>  4 cfb   /plays               top_…     1112 2026-09-27… 2026-09-20T… 2026-09-2…
#>  5 cfb   /recruiting/players  top_…      727 2026-09-27… 2026-09-20T… 2026-09-2…
#>  6 cfb   /teams/matchup       top_…      486 2026-09-27… 2026-09-20T… 2026-09-2…
#>  7 cfb   /games               top_…      470 2026-09-27… 2026-09-20T… 2026-09-2…
#>  8 cfb   /recruiting/teams    top_…      433 2026-09-27… 2026-09-20T… 2026-09-2…
#>  9 cfb   /recruiting/groups   top_…      368 2026-09-27… 2026-09-20T… 2026-09-2…
#> 10 cfb   /stats/player/season top_…      358 2026-09-27… 2026-09-20T… 2026-09-2…
#> 11 cfb   /info/usage          rece…       NA 2026-09-27… 2026-09-20T… 2026-09-2…
#> 12 cfb   /info/usage          rece…       NA 2026-09-27… 2026-09-20T… 2026-09-2…
#> 13 cfb   /games/teams         rece…       NA 2026-09-27… 2026-09-20T… 2026-09-2…
#> 14 cfb   /games/teams         rece…       NA 2026-09-27… 2026-09-20T… 2026-09-2…
#> 15 cfb   /games/schedule      rece…       NA 2026-09-27… 2026-09-20T… 2026-09-2…
#> 16 cfb   /records             rece…       NA 2026-09-27… 2026-09-20T… 2026-09-2…
#> 17 cfb   /records             rece…       NA 2026-09-27… 2026-09-20T… 2026-09-2…
#> 18 cfb   /games/teams         rece…       NA 2026-09-27… 2026-09-20T… 2026-09-2…
#> 19 cfb   /games/:gameId/prev… rece…       NA 2026-09-27… 2026-09-20T… 2026-09-2…
#> 20 cfb   /games/:gameId/prev… rece…       NA 2026-09-27… 2026-09-20T… 2026-09-2…
#> # ℹ 4 more variables: total_requests <int>, total_cfb_requests <int>,
#> #   total_cbb_requests <int>, unique_endpoints <int>
# }
```
