#!/usr/bin/env python3
"""Re-analyse existing start-up runs of Block 6 (no simulation): reads <dir>/*.dat written by startup_block6.py.

Writes <dir>/startup_summary.csv and prints a markdown table (A6). Same settle/OK rule as startup_block6.py:
OK = pulses stay within 1 ns of the final width and gap from some pulse on, final gap >= 5 ns,
final width >= 100 ns, overlap < 1 % of VDD (the screening limit used for the PVT sweeps).

  python3 tools/startup_report_block6.py --dir /headless/tidy_test/results/startup_block6
"""
import argparse, csv, re, sys
from pathlib import Path
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import startup_block6 as S

TAG = re.compile(r"^([a-z]{2})_T(m?\d+)_V(\d+p\d+)_r(\d+)_(after|during)\.dat$")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--dir", default="results/startup_block6")
    ap.add_argument("--min-gap", type=float, default=5.0)
    ap.add_argument("--min-width", type=float, default=100.0)
    ap.add_argument("--max-ovl", type=float, default=0.01)
    a = ap.parse_args()
    d = Path(a.dir)
    rows = []
    for f in sorted(d.glob("*.dat")):
        m = TAG.match(f.name)
        if not m:
            continue
        corner, t, v, r, mode = m.groups()
        temp = t.replace("m", "-"); vdd = float(v.replace("p", ".")); ramp = float(r) * 1e-6
        row = dict(corner=corner, temp=temp, vdd=vdd, ramp_us=float(r), clk_mode=mode, status="CHECK")
        res = S.analyse(f, vdd, ramp, 0.0)
        if res and len(res[0]) >= 3:
            pulses, ovl = res
            w = np.array([p[1] for p in pulses]) * 1e9
            g = np.array([p[2] for p in pulses]) * 1e9
            wf = w[-1]; gf = g[-2] if len(g) > 1 and np.isnan(g[-1]) else g[-1]
            gv = ~np.isnan(g)
            idx = [k for k in range(len(w)) if np.all(np.abs(w[k:] - wf) < 1.0)
                   and np.all(np.abs(g[k:][gv[k:]] - gf) < 1.0)]
            k = idx[0] + 1 if idx else None
            ok = k is not None and gf >= a.min_gap and wf >= a.min_width and ovl < a.max_ovl * vdd
            row.update(pulses=len(w), pulses_to_settle=k if k else "never", final_width_ns=round(wf, 2),
                       final_gap_ns=round(gf, 2), max_overlap_mV=round(ovl * 1e3, 3),
                       first_pulses=" ".join(f"{w[i]:.0f}/{g[i]:.1f}" for i in range(min(3, len(w)))),
                       status="OK" if ok else "CHECK")
        rows.append(row)
    if not rows:
        sys.exit(f"no matching .dat files in {d}")
    cols = ["corner", "temp", "vdd", "ramp_us", "clk_mode", "pulses", "pulses_to_settle", "final_width_ns",
            "final_gap_ns", "max_overlap_mV", "first_pulses", "status"]
    with open(d / "startup_summary.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=cols, extrasaction="ignore"); w.writeheader(); w.writerows(rows)
    print("| Corner | T (C) | VDD (V) | Ramp (us) | Clock | Pulses to settle | Final width (ns) | Final gap (ns) | Max overlap (mV) | First pulses (width/gap ns) | Verdict |")
    print("|---|---|---|---|---|---|---|---|---|---|---|")
    for r in rows:
        print(f"| {r['corner']} | {r['temp']} | {r['vdd']} | {r['ramp_us']:g} | {r['clk_mode']} | {r.get('pulses_to_settle','-')} | "
              f"{r.get('final_width_ns','-')} | {r.get('final_gap_ns','-')} | {r.get('max_overlap_mV','-')} | {r.get('first_pulses','-')} | {r['status']} |")
    print(f"\n{sum(r['status']=='OK' for r in rows)}/{len(rows)} OK; csv: {d / 'startup_summary.csv'}")
    print("STATUS: MEASURED_NOT_FINAL; pre-layout; supply ramp from 0 V, clock after/during the ramp.")


if __name__ == "__main__":
    main()
