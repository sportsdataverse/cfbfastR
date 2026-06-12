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
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 14:24:37 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation games_rushing rushing_yards_allowed_per_atte…¹
#>    <chr>        <chr>             <chr>         <chr>                           
#>  1 Clemson      CLEM              14            4.7                             
#>  2 Duke         DUKE              13            3.7                             
#>  3 Florida St.  FSU               12            4.6                             
#>  4 Georgia Tech GT                13            4.1                             
#>  5 Maryland     UMD               12            3.8                             
#>  6 N. Carolina  UNC               13            3.9                             
#>  7 NC State     NCST              13            4.8                             
#>  8 Virginia     UVA               12            4.1                             
#>  9 Wake Forest  WAKE              12            4.6                             
#> 10 Boston Coll. BC                13            3.6                             
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​rushing_yards_allowed_per_attempt
#> # ℹ 97 more variables: time_of_possession_per_game <chr>,
#> #   passing_yards_per_game_rank <chr>, points_allowed <chr>,
#> #   receiving_yards_allowed_per_game <chr>, passing_yards_rank <chr>,
#> #   points_rank <chr>, rushing_touchdowns <chr>, fourth_down_conversions <chr>,
#> #   receiving_touchdowns_allowed <chr>, completion_percentage_allowed <chr>, …
# }
```
