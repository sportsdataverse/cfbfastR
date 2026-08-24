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
#> ℹ Data updated: 2026-08-24 12:16:07 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation interception_return_t…¹ passing_yards_per_game
#>    <chr>        <chr>             <chr>                   <chr>                 
#>  1 Clemson      CLEM              2                       278.5                 
#>  2 Duke         DUKE              1                       244.3                 
#>  3 Florida St.  FSU               0                       180.3                 
#>  4 Georgia Tech GT                1                       237.5                 
#>  5 Maryland     UMD               0                       275.7                 
#>  6 N. Carolina  UNC               3                       224.4                 
#>  7 NC State     NCST              2                       232.6                 
#>  8 Virginia     UVA               0                       229.0                 
#>  9 Wake Forest  WAKE              0                       240.1                 
#> 10 Boston Coll. BC                3                       199.3                 
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​interception_return_touchdowns
#> # ℹ 97 more variables: completion_percentage_allowed <chr>,
#> #   rushing_first_downs_allowed <chr>,
#> #   rushing_yards_allowed_per_game_rank <chr>, receiving_touchdowns <chr>,
#> #   receiving_first_downs_allowed <chr>, points_allowed_per_game <chr>,
#> #   passing_touchdowns_allowed <chr>, rushing_yards <chr>, …
# }
```
