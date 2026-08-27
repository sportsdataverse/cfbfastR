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
#> ℹ Data updated: 2026-08-27 10:54:18 UTC
#> # A tibble: 20 × 11
#>    api   endpoint            kind   requests occurred_at window_start window_end
#>    <chr> <chr>               <chr>     <int> <chr>       <chr>        <chr>     
#>  1 cfb   /drives             top_e…     2597 2026-08-27… 2026-08-20T… 2026-08-2…
#>  2 cfb   /lines              top_e…     2354 2026-08-27… 2026-08-20T… 2026-08-2…
#>  3 cfb   /plays              top_e…     2330 2026-08-27… 2026-08-20T… 2026-08-2…
#>  4 cfb   /recruiting/players top_e…     1228 2026-08-27… 2026-08-20T… 2026-08-2…
#>  5 cfb   /teams/matchup      top_e…      934 2026-08-27… 2026-08-20T… 2026-08-2…
#>  6 cfb   /games              top_e…      873 2026-08-27… 2026-08-20T… 2026-08-2…
#>  7 cfb   /recruiting/teams   top_e…      820 2026-08-27… 2026-08-20T… 2026-08-2…
#>  8 cfb   /recruiting/groups  top_e…      711 2026-08-27… 2026-08-20T… 2026-08-2…
#>  9 cfb   /teams/fbs          top_e…      692 2026-08-27… 2026-08-20T… 2026-08-2…
#> 10 cfb   /stats/season       top_e…      660 2026-08-27… 2026-08-20T… 2026-08-2…
#> 11 cfb   /info/usage         recen…       NA 2026-08-27… 2026-08-20T… 2026-08-2…
#> 12 cfb   /drives             recen…       NA 2026-08-27… 2026-08-20T… 2026-08-2…
#> 13 cfb   /recruiting/groups  recen…       NA 2026-08-27… 2026-08-20T… 2026-08-2…
#> 14 cfb   /games/teams        recen…       NA 2026-08-27… 2026-08-20T… 2026-08-2…
#> 15 cfb   /lines              recen…       NA 2026-08-27… 2026-08-20T… 2026-08-2…
#> 16 cfb   /games/teams        recen…       NA 2026-08-27… 2026-08-20T… 2026-08-2…
#> 17 cfb   /recruiting/groups  recen…       NA 2026-08-27… 2026-08-20T… 2026-08-2…
#> 18 cfb   /records            recen…       NA 2026-08-27… 2026-08-20T… 2026-08-2…
#> 19 cfb   /records            recen…       NA 2026-08-27… 2026-08-20T… 2026-08-2…
#> 20 cfb   /recruiting/players recen…       NA 2026-08-27… 2026-08-20T… 2026-08-2…
#> # ℹ 4 more variables: total_requests <int>, total_cfb_requests <int>,
#> #   total_cbb_requests <int>, unique_endpoints <int>
# }
```
