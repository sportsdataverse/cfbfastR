"""Re-capture cfbfastR's ESPN play-type relabel parity oracle from sdv-py (offline, raw payloads on disk).

Runs sdv-py's pipeline and records, for every play leaving `__helper_cfb_pbp_features` (in the
order it leaves), the inputs `.espn_retype_plays()` reads and the type / start spot sdv-py's
relabel block gives it. `orig_play_type` is the type before the block (sdv-py sets it just before);
`sdvpy_type_normalized` adds the later pre-2014 label normalization in `__add_new_play_types`.
"""

import csv, gzip, io, json, logging, os, pathlib, subprocess, sys

SDV_PY = os.environ.get("SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py")  # sdv-py checkout
sys.path.insert(0, SDV_PY)
logging.disable(logging.CRITICAL)
import polars as pl
import sportsdataverse.cfb.cfb_pbp as M

RAW = pathlib.Path(os.environ.get("CFB_RAW_JSON", "/mnt/sdv_repos/cfbfastR-cfb-raw/cfb/json/raw"))
OUT = pathlib.Path(__file__).resolve().parents[1] / "tests" / "testthat" / "fixtures" / "parity"
GAMES = [
    # 2004: kicks typed only by scoringType; untyped defensive try
    243250238,
    243582132,
    243392572,
    # 2007-13 touchdown + kick rows: pass / rush, return and fumble touchdowns, a punt team's own
    292832449,
    312462638,
    332782638,
    302602440,
    # a kick-typed interception / fumble touchdown the same team started and ended: not a return
    273000264,
    322660194,
    # defensive try returns typed as the kick
    312530264,
    272650152,
    # kick-typed misfiles: a kickoff, a field goal
    303100030,
    303170158,
    # the untyped two-point try; overtime copies of shootout attempts stay "Unknown"
    401525903,
    401426542,
    # pre-2014 labels: a bare "2pt Conversion" that failed, an onside "Kickoff Return (Defense)"
    292542649,
    242480152,
    # nothing to relabel
    401628339,
    400547699,
]
COLS = [
    "game_id",
    "id",
    "orig_play_type",
    "text",
    "scoring_type",
    "period",
    "scoring_play",
    "clock",
    "start_team",
    "end_team",
    "start_ytg",
    "sdvpy_type",
    "sdvpy_start_ytg",
    "sdvpy_type_normalized",
]
rec = {}
C = M.CFBPlayProcess
orig_feat = C._CFBPlayProcess__helper_cfb_pbp_features


def feat(self, pbp_txt, init):
    out = orig_feat(self, pbp_txt, init)
    rec["plays"] = (out[0] if isinstance(out, tuple) else out)["plays"]
    return out


C._CFBPlayProcess__helper_cfb_pbp_features = feat
orig_new = C._CFBPlayProcess__add_new_play_types
LEGACY = ("Unknown", "2pt Conversion", "Kickoff Return (Defense)")


def new_types(self, df):
    out = orig_new(self, df)
    # its pre-2014 label normalization is gated on these labels: record what it made of them
    rec["norm"] = {
        str(i): o for i, t, o in zip(df["id"].to_list(), df["type.text"].to_list(), out["type.text"].to_list()) if t in LEGACY
    }
    return out


C._CFBPlayProcess__add_new_play_types = new_types
rows = []
for gid in GAMES:
    raw = json.loads((RAW / f"{gid}.json").read_text(encoding="utf-8"))
    # the block rewrites start.yardsToEndzone; its input is the feed's
    ytg = {
        str(p["id"]): (p.get("start") or {}).get("yardsToEndzone")
        for k in (raw.get("drives") or {})
        for dr in (raw["drives"][k] if isinstance(raw["drives"][k], list) else [raw["drives"][k]])
        for p in dr.get("plays") or []
    }
    p = C(gameId=gid, path_to_json=str(RAW))
    p.join_participants = False
    p.cfb_pbp_disk()
    p.run_processing_pipeline()
    df = rec["plays"]
    st = "scoringType.displayName"
    for r in df.iter_rows(named=True):
        rows.append(
            [
                gid,
                str(r["id"]),
                r["orig_play_type"],
                r["text"],
                r.get(st),
                r["period.number"],
                r["scoringPlay"],
                r["clock.displayValue"],
                r["start.pos_team.id"],
                r["end.pos_team.id"],
                ytg.get(str(r["id"])),
                r["type.text"],
                r["start.yardsToEndzone"],
                rec["norm"].get(str(r["id"]), r["type.text"]),
            ]
        )
sha = subprocess.check_output(["git", "-C", SDV_PY, "rev-parse", "--short", "HEAD"]).decode().strip()
# mtime=0 keeps the gzip bytes stable across re-captures
with open(OUT / "retype_oracle.csv.gz", "wb") as fh_raw, gzip.GzipFile(fileobj=fh_raw, mode="wb", mtime=0) as gz:
    fh = io.TextIOWrapper(gz, encoding="utf-8", newline="")
    w = csv.writer(fh, lineterminator="\n")
    w.writerow(COLS)
    w.writerows(rows)
    fh.flush()
    fh.detach()
print("games", len(GAMES), "rows", len(rows), "sdv-py", sha)
