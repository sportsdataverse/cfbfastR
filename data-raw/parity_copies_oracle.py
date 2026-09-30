"""Re-capture cfbfastR's ESPN play-copy parity oracle from sdv-py (offline, raw payloads on disk).

Records the frame sdv-py hands `_drop_espn_play_copies` (in that order: after its first play sort),
with the inputs `.espn_play_copies()` reads, and for each row whether sdv-py drops it there or in
the adjacent-copy rule after it (`sdvpy_drop`), and the type a stub echo leaves on the play it
repeats (`sdvpy_type`).
"""

import csv, gzip, io, logging, os, pathlib, subprocess, sys

SDV_PY = os.environ.get(
    "SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py"
)  # sdv-py checkout
sys.path.insert(0, SDV_PY)
logging.disable(logging.CRITICAL)
import polars as pl
import sportsdataverse.cfb.cfb_pbp as M

RAW = pathlib.Path(
    os.environ.get("CFB_RAW_JSON", "/mnt/sdv_repos/cfbfastR-cfb-raw/cfb/json/raw")
)
OUT = (
    pathlib.Path(__file__).resolve().parents[1]
    / "tests"
    / "testthat"
    / "fixtures"
    / "parity"
)
GAMES = [
    # stub echoes, stale drive batches and copies across a marker (401752854 carries all three)
    401752854,
    272512348,
    282640084,
    283330145,
    312810077,
    313232005,
    401287947,
    401525890,
    # adjacent copies: re-entered duplicates a few seconds apart (401411109), same-id live repeats
    401411109,
    302750249,
    401645383,
    401754601,
    # guards: a stale batch with one exact twin is not stale (400548311); a spotless pair is no stub
    # (242620052); the same play across a marker at another clock is not an echo (292552084)
    400548311,
    242620052,
    292552084,
    # nothing to drop
    401628339,
    242900265,
]
COLS = [
    "game_id",
    "row",
    "id",
    "type",
    "text",
    "drive_id",
    "period",
    "clock",
    "start_team",
    "start_down",
    "start_distance",
    "start_ytg",
    "sdvpy_drop",
    "sdvpy_type",
]
rec = {}
orig_copies = M._drop_espn_play_copies


def copies(df):
    df = df.with_columns(_fx=pl.int_range(pl.len()))
    rec["in"] = df
    out = orig_copies(df)
    rec["out"] = dict(zip(out["_fx"].to_list(), out["type.text"].to_list()))
    return out


M._drop_espn_play_copies = copies
C = M.CFBPlayProcess
orig_feat = C._CFBPlayProcess__helper_cfb_pbp_features


def feat(self, pbp_txt, init):
    out = orig_feat(self, pbp_txt, init)
    rec["feat"] = set(
        (out[0] if isinstance(out, tuple) else out)["plays"]["_fx"].to_list()
    )
    return out


C._CFBPlayProcess__helper_cfb_pbp_features = feat
rows = []
for gid in GAMES:
    rec.clear()
    p = C(gameId=gid, path_to_json=str(RAW))
    p.join_participants = False
    p.cfb_pbp_disk()
    p.run_processing_pipeline()
    for r in rec["in"].iter_rows(named=True):
        fx = r["_fx"]
        rows.append(
            [
                gid,
                fx,
                str(r["id"]),
                r["type.text"],
                r["text"],
                r["drive.id"],
                r["period.number"],
                r["clock.displayValue"],
                r["start.team.id"],
                r["start.down"],
                r["start.distance"],
                r["start.yardsToEndzone"],
                fx not in rec["feat"],
                rec["out"].get(fx, r["type.text"]),
            ]
        )
sha = (
    subprocess.check_output(["git", "-C", SDV_PY, "rev-parse", "--short", "HEAD"])
    .decode()
    .strip()
)
# mtime=0 keeps the gzip bytes stable across re-captures
with (
    open(OUT / "copies_oracle.csv.gz", "wb") as fh_raw,
    gzip.GzipFile(fileobj=fh_raw, mode="wb", mtime=0) as gz,
):
    fh = io.TextIOWrapper(gz, encoding="utf-8", newline="")
    w = csv.writer(fh, lineterminator="\n")
    w.writerow(COLS)
    w.writerows(rows)
    fh.flush()
    fh.detach()
print(
    "games",
    len(GAMES),
    "rows",
    len(rows),
    "dropped",
    sum(r[12] for r in rows),
    "sdv-py",
    sha,
)
