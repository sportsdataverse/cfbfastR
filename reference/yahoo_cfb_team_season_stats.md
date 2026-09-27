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
#> ℹ Data updated: 2026-09-27 05:34:50 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation fourth_down_conversions passing_yards_rank
#>    <chr>        <chr>             <chr>                   <chr>             
#>  1 Clemson      CLEM              12                      16                
#>  2 Duke         DUKE              7                       46                
#>  3 Florida St.  FSU               20                      118               
#>  4 Georgia Tech GT                16                      56                
#>  5 Maryland     UMD               14                      18                
#>  6 N. Carolina  UNC               13                      74                
#>  7 NC State     NCST              11                      60                
#>  8 Virginia     UVA               15                      66                
#>  9 Wake Forest  WAKE              16                      51                
#> 10 Boston Coll. BC                17                      100               
#> # ℹ 124 more rows
#> # ℹ 97 more variables: total_yards_allowed_per_game <chr>,
#> #   passing_yards_per_attempt <chr>, rushing_yards_per_attempt <chr>,
#> #   passing_yards_allowed_per_game <chr>, receiving_yards_allowed <chr>,
#> #   completion_percentage <chr>, games_passing <chr>, receptions <chr>,
#> #   passing_touchdowns_allowed <chr>, passing_attempts_per_game <chr>,
#> #   receiving_touchdowns_allowed_per_game <chr>, …
# }
```
