# CFB Data Teams Examples

### **Load and Install Packages**

``` r
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load(dplyr,tidyr, gt, cfbfastR)
# pacman::p_load_current_gh("sportsdataverse/cfbfastR")
```

### **Get Team Info**

``` r
cfbd_team_info(conference = "SEC")
```

    ## ── Team information from CollegeFootballData.com ───────────── cfbfastR 2.2.1 ──

    ## ℹ Data updated: 2026-01-19 16:24:38 UTC

    ## # A tibble: 16 × 29
    ##    team_id school   mascot abbreviation alt_name1 alt_name2 alt_name3 conference
    ##      <int> <chr>    <chr>  <chr>        <chr>     <chr>     <chr>     <chr>     
    ##  1     333 Alabama  Crims… ALA          ALA       Alabama   NA        SEC       
    ##  2       8 Arkansas Razor… ARK          ARK       Arkansas  NA        SEC       
    ##  3       2 Auburn   Tigers AUB          AUB       Auburn    NA        SEC       
    ##  4      57 Florida  Gators FLA          FLA       Florida   NA        SEC       
    ##  5      61 Georgia  Bulld… UGA          UGA       Georgia   NA        SEC       
    ##  6      96 Kentucky Wildc… UK           UK        Kentucky  NA        SEC       
    ##  7      99 LSU      Tigers LSU          Louisian… LSU       LSU       SEC       
    ##  8     344 Mississ… Bulld… MSST         MSST      Mississi… NA        SEC       
    ##  9     142 Missouri Tigers MIZ          MIZ       Missouri  NA        SEC       
    ## 10     201 Oklahoma Soone… OU           OU        Oklahoma  NA        SEC       
    ## 11     145 Ole Miss Rebels MISS         MISS      Ole Miss  NA        SEC       
    ## 12    2579 South C… Gamec… SC           SC        South Ca… NA        SEC       
    ## 13    2633 Tenness… Volun… TENN         TENN      Tennessee NA        SEC       
    ## 14     251 Texas    Longh… TEX          TEX       Texas     NA        SEC       
    ## 15     245 Texas A… Aggies TA&M         TA&M      Texas A&M NA        SEC       
    ## 16     238 Vanderb… Commo… VAN          VAN       Vanderbi… NA        SEC       
    ## # ℹ 21 more variables: division <lgl>, classification <chr>, color <chr>,
    ## #   alt_color <chr>, logo <chr>, logo_2 <chr>, twitter <chr>, venue_id <int>,
    ## #   venue_name <chr>, city <chr>, state <chr>, zip <chr>, country_code <chr>,
    ## #   timezone <chr>, latitude <dbl>, longitude <dbl>, elevation <chr>,
    ## #   capacity <int>, year_constructed <int>, grass <lgl>, dome <lgl>

``` r
cfbd_team_info(conference = "Ind")
```

    ## ── Team information from CollegeFootballData.com ───────────── cfbfastR 2.2.1 ──
    ## ℹ Data updated: 2026-01-19 16:24:38 UTC

    ## # A tibble: 2 × 29
    ##   team_id school    mascot abbreviation alt_name1 alt_name2 alt_name3 conference
    ##     <int> <chr>     <chr>  <chr>        <chr>     <chr>     <chr>     <chr>     
    ## 1      87 Notre Da… Fight… ND           ND        Notre Da… NA        FBS Indep…
    ## 2      41 UConn     Huski… CONN         Connecti… CONN      UConn     FBS Indep…
    ## # ℹ 21 more variables: division <lgl>, classification <chr>, color <chr>,
    ## #   alt_color <chr>, logo <chr>, logo_2 <chr>, twitter <chr>, venue_id <int>,
    ## #   venue_name <chr>, city <chr>, state <chr>, zip <chr>, country_code <chr>,
    ## #   timezone <chr>, latitude <dbl>, longitude <dbl>, elevation <chr>,
    ## #   capacity <int>, year_constructed <int>, grass <lgl>, dome <lgl>

