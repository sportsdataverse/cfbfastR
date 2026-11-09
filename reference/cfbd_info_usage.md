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
#> ℹ Data updated: 2026-11-09 19:51:59 UTC
#> # A tibble: 20 × 11
#>    api   endpoint            kind   requests occurred_at window_start window_end
#>    <chr> <chr>               <chr>     <int> <chr>       <chr>        <chr>     
#>  1 cfb   /plays/stats        top_e…     5909 2026-11-09… 2026-11-02T… 2026-11-0…
#>  2 cfb   /plays              top_e…     5641 2026-11-09… 2026-11-02T… 2026-11-0…
#>  3 cfb   /games              top_e…     4818 2026-11-09… 2026-11-02T… 2026-11-0…
#>  4 cfb   /drives             top_e…     4174 2026-11-09… 2026-11-02T… 2026-11-0…
#>  5 cfb   /lines              top_e…     4095 2026-11-09… 2026-11-02T… 2026-11-0…
#>  6 cfb   /recruiting/players top_e…     2316 2026-11-09… 2026-11-02T… 2026-11-0…
#>  7 cfb   /roster             top_e…     2174 2026-11-09… 2026-11-02T… 2026-11-0…
#>  8 cfb   /teams/matchup      top_e…     1990 2026-11-09… 2026-11-02T… 2026-11-0…
#>  9 cfb   /recruiting/teams   top_e…     1686 2026-11-09… 2026-11-02T… 2026-11-0…
#> 10 cfb   /teams              top_e…     1584 2026-11-09… 2026-11-02T… 2026-11-0…
#> 11 cfb   /info/usage         recen…       NA 2026-11-09… 2026-11-02T… 2026-11-0…
#> 12 cfb   /ratings/elo        recen…       NA 2026-11-09… 2026-11-02T… 2026-11-0…
#> 13 cfb   /ratings/elo        recen…       NA 2026-11-09… 2026-11-02T… 2026-11-0…
#> 14 cfb   /ratings/core       recen…       NA 2026-11-09… 2026-11-02T… 2026-11-0…
#> 15 cfb   /lines              recen…       NA 2026-11-09… 2026-11-02T… 2026-11-0…
#> 16 cfb   /rankings           recen…       NA 2026-11-09… 2026-11-02T… 2026-11-0…
#> 17 cfb   /rankings           recen…       NA 2026-11-09… 2026-11-02T… 2026-11-0…
#> 18 cfb   /rankings           recen…       NA 2026-11-09… 2026-11-02T… 2026-11-0…
#> 19 cfb   /games/weather      recen…       NA 2026-11-09… 2026-11-02T… 2026-11-0…
#> 20 cfb   /lines              recen…       NA 2026-11-09… 2026-11-02T… 2026-11-0…
#> # ℹ 4 more variables: total_requests <int>, total_cfb_requests <int>,
#> #   total_cbb_requests <int>, unique_endpoints <int>
# }
```
