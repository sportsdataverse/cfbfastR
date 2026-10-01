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
#> ℹ Data updated: 2026-10-01 04:38:10 UTC
#> # A tibble: 20 × 11
#>    api   endpoint             kind  requests occurred_at window_start window_end
#>    <chr> <chr>                <chr>    <int> <chr>       <chr>        <chr>     
#>  1 cfb   /drives              top_…     4671 2026-10-01… 2026-09-24T… 2026-10-0…
#>  2 cfb   /lines               top_…     4561 2026-10-01… 2026-09-24T… 2026-10-0…
#>  3 cfb   /plays               top_…     4171 2026-10-01… 2026-09-24T… 2026-10-0…
#>  4 cfb   /games               top_…     3617 2026-10-01… 2026-09-24T… 2026-10-0…
#>  5 cfb   /plays/stats         top_…     2895 2026-10-01… 2026-09-24T… 2026-10-0…
#>  6 cfb   /recruiting/players  top_…     2497 2026-10-01… 2026-09-24T… 2026-10-0…
#>  7 cfb   /roster              top_…     1843 2026-10-01… 2026-09-24T… 2026-10-0…
#>  8 cfb   /teams/matchup       top_…     1601 2026-10-01… 2026-09-24T… 2026-10-0…
#>  9 cfb   /recruiting/teams    top_…     1411 2026-10-01… 2026-09-24T… 2026-10-0…
#> 10 cfb   /teams               top_…     1331 2026-10-01… 2026-09-24T… 2026-10-0…
#> 11 cfb   /info/usage          rece…       NA 2026-10-01… 2026-09-24T… 2026-10-0…
#> 12 cfb   /plays               rece…       NA 2026-10-01… 2026-09-24T… 2026-10-0…
#> 13 cfb   /playoffs/cfp/parti… rece…       NA 2026-10-01… 2026-09-24T… 2026-10-0…
#> 14 cfb   /drives              rece…       NA 2026-10-01… 2026-09-24T… 2026-10-0…
#> 15 cfb   /playoffs/cfp/games  rece…       NA 2026-10-01… 2026-09-24T… 2026-10-0…
#> 16 cfb   /playoffs/cfp/parti… rece…       NA 2026-10-01… 2026-09-24T… 2026-10-0…
#> 17 cfb   /playoffs/cfp        rece…       NA 2026-10-01… 2026-09-24T… 2026-10-0…
#> 18 cfb   /player/usage        rece…       NA 2026-10-01… 2026-09-24T… 2026-10-0…
#> 19 cfb   /games/weather       rece…       NA 2026-10-01… 2026-09-24T… 2026-10-0…
#> 20 cfb   /lines               rece…       NA 2026-10-01… 2026-09-24T… 2026-10-0…
#> # ℹ 4 more variables: total_requests <int>, total_cfb_requests <int>,
#> #   total_cbb_requests <int>, unique_endpoints <int>
# }
```
