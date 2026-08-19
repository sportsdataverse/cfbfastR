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
#> ℹ Data updated: 2026-08-19 17:43:01 UTC
#> # A tibble: 191 × 88
#>    player_id    display_name team  team_abbreviation games_punting games_offense
#>    <chr>        <chr>        <chr> <chr>             <chr>         <chr>        
#>  1 ncaaf.p.647… Trey Sanders TCU   TCU               NA            5            
#>  2 ncaaf.p.176… Alexander D… Kenn… KENN              NA            2            
#>  3 ncaaf.p.177… Carson Kent  Pitt… PITT              NA            10           
#>  4 ncaaf.p.218… Eric Goins   Notr… ND                NA            NA           
#>  5 ncaaf.p.220… Rico Watson… Sout… S FLA             NA            1            
#>  6 ncaaf.p.263… Cam McCormi… Miam… MIA               NA            5            
#>  7 ncaaf.p.264… Danarius Jo… Kenn… KENN              NA            NA           
#>  8 ncaaf.p.270… Keenan Pili  Tenn… TENN              NA            NA           
#>  9 ncaaf.p.276… Spencer Cur… Hawa… HAW               NA            10           
#> 10 ncaaf.p.276… Logan Lutui  BYU   BYU               NA            1            
#> # ℹ 181 more rows
#> # ℹ 82 more variables: rushing_yards_per_attempt <chr>,
#> #   passing_yards_per_attempt <chr>, tackles_for_loss <chr>,
#> #   forced_fumbles <chr>, punts <chr>, receiving_yards <chr>,
#> #   total_tackles <chr>, passing_completions <chr>, punt_return_yards <chr>,
#> #   sacks_yards_lost <chr>, games_receiving <chr>, rushing_touchdowns <chr>,
#> #   safeties <chr>, passing_interceptions <chr>, games_returns <chr>, …
# }
```
