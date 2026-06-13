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
#> ℹ Data updated: 2026-06-13 02:53:38 UTC
#> # A tibble: 134 × 101
#>    team     team_abbreviation team_penalty_yards_l…¹ passing_yards rushing_yards
#>    <chr>    <chr>             <chr>                  <chr>         <chr>        
#>  1 Clemson  CLEM              667                    3899          2427         
#>  2 Duke     DUKE              651                    3176          1202         
#>  3 Florida… FSU               575                    2164          1079         
#>  4 Georgia… GT                558                    3088          2431         
#>  5 Maryland UMD               703                    3308          1325         
#>  6 N. Caro… UNC               832                    2917          2370         
#>  7 NC State NCST              621                    3024          1887         
#>  8 Virginia UVA               544                    2748          1583         
#>  9 Wake Fo… WAKE              551                    2881          1567         
#> 10 Boston … BC                560                    2591          2159         
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​team_penalty_yards_lost
#> # ℹ 96 more variables: interceptions_forced_rank <chr>,
#> #   rushing_yards_allowed_per_game <chr>,
#> #   rushing_attempts_allowed_per_game <chr>,
#> #   total_offensive_yards_per_game <chr>, receiving_yards_allowed <chr>,
#> #   passing_yards_per_game_rank <chr>, interception_return_touchdowns <chr>, …
# }
```
