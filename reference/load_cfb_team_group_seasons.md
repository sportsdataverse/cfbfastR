# **Load college football team conference membership by season from the SportsDataverse data repo**

Loads one row per college football team per season with the team's
subdivision, conference, and division that season, taken from the most
reliable per-season source and cross-checked against a second source
where one exists. Membership is never back-filled from today's
alignment. Published to the `cfb_groups` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_cfb_team_group_seasons(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons (fall year). Published coverage runs 1869 through the most
  recent season; 1871, when no intercollegiate games were played, has no
  file. Pass `seasons = TRUE` to read every published season from one
  file. (Min: 1869)

- ...:

  Additional arguments passed to an underlying function that writes the
  data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble with one row per team-season.

|  |  |  |
|----|----|----|
| col_name | types | description |
| league | character | League key, always `cfb`. |
| season | integer | Season (fall year; 2025 = fall 2025). |
| team_id | character | ESPN team id where ESPN covers the team, otherwise the CFBD team id (see `team_id_source`). |
| team_id_source | character | Id system of `team_id`: `espn` or `cfbd`. |
| team_name | character | Team name as of that season. |
| subdivision_id | character | SDV group id of the subdivision (`cfb:fbs`, `cfb:fcs`, ...); `NA` where it does not apply. |
| conference_id | character | SDV group id of the conference. |
| division_id | character | SDV group id of the conference division; `NA` where the conference had none. |
| source | character | Source the membership came from: `espn` or `cfbd`. |
| sources_agree | logical | Whether a second source agrees; `NA` when only one source covers the season. |
| notes | character | Membership caveats. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_team_group_seasons(2024))
#> ── college football team conference membership by season from the SportsDatavers
#> ℹ Data updated: 2026-10-01 01:44:55 UTC
#> # A tibble: 677 × 11
#>    league season team_id team_id_source team_name   subdivision_id conference_id
#>    <chr>   <int> <chr>   <chr>          <chr>       <chr>          <chr>        
#>  1 cfb      2024 101     espn           Eureka      cfb:d3         cfb:nacc     
#>  2 cfb      2024 101161  espn           Lyon        cfb:d3         cfb:southern…
#>  3 cfb      2024 101442  espn           Centenary … cfb:d3         cfb:southern…
#>  4 cfb      2024 101784  espn           Erskine     cfb:d2         cfb:gulf-sou…
#>  5 cfb      2024 103     espn           Boston Col… cfb:fbs        cfb:acc      
#>  6 cfb      2024 107     espn           Holy Cross  cfb:fcs        cfb:patriot  
#>  7 cfb      2024 108     espn           Harvard     cfb:fcs        cfb:ivy      
#>  8 cfb      2024 109     espn           MIT         cfb:d3         cfb:newmac   
#>  9 cfb      2024 109418  espn           Finlandia … cfb:d3         cfb:upper-mi…
#> 10 cfb      2024 11      espn           Colorado M… cfb:d2         cfb:rocky-mo…
#> # ℹ 667 more rows
#> # ℹ 4 more variables: division_id <chr>, source <chr>, sources_agree <lgl>,
#> #   notes <chr>
# }
```
