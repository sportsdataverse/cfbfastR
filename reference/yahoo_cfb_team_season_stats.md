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
#> ℹ Data updated: 2026-09-30 23:25:32 UTC
#> # A tibble: 134 × 101
#>    team     team_abbreviation receiving_yards_rank points rushing_yards_per_at…¹
#>    <chr>    <chr>             <chr>                <chr>  <chr>                 
#>  1 Clemson  CLEM              15                   486    5.1                   
#>  2 Duke     DUKE              46                   342    3.2                   
#>  3 Florida… FSU               118                  185    2.9                   
#>  4 Georgia… GT                56                   376    5.0                   
#>  5 Maryland UMD               17                   284    3.6                   
#>  6 N. Caro… UNC               74                   402    4.8                   
#>  7 NC State NCST              60                   371    4.5                   
#>  8 Virginia UVA               66                   272    3.7                   
#>  9 Wake Fo… WAKE              51                   308    3.5                   
#> 10 Boston … BC                100                  366    4.1                   
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​rushing_yards_per_attempt
#> # ℹ 96 more variables: receiving_yards_allowed_per_game <chr>,
#> #   passing_yards_per_game_rank <chr>, rushing_attempts_per_game <chr>,
#> #   rushing_attempts_allowed_per_game <chr>,
#> #   receiving_touchdowns_allowed <chr>, games_punting <chr>,
#> #   rushing_yards_rank <chr>, rushing_yards_per_game_rank <chr>, …
# }
```
