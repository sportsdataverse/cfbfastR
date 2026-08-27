# **Get player recruiting rankings**

**Get player recruiting rankings**

## Usage

``` r
cfbd_recruiting_player(
  year = NULL,
  team = NULL,
  recruit_type = "HighSchool",
  state = NULL,
  position = NULL,
  division = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*) Required if team
  not provided  
  Minimum value accepted: 2000

- team:

  (*String* optional): D-I Team. Required if year not provided

- recruit_type:

  (*String* optional): default API return is 'HighSchool', other options
  include 'JUCO' or 'PrepSchool' - For position group information

- state:

  (*String* optional): Two letter State abbreviation

- position:

  (*String* optional): Position Group - options include:

  - Offense: 'PRO', 'DUAL', 'RB', 'FB', 'TE', 'OT', 'OG', 'OC', 'WR'

  - Defense: 'CB', 'S', 'OLB', 'ILB', 'WDE', 'SDE', 'DT'

  - Special Teams: 'K', 'P'

- division:

  (*String* optional): Division/classification filter – one of `fbs`,
  `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.

## Value

`cfbd_recruiting_player()` - A data frame with 19 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| id | integer | 247Sports referencing id for the recruit. |
| athlete_id | integer | CFBD athlete referencing id linking to player tables. |
| recruit_type | character | Recruit class: High School, Prep School, or Junior College. |
| year | integer | Recruiting class year (four-digit season). |
| ranking | integer | Recruit national ranking within the class. |
| name | character | Recruit full name. |
| school | character | High school, prep school, or JUCO program the recruit attended. |
| committed_to | character | College program the recruit is committed to. |
| position | character | Recruit position abbreviation (e.g. QB, WR, OT). |
| height | numeric | Recruit height in inches. |
| weight | integer | Recruit weight in pounds. |
| stars | integer | Recruit star rating on the 247Sports scale (2-5). |
| rating | numeric | 247Sports composite rating for the recruit. |
| city | character | Hometown city of the recruit. |
| state_province | character | Hometown state or province of the recruit. |
| country | character | Hometown country of the recruit. |
| hometown_info_latitude | character | Latitude of the recruit's hometown. |
| hometown_info_longitude | character | Longitude of the recruit's hometown. |
| hometown_info_fips_code | character | FIPS code of the recruit's hometown. |

## See also

