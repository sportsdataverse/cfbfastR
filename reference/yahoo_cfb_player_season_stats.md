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
#> ℹ Data updated: 2026-09-30 13:22:09 UTC
#> # A tibble: 200 × 89
#>    player_id    display_name team  team_abbreviation games_returns total_tackles
#>    <chr>        <chr>        <chr> <chr>             <chr>         <chr>        
#>  1 ncaaf.p.647… Trey Sanders TCU   TCU               NA            NA           
#>  2 ncaaf.p.176… Alexander D… Kenn… KENN              NA            NA           
#>  3 ncaaf.p.177… Carson Kent  Pitt… PITT              NA            NA           
#>  4 ncaaf.p.218… Eric Goins   Notr… ND                NA            NA           
#>  5 ncaaf.p.220… Rico Watson… Sout… S FLA             NA            28           
#>  6 ncaaf.p.263… Cam McCormi… Miam… MIA               NA            NA           
#>  7 ncaaf.p.264… Danarius Jo… Kenn… KENN              NA            6            
#>  8 ncaaf.p.270… Keenan Pili  Tenn… TENN              NA            27           
#>  9 ncaaf.p.276… Spencer Cur… Hawa… HAW               1             NA           
#> 10 ncaaf.p.276… Logan Lutui  BYU   BYU               NA            11           
#> # ℹ 190 more rows
#> # ℹ 83 more variables: field_goals_made_50_plus <chr>,
#> #   field_goals_40_to_49 <chr>, points_scored_kicking <chr>,
#> #   field_goal_attempts_30_39 <chr>, punt_return_yards <chr>,
#> #   receiving_touchdowns <chr>, longest_field_goal <chr>, solo_tackles <chr>,
#> #   field_goal_attempts_40_49 <chr>, punt_yards_per_punt <chr>,
#> #   longest_pass <chr>, punts <chr>, targets <chr>, …
# }
```
