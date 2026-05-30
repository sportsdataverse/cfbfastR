# cfbfastR ESPN return-shape audit

**Generated:** 2026-05-30
**Scope:** every exported `espn_cfb_*` function across the seven ESPN files (70 exported + 3 internal aliases = 73 audit targets).
**Out of scope:** the official CollegeFootballData API (`cfbd_*()`) and recruiting / 247sports endpoints — those are league-API surfaces and have their own conventions.

## Preference contract being audited against

> ESPN and other non-league API wrappers should return a **single wide rectangular `cfbfastR_data` tibble** with `janitor::clean_names()` applied. Lists of tibbles and nested list-columns are discouraged unless the upstream payload has multiple distinct row grains that genuinely cannot be merged without information loss. Very wide tables are preferred.
> The return must also be **self-describing**: every input parameter (game_id, team, season, season_type, week, conference, etc.) must be echoed back as a column on every row, plus full game/team meta where applicable.

This is the SDV-family-wide standard shared with wehoop and hoopR.

## Tier definitions

| Tier | Meaning | Action |
|------|---------|--------|
| **A** | Already compliant: single wide self-describing `cfbfastR_data` tibble. | No work. |
| **B** | Single tibble, identity-incomplete. | Add `dplyr::mutate(arg = arg)` before `make_cfbfastR_data()`. |
| **C** | Named list of tibbles whose components share a join key. | Decision: collapse vs. document grain. |
| **D** | Named list with genuinely unmergeable grains. | Keep as list; document. |
| **E** | Single tibble with un-flattened nested list-columns. | Flatten (or document if opt-in). |

## Summary

| Tier | Count | % | Status |
|------|------:|--:|--------|
| A — Compliant | 62 | 88% | No work |
| B — Identity-incomplete | 8 | 11% | Trivial fix |
| C — List with shared key | 0 | 0% | n/a |
| D — Multi-grain list | 0 | 0% | n/a |
| E — Nested list-columns (opt-in) | 1 family | <1% | **Intentional — keep, document better** |

**Bottom line:** cfbfastR is the most compliant of the three packages. All 70 ESPN wrappers return a single wide `cfbfastR_data` tibble. The few remaining gaps are identity-echo patches in projection/situation endpoints. The one nested-list-column pattern (`espn_cfb_game_drives(plays = "list")`) is an explicit user choice via parameter, not an oversight — keep but document.

---

## Tier A — Already compliant

Listed by file with row grain. All carry `cfbfastR_data` class and `clean_names()`-normalized columns.

### `R/espn_cfb_game.R` (25 functions)

| Function | Row grain | Notes |
|----------|-----------|-------|
| `espn_cfb_pbp()` | one play | Legacy site-v2 path; full home/away meta |
| `espn_cfb_pbp_v2()` | one play | Core-v2 path with optional EPA/WPA enrichment — recommended successor |
| `espn_cfb_game_pbp()` | one play | core-v2 game play feed |
| `espn_cfb_game_drives()` (default `plays = "expand"`) | one play within drive | Drive meta echoed |
| `espn_cfb_game_drives(plays = "none")` | one drive | Drive-only grain |
| `espn_cfb_game_leaders()` | one (category × leader) | long format |
| `espn_cfb_game_odds()` | one provider | `line_history = TRUE` produces snapshot grain |
| `espn_cfb_game_player_box()` | one player-game | full identity |
| `espn_cfb_game_player_statistics()` | one (athlete × category × stat) | long format |
| `espn_cfb_game_team_statistics()` | one (team × category × stat) | long format |
| `espn_cfb_game_team_leaders()` | one (team × category × leader) | long format |
| `espn_cfb_game_summary` / `_header` / `_info` / `_competitions` / `_competitors` / `_broadcasts` / `_athletes` / `_athlete_box` | one row per appropriate entity | Game-detail family — all compliant |
| `espn_cfb_game_record` / `_records` / `_team_records` | one record entry | Compliant |
| `espn_cfb_unnest_plays()` (helper) | n/a | Internal utility |
| `espn_cfb_clear_cache()` (utility) | n/a | No return |

