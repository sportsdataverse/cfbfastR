# **CFBD Plays Endpoint Overview**

College football plays data

- [`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)::

  CFBD's college football play-by-play.

- [`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md)::

  Gets player info associated by play.

- [`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md)::

  Gets CFBD play stat types.

- [`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md)::

  Gets CFBD play types.

## Details

### **Pull first 3 weeks of 2020 season using [`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)**

     year_vector <- 2020
     week_vector <- 1:3
     weekly_year_df <- expand.grid(year = year_vector, week = week_vector)
     tictoc::tic()
     year_split <- split(weekly_year_df, weekly_year_df$year)
     for (i in 1:length(year_split)) {
       i <- 1

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

### **Gets player info associated by play**

    cfbd_play_stats_player(game_id = 401110722)

### **Gets CFBD play stat types**

    cfbd_play_stats_types()

### **Gets CFBD play types**

    cfbd_play_types()
