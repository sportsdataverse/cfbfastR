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
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-01 16:39:15 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation team_penalties total_yards_allowed_per_game
#>    <chr>        <chr>             <chr>          <chr>                       
#>  1 Clemson      CLEM              69             374.1                       
#>  2 Duke         DUKE              67             363.1                       
#>  3 Florida St.  FSU               67             385.9                       
#>  4 Georgia Tech GT                69             342.8                       
#>  5 Maryland     UMD               77             378.1                       
#>  6 N. Carolina  UNC               98             375.8                       
#>  7 NC State     NCST              66             390.8                       
#>  8 Virginia     UVA               62             408.3                       
#>  9 Wake Forest  WAKE              61             435.0                       
#> 10 Boston Coll. BC                58             360.7                       
#> # ℹ 124 more rows
#> # ℹ 97 more variables: interceptions_forced_rank <chr>,
#> #   rushing_attempts_per_game <chr>, receptions <chr>,
#> #   completion_percentage_allowed <chr>, passing_yards <chr>,
#> #   third_down_attempts <chr>, interception_return_touchdowns <chr>,
#> #   rushing_attempts_allowed_per_game <chr>, games_offense <chr>,
#> #   points_allowed_rank <chr>, total_offensive_yards <chr>, …
# }
```
