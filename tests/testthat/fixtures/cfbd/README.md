# CFBD response fixtures

Real CollegeFootballData API response bodies for offline tests, stored gzipped and unmodified.
Each was recorded by wrapping `get_req()` around the wrapper's own request.

| File | Request | JSON bytes | md5 of the JSON | Captured |
|---|---|---:|---|---|
| `games_teams_2024_w5_oregon.json.gz` | `https://api.collegefootballdata.com/games/teams?year=2024&week=5&seasonType=regular&team=Oregon&classification=fbs` | 2949 | `65fa15ba02148748b777845ebfebed65` | 2026-09-30 UTC |

`games_teams_2024_w5_oregon`: CFBD returns the whole game for `team=` -- Oregon (home) and UCLA.
