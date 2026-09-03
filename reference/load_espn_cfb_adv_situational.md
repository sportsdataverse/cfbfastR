# **Load college football advanced situational from the SportsDataverse data repo**

Loads season-level situational splits – one row per team-situation
(down, distance band, field zone, game state) with EPA and success
aggregates. Published to the `espn_cfb_adv_situational` release tag on
the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_adv_situational(
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
| pos_team | character | Display name of the team on offense (e.g. 'Ohio State Buckeyes'). |
| EPA_success | integer | Count of successful plays. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_rate | double | Success rate – the share of those plays ESPN scored as successful. |
| EPA_success_pass | integer | Count of successful plays on pass plays. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_pass_rate | double | Success rate on pass plays – the share of those plays ESPN scored as successful. |
| EPA_success_rush | integer | Count of successful plays on rush plays. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_rush_rate | double | Success rate on rush plays – the share of those plays ESPN scored as successful. |
| EPA_success_rz | integer | Count of successful plays on the red zone. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_rate_rz | double | Success rate on the red zone – the share of those plays ESPN scored as successful. |
| EPA_success_third | integer | Count of successful plays on third down. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_rate_third | double | Success rate on third down – the share of those plays ESPN scored as successful. |
| EPA_success_early_down | integer | Count of successful plays on early downs. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_early_down_rate | double | Success rate on early downs – the share of those plays ESPN scored as successful. |
| early_downs | integer | Number of plays the team ran on early downs. |
| early_down_pass_rate | double | Share of the team's plays on early downs that were pass plays. |
| early_down_rush_rate | double | Share of the team's plays on early downs that were rush plays. |
| EPA_early_down | double | Total EPA the team generated on early downs. |
| EPA_early_down_per_play | double | EPA per play on early downs. |
| early_down_first_down | integer | Number of early-down plays that produced a first down. |
| early_down_first_down_rate | double | Share of early-down plays that produced a first down. |
| early_down_pass | integer | Number of pass plays the team ran on early downs. |
| EPA_early_down_pass | double | Total EPA the team generated on early downs on pass plays. |
| EPA_early_down_pass_per_play | double | EPA per play on early downs on pass plays. |
| EPA_success_early_down_pass | integer | Count of successful plays on early downs on pass plays. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_early_down_pass_rate | double | Success rate on early downs on pass plays – the share of those plays ESPN scored as successful. |
| early_down_rush | integer | Number of rush plays the team ran on early downs. |
| EPA_early_down_rush | double | Total EPA the team generated on early downs on rush plays. |
| EPA_early_down_rush_per_play | double | EPA per play on early downs on rush plays. |
| EPA_success_early_down_rush | integer | Count of successful plays on early downs on rush plays. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_early_down_rush_rate | double | Success rate on early downs on rush plays – the share of those plays ESPN scored as successful. |
| middle_8 | integer | Number of plays the team ran in the middle eight – the closing minutes of the first half and opening minutes of the second. |
| middle_8_pass_rate | double | Share of the team's plays on the middle eight – the closing minutes of the first half and opening minutes of the second that were pass plays. |
| middle_8_rush_rate | double | Share of the team's plays on the middle eight – the closing minutes of the first half and opening minutes of the second that were rush plays. |
| EPA_middle_8 | double | Total EPA the team generated on the middle eight – the closing minutes of the first half and opening minutes of the second. |
| EPA_middle_8_per_play | double | EPA per play on the middle eight – the closing minutes of the first half and opening minutes of the second. |
| EPA_middle_8_success | integer | Count of successful plays on the middle eight – the closing minutes of the first half and opening minutes of the second. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_middle_8_success_rate | double | Success rate on the middle eight – the closing minutes of the first half and opening minutes of the second – the share of those plays ESPN scored as successful. |
| middle_8_pass | integer | Number of pass plays the team ran on the middle eight – the closing minutes of the first half and opening minutes of the second. |
| EPA_middle_8_pass | double | Total EPA the team generated on the middle eight – the closing minutes of the first half and opening minutes of the second on pass plays. |
| EPA_middle_8_pass_per_play | double | EPA per play on the middle eight – the closing minutes of the first half and opening minutes of the second on pass plays. |
| EPA_middle_8_success_pass | integer | Count of successful plays on the middle eight – the closing minutes of the first half and opening minutes of the second on pass plays. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_middle_8_success_pass_rate | double | Success rate on the middle eight – the closing minutes of the first half and opening minutes of the second on pass plays – the share of those plays ESPN scored as successful. |
| middle_8_rush | integer | Number of rush plays the team ran on the middle eight – the closing minutes of the first half and opening minutes of the second. |
| EPA_middle_8_rush | double | Total EPA the team generated on the middle eight – the closing minutes of the first half and opening minutes of the second on rush plays. |
| EPA_middle_8_rush_per_play | double | EPA per play on the middle eight – the closing minutes of the first half and opening minutes of the second on rush plays. |
| EPA_middle_8_success_rush | integer | Count of successful plays on the middle eight – the closing minutes of the first half and opening minutes of the second on rush plays. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_middle_8_success_rush_rate | double | Success rate on the middle eight – the closing minutes of the first half and opening minutes of the second on rush plays – the share of those plays ESPN scored as successful. |
| EPA_success_late_down | integer | Count of successful plays on late downs. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_late_down_pass | integer | Count of successful plays on late downs on pass plays. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_late_down_rush | integer | Count of successful plays on late downs on rush plays. Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| late_downs | integer | Number of plays the team ran on late downs. |
| late_down_pass | integer | Number of pass plays the team ran on late downs. |
| late_down_rush | integer | Number of rush plays the team ran on late downs. |
| EPA_late_down | double | Total EPA the team generated on late downs. |
| EPA_late_down_per_play | double | EPA per play on late downs. |
| EPA_success_late_down_rate | double | Success rate on late downs – the share of those plays ESPN scored as successful. |
| EPA_success_late_down_pass_rate | double | Success rate on late downs on pass plays – the share of those plays ESPN scored as successful. |
| EPA_success_late_down_rush_rate | double | Success rate on late downs on rush plays – the share of those plays ESPN scored as successful. |
| late_down_pass_rate | double | Share of the team's plays on late downs that were pass plays. |
| late_down_rush_rate | double | Share of the team's plays on late downs that were rush plays. |
| EPA_success_standard_down | integer | Count of successful plays on standard downs (the team ahead of schedule for the series). Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_standard_down_rate | double | Success rate on standard downs (the team ahead of schedule for the series) – the share of those plays ESPN scored as successful. |
| EPA_standard_down | double | Total EPA the team generated on standard downs (the team ahead of schedule for the series). |
| EPA_standard_down_per_play | double | EPA per play on standard downs (the team ahead of schedule for the series). |
| standard_downs | integer | Number of plays the team ran on standard downs (the team ahead of schedule for the series). |
| EPA_success_passing_down | integer | Count of successful plays on passing downs (the team behind schedule for the series). Despite the EPA\_ prefix this is a play COUNT, not an EPA total. |
| EPA_success_passing_down_rate | double | Success rate on passing downs (the team behind schedule for the series) – the share of those plays ESPN scored as successful. |
| EPA_passing_down | double | Total EPA the team generated on passing downs (the team behind schedule for the series). |
| EPA_passing_down_per_play | double | EPA per play on passing downs (the team behind schedule for the series). |
| passing_downs | integer | Number of plays the team ran on passing downs (the team behind schedule for the series). |
| game_id | integer |  |
| season | integer |  |
| week | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_adv_situational(2004))
#> ── college football advanced situational from the SportsDataverse data repo ────
#> ℹ Data updated: 2026-09-03 22:41:09 UTC
#> # A tibble: 926 × 74
#>    pos_team_id pos_team            EPA_success EPA_success_rate EPA_success_pass
#>          <int> <chr>                     <int>            <dbl>            <int>
#>  1          30 USC Trojans                  23            0.404               12
#>  2         259 Virginia Tech Hoki…          17            0.279                9
#>  3         245 Texas A&M Aggies             20            0.299                9
#>  4         254 Utah Utes                    35            0.461               19
#>  5        2050 Ball State Cardina…          13            0.206                7
#>  6         103 Boston College Eag…          24            0.343                8
#>  7          77 Northwestern Wildc…          44            0.473               29
#>  8        2628 TCU Horned Frogs             35            0.455               17
#>  9           9 Arizona State Sun …          24            0.3                 15
#> 10        2638 UTEP Miners                  13            0.183                9
#> # ℹ 916 more rows
#> # ℹ 69 more variables: EPA_success_pass_rate <dbl>, EPA_success_rush <int>,
#> #   EPA_success_rush_rate <dbl>, EPA_success_rz <int>,
#> #   EPA_success_rate_rz <dbl>, EPA_success_third <int>,
#> #   EPA_success_rate_third <dbl>, EPA_success_early_down <int>,
#> #   EPA_success_early_down_rate <dbl>, early_downs <int>,
#> #   early_down_pass_rate <dbl>, early_down_rush_rate <dbl>, …
# }
```
