# **Load NCAA men's football play-by-play (stats.ncaa.org) from the SportsDataverse data repo**

Loads season-level NCAA men's football play-by-play parsed from
stats.ncaa.org by the sdv-py cfb_ncaa_pbp parser. Covers FCS and lower
divisions that ESPN's feed misses; one row per play with drive and
participant context. Published to the `ncaa_mfb_pbp` release tag on the
sportsdataverse-data repo.

For the same plays reshaped onto cfbfastR pbp column conventions (for
binding with
[`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md)
/
[`load_espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_espn_cfb_pbp.md)
output), use
[`load_ncaa_mfb_pbp_cfbfastr()`](https://cfbfastR.sportsdataverse.org/reference/load_ncaa_mfb_pbp_cfbfastr.md).

## Usage

``` r
load_ncaa_mfb_pbp(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2013 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2013)

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

|                  |           |             |
|------------------|-----------|-------------|
| col_name         | types     | description |
| contest_id       | character |             |
| drive_number     | integer   |             |
| play_number      | integer   |             |
| offense          | character |             |
| drive_result     | character |             |
| drive_scored     | logical   |             |
| down             | integer   |             |
| distance         | integer   |             |
| yard_line        | character |             |
| yard_line_side   | character |             |
| yard_line_number | integer   |             |
| play_type        | character |             |
| clock            | character |             |
| yards_gained     | integer   |             |
| formation        | character |             |
| passer           | character |             |
| rusher           | character |             |
| receiver         | character |             |
| kicker           | character |             |
| punter           | character |             |
| returner         | character |             |
| run_direction    | character |             |
| qb_scramble      | logical   |             |
| pass_complete    | logical   |             |
| pass_depth       | character |             |
| pass_direction   | character |             |
| tackler_1        | character |             |
| tackler_2        | character |             |
| kick_yards       | integer   |             |
| return_yards     | integer   |             |
| punt_yards       | integer   |             |
| fg_distance      | integer   |             |
| fg_made          | logical   |             |
| is_first_down    | logical   |             |
| is_touchdown     | logical   |             |
| is_safety        | logical   |             |
| is_fumble        | logical   |             |
| is_turnover      | logical   |             |
| turnover_type    | character |             |
| out_of_bounds    | logical   |             |
| no_play          | logical   |             |
| fair_catch       | logical   |             |
| penalty_flag     | logical   |             |
| penalty_team     | character |             |
| penalty_type     | character |             |
| penalty_player   | character |             |
| penalty_yards    | integer   |             |
| end_yard_line    | character |             |
| play_text        | character |             |
| espn_game_id     | character |             |
| season           | integer   |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_ncaa_mfb_pbp(2013))
#> ── NCAA men's football play-by-play (stats.ncaa.org) from the SportsDataverse da
#> ℹ Data updated: 2026-09-01 11:29:18 UTC
#> # A tibble: 344,180 × 51
#>    contest_id drive_number play_number offense drive_result drive_scored  down
#>    <chr>             <int>       <int> <chr>   <chr>        <lgl>        <int>
#>  1 688871                1           1 UCF     TD           TRUE             1
#>  2 688871                1           2 UCF     TD           TRUE             1
#>  3 688871                1           3 UCF     TD           TRUE             2
#>  4 688871                1           4 UCF     TD           TRUE             1
#>  5 688871                2           1 Akron   PUNT         FALSE            1
#>  6 688871                2           2 Akron   PUNT         FALSE            1
#>  7 688871                2           3 Akron   PUNT         FALSE            1
#>  8 688871                2           4 Akron   PUNT         FALSE            2
#>  9 688871                2           5 Akron   PUNT         FALSE            3
#> 10 688871                2           6 Akron   PUNT         FALSE            1
#> # ℹ 344,170 more rows
#> # ℹ 44 more variables: distance <int>, yard_line <chr>, yard_line_side <chr>,
#> #   yard_line_number <int>, play_type <chr>, clock <chr>, yards_gained <int>,
#> #   formation <chr>, passer <chr>, rusher <chr>, receiver <chr>, kicker <chr>,
#> #   punter <chr>, returner <chr>, run_direction <chr>, qb_scramble <lgl>,
#> #   pass_complete <lgl>, pass_depth <chr>, pass_direction <chr>,
#> #   tackler_1 <chr>, tackler_2 <chr>, kick_yards <int>, return_yards <int>, …
# }
```
