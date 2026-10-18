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
#> ℹ Data updated: 2026-10-18 11:44:06 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation rushing_yards receiving_touchdowns
#>    <chr>        <chr>             <chr>         <chr>               
#>  1 Clemson      CLEM              2427          37                  
#>  2 Duke         DUKE              1202          28                  
#>  3 Florida St.  FSU               1079          11                  
#>  4 Georgia Tech GT                2431          17                  
#>  5 Maryland     UMD               1325          21                  
#>  6 N. Carolina  UNC               2370          18                  
#>  7 NC State     NCST              1887          21                  
#>  8 Virginia     UVA               1583          16                  
#>  9 Wake Forest  WAKE              1567          17                  
#> 10 Boston Coll. BC                2159          24                  
#> # ℹ 124 more rows
#> # ℹ 97 more variables: points_per_game_rank <chr>, third_down_attempts <chr>,
#> #   points_allowed_rank <chr>, rushing_attempts <chr>,
#> #   rushing_yards_per_game_rank <chr>, sacks_rank <chr>,
#> #   total_offensive_yards_per_game_rank <chr>, games_passing <chr>,
#> #   passing_yards_rank <chr>, passing_yards_allowed_per_game_rank <chr>,
#> #   total_yards_allowed_per_game <chr>, games_defense <chr>, …
# }
```
