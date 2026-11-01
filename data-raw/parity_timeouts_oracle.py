"""Re-capture cfbfastR's timeout-counting parity oracle from sdv-py (offline, raw payloads on disk).

Runs ``CFBPlayProcess.run_processing_pipeline()`` on banked ESPN summaries and writes one row per
play, in sdv-py's final order: the inputs ``.espn_timeouts()`` reads (period, type, text and the
header's abbreviation / location / name for each team) and what sdv-py made of them -- which team
a Timeout row charges (``homeTimeoutCalled`` / ``awayTimeoutCalled``) and each team's timeouts
remaining at the start and end of the play; ``start_is_home`` (the start team is the home team)
lets ``test-pbp_timeouts.R`` replay the offense / defense mapping too.

    python data-raw/parity_timeouts_oracle.py

Env: ``SDV_PY_ROOT`` (sdv-py checkout), ``CFB_RAW_JSON`` (cfbfastR-cfb-raw ``cfb/json/raw``),
``SDV_PY_SHA`` (the commit, when ``SDV_PY_ROOT`` is an export with no ``.git``).
Do not hand-edit the output.
"""

import gzip, json, logging, os, pathlib, subprocess, sys

SDV_PY = os.environ.get("SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py")
sys.path.insert(0, SDV_PY)
logging.disable(logging.CRITICAL)
import polars as pl
from sportsdataverse.cfb import CFBPlayProcess

RAW = os.environ.get("CFB_RAW_JSON", "/mnt/sdv_repos/cfbfastR-cfb-raw/cfb/json/raw")
OUT = (
    pathlib.Path(__file__).resolve().parents[1]
    / "tests"
    / "testthat"
    / "fixtures"
    / "parity"
)
# Each picked so one rule decides at least one Timeout row:
GAMES = [
    401752665,  # 2025 "Timeout Alabama, clock 07:51": a name part
    252440248,  # 2005 "Timeout clock 12:14,  Oregon": the clock before the team
    243250239,  # 2004 "Sooners timeout; 00:35.7 remaining 2nd quarter": the mascot, the old clock tail
    242620002,  # 2004 two Tigers: a tie charges both
    283332199,  # 2008 "Eastern Michigan, Central Michigan" in one row: a tie on the location
    322730166,  # 2012 "UTSA, NMSU" in one row
    293110009,  # 2009 "SOUTHERN CAL" vs Cal's "cal": the initialism (USC) outranks a partial match
    283270254,  # 2008 "BRIGHAM YOUNG": initialism BYU
    401012682,  # 2018 "OREGON ST": a full name match outranks Ohio State's initialism OSU
    252532649,  # 2005 "WESTRN MICHIGAN": no name part, the shortened-name resolver
    282430061,  # 2008 "GA SOUTHERN": the shortened-name resolver
    252460251,  # 2005 "UL LAFAYETTE": the shortened-name resolver
    401677188,  # 2024 "two minute" stoppages: charged to nobody
    401761657,  # 2025 an adjacent repeat of a Timeout row: one timeout
    401754372,  # 2025 timeouts in two overtime periods: one per period
    302540119,  # 2010 timeouts in two overtime periods
]
COLS = {
    "id": "id_play",
    "period.number": "period",
    "type.text": "type",
    "text": "text",
    "start.is_home": "start_is_home",
    "homeTimeoutCalled": "sdvpy_home_called",
    "awayTimeoutCalled": "sdvpy_away_called",
    "start.homeTeamTimeouts": "sdvpy_start_home",
    "start.awayTeamTimeouts": "sdvpy_start_away",
    "end.homeTeamTimeouts": "sdvpy_end_home",
    "end.awayTeamTimeouts": "sdvpy_end_away",
}


def header_teams(gid):
    comp = json.load(open(f"{RAW}/{gid}.json", encoding="utf-8"))["header"][
        "competitions"
    ][0]
    out = {}
    for c in comp["competitors"]:
        t, side = c["team"], c["homeAway"]
        out[f"{side}_abbr"] = t.get("abbreviation") or ""
        out[f"{side}_location"] = t.get("location") or ""
        out[f"{side}_name"] = t.get("name") or ""
    return out


def game_frame(gid):
    p = CFBPlayProcess(gameId=gid, path_to_json=RAW)
    p.join_participants = False
    p.cfb_pbp_disk()
    plays = p.run_processing_pipeline()["plays"]
    if not plays:
        return None
    df = pl.DataFrame(
        [{c: r.get(c) for c in COLS} for r in plays], infer_schema_length=None
    )
    teams = header_teams(gid)
    return df.select([pl.col(k).alias(v) for k, v in COLS.items()]).with_columns(
        pl.lit(str(gid)).alias("game_id"),
        pl.col("id_play").cast(pl.Utf8),
        *[pl.lit(v).alias(k) for k, v in teams.items()],
    )


def main():
    frames = [f for f in (game_frame(g) for g in GAMES) if f is not None]
    oracle = pl.concat(frames, how="diagonal_relaxed")
    lead = ["game_id", "id_play", "period", "type", "text"]
    oracle = oracle.select(lead + [c for c in oracle.columns if c not in lead])
    dest = OUT / "timeouts_oracle.csv.gz"
    with gzip.GzipFile(dest, "wb", compresslevel=9, mtime=0) as fh:
        oracle.write_csv(fh)
    try:
        sha = (
            subprocess.check_output(
                ["git", "-C", SDV_PY, "rev-parse", "--short=10", "HEAD"],
                stderr=subprocess.DEVNULL,
            )
            .decode()
            .strip()
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        sha = os.environ.get("SDV_PY_SHA", "unknown")
    to = oracle.filter(pl.col("type") == "Timeout")
    print(
        "games",
        oracle["game_id"].n_unique(),
        "rows",
        oracle.height,
        "timeouts",
        to.height,
        "charged home",
        to["sdvpy_home_called"].sum(),
        "away",
        to["sdvpy_away_called"].sum(),
        "sdv-py",
        sha,
        "->",
        dest,
    )


if __name__ == "__main__":
    main()
