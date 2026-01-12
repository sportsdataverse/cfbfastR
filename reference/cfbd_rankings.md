# **Get historical Coaches and AP poll data**

**Get historical Coaches and AP poll data**

## Usage

``` r
cfbd_rankings(year, week = NULL, season_type = "both")
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)

- week:

  (*Integer* optional): Week, values from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier)

- season_type:

  (*String* default both): Season type - regular, postseason, both,
  allstar, spring_regular, spring_postseason

## Value

`cfbd_rankings()` - A data frame with 9 variables:

|                   |           |
|-------------------|-----------|
| col_name          | types     |
| season            | integer   |
| season_type       | character |
| week              | integer   |
| poll              | character |
| rank              | integer   |
| school            | character |
| conference        | character |
| first_place_votes | integer   |
| points            | integer   |

## See also

Other CFBD Ratings and Rankings:
[`cfbd_ratings_elo()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_elo.md),
[`cfbd_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_fpi.md),
[`cfbd_ratings_sp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp.md),
[`cfbd_ratings_sp_conference()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp_conference.md),
[`cfbd_ratings_srs()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs.md)

## Examples

``` r
# \donttest{
  try(cfbd_rankings(year = 2019, week = 12))
#> ── Rankings data from CollegeFootballData.com ──────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:21:18 UTC
#> # A tibble: 100 × 10
#>    season season_type  week poll       rank teamId school     conference
#>     <int> <chr>       <int> <chr>     <int>  <int> <chr>      <chr>     
#>  1   2019 regular        12 AP Top 25     1     99 LSU        SEC       
#>  2   2019 regular        12 AP Top 25     2    194 Ohio State Big Ten   
#>  3   2019 regular        12 AP Top 25     3    228 Clemson    ACC       
#>  4   2019 regular        12 AP Top 25     4    333 Alabama    SEC       
#>  5   2019 regular        12 AP Top 25     5     61 Georgia    SEC       
#>  6   2019 regular        12 AP Top 25     6   2483 Oregon     Pac-12    
#>  7   2019 regular        12 AP Top 25     7    135 Minnesota  Big Ten   
#>  8   2019 regular        12 AP Top 25     8    254 Utah       Pac-12    
#>  9   2019 regular        12 AP Top 25     9    213 Penn State Big Ten   
#> 10   2019 regular        12 AP Top 25    10    201 Oklahoma   Big 12    
#> # ℹ 90 more rows
#> # ℹ 2 more variables: first_place_votes <int>, points <int>

  try(cfbd_rankings(year = 2018, week = 14))
#> ── Rankings data from CollegeFootballData.com ──────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:21:18 UTC
#> # A tibble: 75 × 10
#>    season season_type  week poll       rank teamId school     conference       
#>     <int> <chr>       <int> <chr>     <int>  <int> <chr>      <chr>            
#>  1   2018 regular        14 AP Top 25     1    333 Alabama    SEC              
#>  2   2018 regular        14 AP Top 25     2    228 Clemson    ACC              
#>  3   2018 regular        14 AP Top 25     3     87 Notre Dame FBS Independents 
#>  4   2018 regular        14 AP Top 25     4     61 Georgia    SEC              
#>  5   2018 regular        14 AP Top 25     5    201 Oklahoma   Big 12           
#>  6   2018 regular        14 AP Top 25     6    194 Ohio State Big Ten          
#>  7   2018 regular        14 AP Top 25     7   2116 UCF        American Athletic
#>  8   2018 regular        14 AP Top 25     8    130 Michigan   Big Ten          
#>  9   2018 regular        14 AP Top 25     9    251 Texas      Big 12           
#> 10   2018 regular        14 AP Top 25    10    264 Washington Pac-12           
#> # ℹ 65 more rows
#> # ℹ 2 more variables: first_place_votes <int>, points <int>

  try(cfbd_rankings(year = 2013, season_type = "postseason"))
#> ── Rankings data from CollegeFootballData.com ──────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:21:18 UTC
#> # A tibble: 75 × 10
#>    season season_type  week poll                   rank teamId school conference
#>     <int> <chr>       <int> <chr>                 <int>  <int> <chr>  <chr>     
#>  1   2013 postseason      1 AFCA Division II Coa…     1    138 North… NA        
#>  2   2013 postseason      1 AFCA Division II Coa…     2   2331 Lenoi… NA        
#>  3   2013 postseason      1 AFCA Division II Coa…     3    125 Grand… NA        
#>  4   2013 postseason      1 AFCA Division II Coa…     4    223 West … NA        
#>  5   2013 postseason      1 AFCA Division II Coa…     5   2594 St. C… NA        
#>  6   2013 postseason      1 AFCA Division II Coa…     6   2364 Minne… NA        
#>  7   2013 postseason      1 AFCA Division II Coa…     7   2570 CSU P… NA        
#>  8   2013 postseason      1 AFCA Division II Coa…     8    134 Minne… NA        
#>  9   2013 postseason      1 AFCA Division II Coa…     9   2974 Sheph… NA        
#> 10   2013 postseason      1 AFCA Division II Coa…    10   2453 North… NA        
#> # ℹ 65 more rows
#> # ℹ 2 more variables: first_place_votes <int>, points <int>
# }
```
