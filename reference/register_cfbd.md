# **CFBD API Key Registration**

Save your API Key as a system environment variable `CFBD_API_KEY`

## Usage

``` r
cfbd_key()

has_cfbd_key()

cfbd_api_key_info()
```

## Value

Returns a data frame with 2 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| patron_level | integer | CFBD Patreon tier associated with the API key (0 = free tier, higher = paid tier). |
| remaining_calls | integer | Number of API calls remaining in the current rate-limit window for this key. |

## Details

To get access to an API key, follow the instructions at
<https://collegefootballdata.com/key>

**Using the key:** You can save the key for consistent usage by adding
`CFBD_API_KEY=YOUR-API-KEY-HERE` to your .Renviron file (easily accessed
via
[**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)).
Run
[**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html),
a new script will pop open named `.Renviron`, **THEN** paste the
following in the new script that pops up (with**out** quotations)

    CFBD_API_KEY = YOUR-API-KEY-HERE

Save the script and restart your RStudio session, by clicking `Session`
(in between `Plots` and `Build`) and click `Restart R` (there also
exists the shortcut `Ctrl + Shift + F10` to restart your session).

If set correctly, from then on you should be able to use any of the
`cfbd_` functions without any other changes.

**For less consistent usage:** At the beginning of every session or
within an R environment, save your API key as the environment variable
`CFBD_API_KEY` (**with** quotations) using a command like the following.

    Sys.setenv(CFBD_API_KEY = "YOUR-API-KEY-HERE")

Get information about your API key, including your Patreon level and
usage limits.

## Examples

``` r
# Offline: is a key registered in this session?
has_cfbd_key()
#> [1] TRUE
# \donttest{
  if (has_cfbd_key()) try(cfbd_api_key_info())
#> 2026-11-06 08:27:32.534747: Invalid arguments or no CFBD API key info data available! Tibble columns must have compatible sizes.
#> • Size 2: Column `products`.
#> • Size 5: Column `features`.
#> ℹ Only values of size one are recycled.
#> $patron_level
#> [1] 4
#> 
#> $tier_name
#> [1] "Tier 4"
#> 
#> $monthly_limit
#> [1] 125000
#> 
#> $remaining_calls
#> [1] 11808
#> 
#> $used_calls
#> [1] 113192
#> 
#> $reset_at
#> [1] "2026-12-01T00:00:00.000Z"
#> 
#> $shared_pool
#> [1] TRUE
#> 
#> $products
#> [1] "cfb" "cbb"
#> 
#> $features
#> $features$adjustedMetrics
#> [1] TRUE
#> 
#> $features$weather
#> [1] TRUE
#> 
#> $features$scoreboard
#> [1] TRUE
#> 
#> $features$livePlayByPlay
#> [1] TRUE
#> 
#> $features$graphQl
#> [1] TRUE
#> 
#> 
# }
```
