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
#> ℹ Data updated: 2026-09-30 20:42:38 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation rushing_attempts_per_…¹ rushing_yards_allowe…²
#>    <chr>        <chr>             <chr>                   <chr>                 
#>  1 Clemson      CLEM              33.8                    160.6                 
#>  2 Duke         DUKE              29.3                    149.6                 
#>  3 Florida St.  FSU               31.5                    184.7                 
#>  4 Georgia Tech GT                37.8                    122.2                 
#>  5 Maryland     UMD               30.8                    136.8                 
#>  6 N. Carolina  UNC               38.2                    149.5                 
#>  7 NC State     NCST              32.4                    157.0                 
#>  8 Virginia     UVA               36.0                    145.3                 
#>  9 Wake Forest  WAKE              37.0                    157.2                 
#> 10 Boston Coll. BC                40.7                    114.9                 
#> # ℹ 124 more rows
#> # ℹ abbreviated names: ¹​rushing_attempts_per_game,
#> #   ²​rushing_yards_allowed_per_game
#> # ℹ 97 more variables: points_rank <chr>, receiving_touchdowns_allowed <chr>,
#> #   longest_pass <chr>, sacks_rank <chr>,
#> #   rushing_yards_allowed_per_game_rank <chr>, first_downs_per_game <chr>,
#> #   receiving_yards_per_reception <chr>, rushing_attempts_allowed <chr>, …
# }
```
