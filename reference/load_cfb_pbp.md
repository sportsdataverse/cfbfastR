# **Load cleaned play-by-play from the data repo**

helper that loads multiple seasons from the data repo either into memory
or writes it into a db using some forwarded arguments in the dots

This is the classic cfbfastR EPA/WPA play-by-play (CFBD-sourced, 2014+).
Every season carries games with an FBS team in them. From 2022 on the
release also carries the FCS games CFBD covers – FCS vs FCS and FCS vs
Division II/III – 36-43% of 2022-2025 plays. Filter on
`home_team_division` / `away_team_division` (`"fbs"`, `"fcs"`, `"ii"`,
`"iii"`) to keep only FBS games:
`dplyr::filter(pbp, home_team_division == "fbs" | away_team_division == "fbs")`.
A few games per season have `NA` divisions.

For the ESPN-derived pbp with deeper history (2004+) see
[`load_espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_espn_cfb_pbp.md);
for stats.ncaa.org pbp covering FCS and lower divisions (2013+) see
[`load_ncaa_mfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_ncaa_mfb_pbp.md).

## Usage

``` r
load_cfb_pbp(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Source

CFB Play-by-Play Data releases can be found here:
<https://github.com/sportsdataverse/sportsdataverse-data/releases/tag/cfbfastR_cfb_pbp>

## Arguments

- seasons:

  A vector of 4-digit years associated with given College Football
  seasons.

- ...:

  Additional arguments passed to an underlying function that writes the
  season data into a database (used by
  [`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md))

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the play by play data table within the database

## Value

Returns a tibble with play-by-play data

## See also

Issues with this data should be filed here:
<https://github.com/sportsdataverse/cfbfastR-data>

[`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md)

Other loaders:
[`load_cfb_rosters()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_rosters.md),
[`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.md),
[`load_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_teams.md),
[`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md)

## Examples

``` r
# One season is about 160,000 plays and 400 MB in memory.
try(load_cfb_pbp(2024))
#> ── PBP from data repo and CollegeFootballData.com ──────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:56:39 UTC
#> # A tibble: 277,048 × 362
#>     year  week id_play   game_id game_play_number half_play_number
#>    <int> <int>   <dbl>     <int>            <dbl>            <dbl>
#>  1  2024     1 4.02e17 401628319                1                1
#>  2  2024     1 4.02e17 401628319                2                2
#>  3  2024     1 4.02e17 401628319                3                3
#>  4  2024     1 4.02e17 401628319                4                4
#>  5  2024     1 4.02e17 401628319                5                5
#>  6  2024     1 4.02e17 401628319                6                6
#>  7  2024     1 4.02e17 401628319                7                7
#>  8  2024     1 4.02e17 401628319                8                8
#>  9  2024     1 4.02e17 401628319                9                9
#> 10  2024     1 4.02e17 401628319               10               10
#> # ℹ 277,038 more rows
#> # ℹ 356 more variables: drive_play_number <dbl>, pos_team <chr>,
#> #   def_pos_team <chr>, pos_team_score <int>, def_pos_team_score <int>,
#> #   half <dbl>, period <int>, clock_minutes <int>, clock_seconds <int>,
#> #   play_type <chr>, play_text <chr>, down <dbl>, distance <dbl>,
#> #   yards_to_goal <dbl>, yards_gained <dbl>, EPA <dbl>, ep_before <dbl>,
#> #   ep_after <dbl>, wpa <dbl>, wp_before <dbl>, wp_after <dbl>, …
```
