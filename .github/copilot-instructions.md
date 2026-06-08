<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [cfbfastR Copilot Instructions](#cfbfastr-copilot-instructions)
- [Project Context](#project-context)
- [Repository Workflow](#repository-workflow)
- [Build & Development Commands](#build--development-commands)
- [Function Naming](#function-naming)
- [Code Style](#code-style)
- [Return-Value Initialization (CRITICAL)](#return-value-initialization-critical)
- [Messaging Layer (cli)](#messaging-layer-cli)
- [Data Processing Pipeline](#data-processing-pipeline)
- [Column Drift Resilience](#column-drift-resilience)
- [Scalar Defaults + `cli::cli_abort` Validation](#scalar-defaults--clicli_abort-validation)
- [Self-Describing Returns](#self-describing-returns)
- [HTTP Layer](#http-layer)
- [Testing](#testing)
- [Documentation Maintenance](#documentation-maintenance)
- [Conventional Commits](#conventional-commits)
- [Common Pitfalls](#common-pitfalls)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# cfbfastR Copilot Instructions

## Project Context

cfbfastR is an R package (v2.3.0 dev) that provides clean, tidy college football play-by-play, schedule, roster, ratings, and box-score data. It wraps the CollegeFootballData API (CFBD) and ESPN College Football endpoints, exporting 150+ functions across four function-family prefixes: `cfbd_*()`, `espn_cfb_*()`, `espn_metrics_*()`, and `espn_ratings_*()`. Full-season parquet/RDS releases land under `load_cfb_*()`. The package uses roxygen2 for documentation, testthat for testing, and pkgdown for the documentation site (https://cfbfastr.sportsdataverse.org/).

When this file conflicts with the repository's developer docs, follow `CLAUDE.md`, `CONTRIBUTING.md`, and the current test implementations under `tests/testthat/` as the source of truth.

**If a section here is incomplete, see `CLAUDE.md` for the full development guide.**

## Repository Workflow

- Use feature branches for changes.
- `main` is the default branch and release branch.
- The active 2.3.0 development work lives on `refactor/pbp-epa-wpa-modular` -- the modular PBP/EPA/WPA engine, the ESPN catalog refactor, and the equivalence harness all merge into that branch before promotion to `main`.
- For any change to exported functions, update tests and documentation in the same PR.

## Build & Development Commands

```r
# Regenerate roxygen documentation + NAMESPACE
devtools::document()

# Run all tests
devtools::test()

# Run a specific test file
testthat::test_file("tests/testthat/test-pbp_equivalence.R")

# Full R CMD check
devtools::check()

# Build pkgdown site locally
pkgdown::build_site()
```

## Function Naming

| Data Source                            | Prefix             | Example                                            |
| -------------------------------------- | ------------------ | -------------------------------------------------- |
| CollegeFootballData API                | `cfbd_`            | `cfbd_pbp_data()`, `cfbd_stats_game_havoc()`       |
| ESPN College Football catalog          | `espn_cfb_`        | `espn_cfb_pbp()`, `espn_cfb_team()`                |
| ESPN win-probability metrics           | `espn_metrics_`    | `espn_metrics_wp()`                                |
| ESPN ratings                           | `espn_ratings_`    | `espn_ratings_fpi()`                               |
| Full-season data loaders               | `load_cfb_`        | `load_cfb_pbp()`, `load_cfb_schedules()`           |

The CFBD API requires a bearer token. Set the `CFBD_API_KEY` environment variable; users can register one via `register_cfbd()` and confirm with `cfbd_api_key_info()` / `has_cfbd_key()`.

## Code Style

- Follow tidyverse style: snake_case for variables/functions, 2-space indentation.
- cfbfastR targets R `>= 4.1.0` and uses the **native pipe `|>` exclusively**. `%>%` has been swept out of `R/`, `tests/`, and `vignettes/`, and `magrittr` is no longer in `Imports`. Two patterns that don't port cleanly to `|>`: `|> `[[`("name")` errors under R 4.1 (use `|> purrr::pluck("name")` instead), and `|> tibble::tibble(col = .data$.)` is a magrittr quirk that creates a duplicate column (use `tibble::tibble(col = <lhs>)` directly).
- Use `%||%` (re-exported from rlang) for null-safe defaults: `value <- obj$field %||% NA_character_`. Do not redefine it locally; import via `@importFrom rlang %||%`.
- All returned data frames must pass through `janitor::clean_names()` then `make_cfbfastR_data()`.
- Internal/non-exported helpers are prefixed with `.` (e.g., `.run_epa_wpa()`, `.espn_pbp_game_meta()`, `.attach_query_meta_auto()`).
- Keep imports minimal and explicit; remove unused imports.

## Return-Value Initialization (CRITICAL)

Every wrapper that returns a variable assigned inside a `tryCatch` must initialize that variable **before** the `tryCatch` block. Otherwise, when the API errors (CFBD rate limits, ESPN 500s, HTTP/2 stream errors, connection resets) the `error` handler runs, the return variable is never bound, and `return(<var>)` throws `object '<var>' not found` instead of the intended `cli::cli_alert_danger()` + empty fallback.

```r
cfbd_func <- function(year, ...) {
  base_url <- "https://api.collegefootballdata.com/games"
  params   <- list(year = year, ...)

  df_list <- list()   # <-- MANDATORY. Initialize before tryCatch.

  tryCatch(
    expr = {
      resp    <- .cfbd_request(url = base_url, query = params)
      df_list <- resp |>
        data.frame(stringsAsFactors = FALSE) |>
        dplyr::as_tibble() |>
        janitor::clean_names() |>
        make_cfbfastR_data("CFBD games", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: No data for {.val {year}}!")
      cli::cli_alert_danger("Error: {conditionMessage(e)}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: {conditionMessage(w)}")
    },
    finally = {}
  )
  return(df_list)
}
```

This rule applies to **every return variable name**, not just `df_list`: `plays_df`, `pbp`, `standings`, `teams`, `recruits`, `coaches`, `ratings`, etc. Initialize to the appropriate empty value -- `list()` for named-list returns, `NULL` for single-object returns, `data.frame()` for tibble returns.

## Messaging Layer (cli)

All user-facing messages use `cli`:

- `cli::cli_alert_danger()` for errors inside `tryCatch` handlers
- `cli::cli_alert_warning()` for warnings inside handlers
- `cli::cli_alert_info()` / `cli::cli_alert_success()` for progress and success
- `cli::cli_warn()` / `cli::cli_abort()` for **raised** conditions (e.g., argument validation, mis-set API key)

**Do not pass raw condition objects to glue-interpolated `cli_*` calls.** An unparenthesized `{e}` will try to coerce the condition to character. Always extract the message first:

```r
# WRONG -- glue tries to interpolate the condition itself
cli::cli_alert_danger("Error: {e}")

# RIGHT -- pass the message string
cli::cli_alert_danger("Error: {conditionMessage(e)}")
```

## Data Processing Pipeline

```r
raw_data |>
  data.frame(stringsAsFactors = FALSE) |>
  dplyr::as_tibble() |>
  janitor::clean_names() |>
  make_cfbfastR_data("Description of payload", Sys.time())
```

`make_cfbfastR_data()` sets the class to `c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")` and attaches `cfbfastR_timestamp` and `cfbfastR_type` attributes. `dplyr` verbs strip class by default, so apply `make_cfbfastR_data()` **after** the final transformation.

## Column Drift Resilience

Both CFBD and ESPN add columns over time without removing old ones, and occasionally rename or drop columns. Two guardrails apply:

1. **Inside functions** -- when dropping a known-transient column, use `dplyr::select(-dplyr::any_of("colname"))` instead of `dplyr::select(-"colname")`. The bare form errors the moment upstream drops that column; `any_of()` no-ops silently.
2. **Inside pipelines that rename** -- use `dplyr::rename(dplyr::any_of(c(new = "old")))` so a schema drift that removes `old` is survivable.

## Scalar Defaults + `cli::cli_abort` Validation

Function default arguments must be a **single chosen value**, not a `c(...)` vector. Document allowed choices in `@param` and validate inside the body with `cli::cli_abort()`. Do **not** rely on `match.arg(c(...))` -- it conflates "default" with "allowed set", and any caller passing a value at the front of the vector silently gets the first element.

**Before (anti-pattern):**

```r
cfbd_pbp_data_v2 <- function(year, week = NULL,
                             output = c("default", "lean", "full"), ...) {
  output <- match.arg(output)
  # ...
}
```

**After (cfbfastR convention):**

```r
#' @param output Column tier to return. One of `"default"` (recommended baseline),
#'   `"lean"` (compact dashboard set), or `"full"` (every modeled column).
cfbd_pbp_data_v2 <- function(year, week = NULL,
                             output = "default", ...) {
  if (!is.character(output) || length(output) != 1L ||
      !output %in% c("default", "lean", "full")) {
    cli::cli_abort(c(
      "{.arg output} must be one of {.val default}, {.val lean}, or {.val full}.",
      "i" = "Got {.val {output}}."
    ))
  }
  # ...
}
```

This pattern is enforced across the catalog and v2 PBP entry points.

## Self-Describing Returns

Every ESPN catalog wrapper returns a `cfbfastR_data` tibble whose leading columns echo the query arguments that produced it (`season`, `season_type`, `week`, `team_id`, `athlete_id`, `coach_id`, `game_id`, ...). This is implemented by a single helper in `R/utils_attach_query_meta.R`:

```r
df <- df |>
  janitor::clean_names() |>
  make_cfbfastR_data("ESPN CFB scoreboard", Sys.time()) |>
  .attach_query_meta_auto()
```

`.attach_query_meta_auto()` introspects the caller's formals via `sys.function(-1L)` + `parent.frame()` and lifts conventionally-named query args onto the response frame as the **leading** columns. `year` is canonicalised to `season`. Response columns win on name collision -- ESPN is authoritative for any field that already exists in the payload.

Adding a new query arg to a catalog wrapper's signature (e.g., `group_id`) auto-flows through to the response without further edits, as long as the new arg uses one of the conventional names.

## HTTP Layer

- **CFBD** -- base URL `https://api.collegefootballdata.com/`. Auth is a bearer token in the `Authorization: Bearer ...` header, read from `Sys.getenv("CFBD_API_KEY")`. Use `register_cfbd()` to set it interactively. CFBD endpoints are **not** cached.
- **ESPN catalog** -- two base hosts: `site.api.espn.com` (rich JSON for scoreboards, teams, athletes) and `sports.core.api.espn.com` (the `$ref`-heavy "core" API). No auth required. ESPN catalog calls are cached through `cachem` + `memoise`, controlled by `options(cfbfastR.cache = "memory" | "filesystem" | "off")` and `options(cfbfastR.cache_duration = 86400)`. Use `espn_cfb_clear_cache()` after upstream schema changes.

## Testing

- Use `skip_on_cran()` and `skip_on_ci()` guards for all live API tests.
- Add a source-specific env-var skip helper immediately after `skip_on_ci()`:
  - `skip_cfbd_test()` for `test-cfbd_*.R` (requires `CFBD_API_KEY`)
  - `skip_espn_test()` for `test-espn_cfb_*.R` (requires `ESPN_TESTS=1`)
- **Column assertions must always use the subset direction** -- expected ⊆ actual:
  `expect_in(sort(expected_cols), sort(colnames(x)))`. Both CFBD and ESPN add columns without removing old ones, so strict `expect_equal(sort(colnames(x)), sort(cols))` will flag on any new column. The subset direction is the only pattern that survives upstream drift.
- **Always add a skip-if-empty guard immediately after the API call**, before any assertion that touches `x`:

  ```r
  x <- cfbd_games(year = 2023, week = 1)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No rows returned from endpoint at test time")
  }
  ```

  This handles transient 500s, CFBD rate-limit hiccups, and empty responses without polluting the failure report.
- For dynamic columns, `expect_true(all(core_cols %in% colnames(x)))` is equivalent to the subset-direction `expect_in()`.

### Equivalence Harness

`tests/testthat/test-pbp_equivalence.R` asserts that v2 modular PBP (`cfbd_pbp_data_v2()` / `espn_cfb_pbp_v2()`) reproduces the legacy outputs **column-for-column**, with an explicit allow-list of intentional representation deltas (character `id_play`, logical `scoring_play`, total `clock_seconds`, v2 short-name `passer_player_name` / `rusher_player_name` / `receiver_player_name`). Any other column-level drift is a regression.

### Environment Variables

| Variable           | Description                       | Helper                  |
|--------------------|-----------------------------------|-------------------------|
| `CFBD_API_KEY`     | Bearer token for CFBD endpoints   | `skip_cfbd_test()`      |
| `ESPN_TESTS=1`     | Enable ESPN catalog tests         | `skip_espn_test()`      |

## Documentation Maintenance

Two regeneration steps are part of the commit workflow whenever the relevant sources change. Both are mechanical -- never edit the generated regions by hand.

- **Markdown TOCs.** `NEWS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `.github/copilot-instructions.md`, and `.github/pull_request_template.md` carry a doctoc-generated TOC inside marker comments. (`cran-comments.md` is intentionally excluded.) After editing any of them, run:

  ```sh
  Rscript tools/run_doctoc.R --maxlevel 2 \
    NEWS.md CLAUDE.md CONTRIBUTING.md \
    .github/copilot-instructions.md .github/pull_request_template.md
  ```

  Use `--maxlevel 2` (level-3 sub-entries crowd the nav).

- **README.md.** Rendered from `README.Rmd`. After editing the Rmd, run `devtools::build_readme()` and commit `README.Rmd` + `README.md` together. Never hand-edit `README.md`.

- **DESCRIPTION.** After editing `DESCRIPTION`, run `usethis::use_tidy_description()` to normalize field order, alphabetize `Imports`/`Suggests`, and reflow long lines.

- **Release notes triad -- `NEWS.md` / `cran-comments.md` / `_pkgdown.yml`.** Whenever you add a `NEWS.md` bullet, check the other two:
  - `NEWS.md` -- all new bullets go under the most recent **unreleased** version heading (currently `# **cfbfastR 2.3.0**`). Do NOT create a new version section ahead of release.
  - `cran-comments.md` -- every user-visible / behavioral change should be reflected before submission. Internal-only changes can be omitted.
  - `_pkgdown.yml` -- new exports go in the right `reference:` section. `starts_with("cfbd_")` / `starts_with("espn_cfb_")` / `starts_with("load_cfb_")` selectors auto-pick up matching prefixes; explicitly-listed functions need a manual entry.

**Never edit `NAMESPACE` or files under `man/` by hand**; regenerate with `devtools::document()`.

## Conventional Commits

Use the format: `type: description`

Types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`, `style`, `perf`, `ci`

- Optional scope is encouraged (e.g., `feat(pbp): ...`, `docs(catalog): ...`).
- Use `type!:` or a `BREAKING CHANGE:` footer for breaking changes.
- Keep commits logically grouped so each commit is easy to review and revert.

**Important**: Never include AI agents or assistants (e.g., Claude, Copilot) as co-authors on commits. Omit all `Co-Authored-By` trailers referencing AI tools.

## Common Pitfalls

- **Return-value initialization is mandatory**: every wrapper that `return(X)` where `X` is assigned only inside `tryCatch(expr = {...})` must initialize `X` *before* the `tryCatch`. Otherwise, when the API errors, `return(X)` throws `object 'X' not found` instead of the intended empty-frame fallback.
- **CFBD rate limits**: free-tier callers hit a per-minute cap quickly. The wrappers surface a `cli::cli_alert_danger()` on 429, but do not retry in a hot loop -- add a `Sys.sleep()` and re-run the failing range.
- **ESPN `$ref` payloads**: ESPN's "core" API often returns `{"$ref": "https://..."}` placeholders instead of inlined team / athlete / venue metadata. Route new ESPN wrappers that consume team metadata through `.espn_pbp_game_meta()` (which falls back to `.espn_cfb_team_lookup()`) rather than reading team fields directly.
- **`output = c(...)` default**: do **not** declare `output = c("default", "lean", "full")` and call `match.arg()`. Use a single-value default (`output = "default"`) and validate with `cli::cli_abort()`. The c-vector form silently picks the first element when the caller passes a vector.
- **Native pipe + `magrittr` placeholder**: `|>` does **not** support the `.` placeholder. Use `_` (R 4.2+) or wrap in an explicit lambda `\(x) ...`. Mixing `.` after `|>` will silently no-op.
- **`%||%` is rlang-imported**: do not redefine it locally; import via `@importFrom rlang %||%`.
- **`make_cfbfastR_data()` class order**: the class vector is `c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")`. Apply `make_cfbfastR_data()` **after** the final dplyr transformation, since `dplyr` verbs strip class.
- **Column drift**: ESPN and CFBD add columns over time -- use subset-direction column assertions (`expect_in(expected, actual)`) and `dplyr::any_of()` for transient-column drops/renames.
- **Local dev artifacts**: `.vscode`, `.claude`, `.positai`, `.remember`, `tools/` can surface as `R CMD check` notes. Keep `.Rbuildignore` patterns for each.
- **Never hand-edit `NAMESPACE` or files under `man/`**; regenerate with `devtools::document()`.
