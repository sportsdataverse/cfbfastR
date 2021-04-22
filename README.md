
# **cfbfastR** <a href='http://saiemgilani.github.io/cfbfastR'><img src='man/figures/logo.png' align="right" height="150" /></a>

<!-- badges: start -->

![Lifecycle:maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg?style=for-the-badge&logo=github)
![R-CMD-check](https://img.shields.io/github/workflow/status/saiemgilani/cfbfastr/R-CMD-check?label=R-CMD-Check&logo=R&logoColor=blue&style=for-the-badge)
![Contributors](https://img.shields.io/github/contributors/saiemgilani/cfbfastR?style=for-the-badge)
![Version-Number](https://img.shields.io/github/r-package/v/saiemgilani/cfbfastr?label=cfbfastR&logo=R&style=for-the-badge)
[![Twitter
Follow](https://img.shields.io/twitter/follow/cfbfastR?color=blue&label=%40cfbfastR&logo=twitter&style=for-the-badge)](https://twitter.com/cfbfastR)

<!-- badges: end -->

The goal of [**`cfbfastR`**](https://saiemgilani.github.io/cfbfastR/) is
to provide the community with an R package for working with CFB data. It
is an R API wrapper around <https://collegefootballdata.com/>. Beyond
data aggregation and tidying ease, one of the multitude of services that
[**`cfbfastR`**](https://saiemgilani.github.io/cfbfastR/) provides is
for benchmarking open-source expected points and win probability
metrics.

## **Installation**

You can install the released version of
[**`cfbfastR`**](https://github.com/saiemgilani/cfbfastR/) from
[GitHub](https://github.com/saiemgilani/cfbfastR) with:

``` r
# You can install using the pacman package using the following code:
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load_current_gh("saiemgilani/cfbfastR")
```

``` r
# if you would prefer devtools installation
if (!requireNamespace('devtools', quietly = TRUE)){
  install.packages('devtools')
}
# Alternatively, using the devtools package:
devtools::install_github(repo = "saiemgilani/cfbfastR")
```

## **Breaking Changes**

### **v1.2.0**

#### **Add significant documentation to the package**

  - Added mini-vignettes pertaining to CFB Data functionality:
      - [`cfbd_betting`](https://saiemgilani.github.io/cfbfastR/articles/cfbd_betting.html),
      - [`cfbd_games`](https://saiemgilani.github.io/cfbfastR/articles/cfbd_games.html),
      - [`cfbd_plays`](https://saiemgilani.github.io/cfbfastR/articles/cfbd_plays.html),  
      - [`cfbd_recruiting`](https://saiemgilani.github.io/cfbfastR/articles/cfbd_recruiting.html),  
      - [`cfbd_stats`](https://saiemgilani.github.io/cfbfastR/articles/cfbd_stats.html),
      - [`cfbd_teams`](https://saiemgilani.github.io/cfbfastR/articles/cfbd_teams.html)
  - [Introductory vignette
    stub](https://saiemgilani.github.io/cfbfastR/articles/intro.html)
    added

#### **ESPN/CFBD metrics function variable return standardization**

  - Change `id` variable to `team_id` in
    [`espn_ratings_fpi()`](https://saiemgilani.github.io/cfbfastR/reference/espn_ratings.html)
  - Changed `espn_game_id` variable to `game_id` in
    [`espn_metrics_wp()`](https://saiemgilani.github.io/cfbfastR/reference/espn_metrics.html),
    corrected the `away_win_percentage` calculation and added
    `tie_percentage` to the returns.
  - Change `id` variable to `athlete_id` in
    [`cfbd_metrics_ppa_players_season()`](https://saiemgilani.github.io/cfbfastR/reference/cfbd_metrics.html)

### **v1.1.0**

#### **Add loading from Data Repository functionality**

  - Added
    [`load_cfb_pbp()`](https://saiemgilani.github.io/cfbfastR/reference/load_cfb_pbp.html)
    and
    [`update_cfb_db()`](https://saiemgilani.github.io/cfbfastR/reference/update_cfb_db.html)
    functions. Pretty much piggy-backing on the `nflfastR` methodology
    of loading data from the
    [`cfbfastR-data`](https://github.com/saiemgilani/cfbfastR-data/)
    repository.

#### **Add support for parallel processing and progress updates**

  - Added [`furrr`](https://furrr.futureverse.org/index.html),
    [`future`](https://future.futureverse.org/), and
    [`progressr`](https://progressr.futureverse.org/) dependencies to
    the package to allow for parallel processing of the play-by-play
    data with progress updates if desired.

### **v1.0.0**

#### **Function Naming Convention Change**

  - All functions sourced from the College Football Data API will start
    with `cfbd_` as opposed to `cfb_` (as in cfbscrapR). One additional
    `cfbd_` function has been added that corresponds to the result when
    [`cfbd_pbp_data()`](https://saiemgilani.github.io/cfbfastR/reference/cfbd_pbp_data.html)
    has the parameter `epa_wpa=FALSE`. It has now been separated into
    its own function for clarity
    [`cfbd_plays()`](https://saiemgilani.github.io/cfbfastR/reference/cfbd_play.html).
    The parameter and functionality still exists in
    [`cfbd_pbp_data()`](https://saiemgilani.github.io/cfbfastR/reference/cfbd_pbp_data.html)
    but we expect this function will still exist but made obsolete in
    favor of a function more closely matching `nflfastR`’s naming
    conventions.

  - Similarly, data and metrics sourced from ESPN will begin with
    `espn_` as opposed to `cfb_`. In particular, the two functions are
    now
    [`espn_ratings_fpi()`](https://saiemgilani.github.io/cfbfastR/reference/espn_ratings.html)
    and
    [`espn_metrics_wp()`](https://saiemgilani.github.io/cfbfastR/reference/espn_metrics.html)

  - Data generated from any of the
    [`cfbfastR`](https://saiemgilani.github.io/cfbfastR/) methods will
    use `cfb_`

#### **CollegeFootballData API Keys**

The [CollegeFootballData API](https://collegefootballdata.com/) now
requires an API key, here’s a quick run-down:

  - To get an API key, follow the directions here: [College Football
    Data Key Registration.](https://collegefootballdata.com/key)

  - Using the key: You can save the key for consistent usage by adding
    `CFBD_API_KEY=XXXX-YOUR-API-KEY-HERE-XXXXX` to your .REnviron file
    (easily accessed via
    [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)).

Run
[**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)
and THEN paste the following in the new script that pops up (with**out**
quotations)

``` r
CFBD_API_KEY = XXXX-YOUR-API-KEY-HERE-XXXXX
```

  - For less consistent usage: At the beginning of every session or
    within an R environment, save your API key as the environment
    variable `CFBD_API_KEY` (with quotations) using a command like the
    following.

<!-- end list -->

``` r
Sys.setenv(CFBD_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")
```

  - Added [API Key
    methods](https://saiemgilani.github.io/cfbfastR/reference/register_cfbd.html).
    If you forget to set your environment variable, functions will give
    you a warning and ask for one.

## Current Issues

| issue | icon                                                                                                                         | title                                                                                                                                  | labels | opened\_by                            | comments | comments\_users                                                                                                                                                                                                                                                                   | assigned\_to | created             | updated             | closed |
| :---- | :--------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------- | :----- | :------------------------------------ | :------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------- | :------------------ | :------------------ | :----- |
| 5     | <span title="Open Issue"><img src="https://github.com/yonicd/issue/blob/master/inst/icons/issue-opened.png?raw=true"></span> | <span title="**Describe the bug**...">[Play by play for data 2013 and before](https://github.com/saiemgilani/cfbfastR/issues/5)</span> | bug    | [rchanks](https://github.com/rchanks) | 1        | <span title="Thanks for bringing it up, but this is a known issue. I am working on a fix to get all the data going back to the start. Will not be forever but another week or two.">[saiemgilani](https://github.com/saiemgilani/cfbfastR/issues/5#issuecomment-820774185)</span> | saiemgilani  | 2021-04-15 16:24:03 | 2021-04-15 22:48:48 | NA     |

<details>

<summary>View More</summary>

| issue | icon                                                                                                                           | title                                                                                                                                                      | labels        | opened\_by                            | comments | comments\_users                                                                                                                                                                                                                                                                                                                    | assigned\_to | created             | updated             | closed              |
| :---- | :----------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------ | :------------------------------------ | :------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------- | :------------------ | :------------------ | :------------------ |
| 4     | <span title="Closed Issue"><img src="https://github.com/yonicd/issue/blob/master/inst/icons/issue-closed.png?raw=true"></span> | <span title="**Describe the bug**...">[cfbd\_play\_types is documented, but isn’t in the package](https://github.com/saiemgilani/cfbfastR/issues/4)</span> | documentation | [rchanks](https://github.com/rchanks) | 1        | <span title="Oops. Will fix. Maybe. Trying to figure out optimal use of the in-package data sources and I&#39;m not sure this one will make the cut. Would not mind if you had any thoughts/suggestions as essential to new users. ">[saiemgilani](https://github.com/saiemgilani/cfbfastR/issues/4#issuecomment-820774552)</span> | saiemgilani  | 2021-04-15 16:11:17 | 2021-04-18 23:47:31 | 2021-04-18 23:47:31 |

</details>

<br>

## **Our Authors**

  - [Saiem Gilani](https://twitter.com/saiemgilani)  
    <a href="https://twitter.com/saiemgilani" target="blank"><img src="https://img.shields.io/twitter/follow/saiemgilani?color=blue&label=%40saiemgilani&logo=twitter&style=for-the-badge" alt="@saiemgilani" /></a>
    <a href="https://github.com/saiemgilani" target="blank"><img src="https://img.shields.io/github/followers/saiemgilani?color=eee&logo=Github&style=for-the-badge" alt="@saiemgilani" /></a>

  - [Akshay Easwaran](https://twitter.com/akeaswaran)  
    <a href="https://twitter.com/akeaswaran" target="blank"><img src="https://img.shields.io/twitter/follow/akeaswaran?color=blue&label=%40akeaswaran&logo=twitter&style=for-the-badge" alt="@akeaswaran" /></a>
    <a href="https://github.com/akeaswaran" target="blank"><img src="https://img.shields.io/github/followers/akeaswaran?color=eee&logo=Github&style=for-the-badge" alt="@akeaswaran" /></a>

  - [Jared Lee](https://twitter.com/JaredDLee) </br>
    <a href="https://twitter.com/JaredDLee" target="blank"><img src="https://img.shields.io/twitter/follow/JaredDLee?color=blue&label=%40JaredDLee&logo=twitter&style=for-the-badge" alt="@JaredDLee" /></a>
    <a href="https://github.com/Kazink36" target="blank"><img src="https://img.shields.io/github/followers/Kazink36?color=eee&logo=Github&style=for-the-badge" alt="@Kazink36" /></a>

  - [Eric Hess](https://twitter.com/arbitanalytics) </br>
    <a href="https://twitter.com/arbitanalytics" target="blank"><img src="https://img.shields.io/twitter/follow/arbitanalytics?color=blue&label=%40arbitanalytics&logo=twitter&style=for-the-badge" alt="@arbitanalytics" /></a>
    <a href="https://github.com/ehess" target="blank"><img src="https://img.shields.io/github/followers/ehess?color=eee&logo=Github&style=for-the-badge" alt="@ehess" /></a>

## **Our Contributors (they’re awesome)**

  - [Nate Manzo](https://twitter.com/cfbnate)  
    <a href="https://twitter.com/cfbnate" target="blank"><img src="https://img.shields.io/twitter/follow/cfbnate?color=blue&label=%40cfbnate&logo=twitter&style=for-the-badge" alt="@cfbnate" /></a>
    <a href="https://github.com/natemanzo" target="blank"><img src="https://img.shields.io/github/followers/natemanzo?color=eee&logo=Github&style=for-the-badge" alt="@natemanzo" /></a>
  - [Michael Egle](https://twitter.com/deceptivespeed_)  
    <a href="https://twitter.com/deceptivespeed_" target="blank"><img src="https://img.shields.io/twitter/follow/deceptivespeed_?color=blue&label=%40deceptivespeed_&logo=twitter&style=for-the-badge" alt="@deceptivespeed_" /></a>
    <a href="https://github.com/michaelegle" target="blank"><img src="https://img.shields.io/github/followers/michaelegle?color=eee&logo=Github&style=for-the-badge" alt="@michaelegle" /></a>
  - [Jason DeLoach](https://twitter.com/CFBNumbers)  
    <a href="https://twitter.com/CFBNumbers" target="blank"><img src="https://img.shields.io/twitter/follow/CFBNumbers?color=blue&label=%40CFBNumbers&logo=twitter&style=for-the-badge" alt="@CFBNumbers" /></a>
    <a href="https://github.com/CFBNumbers" target="blank"><img src="https://img.shields.io/github/followers/CFBNumbers?color=eee&logo=Github&style=for-the-badge" alt="@CFBNumbers" /></a>
  - [Tej Seth](https://twitter.com/Tejseth41)  
    <a href="https://twitter.com/Tejseth41" target="blank"><img src="https://img.shields.io/twitter/follow/Tejseth41?color=blue&label=%40Tejseth41&logo=twitter&style=for-the-badge" alt="@Tejseth41" /></a>
    <a href="https://github.com/tejseth" target="blank"><img src="https://img.shields.io/github/followers/tejseth?color=eee&logo=Github&style=for-the-badge" alt="@tejseth" /></a>
  - [Conor McQuiston](https://twitter.com/ConorMcQ5)  
    <a href="https://twitter.com/ConorMcQ5" target="blank"><img src="https://img.shields.io/twitter/follow/ConorMcQ5?color=blue&label=%40ConorMcQ5&logo=twitter&style=for-the-badge" alt="@ConorMcQ5" /></a>
    <a href="https://github.com/mcqconor" target="blank"><img src="https://img.shields.io/github/followers/mcqconor?color=eee&logo=Github&style=for-the-badge" alt="@mcqconor" /></a>
  - [Tan Ho](https://twitter.com/_TanHo)  
    <a href="https://twitter.com/_TanHo" target="blank"><img src="https://img.shields.io/twitter/follow/_TanHo?color=blue&label=%40_TanHo&logo=twitter&style=for-the-badge" alt="@_TanHo" /></a>
    <a href="https://github.com/tanho63" target="blank"><img src="https://img.shields.io/github/followers/tanho63?color=eee&logo=Github&style=for-the-badge" alt="@tanho63" /></a>

## **Authors Emeritus - `cfbscrapR`\[archived\]**

  - [Meyappan Subbiah](https://twitter.com/msubbaiah1)  
    <a href="https://twitter.com/msubbaiah1" target="blank"><img src="https://img.shields.io/twitter/follow/msubbaiah1?color=blue&label=%40msubbaiah1&logo=twitter&style=for-the-badge" alt="@msubbaiah1" /></a>
    <a href="https://github.com/meysubb" target="blank"><img src="https://img.shields.io/github/followers/meysubb?color=eee&logo=Github&style=for-the-badge" alt="@meysubb" /></a>
  - [Parker Fleming](https://twitter.com/statsowar)  
    <a href="https://twitter.com/statsowar" target="blank"><img src="https://img.shields.io/twitter/follow/statsowar?color=blue&label=%40statsowar&logo=twitter&style=for-the-badge" alt="@statsowar" /></a>
    <a href="https://github.com/spfleming" target="blank"><img src="https://img.shields.io/github/followers/spfleming?color=eee&logo=Github&style=for-the-badge" alt="@spfleming" /></a>

## **Special Thanks**

  - [Nick Tice](https://github.com/NickTice)
  - [Sebastian Carl](https://twitter.com/mrcaseb)  
    <a href="https://twitter.com/mrcaseb" target="blank"><img src="https://img.shields.io/twitter/follow/mrcaseb?color=blue&label=%40mrcaseb&logo=twitter&style=for-the-badge" alt="@mrcaseb" /></a>
    <a href="https://github.com/mrcaseb" target="blank"><img src="https://img.shields.io/github/followers/mrcaseb?color=eee&logo=Github&style=for-the-badge" alt="@mrcaseb" /></a>