### `R/espn_cfb_catalog.R` (11 functions)

| Function | Row grain |
|----------|-----------|
| `espn_cfb_positions()` / `espn_cfb_position()` | one position |
| `espn_cfb_venues()` / `espn_cfb_venue()` | one venue |
| `espn_cfb_franchises()` / `espn_cfb_franchise()` | one franchise |
| `espn_cfb_coaches()` / `espn_cfb_coach()` | one coach |
| `espn_cfb_awards()` / `espn_cfb_award()` | one award |

### `R/espn_cfb_team.R` (13 functions)

| Function | Row grain |
|----------|-----------|
| `espn_cfb_team()` | one team (1 row) |
| `espn_cfb_teams()` | one team |
| `espn_cfb_team_roster()` | one athlete |
| `espn_cfb_team_schedule()` | one event |
| `espn_cfb_team_events()` | one event |
| `espn_cfb_team_leaders()` | one (category × leader) |
| `espn_cfb_team_ranks()` | one ranking entry |
| `espn_cfb_team_powerindex()` | one team-season rating |
| `espn_cfb_team_ats()` | one ATS record |
| `espn_cfb_team_record()` | one record-type |
| `espn_cfb_team_coaches()` | one coach-tenure |
| `espn_cfb_team_awards()` | one award |
| `espn_cfb_team_stats()` | one (team × category × stat) |

### `R/espn_cfb_season.R` (9 functions)

| Function | Row grain |
|----------|-----------|
| `espn_cfb_seasons()` / `espn_cfb_season_info()` | one season |
| `espn_cfb_season_types()` | one season type |
| `espn_cfb_season_weeks()` | one week |
| `espn_cfb_groups()` | one group |
| `espn_cfb_rankings()` / `espn_cfb_week_rankings()` | one ranking |
| `espn_cfb_standings()` | one (team × record × stat) |

### `R/espn_cfb_schedule.R` (3 functions)

| Function | Row grain |
|----------|-----------|
| `espn_cfb_scoreboard()` | one game |
| `espn_cfb_schedule()` | one game |
| `espn_cfb_calendar()` | one calendar entry |

### `R/espn_cfb_player.R` (10 functions)

| Function | Row grain |
|----------|-----------|
| `espn_cfb_player()` | one athlete (1 row) |
| `espn_cfb_players()` | one athlete |
| `espn_cfb_player_seasons()` | one season |
| `espn_cfb_player_eventlog()` | one event |
| `espn_cfb_player_gamelog()` | one game |
| `espn_cfb_player_splits()` | one split |
| `espn_cfb_player_overview()` | one section (long) |
| `espn_cfb_player_statistics()` | one (category × stat) |
| `espn_cfb_player_stats()` | one player-season |
| `espn_cfb_recruits()` | one recruit |

### `R/espn_cfb_ratings.R` (6 functions)

| Function | Row grain |
|----------|-----------|
| `espn_cfb_futures()` | one futures market |
| `espn_cfb_powerindex()` | one team-rating |
| `espn_cfb_qbr()` | one (athlete × season) |
| `espn_cfb_fpi()` | one team-rating |
| `espn_cfb_metrics_wp()` | one play (WP) |

**Tier A subtotal: 62 functions.**

---

## Tier B — Single tibble, identity-incomplete

These return a single tibble but miss an echoed input or carry minimal game/team context. All fixes are mechanical.

