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
#> ℹ Data updated: 2026-08-27 11:54:49 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation longest_pass completion_percentage_allowed
#>    <chr>        <chr>             <chr>        <chr>                        
#>  1 Clemson      CLEM              76           56.3                         
#>  2 Duke         DUKE              86           58.0                         
#>  3 Florida St.  FSU               71           62.6                         
#>  4 Georgia Tech GT                60           63.1                         
#>  5 Maryland     UMD               75           62.5                         
#>  6 N. Carolina  UNC               58           58.0                         
#>  7 NC State     NCST              75           61.3                         
#>  8 Virginia     UVA               68           62.0                         
#>  9 Wake Forest  WAKE              51           70.3                         
#> 10 Boston Coll. BC                72           61.5                         
#> # ℹ 124 more rows
#> # ℹ 97 more variables: rushing_attempts_allowed <chr>,
#> #   third_down_conversions <chr>, receptions_per_game <chr>,
#> #   rushing_yards_per_game <chr>, receiving_touchdowns <chr>,
#> #   rushing_yards_allowed_per_game <chr>, passing_yards <chr>,
#> #   sacks_yards_lost <chr>, passing_yards_per_game <chr>,
#> #   offensive_penalty_yards_lost <chr>, rushing_yards <chr>, …
# }
```
