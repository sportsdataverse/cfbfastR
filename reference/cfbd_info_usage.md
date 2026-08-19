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
#> ℹ Data updated: 2026-08-19 17:52:21 UTC
#> # A tibble: 20 × 11
#>    api   endpoint             kind  requests occurred_at window_start window_end
#>    <chr> <chr>                <chr>    <int> <chr>       <chr>        <chr>     
#>  1 cfb   /drives              top_…     1192 2026-08-19… 2026-08-12T… 2026-08-1…
#>  2 cfb   /lines               top_…     1139 2026-08-19… 2026-08-12T… 2026-08-1…
#>  3 cfb   /plays               top_…     1027 2026-08-19… 2026-08-12T… 2026-08-1…
#>  4 cfb   /recruiting/players  top_…      498 2026-08-19… 2026-08-12T… 2026-08-1…
#>  5 cfb   /teams/matchup       top_…      465 2026-08-19… 2026-08-12T… 2026-08-1…
#>  6 cfb   /recruiting/teams    top_…      401 2026-08-19… 2026-08-12T… 2026-08-1…
#>  7 cfb   /games               top_…      382 2026-08-19… 2026-08-12T… 2026-08-1…
#>  8 cfb   /rankings            top_…      370 2026-08-19… 2026-08-12T… 2026-08-1…
#>  9 cfb   /teams/fbs           top_…      356 2026-08-19… 2026-08-12T… 2026-08-1…
#> 10 cfb   /stats/game/advanced top_…      349 2026-08-19… 2026-08-12T… 2026-08-1…
#> 11 cfb   /info/usage          rece…       NA 2026-08-19… 2026-08-12T… 2026-08-1…
#> 12 cfb   /games/teams         rece…       NA 2026-08-19… 2026-08-12T… 2026-08-1…
#> 13 cfb   /games/teams         rece…       NA 2026-08-19… 2026-08-12T… 2026-08-1…
#> 14 cfb   /records             rece…       NA 2026-08-19… 2026-08-12T… 2026-08-1…
#> 15 cfb   /records             rece…       NA 2026-08-19… 2026-08-12T… 2026-08-1…
#> 16 cfb   /games/players       rece…       NA 2026-08-19… 2026-08-12T… 2026-08-1…
#> 17 cfb   /games/players       rece…       NA 2026-08-19… 2026-08-12T… 2026-08-1…
#> 18 cfb   /games/media         rece…       NA 2026-08-19… 2026-08-12T… 2026-08-1…
#> 19 cfb   /games               rece…       NA 2026-08-19… 2026-08-12T… 2026-08-1…
#> 20 cfb   /game/box/advanced   rece…       NA 2026-08-19… 2026-08-12T… 2026-08-1…
#> # ℹ 4 more variables: total_requests <int>, total_cfb_requests <int>,
#> #   total_cbb_requests <int>, unique_endpoints <int>
# }
```
