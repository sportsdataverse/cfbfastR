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
#> ℹ Data updated: 2026-08-27 15:32:41 UTC
#> # A tibble: 191 × 88
#>    player_id   display_name team  team_abbreviation field_goals_made_40_49 punts
#>    <chr>       <chr>        <chr> <chr>             <chr>                  <chr>
#>  1 ncaaf.p.64… Trey Sanders TCU   TCU               NA                     NA   
#>  2 ncaaf.p.17… Alexander D… Kenn… KENN              NA                     NA   
#>  3 ncaaf.p.17… Carson Kent  Pitt… PITT              NA                     NA   
#>  4 ncaaf.p.21… Eric Goins   Notr… ND                0                      NA   
#>  5 ncaaf.p.22… Rico Watson… Sout… S FLA             NA                     NA   
#>  6 ncaaf.p.26… Cam McCormi… Miam… MIA               NA                     NA   
#>  7 ncaaf.p.26… Danarius Jo… Kenn… KENN              NA                     NA   
#>  8 ncaaf.p.27… Keenan Pili  Tenn… TENN              NA                     NA   
#>  9 ncaaf.p.27… Spencer Cur… Hawa… HAW               NA                     NA   
#> 10 ncaaf.p.27… Logan Lutui  BYU   BYU               NA                     NA   
#> # ℹ 181 more rows
#> # ℹ 82 more variables: passing_yards <chr>, return_yards_per_punt <chr>,
#> #   sacks_taken <chr>, sacks_yards <chr>, field_goals_50_plus <chr>,
#> #   return_yards_per_kickoff <chr>, longest_rush <chr>,
#> #   punt_return_touchdowns <chr>, field_goal_attempts_40_49 <chr>,
#> #   rushing_yards <chr>, kickoff_returns <chr>,
#> #   interception_return_yards <chr>, games_kicking <chr>, …
# }
```
