#!/usr/bin/env python3
"""Figure for the FS / -40 C / 1.62 V corner diagnosis (Step 2 of the corner study).

Three columns: TT reference, FS with fixed bias, FS with tracking bias.
Rows: integrator outputs, comparator output q, OTA internal nodes of stage 2
(source of the PMOS input pair x2.x11.net1 and first-stage outputs x2.vo1_a/b).

Usage (from the repository root, inside the container):
  python3 top_level/closed_loop/tools/plot_fs_debug.py \
      --tt top_level/xschem/sim_out/tb_SD_TOP.raw \
      --fs-fixed top_level/xschem/sim_out/dbg/f7_fs_m40_v162_dbg.raw \
      --fs-track top_level/xschem/sim_out/dbg/f7_fs_m40_v162_trackbias_dbg.raw \
      --out top_level/closed_loop/docs/figures/fs_corner_debug.png
"""
import argparse
import os
import sys

import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from view_raw import read_raw  # noqa: E402


def sig(d, name):
    if name in d:
        return np.asarray(d[name]).real
    return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--tt", required=True)
    ap.add_argument("--fs-fixed", required=True)
    ap.add_argument("--fs-track", required=True)
    ap.add_argument("--t0", type=float, default=20e-6)
    ap.add_argument("--t1", type=float, default=21.5e-6)
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    cols = [("TT / 27 C / 1.8 V (reference)", a.tt, 1.8),
            ("FS / -40 C / 1.62 V, fixed bias", a.fs_fixed, 1.62),
            ("FS / -40 C / 1.62 V, tracking bias", a.fs_track, 1.62)]
    fig, ax = plt.subplots(3, 3, figsize=(16, 9), sharex="col")
    for j, (title, path, vdd) in enumerate(cols):
        d = read_raw(path)
        if isinstance(d, tuple):
            d = [x for x in d if isinstance(x, dict)][0]
        t = sig(d, "time")
        t1 = min(a.t1, t[-1])          # debug runs are shorter: use their last window
        t0 = t1 - (a.t1 - a.t0)
        m = (t >= t0) & (t <= t1)
        tu = t[m] * 1e6
        o1 = sig(d, "o1_p") - sig(d, "o1_n")
        o2 = sig(d, "o2_p") - sig(d, "o2_n")
        ax[0, j].plot(tu, o1[m], label="integrator 1 (diff)")
        ax[0, j].plot(tu, o2[m], label="integrator 2 (diff)")
        ax[0, j].set_title(title, fontsize=10)
        ax[1, j].plot(tu, sig(d, "q")[m], color="k", lw=0.8, label="q (bit)")
        ax[1, j].set_ylim(-0.1, 2.0)
        n1, va, vb = sig(d, "x2.x11.net1"), sig(d, "x2.vo1_a"), sig(d, "x2.vo1_b")
        if n1 is not None:
            ax[2, j].plot(tu, n1[m], label="input-pair source (x2.x11.net1)")
            ax[2, j].plot(tu, va[m], label="1st-stage out a (x2.vo1_a)")
            ax[2, j].plot(tu, vb[m], label="1st-stage out b (x2.vo1_b)")
            ax[2, j].axhline(vdd, color="r", ls=":", lw=0.8, label=f"VDD = {vdd} V")
        else:
            ax[2, j].text(0.5, 0.5, "internal OTA nodes\nnot saved in this run",
                          ha="center", va="center", transform=ax[2, j].transAxes)
        for i in range(3):
            ax[i, j].grid(alpha=0.3)
            ax[i, j].legend(fontsize=7, loc="upper right")
    ax[0, 0].set_ylabel("V")
    ax[1, 0].set_ylabel("V")
    ax[2, 0].set_ylabel("V (stage 2 OTA)")
    for j in range(3):
        ax[2, j].set_xlabel("time [us]")
    fig.suptitle("FS / -40 C / 1.62 V: with tracking bias the OTA input pair has no headroom "
                 "(source at VDD, first stage at ~0 V) and the loop stops toggling  "
                 "[SIMULATED_NOT_FINAL_PASS]", fontsize=10)
    fig.tight_layout()
    os.makedirs(os.path.dirname(a.out), exist_ok=True)
    fig.savefig(a.out, dpi=110)
    print("saved", a.out)


if __name__ == "__main__":
    main()
