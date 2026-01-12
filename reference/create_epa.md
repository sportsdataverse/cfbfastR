# **Create EPA**

Adds Expected Points calculations to Play-by-Play data.frame

## Usage

``` r
create_epa(play_df, ep_model, fg_model)

epa_fg_probs(dat, current_probs, ep_model, fg_mod)
```

## Arguments

- play_df:

  (*data.frame* required): Clean PBP as input from
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)

- ep_model:

  (**model**, default `cfbfastR`'s `ep_model`): FG Model to be used for
  prediction on field goal (FG) attempts in Play-by-Play data.frame

- fg_model:

  (*model* default `cfbfastR`'s `fg_model`): Field Goal (FG) Model

- dat:

  (**data.frame** required): Clean Play-By-Play data.frame as can be
  pulled from
  [`clean_pbp_dat()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)

- current_probs:

  (**data.frame** required): Expected Points (EP) model raw probability
  outputs from initial prediction

- fg_mod:

  (**model**, default `cfbfastR`'s `fg_model`): FG Model to be used for
  prediction on field goal (FG) attempts in Play-by-Play data.frame

## Value

play_df with EPA variables added

Updated expected points probabilities with FG make/miss weighted
adjustment

## Details

Code Description

- 1\. `pred_df`::

  Use select before play model variables -\> Make predictions.

- 2\. `epa_fg_probs`::

  Update expected points predictions from before variables with FG
  make/miss probability weighted adjustment.

- 3\. `pred_df_after`::

  Use select after play model variables -\> Make predictions.

- 4\. `join_ep`::

  Join `ep_before` calcs `pred_df` with `ep_after` calcs `pred_df_after`
  on c("game_id","drive_id","new_id").

- 5\. `kickoffs`::

  Calculate ep_before for kickoffs as if the pre-play assumption is a
  touchback.

- 6\. `wpa_prep`::

  Prep variables for WPA.