| Function | Helper / file | Missing columns | Fix |
|----------|---------------|-----------------|-----|
| `espn_cfb_game_play()` | `R/espn_cfb_game.R` | `play_id` not echoed (game_id is) | `dplyr::mutate(play_id = play_id)` before `make_cfbfastR_data()` |
| `espn_cfb_game_predictor()` | same | `home_team_id` / `away_team_id` / team names sparse when `team_detail = FALSE` | Always run `.espn_cfb_attach_team_meta()` or document `team_detail = TRUE` as the default |
| `espn_cfb_game_powerindex()` | same | same — team meta sparse | same approach |
| `espn_cfb_game_probabilities()` | same | minimal team context on per-play WP rows | Add `home_team_id`, `away_team_id`, `home_team_name`, `away_team_name` mutate |
| `espn_cfb_game_situation()` | same | game_id echoed, team meta sparse | Same |
| `espn_cfb_game_status()` | same | game_id, no team meta | `mutate(game_id = game_id)` + optional team attach |
| `espn_cfb_coach_record()` | `R/espn_cfb_catalog.R` | season / year not systematically per-row | `dplyr::mutate(coach_id = coach_id, year = year)` |
| `espn_cfb_team_stats()` / `espn_cfb_player_stats()` | team/player files | spot-check that `season`, `season_type`, `year`, identifier are on every row | Verify; mutate if absent |

**Tier B subtotal: 8 functions.**

---

## Tier C — List return, components share a key

None. cfbfastR does not return named lists of tibbles in its ESPN family.

---

## Tier D — Genuinely multi-grain list returns

None.

---

## Tier E — Tibbles with surviving nested list-columns

| Function | Nested column | Status / action |
|----------|---------------|-----------------|
| `espn_cfb_game_drives(plays = "list")` | `plays` list-column (each cell is a tibble of plays for that drive) | **INTENTIONAL.** The `plays` parameter explicitly offers three shapes: `"list"` (nested), `"expand"` (flat — default for most callers), `"none"` (drive-only). Users opt into the list-column shape for drill-down. No fix; **document the parameter more prominently** in roxygen `@details`. |
| Functions with `participants_list = TRUE` or `team_participants_list = TRUE` | optional `participants` / `team_participants` list-columns | **INTENTIONAL OPT-IN.** Default is fully rectangular. Document the flags. |

**Tier E subtotal: 1 family, all explicit user-controlled.** Not a compliance gap.

---

## Top wins (ordered by impact ÷ effort)

| # | Win | Effort | Impact |
|---|-----|-------:|-------:|
| 1 | Attach `home_team_id` / `away_team_id` / team names to the 5 game-projection functions (`predictor`, `powerindex`, `probabilities`, `situation`, `status`) via a shared `.espn_cfb_attach_team_meta()` helper | 30 min | high — eliminates 5 Tier B entries |
| 2 | `espn_cfb_game_play()` echo `play_id` | 2 min | low-medium |
| 3 | `espn_cfb_coach_record()` echo `year` + `coach_id` per row | 5 min | medium |
| 4 | Spot-check `espn_cfb_team_stats()` / `_player_stats()` for full identity echoing | 10 min | low |
| 5 | Roxygen `@details` callout: "Default return is fully rectangular. To get drives with a nested `plays` list-column, pass `plays = 'list'`. To opt-in to participant list-columns, pass `participants_list = TRUE`." | 15 min | medium — doc clarity |
| 6 | Deprecation marker on `espn_cfb_pbp()` (legacy site-v2) recommending `espn_cfb_pbp_v2()` | 5 min | low — codebase hygiene |
| 7 | Confirm `.attach_query_meta_auto(df)` runs at the bottom of every ESPN function (audit by grep) | 10 min | medium — self-describing guarantee |
| 8 | Add Suggest-level test that any espn_cfb_* default return has `purrr::none(., is.list)` over column-types (excludes opt-in list-column funcs) | 20 min | medium — regression guard |

---

## Architectural opportunities

1. **`.attach_query_meta_auto(df)` invariant.** This helper appears to attach input-parameter metadata as columns / attributes at the end of each ESPN parser. Make it a hard contract — every `espn_cfb_*` parser must terminate with it. A simple Grep CI check could enforce this:

   ```r
   # tools/checks/check_meta_auto.R
   files <- list.files("R", pattern = "^espn_cfb_.*\\.R$", full.names = TRUE)
   for (f in files) {
     src <- readLines(f)
     if (any(grepl("function\\s*\\(", src)) && !any(grepl(".attach_query_meta_auto", src))) {
       warning(sprintf("Missing .attach_query_meta_auto() in %s", f))
     }
   }
   ```

