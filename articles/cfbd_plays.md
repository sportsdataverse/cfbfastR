# CFB Data Plays Examples

### **Load and Install Packages**

``` r
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load(dplyr,tidyr, cfbfastR)
#pacman::p_load_current_gh("sportsdataverse/cfbfastR")
```

### **Pull first 3 weeks of 2020 season using `cfbd_plays()`**

``` r
year_vector <- 2020
week_vector <- 1:3
weekly_year_df <- expand.grid(year = year_vector, week = week_vector)

tictoc::tic()
year_split <- split(weekly_year_df, weekly_year_df$year)
for (i in 1:length(year_split)) {
  progressr::with_progress({
    year_split[[i]] <- year_split[[i]] %>%
      dplyr::mutate(
        pbp = purrr::map2(
          .x = year,
          .y = week,
          cfbd_plays,
          season_type = "both"
        )
      )

    Sys.sleep(1)
  })
}

tictoc::toc()

year_split <- lapply(year_split, function(x) {
  x %>% tidyr::unnest(pbp, names_repair = "minimal")
})

all_years <- dplyr::bind_rows(year_split)
glimpse(all_years)
```
