# Simulating a College Football Season with cfbseedR

[cfbseedR](https://cfbseedR.sportsdataverse.org/) is the
SportsDataverse’s season simulator for college football, a college
adaptation of [nflseedR](https://nflseedr.com). Give it a schedule and
it computes conference standings with each conference’s official
tiebreakers, crowns the conference champions, seeds the 12-team College
Football Playoff and plays the bracket. Leave some results blank and it
simulates them, thousands of times over.

cfbfastR supplies the schedule. This article rebuilds the 2025 regular
season’s standings and playoff field, then rewinds to week 10 and asks
what the rest of the season looked like from there.

## Load and install the packages

cfbseedR is on CRAN.

``` r

if (!requireNamespace('pak', quietly = TRUE)){
  install.packages('pak')
}
pak::pak(c("dplyr", "cfbseedR", "gt", "scales"))
library(dplyr)
library(cfbseedR)
# cfbfastR is deliberately NOT in the pak() list above. pkgdown and
# R CMD check render this vignette against the package being built, and
# installing from CRAN here would overwrite that dev build with the last
# release -- so any function added since it would vanish mid-render.
library(cfbfastR)
```

[`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.md)
calls the [CollegeFootballData](https://collegefootballdata.com) API, so
it needs a free API key. Get one at
<https://collegefootballdata.com/key> and register it before running the
rest (see
[`?register_cfbd`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)):

``` r

Sys.setenv(CFBD_API_KEY = "YOUR-API-KEY-HERE")
```

## From a cfbfastR schedule to cfbseedR games

[`cfb_games_from_schedule()`](https://cfbseedR.sportsdataverse.org/reference/cfb_games_from_schedule.html)
maps a
[`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.md)
frame onto the games table cfbseedR works with. It turns the final score
into `result` (the home team’s margin) and marks each game `"REG"`,
`"CONF_CHAMP"` (the schedule notes a championship game) or `"POST"`
(bowls and the playoff).

``` r

season <- 2025
sched <- load_cfb_schedules(season)

games <- cfb_games_from_schedule(sched) |>
  # cfbseedR plays the playoff bracket itself, from the seeds it computes
  filter(game_type != "POST")

count(games, game_type)
```

    ## # A tibble: 2 × 2
    ##   game_type      n
    ##   <chr>      <int>
    ## 1 CONF_CHAMP     9
    ## 2 REG          879

The teams table lists the FBS programs and their conference that season.
FCS opponents stay out of it: cfbseedR still counts their games toward
the FBS teams’ records, but gives them no standings row, so they can’t
be seeded.

``` r

teams <- bind_rows(
  select(sched, team = home_team, conference = home_conference, division = home_division),
  select(sched, team = away_team, conference = away_conference, division = away_division)
) |>
  filter(division == "fbs") |>
  distinct(team, conference)

count(teams, conference, sort = TRUE)
```

    ## # A tibble: 11 × 2
    ##    conference            n
    ##    <chr>             <int>
    ##  1 Big Ten              18
    ##  2 ACC                  17
    ##  3 Big 12               16
    ##  4 SEC                  16
    ##  5 American Athletic    14
    ##  6 Sun Belt             14
    ##  7 Mid-American         13
    ##  8 Conference USA       12
    ##  9 Mountain West        12
    ## 10 FBS Independents      2
    ## 11 Pac-12                2

## Standings and the playoff field

With every result filled in,
[`cfb_standings()`](https://cfbseedR.sportsdataverse.org/reference/cfb_standings.html)
ranks each conference with its own tiebreaker procedure, and
[`cfb_playoff_seeds()`](https://cfbseedR.sportsdataverse.org/reference/cfb_playoff_seeds.html)
builds the field. `autobid = "2025"` applies that season’s rule: the
five highest-ranked conference champions are in.

``` r

standings <- cfb_standings(games, teams)

seeds <- cfb_playoff_seeds(standings, playoff_seeds = 12L, autobid = "2025")

seeds |>
  filter(!is.na(seed)) |>
  arrange(seed) |>
  select(seed, team, conference, conf_champ, wins, losses)
```

    ## # A tibble: 12 × 6
    ##     seed team          conference        conf_champ  wins losses
    ##    <int> <chr>         <chr>             <lgl>      <int>  <int>
    ##  1     1 Indiana       Big Ten           TRUE          13      0
    ##  2     2 Texas Tech    Big 12            TRUE          12      1
    ##  3     3 James Madison Sun Belt          TRUE          12      1
    ##  4     4 Georgia       SEC               TRUE          12      1
    ##  5     5 Ohio State    Big Ten           FALSE         12      1
    ##  6     6 Oregon        Big Ten           FALSE         11      1
    ##  7     7 Ole Miss      SEC               FALSE         11      1
    ##  8     8 Texas A&M     SEC               FALSE         11      1
    ##  9     9 BYU           Big 12            FALSE         11      2
    ## 10    10 North Texas   American Athletic FALSE         11      2
    ## 11    11 Tulane        American Athletic TRUE          11      2
    ## 12    12 Oklahoma      SEC               FALSE         10      2

Without a `rankings` table, seeding orders teams by win percentage, then
strength of victory, strength of schedule and point differential. The
real field is seeded by the selection committee’s ranking, so pass the
committee’s final top 25 (`team`, `rank`) as `rankings` to reproduce it.

## Simulating the rest of the season from week 10

Now rewind. Blank out every result between two FBS teams from week 10
on, and let
[`cfb_simulations()`](https://cfbseedR.sportsdataverse.org/reference/cfb_simulations.html)
play those games. Games against FCS opponents keep their real results,
because FCS teams carry no rating.

``` r

cutoff <- 10
fbs <- teams$team

games_wk10 <- games |>
  mutate(result = ifelse(week >= cutoff & home_team %in% fbs & away_team %in% fbs,
                         NA, result))

sum(is.na(games_wk10$result))
```

    ## [1] 298

The default results generator is an Elo model carried over from
nflseedR. Left alone it starts every team at a random rating, so seed it
with CFBD’s own Elo: each team’s post-game rating from its last game
before the cutoff.

``` r

played <- filter(sched, season_type == "regular", week < cutoff)
elo <- bind_rows(
  select(played, start_date, team = home_team, elo = home_postgame_elo),
  select(played, start_date, team = away_team, elo = away_postgame_elo)
) |>
  filter(team %in% fbs, !is.na(elo)) |>
  arrange(start_date) |>
  group_by(team) |>
  summarise(elo = last(elo))

elo <- setNames(elo$elo, elo$team)
head(sort(elo, decreasing = TRUE), 10)
```

    ## Notre Dame Ohio State    Indiana     Oregon    Georgia Penn State    Alabama 
    ##       2193       2098       2091       2055       2034       1990       1978 
    ##   Ole Miss      Texas       Iowa 
    ##       1963       1925       1907

[`cfb_simulations()`](https://cfbseedR.sportsdataverse.org/reference/cfb_simulations.html)
passes `elo` on to the results generator. Each simulation plays out
weeks 10 through the conference championship games, recomputes the
standings and the 12 seeds, and plays the bracket. Conference
championship games are played as scheduled, between the two teams that
actually made them.

``` r

set.seed(2025)
sim <- cfb_simulations(
  games_wk10, teams,
  simulations = 500,
  playoff_seeds = 12L,
  autobid = "2025",
  elo = elo,
  verbosity = "NONE"
)
```

`sim$overall` has one row per team: average wins and the share of
simulations in which it won its conference, made the playoff, earned the
top seed and won the national title.

``` r

sim$overall |>
  arrange(desc(playoff)) |>
  select(team, conference, wins, conf_champ, playoff, seed1, won_natty) |>
  head(16)
```

    ## # A tibble: 16 × 7
    ##    team          conference         wins conf_champ playoff seed1 won_natty
    ##    <chr>         <chr>             <dbl>      <dbl>   <dbl> <dbl>     <dbl>
    ##  1 Indiana       Big Ten           12.0       0.484   0.958 0.292     0.25 
    ##  2 Ohio State    Big Ten           11.9       0.516   0.91  0.264     0.292
    ##  3 Georgia       SEC               11.0       0.632   0.74  0.06      0.114
    ##  4 North Texas   American Athletic 11.0       0.602   0.722 0.022     0.002
    ##  5 James Madison Sun Belt          10.8       0.834   0.678 0.03      0.002
    ##  6 Ole Miss      SEC               10.6       0       0.658 0.002     0.06 
    ##  7 Alabama       SEC               10.7       0.368   0.644 0.048     0.082
    ##  8 Texas A&M     SEC               10.8       0       0.636 0.082     0.016
    ##  9 Texas Tech    Big 12            10.7       0.672   0.622 0.05      0.024
    ## 10 Oregon        Big Ten           10.2       0       0.558 0.002     0.12 
    ## 11 Memphis       American Athletic  9.94      0       0.55  0         0    
    ## 12 BYU           Big 12            10.4       0.328   0.468 0.084     0.006
    ## 13 Georgia Tech  ACC               10.1       0       0.438 0.038     0.002
    ## 14 Boise State   Mountain West     10.0       0.734   0.424 0         0.006
    ## 15 Miami         ACC               10.0       0       0.41  0         0.004
    ## 16 Louisville    ACC                9.45      0       0.372 0.002     0.002

[`summary()`](https://rdrr.io/r/base/summary.html) turns the same
numbers into a table grouped by conference:

``` r

summary(sim)
```

[TABLE]

To spread a larger run across cores, set a parallel plan first:
simulations are split into `chunks` and dispatched with furrr.

``` r

future::plan("multisession")
sim <- cfb_simulations(games_wk10, teams, simulations = 10000, chunks = 8,
                       elo = elo, autobid = "2025")
future::plan("sequential")
```

cfbseedR’s own articles cover the [tiebreaker ladder and CFP
rules](https://cfbseedR.sportsdataverse.org/articles/tiebreakers-and-cfp.html)
and [custom results
generators](https://cfbseedR.sportsdataverse.org/articles/simulating-seasons.html).

## **Citation**

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

## **Related SportsDataverse packages**

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
