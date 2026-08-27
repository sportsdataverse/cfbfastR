# 

# **cfbfastR**

The goal of [**`cfbfastR`**](https://cfbfastR.sportsdataverse.org/) is
to provide the community with an R package for working with CFB data. It
is an R API wrapper around <https://collegefootballdata.com/>. Beyond
data aggregation and tidying ease, one of the multitude of services that
[**`cfbfastR`**](https://cfbfastR.sportsdataverse.org/) provides is for
benchmarking open-source expected points and win probability metrics.

## **Installation**

You can install the CRAN version of
[**`cfbfastR`**](https://CRAN.R-project.org/package=cfbfastR) with:

``` r

install.packages("cfbfastR")
```

You can install the released version of
[**`cfbfastR`**](https://github.com/sportsdataverse/cfbfastR/) from
[GitHub](https://github.com/sportsdataverse/cfbfastR) with:

``` r

# You can install using the pak package using the following code:
if (!requireNamespace('remotes', quietly = TRUE)){
  install.packages('remotes', repos = "https://cloud.r-project.org")
}
remotes::install_github("sportsdataverse/cfbfastR")
```

## **Full Season Data Loaders**

`cfbfastR` ships four loader families that pull pre-built season
datasets from the [sportsdataverse-data
releases](https://github.com/sportsdataverse/sportsdataverse-data/releases)
— no API key, no scraping, one function call per dataset:

| Family | Functions | Source / contents | Coverage |
|----|----|----|----|
| Classic | [`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md), [`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.md), [`load_cfb_rosters()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_rosters.md), [`load_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_teams.md) | The original cfbfastR EPA/WPA play-by-play + companions | pbp 2014+ |
| ESPN | `load_espn_cfb_*()` (27) | ESPN-derived datasets: pbp, schedules, team/player box, drives, game rosters, linescores, betting, play participants, FPI power index, percentiles, passing/rushing/receiving EPA splits, team summaries, model pbp, and eleven `adv_*` advanced-stat datasets | mostly 2004+ |
| Ratings & recruiting | [`load_cfb_ratings()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_ratings.md), [`load_cfb_ratings_weekly()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_ratings_weekly.md), [`load_cfb_fpi_weekly()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_fpi_weekly.md), [`load_cfb_team_summaries_weekly()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_team_summaries_weekly.md), [`load_cfb_team_talent()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_team_talent.md), [`load_cfb_recruits()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_recruits.md), [`load_cfb_recruiting_proj()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_recruiting_proj.md), [`load_cfb_returning_production()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_returning_production.md), plus the `load_cfb_*_crosswalk()` id crosswalks | Season/weekly power ratings, talent composite, recruiting, CFBD↔︎ESPN id crosswalks | varies (2002+) |
| NCAA (stats.ncaa.org) | `load_ncaa_mfb_*()` (10) | pbp (native + cfbfastR-shaped), drives, linescore, officials, player/team stats, rosters, schedule, teams — includes FCS and lower divisions ESPN misses | 2013+ |

**Which play-by-play do I want?**

- [`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md)
  — the classic cfbfastR pbp with the full EPA/WPA model columns; FBS,
  2014+. Existing code keeps working unchanged.
- [`load_espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_espn_cfb_pbp.md)
  — the ESPN-derived pbp (469 columns incl. EPA/WPA and participant ids)
  with deeper history, 2004+.
- [`load_ncaa_mfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_ncaa_mfb_pbp.md)
  — stats.ncaa.org pbp incl. FCS and lower divisions, 2013+;
  [`load_ncaa_mfb_pbp_cfbfastr()`](https://cfbfastR.sportsdataverse.org/reference/load_ncaa_mfb_pbp_cfbfastr.md)
  is the same data reshaped onto cfbfastR pbp column conventions for
  cross-source binds.

All loaders accept a vector of seasons (or `seasons = TRUE` for
everything published) and an optional `dbConnection` + `tablename` to
write straight into a database instead of returning a tibble.

## **Breaking Changes**

[**Full News on
Releases**](https://cfbfastR.sportsdataverse.org/news/index.html)

#### **College Football Data API Keys**

The [CollegeFootballData API](https://collegefootballdata.com/) now
requires an API key, here’s a quick run-down:

- To get an API key, follow the directions here: [College Football Data
  Key Registration.](https://collegefootballdata.com/key)

- Using the key: You can save the key for consistent usage by adding
  `CFBD_API_KEY=YOUR-API-KEY-HERE` to your .Renviron file (easily
  accessed via
  [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)).
  Run
  [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html),
  a new script will pop open named `.Renviron`, **THEN** paste the
  following in the new script that pops up (with**out** quotations)

``` r

CFBD_API_KEY = YOUR-API-KEY-HERE
```

Save the script and restart your RStudio session, by clicking `Session`
(in between `Plots` and `Build`) and click `Restart R` (there also
exists the shortcut `Ctrl + Shift + F10` to restart your session). If
set correctly, from then on you should be able to use any of the `cfbd_`
functions without any other changes.

- For less consistent usage: At the beginning of every session or within
  an R environment, save your API key as the environment variable
  `CFBD_API_KEY` (with quotations) using a command like the following.

``` r

Sys.setenv(CFBD_API_KEY = "YOUR-API-KEY-HERE")
```

## **Proxy support**

If you run `cfbfastR` from behind a corporate proxy, set it once per
session and every `cfbd_*()` / `espn_cfb_*()` call routes through it:

``` r

options(cfbfastR.proxy = "http://proxy.host.example:8080")
# or, for an authenticated proxy:
options(cfbfastR.proxy = list(
  url = "http://proxy.host.example", port = 8080,
  username = "me", password = "pw", auth = "basic"
))
```

The resolution order is: explicit `proxy =` argument -\>
`getOption("cfbfastR.proxy")` -\> `http_proxy` / `https_proxy` env vars.
See the [intro
vignette](https://cfbfastR.sportsdataverse.org/articles/intro.html) and
`CLAUDE.md` for full detail.

## Follow [cfbfastR](https://x.com/cfbfastR) and the [SportsDataverse](https://x.com/SportsDataverse) on Twitter and star this repo

[![X (formerly Twitter)
Follow](https://img.shields.io/twitter/follow/cfbfastR?style=for-the-badge&logo=x&label=%40cfbfastR&color=eee&link=https%3A%2F%2Fx.com%2FcfbfastR)](https://x.com/cfbfastR)
[![Twitter
Follow](https://img.shields.io/twitter/follow/SportsDataverse?color=blue&label=%40SportsDataverse&logo=x&style=for-the-badge)](https://x.com/SportsDataverse)

[![GitHub
stars](https://img.shields.io/github/stars/sportsdataverse/cfbfastR.svg?color=eee&logo=github&style=for-the-badge&label=Star%20cfbfastR&maxAge=2592000)](https://github.com/sportsdataverse/cfbfastR)

## **Our Authors**

- [Saiem Gilani](https://x.com/saiemgilani)
  [![@saiemgilani](https://img.shields.io/twitter/follow/saiemgilani?color=blue&label=%40saiemgilani&logo=x&style=for-the-badge)](https://x.com/saiemgilani)
  [![@saiemgilani](https://img.shields.io/github/followers/saiemgilani?color=eee&logo=Github&style=for-the-badge)](https://github.com/saiemgilani)

- [Akshay Easwaran](https://x.com/akeaswaran)
  [![@akeaswaran](https://img.shields.io/twitter/follow/akeaswaran?color=blue&label=%40akeaswaran&logo=x&style=for-the-badge)](https://x.com/akeaswaran)
  [![@akeaswaran](https://img.shields.io/github/followers/akeaswaran?color=eee&logo=Github&style=for-the-badge)](https://github.com/akeaswaran)

- Jared Lee
  [![@Kazink36](https://img.shields.io/github/followers/Kazink36?color=eee&logo=Github&style=for-the-badge)](https://github.com/Kazink36)

- [Eric Hess](https://x.com/arbitanalytics)
  [![@arbitanalytics](https://img.shields.io/twitter/follow/arbitanalytics?color=blue&label=%40arbitanalytics&logo=x&style=for-the-badge)](https://x.com/arbitanalytics)
  [![@ehess](https://img.shields.io/github/followers/ehess?color=eee&logo=Github&style=for-the-badge)](https://github.com/ehess)

# **Our Contributors (they’re awesome)**

- [Nate Manzo](https://x.com/cfbnate)
  [![@cfbnate](https://img.shields.io/twitter/follow/cfbnate?color=blue&label=%40cfbnate&logo=x&style=for-the-badge)](https://x.com/cfbnate)
  [![@natemanzo](https://img.shields.io/github/followers/natemanzo?color=eee&logo=Github&style=for-the-badge)](https://github.com/natemanzo)

- [Michael Egle](https://x.com/deceptivespeed_)
  [![@deceptivespeed\_](https://img.shields.io/twitter/follow/deceptivespeed_?color=blue&label=%40deceptivespeed_&logo=x&style=for-the-badge)](https://x.com/deceptivespeed_)
  [![@michaelegle](https://img.shields.io/github/followers/michaelegle?color=eee&logo=Github&style=for-the-badge)](https://github.com/michaelegle)

- [Jason DeLoach](https://x.com/CFBNumbers)
  [![@CFBNumbers](https://img.shields.io/twitter/follow/CFBNumbers?color=blue&label=%40CFBNumbers&logo=x&style=for-the-badge)](https://x.com/CFBNumbers)
  [![@CFBNumbers](https://img.shields.io/github/followers/CFBNumbers?color=eee&logo=Github&style=for-the-badge)](https://github.com/CFBNumbers)

- [Tej Seth](https://x.com/tejfbanalytics)
  [![@Tejseth41](https://img.shields.io/twitter/follow/Tejseth41?color=blue&label=%40Tejseth41&logo=x&style=for-the-badge)](https://x.com/tejfbanalytics)
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
  [![@bradisblogging](https://img.shields.io/twitter/follow/bradisblogging?color=blue&label=%40bradisblogging&logo=X&style=for-the-badge)](https://x.com/bradisblogging)
  [![@bradisbrad](https://img.shields.io/github/followers/bradisbrad?color=eee&logo=Github&style=for-the-badge)](https://github.com/bradisbrad)

# **Authors Emeritus - `cfbscrapR`\[archived\]**

- [Meyappan Subbiah](https://x.com/msubbaiah1)
  [![@msubbaiah1](https://img.shields.io/twitter/follow/msubbaiah1?color=blue&label=%40msubbaiah1&logo=x&style=for-the-badge)](https://x.com/msubbaiah1)
  [![@meysubb](https://img.shields.io/github/followers/meysubb?color=eee&logo=Github&style=for-the-badge)](https://github.com/meysubb)

- [Parker Fleming](https://x.com/statsowar)
  [![@statsowar](https://img.shields.io/twitter/follow/statsowar?color=blue&label=%40statsowar&logo=x&style=for-the-badge)](https://x.com/statsowar)
  [![@spfleming](https://img.shields.io/github/followers/spfleming?color=eee&logo=Github&style=for-the-badge)](https://github.com/spfleming)

# **Special Thanks**

- [Nick Tice](https://github.com/NickTice)

## **Citations**

To cite the [**`cfbfastR`**](https://cfbfastR.sportsdataverse.org/) R
package in publications, use:

BibTex Citation

``` bibtex

@article{gilani_et_al_2021_cfbfastr,
  author = {Saiem Gilani and Akshay Easwaran and Jared Lee and Eric Hess},
  title = {cfbfastR: Access College Football Play by Play Data},
  url = {https://cfbfastR.sportsdataverse.org/},
  doi = {10.32614/CRAN.package.cfbfastR},
  journal = {CRAN: Contributed Packages},
  publisher = {The R Foundation},
  year = {2021}
}
```
