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
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 13:09:18 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation receptions_per_game receiving_touchdowns
#>    <chr>        <chr>             <chr>               <chr>               
#>  1 Clemson      CLEM              23.6                37                  
#>  2 Duke         DUKE              21.5                28                  
#>  3 Florida St.  FSU               14.9                11                  
#>  4 Georgia Tech GT                20.7                17                  
#>  5 Maryland     UMD               26.3                21                  
#>  6 N. Carolina  UNC               17.7                18                  
#>  7 NC State     NCST              19.6                21                  
#>  8 Virginia     UVA               20.5                16                  
#>  9 Wake Forest  WAKE              20.7                17                  
#> 10 Boston Coll. BC                15.9                24                  
#> # ℹ 124 more rows
#> # ℹ 97 more variables: total_yards_allowed_per_game_rank <chr>,
#> #   games_receiving <chr>, points_per_game <chr>,
#> #   passing_yards_allowed_per_game <chr>, receiving_yards_rank <chr>,
#> #   passing_yards_allowed <chr>, games_defense <chr>,
#> #   rushing_yards_allowed <chr>, total_offensive_yards <chr>,
#> #   passing_attempts <chr>, receiving_yards_per_game <chr>, …
# }
```
