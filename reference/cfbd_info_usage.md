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
#> ℹ Data updated: 2026-11-24 09:56:52 UTC
#> # A tibble: 20 × 11
#>    api   endpoint             kind  requests occurred_at window_start window_end
#>    <chr> <chr>                <chr>    <int> <chr>       <chr>        <chr>     
#>  1 cfb   /plays/stats         top_…     4550 2026-11-24… 2026-11-17T… 2026-11-2…
#>  2 cfb   /games               top_…      520 2026-11-24… 2026-11-17T… 2026-11-2…
#>  3 cfb   /lines               top_…      372 2026-11-24… 2026-11-17T… 2026-11-2…
#>  4 cfb   /drives              top_…      367 2026-11-24… 2026-11-17T… 2026-11-2…
#>  5 cfb   /plays               top_…      332 2026-11-24… 2026-11-17T… 2026-11-2…
#>  6 cfb   /roster              top_…      161 2026-11-24… 2026-11-17T… 2026-11-2…
#>  7 cfb   /teams               top_…      149 2026-11-24… 2026-11-17T… 2026-11-2…
#>  8 cfb   /teams/matchup       top_…      105 2026-11-24… 2026-11-17T… 2026-11-2…
#>  9 cfb   /recruiting/teams    top_…       86 2026-11-24… 2026-11-17T… 2026-11-2…
#> 10 cfb   /games/teams         top_…       83 2026-11-24… 2026-11-17T… 2026-11-2…
#> 11 cfb   /plays               rece…       NA 2026-11-24… 2026-11-17T… 2026-11-2…
#> 12 cfb   /plays               rece…       NA 2026-11-24… 2026-11-17T… 2026-11-2…
#> 13 cfb   /roster              rece…       NA 2026-11-24… 2026-11-17T… 2026-11-2…
#> 14 cfb   /passing/players/ga… rece…       NA 2026-11-24… 2026-11-17T… 2026-11-2…
#> 15 cfb   /lines               rece…       NA 2026-11-24… 2026-11-17T… 2026-11-2…
#> 16 cfb   /plays               rece…       NA 2026-11-24… 2026-11-17T… 2026-11-2…
#> 17 cfb   /lines               rece…       NA 2026-11-24… 2026-11-17T… 2026-11-2…
#> 18 cfb   /venues              rece…       NA 2026-11-24… 2026-11-17T… 2026-11-2…
#> 19 cfb   /games               rece…       NA 2026-11-24… 2026-11-17T… 2026-11-2…
#> 20 cfb   /plays               rece…       NA 2026-11-24… 2026-11-17T… 2026-11-2…
#> # ℹ 4 more variables: total_requests <int>, total_cfb_requests <int>,
#> #   total_cbb_requests <int>, unique_endpoints <int>
# }
```
