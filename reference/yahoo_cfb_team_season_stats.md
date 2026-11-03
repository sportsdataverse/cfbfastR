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
#> ℹ Data updated: 2026-11-03 23:36:12 UTC
#> # A tibble: 134 × 101
#>    team     team_abbreviation points total_offensive_yards receiving_first_downs
#>    <chr>    <chr>             <chr>  <chr>                 <chr>                
#>  1 Clemson  CLEM              486    6326                  170                  
#>  2 Duke     DUKE              342    4378                  141                  
#>  3 Florida… FSU               185    3243                  103                  
#>  4 Georgia… GT                376    5519                  138                  
#>  5 Maryland UMD               284    4633                  157                  
#>  6 N. Caro… UNC               402    5287                  122                  
#>  7 NC State NCST              371    4911                  137                  
#>  8 Virginia UVA               272    4331                  116                  
#>  9 Wake Fo… WAKE              308    4448                  137                  
#> 10 Boston … BC                366    4750                  112                  
#> # ℹ 124 more rows
#> # ℹ 96 more variables: total_yards_allowed_per_game_rank <chr>,
#> #   receptions <chr>, points_rank <chr>, passing_yards_allowed_per_game <chr>,
#> #   passing_yards_allowed <chr>, first_downs <chr>,
#> #   rushing_yards_allowed <chr>, completion_percentage <chr>,
#> #   rushing_yards_allowed_per_game <chr>, interceptions_forced_rank <chr>,
#> #   receptions_per_game <chr>, rushing_touchdowns <chr>, …
# }
```
