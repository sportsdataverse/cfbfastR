"""Capture cfbfastR's overtime-WP and air-yards-CP parity oracle from sdv-py (offline).

Runs ``CFBPlayProcess.run_processing_pipeline()`` on banked ESPN summaries of two 2025 overtime
games and writes one row per play: the start state sdv-py scored its WP boosters on, the two
boosters' raw output (``_as_trained_2h_flag`` then the booster, as ``parity_epa_wp_oracle.py``),
the same passed through ``cfb_wp_overtime.adjust_wp`` exactly as ``_wp_predict`` does
(``second`` from ``_ot_second``, ``forced`` from ``_ot_forced``), and the CP inputs and sdv-py's
published ``cp`` / ``cp_model`` / ``cp_game_state``. ``test-parity_wp_overtime.R`` replays
cfbfastR's scoring on the inputs.

    python data-raw/parity_wp_overtime_oracle.py

Env: ``SDV_PY_ROOT`` (sdv-py checkout), ``CFB_RAW_JSON`` (cfbfastR-cfb-raw ``cfb/json/raw``).
Do not hand-edit the output.
"""

import gzip, os, pathlib, subprocess, sys

SDV_PY = os.environ.get("SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py")
sys.path.insert(0, SDV_PY)
import numpy as np
import polars as pl
from xgboost import DMatrix
import sportsdataverse.cfb.cfb_pbp as cp
from sportsdataverse.cfb import CFBPlayProcess

RAW = os.environ.get("CFB_RAW_JSON", "/mnt/sdv_repos/cfbfastR-cfb-raw/cfb/json/raw")
DEST = (
    pathlib.Path(__file__).resolve().parents[1]
    / "tests"
    / "testthat"
    / "fixtures"
    / "parity"
    / "wp_overtime_oracle.csv.gz"
)
# 2025 games with a pre-game line that reached overtime: 401760426 went to a second overtime (a
# touchdown there must be followed by a two-point try from 2021), 401761665 to one.
GAMES = [401760426, 401761665]

COLS = {
    "id": "id_play",
    "season": "season",
    "period": "period",
    "type.text": "play_type",
    "homeTeamId": "home_id",
    "start.pos_team.id": "pos_team_id",
    "start.TimeSecsRem": "TimeSecsRem",
    "start.adj_TimeSecsRem": "adj_TimeSecsRem",
    "start.down": "down",
    "start.distance": "distance",
    "start.yardsToEndzone": "yards_to_goal",
    "pos_score_diff_start": "pos_score_diff_start",
    "start.posTeamTimeouts": "pos_team_timeouts_rem_before",
    "start.defPosTeamTimeouts": "def_pos_team_timeouts_rem_before",
    "start.pos_team_receives_2H_kickoff": "pos_team_receives_2H_kickoff",
    "start.is_home": "is_home",
    "start.ExpScoreDiff_Time_Ratio": "ExpScoreDiff_Time_Ratio",
    "start.spread_time": "spread_time",
    "start.pos_team_spread": "pos_team_spread",
    "pass": "pass",
    "rush": "rush",
    "completion": "completion",
    "passing_down": "passing_down",
    "air_yards": "air_yards",
    "pass_direction": "pass_direction",
    "qb_hurry": "qb_hurry",
    "cp": "cp",
    "cp_model": "cp_model",
    "cp_game_state": "cp_game_state",
    "wp_before_naive": "wp_before_naive",
    "wp_before": "wp_before",
}


def booster(df, model, src_cols, names):
    x = df.select(src_cols)
    x.columns = names
    x = cp._as_trained_2h_flag(x)
    return x, model.predict(DMatrix(x)).astype(np.float64)


def game_frame(gid):
    p = CFBPlayProcess(gameId=gid, path_to_json=RAW)
    p.join_participants = False
    p.cfb_pbp_disk()
    plays = p.run_processing_pipeline()["plays"]
    full = pl.DataFrame(
        [{c: r.get(c) for c in COLS} for r in plays], infer_schema_length=None
    )
    second = cp._ot_second(full, "start.pos_team.id")
    forced = cp._ot_forced(full)
    xn, naive = booster(
        full, cp.wp_naive_model, cp.wp_naive_start_columns, cp.wp_naive_final_names
    )
    xs, spread = booster(full, cp.wp_model, cp.wp_start_columns, cp.wp_final_names)
    out = full.select([pl.col(k).alias(v) for k, v in COLS.items()]).with_columns(
        pl.lit(str(gid)).alias("game_id"),
        pl.Series("play_order", np.arange(full.height)),
        *[pl.col(c).cast(pl.Utf8) for c in ("id_play", "home_id", "pos_team_id")],
        pl.Series("ot_second", [None if v is None else bool(v) for v in second], dtype=pl.Boolean),
        pl.Series("ot_forced", forced, dtype=pl.Boolean),
        pl.Series("wp_naive_raw", naive),
        pl.Series("wp_spread_raw", spread),
        pl.Series(
            "wp_naive_adj", cp._adjust_wp(naive, xn, second=second, forced=forced)
        ),
        pl.Series(
            "wp_spread_adj", cp._adjust_wp(spread, xs, second=second, forced=forced)
        ),
    )
    lead = ["game_id", "id_play", "play_order"]
    return out.select(lead + [c for c in out.columns if c not in lead])


def main():
    oracle = pl.concat([game_frame(g) for g in GAMES], how="diagonal_relaxed")
    with gzip.GzipFile(DEST, "wb", compresslevel=9, mtime=0) as fh:
        oracle.write_csv(fh, float_precision=10)
    sha = (
        subprocess.check_output(
            ["git", "-C", SDV_PY, "describe", "--always", "--dirty", "--abbrev=10"]
        )
        .decode()
        .strip()
    )
    print(
        "rows",
        oracle.height,
        "ot rows",
        oracle.filter(pl.col("period") >= 5).height,
        "sdv-py",
        sha,
        "->",
        DEST,
    )


if __name__ == "__main__":
    main()
