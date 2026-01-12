# Introduction to cfbfastR

Hey folks,

Welcome to the football analytics community! I’m Saiem Gilani, one of
the
[authors](https://cfbfastr.sportsdataverse.org/authors.html "Authors and contributors to cfbfastR")
of
[`cfbfastR`](https://twitter.com/cfbfastR "Follow @cfbfastR on Twitter! Tag us in your tweets using cfbfastR and we'll share it!"),
and I hope to give the community a high-quality resource for accessing
college football data for statistical analysis, football research, and
more. I am excited to show you some of what you can do with this edition
of the package.

#### **Installing R and RStudio**

1.  Head to <https://cran.r-project.org>
2.  Select the appropriate link for your operating system (Windows, Mac
    OS X, or Linux)

- **Windows** - Select base and download the most recent version
- **Mac OS X** - Select Latest Release, but check to make sure your OS
  is the correct version. Look through Binaries for Legacy OS X Systems
  if you are on an older release
- **Linux** - Select the appropriate distro and follow the installation
  instructions

3.  Head to
    [RStudio.com](https://www.rstudio.com/products/rstudio/download/#download "Download the appropriate version of RStudio (Free) for your operating system to use with R")
4.  Follow the associated download and installation instructions for
    RStudio.
5.  Start peering over the [RStudio IDE
    Cheatsheet](https://raw.githubusercontent.com/rstudio/cheatsheets/main/rstudio-ide.pdf).
    *An IDE is an integrated development environment.*
6.  For **Windows** users: I recommend you install
    [Rtools](https://cran.r-project.org/bin/windows/Rtools/). This is
    not an R package! It is “a collection of resources for building
    packages for R under Microsoft Windows, or for building R itself”.
    Go to <https://cran.r-project.org/bin/windows/Rtools/> and follow
    the directions for installation.

##### **Load and install the necessary packages**

``` r
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load(tidyverse, zoo, ggimage, gt, cfbfastR)
```

#### **The Data**

There are generally speaking **three** college football data sources
accessed from this package:

- [`cfbfastR-data`
  repo](https://github.com/sportsdataverse/cfbfastR-data) [![Twitter
  Follow](https://img.shields.io/twitter/follow/cfbfastR?color=blue&label=%40cfbfastR&logo=x&style=for-the-badge)](https://twitter.com/cfbfastR)
- [College Football Data API](https://collegefootballdata.com)
  [![Twitter
  Follow](https://img.shields.io/twitter/follow/cfb_data?color=blue&label=%40cfb_data&logo=x&style=for-the-badge)](https://twitter.com/cfb_data)
- [ESPN](https://espn.com)

##### **Function names indicate the data source**

- Functions that use the [`cfbfastR-data`
  repository](https://github.com/sportsdataverse/cfbfastR-data) will
  contain `_cfb` or `cfb_` in the function name and would be considered
  loading functions for the play-by-play data.

- Functions that use the CFB Data API start with `cfbd_` by convention
  and should be assumed as `get` functions.

- Functions that use one of ESPN’s APIs start with `espn_` by convention
  and should be assumed as `get` functions. There are only two of these
  functions so far:
  [`espn_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.md)
  and
  [`espn_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/espn_metrics.md)

However, there is only one data *provider* involved for most game data,
ESPN’s data provider.

As of `cfbfastR` version 2.2.0, the package exports 87 functions. The
bulk (~60) of the functions within the package serve as the unofficial R
API client for the [College Football Data
API](https://collegefootballdata.com).

##### **CFB Data now requires an API key (it’s free)**

- Since April 1, 2021, the College Football Data API requires [key
  authentication](https://collegefootballdata.com/key), but the **key is
  free to acquire and use**.

- [Follow the instructions](https://collegefootballdata.com/key) and
  wait for your API key to be delivered to the e-mail account associated
  with your key.

##### **Using the CFB Data API key**

You can save the key for consistent usage by adding
`CFBD_API_KEY=YOUR-API-KEY-HERE` to your .Renviron file (easily accessed
via
[**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)).
Run
[**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html),
a new script will pop open named `.Renviron`, **THEN** paste the
following in the new script that pops up (with**out** quotations)

``` r
CFBD_API_KEY = YOUR-API-KEY-HERE
```

Save the script and restart your RStudio session, by clicking `Session`
(in between `Plots` and `Build`) and click `Restart R` (n.b. there also
exists the shortcut `Ctrl + Shift + F10` to restart your session). If
set correctly, from then on you should be able to use any of the `cfbd_`
functions without any other changes.

For less consistent usage, save your API key as the environment variable
`CFBD_API_KEY` (**with** quotations) at the beginning of every session,
using a command like the following.

``` r
Sys.setenv(CFBD_API_KEY = "YOUR-API-KEY-HERE")
```

## Let’s get some play by play data

If you have ever worked with the now archived
[**`cfbscrapR`**](https://github.com/saiemgilani/cfbscrapR) package,
most of the functions in **`cfbfastR`** should be fairly familiar with
some slight changes.

### Play by play data comparisons

##### **`cfbfastR::cfbd_pbp_data()`** (1 season, ~6-7 minutes 😕)

##### **`cfbscrapR::cfb_pbp_data()`** (1 season, ~8-10 minutes 👴)

##### **`cfbfastR::load_cfb_pbp()`** (7+ seasons, ~1-1.5 minutes 🔥)

#### **The fastR way**

We are going to load in data for seasons 2014-2025, it’ll take between
45-90 seconds to run.

``` r
tictoc::tic()
pbp <- data.frame()
seasons <- 2014:cfbfastR:::most_recent_cfb_season()
progressr::with_progress({

  pbp <- cfbfastR::load_cfb_pbp(seasons)
})
tictoc::toc()
```

    ## 69.051 sec elapsed

In the selected seasons, there are 12854 games for which the data
repository has play by play data. In the present term, the data
repository supplies over a million rows of play by play data with 362
columns of data. The most relevant play columns are kept to the left of
the data frame for clarity, let’s take a look at the first 40 or so.

``` r
glimpse(pbp[1:40])
```

    ## Rows: 2,294,228
    ## Columns: 40
    ## $ year               <int> 2014, 2014, 2014, 2014, 2014, 2014, 2014, 2014, 201…
    ## $ week               <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    ## $ id_play            <dbl> 4.005476e+17, 4.005476e+17, 4.005476e+17, 4.005476e…
    ## $ game_id            <int> 400547640, 400547640, 400547640, 400547640, 4005476…
    ## $ game_play_number   <dbl> 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 12, 13, 1…
    ## $ half_play_number   <dbl> 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 12, 13, 1…
    ## $ drive_play_number  <dbl> 1, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 3, 4, 1, 2, 3, …
    ## $ pos_team           <chr> "Temple", "Temple", "Temple", "Temple", "Temple", "…
    ## $ def_pos_team       <chr> "Vanderbilt", "Vanderbilt", "Vanderbilt", "Vanderbi…
    ## $ pos_team_score     <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    ## $ def_pos_team_score <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    ## $ half               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    ## $ period             <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    ## $ clock_minutes      <int> 14, 14, 14, 14, 13, 13, 12, 12, 12, 12, 11, 10, 10,…
    ## $ clock_seconds      <int> 55, 55, 45, 20, 50, 25, 58, 50, 7, 0, 20, 40, 13, 4…
    ## $ play_type          <chr> "Kickoff Return (Offense)", "Penalty", "Pass Recept…
    ## $ play_text          <chr> "Hayden Lekacz kickoff for 64 yds , Khalif Herbin r…
    ## $ down               <dbl> 1, 1, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 4, 4, 1, 2, 3, …
    ## $ distance           <dbl> 10, 10, 15, 12, 7, 10, 8, 8, 3, 10, 7, 3, 7, 7, 10,…
    ## $ yards_to_goal      <dbl> 65, 81, 86, 83, 78, 70, 68, 68, 63, 72, 69, 65, 69,…
    ## $ yards_gained       <dbl> 18, -5, 3, 5, 8, 2, 0, 5, 8, 3, 4, -4, 0, 0, 7, -3,…
    ## $ EPA                <dbl> -0.565383839, -0.469578030, -0.484324992, -0.214516…
    ## $ ep_before          <dbl> 0.8358481, 0.2704643, -0.4884171, -0.9727421, -1.18…
    ## $ ep_after           <dbl> 0.2704643, -0.1991138, -0.9727421, -1.1872586, 1.34…
    ## $ wpa                <dbl> -0.0224244, -0.0271206, -0.0118346, -0.0000901, 0.1…
    ## $ wp_before          <dbl> 0.4919244, 0.4695000, 0.4423794, 0.4305448, 0.43045…
    ## $ wp_after           <dbl> 0.4695000, 0.4423794, 0.4305448, 0.4304547, 0.53743…
    ## $ def_wp_before      <dbl> 0.5080756, 0.5305000, 0.5576206, 0.5694552, 0.56954…
    ## $ def_wp_after       <dbl> 0.5305000, 0.5576206, 0.5694552, 0.5695453, 0.46256…
    ## $ penalty_detail     <chr> NA, "False Start", NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ yds_penalty        <dbl> NA, -5, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ penalty_1st_conv   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FA…
    ## $ new_series         <dbl> 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, …
    ## $ firstD_by_kickoff  <dbl> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    ## $ firstD_by_poss     <dbl> 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, …
    ## $ firstD_by_penalty  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    ## $ firstD_by_yards    <dbl> 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    ## $ def_EPA            <dbl> 0.565383839, 0.469578030, 0.484324992, 0.214516439,…
    ## $ home_EPA           <dbl> 0.565383839, 0.469578030, 0.484324992, 0.214516439,…
    ## $ away_EPA           <dbl> -0.565383839, -0.469578030, -0.484324992, -0.214516…

So there are three basic ids within each game,

- the id for the game (`game_id`),
- the id for the drive (`drive_id`),
- the id for the play (`id_play` or `play_id` depending on which data
  set you are looking at).

These are useful for all kinds of grouping, joining and sorting tasks.
The columns `pos_team` and `def_pos_team` are essentially your offense
and defense (the main difference is kickoffs, the team receiving the
kickoff is the `pos_team`) for the play/drive. From there you have the
typical descriptions, play types and yardage columns. Beyond that, you
will see the origin of why this package came to be, building expected
points and win probability metrics for in-game valuation of plays.
