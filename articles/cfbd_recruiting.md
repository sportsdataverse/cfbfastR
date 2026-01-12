# CFB Data Recruiting Examples

### **Load and Install Packages**

``` r
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load(dplyr,tidyr, gt, cfbfastR)
# pacman::p_load_current_gh("sportsdataverse/cfbfastR")
```

### **CFBD Recruiting Player**

Gets CFB recruiting information for a single year with filters available
for team, recruit type, state and position.

``` r
cfbd_recruiting_player(2018, team = "Texas")
```

    ## ── Player recruiting info from CollegeFootballData.com ─────── cfbfastR 2.2.0 ──

    ## ℹ Data updated: 2026-01-12 06:35:24 UTC

    ## # A tibble: 28 × 19
    ##    id     athlete_id recruit_type  year ranking name         school committed_to
    ##    <chr>  <chr>      <chr>        <int>   <int> <chr>        <chr>  <chr>       
    ##  1 126288 4362077    HighSchool    2018      19 Caden Sterns Steele Texas       
    ##  2 126293 4362086    HighSchool    2018      24 B.J. Foster  Angle… Texas       
    ##  3 126316 4362074    HighSchool    2018      47 Jalen Green  Heigh… Texas       
    ##  4 126321 4362088    HighSchool    2018      52 DeMarvion O… Arp    Texas       
    ##  5 126330 4362107    HighSchool    2018      61 Brennan Eag… Alief… Texas       
    ##  6 126333 4362076    HighSchool    2018      64 Anthony Cook Lamar  Texas       
    ##  7 126365 NA         HighSchool    2018      96 Joshua Moore Yoakum Texas       
    ##  8 126373 4362109    HighSchool    2018     104 Al'vonte Wo… Lamar  Texas       
    ##  9 126384 4362082    HighSchool    2018     115 D'Shawn Jam… Lamar  Texas       
    ## 10 126388 4362091    HighSchool    2018     119 Ayodele Ade… IMG A… Texas       
    ## # ℹ 18 more rows
    ## # ℹ 11 more variables: position <chr>, height <dbl>, weight <int>, stars <int>,
    ## #   rating <dbl>, city <chr>, state_province <chr>, country <chr>,
    ## #   hometown_info_latitude <dbl>, hometown_info_longitude <dbl>,
    ## #   hometown_info_fips_code <chr>

``` r
cfbd_recruiting_player(2016, recruit_type = "JUCO")
```

    ## ── Player recruiting info from CollegeFootballData.com ─────── cfbfastR 2.2.0 ──
    ## ℹ Data updated: 2026-01-12 06:35:24 UTC

    ## # A tibble: 470 × 19
    ##    id     athlete_id recruit_type  year ranking name         school committed_to
    ##    <chr>  <chr>      <chr>        <int>   <int> <chr>        <chr>  <chr>       
    ##  1 185438 NA         JUCO          2016       1 Jonathan Ko… Arizo… Tennessee   
    ##  2 185439 NA         JUCO          2016       2 Charles Bal… ASA C… Alabama     
    ##  3 185440 -1039929   JUCO          2016       3 Garett Boll… Snow … Utah        
    ##  4 185441 NA         JUCO          2016       4 Malcolm Pri… Nassa… Ohio State  
    ##  5 185442 4057659    JUCO          2016       5 Mark Thomps… Dodge… Florida     
    ##  6 185443 4038530    JUCO          2016       6 Taj Williams Iowa … TCU         
    ##  7 185444 556465     JUCO          2016       7 Jerod Evans  Trini… Virginia Te…
    ##  8 185445 NA         JUCO          2016       8 Tyree Horton Highl… TCU         
    ##  9 185446 NA         JUCO          2016       9 Ryan Parker  Tyler… TCU         
    ## 10 185447 545367     JUCO          2016      10 Derrick Wil… Trini… Texas Tech  
    ## # ℹ 460 more rows
    ## # ℹ 11 more variables: position <chr>, height <dbl>, weight <int>, stars <int>,
    ## #   rating <dbl>, city <chr>, state_province <chr>, country <chr>,
    ## #   hometown_info_latitude <dbl>, hometown_info_longitude <dbl>,
    ## #   hometown_info_fips_code <chr>

