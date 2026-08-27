# Creating Fourth Down Tendency Plots Using cfbfastR

Hey everyone, my name is Michael and over the summer I worked on a daily
series of plots using `ggplot` and the `cfbfastR` package. One of my
favorite plots I put together was the fourth down tendency plot for
various head coaches. This visualization was inspired by Michael Lopez
doing the same thing for NFL coaches. This tutorial is going to walk
through how they’re put together. If you haven’t already, you should
read the introduction tutorial that Parker made to get used to the data
and download the package.

### First, we’ll have to install and import the necessary packages

``` r

if (!requireNamespace('pak', quietly = TRUE)){
  install.packages('pak')
}
pak::pak(c("tidyverse", "cfbfastR"))
library(tidyverse)
library(cfbfastR)
```

We are going to load in data for seasons 2014-2020, it’ll take between
45-90 seconds to run.

``` r

tictoc::tic()
pbp <- data.frame()
seasons <- 2014:2020
progressr::with_progress({

  pbp <- cfbfastR::load_cfb_pbp(seasons)
})
tictoc::toc()
```

    ## 36.839 sec elapsed

Next, we’ll need to get the coaching information, so we’ll use the
`cfbd_coaches` function:

``` r

coaches <- purrr::map_dfr(seasons,function(x){cfbfastR::cfbd_coaches(year = x)})
```

[`cfbd_coaches()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.md)
already returns each coach’s `conference`, so no extra lookup is needed.

``` r

coaches <- coaches |>
  dplyr::mutate(coach = paste(first_name, last_name, sep = " ")) |>
  dplyr::filter(games >= 6) |>
  dplyr::select(coach, school, year, conference)
```

Since interim coaches are included in the coaches dataframe, we’ll set
the cutoff at coaching 6 or more games.

We only have a couple more steps to make our graph. Next, we need to add
our coaches to the `pbp` dataframe using join functions

``` r

pbp <- pbp |>
  dplyr::inner_join(coaches, by = c("offense_play" = "school", "year" = "year"))
```

    ## Warning in dplyr::inner_join(pbp, coaches, by = c(offense_play = "school", : Detected an unexpected many-to-many relationship between `x` and `y`.
    ## ℹ Row 160134 of `x` matches multiple rows in `y`.
    ## ℹ Row 101 of `y` matches multiple rows in `x`.
    ## ℹ If a many-to-many relationship is expected, set `relationship =
    ##   "many-to-many"` to silence this warning.

Now we can filter down to only fourth down plays, then we’ll add columns
to determine if the play was a punt, FGA, or the team went for it.

``` r

down4 <- pbp |>
  dplyr::filter(down == 4) |>
  dplyr::mutate(fga = ifelse(str_detect(play_type, "Field Goal"),
                             1, 0),
                punt = ifelse(play_type == "Punt", 1, 0),
                attempt = ifelse(rush == 1 | pass == 1, 1, 0),
                play = dplyr::case_when(fga == 1 ~ "FG Attempt",
                                 punt == 1 ~ "Punt",
                                 attempt == 1 ~ "Go"))
```

And now we’ve got all the info we need to make the graph! The code below
is listed for current Big 12 head coaches, but you can alter it to show
whichever coaches you want.

``` r

down4 |>
  dplyr::filter(!is.na(play)) |>
  dplyr::filter(coach %in% c("Matt Campbell", "Steve Sarkisian", "Lincoln Riley", "Chris Klieman", "Matt Wells",
                     "Neal Brown", "Les Miles", "Mike Gundy", "Gary Patterson", "Dave Aranda")) |>
  dplyr::filter(distance <= 5, distance > 0) |>
  ggplot(aes(x = distance, y = 100 - yards_to_goal, color = play)) +
  geom_jitter() +
  facet_wrap(. ~ coach) +
  theme_bw() +
  labs(x = "Yards to Go",
       title = "Big 12 Coaches's Fourth Down Tendencies | CFP Era",
       subtitle = "Data from @cfbfastR",
       caption = "Visualization by Michael Egle (@deceptivespeed_)",
       color = "Decision") +
  scale_y_continuous(labels = c("Own 20", "Own 40", "Opp 40",
                               "Opp 20", "Endzone"),
                     breaks = c(20, 40, 60, 80, 100)) +
  theme(axis.title.y = element_blank())
```

![Big 12 Coaches's Fourth Down Tendencies \| CFP
Era](fourth-down-plot-tutorial_files/figure-html/fourth_down_plot-1.png)

Looks good! Small sample size but can easily be built upon. Hopefully
you found this tutorial helpful and can make some more cool CFB related
visualizations with `ggplot2`

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
