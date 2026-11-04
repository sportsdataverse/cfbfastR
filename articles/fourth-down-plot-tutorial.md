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
pak::pak(c("tidyverse", "sportyR"))
library(tidyverse)
library(sportyR)
# cfbfastR is deliberately NOT in the pak() list above. pkgdown and
# R CMD check render this vignette against the package being built, and
# installing from CRAN here would overwrite that dev build with the last
# release -- so any function added since it would vanish mid-render.
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

    ## 41.254 sec elapsed

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

Rather than a blank panel, we’ll draw each decision on a regulation
college field with [`sportyR`](https://sportyR.sportsdataverse.org/)’s
`geom_football("ncaa")`. sportyR centres the field on midfield and
measures it in yards, so the offense’s own goal line sits at `x = -50`
and the opponent’s at `x = 50`: a line of scrimmage `yards_to_goal`
yards from the end zone is at `x = 50 - yards_to_goal`. The field’s
width carries no information here, so the points are jittered across it.

``` r

big_12_coaches <- c("Matt Campbell", "Steve Sarkisian", "Lincoln Riley", "Chris Klieman", "Matt Wells",
                    "Neal Brown", "Les Miles", "Mike Gundy", "Gary Patterson", "Dave Aranda")

big_12_down4 <- down4 |>
  dplyr::filter(!is.na(play)) |>
  dplyr::filter(coach %in% big_12_coaches) |>
  dplyr::filter(distance <= 5, distance > 0)

geom_football("ncaa") +
  geom_jitter(data = big_12_down4,
              aes(x = 50 - yards_to_goal, y = 0, color = play),
              width = 0, height = 22, size = 1.5) +
  facet_wrap(. ~ coach, ncol = 4) +
  scale_color_manual(values = c("Go" = "#ffd23f", "FG Attempt" = "#3bceac", "Punt" = "#ee4266")) +
  labs(title = "Big 12 Coaches's Fourth Down Tendencies | CFP Era",
       subtitle = "Fourth and 5 or shorter, at the line of scrimmage. Offense moving left to right.",
       caption = "Data from @cfbfastR | Field from sportyR | Visualization by Michael Egle (@deceptivespeed_)",
       color = "Decision") +
  theme(legend.position = "top")
```

![Ten small college football fields, one per Big 12 head coach, each
showing that coach's fourth-and-five-or-shorter plays from 2014 to 2020
as points at the line of scrimmage, coloured by whether the team went
for it, kicked a field goal or punted, with the offense moving left to
right.](fourth-down-plot-tutorial_files/figure-html/fourth_down_plot-1.png)

### How makeable were those fourth downs?

cfbfastR ships a port of [cfb4th](https://cfb4th.sportsdataverse.org/)’s
fourth-down model.
[`calculate_fourth_down()`](https://cfbfastR.sportsdataverse.org/reference/calculate_cfb_models.md)
scores the chance the offense gains the yards it needs
(`fd_conversion_prob`) from the down, distance, field position and the
pre-game line. The line comes from each game’s `spread` (the home team’s
line, negative when the home team is favoured) and `over_under`, turned
around to the offense’s point of view:

``` r

big_12_down4 <- big_12_down4 |>
  dplyr::mutate(
    is_home = pos_team == home,
    posteam_spread = ifelse(is_home, -spread, spread),
    posteam_total = ifelse(is_home, (over_under - spread) / 2, (over_under + spread) / 2)
  ) |>
  cfbfastR::calculate_fourth_down()
```

On the fourth downs the model rates as better than a coin flip to
convert, how often did each coach keep the offense on the field?

``` r

big_12_down4 |>
  dplyr::filter(fd_conversion_prob > 0.5) |>
  dplyr::group_by(coach) |>
  dplyr::summarise(plays = dplyr::n(),
                   go_rate = mean(play == "Go"),
                   mean_conversion_prob = mean(fd_conversion_prob)) |>
  dplyr::arrange(dplyr::desc(go_rate))
```

    ## # A tibble: 10 × 4
    ##    coach           plays go_rate mean_conversion_prob
    ##    <chr>           <int>   <dbl>                <dbl>
    ##  1 Dave Aranda        16   0.5                  0.655
    ##  2 Steve Sarkisian    37   0.486                0.659
    ##  3 Lincoln Riley     114   0.421                0.624
    ##  4 Chris Klieman      40   0.4                  0.637
    ##  5 Matt Campbell     215   0.4                  0.628
    ##  6 Neal Brown        175   0.394                0.625
    ##  7 Les Miles          96   0.375                0.633
    ##  8 Matt Wells        239   0.351                0.626
    ##  9 Gary Patterson    222   0.320                0.647
    ## 10 Mike Gundy        230   0.317                0.640

Conversion probability is only half the decision: going for it should
also be weighed against what a field goal or a punt is worth.
[cfb4th](https://cfb4th.sportsdataverse.org/) does that comparison in
win probability, and is installed from the SportsDataverse r-universe:

``` r

install.packages("cfb4th", repos = c("https://sportsdataverse.r-universe.dev", getOption("repos")))

# go / field goal / punt win probabilities and the recommended call for every
# fourth down of a season. It joins CFBD betting lines, so it needs a
# CFBD_API_KEY; the models download and cache on first use.
fourth_downs <- cfb4th::load_4th_pbp(2020)
fourth_downs |>
  dplyr::select(pos_team, def_pos_team, distance, yards_to_goal, go_boost, go, play_type)
```

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
