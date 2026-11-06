#!/usr/bin/env python3
"""Bias target map for Block 6 (NONOV): which VBN/VBP gives the wanted gap at each PVT point.

Reuses pvt_block6.py (same folder). For every (corner, temp, VDD) a single knob d (volts) is
bisected so that the measured non-overlap gap equals --target (default 14 ns):

    VBN = VBN0 + d                       (VBN0 = 0.70 V, nominal)
    mode "track": VBP = VDD - (VDD0 - VBP0) - d    (VBP follows VDD; VDD0=1.8, VBP0=0.71)
    mode "fixed": VBP = VBP0 - d                    (VBP stays referenced to ground, as in the PVT sweep)

Modes "pmos"/"nmos" move only one device (the other stays nominal / VDD-referenced) to see which one sets the gap.
d > 0 means more bias current in the moved starving device(s), i.e. a faster delay and a smaller gap.
A dead run (no phi pulse, status FAIL) is treated as "gap too large".

Examples (repo root):
  python3 tools/bias_map_block6.py --repo /headless/tidy_test --quick --jobs 2
  python3 tools/bias_map_block6.py --repo /headless/tidy_test --jobs 2 --modes track,fixed

Status labels: MEASURED_NOT_FINAL. The result is a design target for a bias generator, not a
sign-off. Nothing here is a Monte Carlo or post-layout result.
"""
import argparse, csv, itertools, re, sys, concurrent.futures as cf
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import pvt_block6 as P

VBN_RE = re.compile(r"^(\s*vbnsrc\s+\S+\s+\S+\s+)(?:dc\s+)?(\S+)(.*)$", re.I)
VBP_RE = re.compile(r"^(\s*vbpsrc\s+\S+\s+\S+\s+)(?:dc\s+)?(\S+)(.*)$", re.I)

VBN0, VBP0, VDD0 = 0.70, 0.71, 1.8
QUICK = [(c, t, v) for c in ("ss", "tt", "ff")
         for (t, v) in (("-40", "1.62"), ("27", "1.8"), ("125", "1.98"))]


def set_bias(lines, vbn, vbp):
    out, nb, np_ = [], 0, 0
    for l in lines:
        m = VBN_RE.match(l)
        if m:
            l = f"{m.group(1)}{vbn:.5f}{m.group(3)}"; nb += 1
        else:
            m = VBP_RE.match(l)
            if m:
                l = f"{m.group(1)}{vbp:.5f}{m.group(3)}"; np_ += 1
        out.append(l)
    if nb != 1 or np_ != 1:
        raise SystemExit(f"Expected exactly one VBNSRC and one VBPSRC line, found {nb}/{np_}. Run pvt_block6.py --show.")
    return out


def bias_for(d, vdd, mode):
    vp_track = vdd - (VDD0 - VBP0) - d       # VBP referenced to VDD
    if mode == "track": return VBN0 + d, vp_track
    if mode == "fixed": return VBN0 + d, VBP0 - d
    if mode == "pmos":  return VBN0, vp_track                   # only VBP moves (VBN = 0.70 V)
    if mode == "nmos":  return VBN0 + d, vdd - (VDD0 - VBP0)    # only VBN moves (VBP tracks VDD, nominal Vsg)
    raise SystemExit(f"unknown mode {mode}")


def measure(case, d, mode, lines, cwd, outdir, a):
    corner, temp, vdd = case
    vbn, vbp = bias_for(d, float(vdd), mode)
    r = P.run_case(case, set_bias(lines, vbn, vbp), cwd, outdir, a.ngspice, a.timeout, None)
    if r["status"] != "MEASURED_NOT_FINAL":
        return None, None, r["status"]
    gap = min(r["dt_1f2r"], r["dt_2f1r"]) * 1e9
    wid = min(r["w_phi1"], r["w_phi2"]) * 1e9
    return gap, wid, r["status"]


