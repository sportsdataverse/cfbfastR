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
#> ℹ Data updated: 2026-09-07 09:26:01 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation passing_completions passing_completions_allo…¹
#>    <chr>        <chr>             <chr>               <chr>                     
#>  1 Clemson      CLEM              331                 18.8                      
#>  2 Duke         DUKE              280                 18.9                      
#>  3 Florida St.  FSU               179                 17.0                      
#>  4 Georgia Tech GT                269                 19.5                      
#>  5 Maryland     UMD               315                 20.0                      
#>  6 N. Carolina  UNC               230                 16.7                      
#>  7 NC State     NCST              255                 20.1                      
#>  8 Virginia     UVA               246                 20.3                      
#>  9 Wake Forest  WAKE              248                 26.7                      
#> 10 Boston Coll. BC                207                 20.8                      
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​passing_completions_allowed_per_game
#> # ℹ 97 more variables: passing_yards_allowed <chr>,
#> #   rushing_yards_per_game <chr>, passing_first_downs <chr>,
#> #   receiving_yards <chr>, passing_first_downs_allowed <chr>,
#> #   longest_pass <chr>, fourth_down_attempts <chr>, sacks_taken <chr>,
#> #   passing_attempts <chr>, receiving_touchdowns <chr>, …
# }
```
