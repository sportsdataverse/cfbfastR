# CFB Data Games Examples

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

    ## Hit:2 http://azure.archive.ubuntu.com/ubuntu jammy InRelease
    ## Hit:6 https://packages.microsoft.com/repos/azure-cli jammy InRelease
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
    ## 0 upgraded, 0 newly installed, 0 to remove and 45 not upgraded.

    ## ✔ 4 pkgs + 72 deps: kept 71 [10.5s]

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

#### **Get game information**

``` r

df_2018_wk_1 <- cfbfastR::cfbd_game_info(year=2018, week = 1)

df_2018_wk_7_ind <- cfbfastR::cfbd_game_info(year=2018, week = 7, conference = "Ind")

line_scores <- cfbfastR::cfbd_game_info(year=2018, week = 13, team = "Texas A&M", quarter_scores = TRUE)
```

#### **Get calendar weeks and dates**

``` r

cfbfastR::cfbd_calendar(2019)
```

#### **Find game broadcast and media information**

``` r

cfbfastR::cfbd_game_media(2019, week = 4, conference = "ACC")
```

#### **Get CFBD Advanced Game Box Scores (by `game_id`)**

``` r

cfbfastR::cfbd_game_box_advanced(game_id = 401114233)
```

#### **Get CFBD Game Team Box Scores**

``` r

cfbfastR::cfbd_game_team_stats(2019, team = "LSU")
```

    ## ── Team stats data from CollegeFootballData.com ────────────── cfbfastR 3.0.0 ──

    ## ℹ Data updated: 2026-08-27 11:06:32 UTC

    ## # A tibble: 26 × 78
    ##      game_id school     conference home_away opponent opponent_conference points
    ##        <int> <chr>      <chr>      <chr>     <chr>    <chr>                <int>
    ##  1 401110778 Texas      Big 12     home      LSU      SEC                     38
    ##  2 401110778 LSU        SEC        away      Texas    Big 12                  45
    ##  3 401110828 Mississip… SEC        home      LSU      SEC                     13
    ##  4 401110828 LSU        SEC        away      Mississ… SEC                     36
    ##  5 401110833 LSU        SEC        home      Auburn   SEC                     23
    ##  6 401110833 Auburn     SEC        away      LSU      SEC                     20
    ##  7 401110869 LSU        SEC        home      Texas A… SEC                     50
    ##  8 401110869 Texas A&M  SEC        away      LSU      SEC                      7
    ##  9 401110725 LSU        SEC        home      Georgia… Sun Belt                55
    ## 10 401110725 Georgia S… Sun Belt   away      LSU      SEC                      3
    ## # ℹ 16 more rows
    ## # ℹ 71 more variables: total_yards <chr>, net_passing_yards <chr>,
    ## #   completion_attempts <chr>, passing_tds <chr>, yards_per_pass <chr>,
    ## #   passes_intercepted <chr>, interception_yards <chr>, interception_tds <chr>,
    ## #   rushing_attempts <chr>, rushing_yards <chr>, rush_tds <chr>,
    ## #   yards_per_rush_attempt <chr>, first_downs <chr>, third_down_eff <chr>,
    ## #   fourth_down_eff <chr>, punt_returns <chr>, punt_return_yards <chr>, …

``` r

cfbfastR::cfbd_game_team_stats(2013, team = "Florida State")
```

    ## ── Team stats data from CollegeFootballData.com ────────────── cfbfastR 3.0.0 ──
    ## ℹ Data updated: 2026-08-27 11:06:32 UTC

    ## # A tibble: 26 × 78
    ##      game_id school     conference home_away opponent opponent_conference points
    ##        <int> <chr>      <chr>      <chr>     <chr>    <chr>                <int>
    ##  1 332640052 Florida S… ACC        home      Bethune… MEAC                    54
    ##  2 332640052 Bethune-C… MEAC       away      Florida… ACC                      6
    ##  3 333060052 Florida S… ACC        home      Miami    ACC                     41
    ##  4 333060052 Miami      ACC        away      Florida… ACC                     14
    ##  5 333200052 Florida S… ACC        home      Syracuse ACC                     59
    ##  6 333200052 Syracuse   ACC        away      Florida… ACC                      3
    ##  7 333340057 Florida    SEC        home      Florida… ACC                      7
    ##  8 333340057 Florida S… ACC        away      Florida  SEC                     37
    ##  9 332450221 Florida S… ACC        away      Pittsbu… ACC                     41
    ## 10 332450221 Pittsburgh ACC        home      Florida… ACC                     13
    ## # ℹ 16 more rows
    ## # ℹ 71 more variables: total_yards <chr>, net_passing_yards <chr>,
    ## #   completion_attempts <chr>, passing_tds <chr>, yards_per_pass <chr>,
    ## #   passes_intercepted <chr>, interception_yards <chr>, interception_tds <chr>,
    ## #   rushing_attempts <chr>, rushing_yards <chr>, rush_tds <chr>,
    ## #   yards_per_rush_attempt <chr>, first_downs <chr>, third_down_eff <chr>,
    ## #   fourth_down_eff <chr>, punt_returns <chr>, punt_return_yards <chr>, …

#### **Get CFBD Game Player Box Scores**

``` r

cfbfastR::cfbd_game_player_stats(2018, week = 15, conference = "Ind")

cfbfastR::cfbd_game_player_stats(2013, week = 1, team = "Florida State", category = "passing")
```

#### **Get CFBD Team Game Records**

``` r

cfbfastR::cfbd_game_records(2018, team = "Notre Dame")

cfbfastR::cfbd_game_records(2013, team = "Florida State")
```

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
