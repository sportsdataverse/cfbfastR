# **Get player usage metrics**

**Get player usage metrics**

## Usage

``` r
cfbd_player_usage(
  year = most_recent_cfb_season(),
  team = NULL,
  conference = NULL,
  position = NULL,
  athlete_id = NULL,
  excl_garbage_time = FALSE
)
```

## Arguments

- year:

  (*Integer* required, default most recent season): Year, 4 digit format
  (*YYYY*).

- team:

  (*String* optional): Team - Select a valid team, D1 football

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- position:

  (*string* optional): Position of the player you are searching for.
  Position Group - options include:

  - Offense: QB, RB, FB, TE, OL, G, OT, C, WR

  - Defense: DB, CB, S, LB, DE, DT, NT, DL

  - Special Teams: K, P, LS, PK

- athlete_id:

  (*Integer* optional): Athlete ID filter for querying a single athlete
  Can be found using the
  [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md)
  function.

- excl_garbage_time:

  (*Logical* default FALSE): Select whether to exclude Garbage Time
  (TRUE/FALSE)

## Value

`cfbd_player_usage()` - A data frame with 14 variables:

- `season`: integer.:

  Player usage season.

- `athlete_id`: character.:

  Referencing athlete id.

- `name`: character.:

  Athlete name.

- `position`: character.:

  Athlete position.

- `team`: character.:

  Team name.

- `conference`: character.:

  Conference of team.

- `usg_overall`: double.:

  Player usage of overall offense.

- `usg_pass`: double.:

  Player passing usage percentage.

- `usg_rush`: double.:

  Player rushing usage percentage.

- `usg_1st_down`: double.:

  Player first down usage percentage.

- `usg_2nd_down`: double.:

  Player second down usage percentage.

- `usg_3rd_down`: double.:

  Player third down usage percentage.

- `usg_standard_downs`: double.:

  Player standard down usage percentage.

- `usg_passing_downs`: double.:

  Player passing down usage percentage.

## See also

Other CFBD Players:
[`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md),
[`cfbd_player_returning()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_returning.md)

## Examples

``` r
# \donttest{
  try(cfbd_player_usage(year = 2019, position = "WR", team = "Florida State"))
#> ── Player usage data from CollegeFootballData.com ──────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:36 UTC
#> # A tibble: 9 × 14
#>   season athlete_id name          position team  conference usg_overall usg_pass
#>    <int> <chr>      <chr>         <chr>    <chr> <chr>            <dbl>    <dbl>
#> 1   2019 4035628    Keith Gavin   WR       Flor… ACC              0.033    0.063
#> 2   2019 4240028    Tamorrion Te… WR       Flor… ACC              0.115    0.211
#> 3   2019 4240033    Ontaria Wils… WR       Flor… ACC              0.056    0.098
#> 4   2019 4240034    D.J. Matthews WR       Flor… ACC              0.071    0.129
#> 5   2019 4360473    Adarius Dent  WR       Flor… ACC              0.029    0.063
#> 6   2019 4363030    Warren Thomp… WR       Flor… ACC              0.023    0.043
#> 7   2019 4363032    Keyshawn Hel… WR       Flor… ACC              0.069    0.106
#> 8   2019 4363044    Jordan Young  WR       Flor… ACC              0.028    0.053
#> 9   2019 4363046    Tre'Shaun Ha… WR       Flor… ACC              0.059    0.099
#> # ℹ 6 more variables: usg_rush <dbl>, usg_1st_down <dbl>, usg_2nd_down <dbl>,
#> #   usg_3rd_down <dbl>, usg_standard_downs <dbl>, usg_passing_downs <dbl>
# }
```
