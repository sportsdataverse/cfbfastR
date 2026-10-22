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
#> ℹ Data updated: 2026-10-22 17:22:17 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation rushing_attempts points_per_game first_downs
#>    <chr>        <chr>             <chr>            <chr>           <chr>      
#>  1 Clemson      CLEM              473              34.7            337        
#>  2 Duke         DUKE              381              26.3            229        
#>  3 Florida St.  FSU               378              15.4            182        
#>  4 Georgia Tech GT                491              28.9            282        
#>  5 Maryland     UMD               370              23.7            259        
#>  6 N. Carolina  UNC               496              30.9            272        
#>  7 NC State     NCST              421              28.5            263        
#>  8 Virginia     UVA               432              22.7            234        
#>  9 Wake Forest  WAKE              444              25.7            262        
#> 10 Boston Coll. BC                529              28.2            251        
#> # ℹ 124 more rows
#> # ℹ 96 more variables: rushing_yards_rank <chr>, passing_first_downs <chr>,
#> #   passing_yards_per_game_rank <chr>, longest_pass <chr>,
#> #   passing_first_downs_allowed <chr>,
#> #   passing_yards_allowed_per_game_rank <chr>,
#> #   fourth_down_conversion_percentage <chr>, points_rank <chr>,
#> #   rushing_first_downs_allowed <chr>, passing_attempts_per_game <chr>, …
# }
```
