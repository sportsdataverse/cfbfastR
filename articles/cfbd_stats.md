# CFB Data Stats Examples

### **Load and Install Packages**

``` r
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load(dplyr,tidyr, gt, cfbfastR)
# pacman::p_load_current_gh("sportsdataverse/cfbfastR")
```

## Settling **2019 LSU** and **2013 Florida State** offense debates

### **Get Season Statistics by Team**

``` r
team_season_stats <- dplyr::bind_rows(
   cfbd_stats_season_team(year=2019, team = "LSU"),
   cfbd_stats_season_team(year=2013, team = "Florida State")
)
logos <- read.csv("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/themes/logos.csv")
logos<- logos %>% dplyr::select(-"conference")
df_team_season <- team_season_stats %>%
   dplyr::left_join(logos, by=c("team"="school"))
```

``` r
df_team_season_long <- as.data.frame(t(as.matrix(df_team_season)))
colnames(df_team_season_long) <- df_team_season$team
```

### **Get Season Advanced Statistics by Team**

``` r
df_team_season_adv <- dplyr::bind_rows(
   cfbd_stats_season_advanced(2019, team = "LSU"),
   cfbd_stats_season_advanced(2013, team = "Florida State")
)
df_team_season_adv <- df_team_season_adv %>%
   dplyr::left_join(logos, by=c("team"="school"))
```

### **Get Game Advanced Stats**

``` r
df_team_game_adv <- dplyr::bind_rows(
   cfbd_stats_game_advanced(2019, team = "LSU"),
   cfbd_stats_game_advanced(2013, team = "Florida State")
)
df_team_game_adv <- df_team_game_adv %>%
   dplyr::left_join(logos, by=c("team"="school"))
```

### **Get Season Statistics by Player**

``` r
source("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/themes/gt_theme_code_SG.R")
passing_df <- dplyr::bind_rows(
   cfbd_stats_season_player(2019, team = "LSU", category = "passing"),
   cfbd_stats_season_player(2013, team = "Florida State", category = "passing")) %>%
   dplyr::left_join(logos, by=c("team"="school")) %>%
   dplyr::group_by(team) %>%
   dplyr::select(logo,
                 player,
                 passing_completions,
                 passing_att,
                 passing_yds,
                 passing_td,
                 passing_int,
                 passing_ypa) %>%
   arrange( desc(passing_yds), team)
```

    ## Adding missing grouping variables: `team`

``` r
passing_df %>% gt() %>%
  tab_header(title = "Passing Summary") %>%
  cols_label(logo="",
             player = "Player",
             passing_completions = "C",
             passing_att = "Att",
             passing_yds = "Yds",
             passing_td = "TDs",
             passing_int = "INTs",
             passing_ypa = "YPA") %>%
  data_color(
    columns = c("passing_yds"),
    colors = scales::col_numeric(
      palette = "RdBu",
      domain = c(-6000,6000)
    )
  ) %>%
  data_color(
    columns = c("passing_td"),
    colors = scales::col_numeric(
      palette = "RdBu",
      domain = c(-60,60)
    )
  ) %>%
  data_color(
    columns = c("passing_td"),
    colors = scales::col_numeric(
      palette = "RdBu",
      domain = c(-60,60)
    )
  ) %>%
  # add alt-text to the logos in the table
  # this is important for accessibility and for people using screen readers
  
  text_transform(
    locations = cells_body(c("logo")),
    fn = function(logo){
      
     web_image(url= logo, height = 30)

  }) %>%
  tab_source_note(source_note = md("**Table:** @SaiemGilani | **Data:** @CFB_Data with @cfbfastR v2.0.0")) %>%
  gt_theme_538(table.width = px(550))
```

    ## Warning: Since gt v0.9.0, the `colors` argument has been deprecated.
    ## • Please use the `fn` argument instead.
    ## This warning is displayed once every 8 hours.

| Passing Summary                                                      |                |     |     |      |     |      |      |
|----------------------------------------------------------------------|----------------|-----|-----|------|-----|------|------|
|                                                                      | Player         | C   | Att | Yds  | TDs | INTs | YPA  |
| LSU                                                                  |                |     |     |      |     |      |      |
| ![](http://a.espncdn.com/i/teamlogos/ncaa/500/99.png)                | Joe Burrow     | 402 | 527 | 5671 | 60  | 6    | 10.8 |
| ![](http://a.espncdn.com/i/teamlogos/ncaa/500/99.png)                | Myles Brennan  | 24  | 40  | 353  | 1   | 1    | 8.8  |
| Florida State                                                        |                |     |     |      |     |      |      |
| ![](http://a.espncdn.com/i/teamlogos/ncaa/500/52.png)                | Jameis Winston | 257 | 384 | 4057 | 40  | 10   | 10.6 |
| ![](http://a.espncdn.com/i/teamlogos/ncaa/500/52.png)                | Jake Coker     | 18  | 36  | 250  | 0   | 1    | 6.9  |
| ![](http://a.espncdn.com/i/teamlogos/ncaa/500/52.png)                | Sean Maguire   | 13  | 21  | 116  | 2   | 2    | 5.5  |
| **Table:** @SaiemGilani \| **Data:** @CFB_Data with @cfbfastR v2.0.0 |                |     |     |      |     |      |      |

### **College Football Mapping for Stats Categories**

``` r
cfbd_stats_categories()
```

    ## ── Stat categories for CollegeFootballData.com ─────────────── cfbfastR 2.2.0 ──

    ## ℹ Data updated: 2026-01-12 06:35:33 UTC

    ## # A tibble: 38 × 1
    ##    category          
    ##    <chr>             
    ##  1 completionAttempts
    ##  2 defensiveTDs      
    ##  3 extraPoints       
    ##  4 fieldGoalPct      
    ##  5 fieldGoals        
    ##  6 firstDowns        
    ##  7 fourthDownEff     
    ##  8 fumblesLost       
    ##  9 fumblesRecovered  
    ## 10 interceptions     
    ## # ℹ 28 more rows
