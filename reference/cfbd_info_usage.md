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
#> ℹ Data updated: 2026-10-30 00:09:17 UTC
#> # A tibble: 20 × 11
#>    api   endpoint             kind  requests occurred_at window_start window_end
#>    <chr> <chr>                <chr>    <int> <chr>       <chr>        <chr>     
#>  1 cfb   /plays/stats         top_…     2982 2026-10-30… 2026-10-23T… 2026-10-3…
#>  2 cfb   /games               top_…      187 2026-10-30… 2026-10-23T… 2026-10-3…
#>  3 cfb   /plays               top_…      125 2026-10-30… 2026-10-23T… 2026-10-3…
#>  4 cfb   /lines               top_…      123 2026-10-30… 2026-10-23T… 2026-10-3…
#>  5 cfb   /drives              top_…      114 2026-10-30… 2026-10-23T… 2026-10-3…
#>  6 cfb   /teams               top_…       55 2026-10-30… 2026-10-23T… 2026-10-3…
#>  7 cfb   /roster              top_…       46 2026-10-30… 2026-10-23T… 2026-10-3…
#>  8 cfb   /coaches             top_…       44 2026-10-30… 2026-10-23T… 2026-10-3…
#>  9 cfb   /teams/matchup       top_…       37 2026-10-30… 2026-10-23T… 2026-10-3…
#> 10 cfb   /rankings            top_…       30 2026-10-30… 2026-10-23T… 2026-10-3…
#> 11 cfb   /info/usage          rece…       NA 2026-10-30… 2026-10-23T… 2026-10-3…
#> 12 cfb   /rankings            rece…       NA 2026-10-30… 2026-10-23T… 2026-10-3…
#> 13 cfb   /rankings            rece…       NA 2026-10-30… 2026-10-23T… 2026-10-3…
#> 14 cfb   /rankings            rece…       NA 2026-10-30… 2026-10-23T… 2026-10-3…
#> 15 cfb   /games/weather       rece…       NA 2026-10-30… 2026-10-23T… 2026-10-3…
#> 16 cfb   /games/teams         rece…       NA 2026-10-30… 2026-10-23T… 2026-10-3…
#> 17 cfb   /games/teams         rece…       NA 2026-10-30… 2026-10-23T… 2026-10-3…
#> 18 cfb   /plays               rece…       NA 2026-10-30… 2026-10-23T… 2026-10-3…
#> 19 cfb   /games/schedule      rece…       NA 2026-10-30… 2026-10-23T… 2026-10-3…
#> 20 cfb   /playoffs/cfp/parti… rece…       NA 2026-10-30… 2026-10-23T… 2026-10-3…
#> # ℹ 4 more variables: total_requests <int>, total_cfb_requests <int>,
#> #   total_cbb_requests <int>, unique_endpoints <int>
# }
```
