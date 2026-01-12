# **Create WPA**

Add Win Probability Added (WPA) calculations to Play-by-Play DataFrame
This is only for D1 football

## Usage

``` r
create_wpa_naive(df, wp_model)

wpa_calcs_naive(df)
```

## Arguments

- df:

  (*data.frame* required): Clean Play-by-Play data.frame with Expected
  Points Added (EPA) calculations

- wp_model:

  (*model* default cfbfastR:wp_model): Win Probability (WP) Model

## Value

The original `df` with the following columns appended to it:

- wp_before:

  .

- def_wp_before:

  .

- home_wp_before:

  .

- away_wp_before:

  .

- lead_wp_before:

  .

- lead_wp_before2:

  .

- wpa_base:

  .

- wpa_base_nxt:

  .

- wpa_base_ind:

  .

- wpa_base_nxt_ind:

  .

- wpa_change:

  .

- wpa_change_nxt:

  .

- wpa_change_ind:

  .

- wpa_change_nxt_ind:

  .

- wpa:

  .

- wp_after:

  .

- def_wp_after:

  .

- home_wp_after:

  .

- away_wp_after:

  .

## Details

Requires the following columns to be present in the input data frame.
