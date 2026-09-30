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
#> ℹ Data updated: 2026-09-30 14:50:02 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation rushing_yards rushing_yards_allowed_per_game
#>    <chr>        <chr>             <chr>         <chr>                         
#>  1 Clemson      CLEM              2427          160.6                         
#>  2 Duke         DUKE              1202          149.6                         
#>  3 Florida St.  FSU               1079          184.7                         
#>  4 Georgia Tech GT                2431          122.2                         
#>  5 Maryland     UMD               1325          136.8                         
#>  6 N. Carolina  UNC               2370          149.5                         
#>  7 NC State     NCST              1887          157.0                         
#>  8 Virginia     UVA               1583          145.3                         
#>  9 Wake Forest  WAKE              1567          157.2                         
#> 10 Boston Coll. BC                2159          114.9                         
#> # ℹ 124 more rows
#> # ℹ 97 more variables: receiving_yards_allowed_per_game <chr>,
#> #   games_rushing <chr>, games_receiving <chr>,
#> #   rushing_attempts_per_game <chr>, passing_touchdowns <chr>,
#> #   receiving_yards_per_reception <chr>, rushing_yards_per_attempt <chr>,
#> #   team_penalty_yards_lost <chr>, rushing_yards_allowed <chr>,
#> #   rushing_yards_allowed_per_attempt <chr>, …
# }
```
