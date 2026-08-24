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
#> ℹ Data updated: 2026-08-24 11:42:40 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation receiving_yards_rank completion_percentage
#>    <chr>        <chr>             <chr>                <chr>                
#>  1 Clemson      CLEM              15                   62.1                 
#>  2 Duke         DUKE              46                   60.0                 
#>  3 Florida St.  FSU               118                  50.4                 
#>  4 Georgia Tech GT                56                   65.3                 
#>  5 Maryland     UMD               17                   63.8                 
#>  6 N. Carolina  UNC               74                   58.7                 
#>  7 NC State     NCST              60                   65.2                 
#>  8 Virginia     UVA               66                   61.3                 
#>  9 Wake Forest  WAKE              51                   61.4                 
#> 10 Boston Coll. BC                100                  62.7                 
#> # ℹ 124 more rows
#> # ℹ 97 more variables: receiving_yards_allowed <chr>,
#> #   passing_completions <chr>, rushing_attempts_allowed <chr>,
#> #   rushing_first_downs <chr>, passing_touchdowns_allowed <chr>,
#> #   passing_attempts_per_game <chr>, receptions_per_game <chr>,
#> #   rushing_attempts_per_game <chr>, rushing_yards_per_game_rank <chr>,
#> #   receiving_touchdowns_allowed <chr>, total_offensive_yards_per_game <chr>, …
# }
```