Other CFBD Recruiting:
[`cfbd_recruiting_position()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_position.md),
[`cfbd_recruiting_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_team.md),
[`cfbd_recruiting_transfer_portal()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_transfer_portal.md)

## Examples

``` r
# \donttest{
  try(cfbd_recruiting_player(2018, team = "Texas"))
#> ── Player recruiting info from CollegeFootballData.com ─────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 15:25:23 UTC
#> # A tibble: 28 × 19
#>    id     athlete_id recruit_type  year ranking name         school committed_to
#>    <chr>  <chr>      <chr>        <int>   <int> <chr>        <chr>  <chr>       
#>  1 126288 4362077    HighSchool    2018      19 Caden Sterns Cibol… Texas       
#>  2 126293 4362086    HighSchool    2018      24 B.J. Foster  Angle… Texas       
#>  3 126316 4362074    HighSchool    2018      47 Jalen Green  Heigh… Texas       
#>  4 126321 4362088    HighSchool    2018      52 DeMarvion O… Arp    Texas       
#>  5 126330 4362107    HighSchool    2018      61 Brennan Eag… Alief… Texas       
#>  6 126333 4362076    HighSchool    2018      64 Anthony Cook Houst… Texas       
#>  7 126365 NA         HighSchool    2018      96 Joshua Moore Yoakum Texas       
#>  8 126373 4362109    HighSchool    2018     104 Al'vonte Wo… Houst… Texas       
#>  9 126384 4362082    HighSchool    2018     115 D'Shawn Jam… Houst… Texas       
#> 10 126388 4362091    HighSchool    2018     119 Ayodele Ade… IMG A… Texas       
#> # ℹ 18 more rows
#> # ℹ 11 more variables: position <chr>, height <dbl>, weight <int>, stars <int>,
#> #   rating <dbl>, city <chr>, state_province <chr>, country <chr>,
#> #   hometown_info_latitude <dbl>, hometown_info_longitude <dbl>,
#> #   hometown_info_fips_code <chr>

  try(cfbd_recruiting_player(2016, recruit_type = "JUCO"))
#> ── Player recruiting info from CollegeFootballData.com ─────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 15:25:23 UTC
#> # A tibble: 553 × 19
#>    id     athlete_id recruit_type  year ranking name         school committed_to
#>    <chr>  <chr>      <chr>        <int>   <int> <chr>        <chr>  <chr>       
#>  1 185438 NA         JUCO          2016       1 Jonathan Ko… Arizo… Tennessee   
#>  2 185439 NA         JUCO          2016       2 Charles Bal… ASA C… Alabama     
#>  3 185440 -1039929   JUCO          2016       3 Garett Boll… Snow … Utah        
#>  4 185441 NA         JUCO          2016       4 Malcolm Pri… Nassa… Ohio State  
#>  5 185442 4057659    JUCO          2016       5 Mark Thomps… Dodge… Florida     
#>  6 185443 4038530    JUCO          2016       6 Taj Williams Iowa … TCU         
#>  7 185444 556465     JUCO          2016       7 Jerod Evans  Trini… Virginia Te…
#>  8 185445 NA         JUCO          2016       8 Tyree Horton Highl… TCU         
#>  9 185446 NA         JUCO          2016       9 Ryan Parker  Tyler… TCU         
#> 10 185447 545367     JUCO          2016      10 Derrick Wil… Trini… Texas Tech  
#> # ℹ 543 more rows
#> # ℹ 11 more variables: position <chr>, height <dbl>, weight <int>, stars <int>,
#> #   rating <dbl>, city <chr>, state_province <chr>, country <chr>,
#> #   hometown_info_latitude <dbl>, hometown_info_longitude <dbl>,
#> #   hometown_info_fips_code <chr>

  try(cfbd_recruiting_player(2020, recruit_type = "HighSchool", position = "OT", state = "FL"))
#> ── Player recruiting info from CollegeFootballData.com ─────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 15:25:24 UTC
#> # A tibble: 29 × 19
#>    id     athlete_id recruit_type  year ranking name         school committed_to
#>    <chr>  <chr>      <chr>        <int>   <int> <chr>        <chr>  <chr>       
#>  1 118517 4429039    HighSchool    2020     110 Marcus Dume… St. T… LSU         
#>  2 118535 4429010    HighSchool    2020     128 Jalen Rivers Oakle… Miami       
#>  3 118565 NA         HighSchool    2020     158 Issiah Walk… Miami… Florida     
#>  4 118687 4429177    HighSchool    2020     280 Joshua Braun Suwan… Florida     
#>  5 118711 4433873    HighSchool    2020     304 Connor McLa… Tampa… Stanford    
#>  6 118886 4593066    HighSchool    2020     483 Cayden Baker Fort … North Carol…
#>  7 118939 4565556    HighSchool    2020     533 Michael Ran… Lenna… Georgia Tech
#>  8 254339 4431266    HighSchool    2020     647 Gerald Minc… Cardi… Florida     
#>  9 119485 4568715    HighSchool    2020    1090 Lloyd Willis Miami… Florida Sta…
#> 10 119526 4429232    HighSchool    2020    1131 Bradley Ash… Dunca… Vanderbilt  
#> # ℹ 19 more rows
#> # ℹ 11 more variables: position <chr>, height <int>, weight <int>, stars <int>,
#> #   rating <dbl>, city <chr>, state_province <chr>, country <chr>,
#> #   hometown_info_latitude <dbl>, hometown_info_longitude <dbl>,
#> #   hometown_info_fips_code <chr>
# }
```
