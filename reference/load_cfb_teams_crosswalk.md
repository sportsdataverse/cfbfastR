# **Load college football team id crosswalk from the SportsDataverse data repo**

Loads the team-level id crosswalk linking CFBD team ids to ESPN team ids
– one row per team-season. Published to the `cfb_crosswalk` release tag
on the sportsdataverse-data repo.

## Usage

``` r
load_cfb_teams_crosswalk(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2014 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2014)

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
| norm_key | character | Shared join key across providers: the team name lowercased, ASCII-folded, stripped of punctuation, whitespace-collapsed, and alias-mapped. |
| espn_team_id | integer | ESPN team id for the crosswalk row. |
| espn_team | character | ESPN's full team display name, school plus mascot, null when the row was anchored on a non-ESPN provider. |
| espn_abbreviation | character |  |
| fox_team_id | character | Fox Sports team id for the same team. |
| fox_team | character | Fox Sports' team name, which that feed ships in all capitals. |
| fox_abbreviation | character | Fox Sports' short team code, which frequently differs from the ESPN abbreviation for the same school. |
| yahoo_team_id | character | Yahoo Sports team id for the same team. |
| yahoo_team | character | Yahoo Sports' team display name, school plus mascot. |
| yahoo_abbreviation | character | Yahoo Sports' short team code for the school. |
| matched_sources | character | Plus-joined provenance tag naming which of espn, fox, and yahoo contributed a directory row for this team. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_teams_crosswalk(2014))
#> ── college football team id crosswalk from the SportsDataverse data repo ───────
#> ℹ Data updated: 2026-08-24 13:06:21 UTC
#> # A tibble: 828 × 11
#>    norm_key        espn_team_id espn_team espn_abbreviation fox_team_id fox_team
#>    <chr>                  <int> <chr>     <chr>             <chr>       <chr>   
#>  1 abilene christ…         2000 Abilene … ACU               276         ABILENE…
#>  2 adams state gr…         2001 Adams St… ADSU              451         ADAMS S…
#>  3 adrian bulldogs         2003 Adrian B… ADR               818         ADRIAN …
#>  4 air force falc…         2005 Air Forc… AF                77          AIR FOR…
#>  5 akron zips              2006 Akron Zi… AKR               64          AKRON Z…
#>  6 alabama a m bu…         2010 Alabama … AAMU              227         ALABAMA…
#>  7 alabama crimso…          333 Alabama … ALA               101         ALABAMA…
#>  8 alabama state …         2011 Alabama … ALST              228         ALABAMA…
#>  9 albany state g…         2013 Albany S… ABSU              332         ALBANY …
#> 10 albion britons          2790 Albion B… ALBI              NA          NA      
#> # ℹ 818 more rows
#> # ℹ 5 more variables: fox_abbreviation <chr>, yahoo_team_id <chr>,
#> #   yahoo_team <chr>, yahoo_abbreviation <chr>, matched_sources <chr>
# }
```
