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
#> ℹ Data updated: 2026-10-01 05:36:23 UTC
#> # A tibble: 134 × 101
#>    team   team_abbreviation total_offensive_yard…¹ receiving_yards games_offense
#>    <chr>  <chr>             <chr>                  <chr>           <chr>        
#>  1 Clems… CLEM              451.9                  3908            14           
#>  2 Duke   DUKE              336.8                  3180            13           
#>  3 Flori… FSU               270.3                  2164            12           
#>  4 Georg… GT                424.5                  3088            13           
#>  5 Maryl… UMD               386.1                  3320            12           
#>  6 N. Ca… UNC               406.7                  2919            13           
#>  7 NC St… NCST              377.8                  3031            13           
#>  8 Virgi… UVA               360.9                  2748            12           
#>  9 Wake … WAKE              370.7                  2881            12           
#> 10 Bosto… BC                365.4                  2591            13           
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​total_offensive_yards_per_game
#> # ℹ 96 more variables: receptions_per_game <chr>, points_per_game_rank <chr>,
#> #   passing_yards_allowed_per_game_rank <chr>,
#> #   passing_yards_allowed_per_game <chr>, rushing_attempts_allowed <chr>,
#> #   offensive_penalties <chr>, rushing_yards_allowed_per_attempt <chr>,
#> #   passing_yards <chr>, rushing_yards_allowed_per_game_rank <chr>, …
# }
```
