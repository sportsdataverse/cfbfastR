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
#> ℹ Data updated: 2026-06-12 22:30:06 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation passing_touchdowns total_offensive_yards_per…¹
#>    <chr>        <chr>             <chr>              <chr>                      
#>  1 Clemson      CLEM              37                 17                         
#>  2 Duke         DUKE              28                 191                        
#>  3 Florida St.  FSU               11                 260                        
#>  4 Georgia Tech GT                17                 52                         
#>  5 Maryland     UMD               21                 111                        
#>  6 N. Carolina  UNC               18                 76                         
#>  7 NC State     NCST              21                 128                        
#>  8 Virginia     UVA               16                 156                        
#>  9 Wake Forest  WAKE              17                 141                        
#> 10 Boston Coll. BC                24                 149                        
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​total_offensive_yards_per_game_rank
#> # ℹ 97 more variables: sacks_yards_lost <chr>, points_per_game <chr>,
#> #   passing_yards_allowed <chr>, rushing_yards_per_game_rank <chr>,
#> #   receptions <chr>, rushing_touchdowns <chr>, points_allowed <chr>,
#> #   sacks_taken <chr>, games_receiving <chr>,
#> #   passing_yards_per_game_rank <chr>, time_of_possession_per_game <chr>, …
# }
```
