# **Load college football conference and division names by season from the SportsDataverse data repo**

Loads one row per college football group per season it existed, with the
group's name, short name, abbreviation, and parent group **as of that
season** rather than today's labels, plus its member count. Published to
the `cfb_groups` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_cfb_group_seasons(..., dbConnection = NULL, tablename = NULL)
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

Returns a `cfbfastR_data` tibble with one row per group-season.

|  |  |  |
|----|----|----|
| col_name | types | description |
| league | character | League key, always `cfb`. |
| group_id | character | SDV group id, `cfb:{slug}`. |
| season | integer | Season (fall year; 2025 = fall 2025). |
| level | character | Group level: `subdivision`, `conference`, or `division`. |
| name | character | Group name as of that season. |
| short_name | character | Group short name as of that season. |
| abbreviation | character | Group abbreviation as of that season. |
| parent_group_id | character | Parent group id as of that season (division to conference to subdivision). |
| n_teams | integer | Number of member teams that season. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_group_seasons())
#> ── college football conference and division names by season from the SportsDatav
#> ℹ Data updated: 2026-10-09 03:20:56 UTC
#> # A tibble: 5,550 × 9
#>    league group_id season level    name  short_name abbreviation parent_group_id
#>    <chr>  <chr>     <int> <chr>    <chr> <chr>      <chr>        <chr>          
#>  1 cfb    cfb:acc    1953 confere… Atla… ACC        ACC          cfb:fbs        
#>  2 cfb    cfb:acc    1954 confere… Atla… ACC        ACC          cfb:fbs        
#>  3 cfb    cfb:acc    1955 confere… Atla… ACC        ACC          cfb:fbs        
#>  4 cfb    cfb:acc    1956 confere… Atla… ACC        ACC          cfb:fbs        
#>  5 cfb    cfb:acc    1957 confere… Atla… ACC        ACC          cfb:fbs        
#>  6 cfb    cfb:acc    1958 confere… Atla… ACC        ACC          cfb:fbs        
#>  7 cfb    cfb:acc    1959 confere… Atla… ACC        ACC          cfb:fbs        
#>  8 cfb    cfb:acc    1960 confere… Atla… ACC        ACC          cfb:fbs        
#>  9 cfb    cfb:acc    1961 confere… Atla… ACC        ACC          cfb:fbs        
#> 10 cfb    cfb:acc    1962 confere… Atla… ACC        ACC          cfb:fbs        
#> # ℹ 5,540 more rows
#> # ℹ 1 more variable: n_teams <int>
# }
```
