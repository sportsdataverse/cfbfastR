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
#> ℹ Data updated: 2026-09-03 22:33:33 UTC
#> # A tibble: 20 × 11
#>    api   endpoint             kind  requests occurred_at window_start window_end
#>    <chr> <chr>                <chr>    <int> <chr>       <chr>        <chr>     
#>  1 cfb   /drives              top_…      716 2026-09-03… 2026-08-27T… 2026-09-0…
#>  2 cfb   /lines               top_…      683 2026-09-03… 2026-08-27T… 2026-09-0…
#>  3 cfb   /plays               top_…      640 2026-09-03… 2026-08-27T… 2026-09-0…
#>  4 cfb   /recruiting/players  top_…      343 2026-09-03… 2026-08-27T… 2026-09-0…
#>  5 cfb   /games               top_…      297 2026-09-03… 2026-08-27T… 2026-09-0…
#>  6 cfb   /teams/matchup       top_…      286 2026-09-03… 2026-08-27T… 2026-09-0…
#>  7 cfb   /plays/stats         top_…      254 2026-09-03… 2026-08-27T… 2026-09-0…
#>  8 cfb   /recruiting/teams    top_…      247 2026-09-03… 2026-08-27T… 2026-09-0…
#>  9 cfb   /teams/fbs           top_…      212 2026-09-03… 2026-08-27T… 2026-09-0…
#> 10 cfb   /stats/game/advanced top_…      208 2026-09-03… 2026-08-27T… 2026-09-0…
#> 11 cfb   /info/usage          rece…       NA 2026-09-03… 2026-08-27T… 2026-09-0…
#> 12 cfb   /wepa/players/kicki… rece…       NA 2026-09-03… 2026-08-27T… 2026-09-0…
#> 13 cfb   /ppa/teams           rece…       NA 2026-09-03… 2026-08-27T… 2026-09-0…
#> 14 cfb   /ppa/predicted       rece…       NA 2026-09-03… 2026-08-27T… 2026-09-0…
#> 15 cfb   /ppa/predicted       rece…       NA 2026-09-03… 2026-08-27T… 2026-09-0…
#> 16 cfb   /ppa/players/season  rece…       NA 2026-09-03… 2026-08-27T… 2026-09-0…
#> 17 cfb   /ppa/players/games   rece…       NA 2026-09-03… 2026-08-27T… 2026-09-0…
#> 18 cfb   /games/teams         rece…       NA 2026-09-03… 2026-08-27T… 2026-09-0…
#> 19 cfb   /games/teams         rece…       NA 2026-09-03… 2026-08-27T… 2026-09-0…
#> 20 cfb   /ppa/games           rece…       NA 2026-09-03… 2026-08-27T… 2026-09-0…
#> # ℹ 4 more variables: total_requests <int>, total_cfb_requests <int>,
#> #   total_cbb_requests <int>, unique_endpoints <int>
# }
```
