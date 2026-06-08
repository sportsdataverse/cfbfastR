# **CFBD Play-by-Play Endpoint Overview**

- [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md):
  Get college football play by play data with cfbfastR expected
  points/win probability added.

## Details

The modular successor
[`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md)
ships in a sibling file and references the same CFBD upstream.

### **Get college football play by play data with cfbfastR expected points/win probability added**

     # Get play by play data for 2025 regular season week 1
     cfbd_pbp_data(year = 2025, week = 1, season_type = 'regular', epa_wpa = TRUE)
