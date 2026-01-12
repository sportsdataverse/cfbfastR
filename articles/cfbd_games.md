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

    ## ℹ Data updated: 2026-01-12 06:35:17 UTC

    ## # A tibble: 26 × 78
    ##      game_id school     conference home_away opponent opponent_conference points
    ##        <int> <chr>      <chr>      <chr>     <chr>    <chr>                <int>
    ##  1 401110778 Texas      Big 12     home      LSU      SEC                     38
    ##  2 401110778 LSU        SEC        away      Texas    Big 12                  45
    ##  3 401110842 Alabama    SEC        home      LSU      SEC                     41
    ##  4 401110842 LSU        SEC        away      Alabama  SEC                     46
    ##  5 401110850 Ole Miss   SEC        home      LSU      SEC                     37
    ##  6 401110850 LSU        SEC        away      Ole Miss SEC                     58
    ##  7 401110869 LSU        SEC        home      Texas A… SEC                     50
    ##  8 401110869 Texas A&M  SEC        away      LSU      SEC                      7
    ##  9 401110725 LSU        SEC        home      Georgia… Sun Belt                55
    ## 10 401110725 Georgia S… Sun Belt   away      LSU      SEC                      3
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

    ## ℹ Data updated: 2026-01-12 06:35:18 UTC

    ## # A tibble: 26 × 78
    ##      game_id school     conference home_away opponent opponent_conference points
    ##        <int> <chr>      <chr>      <chr>     <chr>    <chr>                <int>
    ##  1 332640052 Florida S… ACC        home      Bethune… MEAC                    54
    ##  2 332640052 Bethune-C… MEAC       away      Florida… ACC                      6
    ##  3 332450221 Pittsburgh ACC        home      Florida… ACC                     13
    ##  4 332450221 Florida S… ACC        away      Pittsbu… ACC                     41
    ##  5 332710103 Boston Co… ACC        home      Florida… ACC                     34
    ##  6 332710103 Florida S… ACC        away      Boston … ACC                     48
    ##  7 332780052 Florida S… ACC        home      Maryland ACC                     63
    ##  8 332780052 Maryland   ACC        away      Florida… ACC                      0
    ##  9 332570052 Nevada     Mountain … away      Florida… ACC                      7
    ## 10 332570052 Florida S… ACC        home      Nevada   Mountain West           62
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
