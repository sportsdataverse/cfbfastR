# CFB Data Recruiting Examples

#### **Load and Install Packages**

``` r

if (!requireNamespace('pak', quietly = TRUE)){
  install.packages('pak')
}
pak::pak(c("dplyr", "tidyr", "gt", "cfbfastR"))
```

    ## ℹ Loading metadata database

    ## ✔ Loading metadata database ... done

    ## 

    ## 

    ## → Package library at /home/runner/work/_temp/Library.

    ## ✔ All system requirements are already installed.

    ## 

    ## ℹ No downloads are needed

    ## ℹ Installing system requirements

    ## ℹ Executing `sudo sh -c apt-get -y update`

    ## Get:1 file:/etc/apt/apt-mirrors.txt Mirrorlist [144 B]

    ## Hit:6 https://packages.microsoft.com/repos/azure-cli jammy InRelease
    ## Hit:2 http://azure.archive.ubuntu.com/ubuntu jammy InRelease
    ## Hit:7 https://packages.microsoft.com/ubuntu/22.04/prod jammy InRelease

    ## Hit:3 http://azure.archive.ubuntu.com/ubuntu jammy-updates InRelease
    ## Hit:4 http://azure.archive.ubuntu.com/ubuntu jammy-backports InRelease
    ## Hit:5 http://azure.archive.ubuntu.com/ubuntu jammy-security InRelease

    ## Hit:8 https://dl.google.com/linux/chrome-stable/deb stable InRelease

    ## Reading package lists...

    ## ℹ Executing `sudo sh -c apt-get -y install libicu-dev libcurl4-openssl-dev libssl-dev cmake make libuv1-dev pandoc libnode-dev libxml2-dev`

    ## Reading package lists...

    ## Building dependency tree...

    ## Reading state information...

    ## libicu-dev is already the newest version (70.1-2).
    ## make is already the newest version (4.3-4.1build1).
    ## pandoc is already the newest version (2.9.2.1-3ubuntu2).
    ## cmake is already the newest version (3.22.1-1ubuntu1.22.04.2).
    ## libcurl4-openssl-dev is already the newest version (7.81.0-1ubuntu1.27).
    ## libssl-dev is already the newest version (3.0.2-0ubuntu1.29).
    ## libuv1-dev is already the newest version (1.43.0-1ubuntu0.1).
    ## libxml2-dev is already the newest version (2.9.13+dfsg-1ubuntu0.12).
    ## libnode-dev is already the newest version (12.22.9~dfsg-1ubuntu3.6).
    ## 0 upgraded, 0 newly installed, 0 to remove and 27 not upgraded.

    ## ✔ 4 pkgs + 72 deps: kept 71 [10.9s]

``` r

library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r

library(tidyr)
library(gt)
library(cfbfastR)
# pak::pak("sportsdataverse/cfbfastR")
```

#### **CFBD Recruiting Player**

Gets CFB recruiting information for a single year with filters available
for team, recruit type, state and position.

``` r

cfbd_recruiting_player(2018, team = "Texas")
```

    ## ── Player recruiting info from CollegeFootballData.com ─────── cfbfastR 3.0.0 ──

    ## ℹ Data updated: 2026-08-27 15:35:32 UTC

    ## # A tibble: 28 × 19
    ##    id     athlete_id recruit_type  year ranking name         school committed_to
    ##    <chr>  <chr>      <chr>        <int>   <int> <chr>        <chr>  <chr>       
    ##  1 126288 4362077    HighSchool    2018      19 Caden Sterns Cibol… Texas       
    ##  2 126293 4362086    HighSchool    2018      24 B.J. Foster  Angle… Texas       
    ##  3 126316 4362074    HighSchool    2018      47 Jalen Green  Heigh… Texas       
    ##  4 126321 4362088    HighSchool    2018      52 DeMarvion O… Arp    Texas       
    ##  5 126330 4362107    HighSchool    2018      61 Brennan Eag… Alief… Texas       
    ##  6 126333 4362076    HighSchool    2018      64 Anthony Cook Houst… Texas       
    ##  7 126365 NA         HighSchool    2018      96 Joshua Moore Yoakum Texas       
    ##  8 126373 4362109    HighSchool    2018     104 Al'vonte Wo… Houst… Texas       
    ##  9 126384 4362082    HighSchool    2018     115 D'Shawn Jam… Houst… Texas       
    ## 10 126388 4362091    HighSchool    2018     119 Ayodele Ade… IMG A… Texas       
    ## # ℹ 18 more rows
    ## # ℹ 11 more variables: position <chr>, height <dbl>, weight <int>, stars <int>,
    ## #   rating <dbl>, city <chr>, state_province <chr>, country <chr>,
    ## #   hometown_info_latitude <dbl>, hometown_info_longitude <dbl>,
    ## #   hometown_info_fips_code <chr>

