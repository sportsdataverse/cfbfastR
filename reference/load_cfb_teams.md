# Load CFB team info from the data repo

Loads team information including colors and logos - useful for plots!
This function wraps the
[`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md)
function sourced from the College Football Data API.

## Usage

``` r
load_cfb_teams(fbs_only = TRUE)
```

## Arguments

- fbs_only:

  if TRUE, returns only FBS teams, otherwise returns all teams in the
  dataset

## Value

A tibble of team-level image URLs and hex color codes.

## See also

[`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md)

Issues with this data should be filed here:
<https://github.com/sportsdataverse/cfbfastR-data>

Other loaders:
[`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md),
[`load_cfb_rosters()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_rosters.md),
[`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.md),
[`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md)

## Examples

``` r
# \donttest{
  try(load_cfb_teams())
#> ── Team information from CollegeFootballData.com ───────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:26 UTC
#> # A tibble: 136 × 29
#>    team_id school   mascot abbreviation alt_name1 alt_name2 alt_name3 conference
#>      <int> <chr>    <chr>  <chr>        <chr>     <chr>     <chr>     <chr>     
#>  1    2005 Air For… Falco… AF           AF        Air Force NA        Mountain …
#>  2    2006 Akron    Zips   AKR          AKR       Akron     NA        Mid-Ameri…
#>  3     333 Alabama  Crims… ALA          ALA       Alabama   NA        SEC       
#>  4    2026 App Sta… Mount… APP          Appalach… APP       App State Sun Belt  
#>  5      12 Arizona  Wildc… ARIZ         ARIZ      Arizona   NA        Big 12    
#>  6       9 Arizona… Sun D… ASU          ASU       Arizona … NA        Big 12    
#>  7       8 Arkansas Razor… ARK          ARK       Arkansas  NA        SEC       
#>  8    2032 Arkansa… Red W… ARST         ARST      Arkansas… NA        Sun Belt  
#>  9     349 Army     Black… ARMY         ARMY      Army      NA        American …
#> 10       2 Auburn   Tigers AUB          AUB       Auburn    NA        SEC       
#> # ℹ 126 more rows
#> # ℹ 21 more variables: division <chr>, classification <chr>, color <chr>,
#> #   alt_color <chr>, logo <chr>, logo_2 <chr>, twitter <chr>, venue_id <int>,
#> #   venue_name <chr>, city <chr>, state <chr>, zip <chr>, country_code <chr>,
#> #   timezone <chr>, latitude <dbl>, longitude <dbl>, elevation <chr>,
#> #   capacity <int>, year_constructed <int>, grass <lgl>, dome <lgl>
# }
```
