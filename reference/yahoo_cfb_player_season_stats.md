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
#> ℹ Data updated: 2026-08-29 13:19:05 UTC
#> # A tibble: 191 × 88
#>    player_id  display_name team  team_abbreviation total_tackles passes_defended
#>    <chr>      <chr>        <chr> <chr>             <chr>         <chr>          
#>  1 ncaaf.p.6… Trey Sanders TCU   TCU               NA            NA             
#>  2 ncaaf.p.1… Alexander D… Kenn… KENN              NA            NA             
#>  3 ncaaf.p.1… Carson Kent  Pitt… PITT              NA            NA             
#>  4 ncaaf.p.2… Eric Goins   Notr… ND                NA            NA             
#>  5 ncaaf.p.2… Rico Watson… Sout… S FLA             28            0              
#>  6 ncaaf.p.2… Cam McCormi… Miam… MIA               NA            NA             
#>  7 ncaaf.p.2… Danarius Jo… Kenn… KENN              6             0              
#>  8 ncaaf.p.2… Keenan Pili  Tenn… TENN              27            0              
#>  9 ncaaf.p.2… Spencer Cur… Hawa… HAW               NA            NA             
#> 10 ncaaf.p.2… Logan Lutui  BYU   BYU               11            0              
#> # ℹ 181 more rows
#> # ℹ 82 more variables: field_goal_attempts_0_19 <chr>,
#> #   extra_point_attempts <chr>, sacks_yards_lost <chr>,
#> #   rushing_attempts_per_game <chr>, receptions <chr>, field_goals_made <chr>,
#> #   games_punting <chr>, forced_fumbles <chr>, points_scored_kicking <chr>,
#> #   passing_touchdowns <chr>, longest_reception <chr>, games_rushing <chr>,
#> #   tackles_for_loss <chr>, extra_points_made <chr>, …
# }
```