``` r
cfbd_recruiting_player(2020, recruit_type = "HighSchool", position = "OT", state = "FL")
```

    ## ── Player recruiting info from CollegeFootballData.com ─────── cfbfastR 2.2.0 ──
    ## ℹ Data updated: 2026-01-12 06:35:24 UTC

    ## # A tibble: 25 × 19
    ##    id     athlete_id recruit_type  year ranking name         school committed_to
    ##    <chr>  <chr>      <chr>        <int>   <int> <chr>        <chr>  <chr>       
    ##  1 118517 4429039    HighSchool    2020     110 Marcus Dume… St. T… LSU         
    ##  2 118535 4429010    HighSchool    2020     128 Jalen Rivers Oakle… Miami       
    ##  3 118565 NA         HighSchool    2020     158 Issiah Walk… Norla… Florida     
    ##  4 118687 4429177    HighSchool    2020     280 Joshua Braun Suwan… Florida     
    ##  5 118711 4433873    HighSchool    2020     304 Connor McLa… Jesuit Stanford    
    ##  6 118886 4593066    HighSchool    2020     483 Cayden Baker Fort … North Carol…
    ##  7 118939 4565556    HighSchool    2020     533 Michael Ran… Lenna… Georgia Tech
    ##  8 119485 NA         HighSchool    2020    1090 Lloyd Willis Killi… NA          
    ##  9 119526 NA         HighSchool    2020    1131 Bradley Ash… Dunca… NA          
    ## 10 119570 NA         HighSchool    2020    1167 Cade Kootso… Crest… NA          
    ## # ℹ 15 more rows
    ## # ℹ 11 more variables: position <chr>, height <int>, weight <int>, stars <int>,
    ## #   rating <dbl>, city <chr>, state_province <chr>, country <chr>,
    ## #   hometown_info_latitude <dbl>, hometown_info_longitude <dbl>,
    ## #   hometown_info_fips_code <chr>

### **CFB Recruiting Information Position Groups.**

``` r
cfbd_recruiting_position(2018, team = "Texas")
```

    ## ── Recruiting position group info from CollegeFootballData.com ─────────────────

    ## ℹ Data updated: 2026-01-12 06:35:24 UTC

    ## # A tibble: 16 × 7
    ##    team  conference position_group avg_rating total_rating commits avg_stars    
    ##    <chr> <chr>      <chr>               <dbl>        <dbl> <chr>   <chr>        
    ##  1 Texas SEC        Defensive Back      0.939         34.7 37      4.0810810810…
    ##  2 Texas SEC        Defensive Line      0.923         35.1 38      3.8947368421…
    ##  3 Texas SEC        Linebacker          0.902         18.9 21      3.6190476190…
    ##  4 Texas SEC        Offensive Line      0.914         26.5 29      3.8965517241…
    ##  5 Texas SEC        Quarterback         0.933         10.3 11      4.0909090909…
    ##  6 Texas SEC        Receiver            0.927         27.8 30      3.8333333333…
    ##  7 Texas SEC        Running Back        0.930         11.2 12      4.0833333333…
    ##  8 Texas SEC        Special Teams       0.878         17.6 20      3.4500000000…
    ##  9 Texas SEC        All Positions       0.939         34.7 37      4.0810810810…
    ## 10 Texas SEC        All Positions       0.923         35.1 38      3.8947368421…
    ## 11 Texas SEC        All Positions       0.902         18.9 21      3.6190476190…
    ## 12 Texas SEC        All Positions       0.914         26.5 29      3.8965517241…
    ## 13 Texas SEC        All Positions       0.933         10.3 11      4.0909090909…
    ## 14 Texas SEC        All Positions       0.927         27.8 30      3.8333333333…
    ## 15 Texas SEC        All Positions       0.930         11.2 12      4.0833333333…
    ## 16 Texas SEC        All Positions       0.878         17.6 20      3.4500000000…

