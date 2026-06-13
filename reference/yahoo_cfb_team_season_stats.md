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
#> ℹ Data updated: 2026-06-13 03:30:06 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation passing_yards_per_gam…¹ points_allowed_per_g…²
#>    <chr>        <chr>             <chr>                   <chr>                 
#>  1 Clemson      CLEM              24                      23.4                  
#>  2 Duke         DUKE              70                      24.5                  
#>  3 Florida St.  FSU               212                     28.0                  
#>  4 Georgia Tech GT                84                      25.6                  
#>  5 Maryland     UMD               26                      30.4                  
#>  6 N. Carolina  UNC               117                     28.1                  
#>  7 NC State     NCST              93                      30.2                  
#>  8 Virginia     UVA               102                     28.8                  
#>  9 Wake Forest  WAKE              76                      32.5                  
#> 10 Boston Coll. BC                174                     23.8                  
#> # ℹ 124 more rows
#> # ℹ abbreviated names: ¹​passing_yards_per_game_rank, ²​points_allowed_per_game
#> # ℹ 97 more variables: passing_attempts_allowed_per_game <chr>,
#> #   total_yards_allowed_per_game <chr>, games_receiving <chr>,
#> #   receiving_touchdowns_allowed <chr>, rushing_yards_rank <chr>,
#> #   offensive_penalty_yards_lost <chr>,
#> #   passing_touchdowns_allowed_per_game <chr>, longest_rush <chr>, …
# }
```
