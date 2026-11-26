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
  try(yahoo_cfb_team_season_stats(season = 2024, count = 10))
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-26 22:54:33 UTC
#> # A tibble: 10 × 101
#>    team         team_abbreviation passing_yards_per_game passing_first_downs
#>    <chr>        <chr>             <chr>                  <chr>              
#>  1 Clemson      CLEM              278.5                  170                
#>  2 Duke         DUKE              244.3                  141                
#>  3 Florida St.  FSU               180.3                  103                
#>  4 Georgia Tech GT                237.5                  138                
#>  5 Maryland     UMD               275.7                  157                
#>  6 N. Carolina  UNC               224.4                  122                
#>  7 NC State     NCST              232.6                  137                
#>  8 Virginia     UVA               229.0                  116                
#>  9 Wake Forest  WAKE              240.1                  137                
#> 10 Boston Coll. BC                199.3                  112                
#> # ℹ 97 more variables: rushing_attempts_allowed_per_game <chr>,
#> #   receiving_touchdowns_allowed <chr>, games_defense <chr>,
#> #   receptions_allowed_per_game <chr>, passing_yards <chr>,
#> #   games_offense <chr>, passing_yards_allowed_per_game <chr>,
#> #   rushing_yards_allowed <chr>, points_rank <chr>, receptions_per_game <chr>,
#> #   passing_first_downs_allowed <chr>, points_per_game <chr>,
#> #   passing_yards_rank <chr>, receiving_yards_per_reception <chr>, …
# }
```
