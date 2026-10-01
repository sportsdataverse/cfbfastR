"""Re-capture cfbfastR's scored-row branch-coverage oracle from sdv-py's own function.

`_type_espn_scored_rows` is pure (it reads only the row), and the 2004-26 corpus decides only some
of its branches (scored_oracle.csv.gz). This runs sdv-py's function on a grid of synthetic rows --
types x texts x margin changes x ESPN's touchdown flag, null text included -- so every branch the
corpus never reaches is still pinned to sdv-py's answer, not to a re-implementation.
"""

import csv, gzip, io, itertools, os, pathlib, subprocess, sys

SDV_PY = os.environ.get("SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py")  # sdv-py checkout
sys.path.insert(0, SDV_PY)
import polars as pl
import sportsdataverse.cfb.cfb_pbp as M

OUT = pathlib.Path(__file__).resolve().parents[1] / "tests" / "testthat" / "fixtures" / "parity"
TYPES = ["Rush", "Pass Completion", "Pass Incompletion", "Sack", "Fumble Recovery (Opponent)", "Fumble Recovery (Own)",
         "Interception Return", "Punt", "Blocked Punt", "Kickoff", "Kickoff Return (Offense)", "Field Goal Missed",
         "Blocked Field Goal", "Timeout", "Unknown", "Penalty", "Rushing Touchdown"]
TEXTS = [
    "A rush for 5 yards for a TOUCHDOWN.",
    "A pass complete to B for 10 yards for a TOUCHDOWN.",
    "A fumbled, recovered by B for a TD",
    "A pass intercepted by B, returned for 40 yards for a TOUCHDOWN.",
    "A punt blocked by B, recovered by C for TD",
    "A punt for 40 yds, B returns for 60 yds (C Kick)",
    "A 40 yard field goal BLOCKED returned, B for 70 yards for a TOUCHDOWN.",
    "A 41 yard field goal MISSED, B returns for 100 yds (C KICK)",
    "A 30 yard field goal GOOD.",
    "A kickoff for 65 yds, B return for 100 yds (C Kick)",
    "A run for 3 yds (B Kick)",
    "A 4 Yd Run (Two-Point Pass Conversion Failed)",
    "A sacked by B at the C 0 for a loss of 8 yards.",
    "A rush for 2 yards, TOUCHDOWN nullified by penalty, clock 10:00 NO PLAY",
    "A run for 4 yards",
    "",
    None,
]
DELTAS = [-9, -8, -7, -6, -5, -3, -2, 0, 2, 3, 5, 6, 7, 8, 9, None]
rows = list(itertools.product(TYPES, TEXTS, DELTAS, [False, True], [True, False]))
df = pl.DataFrame(
    {
        "type.text": [r[0] for r in rows],
        "text": [r[1] for r in rows],
        "scoringPlay": [r[4] for r in rows],
        "start.pos_score_diff": [0 if r[2] is not None else None for r in rows],
        "end.pos_score_diff": [r[2] for r in rows],
        "scoringType.name": ["touchdown" if r[3] else None for r in rows],
    },
    schema={"type.text": pl.Utf8, "text": pl.Utf8, "scoringPlay": pl.Boolean, "start.pos_score_diff": pl.Int64,
            "end.pos_score_diff": pl.Int64, "scoringType.name": pl.Utf8},
)
out = M._type_espn_scored_rows(df)["type.text"].to_list()
sha = subprocess.check_output(["git", "-C", SDV_PY, "rev-parse", "--short", "HEAD"]).decode().strip()
with open(OUT / "scored_grid_oracle.csv.gz", "wb") as fh_raw, gzip.GzipFile(fileobj=fh_raw, mode="wb", mtime=0) as gz:
    fh = io.TextIOWrapper(gz, encoding="utf-8", newline="")
    w = csv.writer(fh, lineterminator="\n")
    w.writerow(["type", "text", "text_null", "delta", "espn_td", "scoring_play", "sdvpy_type"])
    for (t, x, d, e, s), o in zip(rows, out):
        w.writerow([t, x, x is None, d, e, s, o])
    fh.flush()
    fh.detach()
print("rows", len(rows), "retyped", sum(r[0] != o for r, o in zip(rows, out)), "sdv-py", sha)