2. **`espn_cfb_pbp()` → `espn_cfb_pbp_v2()` deprecation path.** `_v2` composes `espn_cfb_game_drives(plays = "expand")` internally and is the canonical PBP path going forward. Mark the legacy site-v2 wrapper with `lifecycle::deprecate_warn()` in the next minor release; remove in the major after.

3. **Shared participants attach helper.** The `participants` / `team_participants` opt-in pattern is consistent across the game-detail family. Ensure the helper that builds these list-columns is shared (one implementation, used by all callers) rather than duplicated per file.

4. **Default-flat invariant.** The "default return is fully rectangular" promise is currently implicit. Make it explicit in `CLAUDE.md` and pkgdown's overview vignette so users know they can chain `dplyr` verbs without `unnest()`-ing unless they explicitly opted into a list-column.

---

## Implementation order recommendation

1. **Batch 1 (Tier B identity, 1 PR):** Patch 5 game-projection functions to attach team meta + echo `play_id` / `coach_id` / `year` where missing. ~30 min total.
2. **Batch 2 (documentation, 1 PR):** Roxygen callouts for `plays = "list"` and `participants_list = TRUE`; add the default-flat invariant note to `CLAUDE.md`.
3. **Batch 3 (CI / regression):** Add the `.attach_query_meta_auto()` invariant grep check and the list-column-free test for default returns.
4. **Batch 4 (deprecation):** `espn_cfb_pbp()` → `espn_cfb_pbp_v2()` lifecycle warning in the next minor.

---

## Comparison to wehoop / hoopR

| Aspect | wehoop | hoopR | cfbfastR |
|--------|-------:|------:|---------:|
| Functions audited | 163 | ~170 | 70 |
| % Tier A compliant | 86% | 82% | **88%** |
| Tier B count | 14 | ~4 | 8 |
| Tier C count | 10 | 10 | **0** |
| Priority collapse refactor | `athlete_stats` | `betting` | — none — |
| Keep-as-list bundles | 4 | 3 | 0 |
| Tier E (nested) | ~2 (unintended) | ~6 (unintended) | 1 family (intentional opt-in) |

cfbfastR sets the standard the other two are converging on: **every ESPN wrapper returns a flat `cfbfastR_data` tibble by default; nesting is parameter-gated and explicit.** wehoop and hoopR retained their `game_all` / `team` / `athlete_info` named-list aggregators for compatibility — cfbfastR never adopted them.

---

## Related references

- `tools/docs/espn_rectangularization_audit.md` in the wehoop and hoopR repos — sibling audits, identical methodology
- SDV memory: `feedback-espn-wide-rectangular-returns`, `feedback-return-self-describing`

---

# Appendix: Empty / NULL / 404 return audit

**Generated:** 2026-05-30. **Sources:** R-CMD-check workflow run `26670459866` (Windows runner, PR `refactor/pbp-epa-wpa-modular` head, 13h ago, job `78612528600`); full-tree grep of `R/espn_*.R` for the CLAUDE.md "Return-Value Initialization" pattern; helper inspection of `.attach_query_meta_auto()` and `.attach_query_meta()` in [R/utils_attach_query_meta.R](../../R/utils_attach_query_meta.R). No `tools/example_runs/` or `tools/probes/` artifacts exist in this repo — coverage gap noted below.

## CI signal (PR run, 2026-05-30)

```
[ FAIL 0 | WARN 0 | SKIP 5 | PASS 958 ]
```

Skip breakdown:

| Skip reason | Count | Meaning |
|-------------|------:|---------|
| `On CI` (`skip_on_ci()` in `test-pbp_equivalence.R` only) | 4 | CFBD/ESPN PBP equivalence harness; intentionally local-only |
| `ESPN calendar (current) returned no rows at test time` | 1 | `espn_cfb_calendar()` — live API call ran, returned 0 rows (May 29, between bowls/spring); test guard skipped the schema assert |
| **None** flagged `Invalid arguments`, `API returned an error`, `404`, or `No rows returned` | 0 | — |

