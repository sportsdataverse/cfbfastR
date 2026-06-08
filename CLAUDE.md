# CLAUDE.md – cfbfastR Development Guide

**Table of Contents** *generated with
[DocToc](https://github.com/thlorenz/doctoc)*

- [CLAUDE.md – cfbfastR Development
  Guide](#claudemd----cfbfastr-development-guide)
- [Package Overview](#package-overview)
- [Branching & PR Workflow](#branching--pr-workflow)
- [Build & Development Commands](#build--development-commands)
- [Project Structure](#project-structure)
- [Key Coding Conventions](#key-coding-conventions)
- [WP/EPA Pipeline](#wpepa-pipeline)
- [ESPN Catalog Cache](#espn-catalog-cache)
- [Testing](#testing)
- [CFB-Specific Details](#cfb-specific-details)
- [NAMESPACE](#namespace)
- [Documentation Maintenance](#documentation-maintenance)
- [Commit Convention](#commit-convention)
- [Common Pitfalls](#common-pitfalls)

## Package Overview

cfbfastR is an R package that provides clean, tidy college football
play-by-play, schedule, roster, ratings, and box-score data. It wraps
the CollegeFootballData API (CFBD) and ESPN College Football endpoints,
exporting 150+ functions across four function-family prefixes:
`cfbd_*()`, `espn_cfb_*()`, `espn_metrics_*()`, and `espn_ratings_*()`.
Full-season parquet/RDS releases land under `load_cfb_*()`.

When this guide differs from current repository docs, treat
`CONTRIBUTING.md` and current test implementations as authoritative.

- **Version**: 2.3.0 (dev)
- **R Requirement**: \>= 4.1.0 (uses native pipe `|>`)
- **License**: MIT
- **pkgdown site**: <https://cfbfastr.sportsdataverse.org/>
- **Maintainer**: Saiem Gilani (`saiem.gilani@gmail.com`)
- **Branch**: `main` is the default branch and release branch.

## Branching & PR Workflow

- Create feature branches from the latest stable base.
- `main` is the default branch and release branch.
- The active 2.3.0 development work lives on
  `refactor/pbp-epa-wpa-modular` – the modular PBP/EPA/WPA engine, the
  ESPN catalog refactor, and the equivalence harness all merge into that
  branch before promotion to `main`.
- Keep code, tests, and roxygen/docs updates in the same PR when
  changing exported behavior.

## Build & Development Commands

``` r

# Regenerate roxygen documentation + NAMESPACE
devtools::document()

# Run all tests
devtools::test()

# Run a specific test file
testthat::test_file("tests/testthat/test-pbp_equivalence.R")

# Full R CMD check
devtools::check()

# Install locally
devtools::install()

# Build pkgdown site locally
pkgdown::build_site()
```

## Project Structure

    R/                              # All package source code

    # ----- CFBD legacy wrappers (cfbd_*) -----
      cfbd_api_key.R                # register_cfbd(), cfbd_api_key_info(),
                                    #   cfbd_key(), has_cfbd_key()
      cfbd_betting.R                # cfbd_betting_lines(), cfbd_betting_ats()
      cfbd_coaches.R                # cfbd_coaches()
      cfbd_conferences.R            # cfbd_conferences()
      cfbd_draft.R                  # cfbd_draft, cfbd_draft_*
      cfbd_drives.R                 # cfbd_drives()
      cfbd_games.R                  # cfbd_games(), cfbd_game_*, cfbd_calendar(),
                                    #   cfbd_live_scoreboard()
      cfbd_metrics.R                # cfbd_metrics(), cfbd_metrics_*
      cfbd_pbp_data.R               # Legacy PBP entry point (CFBD source)
      cfbd_pbp_data_v2.R            # 2.3.0 v2 orchestrator over the modular engine
      cfbd_play.R                   # cfbd_play(), cfbd_plays(), cfbd_live_plays(),
                                    #   cfbd_play_stat_*, cfbd_play_types_*
      cfbd_players.R                # cfbd_players(), cfbd_player_*
      cfbd_ratings.R                # cfbd_ratings(), cfbd_ratings_*, cfbd_rankings_*
      cfbd_recruiting.R             # cfbd_recruiting(), cfbd_recruiting_*
      cfbd_stats.R                  # cfbd_stats(), cfbd_stats_*, cfbd_stats_game_havoc()
      cfbd_teams.R                  # cfbd_teams(), cfbd_team_*
      cfbd_venues.R                 # cfbd_venues()

    # ----- ESPN catalog (2.3.0 refactor) -----
      espn_cfb_catalog.R            # Catalog dispatcher + shared internals (cache,
                                    #   .espn_pbp_game_meta(), .espn_cfb_team_lookup(),
                                    #   espn_cfb_clear_cache())
      espn_cfb_game.R               # espn_cfb_pbp(), espn_cfb_pbp_v2(),
                                    #   espn_cfb_unnest_plays(), espn_cfb_game_*
      espn_cfb_player.R             # espn_cfb_player(), espn_cfb_players(),
                                    #   espn_cfb_player_*, position/recruits helpers
      espn_cfb_ratings.R            # espn_metrics_wp(), espn_ratings_fpi(),
                                    #   espn_cfb_qbr(), espn_cfb_powerindex()
      espn_cfb_schedule.R           # espn_cfb_scoreboard(), espn_cfb_schedule(),
                                    #   espn_cfb_calendar()
      espn_cfb_season.R             # Season metadata, weeks, rankings, standings, groups
      espn_cfb_team.R               # espn_cfb_team(), espn_cfb_teams(), espn_cfb_team_*

    # ----- Modular PBP / EPA / WPA pipeline (refactor/pbp-epa-wpa-modular) -----
      pbp_adapters.R                # .espn_to_epa_input(), .cfbd_to_epa_input()
                                    #   bridge raw payloads -> canonical EPA input frame
      pbp_epa_wpa_engine.R          # .run_epa_wpa() shared engine called by v2 entry pts
      pbp_play_types.R              # .pbp_play_types() canonical taxonomy
      pbp_output_schema.R           # .pbp_output_order column order + the
                                    #   "default"/"lean"/"full" tier selectors
      pbp_create_epa.R              # create_epa()
      pbp_create_wpa_naive.R        # create_wpa_naive()
      pbp_clean_pbp_dat.R           # clean_pbp_dat(), clean_play_text()
      pbp_clean_drive_dat.R         # clean_drive_dat(), clean_drive_info()
      pbp_prep_epa_df_after.R       # prep_epa_df_after(), epa_fg_probs()
      pbp_add_play_counts.R         # add_play_counts(), add_player_cols(), add_yardage()

    # ----- Loaders & utilities -----
      load_cfb.R                    # load_cfb_rosters(), load_cfb_schedules(),
                                    #   load_cfb_teams()
      load_cfb_pbp.R                # load_cfb_pbp()
      utils.R                       # General helpers: csv_from_url(), rds_from_url(),
                                    #   make_cfbfastR_data(), print.cfbfastR_data
      utils_attach_query_meta.R     # .attach_query_meta_auto() for ESPN catalog wrappers
      zzz.R                         # .onLoad(): cachem + memoise wiring, options defaults

    tests/testthat/                 # Test files (incl. test-pbp_equivalence.R,
                                    #   tier-monotonicity tests)
    man/                            # Auto-generated roxygen docs (DO NOT EDIT)
    NAMESPACE                       # Auto-generated by roxygen2 (DO NOT EDIT)

## Key Coding Conventions

### Function Naming

| Data Source | Prefix | Example |
|----|----|----|
| CollegeFootballData API | `cfbd_` | [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md), [`cfbd_stats_game_havoc()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_havoc.md) |
| ESPN College Football catalog | `espn_cfb_` | [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md), [`espn_cfb_team()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team.md) |
| ESPN win-probability metrics | `espn_metrics_` | [`espn_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/espn_metrics.md) |
| ESPN ratings | `espn_ratings_` | [`espn_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.md) |
| Full-season data loaders | `load_cfb_` | [`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md), [`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.md) |

The CFBD API requires a bearer token. Set the `CFBD_API_KEY` environment
variable; users can register one via
[`register_cfbd()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)
and confirm with
[`cfbd_api_key_info()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)
/
[`has_cfbd_key()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md).

### Native pipe `|>`

cfbfastR targets R `>= 4.1.0` and uses the native pipe `|>` exclusively.
The legacy `%>%` has been swept out of `R/`, `tests/`, and `vignettes/`,
and `magrittr` is no longer in `Imports`. New code must use `|>`. Two
patterns that *don’t* port cleanly to `|>`:

- `|>`\[\[`("name")` – native pipe rejects `[[` as RHS in R 4.1. Use
  `|> purrr::pluck("name")` (or assign the chain to a temp and subset).
- `|> tibble::tibble(col = .data$.)` – this magrittr quirk created a
  duplicate column. Use `tibble::tibble(col = <lhs>)` directly.

### Return-Value Initialization (CRITICAL)

Every wrapper that returns a variable assigned inside a `tryCatch` must
initialize that variable **before** the `tryCatch` block. Otherwise,
when the API errors (500s, timeouts, HTTP/2 stream errors, connection
resets, CFBD rate limits) the `error` handler runs, the return variable
is never bound, and `return(<var>)` throws `object '<var>' not found`
instead of the intended
[`cli::cli_alert_danger()`](https://cli.r-lib.org/reference/cli_alert.html) +
empty fallback.

``` r

cfbd_func <- function(year, ...) {
  base_url <- "https://api.collegefootballdata.com/games"
  params   <- list(year = year, ...)

  plays_df <- data.frame()   # <-- MANDATORY. Not inside tryCatch.

  tryCatch(
    expr = {
      resp <- .cfbd_request(url = base_url, query = params)
      plays_df <- resp |>
        data.frame(stringsAsFactors = FALSE) |>
        dplyr::as_tibble() |>
        janitor::clean_names() |>
        make_cfbfastR_data("CFBD games from collegefootballdata.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger(
        "{Sys.time()}: Invalid arguments or no data for {.val {year}} available!"
      )
      cli::cli_alert_danger("Error:\n{conditionMessage(e)}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{conditionMessage(w)}")
    },
    finally = {}
  )
  return(plays_df)
}
```

This rule applies to **every return variable name**, not just
`plays_df`: `df_list`, `pbp`, `standings`, `teams`, `recruits`,
`coaches`, `ratings`, etc. Initialize to the appropriate empty value –
[`list()`](https://rdrr.io/r/base/list.html) for named-list returns,
`NULL` for single-object returns,
[`data.frame()`](https://rdrr.io/r/base/data.frame.html) for tibble
returns.

### Messaging Layer (cli)

All user-facing messages use `cli`:

- [`cli::cli_alert_danger()`](https://cli.r-lib.org/reference/cli_alert.html)
  for errors inside `tryCatch` handlers
- [`cli::cli_alert_warning()`](https://cli.r-lib.org/reference/cli_alert.html)
  for warnings inside handlers
- [`cli::cli_alert_info()`](https://cli.r-lib.org/reference/cli_alert.html)
  /
  [`cli::cli_alert_success()`](https://cli.r-lib.org/reference/cli_alert.html)
  for progress and success
- [`cli::cli_warn()`](https://cli.r-lib.org/reference/cli_abort.html) /
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  for **raised** conditions (e.g., argument validation, mis-set API key)

**Do not pass raw condition objects to `cli_*` calls** – they are
glue-interpolated and an unparenthesized `{e}` will try to coerce the
condition to character. Always extract the message first with a value
placeholder:

``` r

# WRONG -- glue tries to interpolate the condition itself
cli::cli_alert_danger("Error: {e}")

# RIGHT -- pass the message string
cli::cli_alert_danger("Error: {conditionMessage(e)}")
```

### Data Processing Pipeline

``` r

raw_data |>
  data.frame(stringsAsFactors = FALSE) |>
  dplyr::as_tibble() |>
  janitor::clean_names() |>
  make_cfbfastR_data("Description of payload", Sys.time())
```

`make_cfbfastR_data()` sets the class to
`c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")` and
attaches `cfbfastR_timestamp` and `cfbfastR_type` attributes.
`print.cfbfastR_data()` adds a labeled header.

### Null Safety

Use `%||%` (re-exported from rlang) for null-safe defaults throughout:

``` r

value <- obj$field %||% NA_character_
```

This matters especially for the ESPN catalog wrappers, which frequently
return sparsely-populated team / athlete payloads where `$ref`
placeholders take the place of inlined records.

### Column Drift Resilience

Both CFBD and ESPN add columns over time without removing old ones, and
occasionally rename or drop columns. Two guardrails apply:

1.  **Inside functions** – when dropping a known-transient column, use
    `dplyr::select(-dplyr::any_of("colname"))` instead of
    `dplyr::select(-"colname")`. The bare form errors the moment
    upstream drops that column; `any_of()` no-ops silently.
2.  **Inside pipelines that rename** – use
    `dplyr::rename(dplyr::any_of(c(new = "old")))` so a schema drift
    that removes `old` is survivable.

### Scalar Defaults + Explicit `cli::cli_abort` Validation

Function default arguments must be a **single chosen value**, not a
`c(...)` vector. Document the allowed choices in `@param` and validate
inside the body with
[`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html). Do
**not** rely on `match.arg(c(...))` – it conflates “default” with
“allowed set”, and any caller passing a value at the front of the vector
silently gets the first element.

**Before:**

``` r

cfbd_pbp_data_v2 <- function(year, week = NULL,
                             output = c("default", "lean", "full"), ...) {
  output <- match.arg(output)
  # ...
}
```

**After:**

``` r

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

### Self-Describing Returns: `.attach_query_meta_auto()`

Every ESPN catalog wrapper returns a `cfbfastR_data` tibble whose
leading columns echo the query arguments that produced it (`season`,
`season_type`, `week`, `team_id`, `athlete_id`, `coach_id`, `game_id`,
…). This is implemented by a single helper in
`R/utils_attach_query_meta.R`:

``` r

df <- df |>
  janitor::clean_names() |>
  make_cfbfastR_data("ESPN CFB scoreboard", Sys.time()) |>
  .attach_query_meta_auto()
```

`.attach_query_meta_auto()` introspects the caller’s formals via
`sys.function(-1L)` +
[`parent.frame()`](https://rdrr.io/r/base/sys.parent.html) and lifts the
conventionally-named query args onto the response frame as the
**leading** columns. `year` is canonicalised to `season`. **Response
columns win** on name collision – ESPN is authoritative for any field
that already exists in the payload.

The consequence is that adding a new query arg to a catalog wrapper’s
signature (e.g., `group_id`) **auto-flows** through to the response
without further edits, as long as the new arg uses one of the
conventional names. No `dplyr::mutate(season = season, ...)` boilerplate
at the bottom of every wrapper.

### HTTP Layer

- **CFBD** – base URL `https://api.collegefootballdata.com/`. Auth is a
  bearer token in the `Authorization: Bearer ...` header, read from
  `Sys.getenv("CFBD_API_KEY")`. Use
  [`register_cfbd()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)
  to set it interactively.
- **ESPN catalog** – two base hosts: `site.api.espn.com` (rich JSON for
  scoreboards, teams, athletes) and `sports.core.api.espn.com` (the
  `$ref`-heavy “core” API). No auth required.

### Proxy support

`get_req()` (in `R/utils.R`) resolves an outbound proxy in three tiers:

1.  **Explicit `proxy =` argument** (caller-supplied; highest
    precedence).
2.  **`getOption("cfbfastR.proxy")`** – session-level fallback. Set once
    with `options(cfbfastR.proxy = ...)` and every call that flows
    through `get_req()` picks it up.
3.  **`http_proxy` / `https_proxy` / `no_proxy` environment variables**
    – libcurl reads these automatically when no explicit proxy is
    supplied.

The proxy value (whether passed via argument or option) accepts either
form:

- A URL string – `"http://host:port"`, forwarded to
  `httr2::req_proxy(url = ...)`.
- A named list –
  `list(url = "...", port = 8080, username = "...", password = "...", auth = "basic")`,
  spread as keyword args into
  [`httr2::req_proxy()`](https://httr2.r-lib.org/reference/req_proxy.html)
  for authenticated proxies.

**Per-call override** works only for wrappers that thread `...` down to
`get_req()` – typically the `cfbd_*()` family. Wrappers that call
`get_req()` without a `proxy` argument (most of the ESPN catalog) rely
on the option / env-var path. When adding a new wrapper, prefer
threading `proxy = NULL` (or `...`) through to `get_req()` so callers
can override per-call without resetting their session option.

The ESPN catalog wrappers all use `httr2` under the hood, so the env-var
path Just Works for them even without an explicit `proxy` argument.

## WP/EPA Pipeline

The play-by-play / EPA / WPA stack lives in `R/pbp_*.R`. As of 2.3.0
there are two side-by-side surfaces:

- **Legacy entry points**:
  [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
  (CFBD source) and the original
  [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
  (ESPN source). These remain exported and behavior-preserved for
  downstream consumers.
- **v2 entry points**:
  [`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md)
  and
  [`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md).
  Thin orchestrators over the shared **`.run_epa_wpa()`** engine.

The modular pipeline:

1.  **Adapters** (`pbp_adapters.R`) – `.espn_to_epa_input()` and
    `.cfbd_to_epa_input()` translate raw ESPN / CFBD payloads into a
    canonical input frame the engine understands.
2.  **Engine** (`pbp_epa_wpa_engine.R`) – `.run_epa_wpa()` consumes the
    canonical frame, calls
    [`create_epa()`](https://cfbfastR.sportsdataverse.org/reference/create_epa.md) +
    [`create_wpa_naive()`](https://cfbfastR.sportsdataverse.org/reference/create_wpa.md),
    and returns a frame whose play taxonomy is governed by
    `.pbp_play_types()` (`pbp_play_types.R`) and whose column order is
    governed by `.pbp_output_order` (`pbp_output_schema.R`).
3.  **Output tiers** – `output = "default"` (recommended baseline),
    `output = "lean"` (compact dashboard subset), `output = "full"`
    (every modeled column, including intermediate diagnostics). The tier
    is enforced by the scalar-default +
    [`cli::cli_abort`](https://cli.r-lib.org/reference/cli_abort.html)
    validation pattern above and is verified by the tier-monotonicity
    tests (`lean ⊆ default ⊆ full`).
4.  **Game-meta bridge** – for ESPN, `.espn_pbp_game_meta()` resolves
    team / venue / coach metadata that the bare PBP payload omits. When
    ESPN returns a `$ref` placeholder instead of an inlined team record,
    `.espn_pbp_game_meta()` falls back to `.espn_cfb_team_lookup()` so
    the resulting row still has full team metadata. See “Common
    Pitfalls” below.

The equivalence harness `tests/testthat/test-pbp_equivalence.R` asserts
that
[`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md)
and
[`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md)
reproduce the legacy outputs **column-for-column**, with an explicit
allow-list of intentional representation deltas (character `id_play`,
logical `scoring_play`, total `clock_seconds`, v2 short-name
`passer_player_name` / `rusher_player_name` / `receiver_player_name`).

## ESPN Catalog Cache

ESPN catalog calls are cached through `cachem` + `memoise`, wired up in
`R/zzz.R`’s `.onLoad()`. Cache behavior is controlled by two options:

``` r

# Backend: "memory" (default), "filesystem", or "off"
options(cfbfastR.cache = "memory")

# TTL in seconds (default 86400 = 24 hours)
options(cfbfastR.cache_duration = 86400)
```

[`espn_cfb_clear_cache()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_clear_cache.md)
invokes
[`memoise::forget()`](https://memoise.r-lib.org/reference/forget.html)
on every cached catalog endpoint. Use it after schema-affecting upstream
changes or when debugging stale-payload issues. The cache is per-session
for the memory backend and persistent for the filesystem backend (stored
under `tools::R_user_dir("cfbfastR", "cache")`).

CFBD endpoints are **not** cached – the bearer-token API surfaces enough
variation in pagination and date filters that caching would routinely
return wrong rows. Add a
[`Sys.sleep()`](https://rdrr.io/r/base/Sys.sleep.html) between calls if
you are stress-testing the CFBD rate limit.

## Testing

### Test Pattern

**Always use the subset direction for column assertions.** Because both
APIs add columns, strict `expect_equal` will break on any new column.
The rule is: the *expected* list must be a subset of the *actual*
columns.

``` r

test_that("CFBD games endpoint returns expected columns", {
  skip_on_cran()
  skip_on_ci()
  skip_cfbd_test()  # Requires CFBD_API_KEY env var

  x <- cfbd_games(year = 2023, week = 1)

  # Skip-if-empty guard -- always right after the API call, before any assertion
  # that touches x. Handles transient 500s and CFBD rate-limit hiccups.
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No rows returned from endpoint at test time")
  }

  cols_x <- c("id", "season", "week", "home_team", "away_team")
  expect_in(sort(cols_x), sort(colnames(x)))   # expected ⊆ actual
  expect_s3_class(x, "data.frame")
})
```

**Anti-patterns to avoid**:

``` r

# WRONG - flags when upstream adds a column, even though it's non-breaking
expect_equal(sort(colnames(x)), sort(cols_x))

# WRONG - same direction problem, just phrased with expect_in
expect_in(sort(colnames(x)), sort(cols_x))
```

For dynamic columns, `expect_true(all(core_cols %in% colnames(x)))` is
equivalent to the subset-direction `expect_in()`.

### Equivalence Harness

`tests/testthat/test-pbp_equivalence.R` is the 0.0.51-era guard that the
v2 modular pipeline matches the legacy
[`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
/
[`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
output for the same game. It enumerates an explicit **allow-list** of
intentional v2-vs-legacy deltas so the harness fails loudly on any
*unintentional* drift:

- `id_play` is character in v2, mixed in legacy (intentional –
  characters survive JSON round-trips cleanly).
- `scoring_play` is logical in v2, integer 0/1 in legacy (intentional).
- `clock_seconds` is total seconds remaining in v2, period-relative in
  legacy (intentional – enables monotonic time math).
- `passer_player_name` / `rusher_player_name` / `receiver_player_name`
  are short-name strings in v2, full-record list-columns in legacy
  (intentional – short names are what downstream models need).

Any *other* column-level difference is a regression and must be fixed
before the v2 surface promotes ahead of the legacy entry points.

### Environment Variables for Tests

Tests are gated by source-specific env-var helpers in
`tests/testthat/helper-skip.R`:

| Variable       | Description                     | Helper             |
|----------------|---------------------------------|--------------------|
| `CFBD_API_KEY` | Bearer token for CFBD endpoints | `skip_cfbd_test()` |
| `ESPN_TESTS=1` | Enable ESPN catalog tests       | `skip_espn_test()` |

Use the source-specific helper for the endpoint under test:

- `skip_cfbd_test()` for `test-cfbd_*.R`
- `skip_espn_test()` for `test-espn_cfb_*.R`

`skip_on_cran()` and `skip_on_ci()` continue to gate network-dependent
tests on CRAN and CI. Env vars alone do not override those guards unless
tests are intentionally changed.

## CFB-Specific Details

- **Game length**: four 15-minute quarters, 60 minutes regulation. The
  v2 PBP `clock_seconds` column is **total** seconds remaining (start of
  game = 3600), not period-relative.
- **Overtime**: untimed, alternating possessions from the 25-yard line.
  The engine models OT possessions as drives with `period >= 5`.
- **Season convention**: a “season” is the calendar year of the fall
  season (e.g., the 2023 Rose Bowl played January 2024 is
  `season = 2023`).
- **CFBD `season_type`**: one of `"regular"`, `"postseason"`, or
  `"both"`. Cache keys include `season_type`.
- **CFBD bearer token**: `CFBD_API_KEY` env var. Register at
  <https://collegefootballdata.com/key> and set via
  [`register_cfbd()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md).
- **CFBD rate limits**: free-tier callers hit a per-minute cap quickly.
  Catch the 429 and back off; do not retry hot.

## NAMESPACE

Auto-generated by roxygen2. **Never edit manually.** Run
`devtools::document()` to regenerate. `man/` is similarly auto-generated
– never hand-edit files under `man/`.

## Documentation Maintenance

Two regeneration steps are part of the commit workflow whenever the
relevant sources change. Both are mechanical – never edit the generated
regions by hand.

### Markdown TOCs (doctoc)

`NEWS.md`, `CLAUDE.md`, `CONTRIBUTING.md`,
`.github/copilot-instructions.md`, and
`.github/pull_request_template.md` carry a doctoc-generated table of
contents inside the standard marker comments. After editing any of those
files, regenerate the TOC before committing:

``` sh
Rscript tools/run_doctoc.R --maxlevel 2 \
  NEWS.md CLAUDE.md CONTRIBUTING.md \
  .github/copilot-instructions.md .github/pull_request_template.md
```

`cran-comments.md` is intentionally excluded – it is a short
release-notes file submitted to CRAN and does not need a TOC.

`tools/run_doctoc.R` is a no-deps R replacement for the npm `doctoc` CLI
– it produces output indistinguishable from the upstream tool, is
idempotent (a no-op if no headings changed), and runs without Node.js.
Use `--maxlevel 2` so the TOC only lists `#` and `##` headings; level-3
sub-entries crowd the nav.

### README.md (rmarkdown)

`README.md` is rendered from `README.Rmd`. The Rmd carries
`output: github_document: { toc: true, toc_depth: 2 }`, so the README
has its own auto-generated TOC. After editing `README.Rmd`, re-render
before committing:

``` r

devtools::build_readme()
```

Commit `README.Rmd` and the regenerated `README.md` together. Never
hand-edit `README.md`.

### DESCRIPTION (usethis)

After editing `DESCRIPTION` (adding/removing packages, bumping versions,
updating `Authors@R`, etc.), normalize formatting before committing:

``` r

usethis::use_tidy_description()
```

This re-orders fields, alphabetizes `Imports`/`Suggests`, and reflows
long lines so subsequent diffs stay minimal. Run it even for one-line
edits.

### Release notes triad: NEWS.md / cran-comments.md / \_pkgdown.yml

Three files describe the same release at different audiences. Whenever
you add a `NEWS.md` bullet, **think through all three before
committing**:

- **`NEWS.md`** – authoritative changelog for downstream users; rendered
  into the pkgdown changelog. **All new bullets go under the most recent
  unreleased version heading** (currently `# **cfbfastR 2.3.0**`). Do
  NOT create a new version section ahead of release. Add to or extend an
  existing subsection (`### Bug fixes`, `### Deprecations`,
  `### Test infrastructure`, etc.) instead of starting a new one when
  the change is incremental. Once `2.3.0` ships to CRAN, the development
  version gets its own heading and the rule rolls forward.

- **`cran-comments.md`** – what gets submitted to CRAN. Every behavioral
  or user-visible change you add to `NEWS.md` should also be reflected
  in `cran-comments.md` before submission. The two files are not
  duplicates: `NEWS.md` is the long-form changelog, `cran-comments.md`
  is the short-form release summary. If a `NEWS.md` bullet is purely
  internal (refactor, test infrastructure, dev tooling) it can be
  omitted from `cran-comments.md`.

- **`_pkgdown.yml`** – the pkgdown reference index. New exported
  functions need to land in the right `reference:` section. The cfbfastR
  config uses `starts_with("cfbd_")` / `starts_with("espn_cfb_")` /
  `starts_with("load_cfb_")` selectors so new functions matching those
  prefixes are picked up automatically; explicitly-listed functions need
  a manual entry. Functions deprecated via
  [`lifecycle::deprecate_stop()`](https://lifecycle.r-lib.org/reference/deprecate_soft.html) +
  `@keywords internal` are excluded from the rendered index by default –
  preview with
  [`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)
  when in doubt.

When the change touches the API surface (new export, deprecation,
removal), include a one-line note in your commit message confirming
you’ve checked all three files.

## Commit Convention

Use [Conventional Commits](https://www.conventionalcommits.org/):

    feat: add espn_cfb_pbp_v2() catalog entry point
    fix: correct CFBD bearer-token escaping for keys with trailing newlines
    docs: update NEWS.md for v2.3.0
    test: add tier-monotonicity asserts for lean/default/full output
    refactor: extract EPA engine into pbp_epa_wpa_engine.R
    chore: deduplicate .Rbuildignore entries
    ci: bump actions/checkout to v5

Prefer scoped commit subjects when useful (e.g., `feat(pbp): ...`,
`docs(catalog): ...`). Use `type!:` or a `BREAKING CHANGE:` footer for
breaking changes. Split unrelated work into separate commits for
reviewability.

**Important**: Never include AI agents or assistants (e.g., Claude,
Copilot) as co-authors on commits. Omit all `Co-Authored-By` trailers
referencing AI tools.

## Common Pitfalls

- **CFBD rate limits**: free-tier callers hit a per-minute cap quickly.
  The wrappers surface a
  [`cli::cli_alert_danger()`](https://cli.r-lib.org/reference/cli_alert.html)
  on 429, but you must not retry in a hot loop – add a
  [`Sys.sleep()`](https://rdrr.io/r/base/Sys.sleep.html) and re-run the
  failing range.
- **ESPN `$ref` payloads**: ESPN’s “core” API often returns
  `{"$ref": "https://..."}` placeholders instead of the inlined team /
  athlete / venue metadata. The legacy
  [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
  path silently returned NA team names in this case. The v2 path goes
  through `.espn_pbp_game_meta()`, which falls back to
  `.espn_cfb_team_lookup()` (a cached lookup over
  [`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
  when it sees a `$ref`. If you add a new ESPN wrapper that consumes
  team metadata, route it through `.espn_pbp_game_meta()` rather than
  reading team fields directly.
- **`output = c(...)` default**: do **not** declare
  `output = c("default", "lean", "full")` and call
  [`match.arg()`](https://rdrr.io/r/base/match.arg.html). Use a
  single-value default (`output = "default"`) and validate with
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html).
  The c-vector form silently picks the first element when the caller
  passes a vector, which masks bugs.
- **`%||%` is rlang-imported**: do not redefine it locally; import via
  `@importFrom rlang %||%` so the operator survives `R CMD check`.
- **`make_cfbfastR_data` class order**: the class vector is
  `c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")`.
  Adding new helpers must not re-order or strip the class – `dplyr`
  verbs strip class by default, so apply `make_cfbfastR_data()`
  **after** the final transformation.
- **`data.frame(list_of_items)` and `NULL` fields**: when CFBD returns a
  mixed `NULL`/value column, naked
  [`data.frame()`](https://rdrr.io/r/base/data.frame.html) collapses to
  a list-column with `NULL` entries. Use `%||%` defaults inside
  `purrr::map_*()` to coerce to typed NA before the bind.
- **Native pipe + `magrittr` placeholder**: `|>` does **not** support
  the `.` placeholder. If you need argument placement, use `_` (R 4.2+)
  or wrap in an explicit lambda `\(x) ...`. Mixing `.` after `|>` will
  silently no-op in some chains.
- **Local dev artifacts**: `.vscode`, `.claude`, `.positai`,
  `.remember`, `tools/` can surface as `R CMD check` notes. Keep
  `.Rbuildignore` patterns for each.
- **Never hand-edit `NAMESPACE` or files under `man/`**; regenerate with
  `devtools::document()`.
