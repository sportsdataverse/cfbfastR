"""Re-capture cfbfastR's ESPN untyped-admin-row parity oracle from sdv-py (offline, raw payloads on disk).

Every feed play of a few games with sdv-py's own filter applied (`type.text` null and the text
matching `_UNTYPED_ADMIN_RE`, polars semantics): the rows sdv-py drops before it orders the plays.
"""

import csv, gzip, io, json, logging, os, pathlib, subprocess, sys

SDV_PY = os.environ.get("SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py")  # sdv-py checkout
sys.path.insert(0, SDV_PY)
logging.disable(logging.CRITICAL)
import polars as pl
import sportsdataverse.cfb.cfb_pbp as M

RAW = pathlib.Path(os.environ.get("CFB_RAW_JSON", "/mnt/sdv_repos/cfbfastR-cfb-raw/cfb/json/raw"))
OUT = pathlib.Path(__file__).resolve().parents[1] / "tests" / "testthat" / "fixtures" / "parity"
# 2004 untyped quarter / game markers (243042579) and "Begin Drive" (242462628); an OT drive header
# (262522509); empty rows (272870068); a lone kick (401752914); lone two-point tries in OT (401426542)
GAMES = [243042579, 242462628, 262522509, 272870068, 401752914, 401426542]
rows = []
for gid in GAMES:
    d = json.load(open(RAW / f"{gid}.json"))
    plays = [p for dr in d["drives"]["previous"] for p in dr["plays"]]
    df = pl.DataFrame(
        {
            "id": [str(p["id"]) for p in plays],
            "type.text": [(p.get("type") or {}).get("text") for p in plays],
            "text": [p.get("text") for p in plays],
        },
        schema={"id": pl.Utf8, "type.text": pl.Utf8, "text": pl.Utf8},
    )
    admin = df.select(
        pl.col("type.text").is_null() & pl.col("text").fill_null("").str.contains(M._UNTYPED_ADMIN_RE)
    ).to_series()
    for (i, t, x), a in zip(df.rows(), admin):
        rows.append([gid, i, t, x, x is None, a])
sha = subprocess.check_output(["git", "-C", SDV_PY, "rev-parse", "--short", "HEAD"]).decode().strip()
with open(OUT / "admin_oracle.csv.gz", "wb") as fh_raw, gzip.GzipFile(fileobj=fh_raw, mode="wb", mtime=0) as gz:
    fh = io.TextIOWrapper(gz, encoding="utf-8", newline="")
    w = csv.writer(fh, lineterminator="\n")
    w.writerow(["game_id", "id", "type", "text", "text_null", "sdvpy_admin"])
    w.writerows(rows)
    fh.flush()
    fh.detach()
print("games", len(GAMES), "rows", len(rows), "admin", sum(r[-1] for r in rows), "sdv-py", sha)
