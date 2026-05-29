---
name: Bug report
about: Report a problem with a cfbfastR function or data loader
title: "[bug] <short description>"
labels: ["bug", "needs-triage"]
assignees: ""

---

## Describe the bug

A clear and concise description of what the bug is (error message, wrong values,
unexpected `NA`s, schema drift, etc.).

## Which data source / function?

- [ ] `cfbd_*()` — College Football Data API
- [ ] `espn_cfb_*()` — ESPN College Football endpoints
- [ ] `espn_metrics_wp()` / `espn_ratings_fpi()`
- [ ] `load_cfb_*()` — Full-season loaders (pbp, rosters, schedules, teams)
- [ ] `update_cfb_db()` — Local PBP database builder
- [ ] EPA / WPA helpers (`create_epa`, `create_wpa_naive`, `prep_epa_df_after`, ...)
- [ ] Other (please specify):

**Function name(s):**

```
e.g. cfbd_play_stats_player(year = 2024, week = 5, team = "Texas")
```

## Reproducible example

Please include a minimal reprex. The shortest call that reproduces the issue is
ideal. If the issue is data-shaped (missing columns, wrong values for a
specific game), include the relevant `game_id` / `year` / `team` arguments.

```r
# install.packages("cfbfastR") # or remotes::install_github("sportsdataverse/cfbfastR")
library(cfbfastR)

# Smallest call that reproduces the problem:
out <- cfbd_play_stats_player(year = 2024, week = 5, team = "Texas")

# Observed vs expected:
str(out)
```

## Expected behavior

A clear and concise description of what you expected to happen (e.g. column
`player_name` populated, non-zero rows for a known game, EPA values matching a
prior season run).

## Error message / output

If applicable, paste the full error / warning output here (please use a code
fence — do **not** paste screenshots of text).

```
# Error in ...
```

## Session info

Please run the following and paste the output:

```r
sessionInfo()
# or
sessioninfo::session_info()
packageVersion("cfbfastR")
R.version.string
```

```
# Paste output here
```

## Additional context

Anything else relevant — proxy / firewall, CFBD API key tier, recent CFBD API
changes you're aware of, screenshots of plots (if a rendering issue), links to
related issues or PRs.