**Key finding:** cfbfastR ESPN tests are run **live on CI** (only `skip_on_cran()` gates them — no blanket `skip_on_ci()` like wehoop), and **958 of them pass green.** Across the 73 `test-espn_*.R` files (118 `test_that()` blocks) the only empty return surfaced was `espn_cfb_calendar()` mid-off-season, which is correctly defensive — wrapper emits `2026-05-30 01:32:20.856875: invalid input or no ESPN calendar available!` and returns an empty tibble; the test guard skips rather than fails.

## example_runs / probe artifacts

| Artifact | Present? | Notes |
|----------|---------:|-------|
| `tools/example_runs/_results.csv` | **No** | Directory does not exist |
| `tools/example_runs/TRIAGE.md` | **No** | — |
| `tools/probes/` | **No** | — |

**Coverage gap:** cfbfastR has no committed example-batch artifact (the wehoop equivalent that triaged 80 examples into root-cause buckets pre-`a12bbea`). The live-CI test pass count partly compensates, but a `tools/example_runs/run_all.R` + `_results.csv` would still provide:

1. A separate signal channel from testthat (e.g. examples that pass `R CMD check` but emit an unintended message).
2. A regression baseline diffable across PRs.
3. Per-example timing for slow-endpoint hunting.

The wehoop appendix's "Option 3 — bake the example-batch into a scheduled job" applies cleanly here.

## NULL-init source sweep

Pattern hunted (per CLAUDE.md "Return-Value Initialization" rule):

```r
some_func <- function(...) {
  some_var <- NULL                                # bug for tibble returns
  tryCatch(expr = { some_var <- <tibble pipeline> }, ...)
  return(some_var)
}
```

Method: `Grep` for `<-\s*NULL` across `R/espn_*.R` (53 hits), then for each hit triaged by context — return-var init vs. list-element drop vs. inner-loop sentinel.

