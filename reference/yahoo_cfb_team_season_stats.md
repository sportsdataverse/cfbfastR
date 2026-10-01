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
#> ℹ Data updated: 2026-10-01 01:48:08 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation passing_yards_per_attempt sacks_rank
#>    <chr>        <chr>             <chr>                     <chr>     
#>  1 Clemson      CLEM              7.3                       36        
#>  2 Duke         DUKE              6.8                       5         
#>  3 Florida St.  FSU               6.1                       93        
#>  4 Georgia Tech GT                7.5                       208       
#>  5 Maryland     UMD               6.7                       243       
#>  6 N. Carolina  UNC               7.4                       11        
#>  7 NC State     NCST              7.7                       140       
#>  8 Virginia     UVA               6.9                       197       
#>  9 Wake Forest  WAKE              7.1                       178       
#> 10 Boston Coll. BC                7.9                       64        
#> # ℹ 124 more rows
#> # ℹ 97 more variables: passing_first_downs_allowed <chr>,
#> #   games_receiving <chr>, rushing_yards <chr>, games_kicking <chr>,
#> #   rushing_attempts_allowed_per_game <chr>, passing_attempts <chr>,
#> #   passing_yards <chr>, total_offensive_yards_per_game <chr>,
#> #   rushing_attempts <chr>, passing_yards_per_game <chr>, games_offense <chr>,
#> #   rushing_first_downs_allowed <chr>, first_downs <chr>, points <chr>, …
# }
```
