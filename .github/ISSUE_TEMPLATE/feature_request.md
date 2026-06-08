---
name: Feature request
about: Suggest a new endpoint, data loader, helper, or enhancement for cfbfastR
title: "[feat] <short description>"
labels: ["enhancement", "needs-triage"]
assignees: ""

---

## Is your feature request related to a problem?

A clear and concise description of what the problem is.
Example: *"I'm always frustrated when I have to manually join `cfbd_games()`
output to `cfbd_drives()` to get drive-level start/end field position."*

## Which data source / function family?

- [ ] `cfbd_*()` — College Football Data API
- [ ] `espn_cfb_*()` — ESPN College Football endpoints
- [ ] `load_cfb_*()` — Full-season loaders
- [ ] `update_cfb_db()` / database tooling
- [ ] EPA / WPA modeling helpers
- [ ] Documentation / vignettes
- [ ] Other (please specify):

## Describe the solution you'd like

A clear and concise description of what you want to happen. If you're proposing
a new function, sketch the signature:

```r
cfbd_new_endpoint(year, week = NULL, team = NULL, ...)
```

If it wraps an existing upstream endpoint, please link to the relevant docs:
- CFBD API docs: https://api.collegefootballdata.com/api/docs/
- ESPN API references (if known):

## Describe alternatives you've considered

A clear and concise description of any alternative solutions, workarounds, or
existing functions you've considered.

## Additional context

Add any other context, screenshots, sample output, or links to related issues /
PRs / external discussions here.
