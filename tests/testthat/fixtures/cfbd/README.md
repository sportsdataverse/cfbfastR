# CFBD response fixtures

Real CollegeFootballData API response bodies for offline tests, stored gzipped and unmodified.
Each was recorded by wrapping `get_req()` around the wrapper's own request.

| File | Request | JSON bytes | md5 of the JSON | Captured |
|---|---|---:|---|---|
| `games_teams_2024_w5_oregon.json.gz` | `https://api.collegefootballdata.com/games/teams?year=2024&week=5&seasonType=regular&team=Oregon&classification=fbs` | 2949 | `65fa15ba02148748b777845ebfebed65` | 2026-09-30 UTC |
| `game_box_advanced_401628374.json.gz` | `https://api.collegefootballdata.com/game/box/advanced?id=401628374` | 13840 | `aef3899ffc5d1d9240306e47d2dd0ddc` | 2026-09-30 UTC |
| `game_box_advanced_401752677.json.gz` | `https://api.collegefootballdata.com/game/box/advanced?id=401752677` | 56645 | `7687c284c5642553d9d4f06620b1a371` | 2026-09-30 UTC |

`games_teams_2024_w5_oregon`: CFBD returns the whole game for `team=` -- Oregon (home) and UCLA.
`game_box_advanced_401628374`: 2024 Alabama at Georgia; `havoc` lists Georgia first, every other section
Alabama first. `game_box_advanced_401752677`: 2025 Ohio State vs Texas; `passing` and `rushingAdvanced`
are filled (empty in 2024), and `havoc` is again in the opposite order.
