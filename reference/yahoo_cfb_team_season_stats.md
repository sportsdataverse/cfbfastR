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
#> ℹ Data updated: 2026-10-01 04:50:28 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation rushing_attempts_per_…¹ rushing_yards_allowe…²
#>    <chr>        <chr>             <chr>                   <chr>                 
#>  1 Clemson      CLEM              33.8                    4.7                   
#>  2 Duke         DUKE              29.3                    3.7                   
#>  3 Florida St.  FSU               31.5                    4.6                   
#>  4 Georgia Tech GT                37.8                    4.1                   
#>  5 Maryland     UMD               30.8                    3.8                   
#>  6 N. Carolina  UNC               38.2                    3.9                   
#>  7 NC State     NCST              32.4                    4.8                   
#>  8 Virginia     UVA               36.0                    4.1                   
#>  9 Wake Forest  WAKE              37.0                    4.6                   
#> 10 Boston Coll. BC                40.7                    3.6                   
#> # ℹ 124 more rows
#> # ℹ abbreviated names: ¹​rushing_attempts_per_game,
#> #   ²​rushing_yards_allowed_per_attempt
#> # ℹ 97 more variables: team_penalty_yards_lost <chr>,
#> #   receiving_yards_per_game <chr>, receiving_yards_rank <chr>,
#> #   receiving_yards_allowed <chr>, passing_first_downs <chr>,
#> #   rushing_first_downs <chr>, rushing_attempts <chr>, longest_pass <chr>, …
# }
```
