# **CFBD Play-by-Play (v2 Modular EPA/WPA Pipeline) Overview**

- [`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md):
  Get college football play-by-play data — modular EPA/WPA pipeline
  (v2). Thin orchestrator over the shared EPA/WPA engine
  `.run_epa_wpa()`, the canonical play-type taxonomy
  `.pbp_play_types()`, and the canonical output schema
  `.pbp_output_order`. Runs side-by-side with the legacy
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
  entry point until the equivalence harness proves the new path matches.

## Details

The v2 entry point is a thin wrapper around `.run_epa_wpa()` – the
shared engine that powers both the modular (v2) and legacy paths. The
`output = "default" / "lean" / "full"` tier argument selects which
intermediate columns survive the final select: `"default"` drops
pipeline lag/lead intermediates and redundant alternates, `"lean"`
additionally drops the per-branch WPA scratchpad, and `"full"` is the
legacy column set (drops only player-name aliases). The
equivalence-harness allow-list is intentionally permissive about
lag/lead intermediates and per-branch WPA scratchpad columns because
those are mechanically rebuildable from the surviving canonical columns;
the harness only enforces equality on user-facing values.

### **Get college football play-by-play data — modular EPA/WPA pipeline (v2)**

    cfbd_pbp_data_v2(
      year = 2024, week = 1, season_type = "regular",
      epa_wpa = TRUE, output = "default"
    )