``` r
cfbd_recruiting_position(2016, 2020, team = "Virginia")
```

    ## ── Recruiting position group info from CollegeFootballData.com ─────────────────

    ## ℹ Data updated: 2026-01-12 06:35:25 UTC

    ## # A tibble: 16 × 7
    ##    team     conference position_group avg_rating total_rating commits avg_stars 
    ##    <chr>    <chr>      <chr>               <dbl>        <dbl> <chr>   <chr>     
    ##  1 Virginia ACC        Defensive Back      0.831         9.15 11      2.8181818…
    ##  2 Virginia ACC        Defensive Line      0.851         7.66 9       3.2222222…
    ##  3 Virginia ACC        Linebacker          0.848         7.63 9       3.0000000…
    ##  4 Virginia ACC        Offensive Line      0.827         7.44 9       2.8888888…
    ##  5 Virginia ACC        Quarterback         0.853         1.71 2       3.0000000…
    ##  6 Virginia ACC        Receiver            0.835        10.0  12      2.9166666…
    ##  7 Virginia ACC        Running Back        0.836         3.35 4       3.0000000…
    ##  8 Virginia ACC        Special Teams       0.839         7.55 9       2.8888888…
    ##  9 Virginia ACC        All Positions       0.831         9.15 11      2.8181818…
    ## 10 Virginia ACC        All Positions       0.851         7.66 9       3.2222222…
    ## 11 Virginia ACC        All Positions       0.848         7.63 9       3.0000000…
    ## 12 Virginia ACC        All Positions       0.827         7.44 9       2.8888888…
    ## 13 Virginia ACC        All Positions       0.853         1.71 2       3.0000000…
    ## 14 Virginia ACC        All Positions       0.835        10.0  12      2.9166666…
    ## 15 Virginia ACC        All Positions       0.836         3.35 4       3.0000000…
    ## 16 Virginia ACC        All Positions       0.839         7.55 9       2.8888888…

``` r
cfbd_recruiting_position(2015, 2020, conference = "SEC")
```

    ## ── Recruiting position group info from CollegeFootballData.com ─────────────────
    ## ℹ Data updated: 2026-01-12 06:35:25 UTC

    ## # A tibble: 224 × 7
    ##    team     conference position_group avg_rating total_rating commits avg_stars 
    ##    <chr>    <chr>      <chr>               <dbl>        <dbl> <chr>   <chr>     
    ##  1 Alabama  SEC        Defensive Back      0.950        20.9  22      4.0454545…
    ##  2 Alabama  SEC        Defensive Line      0.951        27.6  29      4.1724137…
    ##  3 Alabama  SEC        Linebacker          0.941        15.1  16      4.0000000…
    ##  4 Alabama  SEC        Offensive Line      0.939        19.7  21      4.0476190…
    ##  5 Alabama  SEC        Quarterback         0.894         8.94 10      3.7000000…
    ##  6 Alabama  SEC        Receiver            0.923        19.4  21      3.8571428…
    ##  7 Alabama  SEC        Running Back        0.919        13.8  15      3.8000000…
    ##  8 Alabama  SEC        Special Teams       0.892         7.13 8       3.6250000…
    ##  9 Arkansas SEC        Defensive Back      0.861        13.8  16      3.2500000…
    ## 10 Arkansas SEC        Defensive Line      0.891        14.3  16      3.5000000…
    ## # ℹ 214 more rows

### **CFB Recruiting Information Team Rankings.**

``` r
cfbd_recruiting_team(2018, team = "Texas")
```

    ## ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 2.2.0 ──

    ## ℹ Data updated: 2026-01-12 06:35:25 UTC

    ## # A tibble: 1 × 4
    ##    year team   rank points
    ##   <int> <chr> <int>  <dbl>
    ## 1  2018 Texas     3   300.

``` r
cfbd_recruiting_team(2016, team = "Virginia")
```

    ## ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 2.2.0 ──
    ## ℹ Data updated: 2026-01-12 06:35:25 UTC

    ## # A tibble: 1 × 4
    ##    year team      rank points
    ##   <int> <chr>    <int>  <dbl>
    ## 1  2016 Virginia    63   165.

``` r
cfbd_recruiting_team(2016, team = "Texas A&M")
```

    ## ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 2.2.0 ──
    ## ℹ Data updated: 2026-01-12 06:35:25 UTC

    ## # A tibble: 1 × 4
    ##    year team       rank points
    ##   <int> <chr>     <int>  <dbl>
    ## 1  2016 Texas A&M    18   239.

``` r
cfbd_recruiting_team(2011)
```

    ## ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 2.2.0 ──
    ## ℹ Data updated: 2026-01-12 06:35:25 UTC

    ## # A tibble: 137 × 4
    ##     year team           rank points
    ##    <int> <chr>         <int>  <dbl>
    ##  1  2011 Alabama           1   298.
    ##  2  2011 Florida State     2   297.
    ##  3  2011 USC               3   287.
    ##  4  2011 Texas             4   284.
    ##  5  2011 Auburn            5   281.
    ##  6  2011 Ohio State        6   278.
    ##  7  2011 Georgia           7   278.
    ##  8  2011 LSU               8   273.
    ##  9  2011 Notre Dame        9   271.
    ## 10  2011 Clemson          10   270.
    ## # ℹ 127 more rows
