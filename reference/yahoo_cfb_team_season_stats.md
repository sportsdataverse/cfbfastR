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
#> ℹ Data updated: 2026-10-12 01:34:14 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation passing_yards_per_game passing_attempts_allo…¹
#>    <chr>        <chr>             <chr>                  <chr>                  
#>  1 Clemson      CLEM              278.5                  33.4                   
#>  2 Duke         DUKE              244.3                  32.6                   
#>  3 Florida St.  FSU               180.3                  27.2                   
#>  4 Georgia Tech GT                237.5                  30.8                   
#>  5 Maryland     UMD               275.7                  32.0                   
#>  6 N. Carolina  UNC               224.4                  28.8                   
#>  7 NC State     NCST              232.6                  32.8                   
#>  8 Virginia     UVA               229.0                  32.7                   
#>  9 Wake Forest  WAKE              240.1                  37.9                   
#> 10 Boston Coll. BC                199.3                  33.9                   
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​passing_attempts_allowed_per_game
#> # ℹ 97 more variables: third_down_attempts <chr>, receptions <chr>,
#> #   rushing_yards_per_attempt <chr>, rushing_yards_allowed <chr>,
#> #   completion_percentage <chr>, sacks_taken <chr>,
#> #   passing_yards_per_attempt <chr>, offensive_penalties <chr>,
#> #   rushing_attempts_per_game <chr>, longest_pass <chr>, …
# }
```
