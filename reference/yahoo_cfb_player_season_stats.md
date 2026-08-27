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
#> ── Player season stats from Yahoo Sports (shangrila) ───────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 16:46:16 UTC
#> # A tibble: 191 × 88
#>    player_id display_name team  team_abbreviation sacks_taken rushing_touchdowns
#>    <chr>     <chr>        <chr> <chr>             <chr>       <chr>             
#>  1 ncaaf.p.… Trey Sanders TCU   TCU               NA          0                 
#>  2 ncaaf.p.… Alexander D… Kenn… KENN              NA          0                 
#>  3 ncaaf.p.… Carson Kent  Pitt… PITT              NA          NA                
#>  4 ncaaf.p.… Eric Goins   Notr… ND                NA          NA                
#>  5 ncaaf.p.… Rico Watson… Sout… S FLA             NA          NA                
#>  6 ncaaf.p.… Cam McCormi… Miam… MIA               NA          NA                
#>  7 ncaaf.p.… Danarius Jo… Kenn… KENN              NA          NA                
#>  8 ncaaf.p.… Keenan Pili  Tenn… TENN              NA          NA                
#>  9 ncaaf.p.… Spencer Cur… Hawa… HAW               NA          NA                
#> 10 ncaaf.p.… Logan Lutui  BYU   BYU               NA          NA                
#> # ℹ 181 more rows
#> # ℹ 82 more variables: kickoff_return_yards <chr>, receiving_touchdowns <chr>,
#> #   field_goal_percentage <chr>, points_scored_kicking <chr>,
#> #   games_offense <chr>, passes_defended <chr>, games_kicking <chr>,
#> #   receiving_yards_per_reception <chr>, total_tackles <chr>,
#> #   field_goals_made_50_plus <chr>, rushing_yards_per_game <chr>,
#> #   interception_return_yards <chr>, games_returns <chr>, …
# }
```