``` r
cfbd_team_info(year = 2019)
```

    ## ── Team information from CollegeFootballData.com ───────────── cfbfastR 2.2.1 ──
    ## ℹ Data updated: 2026-01-19 16:24:38 UTC

    ## # A tibble: 130 × 29
    ##    team_id school   mascot abbreviation alt_name1 alt_name2 alt_name3 conference
    ##      <int> <chr>    <chr>  <chr>        <chr>     <chr>     <chr>     <chr>     
    ##  1    2005 Air For… Falco… AF           AF        Air Force NA        Mountain …
    ##  2    2006 Akron    Zips   AKR          AKR       Akron     NA        Mid-Ameri…
    ##  3     333 Alabama  Crims… ALA          ALA       Alabama   NA        SEC       
    ##  4    2026 App Sta… Mount… APP          Appalach… APP       App State Sun Belt  
    ##  5      12 Arizona  Wildc… ARIZ         ARIZ      Arizona   NA        Pac-12    
    ##  6       9 Arizona… Sun D… ASU          ASU       Arizona … NA        Pac-12    
    ##  7       8 Arkansas Razor… ARK          ARK       Arkansas  NA        SEC       
    ##  8    2032 Arkansa… Red W… ARST         ARST      Arkansas… NA        Sun Belt  
    ##  9     349 Army     Black… ARMY         ARMY      Army      NA        FBS Indep…
    ## 10       2 Auburn   Tigers AUB          AUB       Auburn    NA        SEC       
    ## # ℹ 120 more rows
    ## # ℹ 21 more variables: division <chr>, classification <chr>, color <chr>,
    ## #   alt_color <chr>, logo <chr>, logo_2 <chr>, twitter <chr>, venue_id <int>,
    ## #   venue_name <chr>, city <chr>, state <chr>, zip <chr>, country_code <chr>,
    ## #   timezone <chr>, latitude <dbl>, longitude <dbl>, elevation <chr>,
    ## #   capacity <int>, year_constructed <int>, grass <lgl>, dome <lgl>

### **Get Team Matchup History (Total Record)**

``` r
cfbd_team_matchup_records("Texas", "Oklahoma")
```

    ## ── Team matchup record from CollegeFootballData.com ────────── cfbfastR 2.2.1 ──

    ## ℹ Data updated: 2026-01-19 16:24:39 UTC

    ## # A tibble: 1 × 7
    ##   start_year end_year team1 team1_wins team2    team2_wins  ties
    ##        <int>    <int> <chr>      <int> <chr>         <int> <int>
    ## 1       1902     2025 Texas         62 Oklahoma         51     5

``` r
cfbd_team_matchup_records("Texas A&M", "TCU", min_year = 1975)
```

    ## ── Team matchup record from CollegeFootballData.com ────────── cfbfastR 2.2.1 ──
    ## ℹ Data updated: 2026-01-19 16:24:39 UTC

    ## # A tibble: 1 × 7
    ##   start_year end_year team1     team1_wins team2 team2_wins  ties
    ##        <int>    <int> <chr>          <int> <chr>      <int> <int>
    ## 1       1975     2001 Texas A&M         22 TCU            0     0

### **Get Team Matchup History**

``` r
cfbd_team_matchup("Texas", "Oklahoma")
```

    ## ── Team matchup history from CollegeFootballData.com ───────── cfbfastR 2.2.1 ──

    ## ℹ Data updated: 2026-01-19 16:24:39 UTC

    ## # A tibble: 118 × 11
    ##    season  week season_type date         neutral_site venue home_team home_score
    ##     <int> <int> <chr>       <chr>        <lgl>        <chr> <chr>          <int>
    ##  1   1902     4 regular     1902-10-04T… FALSE        NA    Texas             22
    ##  2   1903    10 regular     1903-11-13T… FALSE        NA    Oklahoma           5
    ##  3   1903     6 regular     1903-10-17T… FALSE        NA    Oklahoma           6
    ##  4   1904    10 regular     1904-11-16T… FALSE        NA    Texas             40
    ##  5   1905     8 regular     1905-11-03T… FALSE        NA    Oklahoma           2
    ##  6   1906     7 regular     1906-11-02T… FALSE        NA    Oklahoma           9
    ##  7   1907     9 regular     1907-11-15T… FALSE        NA    Texas             29
    ##  8   1908     9 regular     1908-11-13T… FALSE        NA    Oklahoma          50
    ##  9   1909    10 regular     1909-11-19T… FALSE        NA    Texas             30
    ## 10   1910    11 regular     1910-11-24T… FALSE        NA    Texas              0
    ## # ℹ 108 more rows
    ## # ℹ 3 more variables: away_team <chr>, away_score <int>, winner <chr>

