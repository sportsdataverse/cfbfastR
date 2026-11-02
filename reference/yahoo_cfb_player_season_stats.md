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
#> ── Player season stats from Yahoo Sports (shangrila) ───────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-02 08:14:36 UTC
#> # A tibble: 200 × 89
#>    player_id      display_name     team  team_abbreviation targets games_defense
#>    <chr>          <chr>            <chr> <chr>             <chr>   <chr>        
#>  1 ncaaf.p.64742  Trey Sanders     TCU   TCU               NA      NA           
#>  2 ncaaf.p.176026 Alexander Diggs  Kenn… KENN              NA      NA           
#>  3 ncaaf.p.177536 Carson Kent      Pitt… PITT              27      NA           
#>  4 ncaaf.p.218709 Eric Goins       Notr… ND                NA      NA           
#>  5 ncaaf.p.220824 Rico Watson III  Sout… S FLA             NA      8            
#>  6 ncaaf.p.263248 Cam McCormick    Miam… MIA               6       NA           
#>  7 ncaaf.p.264043 Danarius Johnson Kenn… KENN              NA      3            
#>  8 ncaaf.p.270875 Keenan Pili      Tenn… TENN              NA      5            
#>  9 ncaaf.p.276361 Spencer Curtis   Hawa… HAW               27      NA           
#> 10 ncaaf.p.276368 Logan Lutui      BYU   BYU               NA      7            
#> # ℹ 190 more rows
#> # ℹ 83 more variables: games_kicking <chr>, extra_point_percentage <chr>,
#> #   longest_field_goal <chr>, field_goals_0_to_19 <chr>,
#> #   field_goals_made_30_39 <chr>, punt_yards_per_punt <chr>,
#> #   passing_touchdowns <chr>, extra_point_attempts <chr>,
#> #   interception_return_yards <chr>, kickoff_return_touchdowns <chr>,
#> #   field_goals_made_20_29 <chr>, rushing_yards <chr>, …
# }
```
