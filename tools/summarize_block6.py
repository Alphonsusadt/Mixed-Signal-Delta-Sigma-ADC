#!/usr/bin/env python3
"""Block 6 closure: build the tables, summary CSVs and one figure for the report from the raw sweep CSVs.

Reads (default, edit with the options):
  <results>/pvt_block6                  fixed ideal bias (baseline)
  <results>/pvt_block6_biasgen          replica-diode bias, ideal reference current
  <results>/pvt_block6_biasgen_res      resistor-reference generator, ideal R (no tempco)
  <results>/pvt_block6_biasgen_rpdk     resistor-reference generator, SKY130 poly resistor (its tempco is NOT applied in ngspice)
  <results>/pvt_block6_biasgen_res_tc   resistor-reference generator, ideal R with tc1/tc2 of the SKY130 model  (MAIN)
  <results>/pvt_block6_biasgen_res_r0.8 / _r1.2   R x 0.8 / x 1.2, 12 corner conditions each
  <closed_loop>/results/f5_clkcmp_pvt/f5_pvt_summary.csv       comparator-clock chain over PVT
  <closed_loop>/results/closed_loop/<run>/metrics.json         closed-loop runs
Writes into the repo:
  blocks/06_Clock_gen/results/pvt/<label>_pvt_summary.csv   (copies of the chosen raw CSVs)
  blocks/06_Clock_gen/docs/pvt_results_block6.md            (tables + acceptance criteria + known limits)
  blocks/06_Clock_gen/results/pvt/pvt_gap_compare.png
Missing inputs are skipped and listed. Criteria are engineering screening thresholds (see the generated text).

  python3 tools/summarize_block6.py --repo ~/Document/Portfolio_Mixed --results /headless/tidy_test/results
"""
import argparse, csv, json, shutil, sys
from pathlib import Path

SWEEPS = [
    ("baseline_fixed_bias", "pvt_block6_fixed45", "fixed ideal bias VBN 0.70 / VBP 0.71 V"),
    ("replica_ideal_iref", "pvt_block6_biasgen", "replica-diode bias, ideal reference current"),
    ("generator_ideal_R", "pvt_block6_biasgen_res", "resistor-reference generator, ideal R (no tempco)"),
    ("generator_pdk_R_no_tc", "pvt_block6_biasgen_rpdk", "generator with SKY130 poly resistor (its tempco not applied by ngspice)"),
    ("generator_R_tc", "pvt_block6_biasgen_res_tc", "generator, R with tc1/tc2 of the SKY130 model (MAIN)"),
    ("generator_R_x0p8", "pvt_block6_biasgen_res_r0.8", "generator, R x 0.8 (12 conditions)"),
    ("generator_R_x1p2", "pvt_block6_biasgen_res_r1.2", "generator, R x 1.2 (12 conditions)"),
]
RUNS = [("sine300_n4096", "ideal phases, ideal comparator clock"),
        ("f1_sine300_b6_n4096", "Block 6 phases (ideal bias), ideal comparator clock"),
        ("f5_sine300_n2_n4096", "Block 6 phases (ideal bias), comparator clock from phi2b via 2 inverters"),
        ("f6_sine300_b6res_n4096", "Block 6 phases with resistor-reference bias generator, comparator clock from phi2b via 2 inverters")]


def fl(x):
    try: return float(x)
    except (TypeError, ValueError): return None


def load(p):
    return list(csv.DictReader(open(p, newline="")))


