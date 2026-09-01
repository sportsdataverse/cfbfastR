# **Get Yahoo Sports college football team season stats (modern)**

Flattens the shangrila `leagueStatsByTeam` response into one wide tibble
with one row per team (all stat groups in one call).

## Usage

``` r
yahoo_cfb_team_season_stats(
  season = most_recent_cfb_season(),
  league_structure = "ncaaf.struct.div.1",
  count = 200
)
```

## Arguments

- season:

  (integer): Season year. Defaults to `most_recent_cfb_season()`.

- league_structure:

  (character): Division filter. Defaults to `"ncaaf.struct.div.1"`.

- count:

  (integer): Max teams. Defaults to `200`.

## Value

A `cfbfastR`-tagged tibble with one row per team: `team`,
`team_abbreviation`, `season`, plus one column per `statId`.

## See also

Other Yahoo CFB Functions:
[`yahoo_cfb_boxscore()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_boxscore.md),
[`yahoo_cfb_player_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats.md),
[`yahoo_cfb_player_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats_legacy.md),
[`yahoo_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_scoreboard.md),
[`yahoo_cfb_team_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats_legacy.md)

## Examples

``` r
# \donttest{
  try(yahoo_cfb_team_season_stats(season = 2024))
#> ── Team season stats from Yahoo Sports (shangrila) ────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-01 11:30:57 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation rushing_yards_per_game receiving_yards
#>    <chr>        <chr>             <chr>                  <chr>          
#>  1 Clemson      CLEM              173.4                  3908           
#>  2 Duke         DUKE              92.5                   3180           
#>  3 Florida St.  FSU               89.9                   2164           
#>  4 Georgia Tech GT                187.0                  3088           
#>  5 Maryland     UMD               110.4                  3320           
#>  6 N. Carolina  UNC               182.3                  2919           
#>  7 NC State     NCST              145.2                  3031           
#>  8 Virginia     UVA               131.9                  2748           
#>  9 Wake Forest  WAKE              130.6                  2881           
#> 10 Boston Coll. BC                166.1                  2591           
#> # ℹ 124 more rows
#> # ℹ 97 more variables: receiving_touchdowns_allowed_per_game <chr>,
#> #   rushing_yards_per_game_rank <chr>, rushing_yards <chr>,
#> #   rushing_yards_allowed_per_attempt <chr>,
#> #   receiving_first_downs_allowed <chr>, games_punting <chr>,
#> #   points_allowed_rank <chr>, receptions_allowed_per_game <chr>,
#> #   points_allowed_per_game <chr>, …
# }
```
