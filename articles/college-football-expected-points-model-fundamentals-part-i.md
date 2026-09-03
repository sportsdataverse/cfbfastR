# Expected Points in College Football: How the Model Works (Part I)

**Expected points (EP) is the number of points a team can expect to
score, net of what its opponent scores, before the next score of the
half — given down, distance, field position and time.** A first-and-10
on your own 1-yard line is worth about −1.3 points. The same down and
distance on your opponent’s 20 is worth about +4. The difference between
those two numbers is what makes a 40-yard gain valuable, and *expected
points added* (EPA) is simply the change in EP across a single play.

This article covers what the model predicts and how to reproduce its
central result. [Part
II](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-ii.md)
covers how the model is built and why it is a gradient-boosted
classifier. [Part
III](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-iii.md)
covers where the idea came from.

## Which model are you running?

This matters before anything else, because **two generations of the
model are in circulation and they give different EPA for the same
play.**

|  | CRAN `cfbfastR 3.0.0` | GitHub `3.0.0.9000` |
|----|----|----|
| EP estimator | [`nnet::multinom`](https://rdrr.io/pkg/nnet/man/multinom.html) from `cfbfastR-data` | XGBoost, from the `cfb_model_artifacts` bundle |
| Agrees with `sportsdataverse-py` | no | yes — same artifact |
| Mid-era CFBD seasons (~2006–2013) | aborts ([\#5](https://github.com/sportsdataverse/cfbfastR/issues/5)) | works |

``` r

packageVersion("cfbfastR")
# 3.0.0        -> CRAN build, previous model generation
# 3.0.0.9000   -> GitHub build, shared bundle
```

The four-component version exists precisely so this is answerable. If
you are comparing EPA numbers with someone else, compare versions first.

Everything below describes the **current** generation.

## How the model has evolved

The series originally described a model that no longer ships. The change
is worth understanding, because it is a real shift in modelling
philosophy rather than a version bump.

|  | 2020 generation | 2026 generation (current) |
|----|----|----|
| Estimator | multinomial logistic regression ([`nnet::multinom`](https://rdrr.io/pkg/nnet/man/multinom.html)) | XGBoost, `multi:softprob` |
| Inputs | **96 model variables** — hand-built interactions and factor expansions | **8 features** |
| Training data | non-overtime plays, 2014–2019 | 2004–2025, 2,219,971 plays |
| Validation | leave-one-season-out CV | see the model card |
| Published as | an `.rda` in `cfbfastR-data` | a versioned release asset both libraries read |
| Field goals | GAM on smoothed kick distance | a separate gradient-boosted `fg_model` |

The most interesting line is the feature count: **96 variables became
8.**

That is not a loss of information. The old model needed those 96 columns
because a linear model can only see an interaction if you build the
interaction by hand — every `log(distance) × down`, every
`yards_to_goal × down`, every factor level expanded against a reference
class. Gradient-boosted trees learn interactions from splits, so the
same structure is recovered from the raw eight:

``` r

c("TimeSecsRem", "yards_to_goal", "distance",
  "down_1", "down_2", "down_3", "down_4", "pos_score_diff_start")
```

Note also what is *new* in that list: `pos_score_diff_start`. The
current model knows the score. The old one did not — it handled game
state through observation weights instead.

The second shift is organisational. The models are now published once,
as the
[`cfb_model_artifacts`](https://github.com/sportsdataverse/sportsdataverse-data/releases/tag/cfb_model_artifacts)
release on
[`sportsdataverse-data`](https://github.com/sportsdataverse/sportsdataverse-data),
and read by **both `cfbfastR` and `sportsdataverse-py`**. One artifact,
two languages, identical EPA for a given play. Retraining is a publish,
not a release of either library
([\#138](https://github.com/sportsdataverse/cfbfastR/issues/138)).

## What the model predicts

The model does not predict points directly. It predicts **which team
scores next in this half, and how** — a seven-class problem:

| Outcome             | Points |
|---------------------|--------|
| Touchdown           | 7      |
| Field goal          | 3      |
| Safety              | 2      |
| No score            | 0      |
| Opponent safety     | −2     |
| Opponent field goal | −3     |
| Opponent touchdown  | −7     |

Expected points is then the probability-weighted sum:

``` math
\mathrm{EP} = \sum_{i=1}^{7} p_i \cdot v_i
```

where $`p_i`$ is the model’s probability for outcome $`i`$ and $`v_i`$
its point value. A play with a 40% touchdown probability, 30% field
goal, 20% no score and 10% opponent touchdown is worth
$`0.4(7) + 0.3(3) + 0.2(0) + 0.1(-7) = 2.9`$ expected points.

Two details matter for anyone reproducing this:

- **Point values are signed from the offense’s perspective.** An
  opponent touchdown is −7, not 7.
- **The class order in the bundle is not `cfbfastR`’s historical
  order.** The bundle emits
  `TD, Opp_TD, FG, Opp_FG, Safety, Opp_Safety, No_Score`; `cfbfastR`
  reports `No_Score, FG, Opp_FG, Opp_Safety, Opp_TD, Safety, TD`. The
  permutation between them is published in the manifest rather than
  hard-coded, so an upstream reordering cannot silently corrupt EPA.

## Reproducing this yourself

The whole bundle is public and every asset is checksummed. Nothing below
needs an API key.

``` r

library(jsonlite)

base <- paste0(
  "https://github.com/sportsdataverse/sportsdataverse-data/",
  "releases/download/cfb_model_artifacts/"
)

manifest <- jsonlite::fromJSON(paste0(base, "MANIFEST.json"))

manifest$model_version          # "2026.08.27"
manifest$consumers              # "cfbfastR (R)", "sportsdataverse-py (Python)"
manifest$ep_class_contract$class_order
#> "TD" "Opp_TD" "FG" "Opp_FG" "Safety" "Opp_Safety" "No_Score"
manifest$ep_class_contract$point_values
#>  7 -7  3 -3  2 -2  0
```

Every model ships a card recording exactly how it was trained:

``` r

card <- jsonlite::fromJSON(paste0(base, "ep_model.card.json"))
str(card)
```

which currently reports:

| Field               | Value            |
|---------------------|------------------|
| `objective`         | `multi:softprob` |
| `n_features`        | 8                |
| `training_seasons`  | 2004–2025        |
| `n_training_rows`   | 2,219,971        |
| `num_boost_round`   | 525              |
| `max_depth` / `eta` | 5 / 0.025        |
| `xgboost_version`   | 3.2.0            |
| `trained_date`      | 2026-08-02       |

### Scoring a play by hand

To show there is no magic in EP, score one situation directly against
the downloaded booster:

``` r

library(xgboost)

f <- tempfile(fileext = ".ubj")
download.file(paste0(base, "ep_model.ubj"), f, mode = "wb")
ep_model <- xgboost::xgb.load(f)

# 1st and 10 at your own 25, tied, 30 minutes left in the half
x <- matrix(
  c(1800, 75, 10, 1, 0, 0, 0, 0), nrow = 1,
  dimnames = list(NULL, c("TimeSecsRem", "yards_to_goal", "distance",
                          "down_1", "down_2", "down_3", "down_4",
                          "pos_score_diff_start"))
)

p <- predict(ep_model, x)                       # 7 class probabilities
sum(p * c(7, -7, 3, -3, 2, -2, 0))              # bundle class order -> EP
#> [1] 0.6636
```

So a routine 1st and 10 after a touchback is worth about **two thirds of
a point**. Every EPA figure in college football analytics is a
difference of two numbers computed exactly this way.

The point values must be applied in the **bundle’s** order, which is why
the manifest publishes both orders and the permutation between them.

### Getting EPA on real plays

In practice you never do the above — you ask `cfbfastR` for play-by-play
with the models already applied:

``` r

library(cfbfastR)
library(dplyr)

pbp <- cfbfastR::load_cfb_pbp(2025)

pbp |>
  dplyr::filter(!is.na(EPA)) |>
  dplyr::select(game_id, pos_team, down, distance, yards_to_goal,
                play_text, ep_before, ep_after, EPA) |>
  dplyr::slice_head(n = 10)
```

`ep_before` is EP at the snap, `ep_after` is EP for the next play’s
situation, and `EPA` is the difference — signed so that positive is
always good for the offense.

## Field position and expected points

The single most recognisable output of an EP model is the curve of
expected points against field position. Scoring the booster across the
field reproduces it:

``` r

library(ggplot2)

ep_at <- function(ytg, down = 1, dist = 10, secs = 1800, score_diff = 0) {
  X <- cbind(
    TimeSecsRem = secs, yards_to_goal = ytg, distance = pmin(dist, ytg),
    down_1 = as.integer(down == 1), down_2 = as.integer(down == 2),
    down_3 = as.integer(down == 3), down_4 = as.integer(down == 4),
    pos_score_diff_start = score_diff
  )
  pred <- predict(ep_model, X)
  # predict() may hand back an n x 7 matrix or a flat row-major vector depending on
  # the xgboost build, so normalise rather than assume. Re-wrapping an existing matrix
  # with byrow = TRUE reads it column-major and refills row-major, which silently
  # scrambles the seven probabilities across rows.
  p <- if (is.matrix(pred) && ncol(pred) == 7L) pred else matrix(pred, ncol = 7, byrow = TRUE)
  as.vector(p %*% c(7, -7, 3, -3, 2, -2, 0))
}

fp <- data.frame(yards_to_goal = 1:99)
fp$ep <- ep_at(fp$yards_to_goal)

ggplot(fp, aes(x = yards_to_goal, y = ep)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = c(0, 3), linetype = "dashed", alpha = 0.4) +
  scale_x_reverse() +
  labs(
    x = "Yards to opponent's end zone", y = "Expected points",
    title = "Expected points by field position",
    subtitle = "1st & 10, tied, 30:00 left in the half | model_version 2026.08.27",
    caption = "cfbfastR | @cfbfastR"
  ) +
  theme_minimal()
```

Values from that curve, on the current model:

| Situation          | `yards_to_goal` | EP        |
|--------------------|-----------------|-----------|
| Own 1              | 99              | **−1.23** |
| Own 10             | 90              | −0.30     |
| Own 25 (touchback) | 75              | +0.66     |
| Own 40             | 60              | +1.92     |
| Midfield           | 50              | +2.61     |
| Opponent 40        | 40              | +3.33     |
| Opponent 25        | 25              | +4.20     |
| Opponent 10        | 10              | +4.96     |
| Opponent 1         | 1               | +6.03     |

The shape is the intuition behind every EP-based statistic:

- Deep in your own territory EP is **negative** — the opponent is more
  likely to score next than you are. At your own 1 it is −1.23.
- **EP crosses zero at your own 15.** Inside that, possession is a
  liability.
- It passes **+3, the value of a field goal, at the opponent’s 44.**
  This is a genuinely satisfying result: the common definition of a
  “scoring opportunity” as reaching the opponent’s 40 was chosen by eye,
  and the model — which has never been told what a scoring opportunity
  is — puts the break-even four yards away from it.
- A touchback is worth about two thirds of a point.

The bundle also ships `cfb_field_position_ep.parquet`, a 99-row
`yardline_own`/`ep` lookup used elsewhere in the pipeline. Note it is
*not* this curve — its values are positive across the whole field — so
do not substitute one for the other.

### By down

Splitting the same curve by down shows what down is worth in points at
every spot on the field:

``` r

grid <- expand.grid(yards_to_goal = 1:99, down = 1:4)
grid$ep <- mapply(function(y, d) ep_at(y, down = d), grid$yards_to_goal, grid$down)

ggplot(grid, aes(x = yards_to_goal, y = ep, colour = factor(down))) +
  geom_line(linewidth = 1) +
  scale_x_reverse() +
  labs(x = "Yards to opponent's end zone", y = "Expected points",
       colour = "Down",
       title = "Expected points by field position and down",
       subtitle = "distance = 10, tied game, 30:00 left in the half") +
  theme_minimal()
```

Note the `byrow = TRUE` inside `ep_at()`. `multi:softprob` returns a
flat row-major vector in some XGBoost versions and an n × 7 matrix in
others; reshaping column-major silently interleaves plays with each
other’s probabilities. `cfbfastR` guards against this internally, and it
is the single easiest way to get plausible-looking nonsense when scoring
the model yourself.

The vertical gaps between the lines are the interesting part — this is
what a down is *worth*, in points:

| Spot        | 1st   | 2nd   | 3rd   | 4th   |
|-------------|-------|-------|-------|-------|
| Own 25      | +0.66 | −0.02 | −0.93 | −2.30 |
| Own 40      | +1.92 | +1.27 | +0.31 | −1.25 |
| Midfield    | +2.61 | +1.95 | +0.85 | −0.88 |
| Opponent 40 | +3.33 | +2.69 | +1.67 | −0.31 |
| Opponent 25 | +4.20 | +3.65 | +2.90 | +1.50 |
| Opponent 10 | +4.96 | +4.39 | +3.59 | +2.58 |

Averaged across the middle 60 yards of the field:

- **1st → 2nd down: 0.65 points.** A steady, modest gap.
- **2nd → 3rd down: 0.93 points**, about 1.4× the first gap.
- **3rd → 4th down: 1.59 points**, by far the largest — 4th down is
  where the possession itself is at stake.

Two things in that table are worth dwelling on. First, **a 4th and 10 is
negative EP everywhere outside the opponent’s 35** — at midfield it is
−0.88, meaning the opponent is the favourite to score next. That is the
whole reason punting exists, and the whole reason the fourth-down
decision is interesting.

Second, the 3rd → 4th gap is not constant: it peaks at **1.98 points at
the opponent’s 40** and falls steadily to **1.24 at the opponent’s 15**.
Inside field-goal range a 4th down still has value, because three points
are reachable without converting; at the 40 it does not. The model was
never told that field goals exist as a separate option in this feature
set — it recovered the shape of field-goal range from eight columns and
two million plays. That is the clearest single argument for why the
gradient-boosted version needs no hand-specified `yards_to_goal × down`
interaction term.

## Seeing it applied

[Game on Paper](https://gameonpaper.com) runs these models over every
FBS game and renders the results: EPA per play, success rate and win
probability for any game, with a full play-by-play showing `ep_before`,
`ep_after` and EPA for each snap. Its [advanced stats
glossary](https://gameonpaper.com/glossary) defines the derived metrics
in the same terms used here, and the season leaderboards rank every team
by [offensive](https://gameonpaper.com/year/2025/teams/offensive) and
[defensive](https://gameonpaper.com/year/2025/teams/defensive) EPA per
play.

It is the fastest way to check your intuition about a number this
article describes in the abstract.

## Data and artifacts

Everything referenced here is public:

- **Models** —
  [`cfb_model_artifacts`](https://github.com/sportsdataverse/sportsdataverse-data/releases/tag/cfb_model_artifacts)
  on `sportsdataverse-data`: nine boosters, a punt distribution, a
  field-position EP table, per-model cards and a checksummed
  `MANIFEST.json`.
- **Season play-by-play** —
  [`cfbfastR-data`](https://github.com/sportsdataverse/cfbfastR-data),
  which
  [`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md)
  reads.
- **Package source** —
  [`cfbfastR`](https://github.com/sportsdataverse/cfbfastR) and its
  Python twin
  [`sportsdataverse-py`](https://github.com/sportsdataverse/sportsdataverse-py).
- **Raw API data** —
  [CollegeFootballData.com](https://collegefootballdata.com), courtesy
  of [@CFB_data](https://x.com/CFB_data).

## Next

[Part
II](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-ii.md)
works through *why* this is a multiclass classifier and how the model
got from linear regression to gradient boosting — including the
regressions that do not work, and why they fail.

## Citation

    Gilani, S., Easwaran, A., Lee, J., and Hess, E. (2026). cfbfastR: Access College
    Football Play by Play Data. R package version 3.0.0.9000.
    https://cfbfastr.sportsdataverse.org

Authors, contributors and related SportsDataverse packages are listed on
the [package home page](https://cfbfastR.sportsdataverse.org/index.md).