``` r

cfbd_recruiting_player(2016, recruit_type = "JUCO")
```

    ## ── Player recruiting info from CollegeFootballData.com ─────── cfbfastR 3.0.0 ──
    ## ℹ Data updated: 2026-08-27 15:35:32 UTC

    ## # A tibble: 553 × 19
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
    ## # ℹ 543 more rows
    ## # ℹ 11 more variables: position <chr>, height <dbl>, weight <int>, stars <int>,
    ## #   rating <dbl>, city <chr>, state_province <chr>, country <chr>,
    ## #   hometown_info_latitude <dbl>, hometown_info_longitude <dbl>,
    ## #   hometown_info_fips_code <chr>

``` r

cfbd_recruiting_player(2020, recruit_type = "HighSchool", position = "OT", state = "FL")
```

    ## ── Player recruiting info from CollegeFootballData.com ─────── cfbfastR 3.0.0 ──
    ## ℹ Data updated: 2026-08-27 15:35:32 UTC

    ## # A tibble: 29 × 19
    ##    id     athlete_id recruit_type  year ranking name         school committed_to
    ##    <chr>  <chr>      <chr>        <int>   <int> <chr>        <chr>  <chr>       
    ##  1 118517 4429039    HighSchool    2020     110 Marcus Dume… St. T… LSU         
    ##  2 118535 4429010    HighSchool    2020     128 Jalen Rivers Oakle… Miami       
    ##  3 118565 NA         HighSchool    2020     158 Issiah Walk… Miami… Florida     
    ##  4 118687 4429177    HighSchool    2020     280 Joshua Braun Suwan… Florida     
    ##  5 118711 4433873    HighSchool    2020     304 Connor McLa… Tampa… Stanford    
    ##  6 118886 4593066    HighSchool    2020     483 Cayden Baker Fort … North Carol…
    ##  7 118939 4565556    HighSchool    2020     533 Michael Ran… Lenna… Georgia Tech
    ##  8 254339 4431266    HighSchool    2020     647 Gerald Minc… Cardi… Florida     
    ##  9 119485 4568715    HighSchool    2020    1090 Lloyd Willis Miami… Florida Sta…
    ## 10 119526 4429232    HighSchool    2020    1131 Bradley Ash… Dunca… Vanderbilt  
    ## # ℹ 19 more rows
    ## # ℹ 11 more variables: position <chr>, height <int>, weight <int>, stars <int>,
    ## #   rating <dbl>, city <chr>, state_province <chr>, country <chr>,
    ## #   hometown_info_latitude <dbl>, hometown_info_longitude <dbl>,
    ## #   hometown_info_fips_code <chr>

#### **CFB Recruiting Information Position Groups.**

``` r

cfbd_recruiting_position(2018, team = "Texas")
```

    ## ── Recruiting position group info from CollegeFootballData.com ─────────────────

    ## ℹ Data updated: 2026-08-27 15:35:33 UTC

    ## # A tibble: 16 × 7
    ##    team  conference position_group avg_rating total_rating commits avg_stars    
    ##    <chr> <chr>      <chr>               <dbl>        <dbl> <chr>   <chr>        
    ##  1 Texas SEC        Defensive Back      0.937         37.5 40      4.0500000000…
    ##  2 Texas SEC        Defensive Line      0.916         39.4 43      3.7906976744…
    ##  3 Texas SEC        Linebacker          0.898         20.7 23      3.6086956521…
    ##  4 Texas SEC        Offensive Line      0.908         31.8 35      3.7714285714…
    ##  5 Texas SEC        Quarterback         0.927         11.1 12      4.0000000000…
    ##  6 Texas SEC        Receiver            0.919         33.1 36      3.7222222222…
    ##  7 Texas SEC        Running Back        0.918         12.8 14      3.9285714285…
    ##  8 Texas SEC        Special Teams       0.879         21.1 24      3.4166666666…
    ##  9 Texas SEC        All Positions       0.937         37.5 41      4.0500000000…
    ## 10 Texas SEC        All Positions       0.916         39.4 43      3.7906976744…
    ## 11 Texas SEC        All Positions       0.898         20.7 23      3.6086956521…
    ## 12 Texas SEC        All Positions       0.908         31.8 35      3.7714285714…
    ## 13 Texas SEC        All Positions       0.927         11.1 12      4.0000000000…
    ## 14 Texas SEC        All Positions       0.919         33.1 36      3.7222222222…
    ## 15 Texas SEC        All Positions       0.918         12.8 14      3.9285714285…
    ## 16 Texas SEC        All Positions       0.879         21.1 24      3.4166666666…

