# **Load college football advanced team from the SportsDataverse data repo**

Loads season-level advanced team stats – one row per team with the
offense/defense EPA, success, explosiveness, and havoc profile.
Published to the `espn_cfb_adv_team` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_adv_team(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2004 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2004)

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
| pos_team_id | integer | ESPN team id of the team on offense. Present for every season 2004+. |
| pos_team | character |  |
| rushing_highlight_yards_per_opp | double | Highlight yards per rushing opportunity. |
| total_pen_yards | integer | Total penalty yards assessed. |
| EPA_penalty | double | Total EPA attributed to penalties. |
| penalty_first_downs_created | integer | Number of first downs the team gained via opponent penalty. |
| penalty_first_downs_created_rate | double | Share of the team's first downs that came via opponent penalty. |
| penalties | integer | Number of penalties assessed against the team. |
| penalty_yards | integer | Net penalty yardage assessed against the team; can be negative when enforcement moved the team forward on balance. |
| special_teams_plays | integer | Number of special-teams plays. |
| EPA_sp | double | Total special-teams EPA, ESPN's abbreviated field for the same phase. |
| EPA_special_teams | double | Total EPA generated on special-teams plays. |
| field_goals | integer | Number of field-goal attempts. |
| EPA_fg | double | Total EPA on field-goal attempts. |
| punt_plays | integer | Number of punt plays. |
| EPA_punt | double | Total EPA on punt plays. |
| kickoff_plays | integer | Number of kickoff plays. |
| EPA_kickoff | double | Total EPA on kickoff plays. |
| rushes | integer | Number of rushing attempts. |
| rush_yards | double | Total yards the team gained on rush plays. |
| yards_per_rush | double | Yards gained per rushing attempt. |
| rushing_power_rate | double | Share of carries that were power rushing attempts. |
| rushing_first_downs_created | integer | Number of first downs created on rush plays. |
| rushing_first_downs_created_rate | double | Share of rush plays that created a first down. |
| EPA_rushing_overall | double | Total EPA on rush plays. |
| EPA_rushing_per_play | double | EPA per rush play. |
| EPA_explosive_rushing | integer | Count of explosive rush plays. A play count, not an EPA total. |
| EPA_explosive_rushing_rate | double | Explosive-play rate on rush plays, over ESPN's qualifying-play denominator. |
| EPA_non_explosive_rushing | double | Total EPA on rush plays with explosive plays excluded. |
| EPA_non_explosive_rushing_per_play | double | EPA per rush play with explosive plays excluded. |
| passes | integer | Number of pass plays the team ran. |
| pass_yards | double | Total yards the team gained on pass plays. |
| yards_per_pass | double |  |
| passing_first_downs_created | integer | Number of first downs created on pass plays. |
| passing_first_downs_created_rate | double | Share of pass plays that created a first down. |
| EPA_passing_overall | double | Total EPA on pass plays. |
| EPA_passing_per_play | double | EPA per pass play. |
| EPA_explosive_passing | integer | Count of explosive pass plays. A play count, not an EPA total. |
| EPA_explosive_passing_rate | double | Explosive-play rate on pass plays, over ESPN's qualifying-play denominator. |
| EPA_non_explosive_passing | double | Total EPA on pass plays with explosive plays excluded. |
| EPA_non_explosive_passing_per_play | double | EPA per pass play with explosive plays excluded. |
| scrimmage_plays | integer | Number of plays from scrimmage (rushes plus passes), excluding special teams. |
| EPA_overall_off | double | Total offensive EPA for the team. Duplicated exactly by EPA_overall_offense in every published season checked – prefer one and ignore the other. |
| EPA_overall_offense | double | Total offensive EPA. An exact duplicate of EPA_overall_off. |
| EPA_per_play | double | Offensive EPA per play. |
| EPA_non_explosive | double | Total EPA with explosive plays excluded, isolating the team's routine-down production. |
| EPA_non_explosive_per_play | double | EPA per play with explosive plays excluded. |
| EPA_explosive | integer | Count of explosive plays, per ESPN's advanced box score. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_explosive_rate | double | Explosive-play rate. Note this is NOT EPA_explosive divided by EPA_plays – ESPN divides by its own smaller qualifying-play count, so deriving it yourself will not reproduce this value. |
| passes_rate | double | Share of the team's plays from scrimmage that were pass plays. |
| off_yards | integer | Offensive yards gained from scrimmage. |
| total_off_yards | integer | Total offensive yards across all plays. |
| yards_per_play | double | Yards gained per play. |
| EPA_plays | integer | Number of plays ESPN's advanced box score scored for the team. |
| total_yards | integer | Total yards the team gained across all plays. |
| EPA_overall_total | double | Total EPA across all phases, which is why it differs from the offense-only EPA_overall_off. |
| rushes_rate | double | Share of the team's plays from scrimmage that were rush plays. |
| first_downs_created | integer | Number of first downs the team created. |
| first_downs_created_rate | double | Share of the team's plays that created a first down. |
| EPA_rushing_power | double | Total EPA on power rushing situations, as classified by ESPN's advanced box score. |
| EPA_rushing_power_per_play | double | EPA per play on power rushing situations. |
| rushing_power_success | integer | Count of power rushing attempts that gained the yardage needed. An integer count, not a rate – the rate is published separately as rushing_power_success_rate. |
| rushing_power_success_rate | double | Share of power rushing attempts that succeeded. |
| rushing_power | integer | Count of power rushing attempts, in short-yardage situations as classified by ESPN's advanced box score. |
| rushing_stuff | integer | Count of stuffed rushing attempts. |
| rushing_stuff_rate | double | Share of the team's carries that were stuffed at or behind the line of scrimmage. |
| rushing_stopped | integer | Count of rushing attempts stopped at or behind the line of scrimmage. |
| rushing_stopped_rate | double | Share of carries stopped at or behind the line of scrimmage. |
| rushing_opportunity | integer | Count of rushing opportunities – carries that reached ESPN's opportunity threshold. |
| rushing_opportunity_rate | double | Share of carries that qualified as rushing opportunities. |
| rushing_highlight | integer | Highlight yards – rushing yardage credited to the back rather than the offensive line. |
| rushing_highlight_rate | double | Share of rushing yardage that was highlight (back-credited) yardage. |
| rushing_highlight_yards | double | Total highlight yards the team accumulated – the yardage credited to ball carriers rather than the line. The per-carry figure is rushing_highlight_yards_per_opp. |
| line_yards | double | Line yards – the portion of rushing yardage credited to the offensive line under the standard rushing decomposition. ESPN applies its own qualifying threshold for the yardage split. |
| line_yards_per_carry | double | Line yards per rushing attempt. |
| second_level_yards | double | Second-level yards – rushing yardage earned just beyond the line of scrimmage. |
| open_field_yards | double | Open-field yards – rushing yardage earned well downfield, past the second level. |
| game_id | integer |  |
| season | integer |  |
| week | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_adv_team(2004))
#> ── college football advanced team from the SportsDataverse data repo ───────────
#> ℹ Data updated: 2026-08-24 11:39:50 UTC
#> # A tibble: 926 × 80
#>    pos_team_id pos_team       rushing_highlight_ya…¹ total_pen_yards EPA_penalty
#>          <int> <chr>                           <dbl>           <int>       <dbl>
#>  1          30 USC Trojans                      3.7               -5       -0.56
#>  2         259 Virginia Tech…                   4.67               5        1.86
#>  3         254 Utah Utes                        3.97             -75       -5.97
#>  4         245 Texas A&M Agg…                   6.77             -40       -5.99
#>  5        2050 Ball State Ca…                   1.22             -10       -1.29
#>  6         103 Boston Colleg…                   4.21             -16       -0.69
#>  7        2628 TCU Horned Fr…                   3.07             -15       -1.59
#>  8          77 Northwestern …                   3.62              45        6.3 
#>  9           9 Arizona State…                   1.77             -21       -0.13
#> 10        2638 UTEP Miners                      1.79              10        1.07
#> # ℹ 916 more rows
#> # ℹ abbreviated name: ¹​rushing_highlight_yards_per_opp
#> # ℹ 75 more variables: penalty_first_downs_created <int>,
#> #   penalty_first_downs_created_rate <dbl>, penalties <int>,
#> #   penalty_yards <int>, special_teams_plays <int>, EPA_sp <dbl>,
#> #   EPA_special_teams <dbl>, field_goals <int>, EPA_fg <dbl>, punt_plays <int>,
#> #   EPA_punt <dbl>, kickoff_plays <int>, EPA_kickoff <dbl>, rushes <int>, …
# }
```
