#!/usr/bin/env python3
"""Start-up test of Block 6 (NONOV) with its bias generator: VDD ramps 0 -> VDD, then the phases are checked.

Patches a copy of a deck (use the generator deck, e.g. ..._biasgen_res_tc.spice):
  VVDD  -> PWL(0 0 <ramp> <vdd>)
  VCLK  -> clock starts after the ramp (--clk-mode after, default) or at its original delay
           while VDD is still ramping (--clk-mode during; the clock amplitude is already VDD, a harsh case)
  tran  -> 0 .. ramp + clock delay + --run (default 3 us), meas lines removed.
Per run it prints, for the first pulses and for the settled state: phi1/phi2 width, non-overlap gap, the number of
pulses until width and gap stay within 1 ns of their final value, the maximum overlap min(phi1,phi2), and OK/CHECK
(OK = settled, final gap >= 5 ns, final width >= 100 ns, overlap < 5 % of VDD).
Status labels: MEASURED_NOT_FINAL.

  python3 tools/startup_block6.py --repo /headless/tidy_test --deck <..._biasgen_res_tc.spice>
  python3 tools/startup_block6.py --repo /headless/tidy_test --deck <...> --clk-mode during --ramps 1
"""
import argparse, re, subprocess, sys
from pathlib import Path
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import pvt_block6 as P

TRAN_RE = re.compile(r"^\s*tran\s+.*$", re.I)
MEAS_RE = re.compile(r"^\s*meas\b", re.I)
CASES = [("tt", "27", "1.8"), ("ss", "-40", "1.62"), ("ff", "125", "1.98"), ("fs", "-40", "1.98")]


def num(s):
    m = re.fullmatch(r"([-+0-9.eE]+)([a-zA-Z]*)", s.strip())
    f = {"": 1, "f": 1e-15, "p": 1e-12, "n": 1e-9, "u": 1e-6, "m": 1e-3}
    return float(m.group(1)) * f[m.group(2).lower()]


def build(lines, case, ramp_us, mode, run_us, tstep, dat):
    corner, temp, vdd = case
    ramp = ramp_us * 1e-6
    out, delay = [], 20e-9
    for l in P.patch(lines, corner, temp, vdd, str(dat)):
        m = P.VDD_RE.match(l)
        if m:
            l = f"{m.group(1)}PWL(0 0 {ramp:.6g} {vdd})"
        else:
            m = P.CLK_RE.match(l)
            if m:
                tok = m.group(3).split(None, 1)
                delay = num(tok[0])
                if mode == "after":
                    delay = ramp + 20e-9
                l = f"{m.group(1)}{vdd} {delay:.6g} {tok[1] if len(tok) > 1 else ''}"
        if MEAS_RE.match(l):
            continue
        if TRAN_RE.match(l):
            l = f"tran {tstep} {ramp + delay + run_us * 1e-6:.6g} 0 {tstep}"
        out.append(l)
    return out, ramp, delay


def edges(t, v, th):
    s = v > th
    i = np.where(s[1:] != s[:-1])[0]
    te = t[i] + (th - v[i]) * (t[i + 1] - t[i]) / (v[i + 1] - v[i])
    return te[s[i + 1]], te[~s[i + 1]]          # rising, falling


def analyse(dat, vdd, ramp, delay):
    rows = []
    for l in Path(dat).read_text().splitlines():
        try: rows.append([float(x) for x in l.split()])
        except ValueError: continue
    if not rows or len(rows[0]) < 6:
        return None
    a = np.array(rows); t, p1, p2 = a[:, 0], a[:, 2], a[:, 4]
    th = vdd / 2
    r1, f1 = edges(t, p1, th); r2, f2 = edges(t, p2, th)
    pulses = []                                   # (t_rise1, width1, gap to next phi2 rise)
    for r in r1:
        f = f1[f1 > r]
        if not len(f): continue
        n2 = r2[r2 > f[0]]
        pulses.append((r, f[0] - r, (n2[0] - f[0]) if len(n2) else np.nan))
    ovl = float(np.minimum(p1, p2)[t > ramp].max()) if (t > ramp).any() else np.nan
    return pulses, ovl


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--repo", default=".")
    ap.add_argument("--deck", required=True)
    ap.add_argument("--ngspice", default="ngspice")
    ap.add_argument("--ramps", default="1,20", help="VDD ramp times in us, comma separated")
    ap.add_argument("--clk-mode", choices=["after", "during"], default="after")
    ap.add_argument("--run", type=float, default=3.0, help="us simulated after the clock starts")
    ap.add_argument("--tstep", default="0.2n")
    ap.add_argument("--timeout", type=int, default=1800)
    ap.add_argument("--out", default="results/startup_block6")
    a = ap.parse_args()
    repo = Path(a.repo).resolve(); deck = Path(a.deck)
    if not deck.is_absolute(): deck = repo / deck
    if not deck.exists(): sys.exit(f"Deck not found: {deck}")
    lines = P.read_deck(deck); cwd = P.pick_cwd(deck, lines, repo)
    od = repo / a.out; od.mkdir(parents=True, exist_ok=True)
    print(f"clock mode: {a.clk_mode}; run {a.run} us after clock start")
    print("corner  T(C)   VDD  ramp(us) | pulses to settle | final width  gap (ns) | max overlap (V) | first pulses (width/gap ns) | verdict")
    for case in CASES:
        for rs in a.ramps.split(","):
            ru = float(rs); vdd = float(case[2])
            tag = f"{case[0]}_T{case[1]}_V{case[2]}_r{rs}_{a.clk_mode}".replace("-", "m").replace(".", "p")
            dat = od / f"{tag}.dat"; sp = od / f"{tag}.spice"; log = od / f"{tag}.log"
            new, ramp, delay = build(lines, case, ru, a.clk_mode, a.run, a.tstep, dat)
            sp.write_text("\n".join(new) + "\n")
            try:
                subprocess.run([a.ngspice, "-b", "-o", str(log), str(sp)], cwd=cwd, capture_output=True, text=True, timeout=a.timeout)
            except subprocess.TimeoutExpired:
                print(f"{case[0]:>5s} {case[1]:>6s} {case[2]:>6s} {rs:>7s}  | TIMEOUT"); continue
            res = analyse(dat, vdd, ramp, delay) if dat.exists() else None
            if not res or len(res[0]) < 3:
                print(f"{case[0]:>5s} {case[1]:>6s} {case[2]:>6s} {rs:>7s}  | no/too few phi1 pulses -> CHECK (see {log})"); continue
            pulses, ovl = res
            w = np.array([p[1] for p in pulses]) * 1e9; g = np.array([p[2] for p in pulses]) * 1e9
            wf, gf = w[-1], g[-2] if len(g) > 1 and np.isnan(g[-1]) else g[-1]
            ok_idx = [k for k in range(len(w)) if np.all(np.abs(w[k:] - wf) < 1.0) and np.all(np.abs(g[k:][~np.isnan(g[k:])] - gf) < 1.0)]
            k = ok_idx[0] + 1 if ok_idx else None
            first = " ".join(f"{w[i]:.0f}/{g[i]:.1f}" for i in range(min(3, len(w))))
            good = k is not None and gf >= 5 and wf >= 100 and ovl < 0.05 * vdd
            print(f"{case[0]:>5s} {case[1]:>6s} {case[2]:>6s} {rs:>7s}  | {k if k else 'never':>16} | {wf:9.1f} {gf:8.2f} | {ovl:15.4f} | {first:<27s} | {'OK' if good else 'CHECK'}")
    print("files:", od)


if __name__ == "__main__":
    main()
