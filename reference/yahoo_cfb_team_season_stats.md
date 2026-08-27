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
#> ℹ Data updated: 2026-08-27 20:34:18 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation first_downs fourth_down_conversions
#>    <chr>        <chr>             <chr>       <chr>                  
#>  1 Clemson      CLEM              337         12                     
#>  2 Duke         DUKE              229         7                      
#>  3 Florida St.  FSU               182         20                     
#>  4 Georgia Tech GT                282         16                     
#>  5 Maryland     UMD               259         14                     
#>  6 N. Carolina  UNC               272         13                     
#>  7 NC State     NCST              263         11                     
#>  8 Virginia     UVA               234         15                     
#>  9 Wake Forest  WAKE              262         16                     
#> 10 Boston Coll. BC                251         17                     
#> # ℹ 124 more rows
#> # ℹ 97 more variables: receptions_per_game <chr>,
#> #   passing_yards_per_game_rank <chr>, offensive_penalties <chr>,
#> #   sacks_rank <chr>, games_receiving <chr>, receiving_yards_rank <chr>,
#> #   passing_yards_allowed_per_game <chr>, total_offensive_yards_per_game <chr>,
#> #   rushing_attempts_per_game <chr>, rushing_first_downs_allowed <chr>,
#> #   rushing_attempts_allowed <chr>, passing_yards_rank <chr>, …
# }
```
