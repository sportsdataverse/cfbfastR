# **Team info lookup**

**Team info lookup**

## Usage

``` r
cfbd_team_info(
  conference = NULL,
  only_fbs = TRUE,
  year = most_recent_cfb_season()
)
```

## Arguments

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC,
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC Required if year not provided

- only_fbs:

  (*Logical* default TRUE): Filter for only returning FBS teams for a
  given year. If year is left blank while only_fbs is TRUE, then will
  return values for most current year

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). Filter for
  getting a list of major division team for a given year. Required if
  conference not provided and the `year` parameter is only supported if
  `only_fbs` is TRUE.  
  Minimum value accepted: 1869

## Value

`cfbd_team_info()` - A data frame with 27 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| team_id | integer | Referencing team id. |
| school | character | Team name. |
| mascot | character | Team mascot. |
| abbreviation | character | Team abbreviations. |
| alt_name1 | character | Team alternate name 1 (as it appears in `play_text`). |
| alt_name2 | character | Team alternate name 2 (as it appears in `play_text`). |
| alt_name3 | character | Team alternate name 3 (as it appears in `play_text`). |
| conference | character | Conference of team. |
| division | character | Division of team within the conference. |
| classification | character | Conference classification (fbs, fcs, ii, iii). |
| color | character | Team color (primary). |
| alt_color | character | Team color (alternate). |
| logos | character | Team logos. |
| venue_id | character | Referencing venue id. |
| venue_name | character | Stadium name. |
| city | character | Team/venue city. |
| state | character | Team/venue state. |
| zip | character | Team/venue zip code. |
| country_code | character | Team/venue country code. |
| timezone | character | Team/venue timezone. |
| latitude | numeric | Venue latitude. |
| longitude | numeric | Venue longitude. |
| elevation | numeric | Venue elevation. |
| capacity | integer | Venue capacity. |
| year_constructed | integer | Year the venue was constructed. |
| grass | logical | TRUE/FALSE response on whether the field is grass or not. |
| dome | logical | TRUE/FALSE flag for if the venue is a domed stadium. |

## See also

Other CFBD Teams:
[`cfbd_team_matchup()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup.md),
[`cfbd_team_matchup_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup_records.md),
[`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.md),
[`cfbd_team_talent()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_talent.md)

## Examples

