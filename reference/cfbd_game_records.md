# **Get team records by year**

**Get team records by year**

## Usage

``` r
cfbd_game_records(year, team = NULL, conference = NULL)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*)

- team:

  (*String* optional): Team - Select a valid team, D1 football

- conference:

  (*String* optional): DI Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

## Value

`cfbd_game_records()` - A data frame with 35 variables:

- `year`: integer.:

  Season of the games.

- `team_id`: integer.:

  Referencing team id.

- `team`: character.:

  Team name.

- `classification`: character:

  Conference classification (fbs,fcs,ii,iii)

- `conference`: character.:

  Conference of the team.

- `division`: character.:

  Division in the conference of the team.

- `expected_wins`: numeric:

  Expected number of wins based on post-game win probability.

- `total_games`: integer.:

  Total number of games played.

- `total_wins`: integer.:

  Total wins.

- `total_losses`: integer.:

  Total losses.

- `total_ties`: integer.:

  Total ties.

- `conference_games`: integer.:

  Number of conference games.

- `conference_wins`: integer.:

  Total conference wins.

- `conference_losses`: integer.:

  Total conference losses.

- `conference_ties`: integer.:

  Total conference ties.

- `home_games`: integer.:

  Total home games.

- `home_wins`: integer.:

  Total home wins.

- `home_losses`: integer.:

  Total home losses.

- `home_ties`: integer.:

  Total home ties.

- `away_games`: integer.:

  Total away games.

- `away_wins`: integer.:

  Total away wins.

- `away_losses`: integer.:

  Total away losses.

- `away_ties`: integer.:

  Total away ties.

- `neutral_games`: integer.:

  Total neutral site games.

- `neutral_wins`: integer.:

  Total neutral site wins.

- `neutral_losses`: integer.:

  Total neutral site losses.

- `neutral_ties`: integer.:

  Total neutral site ties.

- `regular_season_games`: integer.:

  Total regular season games.

- `regular_season_wins`: integer.:

  Total regular season wins.

- `regular_season_losses`: integer.:

  Total regular season losses.

- `regular_season_ties`: integer.:

  Total regular season ties.

- `postseason_games`: integer.:

  Total postseason games.

- `postseason_wins`: integer.:

  Total postseason wins.

- `postseason_losses`: integer.:

  Total postseason losses.

- `postseason_ties`: integer.:

  Total postseason ties.

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_records(2018, team = "Notre Dame"))
#> ── Game records data from CollegeFootballData.com ──────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:21:53 UTC
#> # A tibble: 1 × 35
#>    year team_id team       classification conference      division expected_wins
#>   <int>   <int> <chr>      <chr>          <chr>           <chr>            <dbl>
#> 1  2018      87 Notre Dame fbs            FBS Independen… ""                10.5
#> # ℹ 28 more variables: total_games <int>, total_wins <int>, total_losses <int>,
#> #   total_ties <int>, conference_games <int>, conference_wins <int>,
#> #   conference_losses <int>, conference_ties <int>, home_games <int>,
#> #   home_wins <int>, home_losses <int>, home_ties <int>, away_games <int>,
#> #   away_wins <int>, away_losses <int>, away_ties <int>, neutral_games <int>,
#> #   neutral_wins <int>, neutral_losses <int>, neutral_ties <int>,
#> #   regular_season_games <int>, regular_season_wins <int>, …

  try(cfbd_game_records(2013, team = "Florida State"))
#> ── Game records data from CollegeFootballData.com ──────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:21:53 UTC
#> # A tibble: 1 × 35
#>    year team_id team          classification conference division expected_wins
#>   <int>   <int> <chr>         <chr>          <chr>      <chr>            <dbl>
#> 1  2013      52 Florida State fbs            ACC        Atlantic          12.3
#> # ℹ 28 more variables: total_games <int>, total_wins <int>, total_losses <int>,
#> #   total_ties <int>, conference_games <int>, conference_wins <int>,
#> #   conference_losses <int>, conference_ties <int>, home_games <int>,
#> #   home_wins <int>, home_losses <int>, home_ties <int>, away_games <int>,
#> #   away_wins <int>, away_losses <int>, away_ties <int>, neutral_games <int>,
#> #   neutral_wins <int>, neutral_losses <int>, neutral_ties <int>,
#> #   regular_season_games <int>, regular_season_wins <int>, …
# }
```
