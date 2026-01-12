# CFB Data Games Examples

### **Load and Install Packages**

``` r
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load(dplyr,tidyr, gt, cfbfastR)
# pacman::p_load_current_gh("sportsdataverse/cfbfastR")
```

### **Get game information**

``` r
df_2018_wk_1 <- cfbfastR::cfbd_game_info(year=2018, week = 1)

df_2018_wk_7_ind <- cfbfastR::cfbd_game_info(year=2018, week = 7, conference = "Ind")

line_scores <- cfbfastR::cfbd_game_info(year=2018, week = 13, team = "Texas A&M", quarter_scores = TRUE)
```

### **Get calendar weeks and dates**

``` r
cfbfastR::cfbd_calendar(2019)
```

### **Find game broadcast and media information**

``` r
cfbfastR::cfbd_game_media(2019, week = 4, conference = "ACC")
```

### **Get CFBD Advanced Game Box Scores (by `game_id`)**

``` r
cfbfastR::cfbd_game_box_advanced(game_id = 401114233)
```

### **Get CFBD Game Team Box Scores**

``` r
cfbfastR::cfbd_game_team_stats(2019, team = "LSU")
```

    ## ── Team stats data from CollegeFootballData.com ────────────── cfbfastR 2.2.0 ──

    ## ℹ Data updated: 2026-01-12 12:22:58 UTC

    ## # A tibble: 26 × 78
    ##      game_id school     conference home_away opponent opponent_conference points
    ##        <int> <chr>      <chr>      <chr>     <chr>    <chr>                <int>
    ##  1 401110828 Mississip… SEC        home      LSU      SEC                     13
    ##  2 401110828 LSU        SEC        away      Mississ… SEC                     36
    ##  3 401110833 LSU        SEC        home      Auburn   SEC                     23
    ##  4 401110833 Auburn     SEC        away      LSU      SEC                     20
    ##  5 401110859 LSU        SEC        home      Arkansas SEC                     56
    ##  6 401110859 Arkansas   SEC        away      LSU      SEC                     20
    ##  7 401110819 LSU        SEC        home      Florida  SEC                     42
    ##  8 401110819 Florida    SEC        away      LSU      SEC                     28
    ##  9 401110813 LSU        SEC        home      Utah St… Mountain West           42
    ## 10 401110813 Utah State Mountain … away      LSU      SEC                      6
    ## # ℹ 16 more rows
    ## # ℹ 71 more variables: total_yards <chr>, net_passing_yards <chr>,
    ## #   completion_attempts <chr>, passing_tds <chr>, yards_per_pass <chr>,
    ## #   passes_intercepted <chr>, interception_yards <chr>, interception_tds <chr>,
    ## #   rushing_attempts <chr>, rushing_yards <chr>, rush_tds <chr>,
    ## #   yards_per_rush_attempt <chr>, first_downs <chr>, third_down_eff <chr>,
    ## #   fourth_down_eff <chr>, punt_returns <chr>, punt_return_yards <chr>, …

``` r
cfbfastR::cfbd_game_team_stats(2013, team = "Florida State")
```

    ## ── Team stats data from CollegeFootballData.com ────────────── cfbfastR 2.2.0 ──
    ## ℹ Data updated: 2026-01-12 12:22:58 UTC

    ## # A tibble: 26 × 78
    ##      game_id school     conference home_away opponent opponent_conference points
    ##        <int> <chr>      <chr>      <chr>     <chr>    <chr>                <int>
    ##  1 332640052 Florida S… ACC        home      Bethune… MEAC                    54
    ##  2 332640052 Bethune-C… MEAC       away      Florida… ACC                      6
    ##  3 332450221 Pittsburgh ACC        home      Florida… ACC                     13
    ##  4 332450221 Florida S… ACC        away      Pittsbu… ACC                     41
    ##  5 333060052 Florida S… ACC        home      Miami    ACC                     41
    ##  6 333060052 Miami      ACC        away      Florida… ACC                     14
    ##  7 333200052 Florida S… ACC        home      Syracuse ACC                     59
    ##  8 333200052 Syracuse   ACC        away      Florida… ACC                      3
    ##  9 333340057 Florida S… ACC        away      Florida  SEC                     37
    ## 10 333340057 Florida    SEC        home      Florida… ACC                      7
    ## # ℹ 16 more rows
    ## # ℹ 71 more variables: total_yards <chr>, net_passing_yards <chr>,
    ## #   completion_attempts <chr>, passing_tds <chr>, yards_per_pass <chr>,
    ## #   passes_intercepted <chr>, interception_yards <chr>, interception_tds <chr>,
    ## #   rushing_attempts <chr>, rushing_yards <chr>, rush_tds <chr>,
    ## #   yards_per_rush_attempt <chr>, first_downs <chr>, third_down_eff <chr>,
    ## #   fourth_down_eff <chr>, punt_returns <chr>, punt_return_yards <chr>, …

### **Get CFBD Game Player Box Scores**

``` r
cfbfastR::cfbd_game_player_stats(2018, week = 15, conference = "Ind")

cfbfastR::cfbd_game_player_stats(2013, week = 1, team = "Florida State", category = "passing")
```

### **Get CFBD Team Game Records**

``` r
cfbfastR::cfbd_game_records(2018, team = "Notre Dame")

cfbfastR::cfbd_game_records(2013, team = "Florida State")
```
