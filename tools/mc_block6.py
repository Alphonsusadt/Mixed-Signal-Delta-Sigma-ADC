#!/usr/bin/env python3
"""Local-mismatch Monte Carlo for Block 6 (NONOV + bias generator), one corner/T/VDD.

One ngspice process per seed. The seed goes in through `.option seed=N` (same
mechanism as the Block 3 campaign); the .lib corner is switched to <corner>_mm,
so only LOCAL transistor mismatch is random (global process stays at the corner).
Resistor (ideal RB1) and capacitor mismatch are NOT included.

Reuses patch()/parse_log()/parse_dat()/pick_cwd() from tools/pvt_block6.py.
Results are appended per seed to <out>/mc_summary.csv; re-running skips finished seeds.

  python3 tools/mc_block6.py --repo /headless/tidy_test --n 2 --out results/mc_block6_try
  python3 tools/mc_block6.py --repo /headless/tidy_test --n 100 --jobs 2
  python3 tools/mc_block6.py --repo /headless/tidy_test --stats-only
"""
import argparse, csv, json, math, os, re, subprocess, sys, threading, concurrent.futures as cf
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import pvt_block6 as P

DEF_DECK = "blocks/06_Clock_gen/sim/out/netlist/tb_6D_realload_vbn0p70_biasgen_res_tc.spice"
COLS = ["seed", "status", "gap_min_ns", "gap_1f2r_ns", "gap_2f1r_ns", "width_min_ns",
        "w_phi1_ns", "w_phi2_ns", "ovl_mV", "pass"]
LOCK = threading.Lock()


def check_corner(lines, corner):
    """Fail early if the PDK has no '.lib <corner>' section."""
    for l in lines:
        m = re.match(r"^\s*\.lib\s+(\"[^\"]+\"|'[^']+'|\S+)\s+\S+", l, re.I)
        if m:
            lib = Path(m.group(1).strip("\"'"))
            if lib.exists():
                txt = lib.read_text(errors="replace")
                if not re.search(rf"^\s*\.lib\s+{re.escape(corner)}\s*$", txt, re.M | re.I):
                    sys.exit(f"PDK {lib} has no '.lib {corner}' section")
                return
    print("WARNING: could not verify corner section in the PDK file", file=sys.stderr)


def one_seed(seed, lines, cwd, outdir, a):
    corner = f"{a.corner}_mm"
    tag = f"s{seed}"
    deck, dat, log = outdir / f"{tag}.spice", outdir / f"{tag}.dat", outdir / f"{tag}.log"
    dl = P.patch(lines, corner, a.temp, a.vdd, str(dat), None)
    dl.insert(1, f".option seed={seed}")
    deck.write_text("\n".join(dl) + "\n")
    row = {"seed": seed, "status": "FAIL", "pass": 0}
    try:
        p = subprocess.run([a.ngspice, "-b", "-o", str(log), str(deck)], cwd=cwd,
                           capture_output=True, text=True, timeout=a.timeout)
    except subprocess.TimeoutExpired:
        row["status"] = "TIMEOUT"; return row
    txt = log.read_text(errors="replace") if log.exists() else p.stdout + p.stderr
    m = P.parse_log(txt)
    if dat.exists():
        r = P.parse_dat(dat, float(a.vdd))
        if r:
            m["minmax_phi_V"] = r[0]
        if os.environ.get("PVT_KEEP_DAT") is None:
            dat.unlink()
    if m.get("done") and "dt_1f2r" in m and "dt_2f1r" in m and "w_phi1" in m and "w_phi2" in m:
        g1, g2 = m["dt_1f2r"] * 1e9, m["dt_2f1r"] * 1e9
        w1, w2 = m["w_phi1"] * 1e9, m["w_phi2"] * 1e9
        ovl = m.get("minmax_phi_V", float("nan")) * 1e3
        row.update(status="MEASURED_NOT_FINAL", gap_1f2r_ns=g1, gap_2f1r_ns=g2, gap_min_ns=min(g1, g2),
                   w_phi1_ns=w1, w_phi2_ns=w2, width_min_ns=min(w1, w2), ovl_mV=ovl)
        ok = (min(g1, g2) >= a.min_gap and min(w1, w2) >= a.min_width
              and ovl == ovl and ovl <= a.max_ovl * float(a.vdd) * 1e3)
        row["pass"] = int(ok)
    return row


def load(csvp):
    if not csvp.exists():
        return []
    with open(csvp) as fh:
        return list(csv.DictReader(fh))


