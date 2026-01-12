# CFB Data Betting Lines Examples

### **Load and Install Packages**

``` r
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load(dplyr,tidyr, gt, cfbfastR)
# pacman::p_load_current_gh("sportsdataverse/cfbfastR")
```

### **Get Betting information from games**

``` r
cfbd_betting_lines(year = 2018, week = 12, team = "Florida State")
```

    ## ── Betting lines data from CollegeFootballData.com ─────────── cfbfastR 2.2.0 ──

    ## ℹ Data updated: 2026-01-12 12:22:53 UTC

    ## # A tibble: 4 × 23
    ##     game_id season season_type  week start_date           home_team_id home_team
    ##       <int>  <int> <chr>       <int> <chr>                       <int> <chr>    
    ## 1 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
    ## 2 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
    ## 3 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
    ## 4 401013175   2018 regular        12 2018-11-17T20:30:00…           52 Florida …
    ## # ℹ 16 more variables: home_conference <chr>, home_classification <chr>,
    ## #   home_score <int>, away_team_id <int>, away_team <chr>,
    ## #   away_conference <chr>, away_classification <chr>, away_score <int>,
    ## #   provider <chr>, spread <dbl>, formatted_spread <chr>, spread_open <lgl>,
    ## #   over_under <dbl>, over_under_open <lgl>, home_moneyline <lgl>,
    ## #   away_moneyline <lgl>

``` r
# 7 OTs LSU at TAMU
cfbd_betting_lines(year = 2018, week = 13, team = "Texas A&M", conference = "SEC")
```

    ## ── Betting lines data from CollegeFootballData.com ─────────── cfbfastR 2.2.0 ──
    ## ℹ Data updated: 2026-01-12 12:22:53 UTC

    ## # A tibble: 4 × 23
    ##     game_id season season_type  week start_date           home_team_id home_team
    ##       <int>  <int> <chr>       <int> <chr>                       <int> <chr>    
    ## 1 401012356   2018 regular        13 2018-11-25T00:30:00…          245 Texas A&M
    ## 2 401012356   2018 regular        13 2018-11-25T00:30:00…          245 Texas A&M
    ## 3 401012356   2018 regular        13 2018-11-25T00:30:00…          245 Texas A&M
    ## 4 401012356   2018 regular        13 2018-11-25T00:30:00…          245 Texas A&M
    ## # ℹ 16 more variables: home_conference <chr>, home_classification <chr>,
    ## #   home_score <int>, away_team_id <int>, away_team <chr>,
    ## #   away_conference <chr>, away_classification <chr>, away_score <int>,
    ## #   provider <chr>, spread <int>, formatted_spread <chr>, spread_open <lgl>,
    ## #   over_under <dbl>, over_under_open <lgl>, home_moneyline <lgl>,
    ## #   away_moneyline <lgl>
