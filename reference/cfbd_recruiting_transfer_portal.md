# **Get Transfer Portal Data**

**Get Transfer Portal Data**

## Usage

``` r
cfbd_recruiting_transfer_portal(year)
```

## Arguments

- year:

  (*Integer* required): Year of the offseason (2021 would return
  transfer portal data starting from the end of the 2020 season), 4
  digit format (*YYYY*).

## Value

`cfbd_recruiting_transfer_portal()` - A data frame with 11 variables:

- `season`:integer:

  Season of transfer.

- `first_name`:character.:

  Player's first name.

- `last_name`:character.:

  Player's last name.

- `position`:character.:

  Player position.

- `origin`:character.:

  original team.

- `destination`:character.:

  new team.

- `transfer_date`:character.:

  Date of transfer.

- `rating`:character.:

  Player's 247 transfer rating.

- `stars`:integer:

  Player's star rating.

- `eligibilty`:character.:

  Player's eligibilty status.

## See also

Other CFBD Recruiting:
[`cfbd_recruiting_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.md),
[`cfbd_recruiting_position()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_position.md),
[`cfbd_recruiting_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_team.md)

## Examples

``` r
# \donttest{
  try(cfbd_recruiting_transfer_portal(year = 2021))
#> ── Transfer portal data from CollegeFootballData.com ───────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:22:47 UTC
#> # A tibble: 1,770 × 10
#>    season first_name last_name   position origin destination transfer_date      
#>     <int> <chr>      <chr>       <chr>    <chr>  <chr>       <dttm>             
#>  1   2021 Cameron    Wilkins     LB       Misso… UTSA        2021-07-31 00:00:00
#>  2   2021 Javar      Strong      S        Arkan… NA          2021-07-28 00:00:00
#>  3   2021 Noah       Mitchell    LB       UTSA   NA          2021-07-27 00:00:00
#>  4   2021 Trivenskey Mosley      RB       South… NA          2021-07-26 00:00:00
#>  5   2021 Jalar      Holley      DL       Miami  NA          2021-07-25 00:00:00
#>  6   2021 Davon      Wells-Ross  LB       Wyomi… NA          2021-07-23 00:00:00
#>  7   2021 Samari     Saddler     IOL      Easte… NA          2021-07-23 00:00:00
#>  8   2021 Bennett    Johnston    QB       South… NA          2021-07-22 00:00:00
#>  9   2021 Lashawn    Paulino-Be… EDGE     Vande… NA          2021-07-20 00:00:00
#> 10   2021 Chris      Lovick      RB       Tulsa  NA          2021-07-19 00:00:00
#> # ℹ 1,760 more rows
#> # ℹ 3 more variables: rating <dbl>, stars <int>, eligibility <chr>
# }
```
