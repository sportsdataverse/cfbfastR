# **Load college football conference and division aliases from the SportsDataverse data repo**

Loads every name and id that a source (ESPN, CFBD, SDV) uses for a
college football group, with the seasons each alias is valid for. Use it
to map a source's conference id or name onto an SDV `group_id`.
Published to the `cfb_groups` release tag on the sportsdataverse-data
repo.

## Usage

``` r
load_cfb_group_aliases(..., dbConnection = NULL, tablename = NULL)
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

Returns a `cfbfastR_data` tibble with one row per alias.

|  |  |  |
|----|----|----|
| col_name | types | description |
| league | character | League key, always `cfb`. |
| group_id | character | SDV group id, `cfb:{slug}`. |
| source | character | Source that uses the alias: `espn`, `cfbd`, or `sdv`. |
| source_id | character | The source's own id for the group (e.g. ESPN group id, CFBD conference id), when it has one. |
| name_kind | character | Kind of alias: `name`, `short_name`, `abbreviation`, `slug`, or `code`. |
| value | character | The alias itself. |
| valid_from | integer | First season the alias applies (inclusive); `NA` means unbounded. |
| valid_to | integer | Last season the alias applies (inclusive); `NA` means unbounded. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_group_aliases())
#> ── college football conference and division aliases from the SportsDataverse dat
#> ℹ Data updated: 2026-09-27 05:31:21 UTC
#> # A tibble: 2,009 × 8
#>    league group_id source source_id name_kind    value       valid_from valid_to
#>    <chr>  <chr>    <chr>  <chr>     <chr>        <chr>            <int>    <int>
#>  1 cfb    cfb:acc  cfbd   1         abbreviation ACC               1953       NA
#>  2 cfb    cfb:acc  cfbd   1         name         Atlantic C…       1953       NA
#>  3 cfb    cfb:acc  cfbd   1         short_name   ACC               1953       NA
#>  4 cfb    cfb:acc  espn   1         abbreviation acc               2001       NA
#>  5 cfb    cfb:acc  espn   1         name         Atlantic C…       2001       NA
#>  6 cfb    cfb:acc  espn   1         short_name   ACC               2001       NA
#>  7 cfb    cfb:acc  espn   1         slug         acc               2001       NA
#>  8 cfb    cfb:acc  sdv    NA        abbreviation ACC               1953       NA
#>  9 cfb    cfb:acc  sdv    NA        name         Atlantic C…       1953       NA
#> 10 cfb    cfb:acc  sdv    NA        short_name   ACC               1953       NA
#> # ℹ 1,999 more rows
# }
```
