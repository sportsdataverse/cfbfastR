# **CFBD Betting Lines Endpoint Overview**

**Get betting lines information for games**

## Usage

``` r
cfbd_betting_lines(
  game_id = NULL,
  year = NULL,
  week = NULL,
  season_type = "regular",
  team = NULL,
  home_team = NULL,
  away_team = NULL,
  conference = NULL,
  line_provider = NULL
)
```

## Arguments

- game_id:

  (*Integer* optional): Game ID filter for querying a single game.
  Required if year not provided  
  Can be found using the
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  function

- year:

  (*Integer* optional): Year, 4 digit format(*YYYY*). Required if
  game_id not provided

- week:

  (*Integer* optional): Week - values from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier)

- season_type:

  (*String* default regular): Select Season Type: regular, postseason,
  both, allstar, spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- home_team:

  (*String* optional): Home D-I Team

- away_team:

  (*String* optional): Away D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference  
  Conference abbreviations P5: ACC, B12, B1G, SEC, PAC  
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC  

- line_provider:

  (*String* optional): Select Line Provider - Caesars, consensus,
  numberfire, or teamrankings

## Value

Betting information for games with the following columns:

- game_id:integer.:

  Unique game identifier - game_id.

- season:integer.:

  Season parameter.

- season_type:character.):

  Season Type (regular, postseason, both

- week:integer.:

  Week, values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or
  earlier).

- start_date:character.:

  Start Date

- home_team:character.:

  Home D-I Team.

- home_conference:character.:

  Home D-I Conference.

- home_classification:character.:

  Home Conference classification (fbs,fcs,ii,iii)

- home_score:integer.:

  Home Score.

- away_team:character.:

  Away D-I Team.

- away_conference:character.:

  Away D-I Conference.

- away_classification:character.:

  Away Conference classification (fbs,fcs,ii,iii)

- away_score:integer.:

  Away Score.

- provider:character.:

  Line provider.

- spread:character.:

  Spread for the game.

- formatted_spread:character.:

  Formatted spread for the game.

- spread_open:character.:

  Opening spread for the game.

- over_under:character.:

  Over/Under for the game.

- over_under_open:character.:

  Opening over/under for the game.

- home_moneyline:character.:

  Home team moneyline.

- away_moneyline:character.:

  Away team moneyline.

## Examples

``` r
# \donttest{
   try(cfbd_betting_lines(year = 2018, week = 12, team = "Florida State"))
#> ── Betting lines data from CollegeFootballData.com ─────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:27 UTC
#> # A tibble: 4 × 23
#>     game_id season season_type  week start_date           home_team_id home_team
#>       <int>  <int> <chr>       <int> <chr>                       <int> <chr>    
#> 1 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
#> 2 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
#> 3 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
#> 4 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
#> # ℹ 16 more variables: home_conference <chr>, home_classification <chr>,
#> #   home_score <int>, away_team_id <int>, away_team <chr>,
#> #   away_conference <chr>, away_classification <chr>, away_score <int>,
#> #   provider <chr>, spread <dbl>, formatted_spread <chr>, spread_open <lgl>,
#> #   over_under <dbl>, over_under_open <lgl>, home_moneyline <lgl>,
#> #   away_moneyline <lgl>
# }
```
