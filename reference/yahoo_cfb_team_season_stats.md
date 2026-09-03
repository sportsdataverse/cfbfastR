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
#> ℹ Data updated: 2026-09-03 22:43:58 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation interceptions_forced games_offense sacks_taken
#>    <chr>        <chr>             <chr>                <chr>         <chr>      
#>  1 Clemson      CLEM              16                   14            25         
#>  2 Duke         DUKE              13                   13            12         
#>  3 Florida St.  FSU               4                    12            49         
#>  4 Georgia Tech GT                5                    13            9          
#>  5 Maryland     UMD               9                    12            26         
#>  6 N. Carolina  UNC               9                    13            33         
#>  7 NC State     NCST              10                   13            28         
#>  8 Virginia     UVA               9                    12            47         
#>  9 Wake Forest  WAKE              11                   12            41         
#> 10 Boston Coll. BC                17                   13            32         
#> # ℹ 124 more rows
#> # ℹ 96 more variables: rushing_yards_per_game <chr>,
#> #   rushing_touchdowns_allowed_per_game <chr>, first_downs_per_game <chr>,
#> #   passing_interceptions <chr>, completion_percentage_allowed <chr>,
#> #   rushing_first_downs_allowed <chr>, time_of_possession_per_game_rank <chr>,
#> #   rushing_yards_allowed_per_attempt <chr>, time_of_possession_per_game <chr>,
#> #   total_yards_allowed_per_game <chr>, receiving_first_downs <chr>, …
# }
```