``` r

cfbd_recruiting_position(2016, 2020, team = "Virginia")
```

    ## ── Recruiting position group info from CollegeFootballData.com ─────────────────
    ## ℹ Data updated: 2026-08-27 15:35:33 UTC

    ## # A tibble: 16 × 7
    ##    team     conference position_group avg_rating total_rating commits avg_stars 
    ##    <chr>    <chr>      <chr>               <dbl>        <dbl> <chr>   <chr>     
    ##  1 Virginia ACC        Defensive Back      0.833        11.7  14      2.8571428…
    ##  2 Virginia ACC        Defensive Line      0.854        13.7  16      3.1250000…
    ##  3 Virginia ACC        Linebacker          0.848        15.3  18      3.0000000…
    ##  4 Virginia ACC        Offensive Line      0.837        14.2  17      2.9411764…
    ##  5 Virginia ACC        Quarterback         0.851         4.26 5       3.0000000…
    ##  6 Virginia ACC        Receiver            0.841        16.0  19      2.9473684…
    ##  7 Virginia ACC        Running Back        0.848         5.94 7       3.0000000…
    ##  8 Virginia ACC        Special Teams       0.837         9.21 11      2.9090909…
    ##  9 Virginia ACC        All Positions       0.833        11.7  16      2.8571428…
    ## 10 Virginia ACC        All Positions       0.854        13.7  16      3.1250000…
    ## 11 Virginia ACC        All Positions       0.848        15.3  18      3.0000000…
    ## 12 Virginia ACC        All Positions       0.837        14.2  17      2.9411764…
    ## 13 Virginia ACC        All Positions       0.851         4.26 5       3.0000000…
    ## 14 Virginia ACC        All Positions       0.841        16.0  20      2.9473684…
    ## 15 Virginia ACC        All Positions       0.848         5.94 8       3.0000000…
    ## 16 Virginia ACC        All Positions       0.837         9.21 11      2.9090909…

``` r

cfbd_recruiting_position(2015, 2020, conference = "SEC")
```

    ## ── Recruiting position group info from CollegeFootballData.com ─────────────────
    ## ℹ Data updated: 2026-08-27 15:35:33 UTC

    ## # A tibble: 224 × 7
    ##    team     conference position_group avg_rating total_rating commits avg_stars 
    ##    <chr>    <chr>      <chr>               <dbl>        <dbl> <chr>   <chr>     
    ##  1 Alabama  SEC        Defensive Back      0.947        21.8  23      4.0000000…
    ##  2 Alabama  SEC        Defensive Line      0.951        27.6  29      4.1724137…
    ##  3 Alabama  SEC        Linebacker          0.935        15.9  17      3.9411764…
    ##  4 Alabama  SEC        Offensive Line      0.937        20.6  22      4.0454545…
    ##  5 Alabama  SEC        Quarterback         0.894         8.94 10      3.7000000…
    ##  6 Alabama  SEC        Receiver            0.920        20.2  22      3.8181818…
    ##  7 Alabama  SEC        Running Back        0.919        13.8  15      3.8000000…
    ##  8 Alabama  SEC        Special Teams       0.880         9.68 11      3.4545454…
    ##  9 Arkansas SEC        Defensive Back      0.863        17.3  20      3.2500000…
    ## 10 Arkansas SEC        Defensive Line      0.883        21.2  24      3.3750000…
    ## # ℹ 214 more rows

#### **CFB Recruiting Information Team Rankings.**

``` r

cfbd_recruiting_team(2018, team = "Texas")
```

    ## ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 3.0.0 ──

    ## ℹ Data updated: 2026-08-27 15:35:33 UTC

    ## # A tibble: 1 × 4
    ##    year team   rank points
    ##   <int> <chr> <int>  <dbl>
    ## 1  2018 Texas     3   300.

