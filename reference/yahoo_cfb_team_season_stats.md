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
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 15:33:39 UTC
#> # A tibble: 134 × 101
#>    team       team_abbreviation team_penalties total_yards_allowed_…¹ sacks_rank
#>    <chr>      <chr>             <chr>          <chr>                  <chr>     
#>  1 Clemson    CLEM              69             161                    36        
#>  2 Duke       DUKE              67             139                    5         
#>  3 Florida S… FSU               67             187                    93        
#>  4 Georgia T… GT                69             100                    208       
#>  5 Maryland   UMD               77             175                    243       
#>  6 N. Caroli… UNC               98             165                    11        
#>  7 NC State   NCST              66             192                    140       
#>  8 Virginia   UVA               62             219                    197       
#>  9 Wake Fore… WAKE              61             263                    178       
#> 10 Boston Co… BC                58             132                    64        
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​total_yards_allowed_per_game_rank
#> # ℹ 96 more variables: rushing_attempts_per_game <chr>, receptions <chr>,
#> #   passing_touchdowns_allowed <chr>, passing_yards <chr>,
#> #   third_down_attempts <chr>, interception_return_touchdowns <chr>,
#> #   rushing_yards_allowed <chr>, points_allowed_per_game_rank <chr>,
#> #   games_offense <chr>, total_yards_allowed_per_game <chr>, …
# }
```
