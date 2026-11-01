# Rolling EPA Graph

This vignette will use data from the `cfbfastR` package to create a
moving average graph of offensive EPA over the course of a season. This
lets us visualize how a team’s performance has changed over time and
compare that performance to other teams around the country.

### Load and Install the necessary packages

``` r

if (!requireNamespace('pak', quietly = TRUE)){
  install.packages('pak')
}
pak::pak(c("tidyverse", "zoo"))
library(tidyverse)
library(zoo)
library(sdvplotR)
# cfbfastR is deliberately NOT in the pak() list above. pkgdown and
# R CMD check render this vignette against the package being built, and
# installing from CRAN here would overwrite that dev build with the last
# release -- so any function added since it would vanish mid-render.
library(cfbfastR)
```

The team logos and colours come from
[sdvplotR](https://sdvplotR.sportsdataverse.org/), the SportsDataverse
plotting package. It is not on CRAN; install it from the SportsDataverse
r-universe:

``` r

install.packages("sdvplotR", repos = c("https://sportsdataverse.r-universe.dev", getOption("repos")))
```

### Pull the play by play data

Using the
[load_cfb_pbp()](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.html)
method, we will pull down a dataframe that contains ALL of the play by
play data for ALL teams in 2026. This method only takes about 30
seconds.

``` r

yr <- cfbfastR:::most_recent_cfb_season()-1
pbp <- cfbfastR::load_cfb_pbp(yr)
```

### Team colors and logos

There is no team lookup table to build. sdvplotR matches the school
names in the play-by-play (`"Oklahoma"`, `"Illinois State"`) to its
index of every FBS and FCS program, so its scales and logo layers take
the names as they are.
[`sdv_team_colors()`](https://sdvplotR.sportsdataverse.org/reference/sdv_team_colors.html)
shows what it will use:

``` r

sdv_team_colors("cfb", c("Oklahoma", "Texas", "Illinois State"))
```

    ##       Oklahoma          Texas Illinois State 
    ##      "#990000"      "#af5c37"      "#ce1126"

### Basic overview of all FBS Offenses

Let’s create a basic overview of offensive EPA per play. We’ll start by
creating a dataframe listing all 130 FBS teams from best to worst based
on their average EPA per play across all games played.

``` r

off_epa <- pbp |>
  filter(rush == 1 | pass == 1) |> 
  group_by(offense_play, offense_conference) |>
  summarize(off_epa = mean(EPA, na.rm = TRUE)) |>
  arrange(desc(off_epa)) |>
  rename(Team = offense_play) |>
  filter(!is.na(offense_conference)) |>
  ungroup() |>
  mutate(Rank = row_number()) |>
  mutate(TeamRank = paste0(Team, " #", Rank))
```

We can use the [`head()`](https://rdrr.io/r/utils/head.html) function to
take a quick peak at what our new dataframe looks like. The teams at the
top should not be surprising. Remember, EPA is not adjusted for the
strength of opponent. It is purely a measure of how teams perform on the
field (like yards, but better).

``` r

head(off_epa)
```

    ## # A tibble: 6 × 5
    ##   Team          offense_conference off_epa  Rank TeamRank        
    ##   <chr>         <chr>                <dbl> <int> <chr>           
    ## 1 Alabama State SWAC                 0.334     1 Alabama State #1
    ## 2 Vanderbilt    SEC                  0.267     2 Vanderbilt #2   
    ## 3 Jackson State SWAC                 0.227     3 Jackson State #3
    ## 4 North Texas   American Athletic    0.223     4 North Texas #4  
    ## 5 Navy          American Athletic    0.222     5 Navy #5         
    ## 6 USC           Big Ten              0.215     6 USC #6

Ok, now let’s start to visualize the data beyond the top few schools.
Let’s graph all the teams that have a positive EPA on the year.

``` r

off_epa |>
  filter(off_epa > 0) |>
  ggplot(aes(x = reorder(TeamRank, off_epa), y=off_epa)) +
  geom_point(size = 3) +
  coord_flip() +
  theme_bw() +
  ylab("Average EPA Per Play") + xlab("") +
  labs(title = "Offensive EPA Per Play | Positive EPA Teams",
       caption = "Chart by @cfbNate
       Data from @CFB_Data via @cfbfastr") 
```

![Offensive EPA Per Play \| Positive EPA
Teams](rolling-epa-graph_files/figure-html/graph_top_offenses-1.png)

### Prepare the data for the moving average chart

So far, so good, but we came here to build a moving average chart! Let’s
proceed by defining the team of interest and the moving average window
by editing the cell block below. I like to use 100 plays when looking at
a full season to smooth out as much of the variability as possible, but
for a mid-season view 50 plays or even 25 plays might be more
appropriate. Play around!

``` r

team <- "Oklahoma"
ma_plays <- 100
```

Now that we have defined our team of interest, we can prepare the data
for this specific team. We’re going to create a dataframe called
`team_off` that is subsetted from our full season play by play data.
This new dataframe will be specific to our team of interest and it will
add fields for the moving average and the play count.

``` r

team_off <- pbp |>
  filter(offense_play == {{team}}) |>
  filter(rush == 1 | pass == 1) |>
  filter(!is.na(EPA)) |>
  mutate(cu_epa=cummean(EPA),  #this field is not used in this vignette but it could be substituted later to graph the cumulative EPA
         ma_epa = rollapply(EPA,ma_plays,mean,align='right',fill=NA),
         play_count = row_number(),
         week_team = paste0("WK", ifelse(week > 9, week, paste0(0,week)), " ", defense_play))
```

We’re going to graph different background tiles for each opponent so we
need to define where one opponent stops and another one begins.

``` r

team_off_play_start <- team_off |>
  group_by(week_team) |>
  slice(1) |>
  select(defense_play, week_team, play_count) |>
  rename(play_start = play_count,
         team = defense_play)

team_off_play_stop <- team_off |>
  group_by(week_team) |>
  filter(row_number() == n()) |>
  select(week_team, play_count) |>
  rename(play_stop = play_count)
```

We’re going to add the opponent’s logo in the middle of each background
tile, so we need to define the midpoint of each background tile as well.

``` r

team_off_start_stop <- team_off_play_start |>
  left_join(team_off_play_stop, by = "week_team") |>
  mutate(midpoint = (play_start + play_stop)/2)
```

We need to make a simple vector that says how many total plays are in
our `team_off` dataframe.

``` r

play_count <- max(team_off$play_count)
```

Each background tile is coloured with the opponent’s primary colour by
`scale_fill_sdv(league = "cfb")`, and
[`geom_sdv_logos()`](https://sdvplotR.sportsdataverse.org/reference/geom_sdv_logos.html)
puts the opponent’s logo at the tile’s midpoint. Both read the opponent
from the `team` column, FCS opponents included.

Almost done! The last thing we need is your signature to go in the
caption of the graph. You can use your twitter handle or your real name
here.

``` r

signature <- "@cfbNate"
```

### IT’S GRAPHIN’ TIME\*

^(\*To be said in an extremely Power Rangers voice)

The beginning of the line graph will depend on the `ma_plays` variable
that you defined earlier. Dashed lines indicating the EPA/play of the
25th percentile, median, 75th percentile, and top and bottom teams in
the country are drawn on the graph to show context for how the team of
interest compares to the rest of the country.

``` r

graph_team_off = ggplot() +
  geom_rect(data = team_off_start_stop, aes(xmin = play_start, xmax = play_stop, fill = team, ymin = -.7, ymax = .9), color = "gray90") +
  geom_rect(data = team_off_start_stop, aes(xmin = play_start, xmax = play_stop, ymin = .8, ymax = 1), color = "gray90", fill = "white") +
  scale_fill_sdv(league = "cfb") +
  geom_hline(yintercept = quantile(off_epa$off_epa), linetype = 2, color = "gray20", alpha = .8) +
  geom_hline(yintercept = 0, linetype = 1, color = "gray20", alpha = .2) +
  geom_sdv_logos(data = team_off_start_stop, aes(x = midpoint, y = .9, team = team), league = "cfb", height = .07) +
  annotate(x = -2, y = quantile(off_epa$off_epa)[1], geom = "text", size = 3, hjust = "right", vjust = 0, label = off_epa |> slice(n()) |> pull(Team)) +
  annotate(x = -2, y = quantile(off_epa$off_epa)[2], geom = "text", size = 3, hjust = "right", vjust = 0, label = "25%ile") +
  annotate(x = -2, y = quantile(off_epa$off_epa)[3], geom = "text", size = 3, hjust = "right", vjust = 0, label = "Median") +
  annotate(x = -2, y = quantile(off_epa$off_epa)[4], geom = "text", size = 3, hjust = "right", vjust = 0, label = "75%ile") +
  annotate(x = -2, y = quantile(off_epa$off_epa)[5], geom = "text", size = 3, hjust = "right", vjust = 0, label = off_epa |> slice(1) |> pull(Team)) +
  geom_line(data = team_off, aes(x = play_count, y = ma_epa), color = "white", size = 2) +
  geom_line(data = team_off, aes(x = play_count, y = ma_epa), size = 1.25) +
  theme_minimal() + theme(panel.grid = element_blank()) + theme(legend.position = "none") +
  ylab("EPA") + xlab("Number of Plays") +
  labs(title = paste0(team," Offensive EPA | ",ma_plays,"-Play Moving Average"),
       caption = paste0("Chart by ",signature," using code from @cfbNate
       Data from @CFB_Data via @cfbfastR")) +
  coord_cartesian(xlim = c(-20, play_count),  # This leaves room for the labels over the dashed lines
                  clip = 'off')               # This keeps the labels from disappearing

graph_team_off
```

![Offensive EPA Rolling
Average](rolling-epa-graph_files/figure-html/graph_the_graph-1.png)

Lastly, you can save your graph to your working directory by running the
line below. PC users will notice the saved graphic will have a higher
resolution and less pixelization than the graphic generated above.

Reminder: You can always use
[`getwd()`](https://rdrr.io/r/base/getwd.html) to find out what your
current working directory is if you’re not sure.

``` r

ggsave(graph_team_off, filename = paste0("off_epa_rolling_",team,".png"), 
       dpi = 300, type = "cairo", width = 10, height = 7, units = "in")
```

I hope you found this useful! As always, thanks to
[@CFB_Data](https://twitter.com/CFB_Data) and the
[@cfbfastR](https://twitter.com/cfbfastR) team for making this possible.
And shout out to folks like Parker Fleming
([@statsowar](https://twitter.com/statsowar)) and Meyappan Subbaiah
([@msubbaiah1](https://twitter.com/msubbaiah1)) for their feedback,
advice, and encouragement while refining the look of this visualization.
Tag me in any of these graphs you post on twitter and I’ll share them as
much as possible.

\-[Nate Manzo](https://twitter.com/cfbNate)

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
