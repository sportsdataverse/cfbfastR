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
#> ℹ Data updated: 2026-06-24 02:10:59 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation rushing_yards total_offensive_yards_per_game
#>    <chr>        <chr>             <chr>         <chr>                         
#>  1 Clemson      CLEM              2427          451.9                         
#>  2 Duke         DUKE              1202          336.8                         
#>  3 Florida St.  FSU               1079          270.3                         
#>  4 Georgia Tech GT                2431          424.5                         
#>  5 Maryland     UMD               1325          386.1                         
#>  6 N. Carolina  UNC               2370          406.7                         
#>  7 NC State     NCST              1887          377.8                         
#>  8 Virginia     UVA               1583          360.9                         
#>  9 Wake Forest  WAKE              1567          370.7                         
#> 10 Boston Coll. BC                2159          365.4                         
#> # ℹ 124 more rows
#> # ℹ 97 more variables: rushing_touchdowns_allowed <chr>,
#> #   passing_completions_per_game <chr>, third_down_attempts <chr>,
#> #   rushing_yards_rank <chr>, rushing_yards_allowed <chr>, games_punting <chr>,
#> #   offensive_penalty_yards_lost <chr>, receiving_first_downs_allowed <chr>,
#> #   points_allowed_per_game <chr>, first_downs_per_game <chr>,
#> #   passing_completions <chr>, points <chr>, receptions <chr>, …
# }
```
