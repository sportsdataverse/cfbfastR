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
#> ℹ Data updated: 2026-08-29 13:20:11 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation points_allowed passing_yards_per_attempt
#>    <chr>        <chr>             <chr>          <chr>                    
#>  1 Clemson      CLEM              328            7.3                      
#>  2 Duke         DUKE              318            6.8                      
#>  3 Florida St.  FSU               336            6.1                      
#>  4 Georgia Tech GT                333            7.5                      
#>  5 Maryland     UMD               365            6.7                      
#>  6 N. Carolina  UNC               365            7.4                      
#>  7 NC State     NCST              392            7.7                      
#>  8 Virginia     UVA               345            6.9                      
#>  9 Wake Forest  WAKE              390            7.1                      
#> 10 Boston Coll. BC                309            7.9                      
#> # ℹ 124 more rows
#> # ℹ 97 more variables: passing_completions_allowed_per_game <chr>,
#> #   rushing_touchdowns_allowed_per_game <chr>,
#> #   rushing_yards_allowed_per_game <chr>,
#> #   receiving_touchdowns_allowed_per_game <chr>, rushing_yards_rank <chr>,
#> #   completion_percentage_allowed <chr>, rushing_attempts_per_game <chr>,
#> #   passing_yards_allowed_per_game_rank <chr>, …
# }
```
