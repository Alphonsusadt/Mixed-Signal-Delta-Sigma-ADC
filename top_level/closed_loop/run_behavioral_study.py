#!/usr/bin/env python3
"""Studi model perilaku: DR vs OSR, kT/C vs Cs, gain OTA. Menulis results/*.csv|json|png."""
import csv, json, os, sys
import numpy as np
from sd_behavioral import (simulate, coherent_sine, sndr_from_bits,
                           amplitude_sweep, dynamic_range)

OUT = "results"
os.makedirs(OUT, exist_ok=True)
BASE = dict(a1=0.5, a2=0.5, b1=0.5, b2=0.5)
AMPS = list(range(-90, -9, 6)) + [-8, -6, -4.5, -3, -1.5]


def case(label, osr, n, fin_bin, **extra):
    params = dict(BASE); params.update(extra)
    rows = amplitude_sweep(params, AMPS, n_samp=n, osr=osr, fin_bin=fin_bin)
    ok = [r for r in rows if r["y1_pk"] < 3 and r["y2_pk"] < 3]   # buang overload
    best = max(ok, key=lambda r: r["sndr_db"])
    dr = dynamic_range(ok, a_max_dbfs=best["amp_dbfs"])
    res = dict(label=label, osr=osr, peak_sndr_db=round(best["sndr_db"], 1),
               peak_amp_dbfs=best["amp_dbfs"],
               dr_db=round(dr["dr_db"], 1) if dr else None)
    print(res, flush=True)
    return res, rows


results = []
sweeps = {}
# 1) ideal, DR vs OSR (fs tetap 4 MHz; BW = fs/(2 OSR))
for osr in (80, 128, 160, 256, 320):
    r, rows = case(f"ideal OSR={osr}", osr, 2 ** 16, 13)
    r["bw_khz"] = 4000 / (2 * osr); results.append(r); sweeps[r["label"]] = rows
# 2) kT/C, OSR=80
for cs in (1e-12, 2e-12, 4e-12, 8e-12):
    r, rows = case(f"kT/C Cs=Cd={cs*1e12:.0f}pF OSR=80", 80, 2 ** 16, 13,
                   cs1=cs, cd1=cs, cs2=cs, cd2=cs)
    r["bw_khz"] = 25.0; results.append(r); sweeps[r["label"]] = rows
# 3) kT/C, OSR=256
for cs in (1e-12, 2e-12, 4e-12):
    r, rows = case(f"kT/C Cs=Cd={cs*1e12:.0f}pF OSR=256", 256, 2 ** 16, 13,
                   cs1=cs, cd1=cs, cs2=cs, cd2=cs)
    r["bw_khz"] = 4000 / 512; results.append(r); sweeps[r["label"]] = rows
# 4) gain OTA hingga, OSR=80 (efek leakage)
for a0 in (40, 50, 60, 70):
    r, rows = case(f"A0={a0}dB OSR=80", 80, 2 ** 16, 13, a0_db=a0)
    r["bw_khz"] = 25.0; results.append(r); sweeps[r["label"]] = rows

with open(os.path.join(OUT, "behavioral_study.csv"), "w", newline="") as f:
    w = csv.DictWriter(f, fieldnames=["label", "osr", "bw_khz", "peak_sndr_db", "peak_amp_dbfs", "dr_db"])
    w.writeheader(); w.writerows(results)
json.dump(results, open(os.path.join(OUT, "behavioral_study.json"), "w"), indent=2)
print("selesai")
