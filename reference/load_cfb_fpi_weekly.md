# **Load college football weekly ESPN FPI ratings from the SportsDataverse data repo**

Loads weekly ESPN FPI snapshots – one row per team-week with FPI and its
components as published that week. Published to the `cfb_fpi_weekly`
release tag on the sportsdataverse-data repo.

## Usage

``` r
load_cfb_fpi_weekly(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2005 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2005)

- ...:

  Additional arguments passed to an underlying function that writes the
  season data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble.

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer |  |
| season_type | integer |  |
| week | integer |  |
| team_id | integer |  |
| last_updated | character |  |
| run_date_time_key | integer | ESPN's run key for the snapshot, as an integer timestamp (e.g. 20241021040000). This is the AS-OF date the snapshot represents, which is not the same as last_updated (when ESPN computed it); the gap between the two is what snapshot_is_contemporaneous flags. |
| snapshot_out_of_sequence | logical | True when this snapshot was computed AFTER one belonging to a later week of the same season type – so it cannot be read as an as-of-that-week rating. Almost always the week-1 slot, which ESPN overwrites with a late-season computation (2024 week 1 is stamped 2024-12-15). Filter these out for any point-in-time or backtest use. |
| fpi | double | Football Power Index that measures team's true strength on net points scale; expected point margin vs average opponent on neutral field. |
| fpirank | double | ESPN's FPI rank field. Agrees with rank on 99.4% of rows; on the ~0.6% where they differ it is stale – it never matches the rank implied by the published fpi, while rank always does. Prefer rank. |
| projectedw | double | Projected overall W-L, accounting for results to date and FPI-based projections for remaining scheduled games (and potential conference championship games). May not sum to a whole number because of differing number of games played in each simulation. |
| projectedl | double | Projected overall Losses, accounting for results to date and FPI-based projections for remaining scheduled games (including potential conference championship games). May not sum to a whole number because of differing number of games played in each simulation. |
| projectedt | character | Projected ties. Always null – college football abolished ties in 1996, and ESPN emits the key beside projectedw/projectedl without ever populating it. Retained so the column set matches the upstream payload. |
| projectedwpctrank | double | Rank among FBS teams by projected win percentage. ESPN publishes the rank without the underlying percentage; derive it from projectedw and projectedl. |
| probwinout | double | Percent of season simulations in which team won all remaining scheduled games as well as conference championship game (if applicable). |
| probwinconf | double | Percent of season simulations in which team won its conference, incorporating chance of getting to and winning conference championship game (if applicable). Accounts for shared conference titles in conferences that allow them. |
| sosremainingrank | double | Rank among all FBS teams of remaining schedule strength, from perspective of an average FBS team. |
| accomplishment | double | Reflects chance that an average Top 25 team would have team's record or better, given the schedule. On a 0 to 100 scale, where 100 is best. |
| accomplishmentrank | double | Strength of Record rank. Reflects chance that an average Top 25 team would have team's record or better, given the schedule. |
| adjwins | double | Team's Wins adjusted for chance an average FBS team would have team's record or better, given the schedule. |
| adjlosses | double | Team's Losses adjusted for chance an average FBS team would have team's record or better, given the schedule. |
| adjwinpctrank | double | Rank among FBS teams by adjusted win percentage. ESPN publishes the rank without the underlying percentage; derive it from adjwins and adjlosses. 0 is an unranked placeholder, not a rank – it appears where the underlying value is null. |
| gamecontrol | double | Reflects chance that an average Top 25 team would control games from start to end the way this team did, given the schedule. On a 0 to 100 scale, where 100 is best. |
| gamecontrolrank | double | Game Control rank. Reflects chance that an average Top 25 team would control games from start to end the way this team did, given the schedule. |
| adjavgingamewp | double | Team's average in-game win probability adjusted for chance that an average FBS team would control games from start to end the way this team did, given the schedule. |
| adjavgingamewprank | double | Rank among FBS teams by adjavgingamewp (average in-game win probability adjusted for opponent). Null for most pre-2019 snapshots. 0 is an unranked placeholder, not a rank. |
| avgingamewp | double | Team's average in-game win probability across all plays of all games played, not adjusted for site or opponent. |
| avgingamewprank | double | Team's average in-game win probability rank adjusted for chance that an average FBS team would control games from start to end the way this team did, given the schedule. |
| avgsosrank | double | Rank among all FBS teams of games already played schedule strength, from perspective of an average Top 25 team. |
| topsosrank | double | Rank among all FBS teams of games already played schedule strength, from perspective of an top FBS team. |
| epaoffense | double | Offensive component of FPI. Offensive contribution to expected point margin vs average opponent on neutral field. |
| epadefense | double | Defensive component of FPI. Defensive contribution to expected point margin vs average opponent on neutral field. |
| epaspecialteams | double | Special teams component of FPI. Special teams contribution to expected point margin vs average opponent on neutral field. |
| probwindiv | double | Percent of season simulations in which team won its conference division, for those conferences that have divisions. |
| probmakeplayoffs | double | Chance to make the CFB Playoff, according to the Playoff Predictor. |
| probmaketitlegame | double | Chance to make the CFB Playoff National Championship game, according to the Playoff Predictor. |
| numwins | double | Actual wins to date at the time of the snapshot. Distinct from projectedw (full-season projection) and adjwins (opponent-adjusted). |
| numlosses | double | Actual losses to date at the time of the snapshot. Distinct from projectedl (full-season projection) and adjlosses (opponent-adjusted). |
| numties | double | Actual ties to date. Never nonzero – college football abolished ties in 1996; the column is null or 0 in every published row. |
| probwintitle | double | Chance to win the CFB Playoff National Championship, according to the Playoff Predictor. |
| rankchange7days | double | FPI Rank change from previous week. |
| prob6wins | double | Percent of season simulations in which a team won at least 6 games (typically bowl-eligible). |
| rank | double | FPI rank among FBS teams for this snapshot (1 = best). Prefer this over fpirank: the two agree on 99.4% of rows, and on the ~0.6% where they differ, rank is always the one consistent with the published fpi value. |
| offefficiency | double | Offensive efficiency on 0-100 scale; based on offense's contribution to scoring margin on per-play basis, adjusted for strength of opposing defenses faced. |
| offefficiencyrank | double | Team's offensive efficiency rank among all FBS teams. |
| defefficiency | double | Defensive efficiency on 0-100 scale; based on defense's contribution to scoring margin on per-play basis, adjusted for strength of opposing offenses faced. |
| defefficiencyrank | double | Team's defensive efficiency rank among all FBS teams. |
| stefficiency | double | Special teams efficiency on 0-100 scale; based on special teams' contribution to scoring margin on per-play basis, adjusted for strength of opposing special teams faced. |
| stefficiencyrank | double | Team's special teams efficiency rank among all FBS teams. |
| totefficiency | double | Net efficiency on 0-100 scale; incorporates offense, defense and special teams efficiencies into a single schedule-adjusted measure of per-play efficiency. |
| totefficiencyrank | double | Team's overall efficiency rank among all FBS teams. |
| snapshot_is_contemporaneous | logical | True when the snapshot was computed inside its own season's window (August of the season year through February of the next), i.e. it is a live weekly run rather than a retrospective backfill. False for every row before 2015, which ESPN computed in one pass afterwards. A retrospective row is a reconstruction, not an as-of-week rating. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_fpi_weekly(2005))
#> ── college football weekly ESPN FPI ratings from the SportsDataverse data repo ─
#> ℹ Data updated: 2026-08-27 04:22:14 UTC
#> # A tibble: 2,023 × 51
#>    season season_type  week team_id last_updated      run_date_time_key
#>     <int>       <int> <int>   <int> <chr>                         <dbl>
#>  1   2005           2     1       2 2015-08-29T22:50Z           2.01e13
#>  2   2005           2     1       5 2015-08-29T22:50Z           2.01e13
#>  3   2005           2     1       8 2015-08-29T22:50Z           2.01e13
#>  4   2005           2     1       9 2015-08-29T22:50Z           2.01e13
#>  5   2005           2     1      12 2015-08-29T22:50Z           2.01e13
#>  6   2005           2     1      21 2015-08-29T22:50Z           2.01e13
#>  7   2005           2     1      23 2015-08-29T22:50Z           2.01e13
#>  8   2005           2     1      24 2015-08-29T22:50Z           2.01e13
#>  9   2005           2     1      25 2015-08-29T22:50Z           2.01e13
#> 10   2005           2     1      26 2015-08-29T22:50Z           2.01e13
#> # ℹ 2,013 more rows
#> # ℹ 45 more variables: snapshot_out_of_sequence <lgl>, fpi <dbl>,
#> #   fpirank <dbl>, projectedw <dbl>, projectedl <dbl>, projectedt <lgl>,
#> #   projectedwpctrank <dbl>, probwinout <dbl>, probwinconf <dbl>,
#> #   sosremainingrank <lgl>, accomplishment <dbl>, accomplishmentrank <dbl>,
#> #   adjwins <dbl>, adjlosses <dbl>, adjwinpctrank <dbl>, gamecontrol <dbl>,
#> #   gamecontrolrank <dbl>, adjavgingamewp <dbl>, adjavgingamewprank <dbl>, …
# }
```
