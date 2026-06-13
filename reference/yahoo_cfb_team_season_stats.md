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
#> ℹ Data updated: 2026-06-13 04:24:42 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation third_down_attempts passing_completions_per_…¹
#>    <chr>        <chr>             <chr>               <chr>                     
#>  1 Clemson      CLEM              197                 23.6                      
#>  2 Duke         DUKE              176                 21.5                      
#>  3 Florida St.  FSU               160                 14.9                      
#>  4 Georgia Tech GT                170                 20.7                      
#>  5 Maryland     UMD               180                 26.3                      
#>  6 N. Carolina  UNC               176                 17.7                      
#>  7 NC State     NCST              155                 19.6                      
#>  8 Virginia     UVA               182                 20.5                      
#>  9 Wake Forest  WAKE              171                 20.7                      
#> 10 Boston Coll. BC                179                 15.9                      
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​passing_completions_per_game
#> # ℹ 97 more variables: points_allowed_per_game <chr>, passing_touchdowns <chr>,
#> #   total_yards_allowed_per_game_rank <chr>, offensive_penalties <chr>,
#> #   passing_attempts_allowed_per_game <chr>,
#> #   time_of_possession_per_game_rank <chr>, rushing_yards_per_game <chr>,
#> #   receiving_yards_allowed <chr>, total_offensive_yards_rank <chr>, …
# }
```
