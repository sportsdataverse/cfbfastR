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
#> ℹ Data updated: 2026-09-30 11:17:28 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation sacks_taken rushing_yards_allowed…¹ receptions
#>    <chr>        <chr>             <chr>       <chr>                   <chr>     
#>  1 Clemson      CLEM              25          160.6                   331       
#>  2 Duke         DUKE              12          149.6                   280       
#>  3 Florida St.  FSU               49          184.7                   179       
#>  4 Georgia Tech GT                9           122.2                   269       
#>  5 Maryland     UMD               26          136.8                   315       
#>  6 N. Carolina  UNC               33          149.5                   230       
#>  7 NC State     NCST              28          157.0                   255       
#>  8 Virginia     UVA               47          145.3                   246       
#>  9 Wake Forest  WAKE              41          157.2                   248       
#> 10 Boston Coll. BC                32          114.9                   207       
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​rushing_yards_allowed_per_game
#> # ℹ 96 more variables: rushing_first_downs_allowed <chr>, rushing_yards <chr>,
#> #   passing_attempts <chr>, rushing_first_downs <chr>, points_allowed <chr>,
#> #   receiving_yards_rank <chr>, sacks_yards_lost <chr>, points <chr>,
#> #   receiving_touchdowns_allowed <chr>,
#> #   fourth_down_conversion_percentage <chr>, …
# }
```
