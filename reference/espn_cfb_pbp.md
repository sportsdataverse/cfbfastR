# Get ESPN college football PBP data

Get ESPN college football PBP data

## Usage

``` r
espn_cfb_pbp(game_id, epa_wpa = FALSE)
```

## Arguments

- game_id:

  Game ID

- epa_wpa:

  Logical parameter (TRUE/FALSE) to return the Expected Points Added/Win
  Probability Added variables

## Value

A data frame with college football play-by-play data

## Author

Saiem Gilani

## Examples

``` r
 # \donttest{
   try(espn_cfb_pbp(game_id = 401282614, epa_wpa = TRUE))
#> ── Play-by-play data from ESPN.com ─────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 03:17:42 UTC
#> # A tibble: 196 × 419
#>      game_id id_play         drive_id home  away  drive_number drive_play_number
#>        <dbl> <chr>           <chr>    <chr> <chr>        <int>             <dbl>
#>  1 401282614 40128261410184… 4012826… Flor… Notr…            1                 1
#>  2 401282614 40128261410185… 4012826… Flor… Notr…            1                 2
#>  3 401282614 40128261410185… 4012826… Flor… Notr…            1                 2
#>  4 401282614 40128261410186… 4012826… Flor… Notr…            1                 3
#>  5 401282614 40128261410186… 4012826… Flor… Notr…            1                 4
#>  6 401282614 40128261410187… 4012826… Flor… Notr…            1                 5
#>  7 401282614 40128261410187… 4012826… Flor… Notr…            1                 2
#>  8 401282614 40128261410187… 4012826… Flor… Notr…            2                 1
#>  9 401282614 40128261410187… 4012826… Flor… Notr…            2                 3
#> 10 401282614 40128261410187… 4012826… Flor… Notr…            2                 3
#> # ℹ 186 more rows
#> # ℹ 412 more variables: game_play_number <dbl>, pos_team <chr>,
#> #   def_pos_team <chr>, clock_minutes <dbl>, clock_seconds <dbl>, half <fct>,
#> #   period <int>, TimeSecsRem <dbl>, play_type <chr>, play_text <chr>,
#> #   down <dbl>, distance <dbl>, yards_to_goal <dbl>, yards_gained <dbl>,
#> #   Goal_To_Go <lgl>, Under_two <lgl>, pos_score_diff <int>,
#> #   pos_score_diff_start <dbl>, pos_team_score <int>, …
 # }
```
