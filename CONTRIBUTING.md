# Contributing to cfbfastR

**Table of Contents** *generated with
[DocToc](https://github.com/thlorenz/doctoc)*

- [Contributing to cfbfastR](#contributing-to-cfbfastr)
- [Code of Conduct](#code-of-conduct)
- [Development Setup](#development-setup)
- [Workflow](#workflow)
- [Naming Conventions](#naming-conventions)
- [Documentation Maintenance](#documentation-maintenance)
- [Commit Messages](#commit-messages)
- [Pull Requests](#pull-requests)
- [Testing](#testing)
- [CI / GitHub Actions](#ci-github-actions)
- [Reporting Issues](#reporting-issues)
- [License](#license)

Thank you for your interest in contributing to cfbfastR! This guide
walks you through the local setup, the conventions enforced inside `R/`,
and the steps for opening a clean pull request against `main`.

If anything below conflicts with `CLAUDE.md` or the current state of
`tests/testthat/`, treat `CLAUDE.md` and the live test files as
authoritative – this document is a higher-level orientation. For deep
coding conventions (return-value initialization, column-drift
resilience, the `.run_epa_wpa()` engine, `.attach_query_meta_auto()`,
the cachem/memoise tiered cache, and the
`output = "default"/"lean"/"full"` tier argument), see `CLAUDE.md`.

## Code of Conduct

This project is released with a [Contributor Code of
Conduct](https://cfbfastR.sportsdataverse.org/CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

## Development Setup

1.  **Fork and clone** the repository from
    [sportsdataverse/cfbfastR](https://github.com/sportsdataverse/cfbfastR).
2.  **Install dependencies**: open the project in RStudio and run
    `devtools::install_deps(dependencies = TRUE)`. cfbfastR requires **R
    \>= 4.1.0** because the codebase uses the native pipe `|>`.
3.  **Create a feature branch from `main`**:
    `git checkout -b feat/your-feature main`. `main` is the default
    branch and the release branch. During the 2.3.0 cycle, larger
    play-by-play / EPA / WPA work was staged on
    `refactor/pbp-epa-wpa-modular`; if you are contributing to that
    area, coordinate with the maintainer before branching so you start
    from the same base.
4.  **Set up your CFBD API key for live tests**:
    - Sign up for a free key at
      [collegefootballdata.com/key](https://collegefootballdata.com/key).
    - Export it as `CFBD_API_KEY` (or set it in `~/.Renviron`) so the
      `cfbd_*` wrappers and any tests that hit
      `api.collegefootballdata.com` can authenticate.
      [`register_cfbd()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)
      will read this for you;
      [`cfbd_api_key_info()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)
      /
      [`has_cfbd_key()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)
      can confirm it’s wired up.
    - ESPN endpoints (`espn_cfb_*`, `espn_metrics_wp`,
      `espn_ratings_fpi`) are unauthenticated but still hit the network
      – you do not need a key for them, just connectivity.

## Workflow

### Making Changes

1.  Edit source code in `R/`.
2.  Regenerate docs and `NAMESPACE`: `devtools::document()`.
3.  Run the test suite: `devtools::test()`. Most live-API tests are
    gated behind `skip_on_cran()` / `skip_on_ci()` and will no-op unless
    you have the relevant env vars set (see [Testing](#testing) below).
4.  Run the full check: `devtools::check()`. It should pass with zero
    errors and zero warnings before you open a PR.

### Adding a New CFBD Endpoint

1.  **Create the function** in the appropriate `R/cfbd_*.R` file
    following the existing pattern:
    - Build the request URL on top of
      `https://api.collegefootballdata.com/`.
    - Authenticate with the bearer token resolved via
      [`cfbd_key()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)
      (and surface
      [`has_cfbd_key()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)-style
      guidance in the error path if no key is configured).
    - Parse the response with
      [`jsonlite::fromJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)
      -\>
      [`dplyr::as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html)
      -\>
      [`janitor::clean_names()`](https://sfirke.github.io/janitor/reference/clean_names.html)
      -\> `make_cfbfastR_data("<source description>", Sys.time())`.
    - Use the native pipe `|>` exclusively. `%>%` has been swept out of
      `R/`, `tests/`, and `vignettes/`, and `magrittr` is no longer in
      `Imports`. Two `|>` pitfalls: `|>`\[\[`("x")` errors under R 4.1
      (use `|> purrr::pluck("x")`), and
      `|> tibble::tibble(col = .data$.)` is a magrittr quirk (use
      `tibble::tibble(col = <lhs>)` directly).
    - Use `%||%` (from rlang) for null-safe defaults on every extracted
      field.
2.  **Initialize the return variable before `tryCatch`**. Every wrapper
    that returns a value assigned inside `tryCatch` must initialize that
    variable (`df <- data.frame()`, `df_list <- list()`,
    `plays_df <- NULL`, etc.) **before** the `tryCatch` block. Otherwise
    an API error leaves the variable unbound and `return(<var>)` throws
    `object '<var>' not found` instead of the intended
    [`cli::cli_alert_danger()`](https://cli.r-lib.org/reference/cli_alert.html) +
    empty fallback.
3.  **Add roxygen docs** with `@export`, `@family`, `@return` (including
    column markdown tables), and a runnable example.
4.  **Create a test** in `tests/testthat/` with `skip_on_cran()` and
    `skip_on_ci()` guards plus a skip-if-empty check immediately after
    the API call.
5.  **Update `NEWS.md`** under the current `# **cfbfastR 2.3.0**`
    heading – do not start a new version section ahead of release.
6.  Run `devtools::document()` to update `NAMESPACE`.

### Adding a New ESPN College Football Endpoint

ESPN wrappers added in 2.3.0 live in the catalog files:

- `R/espn_cfb_catalog.R`
- `R/espn_cfb_game.R`
- `R/espn_cfb_player.R`
- `R/espn_cfb_ratings.R`
- `R/espn_cfb_schedule.R`
- `R/espn_cfb_season.R`
- `R/espn_cfb_team.R`

When extending the catalog:

- Call `site.api.espn.com` / `sports.core.api.espn.com` directly; no API
  key is required.
- At the return-site, call `.attach_query_meta_auto(df)` so the response
  carries the caller’s query parameters (`season`, `season_type`,
  `week`, `team_id`, `athlete_id`, `coach_id`, `game_id`, …) as leading
  columns. `year` is canonicalised to `season`; response columns win on
  collisions.
- Honour the tiered TTL cachem/memoise cache wired in `.onLoad`. Users
  control it via `options(cfbfastR.cache = "memory"/"filesystem"/"off")`
  and `options(cfbfastR.cache_duration = 86400)`;
  [`espn_cfb_clear_cache()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_clear_cache.md)
  calls
  [`memoise::forget()`](https://memoise.r-lib.org/reference/forget.html)
  for invalidation.
- If your wrapper accepts a column-tier argument, follow the
  `output = "default"` scalar default +
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  validation pattern. **Do not** use
  `output = c("default", "lean", "full")` as a default – defaults must
  be a single chosen value, with the allowed choices documented in
  `@param` and validated in the body.

## Naming Conventions

### Function Names

| Data Source | Prefix | Example |
|----|----|----|
| College Football Data API | `cfbd_` | [`cfbd_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_games.md), [`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md), [`cfbd_betting_ats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_ats.md) |
| ESPN College Football | `espn_cfb_` | [`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md), [`espn_cfb_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.md), [`espn_cfb_qbr()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_qbr.md) |
| ESPN win-probability metrics | `espn_metrics_` | [`espn_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/espn_metrics.md) |
| ESPN ratings | `espn_ratings_` | [`espn_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.md) |
| Data loaders | `load_cfb_` | [`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md), [`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.md) |

### General Naming Rules

- **snake_case** for all function names, variables, and parameters.
- **Internal helpers** (not exported) are prefixed with `.` (e.g.,
  `.run_epa_wpa()`, `.espn_to_epa_input()`, `.cfbd_to_epa_input()`,
  `.attach_query_meta_auto()`).
- **Parameter names** use `snake_case` in R and are mapped to the API’s
  casing inside the wrapper.
- **File names** follow `R/cfbd_*.R`, `R/espn_cfb_*.R`, and `R/pbp_*.R`
  for the EPA/WPA engine internals.

### Native Pipe and Data Pipeline

All new code uses `|>`. The standard frame-shaping pipeline is:

``` r

raw |>
  dplyr::as_tibble() |>
  janitor::clean_names() |>
  make_cfbfastR_data("Source description", Sys.time())
```

`make_cfbfastR_data()` sets the class to
`c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")` and
attaches the source description + timestamp.

### Roxygen Documentation

Every exported function needs:

- `@title` (typically a bold markdown description)
- `@author`
- `@param` for every parameter (including `...`)
- `@return` – when the return is a tibble, document the columns in a
  markdown table
- `@importFrom` for specific function imports
- `@export`
- `@family` so the function lands in the correct pkgdown group
- A runnable `@examples` block (use `\donttest{}` for live-network
  examples so `R CMD check` does not hit the API during routine
  checking)

### Code Style

- Follow [tidyverse style](https://style.tidyverse.org/): `snake_case`,
  2-space indentation.
- Drop columns with `dplyr::select(-dplyr::any_of(...))` and rename with
  `dplyr::rename(dplyr::any_of(c(new = "old")))` so a schema drift
  upstream is survivable.
- Use `%||%` (rlang) for null-safe defaults when parsing API responses.
- All user-facing messages go through `cli`:
  [`cli::cli_alert_danger()`](https://cli.r-lib.org/reference/cli_alert.html)
  in error handlers,
  [`cli::cli_alert_warning()`](https://cli.r-lib.org/reference/cli_alert.html)
  for warnings,
  [`cli::cli_alert_info()`](https://cli.r-lib.org/reference/cli_alert.html)
  for informational notes,
  [`cli::cli_warn()`](https://cli.r-lib.org/reference/cli_abort.html) /
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  for raised conditions. Do **not** pass a raw condition object directly
  into a `cli_*` call (it is glue-interpolated); pass
  `conditionMessage(cond)` through a value placeholder instead.

## Documentation Maintenance

Several regeneration steps are part of the commit workflow whenever the
relevant sources change. All of them are mechanical – never edit the
generated regions by hand.

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

`README.md` is rendered from `README.Rmd`. After editing `README.Rmd`,
re-render before committing:

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
  not create a new version section ahead of release. Add to or extend an
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
  config uses `starts_with("cfbd_")`, `starts_with("espn_cfb_")`,
  `starts_with("load_cfb_")`, etc. so new functions matching those
  prefixes are picked up automatically; explicitly-listed functions
  (e.g. `cfbd_pbp_data_v2`, `espn_metrics_wp`, `espn_ratings_fpi`) need
  a manual entry. Preview with
  [`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)
  when in doubt – the site is published at
  <https://cfbfastr.sportsdataverse.org/>.

When the change touches the API surface (new export, deprecation,
removal), include a one-line note in your commit message confirming you
have checked all three files.

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

    feat: add cfbd_pbp_data_v2() modular EPA/WPA pipeline
    fix: initialize df_list before tryCatch in espn_cfb_team_roster()
    docs: update roxygen for output = "default"/"lean"/"full" tier arg
    test: add equivalence harness for espn_cfb_pbp_v2 vs legacy
    refactor: extract .run_epa_wpa() engine from cfbd_pbp_data
    chore: dedupe .Rbuildignore entries
    ci: bump actions/checkout to v5 in pkgdown workflow

Prefer scoped commit subjects when useful (e.g., `feat(pbp): ...`,
`docs(espn): ...`). Use `type!:` or a `BREAKING CHANGE:` footer for
breaking changes. Split unrelated work into separate commits for
reviewability.

**Important**: Never include AI agents or assistants (e.g., Claude,
Copilot) as co-authors on commits. Omit all `Co-Authored-By` trailers
referencing AI tools.

## Pull Requests

- Target the `main` branch (or `refactor/pbp-epa-wpa-modular` if your
  work was scoped to that staging branch and the maintainer asked you to
  base on it).
- Fill out the PR template at `.github/pull_request_template.md` – it is
  auto-applied when you open the PR.
- Include a clear description of what changed and why.
- Ensure `devtools::check()` passes with no errors or warnings.
- Add tests for new functions and update existing tests when behavior
  changes.
- Update `NEWS.md` for user-facing changes; update `cran-comments.md`
  and `_pkgdown.yml` too if the API surface moved.

## Testing

### Test Pattern

Live-API tests follow the **subset direction** rule for column
assertions: the *expected* list must be a subset of the *actual*
columns, so an upstream-added column never breaks the test.

``` r

test_that("CFBD endpoint returns expected columns", {
  skip_on_cran()
  skip_on_ci()
  skip_if(Sys.getenv("CFBD_API_KEY") == "", "CFBD_API_KEY not set")

  x <- cfbd_games(year = 2023, week = 1)

  # Skip-if-empty guard - always right after the API call, before any
  # assertion that touches the response. Handles transient 500s.
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No rows returned from endpoint at test time")
  }

  expected_cols <- c("game_id", "season", "week", "home_team", "away_team")
  expect_in(sort(expected_cols), sort(colnames(x)))   # expected subset-of actual
  expect_s3_class(x, "data.frame")
})
```

**Anti-patterns to avoid:**

``` r

# WRONG - flags when upstream adds a column, even though it is non-breaking
expect_equal(sort(colnames(x)), sort(expected_cols))

# WRONG - same direction problem, just phrased as expect_in()
expect_in(sort(colnames(x)), sort(expected_cols))
```

For dynamic columns, `expect_true(all(core_cols %in% colnames(x)))` is
equivalent.

### Running live vs offline tests

- **Offline** (default in CI and `R CMD check`): `devtools::test()` will
  skip every test guarded by `skip_on_cran()` / `skip_on_ci()` – the
  suite stays green even without network or an API key.
- **Live CFBD**: set `Sys.setenv(CFBD_API_KEY = "...")` (or put it in
  `~/.Renviron`) and run `devtools::test()` locally. The `cfbd_*` tests
  will hit `api.collegefootballdata.com`.
- **Live ESPN**: no API key needed – just connectivity. The `espn_cfb_*`
  tests hit `site.api.espn.com` / `sports.core.api.espn.com` directly.
- **PBP equivalence harness**: `tests/testthat/test-pbp_equivalence.R`
  asserts
  [`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md)
  and
  [`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md)
  reproduce the legacy outputs column-for-column, with an explicit
  allow-list of intentional representation deltas (character `id_play`,
  logical `scoring_play`, total `clock_seconds`, v2 short-name
  passer/rusher/receiver). Run it when you touch anything in
  `R/pbp_*.R`, `R/cfbd_pbp_data*.R`, `R/espn_cfb_game.R`, or the
  `.run_epa_wpa()` engine.

## CI / GitHub Actions

The repository runs three workflows out of `.github/workflows/`:

| Workflow | Triggers | Purpose |
|----|----|----|
| `R-CMD-check.yaml` | push / PR to `main` | Cross-platform `R CMD check` matrix |
| `pkgdown.yaml` | push to `main`, release | Build & deploy <https://cfbfastr.sportsdataverse.org/> |
| `rhub.yaml` | manual / scheduled | rhub v2 checks across CRAN-relevant platforms |

Secrets used:

| Secret | Used by | Description |
|----|----|----|
| `GITHUB_TOKEN` | All workflows | Auto-provided by GitHub |
| `CFBD_API_KEY` | `R-CMD-check.yaml` | Optional – enables live CFBD tests when present in CI |

## Reporting Issues

When filing a bug report, please include:

1.  A minimal **reprex** (reproducible example) using
    `reprex::reprex()`.
2.  The **endpoint** and **parameters** used (year, week, team, game_id,
    etc.).
3.  Your [`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html)
    output.
4.  The specific **error message** or unexpected output.

Use the [bug report
template](https://cfbfastR.sportsdataverse.org/ISSUE_TEMPLATE/bug_report.md)
when opening a new issue.

## License

By contributing, you agree that your contributions will be licensed
under the [MIT License](https://cfbfastR.sportsdataverse.org/LICENSE).