| Function | File:line of NULL hit | Return type | Verdict |
|----------|----------------------|-------------|---------|
| `espn_cfb_team_schedule()` competitor split | [R/espn_cfb_team.R:2126-2127](../../R/espn_cfb_team.R#L2126) (`self <- NULL`, `opp <- NULL`) | `tibble` | **False positive.** Inner-loop sentinels — the outer return-var is `df <- data.frame()` at [L2102](../../R/espn_cfb_team.R#L2102). Correct. |
| 22× `team_df[["fieldname"]] <- NULL` | [R/espn_cfb_team.R:2587-2606](../../R/espn_cfb_team.R#L2587), [R/espn_cfb_player.R:2382-2401, 2448+](../../R/espn_cfb_player.R#L2382) | n/a | **False positive.** List-element drops to flatten ESPN's payload, not return-var inits. |
| All 7 Tier-B candidates flagged by prompt | see table below | tibble | **All correct** — every one inits `df <- data.frame()` before `tryCatch`. |

Tier-B candidates (from prompt) — explicit verification:

| Function | Init line | Status |
|----------|-----------|--------|
| `espn_cfb_game_status()` | [R/espn_cfb_game.R:4700](../../R/espn_cfb_game.R#L4700) `df <- data.frame()` | OK |
| `espn_cfb_game_situation()` | [R/espn_cfb_game.R:4580](../../R/espn_cfb_game.R#L4580) `df <- data.frame()` | OK |
| `espn_cfb_game_predictor()` | [R/espn_cfb_game.R:4208](../../R/espn_cfb_game.R#L4208) `df <- data.frame()` | OK |
| `espn_cfb_game_powerindex()` | [R/espn_cfb_game.R:4031](../../R/espn_cfb_game.R#L4031) `df <- data.frame()` | OK |
| `espn_cfb_game_probabilities()` | [R/espn_cfb_game.R:4413](../../R/espn_cfb_game.R#L4413) `df <- data.frame()` | OK |
| `espn_cfb_game_play()` | [R/espn_cfb_game.R:3243](../../R/espn_cfb_game.R#L3243) `df <- data.frame()` | OK |
| `espn_cfb_coach_record()` | [R/espn_cfb_catalog.R:773](../../R/espn_cfb_catalog.R#L773) `df <- data.frame()` | OK |

Aggregate: across 71 exported `espn_cfb_*` wrappers, **0 genuine NULL-init bugs** were found. cfbfastR does not share wehoop's `espn_wnba_conferences()` defect — every tibble-returning ESPN wrapper initializes `df <- data.frame()` (or `plays_df <- data.frame()`) before `tryCatch`. Cross-checked: 66 `df <- data.frame()` inits paired against 117 `return(df)` sites — the delta is early-return guards inside the success path (e.g. `if (length(items) == 0) return(df)`), not uninited returns.

### `.attach_query_meta_auto()` interaction with errors

The helper is called as `return(.attach_query_meta_auto(df))` **outside** the `tryCatch` in every ESPN wrapper that uses it (47 sites across 6 files). On error, `df` is the pre-initialized empty `data.frame()`, and `.attach_query_meta()` correctly populates typed zero-length vectors for each echo column via [R/utils_attach_query_meta.R:48-51](../../R/utils_attach_query_meta.R#L48):

```r
if (nrow(df) == 0L) {
  for (nm in names(args)) df[[nm]] <- vector(typeof(args[[nm]]), 0L)
}
```

**Net effect:** identity-echo columns are present on error even though the frame is empty. This is the correct contract and stronger than wehoop's `make_wehoop_data()` path. No work needed.

## Permanent empties / known-broken endpoints

| Function | Reason | Status |
|----------|--------|--------|
| `espn_cfb_calendar()` (current season window) | ESPN returns no calendar entries in the off-season tail (mid-May through summer); wrapper emits `invalid input or no ESPN calendar available!` and returns an empty tibble | **Defensive, working as designed.** The test guard at [tests/testthat/test-espn_cfb_calendar.R:23](../../tests/testthat/test-espn_cfb_calendar.R#L23) skips the schema assert when `nrow(x) == 0`. |

No other ESPN endpoints flagged as permanently broken in the CI run or in source-comment notes. CFB's stable seasonal calendar (Sep–Jan competition + bowls, then a long quiet window) generates fewer "ESPN removed the endpoint" cases than WNBA. The off-season empty window for `calendar` is the only recurring shape.

## CI coverage gap

cfbfastR does **not** have wehoop's structural CI gap. The numbers compared:

| Metric | wehoop (push CI 2026-05-29) | cfbfastR (PR CI 2026-05-30) |
|--------|------:|------:|
| `[ PASS ]` | 52 | **958** |
| `[ SKIP ]` | 335 | 5 |
| Skips from `skip_on_ci()` | 324 | 4 (PBP equivalence only) |
| ESPN tests that actually ran live | 1 | ~118 |
| ESPN endpoints with live coverage / total ESPN exports | 1 / 163 (~0.6%) | ~70 / 71 (~99%) |

cfbfastR ESPN tests do not gate on CI, so every push run gives live signal across the full ESPN surface. The trade-off — ESPN rate-limit flake on PR runs — is absorbed by `httr2::req_retry(max_tries = 3, backoff = ~ 2)` in every wrapper.

The one missing piece: no scheduled `tools/example_runs/run_all.R`-style batch to catch examples that succeed but emit unintended messages (the `\donttest{}` blocks are not run under `--as-cran` and `R-CMD-check` doesn't surface stray `message()` calls). A nightly cron that runs every wrapper's first `@examples` block and diffs `_results.csv` would close the loop.

## Remediation plan (ordered)

| # | Fix | Effort | Trigger |
|---|-----|-------:|---------|
| 1 | `espn_cfb_calendar()` — add `@note` documenting expected empty between seasons (May–Aug) so users don't file bug reports | 5 min | Tier-3 (docs only) |
| 2 | Add `tools/example_runs/run_all.R` + commit baseline `_results.csv`; wire into a scheduled GitHub Actions workflow (cron 6h) that diffs the CSV and surfaces regressions as a PR comment | 60 min | Tier-2 (regression infra parity with wehoop's planned setup) |
| 3 | Add an invariant grep check (`.github/workflows/lint-meta-auto.yml` or a `tools/checks/check_init_pattern.R` test) that fails CI if any `^espn_cfb_*` function uses `return(df)` without `df <- data.frame()` (or `plays_df <- data.frame()` etc.) earlier in the function body | 30 min | Tier-3 (prevent regression) |
| 4 | Borrow wehoop's `tools/probes/probe_known_broken.R` shape — even if currently empty, having the file present lets future "endpoint X started 500-ing" investigations slot in without scaffolding | 15 min | Tier-3 |

No source-code bug fixes are needed. cfbfastR's ESPN wrappers are clean against the CLAUDE.md return-init contract, and the live-CI test signal confirms behavior end-to-end.

## Cross-package note

This appendix completes the sibling-audit set with the wehoop and hoopR copies:

- **wehoop** — `espn_wnba_conferences()` + `espn_wbb_conferences()` NULL-init bugs fixed 2026-05-30 (init to typed empty `wehoop_data` tibble with success-case schema); CI coverage gap remains (1/163 live)
- **hoopR** — ~76 genuine NULL-init bugs across `R/espn_basketball_*_helpers.R` + `espn_nba_conferences()` / `espn_mbb_conferences()`; batch fix pending; no `tools/example_runs/` infrastructure
- **cfbfastR** — 0 genuine bugs; near-full live CI coverage; only gap is missing example-runs batch infrastructure

## Reference pattern: `.attach_query_meta()` zero-row-frame handling

cfbfastR's [R/utils_attach_query_meta.R:48-51](../../R/utils_attach_query_meta.R#L48-L51) implements the canonical pattern for "identity columns survive on empty returns" that wehoop and hoopR should adopt during their NULL-init batch fixes:

```r
if (nrow(df) == 0L) {
  for (nm in names(args)) {
    df[[nm]] <- vector(typeof(args[[nm]]), 0L)
  }
} else {
  for (nm in names(args)) {
    df[[nm]] <- args[[nm]]
  }
}
```

**Why this matters:** when an ESPN wrapper returns a zero-row tibble (either because the upstream API errored or legitimately returned no items), naively running `df[[nm]] <- args[[nm]]` would either (a) error on a zero-row frame or (b) silently create a one-row frame with the args repeated. The cfbfastR pattern instead inserts a zero-length vector of the correct type, preserving the row-count of zero while keeping the column schema stable for downstream `bind_rows()` consumers.

**Combined with typed-empty init**, this guarantees three invariants on any ESPN wrapper:

1. Return is always a tibble (never `NULL`) — satisfied by typed empty `*_data` init before `tryCatch`.
2. Column schema is stable across success/empty/error — satisfied by typed-empty init carrying the same column names + types as the success path.
3. Identity columns (echoed inputs) are present even on empty — satisfied by `.attach_query_meta()`'s zero-row branch.

**Recommendation for wehoop / hoopR:** when fixing their NULL-init bugs, port the `.attach_query_meta()` + `.attach_query_meta_auto()` helpers from cfbfastR (or equivalent) and call them at the end of every ESPN wrapper. This collapses three orthogonal concerns (return-init, identity-echo, schema stability) into one well-tested helper, and matches cfbfastR's "any wrapper terminates with `.attach_query_meta_auto(df)`" invariant.

Source files to port:
- [R/utils_attach_query_meta.R](../../R/utils_attach_query_meta.R) — the helper + `.attach_query_meta_auto()` wrapper that introspects calling formals
- Test coverage in `tests/testthat/test-utils_attach_query_meta.R` (if present) — port alongside the helper
