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
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-04 03:48:50 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation passing_first_downs_a…¹ rushing_yards_allowe…²
#>    <chr>        <chr>             <chr>                   <chr>                 
#>  1 Clemson      CLEM              133                     4.7                   
#>  2 Duke         DUKE              123                     3.7                   
#>  3 Florida St.  FSU               110                     4.6                   
#>  4 Georgia Tech GT                125                     4.1                   
#>  5 Maryland     UMD               126                     3.8                   
#>  6 N. Carolina  UNC               112                     3.9                   
#>  7 NC State     NCST              133                     4.8                   
#>  8 Virginia     UVA               123                     4.1                   
#>  9 Wake Forest  WAKE              170                     4.6                   
#> 10 Boston Coll. BC                153                     3.6                   
#> # ℹ 124 more rows
#> # ℹ abbreviated names: ¹​passing_first_downs_allowed,
#> #   ²​rushing_yards_allowed_per_attempt
#> # ℹ 97 more variables: fourth_down_conversion_percentage <chr>,
#> #   receiving_yards_per_game <chr>, games_receiving <chr>,
#> #   rushing_touchdowns_allowed_per_game <chr>, passing_touchdowns <chr>,
#> #   rushing_attempts_per_game <chr>, passing_interceptions <chr>, …
# }
```