def solve(case, mode, lines, cwd, outdir, a):
    lo, hi = a.dmin, a.dmax          # gap decreases with d
    best = None                      # (|err|, d, gap, width)
    n = 0
    trace = []
    for _ in range(a.iters):
        d = 0.5 * (lo + hi); n += 1
        gap, wid, st = measure(case, d, mode, lines, cwd, outdir, a)
        vb = bias_for(d, float(case[2]), mode)
        trace.append(dict(mode=mode, corner=case[0], temp=case[1], vdd=case[2], it=n, d=d,
                          vbn=vb[0], vbp=vb[1], gap_ns=gap, width_ns=wid, status=st))
        if st == "TIMEOUT":
            return dict(status="TIMEOUT", iters=n, trace=trace)
        if gap is None:              # dead: too slow -> need larger d
            lo = d; continue
        err = gap - a.target
        if best is None or abs(err) < best[0]:
            best = (abs(err), d, gap, wid)
        if abs(err) <= a.tol:
            break
        if err > 0: lo = d           # gap too big -> faster
        else: hi = d
    if best is None:
        return dict(status="NO_SOLUTION_DEAD", iters=n, trace=trace)
    _, d, gap, wid = best
    vbn, vbp = bias_for(d, float(case[2]), mode)
    st = "MEASURED_NOT_FINAL" if abs(gap - a.target) <= a.tol else "NOT_CONVERGED"
    return dict(status=st, iters=n, d=d, vbn=vbn, vbp=vbp, gap_ns=gap, width_ns=wid,
                vsg_p=float(case[2]) - vbp, trace=trace)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--repo", default=".")
    ap.add_argument("--deck", default=P.DEF_DECK)
    ap.add_argument("--ngspice", default="ngspice")
    ap.add_argument("--corners", default="tt,ss,ff,sf,fs")
    ap.add_argument("--temps", default="-40,27,125")
    ap.add_argument("--vdds", default="1.62,1.8,1.98")
    ap.add_argument("--quick", action="store_true", help="9 points: ss/tt/ff x (-40C,1.62V | 27C,1.8V | 125C,1.98V)")
    ap.add_argument("--modes", default="track", help="track, fixed, pmos (only VBP moves), nmos (only VBN moves); comma separated")
    ap.add_argument("--target", type=float, default=14.0, help="wanted gap, ns")
    ap.add_argument("--tol", type=float, default=0.7, help="accepted |gap-target|, ns")
    ap.add_argument("--dmin", type=float, default=-0.25)
    ap.add_argument("--dmax", type=float, default=0.30)
    ap.add_argument("--iters", type=int, default=10)
    ap.add_argument("--jobs", type=int, default=2)
    ap.add_argument("--timeout", type=int, default=900)
    ap.add_argument("--out", default="results/bias_map_block6")
    a = ap.parse_args()

    repo = Path(a.repo).resolve()
    deck = (repo / a.deck) if not Path(a.deck).is_absolute() else Path(a.deck)
    if not deck.exists():
        sys.exit(f"Deck not found: {deck}")
    lines = P.read_deck(deck)
    cwd = P.pick_cwd(deck, lines, repo)
    base = repo / a.out; base.mkdir(parents=True, exist_ok=True)
    cases = QUICK if a.quick else list(itertools.product(a.corners.split(","), a.temps.split(","), a.vdds.split(",")))
    modes = a.modes.split(",")
    jobs = [(c, m) for m in modes for c in cases]
    print(f"{len(jobs)} solves (<= {a.iters} ngspice runs each), target gap {a.target} ns, cwd={cwd}", flush=True)

    def work(j):
        c, m = j
        od = base / m; od.mkdir(exist_ok=True)
        return j, solve(c, m, lines, cwd, od, a)

    res = []
    with cf.ThreadPoolExecutor(max_workers=a.jobs) as ex:
        for j, r in ex.map(work, jobs):
            res.append((j, r))
            c, m = j
            print(f"  done {m:>5s} {c[0]:>3s} {c[1]:>4s}C {c[2]:>4s}V  {r['status']}  "
                  + (f"VBN={r['vbn']:.3f} VBP={r['vbp']:.3f} gap={r['gap_ns']:.2f}" if "vbn" in r else ""), flush=True)

    cols = ["mode", "corner", "temp", "vdd", "status", "iters", "d", "vbn", "vbp", "vsg_p", "gap_ns", "width_ns"]
    with open(base / "bias_map.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=cols, extrasaction="ignore"); w.writeheader()
        for (c, m), r in res:
            w.writerow(dict(mode=m, corner=c[0], temp=c[1], vdd=c[2], **r))

    tcols = ["mode", "corner", "temp", "vdd", "it", "d", "vbn", "vbp", "gap_ns", "width_ns", "status"]
    with open(base / "bias_trace.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=tcols, extrasaction="ignore"); w.writeheader()
        for (c, m), r in res:
            w.writerows(r.get("trace", []))
    print(f"\nmode  corner  T(C)  VDD   status               VBN     VBP    VDD-VBP  gap(ns)  width(ns)")
    for (c, m), r in res:
        if "vbn" in r:
            print(f"{m:>5s} {c[0]:>6s} {c[1]:>5s} {c[2]:>5s}  {r['status']:<19s}  {r['vbn']:.3f}  {r['vbp']:.3f}  {r['vsg_p']:.3f}   {r['gap_ns']:6.2f}  {r['width_ns']:7.1f}")
        else:
            print(f"{m:>5s} {c[0]:>6s} {c[1]:>5s} {c[2]:>5s}  {r['status']}")

    for m in modes:
        ok = [r for (c, mm), r in res if mm == m and "vbn" in r and r["status"] == "MEASURED_NOT_FINAL"]
        if ok:
            vn = [r["vbn"] for r in ok]; vs = [r["vsg_p"] for r in ok]
            print(f"\n[{m}] {len(ok)} converged: VBN {min(vn):.3f}..{max(vn):.3f} V (span {1e3*(max(vn)-min(vn)):.0f} mV), "
                  f"VDD-VBP {min(vs):.3f}..{max(vs):.3f} V (span {1e3*(max(vs)-min(vs)):.0f} mV)")
    print("csv :", base / "bias_map.csv", "|", base / "bias_trace.csv")


if __name__ == "__main__":
    main()
