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
#> ℹ Data updated: 2026-09-19 02:52:53 UTC
#> # A tibble: 20 × 11
#>    api   endpoint          kind     requests occurred_at window_start window_end
#>    <chr> <chr>             <chr>       <int> <chr>       <chr>        <chr>     
#>  1 cfb   /plays/stats      top_end…     1205 2026-09-19… 2026-09-12T… 2026-09-1…
#>  2 cfb   /lines            top_end…      551 2026-09-19… 2026-09-12T… 2026-09-1…
#>  3 cfb   /plays            top_end…      508 2026-09-19… 2026-09-12T… 2026-09-1…
#>  4 cfb   /drives           top_end…      504 2026-09-19… 2026-09-12T… 2026-09-1…
#>  5 cfb   /games            top_end…      406 2026-09-19… 2026-09-12T… 2026-09-1…
#>  6 cfb   /coaches          top_end…      206 2026-09-19… 2026-09-12T… 2026-09-1…
#>  7 cfb   /teams/matchup    top_end…      168 2026-09-19… 2026-09-12T… 2026-09-1…
#>  8 cfb   /recruiting/teams top_end…      151 2026-09-19… 2026-09-12T… 2026-09-1…
#>  9 cfb   /teams/fbs        top_end…      138 2026-09-19… 2026-09-12T… 2026-09-1…
#> 10 cfb   /rankings         top_end…      133 2026-09-19… 2026-09-12T… 2026-09-1…
#> 11 cfb   /info/usage       recent_…       NA 2026-09-19… 2026-09-12T… 2026-09-1…
#> 12 cfb   /plays/stats      recent_…       NA 2026-09-19… 2026-09-12T… 2026-09-1…
#> 13 cfb   /games/teams      recent_…       NA 2026-09-19… 2026-09-12T… 2026-09-1…
#> 14 cfb   /games/teams      recent_…       NA 2026-09-19… 2026-09-12T… 2026-09-1…
#> 15 cfb   /records          recent_…       NA 2026-09-19… 2026-09-12T… 2026-09-1…
#> 16 cfb   /records          recent_…       NA 2026-09-19… 2026-09-12T… 2026-09-1…
#> 17 cfb   /games/players    recent_…       NA 2026-09-19… 2026-09-12T… 2026-09-1…
#> 18 cfb   /games/players    recent_…       NA 2026-09-19… 2026-09-12T… 2026-09-1…
#> 19 cfb   /games/media      recent_…       NA 2026-09-19… 2026-09-12T… 2026-09-1…
#> 20 cfb   /games            recent_…       NA 2026-09-19… 2026-09-12T… 2026-09-1…
#> # ℹ 4 more variables: total_requests <int>, total_cfb_requests <int>,
#> #   total_cbb_requests <int>, unique_endpoints <int>
# }
```
