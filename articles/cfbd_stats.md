# CFB Data Stats Examples

#### **Load and Install Packages**

``` r

if (!requireNamespace('pak', quietly = TRUE)){
  install.packages('pak')
}
pak::pak(c("dplyr", "tidyr", "gt"))
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
    ## Hit:6 https://packages.microsoft.com/ubuntu/22.04/prod jammy InRelease

    ## Hit:3 http://azure.archive.ubuntu.com/ubuntu jammy-updates InRelease
    ## Hit:4 http://azure.archive.ubuntu.com/ubuntu jammy-backports InRelease

    ## Hit:5 http://azure.archive.ubuntu.com/ubuntu jammy-security InRelease

    ## Reading package lists...

    ## ℹ Executing `sudo sh -c apt-get -y install libicu-dev libcurl4-openssl-dev libssl-dev cmake make libuv1-dev pandoc libnode-dev libxml2-dev`

    ## Reading package lists...

    ## Building dependency tree...

    ## Reading state information...

    ## libicu-dev is already the newest version (70.1-2).
    ## make is already the newest version (4.3-4.1build1).
    ## pandoc is already the newest version (2.9.2.1-3ubuntu2).
    ## cmake is already the newest version (3.22.1-1ubuntu1.22.04.2).
    ## libcurl4-openssl-dev is already the newest version (7.81.0-1ubuntu1.30).
    ## libssl-dev is already the newest version (3.0.2-0ubuntu1.30).
    ## libuv1-dev is already the newest version (1.43.0-1ubuntu0.1).
    ## libxml2-dev is already the newest version (2.9.13+dfsg-1ubuntu0.14).
    ## libnode-dev is already the newest version (12.22.9~dfsg-1ubuntu3.6).
    ## 0 upgraded, 0 newly installed, 0 to remove and 19 not upgraded.

    ## ✔ 3 pkgs + 56 deps: kept 59 [10.2s]

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
library(sdvplotR)
# cfbfastR is deliberately NOT in the pak() list above. pkgdown and
# R CMD check render this vignette against the package being built, and
# installing from CRAN here would overwrite that dev build with the last
# release -- so any function added since it would vanish mid-render.
library(cfbfastR)
# pak::pak("sportsdataverse/cfbfastR")
```