def stats(rows, a, outdir):
    n = len(rows)
    ok = [r for r in rows if r["status"] == "MEASURED_NOT_FINAL"]
    npass = sum(int(r["pass"]) for r in rows)
    print(f"\nseeds run: {n}, valid measurements: {len(ok)}, pass: {npass}")
    res = {"n": n, "valid": len(ok), "pass": npass, "corner": a.corner + "_mm",
           "temp": a.temp, "vdd": a.vdd,
           "criteria": {"min_gap_ns": a.min_gap, "min_width_ns": a.min_width, "max_ovl_frac_vdd": a.max_ovl}}
    if n:
        print(f"pass fraction {npass}/{n}; with {n} samples and 0 failures the 95% lower bound is only about "
              f"{max(0.0, 1 - 3.0 / n):.3f} (rule of three)")
    for key, label in [("gap_min_ns", "gap (min of two)"), ("width_min_ns", "width (min of two)"),
                       ("ovl_mV", "overlap mV")]:
        v = [float(r[key]) for r in ok if r.get(key) not in (None, "")]
        if len(v) < 2:
            continue
        mu = sum(v) / len(v)
        sd = math.sqrt(sum((x - mu) ** 2 for x in v) / (len(v) - 1))
        res[key] = {"mean": mu, "std": sd, "min": min(v), "max": max(v), "mean_minus_3sd": mu - 3 * sd}
        print(f"{label:20s} mean {mu:8.3f}  sd {sd:7.3f}  min {min(v):8.3f}  max {max(v):8.3f}  "
              f"mean-3sd {mu - 3 * sd:8.3f}")
    if res.get("gap_min_ns", {}).get("std", 1) == 0.0:
        print("WARNING: zero spread across seeds -> mismatch may not be active (check the .lib corner and .option seed)")
    (outdir / "mc_stats.json").write_text(json.dumps(res, indent=1))
    try:
        import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
        fig, ax = plt.subplots(1, 2, figsize=(8, 3.2))
        for axx, key, lim, nm in [(ax[0], "gap_min_ns", a.min_gap, "gap (ns)"),
                                  (ax[1], "width_min_ns", a.min_width, "width (ns)")]:
            v = [float(r[key]) for r in ok if r.get(key) not in (None, "")]
            if v:
                axx.hist(v, bins=min(20, max(5, len(v) // 4)), color="C0")
                axx.axvline(lim, color="r", ls="--", label="screening limit")
            axx.set_xlabel(nm); axx.grid(alpha=.3)
        ax[0].set_ylabel("count"); ax[0].legend(fontsize=7)
        fig.suptitle(f"Block 6 local-mismatch MC, {a.corner}_mm, {a.temp} C, {a.vdd} V, N={n}", fontsize=9)
        plt.tight_layout(); plt.savefig(outdir / "mc_hist.png", dpi=150)
        print("plot:", outdir / "mc_hist.png")
    except Exception as e:
        print("plot skipped:", e)
    print("STATUS: MEASURED_NOT_FINAL; pre-layout; local transistor mismatch only (resistor ideal, no global process spread).")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--repo", default=".")
    ap.add_argument("--deck", default=DEF_DECK)
    ap.add_argument("--ngspice", default="ngspice")
    ap.add_argument("--corner", default="tt", help="2-letter corner; _mm is appended")
    ap.add_argument("--temp", default="27")
    ap.add_argument("--vdd", default="1.8")
    ap.add_argument("--n", type=int, default=100)
    ap.add_argument("--seed0", type=int, default=2001)
    ap.add_argument("--jobs", type=int, default=2)
    ap.add_argument("--timeout", type=int, default=900)
    ap.add_argument("--out", default="results/mc_block6")
    ap.add_argument("--min-gap", type=float, default=5.0)
    ap.add_argument("--min-width", type=float, default=100.0)
    ap.add_argument("--max-ovl", type=float, default=0.01, help="fraction of VDD")
    ap.add_argument("--stats-only", action="store_true")
    a = ap.parse_args()

    repo = Path(a.repo).resolve()
    outdir = repo / a.out
    outdir.mkdir(parents=True, exist_ok=True)
    csvp = outdir / "mc_summary.csv"
    if a.stats_only:
        stats(load(csvp), a, outdir); return
    deck = Path(a.deck) if Path(a.deck).is_absolute() else repo / a.deck
    if not deck.exists():
        sys.exit(f"Deck not found: {deck}")
    lines = P.read_deck(deck)
    check_corner(lines, f"{a.corner}_mm")
    cwd = P.pick_cwd(deck, lines, repo)
    done = {int(r["seed"]) for r in load(csvp)}
    todo = [s for s in range(a.seed0, a.seed0 + a.n) if s not in done]
    print(f"{len(todo)} seeds to run ({len(done)} already done), {a.corner}_mm {a.temp} C {a.vdd} V, out={outdir}", flush=True)
    new = not csvp.exists()
    fh = open(csvp, "a", newline="")
    w = csv.DictWriter(fh, fieldnames=COLS, extrasaction="ignore")
    if new:
        w.writeheader(); fh.flush()
    with cf.ThreadPoolExecutor(max_workers=a.jobs) as ex:
        futs = {ex.submit(one_seed, s, lines, cwd, outdir, a): s for s in todo}
        for f in cf.as_completed(futs):
            r = f.result()
            with LOCK:
                w.writerow(r); fh.flush()
            if r["status"] == "MEASURED_NOT_FINAL":
                print(f"  seed {r['seed']}: gap {r['gap_min_ns']:.2f} ns, width {r['width_min_ns']:.2f} ns, "
                      f"ovl {r['ovl_mV']:.2f} mV, {'pass' if r['pass'] else 'FLAG'}", flush=True)
            else:
                print(f"  seed {r['seed']}: {r['status']}", flush=True)
    fh.close()
    rows = sorted(load(csvp), key=lambda r: int(r["seed"]))
    stats(rows, a, outdir)


if __name__ == "__main__":
    main()
