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
#> ℹ Data updated: 2026-10-30 00:18:30 UTC
#> # A tibble: 134 × 101
#>    team   team_abbreviation points_per_game games_passing fourth_down_conversi…¹
#>    <chr>  <chr>             <chr>           <chr>         <chr>                 
#>  1 Clems… CLEM              34.7            14            57.1                  
#>  2 Duke   DUKE              26.3            13            38.9                  
#>  3 Flori… FSU               15.4            12            62.5                  
#>  4 Georg… GT                28.9            13            55.2                  
#>  5 Maryl… UMD               23.7            12            45.2                  
#>  6 N. Ca… UNC               30.9            13            48.1                  
#>  7 NC St… NCST              28.5            13            55.0                  
#>  8 Virgi… UVA               22.7            12            51.7                  
#>  9 Wake … WAKE              25.7            12            64.0                  
#> 10 Bosto… BC                28.2            13            45.9                  
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​fourth_down_conversion_percentage
#> # ℹ 96 more variables: passing_completions <chr>, first_downs_per_game <chr>,
#> #   passing_touchdowns_allowed <chr>, receiving_first_downs <chr>,
#> #   longest_pass <chr>, passing_yards_per_game_rank <chr>,
#> #   interceptions_forced <chr>, passing_first_downs_allowed <chr>,
#> #   offensive_penalties <chr>, fourth_down_conversions <chr>, …
# }
```
