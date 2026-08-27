# **Load college football recruiting rankings from the SportsDataverse data repo**

Loads player recruiting rankings – one row per recruit-season with
stars, rating, position, and school commitment. Published to the
`cfb_recruits` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_cfb_recruits(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2002 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2002)

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

|             |           |             |
|-------------|-----------|-------------|
| col_name    | types     | description |
| season      | integer   |             |
| team_id     | integer   |             |
| team_id_247 | character |             |
| team        | character |             |
| recruit_id  | character |             |
| player_name | character |             |
| stars       | integer   |             |
| grade       | double    |             |
| position    | character |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_recruits(2002))
#> ── college football recruiting rankings from the SportsDataverse data repo ─────
#> ℹ Data updated: 2026-08-27 11:51:51 UTC
#> # A tibble: 2,058 × 9
#>    season team_id team_id_247 team   recruit_id player_name stars grade position
#>     <int> <chr>   <chr>       <chr>  <chr>      <chr>       <int> <dbl> <chr>   
#>  1   2002 265     162         Washi… 51246      Matt Mulle…     2  76.7 ILB     
#>  2   2002 61      172         Georg… 49964      Leonard Po…     4  93.3 TE      
#>  3   2002 265     162         Washi… 51240      Don Jackson    NA  NA   ILB     
#>  4   2002 2390    13          Miami… 26668      Ryan Moore      5  99.9 WR      
#>  5   2002 265     162         Washi… 51230      Robert Fra…     2  76.7 ATH     
#>  6   2002 2390    13          Miami… 18057      Devin Hest…     5  98.8 ATH     
#>  7   2002 127     73          Michi… 50790      Brandon Fi…     2  76.7 K       
#>  8   2002 265     162         Washi… 51265      Jesse Tayl…     4  90   TE      
#>  9   2002 265     162         Washi… 51212      Cody Boyd       3  86.7 TE      
#> 10   2002 265     162         Washi… 51264      Jonathan S…     4  90   APB     
#> # ℹ 2,048 more rows
# }
```
