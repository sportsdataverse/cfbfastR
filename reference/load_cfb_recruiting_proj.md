# **Load college football recruiting projections from the SportsDataverse data repo**

Loads recruiting-based team projections – one row per team-season with
talent-derived projection inputs. Published to the `cfb_recruiting_proj`
release tag on the sportsdataverse-data repo.

## Usage

``` r
load_cfb_recruiting_proj(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2016 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2016)

- ...:

  Additional arguments passed to an underlying function that writes the
  season data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble.

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer |  |
| team_id | integer |  |
| pred_wins | double | Ridge projection of the team's season win total, fit strictly on prior seasons from talent composite, blue-chip ratio, offensive and defensive returning production, and prior wins. |
| pred_margin | double | Ridge projection of the team's average per-game scoring margin, from the same preseason-known feature set as pred_wins. |
| pred_net_epa | double | Reserved slot for a projected adjusted net EPA; it ships all-null because the adjusted-EPA training target is not currently loadable. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_recruiting_proj(2016))
#> ── college football recruiting projections from the SportsDataverse data repo ──
#> ℹ Data updated: 2026-08-24 11:39:27 UTC
#> # A tibble: 201 × 5
#>    season team_id pred_wins pred_margin pred_net_epa
#>     <int> <chr>       <dbl>       <dbl>        <dbl>
#>  1   2016 333         10.3        18.6            NA
#>  2   2016 99           9.10       13.4            NA
#>  3   2016 52           9.75       16.3            NA
#>  4   2016 194          9.46       15.0            NA
#>  5   2016 30           8.50       10.7            NA
#>  6   2016 145          8.95       13.0            NA
#>  7   2016 2            7.22        5.21           NA
#>  8   2016 61           9.07       13.4            NA
#>  9   2016 2633         8.71       12.0            NA
#> 10   2016 57           8.63       11.7            NA
#> # ℹ 191 more rows
# }
```
