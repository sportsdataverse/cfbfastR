
<!-- README.md is generated from README.Rmd. Please edit that file -->

# **cfbfastR** <a href='http://saiemgilani.github.io/cfbfastR'><img src='man/figures/logo.png' align="right" height="120" /></a>

<!-- badges: start -->

![Lifecycle:maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg?style=for-the-badge&logo=github)
![R-CMD-check](https://img.shields.io/github/workflow/status/saiemgilani/cfbfastr/R-CMD-check?label=R-CMD-Check&logo=R&logoColor=blue&style=for-the-badge)
![Contributors](https://img.shields.io/github/contributors/saiemgilani/cfbfastR?style=for-the-badge)
![Version-Number](https://img.shields.io/github/r-package/v/saiemgilani/cfbfastr?label=cfbfastR&logo=R&style=for-the-badge)
[![Twitter
Follow](https://img.shields.io/twitter/follow/cfbfastR?color=blue&label=%40cfbfastR&logo=twitter&style=for-the-badge)](https://twitter.com/cfbfastR)

<!-- badges: end -->

The goal of [`cfbfastR`](https://saiemgilani.github.io/cfbfastR/) is to
provide the community with an R package for working with CFB data. It is
an R API wrapper around <https://collegefootballdata.com/>.

## **Installation**

You can install the released version of `cfbfastR` from
[GitHub](https://github.com/saiemgilani/cfbfastR) with:

``` r
# Then can install using the devtools package from the following:

devtools::install_github(repo = "saiemgilani/cfbfastR")
```

## **Breaking Changes**

### **v1.0.0**

#### Function Naming Convention Change

All functions sourced from the College Football Data API will start with
`cfbd_` as opposed to `cfb_` (as in cfbscrapR).

Similarly, data and metrics sourced from ESPN will begin with `espn_` as
opposed to `cfb_`. In particular, the two functions are now
[`espn_ratings_fpi()`](https://saiemgilani.github.io/cfbfastR/reference/espn_ratings.html)
and
[`espn_metrics_wp()`](https://saiemgilani.github.io/cfbfastR/reference/espn_metrics.html)

Data generated from any of the
[`cfbfastR`](https://saiemgilani.github.io/cfbfastR/) methods will use
`cfb_`

The [CollegeFootballData API](https://collegefootballdata.com/) now
requires an API key, here’s a quick run-down:

  - To get an API key, follow the directions here: [College Football
    Data Key Registration.](https://collegefootballdata.com/key)

  - Using the key: At the beginning of every session or within an R
    environment, save your API key as the environment variable
    `CFBD_API_KEY` using a command like the following.

<!-- end list -->

``` r
Sys.setenv(CFBD_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")
```

  - Added [API Key
    methods](https://saiemgilani.github.io/cfbfastR/reference/register_cfbd.html).
    If you forget to set your environment variable, functions will give
    you a warning and ask for one.

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

## **Special Thanks**

  - [Nick Tice](https://github.com/NickTice)
