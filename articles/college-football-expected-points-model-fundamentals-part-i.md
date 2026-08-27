# College Football Expected Points Model Fundamentals - Part I

In this tutorial, we are going to get more familiar with the Expected
Points portion of College Football Expected Points Added model.

We will be using these ideas as a tool for valuation of plays with the
goal of contextualizing team and player performance relative to the
average, given the situational factors at the start of the play.

Let’s dig in.

### The Data

We will be acquiring data from
[CollegeFootballData.com](https://cfbfastR.sportsdataverse.org/articles/collegefootballdata.com),
courtesy of @[CFB_data](https://twitter.com/CFB_data), using `cfbfastR`,
created by [Saiem Gilani](https://twitter.com/saiemgilani), [Akshay
Easwaran](https://twitter.com/akeaswaran), [Jared
Lee](https://twitter.com/JaredDLee) and [Eric
Hess](https://twitter.com/arbitanalytics).

## The Expected Points Model

### Outcome (target) variables

This model generates probabilities for the possible types of next
scoring events within the same half. The 7 scoring possibilities are:

- Touchdown (7)
- Field Goal (3)
- Safety (2)
- No Score (0)
- Opponent Safety (-2)
- Opponent Field Goal (-3)
- Opponent Touchdown (-7)

For each play, the multinomial logistic regression model calculates what
the probability () of each of those scoring outcomes is and the expected
points can be calculated by multiplying each of the scoring event
probabilities by their associated point values and summing the products,
like so:

[![Figure:
@SaiemGilani](https://i.imgur.com/sJTs6j6.png "Figure: @SaiemGilani")](https://imgur.com/sJTs6j6)

### Predictive variables

The model is fit using the following variables and interactions:

#### Pure Distance Factors (24 variables)

- Yards from opponent’s end zone (6)
- log(yards to convert 1st/Goal) (6)
- Indicator for goal-to-go situations (6)
- Interaction between log(yards to convert 1st/Goal) and goal-to-go
  indicator (6)

#### Down Factors and Down Interactions (54 variables)

- Down (18 since Down is a categorical factor)
- Interaction between log(yards to convert 1st/Goal) and down (18)
- Interaction between yards from opponent’s end zone and down (18)

#### Time Factors and Intercept (18 variables)

- Seconds remaining in the current half (6)
- Indicator for under two-minutes to the end of half/game (6)
- Intercept for each next score type, used as the combined mean value
  for reference variables, in this case 1st Down, not a goal-to-go
  situation and outside of under two minutes left to the end of half or
  game. (6)

You might be asking at this point, “how are there 96 variables, if there
are only 10 bullet points here?” (skip to the next section if you didn’t
ask.) The answer is a little technical if answered completely, but to
model this appropriately, one next score type is used as the reference
target (we chose “No Score” as our reference) and the coefficients are
fitted to the predictive variables for each of the remaining 6 target
score types. This is why you see each factor comprising at least 6
variables.

The additional complexity is that down must be treated as a categorical
factor, meaning 1st down is treated as the reference and there are then
6 variables for 2nd down, 6 variables for 3rd down, and 6 variables for
4th down. The same logic would then also apply to each of the down
interactions. The Boolean indicators for goal-to-go and under
two-minutes are also factors that give relative coefficients to the
‘False’ case, but since there only two cases, only 6 additional
variables are created for each.

### Model Weights

Observations are weighted by both score differential and difference in
number of drives between play and the next score. The former weighting
is intended to accomplish the goal of valuing plays where the score
differential is higher less than possessions where the score
differential is closer to zero.

Additionally, the latter model weighting places more emphasis on plays
on drives that occur closer to the next scoring drive more than plays on
prior drives. An example would be if a game begins with 6 scoreless
drives to start before one team scores, the plays of the first drive
would have a weight of 1/7\*, the plays of the second drive a 2/7
weighting, with the plays of the first scoring drive (i.e. the 7th
possession) having a full 7/7 weighting.

\*Full disclosure: it would be 7 as the denominator if 6 scoreless
drives was the largest distance between scoring drives for the entire
season across all games (it could be 12 for the games across the entire
season, in which case the values would have been 1/12, 2/12, …, 7/12.)

This way the model weighs all games with the same denominator and scales
the weight of each scoring drive distance to a value between 0 and 1.
This same caveat also applies for score differential. Score difference
is scaled by largest score differential across all games in a given
season. Both of the score differential and scoring drive distance
weightings are combined to create a single scaled weighting for each
play across each season.

#### Kicking, Kickoffs, and Punts

Field goals and kickoffs are treated separately. The probability that a
field goal is made is calculated using a general additive model using
the (smoothed) distance of the kick as the predictor, calculated as the
yard-line plus an additional 17 yards. Each field goal attempt’s
expected points are weighted by the probability it is made (resulting in
3 expected points) and adjusted by the probability of a missed field
goal (i.e. Pr(Missed FG) = 1 - Pr(Made FG)) and the resulting change in
EPA due to changes in field position, down, etc. that would occur from
the missed field goal.

Touch-backs are considered the standard expected outcome for kickoffs
and anything returned past the 25 would be a points added situation and
vice versa for those not returned to at least the 25. considered

PATs are not currently being treated separately, the extra point is
treated as a given, which is less than ideal.

Punts are not treated separately, since their primary effect lies mostly
in the change in field position. It is a situation the expected points
model is well suited to predict on.

### Field Position and Expected Points

The model was trained on non-overtime data from 2014-2019 using
leave-one-season-out cross-validation. This means the model holds one
season for test data validation and uses the remaining seasons as the
training set, then uses the trained model to make predictions on the
season held out. This process is then iterated for each season in the
data.

[![Figure:
@SaiemGilani](https://i.imgur.com/g5rSRUXl.png "Figure: @SaiemGilani")](https://imgur.com/g5rSRUX)

This is the plot of expected points in relation to field position alone,
grouped in 10 yard bins and labeled on the plot with the mean expected
points for the bin. The point at the bottom left is roughly the expected
points from having the ball at the offense’s own 1-yard line, -1.28
expected points. The observed mean expected value for receiving the ball
from the offense’s own 21-30-yard line (or 70 to 79 yards from
opponent’s end-zone) is 0.29 expected points.

It should be no surprise that as offenses move closer to their
opponent’s goal line, the expected points trend upward for the offense.
Notice for the point representing the 30-39-yard line grouping, the
expected points is right around the value of a field goal. This aligns
with one of the common definitions of a scoring opportunity, giving
support to the appropriateness of the definition.

The observed average expected points in the red-zone are 4.05 in the
10-19-yard line bin and 5.17 inside the 10, with plays at the 1-yard
line averaging 6.06 expected points. Note: There are some plays that
were input as yard 0 that I interpreted as an “& inches” situation.
There are 66 such plays (compared to 5.3k plays at the 1-yard line) and
their observed mean expected points is 4.62.

### Field Position and Expected Points by Down

Recall that down and down interactions were three of the predictors in
the model, so here is the field position view of expected points
separated by down. The plot below demonstrates that your expected points
are higher (on average) on 1st down than 2nd, and 2nd down than 3rd, etc
at every point on the field, except possibly near the offense’s own goal
line where there is risk of giving up a safety.

[![Figure:
@SaiemGilani](https://i.imgur.com/S7etCxQl.png "Figure: @SaiemGilani")](https://imgur.com/S7etCxQ)

This graph should be somewhat intuitive, but to understand what the
relative expected points difference for each down at the same field
position, we are interested in the vertical distance between each of the
lines.

### 1st and 2nd Down

Noting that, we see that difference between 1st and 2nd down is steady
across most of the field from left to right, starting wider near the
offense’s own goal line and narrowing as the offense progresses toward
the opponent’s end-zone.

### 2nd and 3rd Down

Examining the difference between the 2nd and 3rd down lines, the
distance is much wider, doubling the relative difference between 1st and
2nd for most portions of the middle 60 yards of the field.

### 3rd and 4th Down

Further yet is the 4th down line, which has an interesting track,
narrowing closest to the other down lines around the 25 yard line.

Perhaps we should examine the next score probabilities underlying each
of these down lines to see what drives these relative differences. More
on that in Part 2, coming your way next.

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
