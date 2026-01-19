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
#> Request failed [404]. Retrying in 1 seconds...
#> Request failed [404]. Retrying in 3.1 seconds...
#> 2026-01-19 16:23:14.845156: Invalid arguments or no play-by-play data for 401282614 available!
#> Error in espn_cfb_pbp(game_id = 401282614, epa_wpa = TRUE) : 
#>   object 'plays_df' not found
 # }
```
