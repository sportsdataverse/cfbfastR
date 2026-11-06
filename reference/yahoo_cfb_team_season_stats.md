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
#> ℹ Data updated: 2026-11-06 08:27:45 UTC
#> # A tibble: 10 × 101
#>    team         team_abbreviation total_offensive_yards_per…¹ rushing_touchdowns
#>    <chr>        <chr>             <chr>                       <chr>             
#>  1 Clemson      CLEM              451.9                       23                
#>  2 Duke         DUKE              336.8                       13                
#>  3 Florida St.  FSU               270.3                       8                 
#>  4 Georgia Tech GT                424.5                       29                
#>  5 Maryland     UMD               386.1                       15                
#>  6 N. Carolina  UNC               406.7                       26                
#>  7 NC State     NCST              377.8                       21                
#>  8 Virginia     UVA               360.9                       14                
#>  9 Wake Forest  WAKE              370.7                       18                
#> 10 Boston Coll. BC                365.4                       24                
#> # ℹ abbreviated name: ¹​total_offensive_yards_per_game
#> # ℹ 97 more variables: receiving_yards_per_game <chr>,
#> #   receiving_first_downs_allowed <chr>, rushing_yards_rank <chr>,
#> #   rushing_yards_per_game <chr>, rushing_yards_allowed_per_game <chr>,
#> #   points_allowed_per_game_rank <chr>, receiving_yards_allowed <chr>,
#> #   points_allowed_rank <chr>, completion_percentage_allowed <chr>,
#> #   third_down_conversion_percentage <chr>, …
# }
```
