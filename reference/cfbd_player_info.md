# **Player information lookup**

**Player information lookup**

## Usage

``` r
cfbd_player_info(search_term, position = NULL, team = NULL, year = NULL)
```

## Arguments

- search_term:

  (*String* required): Search term for the player you are trying to look
  up

- position:

  (*string* optional): Position of the player you are searching for.
  Position Group - options include:

  - Offense: QB, RB, FB, TE, OL, G, OT, C, WR

  - Defense: DB, CB, S, LB, DE, DT, NT, DL

  - Special Teams: K, P, LS, PK

- team:

  (*String* optional): Team - Select a valid team, D1 football

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). If left NULL, API
  default will only provide results for most recent year of final
  rosters: 2020

## Value

`cfbd_player_info()` - A data frame with 12 variables:

- `athlete_id`:character.:

  Unique player identifier `athlete_id`.

- `team`:character.:

  Team of the player.

- `name`:character.:

  Player name.

- `first_name`:character.:

  Player first name.

- `last_name`:character.:

  Player last name.

- `weight`:integer.:

  Player weight.

- `height`:integer.:

  Player height.

- `jersey`:integer.:

  Player jersey number.

- `position`:character.:

  Player position.

- `home_town`:character.:

  Player home town.

- `team_color`:character.:

  Player team color.

- `team_color_secondary`:character.:

  Player team secondary color.

## See also

Other CFBD Players:
[`cfbd_player_returning()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_returning.md),
[`cfbd_player_usage()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.md)

## Examples

``` r
# \donttest{
  try(cfbd_player_info(search_term = "James", position = "DB", team = "Florida State", year = 2017))
#> ── Player information from CollegeFootballData.com ─────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:22:34 UTC
#> # A tibble: 1 × 12
#>   athlete_id team       name  first_name last_name weight height jersey position
#>   <chr>      <chr>      <chr> <chr>      <chr>      <int>  <int>  <int> <chr>   
#> 1 3691739    Florida S… Derw… Derwin     James        211     75      3 DB      
#> # ℹ 3 more variables: home_town <chr>, team_color <chr>,
#> #   team_color_secondary <chr>

  try(cfbd_player_info(search_term = "Lawrence", team = "Clemson"))
#> ── Player information from CollegeFootballData.com ─────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:22:34 UTC
#> # A tibble: 2 × 12
#>   athlete_id team    name     first_name last_name weight height jersey position
#>   <chr>      <chr>   <chr>    <chr>      <chr>      <int>  <int>  <int> <chr>   
#> 1 4035483    Clemson Dexter … Dexter     Lawrence     340     76     90 DT      
#> 2 4360310    Clemson Trevor … Trevor     Lawrence     220     78     16 QB      
#> # ℹ 3 more variables: home_town <chr>, team_color <chr>,
#> #   team_color_secondary <chr>
# }
```