The team logos and the table theme come from
[sdvplotR](https://sdvplotR.sportsdataverse.org/), which is not on CRAN;
install it from the SportsDataverse r-universe:

``` r

install.packages("sdvplotR", repos = c("https://sportsdataverse.r-universe.dev", getOption("repos")))
```

### Settling **2019 LSU** and **2013 Florida State** offense debates

#### **Get Season Statistics by Team**

``` r

team_season_stats <- dplyr::bind_rows(
   cfbd_stats_season_team(year=2019, team = "LSU"),
   cfbd_stats_season_team(year=2013, team = "Florida State")
)
df_team_season <- team_season_stats
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
```

#### **Get Game Advanced Stats**

``` r

df_team_game_adv <- dplyr::bind_rows(
   cfbd_stats_game_advanced(2019, team = "LSU"),
   cfbd_stats_game_advanced(2013, team = "Florida State")
)
```

#### **Get Season Statistics by Player**

``` r

passing_df <- dplyr::bind_rows(
   cfbd_stats_season_player(2019, team = "LSU", category = "passing"),
   cfbd_stats_season_player(2013, team = "Florida State", category = "passing")) |>
   dplyr::group_by(team) |>
   dplyr::mutate(logo = team) |>
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
  # sdvplotR turns the school names into logos, and gives each image the
  # team's full name as alt text for screen readers.
  gt_sdv_logos(columns = "logo", league = "cfb") |>
  tab_source_note(source_note = md("**Table:** @SaiemGilani | **Data:** @CFB_Data with @cfbfastR v2.0.0")) |>
  gt_theme_sdv() |>
  tab_options(table.width = px(550))
```

    ## Warning: Since gt v0.9.0, the `colors` argument has been deprecated.
    ## • Please use the `fn` argument instead.
    ## This warning is displayed once every 8 hours.

| Passing Summary |  |  |  |  |  |  |  |
|----|----|----|----|----|----|----|----|
|  | Player | C | Att | Yds | TDs | INTs | YPA |
| LSU |  |  |  |  |  |  |  |
| ![LSU Tigers](https://sdv.nyc3.cdn.digitaloceanspaces.com/assets/public/sha256/d0/d02e29a9f8824740d848b4a83c574b1c1942ba1cdee61b3ee08611634cc86b46.png) | Joe Burrow | 402 | 527 | 5671 | 60 | 6 | 10.8 |
| ![LSU Tigers](https://sdv.nyc3.cdn.digitaloceanspaces.com/assets/public/sha256/d0/d02e29a9f8824740d848b4a83c574b1c1942ba1cdee61b3ee08611634cc86b46.png) | Myles Brennan | 24 | 40 | 353 | 1 | 1 | 8.8 |
| Florida State |  |  |  |  |  |  |  |
| ![Florida State Seminoles](https://sdv.nyc3.cdn.digitaloceanspaces.com/assets/public/sha256/2b/2b8ccabe8c063ef5f2fbd4c21b489179d94782ca4ea6c14dd3e5d1728afa61a3.png) | Jameis Winston | 257 | 384 | 4057 | 40 | 10 | 10.6 |
| ![Florida State Seminoles](https://sdv.nyc3.cdn.digitaloceanspaces.com/assets/public/sha256/2b/2b8ccabe8c063ef5f2fbd4c21b489179d94782ca4ea6c14dd3e5d1728afa61a3.png) | Jake Coker | 18 | 36 | 250 | 0 | 1 | 6.9 |
| ![Florida State Seminoles](https://sdv.nyc3.cdn.digitaloceanspaces.com/assets/public/sha256/2b/2b8ccabe8c063ef5f2fbd4c21b489179d94782ca4ea6c14dd3e5d1728afa61a3.png) | Sean Maguire | 13 | 21 | 116 | 2 | 2 | 5.5 |
| **Table:** @SaiemGilani \| **Data:** @CFB_Data with @cfbfastR v2.0.0 |  |  |  |  |  |  |  |

#### **Passing and rushing splits (2025 onward)**

The `cfbd_passing_*()` and `cfbd_rushing_*()` families carry charting
detail the season-stats endpoints above do not: passing production split
across seven pass locations, rushing across four run directions, and
play-level frames with air yards, yards after catch and carrier
attribution.

These frames are **wide by construction** — a 28-column passing
production block, a 23-column form of it for every location, and the
team endpoints repeat the whole thing for offense and defense, so
[`cfbd_passing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_season.md)
is 381 columns. Select what you need rather than printing them whole.

``` r

tex_pass <- cfbd_passing_players_season(year = 2025, team = "Texas")

tex_pass |>
  dplyr::filter(attempts > 20) |>
  dplyr::select(player, attempts, completion_rate, average_depth_of_target, ppa) |>
  dplyr::arrange(dplyr::desc(attempts))
```

    ## ── Player season passing data from CollegeFootballData.com ─── cfbfastR 3.1.0 ──

    ## ℹ Data updated: 2026-11-02 06:24:47 UTC

    ## # A tibble: 1 × 5
    ##   player       attempts completion_rate average_depth_of_target   ppa
    ##   <chr>           <int>           <dbl>                   <dbl> <dbl>
    ## 1 Arch Manning      399           0.607                     8.5 0.274

Where the splits earn their keep is comparing a passer by area of the
field. The bucket columns are named `locations_<bucket>_<stat>`:

``` r

buckets <- c("short_left", "short_middle", "short_right",
             "deep_left", "deep_middle", "deep_right", "unknown")

tex_pass |>
  dplyr::filter(attempts == max(attempts)) |>
  # name the seven buckets explicitly: a wildcard on `_attempts` would also
  # sweep up `locations_<bucket>_successful_attempts`, which is a different
  # statistic, and silently double the rows.
  dplyr::select(player, paste0("locations_", buckets, "_attempts")) |>
  tidyr::pivot_longer(
    -player,
    names_to = "location", values_to = "attempts",
    names_pattern = "locations_(.*)_attempts"
  ) |>
  dplyr::arrange(dplyr::desc(attempts))
```

    ## # A tibble: 7 × 3
    ##   player       location     attempts
    ##   <chr>        <chr>           <int>
    ## 1 Arch Manning unknown           189
    ## 2 Arch Manning short_right        74
    ## 3 Arch Manning short_left         71
    ## 4 Arch Manning short_middle       41
    ## 5 Arch Manning deep_left          11
    ## 6 Arch Manning deep_right          7
    ## 7 Arch Manning deep_middle         5

Note how large the `unknown` bucket is. Location is parsed from play
text, so a sizeable share of attempts never get one — which is exactly
why the next point matters.

A caveat that matters for every mean you compute from these: the
`*_available` columns are **denominators, not statistics**. CFBD parses
air yards, YAC and location out of play text, so an attempt can be
counted while those stay unknown. Divide by the matching `*_available`
column, not by `attempts`:

``` r

tex_pass |>
  dplyr::filter(attempts > 20) |>
  dplyr::transmute(
    player,
    attempts,
    air_yards_parsed = air_yards_attempts_available,
    # right: the denominator CFBD actually measured
    adot_correct = total_air_yards / air_yards_attempts_available,
    # wrong: silently understated wherever parsing was incomplete
    adot_naive = total_air_yards / attempts
  )
```

    ## ── Player season passing data from CollegeFootballData.com ─── cfbfastR 3.1.0 ──

    ## ℹ Data updated: 2026-11-02 06:24:47 UTC

    ## # A tibble: 1 × 5
    ##   player       attempts air_yards_parsed adot_correct adot_naive
    ##   <chr>           <int>            <int>        <dbl>      <dbl>
    ## 1 Arch Manning      399              211         8.54       4.52

Play-level frames expose the same idea as parse flags. Filter on
`location_analysis_eligible` (passing) or `direction_analysis_eligible`
(rushing) before trusting a split column:

``` r

cfbd_passing_plays(year = 2025, week = 5, outcome = "completion") |>
  dplyr::filter(location_analysis_eligible, !is.na(target)) |>
  dplyr::select(offense, defense, passer, target, total_yards, ppa, success) |>
  head(10)
```

    ## ── Passing plays data from CollegeFootballData.com ─────────── cfbfastR 3.1.0 ──

    ## ℹ Data updated: 2026-11-02 06:24:49 UTC

    ## # A tibble: 10 × 7
    ##    offense    defense    passer       target         total_yards   ppa success
    ##    <chr>      <chr>      <chr>        <chr>                <int> <dbl> <lgl>  
    ##  1 Notre Dame Arkansas   C.J. Carr    Eli Raridon             18 1.66  TRUE   
    ##  2 Arkansas   Notre Dame Taylen Green O'Mega Blake             8 0.910 TRUE   
    ##  3 Notre Dame Arkansas   C.J. Carr    Will Pauling            22 1.89  TRUE   
    ##  4 Arkansas   Notre Dame Taylen Green O'Mega Blake            33 2.09  TRUE   
    ##  5 Notre Dame Arkansas   C.J. Carr    Malachi Fields          21 2.30  TRUE   
    ##  6 Arkansas   Notre Dame Taylen Green Andreas Paaske           8 0.752 TRUE   
    ##  7 Notre Dame Arkansas   C.J. Carr    Jeremiyah Love          25 2.44  TRUE   
    ##  8 Notre Dame Arkansas   C.J. Carr    Jeremiyah Love           7 2.61  TRUE   
    ##  9 Arkansas   Notre Dame Taylen Green Jalen Brown             11 1.46  TRUE   
    ## 10 Notre Dame Arkansas   C.J. Carr    Jordan Faison           10 0.504 TRUE

Check a column before you build on it. As of this writing CFBD populates
`target` on the play frame (1,976 of 2,003 week-5 completions) but has
**not** populated play-level `air_yards` or `yards_after_catch` at all —
R types those `logical` because every value is `NA`. The *season*
aggregates do carry air yards, which is why `total_air_yards` above is
non-zero while the play column is empty. The same applies to
`rush_direction` on
[`cfbd_rushing_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_plays.md).

Earlier seasons are not an error — these endpoints begin in 2025, and
CFBD answers a 2024 request with an empty array, so the functions return
a zero-row data frame rather than failing.

#### **Punting (2015 onward)**

The `cfbd_punting_*()` family covers both sides of a punt. Team frames
carry one 24-column block twice: `punting_*` for the team’s own punts
and `returning_*` for the punts it received. Player frames carry a
punter block and a returner block, so a returner shows up with `NA`
punting columns. Coverage starts in **2015**.

Gross average flatters a punter whose kicks get returned. Net yards per
punt charges the return back:

``` r

cfbd_punting_teams_season(year = 2025, conference = "SEC") |>
  dplyr::select(team, punting_punts, punting_yards_per_punt,
                punting_net_yards_per_punt, punting_inside20, punting_touchbacks) |>
  dplyr::arrange(dplyr::desc(punting_net_yards_per_punt))
```

    ## ── Team season punting data from CollegeFootballData.com ───── cfbfastR 3.1.0 ──

    ## ℹ Data updated: 2026-11-02 06:24:50 UTC

    ## # A tibble: 16 × 6
    ##    team              punting_punts punting_yards_per_punt punting_net_yards_pe…¹
    ##    <chr>                     <int>                  <dbl>                  <dbl>
    ##  1 Ole Miss                     41                   46                     43.4
    ##  2 Georgia                      51                   45.7                   43.2
    ##  3 Tennessee                    39                   44                     42.3
    ##  4 Vanderbilt                   27                   47.1                   42.2
    ##  5 Mississippi State            58                   45.6                   41.9
    ##  6 Arkansas                     35                   44.8                   41.1
    ##  7 Auburn                       50                   42                     40.5
    ##  8 Florida                      48                   43.4                   40.4
    ##  9 South Carolina               52                   44.2                   40.2
    ## 10 LSU                          63                   45.8                   38.6
    ## 11 Oklahoma                     63                   45.1                   38.3
    ## 12 Missouri                     45                   41.6                   38.2
    ## 13 Alabama                      53                   41.5                   38  
    ## 14 Kentucky                     49                   43.4                   37.6
    ## 15 Texas                        59                   44.6                   37.6
    ## 16 Texas A&M                    51                   43.5                   35.2
    ## # ℹ abbreviated name: ¹​punting_net_yards_per_punt
    ## # ℹ 2 more variables: punting_inside20 <int>, punting_touchbacks <int>

As with passing, the `*_available` columns are denominators, so divide
by `punting_net_punt_yards_available` rather than `punting_punts` if you
rebuild an average yourself.

#### **College Football Mapping for Stats Categories**

``` r

cfbd_stats_categories()
```

    ## ── Stat categories for CollegeFootballData.com ─────────────── cfbfastR 3.1.0 ──

    ## ℹ Data updated: 2026-11-02 06:24:50 UTC

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
- [Jared Lee](https://github.com/Kazink36)
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
- [**cfbseedR**](https://cfbseedR.sportsdataverse.org/) - college
  football season and playoff simulation (CRAN)
- [**cfb4th**](https://cfb4th.sportsdataverse.org/) - college football
  fourth-down decisions (r-universe)
- [**sdvplotR**](https://sdvplotR.sportsdataverse.org/) - team logos,
  colours and tables for every SportsDataverse league (r-universe)
- [**sportyR**](https://sportyR.sportsdataverse.org/) - playing
  surfaces, including the college football field (CRAN)
- [**cfbplotR**](https://cfbplotR.sportsdataverse.org/) - college
  football logos and colours (r-universe)
- [**sportsdataverse-py**](https://py.sportsdataverse.org/) - the Python
  package
- [**sportsdataverse-R**](https://r.sportsdataverse.org/) - the R
  meta-package
