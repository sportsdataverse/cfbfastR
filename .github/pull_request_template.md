<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Pull Request](#pull-request)
- [Summary](#summary)
- [Type of Change](#type-of-change)
- [Related Issues](#related-issues)
- [Background & Context](#background-context)
- [Changes Made](#changes-made)
- [Submission Checklist](#submission-checklist)
- [Testing](#testing)
- [Screenshots / Output](#screenshots-output)
- [Reviewer Checklist](#reviewer-checklist)
- [Additional Notes](#additional-notes)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Pull Request

## Summary
<!-- Provide a brief, clear summary of what this PR does (2-3 sentences max) -->

## Type of Change

- [ ] `feat`: New feature (e.g. new `cfbd_*`, `espn_cfb_*`, or `load_cfb_*` wrapper)
- [ ] `fix`: Bug fix
- [ ] `docs`: Documentation only (roxygen, README, NEWS, vignettes)
- [ ] `test`: Adding or updating tests (includes the pbp equivalence harness)
- [ ] `refactor`: Code refactoring (no functional change -- e.g. extracting helpers into `R/pbp_*.R`)
- [ ] `chore`: Maintenance / tooling (`.Rbuildignore`, `tools/`, lockfiles)
- [ ] `perf`: Performance improvement
- [ ] `ci`: GitHub Actions / workflow changes

## Related Issues

<!-- Link related issues: Closes #123, Fixes #456 -->

## Background & Context
<!--
Help future contributors understand the full picture:
- What problem or need prompted this change?
- What was the previous state/behavior? Any upstream API drift (CFBD or ESPN)?
- Link to any relevant threads or discussions (issues, Discord, slack).
- Are there any known limitations or technical debt introduced?
- If this touches the 2.3.0 modular EPA/WPA pipeline (cfbd_pbp_data_v2 /
  espn_cfb_pbp_v2 / .run_epa_wpa() / .pbp_play_types() / .pbp_output_order),
  note how the equivalence harness behaves with your change.
-->


## Changes Made
<!--
List ALL changes in detail. Be specific -- assume the reviewer has no prior context.
Example format:
- Modified `R/cfbd_play.R`: Added retry logic to handle 5xx responses
- Updated `R/espn_cfb_game.R`: Switched data-source description in make_cfbfastR_data()
- Created `R/pbp_xyz.R`: New internal helper for the .run_epa_wpa() pipeline
-->

| File / Resource | Change Description |
| --------------- | ------------------ |
|                 |                    |
|                 |                    |
|                 |                    |
|                 |                    |

## Submission Checklist

- [ ] Code follows tidyverse style (`snake_case`, 2-space indent, native pipe `|>`)
- [ ] Return variables are initialized **before** any `tryCatch` block (e.g. `df_list <- list()`, `plays_df <- NULL`)
- [ ] Column drops use `dplyr::select(-dplyr::any_of(...))`; renames use `dplyr::rename(dplyr::any_of(c(new = "old")))`
- [ ] User-facing messages use `cli::cli_alert_*()` / `cli::cli_warn()` / `cli::cli_abort()` (not `message()` / `stop()` / `warning()`)
- [ ] `devtools::document()` has been run (NAMESPACE updated; no hand-edits to `man/` or `NAMESPACE`)
- [ ] New / changed functions have roxygen with `@export`, `@family`, `@return`, and a runnable example (`\donttest{}` for live-network calls)
- [ ] Tests added / updated in `tests/testthat/` with `skip_on_cran()` + `skip_on_ci()` and a skip-if-empty guard right after the API call
- [ ] Column assertions use the **subset direction**: `expect_in(sort(expected), sort(colnames(x)))`
- [ ] If touching the 2.3.0 PBP pipeline: `test-pbp_equivalence.R` still passes (or the allow-list is updated with justification)
- [ ] `devtools::check()` passes with no errors or warnings
- [ ] `NEWS.md` updated under the current `# **cfbfastR 2.3.0**` heading (if user-facing)
- [ ] `cran-comments.md` updated (if behavioural / user-visible)
- [ ] `_pkgdown.yml` updated for new exports that need an explicit reference entry (the `starts_with("cfbd_")` / `starts_with("espn_cfb_")` selectors pick up most prefix-matching additions automatically)
- [ ] `README.Rmd` re-rendered with `devtools::build_readme()` if README content changed
- [ ] `DESCRIPTION` normalized with `usethis::use_tidy_description()` if it was edited
- [ ] doctoc TOC re-run if any of `NEWS.md` / `CLAUDE.md` / `CONTRIBUTING.md` / `.github/copilot-instructions.md` / `.github/pull_request_template.md` changed
- [ ] Commit messages use conventional commit format (`type: description`); no AI co-authors

## Testing

<!-- How was this tested? Which years / weeks / game IDs / team IDs / params? -->

Describe how you verified these changes work correctly:

- Tests run locally:
  - [ ] `devtools::test()` (offline -- network tests skip cleanly)
  - [ ] `devtools::test()` with `CFBD_API_KEY` set (live CFBD)
  - [ ] `devtools::test()` with ESPN connectivity (live `espn_cfb_*`)
  - [ ] `tests/testthat/test-pbp_equivalence.R` (if you touched PBP / EPA / WPA)
- Manual smoke calls (paste a couple of representative invocations):

```r
# e.g.
# cfbd_pbp_data_v2(year = 2023, week = 1, output = "default")
# espn_cfb_pbp_v2(game_id = "401520281")
```

- Current production code execution time:
- Proposed new code execution time:

## Screenshots / Output

<!-- If applicable, paste sample output, a glimpse() of the returned tibble, or a screenshot. -->

---

## Reviewer Checklist

**Reviewers: Do not approve until all items are verified**

- [ ] Summary clearly explains what this PR does
- [ ] Background & Context provides enough information for someone unfamiliar with the change
- [ ] All changed files are documented with descriptions in the Changes Made table
- [ ] Testing approach is documented and sufficient (offline + live coverage where relevant)
- [ ] Documentation (`NEWS.md`, `cran-comments.md`, `_pkgdown.yml`, roxygen) has been updated or marked N/A with justification
- [ ] Are all items in the PR template completed properly?

---

## Additional Notes
<!-- Any other information reviewers should know -->
