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
#> ℹ Data updated: 2026-09-26 06:53:40 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation receiving_yards_per_r…¹ receiving_touchdowns…²
#>    <chr>        <chr>             <chr>                   <chr>                 
#>  1 Clemson      CLEM              11.8                    22                    
#>  2 Duke         DUKE              11.4                    19                    
#>  3 Florida St.  FSU               12.1                    16                    
#>  4 Georgia Tech GT                11.5                    24                    
#>  5 Maryland     UMD               10.5                    22                    
#>  6 N. Carolina  UNC               12.7                    19                    
#>  7 NC State     NCST              11.9                    19                    
#>  8 Virginia     UVA               11.2                    20                    
#>  9 Wake Forest  WAKE              11.6                    23                    
#> 10 Boston Coll. BC                12.5                    17                    
#> # ℹ 124 more rows
#> # ℹ abbreviated names: ¹​receiving_yards_per_reception,
#> #   ²​receiving_touchdowns_allowed
#> # ℹ 97 more variables: points_per_game <chr>, games_punting <chr>,
#> #   receptions_per_game <chr>, receiving_first_downs <chr>,
#> #   receiving_yards <chr>, rushing_yards_per_attempt <chr>,
#> #   passing_attempts <chr>, third_down_conversion_percentage <chr>, …
# }
```
