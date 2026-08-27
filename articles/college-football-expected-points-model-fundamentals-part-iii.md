# College Football Expected Points Model Fundamentals - Part III

Previously in part 1, we left off discussing field position and expected
points, including a breakdown by down. Generally, what was presented
could be considered the most top-level results discussion and model
definition information. In part 2, we went into some detail about
regression model building methods and how the model generates the next
score probabilities, with some depth into how we arrived at the model
from a technical perspective. Today, I feel it necessary for us to cover
some history of the expected points model in football. This article will
show you how we arrive at the model factors that we currently have from
a historical perspective.

The entire purpose of these series of articles is to show you as
transparently as I can how the College Football Expected Points model
works, how well it works, and how the model is limited. Additionally,
this research is reproducible.

### The Data

We will be acquiring data from
[CollegeFootballData.com](https://cfbfastR.sportsdataverse.org/articles/collegefootballdata.com),
courtesy of @[CFB_data](https://twitter.com/CFB_data), using `cfbfastR`,
created by [Saiem Gilani](https://twitter.com/saiemgilani), [Akshay
Easwaran](https://twitter.com/akeaswaran), [Jared
Lee](https://twitter.com/JaredDLee) and [Eric
Hess](https://twitter.com/arbitanalytics).

## An Abridged History of Expected Points Models in Football

### Field Position models

One of the earliest discussions and attempts at building an expected
points model in football was made by [Virgil Carter of the Cincinatti
Bengals](https://vault.si.com/vault/1972/10/16/handy-pair-of-brainy-bengals)
in his graduate research paper, “[Operations Research on
Football](https://pubsonline.informs.org/doi/pdf/10.1287/opre.19.2.541)”.
Carter found some time to write the research paper while pursuing his
MBA at Northwestern in the off-season from his main gig of being
quarterback for the Chicago Bears.

For the study, Carter and his wife Judy coded 8,373 plays with 53
variables — including time, down, and distance — from 56 games played
during the first half of the 1969 season. From the paper:

> … the field was divided into ten strips, namely, 99 to 01 yards to go,
> 90 to 81 yards to go, 80 to 71 yards to go, etc. These data are
> identified by their midpoints in Table I. The smallest number of data
> points in any set was 57 (this set centered on 95 yards to go), and
> the largest was 601 (this set centered on 75 yards to go)., This
> condensation led to a system of ten equations in 10 unknowns.

[![Figure:
@SaiemGilani](https://i.imgur.com/3X3s1dMl.png "Figure: @SaiemGilani")](https://imgur.com/3X3s1dM)

**Figure 1**: Expected Point Values of Possession table \| Virgil
Carter, “Operations Research on Football”, 1971

> The analysis was based on a study of 2,852 first-and-ten plays. An
> independent calculation was performed for the subset of 1,258 first
> downs immediately following a turnover (i.e. the start of a series),
> and the average absolute difference was found to be less than a
> quarter of a point. (Carter and Machol, 1971)

This smaller dataset is used as the basis for the model described in the
paper and we will show the results graphically in the figure below.

For complete clarity, the study averaged the value of the next scores
for each of the 10 strips listed to give the data in the table.

[![Figure:
@SaiemGilani](https://i.imgur.com/MdzOd7sl.png "Figure: @SaiemGilani")](https://imgur.com/MdzOd7s)

**Figure 2**: Virgil Carter’s Expected Points study, 1971

In 1988, the book [Hidden Game of
Football](https://www.amazon.com/gp/product/0446390917?ie=UTF8&tag=adnfst-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0446390917)
by Bob Carroll, Pete Palmer, and John Thorn introduced a straight-line
model of valuing field position in two point increments.

In other words, starting from your own 0 (or 100 yards-to-goal) is worth
-2 expected points, possession at the 20-yard line is worth 0 expected
points, and possession at the 40-yard line is worth 2 points, etc. until
you get to the opponent’s goal line, where your expected points value is
6. This is a simplified model based in principle on the Carter model
above.

The figure below is a visual comparison of the two models.

[![Figure:
@SaiemGilani](https://i.imgur.com/Ccqk9lrl.png "Figure: @SaiemGilani")](https://imgur.com/Ccqk9lr)

**Figure 3**: Expected Points Value Comparison: Virgil Carter study
vs. Hidden Game of Football EP model

We have looked at the Carter model, which only looked at field position
for a specific down and distance situation (namely, 1st-and-10) and
modeled expected points as the average of the points scored in each of
the 10 field position bins.

We additionally covered a model that ignored down and distance
altogether and modeled the expected points as a function of field
position. Now, let’s look at some of the more recent attempts at
modeling that include both down and distance, in addition to field
position.

### Down-Distance-Field Position models

Belur V. Dasarthy wrote a paper in 1991 with the three above factors
using a nearest-neighbor approach and averaging the next points scored
that I have not been able to get my hands on.

Some time in 2009 or earlier, Brian Burke posited that every
down-distance-field position combination had an [average net point
advantage](http://www.advancedfootballanalytics.com/2009/12/expected-point-values.md).
He built a model demonstrating as such with a smoothing technique called
locally estimated scatterplot smoothing (LOESS) but not much else in
terms of detail provided.

You can read more about his model at the link above, but among the noted
limitations with the model were that it only included first and third
quarter data since he correctly noted end-of-half drive plays was a
factor that needed to be accounted for.

His other consideration was that he limited the data to plays where the
score differential was within 10 points to limit the effect of garbage
time.

Trey Causey did a quality write-up on a very similar style
[model](http://thespread.us/expected-points.md) and has done some
interesting [nearest-neighbors](http://thespread.us/clustering.md)
player similarity modeling that is worth reading and, at the time, was
reproducible.

So all of these models are curve fitting attempts that lead us to the
topic of regression.

### Game-State Situational Probability models

Alok Pattani’s 2012 writeup on [ESPN’s NFL Expected Points
model](https://www.espn.com/nfl/story/_/id/8379024/nfl-explaining-expected-points-metric),
which additionally included home-field advantage and time remaining,
left a lot of the detail out, giving few reproducible details.

However, in subsequent years, more details regarding the technical
specifics of ESPN’s Bayesian hierarchical statistical expected points
model were discussed in an article on the [PlayStation Player Impact
Rating](https://www.espn.com/college-football/story/_/page/PSimpactrating0819/introducing-new-way-rate-college-football-players).

Additionally, Kenneth Goldner wrote a paper in 2017 about using a Markov
modeling of a possession with stochastic processes which I have been
unable to get my hands on. EDIT: A very kind Columbia professor saw this
article and sent me the paper. Among other things, the paper
demonstrates that on 1st and 10 at any point on the field, the expected
points is positive.

In 2017, Ron Yurko, Sam Ventura, and Max Horowitz from Carnegie Mellon
University’s Statistics department started presenting “[NFL Player
Evaluation Using Expected Points Added with
nflscrapR](https://www.stat.cmu.edu/~ryurko/files/greatlakes_2017.pdf)”
at conferences and ultimately published the
[nflWAR](https://www.degruyter.com/view/journals/jqas/15/3/article-p163.xml?tab_body=pdf-74962)
paper in the Journal of Quantitative Analysis in Sports.

(That is a seminal work in football analytics and if you were to only
click one link to read more on, that is the paper you should look at.)

[![Figure:
@SaiemGilani](https://i.imgur.com/cejyymhl.png "Figure: @SaiemGilani")](https://imgur.com/cejyymh)

**Figure 4**: Modeling Expected Points using situational factors to
predict the probability of each Next Score type

The current cfbfastR model is providing expected points using the same
model fit to college football data and with very similar adjustments.

Time to talk about the cfbfastR model, finally!

Recall the following figure from part 2.

[![Figure:
@SaiemGilani](https://i.imgur.com/bGug8hpl.png "Figure: @SaiemGilani")](https://imgur.com/bGug8hp)

**Figure 5**: Multinomial Logistic Regression Football Expected Points
Model

The college football expected points (EP) model is a multinomial
logistic regression model which generates probabilities for our
dependent (target) variable, the possible types of next score events
within the same half.

In our case, we build 6 logistic regression models fit to the next score
types — Offense FG, Offense TD, Offense Safety, Opponent TD, Opponent
FG, and Opponent Safety — all except for the class that is used as the
base case (i.e. No Score), since that is accounted for in the intercept,
as mentioned in part 1.

Since down is a categorical variable, it must be treated as a factor
variable, meaning coefficients of the model are given relative to the
base case of 1st down.

Thus, we have 2nd down, 3rd down, and 4th down coefficients, with the
same reasoning applying to all other interaction variables which include
down.

The independent variables are (in parentheses are the number of
coefficients fitted to the factor):

- Down (3)
- Distance (to convert 1st down or goal), transformed as log(yards to
  convert 1st/Goal) (1)
- Yards-to-goal (or field position, or yards to opponent goal line) (1)
- Time remaining in half in seconds (1)

From these independent variables, we derive two other boolean variables:

- Goal-to-Go (1)
- Under two minutes in half (1)

We also include several interaction terms between our independent and
derived variables:

- Interaction between distance as log(yards to convert 1st/Goal) and
  goal-to-go indicator (1)
- Interaction between distance as log(yards to convert 1st/Goal) and
  down (3)
- Interaction between yards from opponent’s end zone and down (3)

The model outputs the probability predictions of each next score type
for every play before the play. Then using the play outcomes to adjust
our four main independent variables, it then outputs the model
probability predictions for all 7 types post-play.

Next time will cover the underlying next score type probabilities and
their influence on the change in expected points as the offense
progresses down the field.

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
