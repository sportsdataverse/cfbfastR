# **Load ESPN college football team box scores from the SportsDataverse data repo**

Loads season-level team box scores – one row per team-game with scoring,
team statistics, and opponent context. Published to the
`espn_cfb_team_box` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_team_box(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2004 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2004)

- ...:

  Additional arguments passed to an underlying function that writes the
  season data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble.

|  |  |  |
|----|----|----|
| col_name | types | description |
| firstDowns | character | Total first downs ESPN credits the team, carried verbatim from the box score as a string. |
| thirdDownEff | character | Third-down efficiency as ESPN's conversions-attempts string, for example 5-15. |
| fourthDownEff | character | Fourth-down efficiency as a conversions-attempts string, for example 3-4. |
| totalYards | character | Total offensive yards for the team, matching rushingYards plus netPassingYards in about 99.8 percent of games. |
| netPassingYards | character | Passing yards after yardage lost to sacks is deducted, the numerator behind yardsPerPass. |
| completionAttempts | character | Completions and pass attempts as a slash-separated string, for example 23/41. |
| yardsPerPass | character | Net passing yards per pass attempt, netPassingYards divided by the attempt count in completionAttempts and rounded to one decimal. |
| rushingYards | character | Net rushing yards gained. |
| rushingAttempts | character | Rushing attempts. |
| yardsPerRushAttempt | character | Yards gained per rushing attempt. |
| totalPenaltiesYards | character | Penalties and penalty yards as a hyphen-separated string, for example 7-64. |
| turnovers | character |  |
| fumblesLost | character | Number of fumbles the team lost to the opponent, carried as a string. |
| interceptions | character |  |
| possessionTime | character | Time of possession as mm:ss; the two teams' values add up to 60 minutes in a regulation game. |
| team_id | integer |  |
| team_abbreviation | character |  |
| team_name | character |  |
| home_away | character |  |
| game_id | integer |  |
| season | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_team_box(2004))
#> ── ESPN college football team box scores from the SportsDataverse data repo ────
#> ℹ Data updated: 2026-09-03 22:41:35 UTC
#> # A tibble: 1,424 × 21
#>    firstDowns thirdDownEff fourthDownEff totalYards netPassingYards
#>    <chr>      <chr>        <chr>         <chr>      <chr>          
#>  1 16         6-14         0-1           373        284            
#>  2 18         5-13         0-0           294        180            
#>  3 12         0-0          0-0           204        137            
#>  4 26         4-11         1-3           454        292            
#>  5 17         3-16         1-4           437        292            
#>  6 23         7-16         1-2           582        381            
#>  7 NA         NA           NA            NA         NA             
#>  8 NA         NA           NA            NA         NA             
#>  9 17         6-14         0-2           340        140            
#> 10 12         5-18         0-1           211        183            
#> # ℹ 1,414 more rows
#> # ℹ 16 more variables: completionAttempts <chr>, yardsPerPass <chr>,
#> #   rushingYards <chr>, rushingAttempts <chr>, yardsPerRushAttempt <chr>,
#> #   totalPenaltiesYards <chr>, turnovers <chr>, fumblesLost <chr>,
#> #   interceptions <chr>, possessionTime <chr>, team_id <int>,
#> #   team_abbreviation <chr>, team_name <chr>, home_away <chr>, game_id <int>,
#> #   season <int>
# }
```
