# **Get Yahoo Sports college football player season stats (modern)**

Flattens the shangrila `leagueStatsIndividual` response (all stat groups
in one call) into one wide tibble with one row per player. NCAAF data is
available 2013-present.

## Usage

``` r
yahoo_cfb_player_season_stats(
  season = most_recent_cfb_season(),
  league_structure = "ncaaf.struct.div.1",
  count = 200,
  qualified = FALSE
)
```

## Arguments

- season:

  (integer): Season year (e.g. `2024`). Defaults to
  `most_recent_cfb_season()`.

- league_structure:

  (character): Division filter. Defaults to `"ncaaf.struct.div.1"`
  (FBS).

- count:

  (integer): Max players. Defaults to `200`.

- qualified:

  (logical): Restrict to qualified leaders. Defaults to `FALSE`.

## Value

A `cfbfastR`-tagged tibble with one row per player. Core columns:

- `player_id`: character.: Yahoo player id (`ncaaf.p.*`).

- `display_name`: character.: Player name.

- `team`: character.: Team display name.

- `team_abbreviation`: character.: Team abbreviation.

- `season`: integer.: Season echoed back.

Remaining columns are one per `statId` (e.g. `passing_yards`,
`rushing_yards`, `receptions`, ...), value as displayed (character).
Column set grows over time.

## See also

Other Yahoo CFB Functions:
[`yahoo_cfb_boxscore()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_boxscore.md),
[`yahoo_cfb_player_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats_legacy.md),
[`yahoo_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_scoreboard.md),
[`yahoo_cfb_team_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats.md),
[`yahoo_cfb_team_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats_legacy.md)

## Examples

``` r
# \donttest{
  try(yahoo_cfb_player_season_stats(season = 2024))
#> ── Player season stats from Yahoo Sports (shangrila) ──── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-27 05:33:45 UTC
#> # A tibble: 200 × 89
#>    player_id     display_name team  team_abbreviation safeties extra_points_made
#>    <chr>         <chr>        <chr> <chr>             <chr>    <chr>            
#>  1 ncaaf.p.64742 Trey Sanders TCU   TCU               NA       NA               
#>  2 ncaaf.p.1760… Alexander D… Kenn… KENN              NA       NA               
#>  3 ncaaf.p.1775… Carson Kent  Pitt… PITT              NA       NA               
#>  4 ncaaf.p.2187… Eric Goins   Notr… ND                NA       0                
#>  5 ncaaf.p.2208… Rico Watson… Sout… S FLA             0        NA               
#>  6 ncaaf.p.2632… Cam McCormi… Miam… MIA               NA       NA               
#>  7 ncaaf.p.2640… Danarius Jo… Kenn… KENN              0        NA               
#>  8 ncaaf.p.2708… Keenan Pili  Tenn… TENN              0        NA               
#>  9 ncaaf.p.2763… Spencer Cur… Hawa… HAW               NA       NA               
#> 10 ncaaf.p.2763… Logan Lutui  BYU   BYU               0        NA               
#> # ℹ 190 more rows
#> # ℹ 83 more variables: field_goals_30_to_39 <chr>,
#> #   field_goals_made_50_plus <chr>, games_receiving <chr>,
#> #   receiving_yards <chr>, games_returns <chr>,
#> #   field_goal_attempts_20_29 <chr>, games_offense <chr>,
#> #   field_goal_percentage <chr>, field_goals_0_to_19 <chr>,
#> #   rushing_yards_per_attempt <chr>, return_yards_per_punt <chr>, …
# }
```
