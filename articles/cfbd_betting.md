# CFB Data Betting Lines Examples

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

    ## → Will install 1 system package:

    ## + libnode-dev  - V8

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
    ## The following additional packages will be installed:

    ## libnode72

    ## The following NEW packages will be installed:

    ## libnode-dev libnode72

    ## 0 upgraded, 2 newly installed, 0 to remove and 27 not upgraded.
    ## Need to get 11.4 MB of archives.
    ## After this operation, 47.4 MB of additional disk space will be used.
    ## Get:1 file:/etc/apt/apt-mirrors.txt Mirrorlist [144 B]

    ## Get:2 http://azure.archive.ubuntu.com/ubuntu jammy-updates/universe amd64 libnode72 amd64 12.22.9~dfsg-1ubuntu3.6 [10.8 MB]

    ## Get:3 http://azure.archive.ubuntu.com/ubuntu jammy-updates/universe amd64 libnode-dev amd64 12.22.9~dfsg-1ubuntu3.6 [609 kB]

    ## Fetched 11.4 MB in 0s (81.1 MB/s)

    ## Selecting previously unselected package libnode72:amd64.
    ## (Reading database ...

    ## (Reading database ... 5%(Reading database ... 10%(Reading database ... 15%(Reading database ... 20%(Reading database ... 25%(Reading database ... 30%(Reading database ... 35%(Reading database ... 40%(Reading database ... 45%(Reading database ... 50%(Reading database ... 55%

    ## (Reading database ... 60%

    ## (Reading database ... 65%

    ## (Reading database ... 70%

    ## (Reading database ... 75%

    ## (Reading database ... 80%

    ## (Reading database ... 85%

    ## (Reading database ... 90%

    ## (Reading database ... 95%

    ## (Reading database ... 100%(Reading database ... 309923 files and directories currently installed.)

    ## Preparing to unpack .../libnode72_12.22.9~dfsg-1ubuntu3.6_amd64.deb ...

    ## Unpacking libnode72:amd64 (12.22.9~dfsg-1ubuntu3.6) ...

    ## Selecting previously unselected package libnode-dev.

    ## Preparing to unpack .../libnode-dev_12.22.9~dfsg-1ubuntu3.6_amd64.deb ...

    ## Unpacking libnode-dev (12.22.9~dfsg-1ubuntu3.6) ...

    ## Setting up libnode72:amd64 (12.22.9~dfsg-1ubuntu3.6) ...

    ## Setting up libnode-dev (12.22.9~dfsg-1ubuntu3.6) ...

    ## Processing triggers for libc-bin (2.35-0ubuntu3.14) ...

    ## Running kernel seems to be up-to-date.
    ## 
    ## Services to be restarted:

    ## systemctl restart packagekit.service

    ## systemctl restart php8.1-fpm.service

    ## systemctl restart ssh.service

    ## systemctl restart systemd-journald.service

    ## /etc/needrestart/restart.d/systemd-manager

    ## systemctl restart systemd-networkd.service

    ## systemctl restart systemd-resolved.service

    ## systemctl restart systemd-udevd.service

    ## Service restarts being deferred:
    ##  systemctl restart hosted-compute-agent.service
    ##  systemctl restart systemd-logind.service
    ##  systemctl restart user@1001.service

    ## systemctl restart walinuxagent.service
    ## 
    ## No containers need to be restarted.
    ## 
    ## No user sessions are running outdated binaries.
    ## 
    ## No VM guests are running outdated hypervisor (qemu) binaries on this host.

    ## ✔ 4 pkgs + 72 deps: kept 71 [14.2s]

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

#### **Get Betting information from games**

``` r

cfbd_betting_lines(year = 2018, week = 12, team = "Florida State")
```

    ## ── Betting lines data from CollegeFootballData.com ─────────── cfbfastR 3.0.0 ──

    ## ℹ Data updated: 2026-08-27 11:56:03 UTC

    ## # A tibble: 4 × 23
    ##     game_id season season_type  week start_date           home_team_id home_team
    ##       <int>  <int> <chr>       <int> <chr>                       <int> <chr>    
    ## 1 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
    ## 2 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
    ## 3 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
    ## 4 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
    ## # ℹ 16 more variables: home_conference <chr>, home_classification <chr>,
    ## #   home_score <int>, away_team_id <int>, away_team <chr>,
    ## #   away_conference <chr>, away_classification <chr>, away_score <int>,
    ## #   provider <chr>, spread <dbl>, formatted_spread <chr>, spread_open <lgl>,
    ## #   over_under <dbl>, over_under_open <lgl>, home_moneyline <lgl>,
    ## #   away_moneyline <lgl>

``` r

# 7 OTs LSU at TAMU
cfbd_betting_lines(year = 2018, week = 13, team = "Texas A&M", conference = "SEC")
```

    ## ── Betting lines data from CollegeFootballData.com ─────────── cfbfastR 3.0.0 ──
    ## ℹ Data updated: 2026-08-27 11:56:03 UTC

    ## # A tibble: 4 × 23
    ##     game_id season season_type  week start_date           home_team_id home_team
    ##       <int>  <int> <chr>       <int> <chr>                       <int> <chr>    
    ## 1 401012356   2018 regular        13 2018-11-25T00:30:00…          245 Texas A&M
    ## 2 401012356   2018 regular        13 2018-11-25T00:30:00…          245 Texas A&M
    ## 3 401012356   2018 regular        13 2018-11-25T00:30:00…          245 Texas A&M
    ## 4 401012356   2018 regular        13 2018-11-25T00:30:00…          245 Texas A&M
    ## # ℹ 16 more variables: home_conference <chr>, home_classification <chr>,
    ## #   home_score <int>, away_team_id <int>, away_team <chr>,
    ## #   away_conference <chr>, away_classification <chr>, away_score <int>,
    ## #   provider <chr>, spread <int>, formatted_spread <chr>, spread_open <lgl>,
    ## #   over_under <dbl>, over_under_open <lgl>, home_moneyline <lgl>,
    ## #   away_moneyline <lgl>

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