``` r

cfbd_recruiting_team(2016, team = "Virginia")
```

    ## ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 3.0.0 ──

    ## ℹ Data updated: 2026-08-27 15:35:34 UTC

    ## # A tibble: 1 × 4
    ##    year team      rank points
    ##   <int> <chr>    <int>  <dbl>
    ## 1  2016 Virginia    63   165.

``` r

cfbd_recruiting_team(2016, team = "Texas A&M")
```

    ## ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 3.0.0 ──

    ## ℹ Data updated: 2026-08-27 15:35:35 UTC

    ## # A tibble: 1 × 4
    ##    year team       rank points
    ##   <int> <chr>     <int>  <dbl>
    ## 1  2016 Texas A&M    18   239.

``` r

cfbd_recruiting_team(2011)
```

    ## ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 3.0.0 ──
    ## ℹ Data updated: 2026-08-27 15:35:35 UTC

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

## **Our Authors**

- [Saiem Gilani](https://x.com/saiemgilani)
  [![@saiemgilani](https://img.shields.io/twitter/follow/saiemgilani?color=blue&label=%40saiemgilani&logo=x&style=for-the-badge)](https://x.com/saiemgilani)
  [![@saiemgilani](https://img.shields.io/github/followers/saiemgilani?color=eee&logo=Github&style=for-the-badge)](https://github.com/saiemgilani)
- [Akshay Easwaran](https://x.com/akeaswaran)
  [![@akeaswaran](https://img.shields.io/twitter/follow/akeaswaran?color=blue&label=%40akeaswaran&logo=x&style=for-the-badge)](https://x.com/akeaswaran)
  [![@akeaswaran](https://img.shields.io/github/followers/akeaswaran?color=eee&logo=Github&style=for-the-badge)](https://github.com/akeaswaran)
- [Jared Lee](https://x.com/JaredDLee)
  [![@JaredDLee](https://img.shields.io/twitter/follow/JaredDLee?color=blue&label=%40JaredDLee&logo=x&style=for-the-badge)](https://x.com/JaredDLee)
  [![@Kazink36](https://img.shields.io/github/followers/Kazink36?color=eee&logo=Github&style=for-the-badge)](https://github.com/Kazink36)
- [Eric Hess](https://x.com/arbitanalytics)
  [![@arbitanalytics](https://img.shields.io/twitter/follow/arbitanalytics?color=blue&label=%40arbitanalytics&logo=x&style=for-the-badge)](https://x.com/arbitanalytics)
  [![@ehess](https://img.shields.io/github/followers/ehess?color=eee&logo=Github&style=for-the-badge)](https://github.com/ehess)

### **Our Contributors**

- [Michael Egle](https://x.com/deceptivespeed_)
  [![@deceptivespeed\_](https://img.shields.io/twitter/follow/deceptivespeed_?color=blue&label=%40deceptivespeed_&logo=x&style=for-the-badge)](https://x.com/deceptivespeed_)
  [![@michaelegle](https://img.shields.io/github/followers/michaelegle?color=eee&logo=Github&style=for-the-badge)](https://github.com/michaelegle)
- [Nate Manzo](https://x.com/cfbnate)
  [![@cfbnate](https://img.shields.io/twitter/follow/cfbnate?color=blue&label=%40cfbnate&logo=x&style=for-the-badge)](https://x.com/cfbnate)
  [![@natemanzo](https://img.shields.io/github/followers/natemanzo?color=eee&logo=Github&style=for-the-badge)](https://github.com/natemanzo)
- [Jason DeLoach](https://x.com/CFBNumbers)
  [![@CFBNumbers](https://img.shields.io/twitter/follow/CFBNumbers?color=blue&label=%40CFBNumbers&logo=x&style=for-the-badge)](https://x.com/CFBNumbers)
  [![@CFBNumbers](https://img.shields.io/github/followers/CFBNumbers?color=eee&logo=Github&style=for-the-badge)](https://github.com/CFBNumbers)
- [Tej Seth](https://x.com/tejfbanalytics)
  [![@tejfbanalytics](https://img.shields.io/twitter/follow/tejfbanalytics?color=blue&label=%40tejfbanalytics&logo=x&style=for-the-badge)](https://x.com/tejfbanalytics)
  [![@tejseth](https://img.shields.io/github/followers/tejseth?color=eee&logo=Github&style=for-the-badge)](https://github.com/tejseth)
- [Conor McQuiston](https://x.com/ConorMcQ5)
  [![@ConorMcQ5](https://img.shields.io/twitter/follow/ConorMcQ5?color=blue&label=%40ConorMcQ5&logo=x&style=for-the-badge)](https://x.com/ConorMcQ5)
  [![@mcqconor](https://img.shields.io/github/followers/mcqconor?color=eee&logo=Github&style=for-the-badge)](https://github.com/mcqconor)
- [Tan Ho](https://x.com/_TanHo)
  [![@\_TanHo](https://img.shields.io/twitter/follow/_TanHo?color=blue&label=%40_TanHo&logo=x&style=for-the-badge)](https://x.com/_TanHo)
  [![@tanho63](https://img.shields.io/github/followers/tanho63?color=eee&logo=Github&style=for-the-badge)](https://github.com/tanho63)
- [Keegan Abdoo](https://x.com/KeeganAbdoo)
  [![@KeeganAbdoo](https://img.shields.io/twitter/follow/KeeganAbdoo?color=blue&label=%40KeeganAbdoo&logo=x&style=for-the-badge)](https://x.com/KeeganAbdoo)
  [![@keegan-abdoo](https://img.shields.io/github/followers/keegan-abdoo?color=eee&logo=Github&style=for-the-badge)](https://github.com/keegan-abdoo)
- [Matt Spencer](https://x.com/Maatspencer)
  [![@Maatspencer](https://img.shields.io/twitter/follow/Maatspencer?color=blue&label=%40Maatspencer&logo=x&style=for-the-badge)](https://x.com/Maatspencer)
  [![@Maatspencer](https://img.shields.io/github/followers/Maatspencer?color=eee&logo=Github&style=for-the-badge)](https://github.com/Maatspencer)
- [Sebastian Carl](https://x.com/mrcaseb)
  [![@mrcaseb](https://img.shields.io/twitter/follow/mrcaseb?color=blue&label=%40mrcaseb&logo=x&style=for-the-badge)](https://x.com/mrcaseb)
  [![@mrcaseb](https://img.shields.io/github/followers/mrcaseb?color=eee&logo=Github&style=for-the-badge)](https://github.com/mrcaseb)
- [John Edwards](https://x.com/John_B_Edwards)
  [![@John_B_Edwards](https://img.shields.io/twitter/follow/John_B_Edwards?color=blue&label=%40John_B_Edwards&logo=x&style=for-the-badge)](https://x.com/John_B_Edwards)
  [![@john-b-edwards](https://img.shields.io/github/followers/john-b-edwards?color=eee&logo=Github&style=for-the-badge)](https://github.com/john-b-edwards)
- [Brad Hill](https://x.com/bradisblogging)
  [![@bradisblogging](https://img.shields.io/twitter/follow/bradisblogging?color=blue&label=%40bradisblogging&logo=x&style=for-the-badge)](https://x.com/bradisblogging)
  [![@bradisbrad](https://img.shields.io/github/followers/bradisbrad?color=eee&logo=Github&style=for-the-badge)](https://github.com/bradisbrad)

### **Citation**

To cite the [**`cfbfastR`**](https://cfbfastR.sportsdataverse.org/) R
package in publications, use:

BibTeX Citation

``` bibtex
@misc{cfbfastr,
  author = {Saiem Gilani and Akshay Easwaran and Jared Lee and Eric Hess},
  title = {cfbfastR: Access College Football Play by Play Data},
  url = {https://cfbfastR.sportsdataverse.org/},
  year = {2021}
}
```

### **Related SportsDataverse packages**

- [**cfbfastR**](https://cfbfastR.sportsdataverse.org/) - college
  football
- [**hoopR**](https://hoopR.sportsdataverse.org/) - men’s basketball
- [**wehoop**](https://wehoop.sportsdataverse.org/) - women’s basketball
- [**baseballr**](https://baseballr.sportsdataverse.org/) - baseball
- [**fastRhockey**](https://fastRhockey.sportsdataverse.org/) - hockey
- [**oddsapiR**](https://oddsapiR.sportsdataverse.org/) - betting odds
- [**sportyR**](https://sportyR.sportsdataverse.org/) - playing surfaces
- [**sportsdataverse-py**](https://py.sportsdataverse.org/) - the Python
  package
- [**sportsdataverse-R**](https://r.sportsdataverse.org/) - the R
  meta-package
