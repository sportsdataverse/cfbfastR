# CFB Data Stats Examples

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

    ## ✔ 4 pkgs + 72 deps: kept 71 [10.6s]

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

### Settling **2019 LSU** and **2013 Florida State** offense debates

#### **Get Season Statistics by Team**

``` r

team_season_stats <- dplyr::bind_rows(
   cfbd_stats_season_team(year=2019, team = "LSU"),
   cfbd_stats_season_team(year=2013, team = "Florida State")
)
logos <- read.csv("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/themes/logos.csv")
logos<- logos |> dplyr::select(-"conference")
df_team_season <- team_season_stats |>
   dplyr::left_join(logos, by=c("team"="school"))
```

``` r

df_team_season_long <- as.data.frame(t(as.matrix(df_team_season)))
colnames(df_team_season_long) <- df_team_season$team
```

#### **Get Season Advanced Statistics by Team**

``` r

df_team_season_adv <- dplyr::bind_rows(
   cfbd_stats_season_advanced(2019, team = "LSU"),
   cfbd_stats_season_advanced(2013, team = "Florida State")
)
df_team_season_adv <- df_team_season_adv |>
   dplyr::left_join(logos, by=c("team"="school"))
```

#### **Get Game Advanced Stats**

``` r

df_team_game_adv <- dplyr::bind_rows(
   cfbd_stats_game_advanced(2019, team = "LSU"),
   cfbd_stats_game_advanced(2013, team = "Florida State")
)
df_team_game_adv <- df_team_game_adv |>
   dplyr::left_join(logos, by=c("team"="school"))
```

#### **Get Season Statistics by Player**

``` r

source("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/themes/gt_theme_code_SG.R")
passing_df <- dplyr::bind_rows(
   cfbd_stats_season_player(2019, team = "LSU", category = "passing"),
   cfbd_stats_season_player(2013, team = "Florida State", category = "passing")) |>
   dplyr::left_join(logos, by=c("team"="school")) |>
   dplyr::group_by(team) |>
   dplyr::mutate(logo = sprintf('<img src="%s" height="30" alt="%s logo">', logo, team)) |>
   dplyr::select(logo,
                 player,
                 passing_completions,
                 passing_att,
                 passing_yds,
                 passing_td,
                 passing_int,
                 passing_ypa) |>
   arrange( desc(passing_yds), team)
```

    ## Adding missing grouping variables: `team`

``` r

passing_df |> gt() |>
  tab_header(title = "Passing Summary") |>
  cols_label(logo="",
             player = "Player",
             passing_completions = "C",
             passing_att = "Att",
             passing_yds = "Yds",
             passing_td = "TDs",
             passing_int = "INTs",
             passing_ypa = "YPA") |>
  data_color(
    columns = c("passing_yds"),
    colors = scales::col_numeric(
      palette = "RdBu",
      domain = c(-6000,6000)
    )
  ) |>
  data_color(
    columns = c("passing_td"),
    colors = scales::col_numeric(
      palette = "RdBu",
      domain = c(-60,60)
    )
  ) |>
  data_color(
    columns = c("passing_td"),
    colors = scales::col_numeric(
      palette = "RdBu",
      domain = c(-60,60)
    )
  ) |>
  # Render the team logos from pre-built <img> HTML that carries alt text
  # (gt::web_image() cannot set alt; important for screen-reader accessibility).
  fmt_markdown(columns = "logo") |>
  tab_source_note(source_note = md("**Table:** @SaiemGilani | **Data:** @CFB_Data with @cfbfastR v2.0.0")) |>
  gt_theme_538(table.width = px(550))
```

    ## Warning: Since gt v0.9.0, the `colors` argument has been deprecated.
    ## • Please use the `fn` argument instead.
    ## This warning is displayed once every 8 hours.

| Passing Summary |  |  |  |  |  |  |  |
|----|----|----|----|----|----|----|----|
|  | Player | C | Att | Yds | TDs | INTs | YPA |
| LSU |  |  |  |  |  |  |  |
| ![LSU logo](http://a.espncdn.com/i/teamlogos/ncaa/500/99.png) | Joe Burrow | 402 | 527 | 5671 | 60 | 6 | 10.8 |
| ![LSU logo](http://a.espncdn.com/i/teamlogos/ncaa/500/99.png) | Myles Brennan | 24 | 40 | 353 | 1 | 1 | 8.8 |
| Florida State |  |  |  |  |  |  |  |
| ![Florida State logo](http://a.espncdn.com/i/teamlogos/ncaa/500/52.png) | Jameis Winston | 257 | 384 | 4057 | 40 | 10 | 10.6 |
| ![Florida State logo](http://a.espncdn.com/i/teamlogos/ncaa/500/52.png) | Jake Coker | 18 | 36 | 250 | 0 | 1 | 6.9 |
| ![Florida State logo](http://a.espncdn.com/i/teamlogos/ncaa/500/52.png) | Sean Maguire | 13 | 21 | 116 | 2 | 2 | 5.5 |
| **Table:** @SaiemGilani \| **Data:** @CFB_Data with @cfbfastR v2.0.0 |  |  |  |  |  |  |  |

#### **College Football Mapping for Stats Categories**

``` r

cfbd_stats_categories()
```

    ## ── Stat categories for CollegeFootballData.com ─────────────── cfbfastR 3.0.0 ──

    ## ℹ Data updated: 2026-08-27 11:57:07 UTC

    ## # A tibble: 38 × 1
    ##    category          
    ##    <chr>             
    ##  1 completionAttempts
    ##  2 defensiveTDs      
    ##  3 extraPoints       
    ##  4 fieldGoalPct      
    ##  5 fieldGoals        
    ##  6 firstDowns        
    ##  7 fourthDownEff     
    ##  8 fumblesLost       
    ##  9 fumblesRecovered  
    ## 10 interceptions     
    ## # ℹ 28 more rows

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
