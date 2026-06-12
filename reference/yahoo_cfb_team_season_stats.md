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
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 13:16:57 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation interception_return_t…¹ rushing_yards_per_game
#>    <chr>        <chr>             <chr>                   <chr>                 
#>  1 Clemson      CLEM              2                       173.4                 
#>  2 Duke         DUKE              1                       92.5                  
#>  3 Florida St.  FSU               0                       89.9                  
#>  4 Georgia Tech GT                1                       187.0                 
#>  5 Maryland     UMD               0                       110.4                 
#>  6 N. Carolina  UNC               3                       182.3                 
#>  7 NC State     NCST              2                       145.2                 
#>  8 Virginia     UVA               0                       131.9                 
#>  9 Wake Forest  WAKE              0                       130.6                 
#> 10 Boston Coll. BC                3                       166.1                 
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​interception_return_touchdowns
#> # ℹ 97 more variables: receiving_touchdowns_allowed_per_game <chr>,
#> #   passing_yards_allowed <chr>, passing_interceptions <chr>,
#> #   games_offense <chr>, points_allowed <chr>, completion_percentage <chr>,
#> #   receptions_allowed_per_game <chr>, rushing_attempts <chr>,
#> #   passing_attempts_per_game <chr>, games_receiving <chr>, …
# }
```
