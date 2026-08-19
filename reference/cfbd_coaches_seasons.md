# **Get coaching seasons**

**Get coaching seasons** Season-by-season coaching records.

## Usage

``` r
cfbd_coaches_seasons(
  coach_id = NULL,
  team = NULL,
  year = NULL,
  min_year = NULL,
  max_year = NULL,
  proxy = NULL
)
```

## Arguments

- coach_id:

  (*Integer* optional): Coach identifier.

- team:

  (*String* optional): Team filter.

- year:

  (*Integer* optional): Season, 4 digits (YYYY).  
  Minimum value accepted: 1886

- min_year:

  (*Integer* optional): Earliest season to include.

- max_year:

  (*Integer* optional): Latest season to include.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_coaches_seasons()` - A tibble with 68 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| year | integer | Four-digit season year. |
| games | integer | Games played. |
| wins | integer | Wins. |
| losses | integer | Losses. |
| ties | integer | Ties. |
| win_percentage | numeric | Win percentage. |
| preseason_rank | integer | Preseason rank. |
| postseason_rank | integer | Postseason rank. |
| srs | numeric | Srs. |
| sp_overall | numeric | Sp overall. |
| sp_offense | numeric | Sp offense. |
| sp_defense | numeric | Sp defense. |
| attribution_complete | logical | Attribution complete. |
| coach_id | integer | Coach identifier. |
| coach_first_name | character | Coach first name. |
| coach_last_name | character | Coach last name. |
| team_id | integer | Referencing team id. |
| team_school | character | School name of the team. |
| team_conference | character | Conference the team belongs to. |
| team_metrics_sp_special_teams | numeric | Team metrics sp special teams. |
| team_metrics_strength_of_schedule | numeric | Team metrics strength of schedule. |
| team_metrics_second_order_wins | numeric | Team metrics second order wins. |
| team_metrics_fpi | numeric | Team metrics fpi. |
| team_metrics_year_over_year_wins | integer | Team metrics year over year wins. |
| team_metrics_year_over_year_srs | numeric | Team metrics year over year srs. |
| team_metrics_year_over_year_sp_overall | numeric | Team metrics year over year sp overall. |
| recruiting_rank | integer | Recruiting rank. |
| recruiting_points | numeric | Recruiting points scored. |
| recruiting_talent | numeric | Recruiting talent. |
| poll_resume_preseason_rank | integer | Poll resume preseason rank. |
| poll_resume_postseason_rank | integer | Poll resume postseason rank. |
| poll_resume_best_rank | integer | Poll resume best rank. |
| poll_resume_weeks_ranked | integer | Poll resume weeks ranked. |
| poll_resume_weeks_top_ten | integer | Poll resume weeks top ten. |
| record_splits_conference_games | integer | Record splits conference games. |
| record_splits_conference_wins | integer | Record splits conference wins. |
| record_splits_conference_losses | integer | Record splits conference losses. |
| record_splits_conference_ties | integer | Record splits conference ties. |
| record_splits_conference_win_percentage | numeric | Record splits conference win percentage. |
| record_splits_postseason_games | integer | Record splits postseason games. |
| record_splits_postseason_wins | integer | Record splits postseason wins. |
| record_splits_postseason_losses | integer | Record splits postseason losses. |
| record_splits_postseason_ties | integer | Record splits postseason ties. |
| record_splits_postseason_win_percentage | numeric | Record splits postseason win percentage. |
| record_splits_home_games | integer | Record splits home games. |
| record_splits_home_wins | integer | Record splits home wins. |
| record_splits_home_losses | integer | Record splits home losses. |
| record_splits_home_ties | integer | Record splits home ties. |
| record_splits_home_win_percentage | numeric | Record splits home win percentage. |
| record_splits_away_games | integer | Record splits away games. |
| record_splits_away_wins | integer | Record splits away wins. |
| record_splits_away_losses | integer | Record splits away losses. |
| record_splits_away_ties | integer | Record splits away ties. |
| record_splits_away_win_percentage | numeric | Record splits away win percentage. |
| record_splits_neutral_games | integer | Record splits neutral games. |
| record_splits_neutral_wins | integer | Record splits neutral wins. |
| record_splits_neutral_losses | integer | Record splits neutral losses. |
| record_splits_neutral_ties | integer | Record splits neutral ties. |
| record_splits_neutral_win_percentage | numeric | Record splits neutral win percentage. |
| scoring_points_for | integer | Scoring points for. |
| scoring_points_against | integer | Scoring points against. |
| scoring_average_point_differential | numeric | Scoring average point differential. |
| cfp_appeared | logical | Cfp appeared. |
| cfp_seed | integer | Cfp seed. |
| cfp_outcome | character | Cfp outcome. |
| draft_following_season_year | integer | Draft following season year. |
| draft_following_season_total_picks | integer | Draft following season total picks. |
| draft_following_season_first_round_picks | integer | Draft following season first round picks. |

## See also

Other CFBD Coaches Functions:
[`cfbd_coaches()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.md),
[`cfbd_coaches_profile()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_profile.md),
[`cfbd_coaches_tenures()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_tenures.md)

## Examples

``` r
# \donttest{
  try(cfbd_coaches_seasons(team = "Georgia"))
#> ── Get coaching seasons from CollegeFootballData.com ───────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 17:52:06 UTC
#> # A tibble: 123 × 68
#>     year games  wins losses  ties win_percentage preseason_rank postseason_rank
#>    <int> <int> <int>  <int> <int>          <dbl>          <int>           <int>
#>  1  1902     7     4      2     1          0.643             NA              NA
#>  2  1903     7     3      4     0          0.429             NA              NA
#>  3  1904     6     1      5     0          0.167             NA              NA
#>  4  1905     6     1      5     0          0.167             NA              NA
#>  5  1906     7     2      4     1          0.357             NA              NA
#>  6  1907     8     4      3     1          0.563             NA              NA
#>  7  1908     8     5      2     1          0.688             NA              NA
#>  8  1909     7     1      4     2          0.286             NA              NA
#>  9  1910     9     6      2     1          0.722             NA              NA
#> 10  1911     9     7      1     1          0.833             NA              NA
#> # ℹ 113 more rows
#> # ℹ 60 more variables: srs <dbl>, sp_overall <dbl>, sp_offense <dbl>,
#> #   sp_defense <dbl>, attribution_complete <lgl>, coach_id <int>,
#> #   coach_first_name <chr>, coach_last_name <chr>, team_id <int>,
#> #   team_school <chr>, team_conference <chr>,
#> #   team_metrics_sp_special_teams <dbl>,
#> #   team_metrics_strength_of_schedule <dbl>, …
# }
```
