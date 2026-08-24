# **Get Yahoo Sports CFB legacy per-category team stats**

Flattens a legacy `seasonTeamStatsFootball{Category}` query into a wide
team tibble.

## Usage

``` r
yahoo_cfb_team_season_stats_legacy(
  season = most_recent_cfb_season(),
  category = "Passing",
  sort_stat = "PASSING_YARDS",
  league_structure = "ncaaf.struct.div.1",
  count = 200
)
```

## Arguments

- season:

  (integer): Season year. Defaults to `most_recent_cfb_season()`.

- category:

  (character): One of `Passing`, `Rushing`, `Receiving`, `Defense`,
  `Kicking`, `Punting`, `Returns`, `Kickoffs`, `Offense`. Defaults to
  `"Passing"`.

- sort_stat:

  (character): Required sort stat id. Defaults to `"PASSING_YARDS"`.

- league_structure:

  (character): Defaults to `"ncaaf.struct.div.1"`.

- count:

  (integer): Defaults to `200`.

## Value

A `cfbfastR`-tagged tibble: `team`, `team_abbreviation`, `season`,
`category`, plus one column per `statId`.

## See also

Other Yahoo CFB Functions:
[`yahoo_cfb_boxscore()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_boxscore.md),
[`yahoo_cfb_player_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats.md),
[`yahoo_cfb_player_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats_legacy.md),
[`yahoo_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_scoreboard.md),
[`yahoo_cfb_team_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats.md)

## Examples

``` r
# \donttest{
  try(yahoo_cfb_team_season_stats_legacy(season = 2024, category = "Rushing",
                                         sort_stat = "RUSHING_YARDS"))
#> ── Legacy team season stats from Yahoo Sports (shangrila) ──── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 12:16:13 UTC
#> # A tibble: 134 × 15
#>    team           team_abbreviation games_rushing rushing_attempts rushing_yards
#>    <chr>          <chr>             <chr>         <chr>            <chr>        
#>  1 Army           ARMY              14            764              4207         
#>  2 Jacksonville … JVST              14            646              3517         
#>  3 UNLV           UNLV              14            623              3409         
#>  4 Boise St.      BSU               14            555              3365         
#>  5 Penn St.       PSU               16            615              3237         
#>  6 Navy           NAVY              13            592              3222         
#>  7 Notre Dame     ND                16            568              3215         
#>  8 New Mexico     UNM               12            456              3043         
#>  9 Liberty        LIB               12            542              3015         
#> 10 Ohio           OHIO              14            574              2985         
#> # ℹ 124 more rows
#> # ℹ 10 more variables: rushing_yards_per_attempt <chr>,
#> #   rushing_attempts_per_game <chr>, rushing_yards_per_game <chr>,
#> #   rushing_touchdowns <chr>, rushing_first_downs <chr>, longest_rush <chr>,
#> #   rushing_fumbles <chr>, rushing_fumbles_lost <chr>, season <dbl>,
#> #   category <chr>
# }
```