def stats(rows, a):
    valid = [r for r in rows if r.get("status") == "MEASURED_NOT_FINAL" and fl(r.get("dt_1f2r")) is not None]
    out = dict(n=len(rows), valid=len(valid), passed=0)
    gaps, wids, ovl, tag = [], [], [], []
    for r in valid:
        g = min(fl(r["dt_1f2r"]), fl(r["dt_2f1r"])) * 1e9
        w = min(fl(r["w_phi1"]), fl(r["w_phi2"])) * 1e9
        vdd = float(r["vdd"]); o = fl(r.get("minmax_phi_V")); o = 0.0 if o is None else o
        gaps.append(g); wids.append(w); ovl.append(o / vdd); tag.append(f'{r["corner"]}/{r["temp"]}C/{r["vdd"]}V')
        if g >= a.min_gap and w >= a.min_width and o < a.max_ovl * vdd:
            out["passed"] += 1
    if valid:
        i = gaps.index(min(gaps)); j = gaps.index(max(gaps)); k = wids.index(min(wids))
        out.update(gmin=min(gaps), gmax=max(gaps), wmin=min(wids), omax=max(ovl) * 100,
                   gmin_at=tag[i], gmax_at=tag[j], wmin_at=tag[k])
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--repo", default=".")
    ap.add_argument("--results", default="/headless/tidy_test/results")
    ap.add_argument("--closed-loop", default=None, help="default: <repo>/top_level/closed_loop")
    ap.add_argument("--min-gap", type=float, default=5.0)
    ap.add_argument("--min-width", type=float, default=100.0)
    ap.add_argument("--max-ovl", type=float, default=0.05, help="max overlap as a fraction of VDD")
    a = ap.parse_args()
    repo = Path(a.repo).expanduser().resolve(); res = Path(a.results).expanduser()
    cl = Path(a.closed_loop).expanduser() if a.closed_loop else repo / "top_level" / "closed_loop"
    b6 = repo / "blocks" / "06_Clock_gen"
    if not b6.exists(): sys.exit(f"{b6} not found: pass --repo <repo root>")
    outd = b6 / "results" / "pvt"; outd.mkdir(parents=True, exist_ok=True)
    (b6 / "docs").mkdir(exist_ok=True)

    data, missing = {}, []
    for lab, folder, desc in SWEEPS:
        p = res / folder / "pvt_summary.csv"
        if not p.exists(): missing.append(str(p)); continue
        rows = load(p); data[lab] = (desc, rows, stats(rows, a))
        shutil.copy(p, outd / f"{lab}_pvt_summary.csv")

    md = ["# Block 6 (NONOV clock generator): PVT results, acceptance criteria and known limits", "",
          "Generated by `tools/summarize_block6.py` from the raw CSVs in `blocks/06_Clock_gen/results/pvt/`. "
          "All numbers: pre-layout ngspice, status `MEASURED_NOT_FINAL` / `SIMULATED_NOT_FINAL_PASS`; none is a final sign-off.", "",
          "## Acceptance criteria used", "",
          "These are engineering screening thresholds chosen for this design. They are **not** derived from a switch-settling "
          "or comparator-timing budget; the only system-level evidence is the nominal closed-loop run below.", "",
          f"| # | Criterion | Threshold |", "|---|---|---|",
          "| A1 | Phases are produced in every PVT condition (5 corners x -40/27/125 C x 1.62/1.8/1.98 V = 45) | 45/45 |",
          f"| A2 | No overlap: max over time of min(phi1, phi2) | < {a.max_ovl * 100:.0f} % of VDD |",
          f"| A3 | Non-overlap gap (min of both gaps) | >= {a.min_gap:g} ns |",
          f"| A4 | Phase width (min of both phases), T/2 = 125 ns | >= {a.min_width:g} ns |",
          "| A5 | Comparator clock (phi2b through 2 inverters) rises after phi2 falls and before phi1 rises | 45/45 |",
          "| A6 | Start-up: stable width and gap within a few clock cycles after the clock starts, VDD ramp 1 and 20 us | 4 corners |", "",
          "## Sweeps (A1-A4)", "",
          "| Sweep | Description | Conditions | Valid | Pass A1-A4 | Gap min..max (ns) | Min width (ns) | Max overlap (% VDD) |",
          "|---|---|---|---|---|---|---|---|"]
    for lab, (desc, rows, s) in data.items():
        rng = f"{s['gmin']:.2f} .. {s['gmax']:.2f}" if "gmin" in s else "-"
        md.append(f"| `{lab}` | {desc} | {s['n']} | {s['valid']} | {s['passed']}/{s['n']} | {rng} | "
                  f"{s['wmin']:.1f} | {s['omax']:.3f} |" if "gmin" in s else f"| `{lab}` | {desc} | {s['n']} | 0 | 0/{s['n']} | - | - | - |")
    md += ["", "Worst cases (main sweep and others):", ""]
    for lab, (desc, rows, s) in data.items():
        if "gmin" in s:
            md.append(f"- `{lab}`: smallest gap {s['gmin']:.2f} ns at {s['gmin_at']}; largest gap {s['gmax']:.2f} ns at {s['gmax_at']}; "
                      f"smallest width {s['wmin']:.2f} ns at {s['wmin_at']}.")
    if "generator_R_tc" in data:
        md += ["", "## Main sweep: generator with tempco, per condition", "",
               "| Corner | T (C) | VDD (V) | Gap (ns) | Width (ns) | Overlap (mV) | tr phi1 (ns) | Status |", "|---|---|---|---|---|---|---|---|"]
        for r in data["generator_R_tc"][1]:
            g = min(fl(r["dt_1f2r"]), fl(r["dt_2f1r"])) * 1e9 if fl(r.get("dt_1f2r")) is not None else None
            w = min(fl(r["w_phi1"]), fl(r["w_phi2"])) * 1e9 if fl(r.get("w_phi1")) is not None else None
            o = fl(r.get("minmax_phi_V")); tr = fl(r.get("tr_phi1"))
            md.append(f"| {r['corner']} | {r['temp']} | {r['vdd']} | {'-' if g is None else f'{g:.2f}'} | {'-' if w is None else f'{w:.2f}'} | "
                      f"{'-' if o is None else f'{o * 1e3:.2f}'} | {'-' if tr is None else f'{tr * 1e9:.2f}'} | {r['status']} |")

    f5 = cl / "results" / "f5_clkcmp_pvt" / "f5_pvt_summary.csv"
    if f5.exists():
        rows = [r for r in load(f5) if r.get("status") == "MEASURED_NOT_FINAL"]
        shutil.copy(f5, outd / "f5_clkcmp_pvt_summary.csv")
        d = [float(r["d_p2f_clkr"]) * 1e9 for r in rows]; c = [float(r["clkr_to_p1r"]) * 1e9 for r in rows]
        ing = sum(1 for r in rows if float(r["d_p2f_clkr"]) > 0 and float(r["clkr_to_p1r"]) > 0)
        md += ["", "## Comparator clock derived from phi2b (A5)", "",
               f"{len(rows)} valid points; clock rises inside the non-overlap gap at {ing}/{len(rows)}. "
               f"phi2 fall to clock rise: {min(d):.2f} .. {max(d):.2f} ns; clock rise to phi1 rise: {min(c):.2f} .. {max(c):.2f} ns. "
               "Load on the clock node is a placeholder (20 fF), not the extracted StrongARM input capacitance. "
               "Block 3 reports a worst-case integrated decision delay of 3.189 ns (standalone PVT campaign, 5 ns clock edges); "
               "the definitions and conditions of the two numbers have not been matched, so this is an indication, not a margin claim."]
    else:
        missing.append(str(f5))

    md += ["", "## Closed loop (300 mV sine, OSR 80, 4112 cycles, TT, 27 C, 1.8 V)", "",
           "| Run | Configuration | SNDR (dB) | ENOB |", "|---|---|---|---|"]
    for run, desc in RUNS:
        mp = cl / "results" / "closed_loop" / run / "metrics.json"
        if mp.exists():
            m = json.load(open(mp)); md.append(f"| `{run}` | {desc} | {m['sndr_db']:.2f} | {m['enob']:.2f} |")
        else:
            missing.append(str(mp))
    md += ["", "Single-run SNDR scatter is about +-1 dB at OSR 80, so differences between rows are not claimed as degradation or improvement. "
           "The system target was revised to about 75 dB at OSR 80.", "",
           "## Known limits (not covered)", "",
           "- Pre-layout only: no extraction, no parasitics; clock-node load is a placeholder.",
           "- No Monte Carlo (device mismatch, resistor spread). The SKY130 resistor model is not corner- or tempco-active in this ngspice setup; "
           "its model tempco (tc1 = -1.47e-3 /K, tc2 = 2.7e-6 /K) was applied manually to an ideal resistor, and R spread is covered only by x0.8 / x1.2 at the extreme conditions.",
           "- Closed loop only at the nominal point (one amplitude, one bin, one run per configuration).",
           "- During the supply ramp phi1 follows VDD until the clock starts and phi2 can rise to a fraction of VDD; the effect on the Block 5 switches is not evaluated. "
           "The first 2-3 clock cycles after start are not nominal; they are assumed to fall inside the 5 us reset, which is a default value, not a validated requirement.",
           "- Supply current of the generator is estimated (about 2 x I) and not separately reported.",
           "- Resistor length for 1.248 MOhm is about 850 um at W = 1.41 um (603 squares) with the SKY130 xhigh-po model; layout area is not evaluated."]
    (b6 / "docs" / "pvt_results_block6.md").write_text("\n".join(md) + "\n")

    try:
        import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
        fig, ax = plt.subplots(figsize=(10, 4.2), dpi=150)
        for lab, col, mk in (("baseline_fixed_bias", "#b0413e", "x"), ("replica_ideal_iref", "#7a7a7a", "s"), ("generator_R_tc", "#1f6fb4", "o")):
            if lab in data:
                ys = [(min(fl(r["dt_1f2r"]), fl(r["dt_2f1r"])) * 1e9) if fl(r.get("dt_1f2r")) is not None else float("nan") for r in data[lab][1]]
                ax.plot(range(len(ys)), ys, mk, color=col, ms=4, ls="none", label=lab.replace("_", " "))
        ax.axhline(a.min_gap, color="k", lw=0.8, ls="--"); ax.text(0.2, a.min_gap * 1.06, f"gap >= {a.min_gap:g} ns", fontsize=8)
        from matplotlib.ticker import FixedLocator, FixedFormatter, NullLocator
        ax.set_yscale("log"); ax.yaxis.set_major_locator(FixedLocator([1, 2, 5, 10, 20, 50, 100]))
        ax.yaxis.set_major_formatter(FixedFormatter(["1", "2", "5", "10", "20", "50", "100"])); ax.yaxis.set_minor_locator(NullLocator())
        ax.set_xlabel("PVT condition index (5 corners x 3 T x 3 VDD, order of the CSV); conditions without phases are not drawn")
        ax.set_ylabel("non-overlap gap (ns)"); ax.grid(alpha=0.25)
        ax.legend(fontsize=8, loc="upper center", bbox_to_anchor=(0.5, -0.2), ncol=3, frameon=False)
        ax.set_title("Block 6 non-overlap gap over 45 PVT conditions (log scale)", fontsize=10)
        fig.tight_layout(); fig.savefig(outd / "pvt_gap_compare.png"); plt.close(fig)
    except Exception as e:
        print("figure skipped:", e)

    print("wrote:", b6 / "docs" / "pvt_results_block6.md"); print("      ", outd)
    for lab, (desc, rows, s) in data.items():
        print(f"  {lab:<24s} valid {s['valid']}/{s['n']}  pass {s['passed']}/{s['n']}  " +
              (f"gap {s['gmin']:.2f}..{s['gmax']:.2f} ns  width_min {s['wmin']:.1f} ns  ovl_max {s['omax']:.3f} %VDD" if "gmin" in s else ""))
    if missing: print("missing inputs (skipped):", *missing, sep="\n  ")


if __name__ == "__main__":
    main()
