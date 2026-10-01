# **Load college football conference and division lineages from the SportsDataverse data repo**

Loads one row per college football group lineage – the FBS / FCS
subdivisions, the conferences, and the conference divisions – with the
first and last season each had at least one member. A lineage keeps one
`group_id` across renames that keep continuity (Pac-10 to Pac-12 stays
`cfb:pac-12`); a new body gets a new id. Published to the `cfb_groups`
release tag on the sportsdataverse-data repo.

See
[`load_cfb_group_seasons()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_group_seasons.md)
for per-season names and parents,
[`load_cfb_group_aliases()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_group_aliases.md)
for the names and ids other sources use, and
[`load_cfb_team_group_seasons()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_team_group_seasons.md)
for team membership.

## Usage

``` r
load_cfb_groups(..., dbConnection = NULL, tablename = NULL)
```

## Arguments

- ...:

  Additional arguments passed to an underlying function that writes the
  data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble with one row per group lineage.

|  |  |  |
|----|----|----|
| col_name | types | description |
| league | character | League key, always `cfb`. |
| group_id | character | SDV group id, `cfb:{slug}` (e.g. `cfb:big-ten`, `cfb:fbs`); one id per lineage across renames. |
| level | character | Group level: `subdivision`, `conference`, or `division`. |
| first_season | integer | First season (fall year) with at least one member. |
| last_season | integer | Last season (fall year) with at least one member. |
| notes | character | Lineage decisions and source caveats. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_groups())
#> ── college football conference and division lineages from the SportsDataverse da
#> ℹ Data updated: 2026-10-01 10:21:22 UTC
#> # A tibble: 237 × 6
#>    league group_id                     level      first_season last_season notes
#>    <chr>  <chr>                        <chr>             <int>       <int> <chr>
#>  1 cfb    cfb:acc                      conference         1953        2026 CFBD…
#>  2 cfb    cfb:acc-atlantic             division           2005        2022 NA   
#>  3 cfb    cfb:acc-coastal              division           2005        2022 NA   
#>  4 cfb    cfb:american                 conference         2013        2026 Amer…
#>  5 cfb    cfb:american-east            division           2015        2019 NA   
#>  6 cfb    cfb:american-rivers          conference         2014        2026 CFBD…
#>  7 cfb    cfb:american-southwest       conference         2014        2026 CFBD…
#>  8 cfb    cfb:american-west            division           2015        2019 NA   
#>  9 cfb    cfb:american-west-conference conference         1993        1995 Name…
#> 10 cfb    cfb:arkansas-intercollegiate conference         1930        1950 CFBD…
#> # ℹ 227 more rows
# }
```