``` r
cfbd_team_matchup("Texas A&M", "TCU")
```

    ## ── Team matchup history from CollegeFootballData.com ───────── cfbfastR 2.2.1 ──
    ## ℹ Data updated: 2026-01-19 16:24:39 UTC

    ## # A tibble: 89 × 11
    ##    season  week season_type date         neutral_site venue home_team home_score
    ##     <int> <int> <chr>       <chr>        <lgl>        <lgl> <chr>          <int>
    ##  1   1903    10 regular     1903-11-14T… FALSE        NA    Texas A&M         16
    ##  2   1903    12 regular     1903-11-28T… FALSE        NA    Texas A&M         14
    ##  3   1903     5 regular     1903-10-10T… FALSE        NA    Texas A&M         11
    ##  4   1904     6 regular     1904-10-22T… FALSE        NA    Texas A&M         29
    ##  5   1905     3 regular     1905-09-30T… FALSE        NA    Texas A&M         20
    ##  6   1905     8 regular     1905-11-04T… FALSE        NA    Texas A&M         24
    ##  7   1906     8 regular     1906-11-10T… FALSE        NA    Texas A&M         22
    ##  8   1906     6 regular     1906-10-27T… FALSE        NA    Texas A&M         42
    ##  9   1907     8 regular     1907-11-05T… FALSE        NA    Texas A&M         32
    ## 10   1908     7 regular     1908-10-31T… FALSE        NA    Texas A&M         13
    ## # ℹ 79 more rows
    ## # ℹ 3 more variables: away_team <chr>, away_score <int>, winner <chr>

``` r
cfbd_team_matchup("Texas A&M", "TCU", min_year = 1975)
```

    ## ── Team matchup history from CollegeFootballData.com ───────── cfbfastR 2.2.1 ──
    ## ℹ Data updated: 2026-01-19 16:24:39 UTC

    ## # A tibble: 22 × 11
    ##    season  week season_type date         neutral_site venue home_team home_score
    ##     <int> <int> <chr>       <chr>        <lgl>        <lgl> <chr>          <int>
    ##  1   1975     7 regular     1975-10-18T… FALSE        NA    TCU                6
    ##  2   1976    12 regular     1976-11-20T… FALSE        NA    Texas A&M         59
    ##  3   1977    12 regular     1977-11-19T… FALSE        NA    TCU               23
    ##  4   1978    13 regular     1978-11-25T… FALSE        NA    Texas A&M         15
    ##  5   1979    13 regular     1979-11-24T… FALSE        NA    TCU                7
    ##  6   1980    13 regular     1980-11-22T… FALSE        NA    Texas A&M         13
    ##  7   1981    12 regular     1981-11-21T… FALSE        NA    TCU                7
    ##  8   1982    12 regular     1982-11-20T… FALSE        NA    Texas A&M         34
    ##  9   1983    13 regular     1983-11-19T… FALSE        NA    TCU               10
    ## 10   1984    14 regular     1984-11-24T… FALSE        NA    Texas A&M         35
    ## # ℹ 12 more rows
    ## # ℹ 3 more variables: away_team <chr>, away_score <int>, winner <chr>

