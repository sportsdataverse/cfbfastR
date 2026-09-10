# **Score a data frame with the shipped CFB models**

Hand a data frame to any of these and get model output back, whether the
rows came from a play-by-play frame or were typed by hand to ask a
hypothetical. Only the model card's declared columns are required; extra
columns pass through untouched, and every input column is preserved so
chaining two calculators is lossless.

Play-by-play column names are normalized automatically – a frame
carrying `start.TimeSecsRem` and `start.yardsToEndzone` is accepted
as-is.

- `calculate_expected_points()`: expected points, plus the seven
  next-score class probabilities.

- `calculate_win_probability()`: win probability (`wp_spread` when a
  spread is present, else `wp_naive`).

- `calculate_epa()` / `calculate_wpa()`: the change in EP / WP across a
  play.

- `calculate_field_goal_probability()`: field-goal make probability.

- `calculate_completion_probability()`: completion probability.

- `calculate_xpass()`: expected pass probability.

- `calculate_two_point_probability()`: two-point conversion probability.

- `calculate_fourth_down()`: fourth-down model output.

- `calculate_qbr()`: model QBR.

These wrap
[`create_epa()`](https://cfbfastR.sportsdataverse.org/reference/create_epa.md)
and
[`create_wpa_naive()`](https://cfbfastR.sportsdataverse.org/reference/create_wpa.md),
which remain available for callers that already hold booster objects.

## Usage

``` r
calculate_xpass(df, season = NULL)

calculate_field_goal_probability(df, season = NULL)

calculate_completion_probability(df, season = NULL)

calculate_two_point_probability(df, season = NULL)

calculate_fourth_down(df, season = NULL)

calculate_qbr(df, season = NULL)

calculate_expected_points(df, season = NULL)

calculate_win_probability(df, season = NULL)

calculate_epa(df, season = NULL)

calculate_wpa(df, season = NULL)
```

## Arguments

- df:

  (*data.frame* required): Rows to score. Requires the columns the
  model's published card declares; see the per-function entries.

- season:

  (*Integer* optional): Season used to derive era columns when `df`
  carries no `season` column. The frame's own `season` always wins.

## Value

A data frame: `df` with the model's output column(s) appended.

`calculate_xpass()` - `df` with one column appended:

|          |         |                                       |
|----------|---------|---------------------------------------|
| col_name | types   | description                           |
| xpass    | numeric | Probability the play is a pass (0-1). |

`calculate_field_goal_probability()` - `df` with one column appended:

|              |         |                                           |
|--------------|---------|-------------------------------------------|
| col_name     | types   | description                               |
| fg_make_prob | numeric | Probability the field goal is made (0-1). |

Named `fg_make_prob`, not `fg_prob`: `calculate_expected_points()` emits
`FG` for the probability the NEXT SCORE is a field goal, a different
quantity, and the Python sibling uses `fg_prob` for that class. Keeping
the names distinct makes chaining the two lossless in both languages.

`calculate_completion_probability()` - `df` with one column appended:

|          |         |                               |
|----------|---------|-------------------------------|
| col_name | types   | description                   |
| cp       | numeric | Completion probability (0-1). |

`calculate_two_point_probability()` - `df` with one column appended:

|             |         |                                         |
|-------------|---------|-----------------------------------------|
| col_name    | types   | description                             |
| two_pt_prob | numeric | Two-point conversion probability (0-1). |

`calculate_fourth_down()` - `df` with two columns appended:

|                    |         |                                                |
|--------------------|---------|------------------------------------------------|
| col_name           | types   | description                                    |
| fd_conversion_prob | numeric | Probability the gain reaches `distance` (0-1). |
| fd_expected_yards  | numeric | Expected yards gained on the play.             |

`fd_model` is a 76-class yards-gained distribution (class *k* is a gain
of *k* - 10 yards), not a probability, so these are derived from it
rather than returned raw – an array column could not be written to CSV
and is not a usable public surface.

`calculate_qbr()` - `df` with one column appended:

|          |         |             |
|----------|---------|-------------|
| col_name | types   | description |
| qbr      | numeric | Model QBR.  |

`calculate_expected_points()` - `df` with eight columns appended:

|  |  |  |
|----|----|----|
| col_name | types | description |
| No_Score | numeric | Probability the next score is none. |
| FG | numeric | Probability the next score is a field goal. |
| Opp_FG | numeric | Probability the next score is an opponent field goal. |
| Opp_Safety | numeric | Probability the next score is an opponent safety. |
| Opp_TD | numeric | Probability the next score is an opponent touchdown. |
| Safety | numeric | Probability the next score is a safety. |
| TD | numeric | Probability the next score is a touchdown. |
| ep | numeric | Expected points: the class probabilities weighted by their point values. |

Class order follows `.EP_LEV`, which is **not** the ordering
`sportsdataverse-py` uses. Scoring goes through `.ep_predict()`, which
applies the bundle's own class permutation – reimplementing the reshape
here would produce every column present and every value mis-assigned.

`calculate_win_probability()` - `df` with one column appended:

|          |         |                                                |
|----------|---------|------------------------------------------------|
| col_name | types   | description                                    |
| wp       | numeric | Win probability for the possessing team (0-1). |

Uses `wp_spread` when the frame carries a `spread_time` column and
`wp_naive` otherwise – the naive model is the spread model minus that
single feature, so the presence of spread information is what decides
which contract applies.

`calculate_epa()` - `df` with `ep` (when it was absent) and `epa`
appended.

|          |         |                                             |
|----------|---------|---------------------------------------------|
| col_name | types   | description                                 |
| epa      | numeric | Expected points added: `ep_end` minus `ep`. |

Requires an `ep_end` column – the expected points after the play. EPA is
a difference and this scores rows rather than sequences, so inventing
`ep_end` would produce a number that looks like EPA and is not.

`calculate_wpa()` - `df` with `wp` (when it was absent) and `wpa`
appended.

|          |         |                                             |
|----------|---------|---------------------------------------------|
| col_name | types   | description                                 |
| wpa      | numeric | Win probability added: `wp_end` minus `wp`. |

Requires a `wp_end` column, for the same reason `calculate_epa()`
requires `ep_end`.

## See also

Other CFB Model Calculators:
[`cfb_model_card()`](https://cfbfastR.sportsdataverse.org/reference/cfb_model_card.md)

## Examples

``` r
# \donttest{
  try(calculate_xpass(data.frame(season = 2024, down = 3, distance = 8,
    yards_to_goal = 55, pos_score_diff = -4, TimeSecsRem = 900, period = 3)))
#>   season down distance yards_to_goal pos_score_diff TimeSecsRem period era
#> 1   2024    3        8            55             -4         900      3   3
#>       xpass
#> 1 0.8236039
# }
# \donttest{
  try(calculate_field_goal_probability(data.frame(season = 2024, yards_to_goal = 25)))
#>   season yards_to_goal era0 era1 era2 era3 fg_make_prob
#> 1   2024            25    0    0    0    1    0.6751403
# }
# \donttest{
  try(calculate_completion_probability(data.frame(season = 2024, down = 3,
    distance = 8, yards_to_goal = 55, score_diff = -4,
    seconds_remaining = 900, is_home = 1, period = 3, passing_down = 1)))
#>   season down distance yards_to_goal score_diff seconds_remaining is_home
#> 1   2024    3        8            55         -4               900       1
#>   period passing_down        cp
#> 1      3            1 0.4777572
# }
# \donttest{
  try(calculate_two_point_probability(data.frame(season = 2024,
    posteam_spread = -3, posteam_total = 28, pos_score_diff = -2)))
#>   season posteam_spread posteam_total pos_score_diff era two_pt_prob
#> 1   2024             -3            28             -2   3   0.5070384
# }
# \donttest{
  try(calculate_fourth_down(data.frame(season = 2024, down = 4, distance = 2,
    yards_to_goal = 45, posteam_total = 52, posteam_spread = -3)))
#>   season down distance yards_to_goal posteam_total posteam_spread era0 era1
#> 1   2024    4        2            45            52             -3    0    0
#>   era2 era3 fd_expected_yards fd_conversion_prob
#> 1    0    1           8.22391          0.6602082
# }
# \donttest{
  try(calculate_qbr(data.frame(season = 2024, qbr_epa = 0.1, sack_epa = -0.2,
    pass_epa = 0.3, rush_epa = 0.05, pen_epa = 0, spread = -3)))
#>   season qbr_epa sack_epa pass_epa rush_epa pen_epa spread era0 era1 era2 era3
#> 1   2024     0.1     -0.2      0.3     0.05       0     -3    0    0    0    1
#>        qbr
#> 1 64.32548
# }
# \donttest{
  try(calculate_expected_points(data.frame(TimeSecsRem = 1800,
    yards_to_goal = 75, distance = 10, down_1 = 1, down_2 = 0, down_3 = 0,
    down_4 = 0, pos_score_diff_start = 0)))
#>   TimeSecsRem yards_to_goal distance down_1 down_2 down_3 down_4
#> 1        1800            75       10      1      0      0      0
#>   pos_score_diff_start down    No_Score        FG    Opp_FG  Opp_Safety
#> 1                    0    1 0.004676826 0.1563549 0.1184921 0.002391808
#>      Opp_TD      Safety        TD        ep
#> 1 0.3181985 0.003416252 0.3964695 0.6635342
# }
# \donttest{
  try(calculate_win_probability(cfbd_pbp_data(2024, week = 5)))
#> Error in .cfb_predict_from_card(prepared, model, booster) : 
#>   wp_naive needs 8 columns not present in the data.
#> ✖ Missing: "pos_team_receives_2H_kickoff", "TimeSecsRem", "adj_TimeSecsRem",
#>   "ExpScoreDiff_Time_Ratio", "pos_score_diff_start", "is_home",
#>   "pos_team_timeouts_rem_before", and "def_pos_team_timeouts_rem_before"
#> ℹ Its card declares: "pos_team_receives_2H_kickoff", "TimeSecsRem",
#>   "adj_TimeSecsRem", "ExpScoreDiff_Time_Ratio", "pos_score_diff_start", "down",
#>   "distance", "yards_to_goal", "is_home", "pos_team_timeouts_rem_before",
#>   "def_pos_team_timeouts_rem_before", and "period"
# }
# \donttest{
  try(calculate_epa(data.frame(ep = 2, ep_end = 5)))
#>   ep ep_end epa
#> 1  2      5   3
# }
# \donttest{
  try(calculate_wpa(data.frame(wp = 0.4, wp_end = 0.6)))
#>    wp wp_end wpa
#> 1 0.4    0.6 0.2
# }
```
