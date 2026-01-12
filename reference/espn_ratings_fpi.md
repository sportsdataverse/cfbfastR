# **ESPN FPI Ratings**

Get FPI historical rating data (most recent of each year)

## Usage

``` r
espn_ratings_fpi(year = 2019)
```

## Arguments

- year:

  Year

## Value

A data frame with 20 variables:

- `year`: integer.:

  Season of the Football Power Index (FPI) Rating.

- `team_id`: integer.:

  Unique ESPN team ID - `team_id`.

- `team_name`: character.:

  Team Name.

- `team_abbreviation`: character.:

  Team abbreviation.

- `fpi`: character.:

  Football Power Index (FPI) Rating.

- `fpi_rk`: character.:

  Football Power Index (FPI) Rank.

- `trend`: character.:

  Football Power Index (FPI) ranking trend.

- `projected_wins`: character.:

  Projected Win total for the season.

- `projected_losses`: character.:

  Projected Loss total for the season.

- `win_out_pct`: double.:

  Probability the team wins out.

- `win_6_pct`: double.:

  Probability the team wins at least six games.

- `win_division_pct`: double.:

  Probability the team wins at their division.

- `playoff_pct`: double.:

  Probability the team reaches the playoff.

- `nc_game_pct`: double.:

  Probability the team reaches the national championship game.

- `nc_win_pct`: double.:

  Probability the team wins the national championship game.

- `win_conference_pct`: double.:

  Probability the team wins their conference game.

- `w`: integer.:

  Wins on the season.

- `l`: integer.:

  Losses on the season.

- `t`: character.:

  Ties on the season.

## Details

Adapted from sabinanalytic's fork of the cfbfastR repo

## Examples

``` r
# \donttest{
  try(espn_ratings_fpi(year=2019))
#> ── FPI rating data from ESPN ───────────────────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:19 UTC
#> # A tibble: 130 × 19
#>     year team_id team_name  team_abbreviation fpi   fpi_rk trend projected_wins
#>    <int>   <int> <chr>      <chr>             <chr> <chr>  <chr> <chr>         
#>  1  2019     194 Ohio State OSU               33.7  1st    -     13.0          
#>  2  2019     228 Clemson    CLEM              31.5  2nd    -     14.0          
#>  3  2019      99 LSU        LSU               30.3  3rd    -     15.0          
#>  4  2019     333 Alabama    ALA               29.4  4th    -     11.0          
#>  5  2019      61 Georgia    UGA               24.0  5th    -     12.0          
#>  6  2019    2483 Oregon     ORE               21.7  6th    -     12.0          
#>  7  2019     213 Penn State PSU               21.5  7th    -     11.0          
#>  8  2019     275 Wisconsin  WIS               21.3  8th    -     10.0          
#>  9  2019      57 Florida    FLA               21.3  9th    -     11.0          
#> 10  2019       2 Auburn     AUB               21.3  10th   -     9.0           
#> # ℹ 120 more rows
#> # ℹ 11 more variables: projected_losses <chr>, win_out_pct <dbl>,
#> #   win_6_pct <dbl>, win_division_pct <dbl>, playoff_pct <dbl>,
#> #   nc_game_pct <dbl>, nc_win_pct <dbl>, win_conference_pct <dbl>, w <int>,
#> #   l <int>, t <chr>
# }
```
