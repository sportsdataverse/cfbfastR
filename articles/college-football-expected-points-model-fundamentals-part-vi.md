# CPOE, xpass, Field Goals and Fourth Downs: The Derived Models (Part VI)

[Expected
points](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-i.md)
and [win
probability](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-v.md)
are the foundation. Everything in this article is built on top of them,
and all of it ships in the same
[`cfb_model_artifacts`](https://github.com/sportsdataverse/sportsdataverse-data/releases/tag/cfb_model_artifacts)
bundle.

There is a useful distinction to draw first. Some of these are
**models** — they predict a thing and you read the number. Others are
**analytic surfaces**: they build the game state that *would* follow a
choice, score it with the WP model, and compare. Fourth down and the
two-point decision are surfaces, and they are ports of
[`cfb4th`](https://github.com/sportsdataverse/cfb4th).

## The bundle at a glance

| Artifact | Objective | Features | Produces |
|----|----|----|----|
| `ep_model` | `multi:softprob` (7) | 8 | `ep_before`, `ep_after`, `EPA` |
| `wp_naive` | `binary:logistic` | 12 | `wp_before`, `wpa` |
| `wp_spread` | `binary:logistic` | 13 | `vegas_wp` |
| `cfb_cp_model` | `binary:logistic` | 8 | `cp`, `cpoe` |
| `xpass_model` | `binary:logistic` | 7 | `xpass`, `pass_oe` |
| `fg_model` | `binary:logistic` | 5 | field-goal probability |
| `two_pt_model` | `binary:logistic` | 4 | `prob_2pt` |
| `fd_model` | `multi:softprob` (**76**) | 9 | fourth-down gain distribution |
| `qbr_model` | `reg:squarederror` | 10 | QBR |

Plus `punt_distribution.parquet`, which is not a model at all — see
below.

## Completion probability and CPOE

`cp` is the probability a given pass attempt is completed, from down,
distance, field position, score, clock, home field, period and a
passing-down indicator. **CPOE** is the difference between what happened
and what was expected, on a percentage-point scale:

``` math
\mathrm{CPOE} = 100 \times (\text{completion} - \mathrm{cp})
```

| Situation            | `cp`  |
|----------------------|-------|
| 1st & 10, own 25     | 0.639 |
| 3rd & 3, opponent 40 | 0.595 |
| 2nd & 20, own 20     | 0.627 |
| 3rd & 12, own 30     | 0.489 |

CPOE is the standard way to separate a quarterback’s accuracy from his
situation. A 65% completion rate throwing 3rd-and-12s is a much better
performance than 65% throwing 1st-and-10s, and CPOE is what says so.

Note that the model has **no receiver, pressure, or air-yards input** —
it is a situational baseline, not a throw-difficulty model. A
quarterback checking down constantly will post good CPOE.

## Expected pass rate (`xpass` and `pass_oe`)

`xpass` is the probability a play *is* a pass, given the situation — a
model of tendency, not of quality. `pass_oe` (pass rate over expected)
is `100 * (pass - xpass)`, and measures how much more pass-happy a team
is than its situations warrant.

| Situation              | `xpass` |
|------------------------|---------|
| 1st & goal, opponent 3 | 0.141   |
| 2nd & 2, own 33        | 0.247   |
| 3rd & 2, opponent 40   | 0.255   |
| 1st & 10, own 25       | 0.373   |
| 2nd & 8, own 27        | 0.536   |
| 3rd & 8, opponent 40   | 0.782   |

The spread is the point: 14% on 1st and goal from the 3, 78% on 3rd and
8. Any raw pass-rate statistic is mostly measuring which of these
situations a team found itself in. `pass_oe` removes that.

### An era-encoding trap

The `xpass` model uses an **ordinal** `era` feature cutting at **2006 /
2013 / 2017**. The FG, two-point and QBR models use **one-hot**
`era0`–`era3` cutting at **2006 / 2013 / 2020**.

Different encodings *and* different cutpoints, in the same bundle. If
you score these models by hand, build each one’s era feature from its
own rule — reusing one for the other is silent and wrong. `cfbfastR`
handles this internally; it is listed here because it is exactly the
kind of thing that survives a code review and fails in production.

## The field goal model

Five features: `yards_to_goal` and the one-hot era. Kick distance is
`yards_to_goal + 17`.

| `yards_to_goal` | Kick | P(make) |
|-----------------|------|---------|
| 2               | 19   | 0.956   |
| 10              | 27   | 0.893   |
| 17              | 34   | 0.809   |
| 20              | 37   | 0.754   |
| 25              | 42   | 0.675   |
| 30              | 47   | 0.614   |
| 33              | 50   | 0.542   |
| 38              | 55   | 0.455   |
| 43              | 60   | 0.366   |
| 48              | 65   | 0.366   |

A 50-yarder is a coin flip, which is a useful number to carry around.

**Era matters, and it is not a rounding effect.** Kicking has genuinely
improved, and the model captures it — the same 42-yard attempt across
the four eras:

| Era                | P(make), 42 yards |
|--------------------|-------------------|
| `era0` (pre-2006)  | 0.556             |
| `era1` (2006–2012) | 0.598             |
| `era2` (2013–2019) | 0.612             |
| `era3` (2020+)     | 0.675             |

Twelve percentage points from the oldest era to the current one. The era
features carry about 20% of the model’s gain between them, so scoring a
historical kick with `era3` — or a modern one with `era0` — is a real
error, not a nicety.

**The tail runs out at 57 yards.** From `yards_to_goal` 40 outward the
model returns a constant **0.3656** — a 57-yard and a 70-yard attempt
get identical probabilities. Nobody attempts many 65-yarders except in
desperation, so there is nothing to learn from and the model
extrapolates flat. Treat anything past a 57-yard kick as “the model has
run out of evidence” rather than an estimate.

**Two small monotonicity violations.** Across 58 steps the curve rises
twice where it should fall: a 49-yard kick is rated 0.5882 against
0.5647 for a 48-yarder, and 51 yards beats 50. Both are sub-3-point
artifacts of tree splitting rather than anything meaningful, but if you
are differencing adjacent yard lines — as the fourth-down surface does
when it weighs a make against a miss — be aware the curve is not
strictly monotone.

The model also has **no kicker identity, weather or altitude input**. A
kick in Laramie and a kick in a dome get the same number.

## The two-point model, and an honest caveat

Four features: `posteam_spread`, `posteam_total`, `pos_score_diff`,
`era`. It produces `prob_2pt`, which feeds the two-point decision
surface — `two_pt_wp`, `xp_wp`, `two_pt_wp_diff` and
`two_pt_recommendation`.

This model does not work, and it is worth showing exactly how rather
than gesturing at a caveat.

Sweeping each feature with the others held at realistic values:

| Feature          | Values swept | `prob_2pt`                |
|------------------|--------------|---------------------------|
| `pos_score_diff` | −14 → +14    | 0.487 … **0.578** … 0.557 |
| `posteam_spread` | −28 → +28    | 0.572 … 0.592             |
| `posteam_total`  | 35 → 75      | **0.578 at every value**  |
| `era`            | 0 → 3        | **0.578 at every value**  |

The whole model moves between **0.487 and 0.592**. It is very nearly a
constant.

Three specific problems, from the tree dump:

1.  **`era` is never split on.** It appears in the feature list and in
    no tree. Two-point conversion rates have moved over twenty years;
    this model cannot express that.
2.  **The `posteam_total` splits are at 21.375 and 31.875.** College
    football game totals live between about 45 and 65. Every realistic
    game takes the same branch, which is why sweeping the total from 35
    to 75 changes nothing. Those thresholds suggest the training feature
    was not the game total on the scale it is scored with — a scaling or
    fill problem upstream, not a modelling choice.
3.  **The first split is `pos_score_diff < -6`.** Almost every genuine
    two-point decision happens within a touchdown either way, so in the
    region that matters the model is flat by construction.

And the level is wrong: it centres on **0.578** where real college
two-point conversion rates run closer to 45%. Note its own `base_score`
is 0.4816 — the trees push the prediction *above* the base rate for
every realistic input.

**Practical consequence.** `prob_2pt` feeds `two_pt_wp`, so an
optimistic and nearly-constant conversion probability biases the
decision surface toward going for two, everywhere, regardless of
situation. `cfb4th`’s rule has no margin — it will recommend two on a
difference of 0.0001 — so **read `two_pt_wp_diff` and treat anything
under a couple of percentage points as a coin flip**, or supply your own
conversion probability.

To be clear about where the fault lies: the surface’s arithmetic is
sound and was verified **bit-identical to `sportsdataverse-py` to eight
decimal places**. The problem is entirely the input model. It is a
retrain candidate, and until then the recommendation column should not
be used on its own.

## The fourth-down decision

This is the most elaborate surface in the package, and the 76-class
model is the interesting part.

`fd_model` is a `multi:softprob` classifier over **76 classes: yards
gained, from −10 to +65**. It does not predict whether a fourth down is
converted. It predicts the *whole distribution* of what happens if you
go for it.

The go branch then:

1.  Scores the 76-class distribution for the fourth-down state.
2.  Expands the play into **one hypothetical game state per outcome** —
    every yardage result gets its own down, distance and field position.
3.  Scores each with the win probability model.
4.  Averages, weighted by the distribution.

That average is `go_wp` — the win probability of going for it,
integrated over everything that could happen.

The punt branch is different again. **`cfb4th` does not model punts.**
It joins an empirical distribution of punt end-yardlines from
`punt_distribution.parquet`, expands to one state per landing spot,
scores each, and averages. The field-goal branch uses the FG model
above, weighting a make against a miss and the field position each
produces.

The outputs:

| Column | Meaning |
|----|----|
| `go_wp`, `fg_wp`, `punt_wp` | win probability of each choice |
| `go_wp_diff`, `fg_wp_diff`, `punt_wp_diff` | each against the best alternative |
| `go_boost` | how much going for it gains over the best kicking option |
| `first_down_prob` | conversion probability from the distribution |
| `wp_succeed`, `wp_fail` | WP after converting / failing |
| `fourth_down_recommendation` | the call |

``` r

library(cfbfastR)
library(dplyr)

pbp <- cfbfastR::load_cfb_pbp(2025)

pbp |>
  dplyr::filter(down == 4, !is.na(go_boost)) |>
  dplyr::select(pos_team, distance, yards_to_goal, go_wp, fg_wp, punt_wp,
                go_boost, first_down_prob, fourth_down_recommendation) |>
  dplyr::arrange(dplyr::desc(go_boost)) |>
  dplyr::slice_head(n = 20)
```

Sorting by `go_boost` finds the fourth downs where going for it was most
clearly right — and, sorted the other way, the punts that cost the most.

As with the two-point surface, **`go_boost` is more useful than the
recommendation**: a 0.001 edge and a 0.08 edge are different decisions,
and only the magnitude distinguishes them.

## QBR

A regression (`reg:squarederror`) on ten features, all of which are
already EPA components: `qbr_epa`, `sack_epa`, `pass_epa`, `rush_epa`,
`pen_epa`, plus `spread` and the one-hot era.

This is worth being clear about, because QBR is often described as a
black box. Here it is not a new measurement of anything — it is **a
re-scaling of EPA components onto the 0–100 scale people recognise**,
fit to reproduce the published QBR values. Everything it knows, it knows
from EPA. If you want to understand why a quarterback’s QBR is what it
is, look at his EPA splits; there is nothing else in there.

## Everything degrades to `NA`

A design decision worth knowing about: none of these surfaces fail the
pipeline. If a model artifact cannot be fetched, or `arrow` is missing,
or the punt table is unavailable, or the game has no pre-game line, the
columns are added as `NA` rather than the stage erroring.

This means **you must check for `NA` rather than assuming a column is
populated** — particularly `vegas_wp` and the two decision surfaces,
which need a spread. The upside is that a network problem degrades your
play-by-play instead of destroying it.

``` r

pbp |>
  dplyr::summarise(dplyr::across(
    c(EPA, wpa, vegas_wp, cpoe, xpass, go_boost),
    ~ mean(is.na(.x))
  ))
```

## Seeing it applied

[Game on Paper](https://gameonpaper.com) surfaces most of this per game:
the win probability chart, per-play EPA, and fourth-down decision
context. Its [glossary](https://gameonpaper.com/glossary) defines the
derived metrics in the same terms used here.

## Frequently asked

**What is CPOE in college football?** Completion percentage over
expected — the gap between a passer’s actual completions and what the
situation predicted, in percentage points. It separates accuracy from
difficulty of situation.

**What is pass rate over expected (`pass_oe`)?** How much more often a
team passes than its down, distance, score and clock suggest. It
measures aggression, not effectiveness.

**How accurate is the college field goal model?** In the modern era
(`era3`, 2020+) it gives about 81% at 34 yards and 54% at 50. Older eras
are materially lower — 42 yards is 0.68 in `era3` against 0.56 in
`era0`. It has no kicker, weather or altitude input, and flattens beyond
roughly 57 yards where data runs out.

**Should I trust `two_pt_recommendation`?** No, not on its own. The
underlying `prob_2pt` model is nearly constant at about 0.578, against
real college rates closer to 45%, so the surface is biased toward going
for two. Read `two_pt_wp_diff` and treat small margins as coin flips.

**Should I trust `fourth_down_recommendation`?** Use `go_boost` instead.
The recommendation has no margin, so it treats a 0.0001 edge as a
decision.

## The series

1.  [Expected points: how the model
    works](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-i.md)
2.  [How the model is
    built](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-ii.md)
3.  [A history of expected points
    models](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-iii.md)
4.  [What is
    EPA?](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-iv.md)
5.  [Win probability, WPA and
    `vegas_wp`](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-v.md)
6.  CPOE, xpass, field goals and fourth downs — this article

## Data and artifacts

- **Models** —
  [`cfb_model_artifacts`](https://github.com/sportsdataverse/sportsdataverse-data/releases/tag/cfb_model_artifacts)
- **Season play-by-play** —
  [`cfbfastR-data`](https://github.com/sportsdataverse/cfbfastR-data)
- **Source** — [`cfbfastR`](https://github.com/sportsdataverse/cfbfastR)
  ·
  [`sportsdataverse-py`](https://github.com/sportsdataverse/sportsdataverse-py)
  · [`cfb4th`](https://github.com/sportsdataverse/cfb4th)
- **Applied, live** — [Game on Paper](https://gameonpaper.com)
- **Raw API** —
  [CollegeFootballData.com](https://collegefootballdata.com), courtesy
  of [@CFB_data](https://x.com/CFB_data)

## Citation

    Gilani, S., Easwaran, A., Lee, J., and Hess, E. (2026). cfbfastR: Access College
    Football Play by Play Data. R package version 3.0.0.9000.
    https://cfbfastr.sportsdataverse.org

Authors, contributors and related SportsDataverse packages are listed on
the [package home page](https://cfbfastR.sportsdataverse.org/index.md).
