# **Get FBS teams**

**Get FBS teams** Every FBS team for a season.

## Usage

``` r
cfbd_teams_fbs(year = NULL, proxy = NULL)
```

## Arguments

- year:

  (*Integer* optional): Season, 4 digits (YYYY).  
  Minimum value accepted: 1869

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_teams_fbs()` - A tibble with 43 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| id | integer | Record identifier. |
| school | character | School name. |
| mascot | character | Team mascot. |
| abbreviation | character | Abbreviation. |
| alternate_names_1 | character | First alternate team name. |
| alternate_names_2 | character | Second alternate team name. |
| alternate_names_3 | character | Third alternate team name. |
| conference | character | Conference name. |
| division | character | Division. |
| classification | character | Division classification (fbs, fcs, ii, ii/iii, iii). |
| color | character | Primary team color (hex). |
| alternate_color | character | Alternate color. |
| logos_1 | character | Primary team logo URL. |
| logos_2 | character | Alternate (dark) team logo URL. |
| logos_3 | character | Logos 3. |
| logos_4 | character | Logos 4. |
| logos_5 | character | Logos 5. |
| logos_6 | character | Logos 6. |
| logos_7 | character | Logos 7. |
| logos_8 | character | Logos 8. |
| logos_9 | character | Logos 9. |
| logos_10 | character | Logos 10. |
| logos_11 | character | Logos 11. |
| logos_12 | character | Logos 12. |
| logos_13 | character | Logos 13. |
| logos_14 | character | Logos 14. |
| logos_15 | character | Logos 15. |
| logos_16 | character | Logos 16. |
| twitter | character | Team Twitter/X handle. |
| location_id | integer | Venue identifier. |
| location_name | character | Venue name. |
| location_city | character | Venue city. |
| location_state | character | Venue state. |
| location_zip | character | Venue zip. |
| location_country_code | character | Venue country code. |
| location_timezone | character | Venue timezone. |
| location_latitude | numeric | Venue latitude. |
| location_longitude | numeric | Venue longitude. |
| location_elevation | character | Venue elevation. |
| location_capacity | integer | Venue capacity. |
| location_construction_year | integer | Venue construction year. |
| location_grass | logical | Venue grass. |
| location_dome | logical | Venue dome. |

## Examples

``` r
# \donttest{
  try(cfbd_teams_fbs(year = 2024))
#> ── Get FBS teams from CollegeFootballData.com ─────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-01 11:25:05 UTC
#> # A tibble: 134 × 43
#>       id school         mascot  abbreviation alternate_names_1 alternate_names_2
#>    <int> <chr>          <chr>   <chr>        <chr>             <chr>            
#>  1  2005 Air Force      Falcons AF           AF                Air Force        
#>  2  2006 Akron          Zips    AKR          AKR               Akron            
#>  3   333 Alabama        Crimso… ALA          ALA               Alabama          
#>  4  2026 App State      Mounta… APP          Appalachian State APP              
#>  5    12 Arizona        Wildca… ARIZ         ARIZ              Arizona          
#>  6     9 Arizona State  Sun De… ASU          ASU               Arizona St       
#>  7     8 Arkansas       Razorb… ARK          ARK               Arkansas         
#>  8  2032 Arkansas State Red Wo… ARST         ARST              Arkansas St      
#>  9   349 Army           Black … ARMY         ARMY              Army             
#> 10     2 Auburn         Tigers  AUB          AUB               Auburn           
#> # ℹ 124 more rows
#> # ℹ 37 more variables: alternate_names_3 <chr>, conference <chr>,
#> #   division <chr>, classification <chr>, color <chr>, alternate_color <chr>,
#> #   logos_1 <chr>, logos_2 <chr>, logos_3 <chr>, logos_4 <chr>, logos_5 <chr>,
#> #   logos_6 <chr>, logos_7 <chr>, logos_8 <chr>, logos_9 <chr>, logos_10 <chr>,
#> #   logos_11 <chr>, logos_12 <chr>, logos_13 <chr>, logos_14 <chr>,
#> #   logos_15 <chr>, logos_16 <chr>, twitter <chr>, location_id <int>, …
# }
```
