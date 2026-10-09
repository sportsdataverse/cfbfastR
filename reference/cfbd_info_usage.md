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
#> ℹ Data updated: 2026-10-09 03:13:01 UTC
#> # A tibble: 20 × 11
#>    api   endpoint             kind  requests occurred_at window_start window_end
#>    <chr> <chr>                <chr>    <int> <chr>       <chr>        <chr>     
#>  1 cfb   /plays/stats         top_…     2673 2026-10-09… 2026-10-02T… 2026-10-0…
#>  2 cfb   /games               top_…      535 2026-10-09… 2026-10-02T… 2026-10-0…
#>  3 cfb   /plays               top_…      197 2026-10-09… 2026-10-02T… 2026-10-0…
#>  4 cfb   /lines               top_…      194 2026-10-09… 2026-10-02T… 2026-10-0…
#>  5 cfb   /rankings            top_…      193 2026-10-09… 2026-10-02T… 2026-10-0…
#>  6 cfb   /drives              top_…      173 2026-10-09… 2026-10-02T… 2026-10-0…
#>  7 cfb   /teams/matchup       top_…      110 2026-10-09… 2026-10-02T… 2026-10-0…
#>  8 cfb   /ratings/sp          top_…       98 2026-10-09… 2026-10-02T… 2026-10-0…
#>  9 cfb   /ratings/srs         top_…       92 2026-10-09… 2026-10-02T… 2026-10-0…
#> 10 cfb   /roster              top_…       82 2026-10-09… 2026-10-02T… 2026-10-0…
#> 11 cfb   /info/usage          rece…       NA 2026-10-09… 2026-10-02T… 2026-10-0…
#> 12 cfb   /games/weather       rece…       NA 2026-10-09… 2026-10-02T… 2026-10-0…
#> 13 cfb   /games/teams         rece…       NA 2026-10-09… 2026-10-02T… 2026-10-0…
#> 14 cfb   /games/teams         rece…       NA 2026-10-09… 2026-10-02T… 2026-10-0…
#> 15 cfb   /games/schedule      rece…       NA 2026-10-09… 2026-10-02T… 2026-10-0…
#> 16 cfb   /records             rece…       NA 2026-10-09… 2026-10-02T… 2026-10-0…
#> 17 cfb   /records             rece…       NA 2026-10-09… 2026-10-02T… 2026-10-0…
#> 18 cfb   /games/:gameId/prev… rece…       NA 2026-10-09… 2026-10-02T… 2026-10-0…
#> 19 cfb   /games/:gameId/prev… rece…       NA 2026-10-09… 2026-10-02T… 2026-10-0…
#> 20 cfb   /games/players       rece…       NA 2026-10-09… 2026-10-02T… 2026-10-0…
#> # ℹ 4 more variables: total_requests <int>, total_cfb_requests <int>,
#> #   total_cbb_requests <int>, unique_endpoints <int>
# }
```
