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
#> ℹ Data updated: 2026-09-07 06:41:45 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation third_down_conversion_per…¹ passing_yards_rank
#>    <chr>        <chr>             <chr>                       <chr>             
#>  1 Clemson      CLEM              44.2                        16                
#>  2 Duke         DUKE              29.5                        46                
#>  3 Florida St.  FSU               28.8                        118               
#>  4 Georgia Tech GT                40.6                        56                
#>  5 Maryland     UMD               40.0                        18                
#>  6 N. Carolina  UNC               37.5                        74                
#>  7 NC State     NCST              37.4                        60                
#>  8 Virginia     UVA               34.1                        66                
#>  9 Wake Forest  WAKE              39.2                        51                
#> 10 Boston Coll. BC                43.6                        100               
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​third_down_conversion_percentage
#> # ℹ 97 more variables: games_kicking <chr>, passing_first_downs <chr>,
#> #   games_passing <chr>, points_allowed <chr>, points_rank <chr>,
#> #   sacks_taken <chr>, rushing_yards_per_attempt <chr>,
#> #   rushing_yards_per_game <chr>, total_offensive_yards_per_game <chr>,
#> #   passing_interceptions <chr>, points_allowed_per_game <chr>, …
# }
```