``` r
# \donttest{
  try(cfbd_team_info(conference = "SEC"))
#> ── Team information from CollegeFootballData.com ───────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 16:40:57 UTC
#> # A tibble: 16 × 43
#>    team_id school   mascot abbreviation alt_name1 alt_name2 alt_name3 conference
#>      <int> <chr>    <chr>  <chr>        <chr>     <chr>     <chr>     <chr>     
#>  1     333 Alabama  Crims… ALA          ALA       Alabama   NA        SEC       
#>  2       8 Arkansas Razor… ARK          ARK       Arkansas  NA        SEC       
#>  3       2 Auburn   Tigers AUB          AUB       Auburn    NA        SEC       
#>  4      57 Florida  Gators FLA          FLA       Florida   NA        SEC       
#>  5      61 Georgia  Bulld… UGA          UGA       Georgia   NA        SEC       
#>  6      96 Kentucky Wildc… UK           UK        Kentucky  NA        SEC       
#>  7      99 LSU      Tigers LSU          Louisian… LSU       LSU       SEC       
#>  8     344 Mississ… Bulld… MSST         MSST      Mississi… NA        SEC       
#>  9     142 Missouri Tigers MIZ          MIZ       Missouri  NA        SEC       
#> 10     201 Oklahoma Soone… OU           OU        Oklahoma  NA        SEC       
#> 11     145 Ole Miss Rebels MISS         MISS      Ole Miss  NA        SEC       
#> 12    2579 South C… Gamec… SC           SC        South Ca… NA        SEC       
#> 13    2633 Tenness… Volun… TENN         TENN      Tennessee NA        SEC       
#> 14     251 Texas    Longh… TEX          TEX       Texas     NA        SEC       
#> 15     245 Texas A… Aggies TA&M         TA&M      Texas A&M NA        SEC       
#> 16     238 Vanderb… Commo… VAN          VAN       Vanderbi… NA        SEC       
#> # ℹ 35 more variables: division <lgl>, classification <chr>, color <chr>,
#> #   alt_color <chr>, logo <chr>, logo_2 <chr>, logos_3 <chr>, logos_4 <chr>,
#> #   logos_5 <chr>, logos_6 <chr>, logos_7 <chr>, logos_8 <chr>, logos_9 <chr>,
#> #   logos_10 <chr>, logos_11 <chr>, logos_12 <chr>, logos_13 <chr>,
#> #   logos_14 <chr>, logos_15 <chr>, logos_16 <chr>, twitter <chr>,
#> #   venue_id <int>, venue_name <chr>, city <chr>, state <chr>, zip <chr>,
#> #   country_code <chr>, timezone <chr>, latitude <dbl>, longitude <dbl>, …

  try(cfbd_team_info(conference = "Ind"))
#> ── Team information from CollegeFootballData.com ───────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 16:40:57 UTC
#> # A tibble: 2 × 43
#>   team_id school    mascot abbreviation alt_name1 alt_name2 alt_name3 conference
#>     <int> <chr>     <chr>  <chr>        <chr>     <chr>     <chr>     <chr>     
#> 1      87 Notre Da… Fight… ND           ND        Notre Da… NA        FBS Indep…
#> 2      41 UConn     Huski… CONN         Connecti… CONN      UConn     FBS Indep…
#> # ℹ 35 more variables: division <lgl>, classification <chr>, color <chr>,
#> #   alt_color <chr>, logo <chr>, logo_2 <chr>, logos_3 <chr>, logos_4 <chr>,
#> #   logos_5 <chr>, logos_6 <chr>, logos_7 <chr>, logos_8 <chr>, logos_9 <chr>,
#> #   logos_10 <chr>, logos_11 <chr>, logos_12 <chr>, logos_13 <chr>,
#> #   logos_14 <chr>, logos_15 <chr>, logos_16 <chr>, twitter <chr>,
#> #   venue_id <int>, venue_name <chr>, city <chr>, state <chr>, zip <chr>,
#> #   country_code <chr>, timezone <chr>, latitude <dbl>, longitude <dbl>, …

  try(cfbd_team_info(year = 2019))
#> ── Team information from CollegeFootballData.com ───────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 16:40:57 UTC
#> # A tibble: 130 × 43
#>    team_id school   mascot abbreviation alt_name1 alt_name2 alt_name3 conference
#>      <int> <chr>    <chr>  <chr>        <chr>     <chr>     <chr>     <chr>     
#>  1    2005 Air For… Falco… AF           AF        Air Force NA        Mountain …
#>  2    2006 Akron    Zips   AKR          AKR       Akron     NA        Mid-Ameri…
#>  3     333 Alabama  Crims… ALA          ALA       Alabama   NA        SEC       
#>  4    2026 App Sta… Mount… APP          Appalach… APP       App State Sun Belt  
#>  5      12 Arizona  Wildc… ARIZ         ARIZ      Arizona   NA        Pac-12    
#>  6       9 Arizona… Sun D… ASU          ASU       Arizona … NA        Pac-12    
#>  7       8 Arkansas Razor… ARK          ARK       Arkansas  NA        SEC       
#>  8    2032 Arkansa… Red W… ARST         ARST      Arkansas… NA        Sun Belt  
#>  9     349 Army     Black… ARMY         ARMY      Army      NA        FBS Indep…
#> 10       2 Auburn   Tigers AUB          AUB       Auburn    NA        SEC       
#> # ℹ 120 more rows
#> # ℹ 35 more variables: division <chr>, classification <chr>, color <chr>,
#> #   alt_color <chr>, logo <chr>, logo_2 <chr>, logos_3 <chr>, logos_4 <chr>,
#> #   logos_5 <chr>, logos_6 <chr>, logos_7 <chr>, logos_8 <chr>, logos_9 <chr>,
#> #   logos_10 <chr>, logos_11 <chr>, logos_12 <chr>, logos_13 <chr>,
#> #   logos_14 <chr>, logos_15 <chr>, logos_16 <chr>, twitter <chr>,
#> #   venue_id <int>, venue_name <chr>, city <chr>, state <chr>, zip <chr>, …
# }
```
