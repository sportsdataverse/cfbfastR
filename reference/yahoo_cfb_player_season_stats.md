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
#> ── Player season stats from Yahoo Sports (shangrila) ───────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-13 03:29:11 UTC
#> # A tibble: 191 × 88
#>    player_id      display_name  team  team_abbreviation punts passing_touchdowns
#>    <chr>          <chr>         <chr> <chr>             <chr> <chr>             
#>  1 ncaaf.p.64742  Trey Sanders  TCU   TCU               NA    NA                
#>  2 ncaaf.p.176026 Alexander Di… Kenn… KENN              NA    NA                
#>  3 ncaaf.p.177536 Carson Kent   Pitt… PITT              NA    NA                
#>  4 ncaaf.p.218709 Eric Goins    Notr… ND                NA    NA                
#>  5 ncaaf.p.220824 Rico Watson … Sout… S FLA             NA    NA                
#>  6 ncaaf.p.263248 Cam McCormick Miam… MIA               NA    NA                
#>  7 ncaaf.p.264043 Danarius Joh… Kenn… KENN              NA    NA                
#>  8 ncaaf.p.270875 Keenan Pili   Tenn… TENN              NA    NA                
#>  9 ncaaf.p.276361 Spencer Curt… Hawa… HAW               NA    NA                
#> 10 ncaaf.p.276368 Logan Lutui   BYU   BYU               NA    NA                
#> # ℹ 181 more rows
#> # ℹ 82 more variables: games_rushing <chr>, field_goals_made_50_plus <chr>,
#> #   total_tackles <chr>, longest_pass <chr>, games_offense <chr>,
#> #   points_scored_kicking <chr>, rushing_yards <chr>, extra_points_made <chr>,
#> #   games_receiving <chr>, safeties <chr>, longest_field_goal <chr>,
#> #   qb_rating <chr>, passing_yards <chr>, field_goals_40_to_49 <chr>,
#> #   receiving_yards_per_game <chr>, sacks_taken <chr>, sacks <chr>, …
# }
```
