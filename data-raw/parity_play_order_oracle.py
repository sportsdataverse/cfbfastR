"""Re-capture cfbfastR's ESPN play-order parity oracle from sdv-py (offline, raw payloads on disk).

Replays sdv-py's final `_sort_plays_ot_aware` call (id sort, late inserts, drive reunite, tries filed
after the kickoff, overtime order) on each game's raw ESPN plays, and records the inputs
`.espn_play_order()` reads plus the rank sdv-py gives each row (`sdvpy_rank`, 0-based).
"""

import csv, gzip, io, json, os, pathlib, subprocess, sys

SDV_PY = os.environ.get(
    "SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py"
)  # sdv-py checkout
sys.path.insert(0, SDV_PY)
import polars as pl
from sportsdataverse.cfb.cfb_pbp import _sort_plays_ot_aware

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
    # late inserts
    401752769,
    401754571,
    401754572,
    401754604,
    401757174,
    401757299,
    401762495,
    401762509,
    401762847,
    401777326,
    401779842,
    401856816,
    401858213,
    401860878,
    401864425,
    401869931,
    # drive reunite (sportsdataverse-py #637)
    400763648,
    401525890,
    401635534,
    401752914,
    401754558,
    401757267,
    401760367,
    401762472,
    # 323080276: id order alternates two drives; only the moved drive's own try travels
    323080276,
    # tries filed after the kickoff
    400547867,
    400548185,
    400548250,
    400852742,
    401524046,
    # overtime (400547647, 401762831: sequence and id order step the score back equally)
    272512348,
    332852655,
    400787460,
    400869644,
    401117878,
    401752705,
    401752720,
    401757168,
    400547647,
    401762831,
    # id order alone differs from the feed (duplicate ids, variable-length 2025+ ids)
    401752687,
    401752757,
    401754516,
    401864500,
    # nothing to repair
    242900265,
]
COLS = [
    "game_id",
    "row",
    "id",
    "sequence",
    "period",
    "clock",
    "drive_id",
    "type",
    "start_text",
    "end_text",
    "season",
    "home_score",
    "away_score",
    "sdvpy_rank",
]
out = []
for gid in GAMES:
    d = json.loads((RAW / f"{gid}.json").read_text())
    season = ((d.get("header") or {}).get("season") or {}).get("year")
    rows = []
    for key in sorted((d.get("drives") or {}).keys(), key=lambda k: k == "current"):
        drives = (
            d["drives"][key]
            if isinstance(d["drives"][key], list)
            else [d["drives"][key]]
        )
        for dr in drives:
            for p in dr.get("plays") or []:
                clk = (p.get("clock") or {}).get("displayValue") or ""
                per = (p.get("period") or {}).get("number")
                try:
                    mm, ss = (int(x) for x in clk.split(":"))
                    adj = {1: 2700, 2: 1800, 3: 900}.get(per, 0) + 60 * mm + ss
                except (ValueError, TypeError):
                    adj = None
                seq = p.get("sequenceNumber")
                rows.append(
                    {
                        "id": int(p["id"]),
                        "sequenceNumber": int(seq) if seq not in (None, "") else None,
                        "period.number": per,
                        "start.adj_TimeSecsRem": adj,
                        "drive.id": None if dr.get("id") is None else str(dr["id"]),
                        "type.text": (p.get("type") or {}).get("text"),
                        "start.downDistanceText": (p.get("start") or {}).get(
                            "downDistanceText"
                        ),
                        "end.downDistanceText": (p.get("end") or {}).get(
                            "downDistanceText"
                        ),
                        "season": season,
                        "homeScore": p.get("homeScore"),
                        "awayScore": p.get("awayScore"),
                        "_clock": clk,
                    }
                )
    df = pl.DataFrame(rows, infer_schema_length=None).with_row_index("_row")
    # sdv-py's final sort (__add_downs_data) runs after a typeless play is labelled
    # "Unknown"; the fixture keeps the raw type so the R side has to do the same
    final = df.drop("_clock").with_columns(pl.col("type.text").fill_null("Unknown"))
    rank = {r: k for k, r in enumerate(_sort_plays_ot_aware(final)["_row"].to_list())}
    for r in df.iter_rows(named=True):
        out.append(
            [
                gid,
                r["_row"],
                r["id"],
                r["sequenceNumber"],
                r["period.number"],
                r["_clock"],
                r["drive.id"],
                r["type.text"],
                r["start.downDistanceText"],
                r["end.downDistanceText"],
                r["season"],
                r["homeScore"],
                r["awayScore"],
                rank[r["_row"]],
            ]
        )
sha = (
    subprocess.check_output(["git", "-C", SDV_PY, "rev-parse", "--short", "HEAD"])
    .decode()
    .strip()
)
# mtime=0 keeps the gzip bytes stable across re-captures
with (
    open(OUT / "play_order_oracle.csv.gz", "wb") as raw,
    gzip.GzipFile(fileobj=raw, mode="wb", mtime=0) as gz,
):
    fh = io.TextIOWrapper(gz, encoding="utf-8", newline="")
    w = csv.writer(fh, lineterminator="\n")
    w.writerow(COLS)
    w.writerows(out)
    fh.flush()
    fh.detach()
print("games", len(GAMES), "rows", len(out), "sdv-py", sha)
