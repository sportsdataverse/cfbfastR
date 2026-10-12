"""Re-capture cfbfastR's pre-game line oracle from sdv-py (LIVE: the 2024+ games need ESPN's core odds API).

sdv-py resolves the line in CFBPlayProcess.__helper_cfb_pickcenter: the summary `pickcenter` when it has more
than one provider (every pre-2024 game), else the core-v2 odds collection (ESPN emptied pickcenter for 2024+).
Writes odds_oracle.csv (sdv-py's resolved line per game, plus the home-line `spread` cfbfastR should emit) and
odds_pickcenter.json (the raw pickcenter arrays, so the pickcenter path is tested offline).
"""

import csv
import json
import os
import pathlib
import sys
import numpy as np

SDV_PY = os.environ.get("SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py")  # sdv-py checkout (or leave importable)
sys.path.insert(0, SDV_PY)
from sportsdataverse.cfb.cfb_pbp import CFBPlayProcess

OUT = pathlib.Path(__file__).resolve().parents[1] / "tests" / "testthat" / "fixtures" / "parity"
# two 2019 + two 2022 (pickcenter), two MAC + two power-four 2025 (core odds API)
ids = [401112080, 401121960, 401416632, 401416633, 401762862, 401762864, 401752912, 401752776]
sc = lambda x: np.asarray(x).ravel()[0].item()  # sdv-py's pickcenter path leaves 1-element arrays
rows, pickcenter = [], {}
for gid in ids:
    p = CFBPlayProcess(gameId=gid)
    raw = p.espn_cfb_pbp()
    pickcenter[str(gid)] = raw.get("pickcenter") or []
    p.run_processing_pipeline()
    spread, home_fav, ou, avail = (
        float(sc(p.gameSpread)),
        bool(sc(p.homeFavorite)),
        float(sc(p.overUnder)),
        bool(p.gameSpreadAvailable),
    )
    home_team_spread = abs(spread) if home_fav else -abs(spread)  # cfb_pbp.py homeTeamSpread: + = home favoured
    rows.append(
        dict(
            game_id=gid,
            season=raw["header"]["season"]["year"],
            n_pickcenter=len(pickcenter[str(gid)]),
            odds_source=p.odds_source,
            game_spread_available=avail,
            sdvpy_game_spread=spread,
            home_favorite=home_fav,
            over_under=ou,
            # cfbfastR's `spread` is the home line, negative when the home team is favoured (CFBD's
            # convention); no line is NA there, not sdv-py's (2.5, 55.5) defaults
            spread=(-home_team_spread if avail else ""),
            expected_over_under=(ou if avail else ""),
        )
    )
with open(OUT / "odds_oracle.csv", "w", newline="") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0]))
    w.writeheader()
    w.writerows(rows)
json.dump(pickcenter, open(OUT / "odds_pickcenter.json", "w"), indent=1)
print(f"{len(rows)} games -> {OUT}/odds_oracle.csv, odds_pickcenter.json")
