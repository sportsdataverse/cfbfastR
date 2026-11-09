# **ESPN College Football Teams Index**

Get the full ESPN directory of college football teams – one row per team
with identifiers, branding, conference grouping, and logo URLs.

## Usage

``` r
espn_cfb_teams()
```

## Value

A data frame with one row per team:

|                    |           |                                       |
|--------------------|-----------|---------------------------------------|
| col_name           | types     | description                           |
| team_id            | character | ESPN team id.                         |
| uid                | character | ESPN global unique identifier.        |
| slug               | character | URL slug for the team.                |
| abbreviation       | character | Team abbreviation.                    |
| display_name       | character | Full team display name.               |
| short_display_name | character | Short team display name.              |
| name               | character | Team nickname (e.g. `Bulldogs`).      |
| nickname           | character | Team nickname / location label.       |
| location           | character | Team location / school name.          |
| color              | character | Primary team color (hex, no `#`).     |
| alternate_color    | character | Alternate team color (hex, no `#`).   |
| is_active          | logical   | Whether the team is currently active. |
| is_all_star        | logical   | Whether the team is an all-star team. |
| logo_href          | character | URL of the default team logo.         |
| logo_dark_href     | character | URL of the dark-variant team logo.    |

## Details

Wraps the ESPN site-v2 expanded teams endpoint
`site.api.espn.com/apis/site/v2/sports/football/college-football/teams`.
The expanded endpoint returns every team fully inlined in a single call
(no `$ref` dereferencing), so one request produces the whole directory.
The `team_id` column is the ESPN team identifier used as the `team_id`
argument to the other `espn_cfb_team_*()` wrappers.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_teams())
#> ── Teams index from ESPN ───────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:13:35 UTC
#> # A tibble: 763 × 15
#>    team_id uid          slug  abbreviation display_name short_display_name name 
#>    <chr>   <chr>        <chr> <chr>        <chr>        <chr>              <chr>
#>  1 2000    s:20~l:23~t… abil… ACU          Abilene Chr… Abilene Chrstn     Wild…
#>  2 2001    s:20~l:23~t… adam… ADSU         Adams State… Adams St           Griz…
#>  3 2003    s:20~l:23~t… adri… ADR          Adrian Bull… Adrian             Bull…
#>  4 2005    s:20~l:23~t… air-… AF           Air Force F… Air Force          Falc…
#>  5 2006    s:20~l:23~t… akro… AKR          Akron Zips   Akron              Zips 
#>  6 2010    s:20~l:23~t… alab… AAMU         Alabama A&M… Alabama A&M        Bull…
#>  7 333     s:20~l:23~t… alab… ALA          Alabama Cri… Alabama            Crim…
#>  8 2011    s:20~l:23~t… alab… ALST         Alabama Sta… Alabama St         Horn…
#>  9 2013    s:20~l:23~t… alba… ABSU         Albany Stat… Albany St          Gold…
#> 10 2790    s:20~l:23~t… albi… ALBI         Albion Brit… Albion             Brit…
#> # ℹ 753 more rows
#> # ℹ 8 more variables: nickname <chr>, location <chr>, color <chr>,
#> #   alternate_color <chr>, is_active <lgl>, is_all_star <lgl>, logo_href <chr>,
#> #   logo_dark_href <chr>
# }
```