``` r
cfbd_team_matchup("Florida State", "Florida", min_year = 1975)
```

    ## ── Team matchup history from CollegeFootballData.com ───────── cfbfastR 2.2.1 ──

    ## ℹ Data updated: 2026-01-19 16:24:40 UTC

    ## # A tibble: 52 × 11
    ##    season  week season_type date         neutral_site venue home_team home_score
    ##     <int> <int> <chr>       <chr>        <lgl>        <chr> <chr>          <int>
    ##  1   1975     7 regular     1975-10-18T… FALSE        NA    Florida           34
    ##  2   1976     7 regular     1976-10-16T… FALSE        NA    Florida …         26
    ##  3   1977    14 regular     1977-12-03T… FALSE        NA    Florida            9
    ##  4   1978    13 regular     1978-11-25T… FALSE        NA    Florida …         38
    ##  5   1979    13 regular     1979-11-24T… FALSE        NA    Florida           16
    ##  6   1980    15 regular     1980-12-06T… FALSE        NA    Florida …         17
    ##  7   1981    13 regular     1981-11-28T… FALSE        NA    Florida           35
    ##  8   1982    14 regular     1982-12-04T… FALSE        NA    Florida …         10
    ##  9   1983    15 regular     1983-12-03T… FALSE        NA    Florida           53
    ## 10   1984    15 regular     1984-12-01T… FALSE        NA    Florida …         17
    ## # ℹ 42 more rows
    ## # ℹ 3 more variables: away_team <chr>, away_score <int>, winner <chr>

### **Get Team Rosters**

``` r
cfbd_team_roster(year = 2013, team = "Florida State")
```

    ## ── Team roster data from CollegeFootballData.com ───────────── cfbfastR 2.2.1 ──

    ## ℹ Data updated: 2026-01-19 16:24:40 UTC

    ## # A tibble: 134 × 17
    ##    athlete_id first_name last_name   team    weight height jersey  year position
    ##    <chr>      <chr>      <chr>       <chr>    <int>  <int>  <int> <int> <chr>   
    ##  1 -1011031   Colton     Woodall     Florid…    190     75     49  2013 DB      
    ##  2 -1011030   James      Wilder, Jr. Florid…    229     74     32  2013 RB      
    ##  3 -1011029   Levonte    Whitfield   Florid…    178     67      7  2013 WR      
    ##  4 -1011028   Jermaine   Washington  Florid…    194     68     36  2013 WR      
    ##  5 -1011027   Jonathan   Wallace     Florid…    295     79     74  2013 OL      
    ##  6 -1011026   Donovan    Todd        Florid…    205     71     39  2013 DB      
    ##  7 -1011025   Bryan      Stork       Florid…    300     76     52  2013 OL      
    ##  8 -1011024   Nathan     Slater      Florid…    223     74     45  2013 LB      
    ##  9 -1011023   Garrett    Scott       Florid…    275     75     69  2013 OL      
    ## 10 -1011022   Michael    Scheerhorn  Florid…    240     76     79  2013 OL      
    ## # ℹ 124 more rows
    ## # ℹ 8 more variables: home_city <chr>, home_state <chr>, home_country <chr>,
    ## #   home_latitude <dbl>, home_longitude <dbl>, home_county_fips <chr>,
    ## #   recruit_ids <list>, headshot_url <chr>

### **Get Team Talent**

``` r
cfbd_team_talent()
```

    ## ── 247sports team talent ratings from CollegeFootballData.com ──────────────────

    ## ℹ Data updated: 2026-01-19 16:24:40 UTC

    ## # A tibble: 134 × 3
    ##     year school     talent
    ##    <int> <chr>       <dbl>
    ##  1  2025 Georgia     1003.
    ##  2  2025 Alabama      994.
    ##  3  2025 Ohio State   974.
    ##  4  2025 Texas        974.
    ##  5  2025 Oregon       941.
    ##  6  2025 LSU          920.
    ##  7  2025 Clemson      918.
    ##  8  2025 Texas A&M    917.
    ##  9  2025 Notre Dame   912.
    ## 10  2025 Penn State   910.
    ## # ℹ 124 more rows

``` r
cfbd_team_talent(year = 2018)
```

    ## ── 247sports team talent ratings from CollegeFootballData.com ──────────────────
    ## ℹ Data updated: 2026-01-19 16:24:40 UTC

    ## # A tibble: 237 × 3
    ##     year school        talent
    ##    <int> <chr>          <dbl>
    ##  1  2018 Ohio State      984.
    ##  2  2018 Alabama         979.
    ##  3  2018 Georgia         964 
    ##  4  2018 USC             934.
    ##  5  2018 Clemson         893.
    ##  6  2018 LSU             890.
    ##  7  2018 Florida State   889.
    ##  8  2018 Michigan        862.
    ##  9  2018 Texas           861.
    ## 10  2018 Notre Dame      848.
    ## # ℹ 227 more rows
