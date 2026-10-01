"""Re-capture cfbfastR's ESPN scored-row parity oracle from sdv-py (offline, raw payloads on disk).

Records what sdv-py hands `_type_espn_scored_rows` for each ESPN-scored row (`scoringPlay`) of a set
of games -- the type after its relabels, the text, the start team's margin change on the row and
whether ESPN's `scoringType` is a touchdown -- and the type it returns (`sdvpy_type`).
"""

import csv, gzip, io, logging, os, pathlib, subprocess, sys

SDV_PY = os.environ.get("SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py")  # sdv-py checkout
sys.path.insert(0, SDV_PY)
logging.disable(logging.CRITICAL)
import polars as pl
import sportsdataverse.cfb.cfb_pbp as M

RAW = pathlib.Path(os.environ.get("CFB_RAW_JSON", "/mnt/sdv_repos/cfbfastR-cfb-raw/cfb/json/raw"))
OUT = pathlib.Path(__file__).resolve().parents[1] / "tests" / "testthat" / "fixtures" / "parity"
GAMES = [
    # frozen-board pick-sixes; "X yd fumble return." (2004-07); "(X KICK)" fumble returns (2014+)
    282640084, 262922117, 292970166, 272650194, 401234617, 400547643,
    # strip-sacks at the 0; a kickoff team's recovery; kick and punt returns typed Kickoff / Punt
    253090038, 282780036, 400548343, 400548079, 401309833,
    # field goals typed as the snap before them (Pass Incompletion, Rush, Timeout, Penalty)
    292832633, 283340228, 312912032, 303310150,
    # Miami's game-ending eight-lateral kickoff return; a blocked field goal returned on a frozen board
    400756970, 332640098,
    # left alone: ESPN's start team is the returner (272512655), a frozen-board rush fumble
    # (292970254), "fumbled in the endzone" with no touchdown (302890062)
    272512655, 292970254, 302890062,
]
COLS = ["game_id", "id", "type", "text", "scoring_play", "delta", "espn_td", "sdvpy_type"]
rec = []
orig = M._type_espn_scored_rows


def hook(df):
    out = orig(df)
    keep = df["scoringPlay"] == True  # noqa: E712
    td = (
        df["scoringType.name"].cast(pl.Utf8).fill_null("") == "touchdown"
        if "scoringType.name" in df.columns
        else pl.Series([False] * df.height)
    )
    for r, t, new in zip(df.filter(keep).iter_rows(named=True), td.filter(keep), out.filter(keep)["type.text"]):
        rec.append([r["id"], r["type.text"], r["text"], r["scoringPlay"],
                    None if r["end.pos_score_diff"] is None or r["start.pos_score_diff"] is None
                    else r["end.pos_score_diff"] - r["start.pos_score_diff"], t, new])
    return out


M._type_espn_scored_rows = hook
rows = []
for gid in GAMES:
    rec.clear()
    p = M.CFBPlayProcess(gameId=gid, path_to_json=str(RAW))
    p.join_participants = False
    p.cfb_pbp_disk()
    p.run_processing_pipeline()
    rows += [[gid, *r] for r in rec]
sha = subprocess.check_output(["git", "-C", SDV_PY, "rev-parse", "--short", "HEAD"]).decode().strip()
# mtime=0 keeps the gzip bytes stable across re-captures
with open(OUT / "scored_oracle.csv.gz", "wb") as fh_raw, gzip.GzipFile(fileobj=fh_raw, mode="wb", mtime=0) as gz:
    fh = io.TextIOWrapper(gz, encoding="utf-8", newline="")
    w = csv.writer(fh, lineterminator="\n")
    w.writerow(COLS)
    w.writerows(rows)
    fh.flush()
    fh.detach()
print("games", len(GAMES), "rows", len(rows), "retyped", sum(r[2] != r[7] for r in rows), "sdv-py", sha)
