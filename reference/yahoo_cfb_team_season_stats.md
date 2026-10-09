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
#> ℹ Data updated: 2026-10-09 05:41:22 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation fourth_down_conversion_percent…¹ games_passing
#>    <chr>        <chr>             <chr>                            <chr>        
#>  1 Clemson      CLEM              57.1                             14           
#>  2 Duke         DUKE              38.9                             13           
#>  3 Florida St.  FSU               62.5                             12           
#>  4 Georgia Tech GT                55.2                             13           
#>  5 Maryland     UMD               45.2                             12           
#>  6 N. Carolina  UNC               48.1                             13           
#>  7 NC State     NCST              55.0                             13           
#>  8 Virginia     UVA               51.7                             12           
#>  9 Wake Forest  WAKE              64.0                             12           
#> 10 Boston Coll. BC                45.9                             13           
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​fourth_down_conversion_percentage
#> # ℹ 97 more variables: rushing_yards_per_game_rank <chr>,
#> #   total_yards_allowed_per_game_rank <chr>, sacks_taken <chr>,
#> #   passing_yards_per_game <chr>, rushing_yards_per_game <chr>,
#> #   passing_yards_allowed_per_game_rank <chr>,
#> #   receiving_yards_allowed_per_game <chr>, points <chr>, …
# }
```
