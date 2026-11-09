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
  try(yahoo_cfb_team_season_stats(season = 2024, count = 10))
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:44:20 UTC
#> # A tibble: 10 × 101
#>    team         team_abbreviation completion_percentage passing_yards_allowed_…¹
#>    <chr>        <chr>             <chr>                 <chr>                   
#>  1 Clemson      CLEM              62.1                  143                     
#>  2 Duke         DUKE              60.0                  142                     
#>  3 Florida St.  FSU               50.4                  110                     
#>  4 Georgia Tech GT                65.3                  169                     
#>  5 Maryland     UMD               63.8                  241                     
#>  6 N. Carolina  UNC               58.7                  188                     
#>  7 NC State     NCST              65.2                  212                     
#>  8 Virginia     UVA               61.3                  271                     
#>  9 Wake Forest  WAKE              61.4                  282                     
#> 10 Boston Coll. BC                62.7                  249                     
#> # ℹ abbreviated name: ¹​passing_yards_allowed_per_game_rank
#> # ℹ 97 more variables: passing_touchdowns_allowed <chr>,
#> #   rushing_touchdowns <chr>, rushing_attempts <chr>,
#> #   receiving_yards_per_game <chr>, passing_attempts <chr>,
#> #   games_passing <chr>, games_offense <chr>,
#> #   fourth_down_conversion_percentage <chr>, passing_first_downs <chr>,
#> #   passing_yards <chr>, rushing_touchdowns_allowed <chr>, …
# }
```
