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
#> ℹ Data updated: 2026-09-27 07:50:37 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation games_kicking longest_pass games_rushing
#>    <chr>        <chr>             <chr>         <chr>        <chr>        
#>  1 Clemson      CLEM              14            76           14           
#>  2 Duke         DUKE              13            86           13           
#>  3 Florida St.  FSU               12            71           12           
#>  4 Georgia Tech GT                13            60           13           
#>  5 Maryland     UMD               12            75           12           
#>  6 N. Carolina  UNC               13            58           13           
#>  7 NC State     NCST              13            75           13           
#>  8 Virginia     UVA               12            68           12           
#>  9 Wake Forest  WAKE              12            51           12           
#> 10 Boston Coll. BC                13            72           13           
#> # ℹ 124 more rows
#> # ℹ 96 more variables: rushing_yards_allowed <chr>,
#> #   receiving_touchdowns_allowed_per_game <chr>, receiving_yards_allowed <chr>,
#> #   passing_yards_per_attempt <chr>, total_offensive_yards <chr>,
#> #   passing_yards_allowed_per_game_rank <chr>,
#> #   rushing_yards_allowed_per_attempt <chr>, points_per_game_rank <chr>,
#> #   points_rank <chr>, rushing_yards_per_game_rank <chr>, …
# }
```
