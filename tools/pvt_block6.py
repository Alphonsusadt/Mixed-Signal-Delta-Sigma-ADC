#!/usr/bin/env python3
"""PVT sweep for Block 6 (NONOV) using an existing xschem-generated ngspice deck.

Python only orchestrates: for every (corner, temperature, VDD) it copies the deck,
patches the .lib corner / .temp / VDD (and the clock amplitude), runs ngspice in
batch mode, then reads the TB6_MEAS block from the log and the waveform .dat.

Example (run from the repo root):
  python3 tools/pvt_block6.py --jobs 2
  python3 tools/pvt_block6.py --show            # print lib/temp/vdd lines of the deck
  python3 tools/pvt_block6.py --corners tt --temps 27 --vdds 1.8   # single sanity run

Status labels follow the project convention: MEASURED_NOT_FINAL. No acceptance limit is
imposed by the tool; --min-gap/--min-width only mark rows as FLAG in the table.
"""
import argparse, csv, itertools, os, re, shutil, subprocess, sys, concurrent.futures as cf
from pathlib import Path

DEF_DECK = "blocks/06_Clock_gen/sim/out/netlist/tb_6D_realload_vbn0p70.spice"
MEAS_KEYS = ["dt_1f2r", "dt_2f1r", "w_phi1", "w_phi2", "skew_p1r", "skew_p1f",
             "tr_phi1", "tf_phi1", "tr_phi2", "tf_phi2", "tr_phi1b", "tf_phi1b",
             "tr_phi2b", "tf_phi2b", "ovl_prod", "phi1_max", "phi2_max", "ivdd_avg"]

LIB_RE = re.compile(r"^(\s*\.lib\s+\S+\s+)([a-z]{2}(?:_mm)?)(\s*)$", re.I)
TEMP_RE = re.compile(r"^\s*\.temp\s+\S+", re.I)
VDD_RE = re.compile(r"^(\s*vvdd\s+\S+\s+\S+\s+)(\S+)(.*)$", re.I)
CLK_RE = re.compile(r"^(\s*vclk\s+\S+\s+\S+\s+pulse\s*\(\s*\S+\s+)(\S+)(.*)$", re.I)
WR_RE = re.compile(r"(\bwrdata\s+)(\S+)", re.I)
VAL_RE = re.compile(r"(\bVAL=)([-+0-9.eE]+)", re.I)
VM_RE = re.compile(r"^(\s*vm\s+\S+\s+\S+\s+)(\S+)(.*)$", re.I)
INC_RE = re.compile(r"^\s*\.(?:include|lib)\s+(\"[^\"]+\"|'[^']+'|\S+)", re.I)


def read_deck(path):
    return Path(path).read_text().splitlines()


def show(lines):
    for i, l in enumerate(lines, 1):
        if re.match(r"^\s*(\.lib|\.include|\.temp|\.option|vvdd|vclk|vbn|vbp|\.control|wrdata|\.save)", l, re.I):
            print(f"{i:4d}: {l}")


def pick_cwd(deck_path, lines, repo):
    """Choose a working directory in which all relative .include/.lib paths resolve."""
    rel = []
    for l in lines:
        m = INC_RE.match(l)
        if m:
            p = m.group(1).strip("\"'")
            if not p.startswith("/") and "$" not in p:
                rel.append(p)
    cands = [deck_path.parent, deck_path.parent.parent, deck_path.parent.parent.parent, repo,
             repo / "blocks/06_Clock_gen/sim"]
    for c in cands:
        if all((c / p).exists() for p in rel):
            return c
    print("WARNING: could not find a directory resolving relative includes:", rel[:5], file=sys.stderr)
    return deck_path.parent


def patch(lines, corner, temp, vdd, wr_path, seed=None):
    out, saw_lib, saw_temp, saw_vdd, saw_clk = [], 0, False, False, False
    for i, l in enumerate(lines):
        m = LIB_RE.match(l)
        if m:
            l = f"{m.group(1)}{corner}{m.group(3)}"; saw_lib += 1
        elif TEMP_RE.match(l):
            l = f".temp {temp}"; saw_temp = True
        else:
            m = VDD_RE.match(l)
            if m:
                l = f"{m.group(1)}{vdd}{m.group(3)}"; saw_vdd = True
            else:
                m = CLK_RE.match(l)
                if m:
                    l = f"{m.group(1)}{vdd}{m.group(3)}"; saw_clk = True
        if re.match(r"^\s*meas\b", l, re.I):
            k = float(vdd) / 1.8   # thresholds were written for 1.8 V: keep 10/50/90 %
            l = VAL_RE.sub(lambda mm: f"{mm.group(1)}{float(mm.group(2)) * k:.6g}", l)
        mv = VM_RE.match(l)
        if mv:
            l = f"{mv.group(1)}{float(vdd) / 2:.6g}{mv.group(3)}"
        if WR_RE.search(l):
            l = WR_RE.sub(lambda mm: f"{mm.group(1)}{wr_path}", l)
        out.append(l)
        if seed is not None and re.match(r"^\s*\.control", l, re.I):
            out.append(f"set rndseed={seed}")
    if not saw_lib:
        raise SystemExit("No '.lib <file> <corner>' line with a 2-letter corner found. Run with --show.")
    if not saw_vdd:
        raise SystemExit("No 'vvdd <n+> <n-> <value>' line found. Run with --show.")
    if not saw_clk:
        print("WARNING: no 'vclk ... PULSE(v1 v2 ...)' line matched; clock amplitude NOT scaled with VDD (run --show)", file=sys.stderr)
    if not saw_temp:
        out.insert(1, f".temp {temp}")
    return out


def parse_log(text):
    res = {}
    for k in MEAS_KEYS:
        m = re.search(rf"^{k}\s*=\s*([-+0-9.eE]+)", text, re.M)
        if m:
            res[k] = float(m.group(1))
    res["done"] = "TB6_DONE" in text
    return res


def parse_dat(path, vdd):
    """max over time of min(phi1,phi2); columns: t clk phi1 phi1b phi2 phi2b."""
    import numpy as np
    rows = []
    for l in Path(path).read_text().splitlines():
        try:
            rows.append([float(x) for x in l.split()])
        except ValueError:
            continue
    if not rows:
        return None
    a = np.array(rows)
    if a.shape[1] < 6:
        return None
    t, p1, p2 = a[:, 0], a[:, 2], a[:, 4]
    m = t > 50e-9
    if not m.any():
        return None
    return float(np.minimum(p1, p2)[m].max()), float(max(p1[m].max(), p2[m].max()))


def run_case(case, deck_lines, cwd, outdir, ngspice, timeout, seed):
    corner, temp, vdd = case
    tag = f"{corner}_T{temp}_V{vdd}".replace("-", "m").replace(".", "p")
    deck = outdir / f"{tag}.spice"
    dat = outdir / f"{tag}.dat"
    log = outdir / f"{tag}.log"
    deck.write_text("\n".join(patch(deck_lines, corner, temp, vdd, str(dat), seed)) + "\n")
    row = {"corner": corner, "temp": temp, "vdd": vdd, "status": "FAIL"}
    try:
        p = subprocess.run([ngspice, "-b", "-o", str(log), str(deck)], cwd=cwd,
                           capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        row["status"] = "TIMEOUT"; return row
    txt = log.read_text(errors="replace") if log.exists() else p.stdout + p.stderr
    row.update(parse_log(txt))
    if dat.exists():
        r = parse_dat(dat, float(vdd))
        if r:
            row["minmax_phi_V"], row["phi_max_V"] = r
        dat.unlink() if os.environ.get("PVT_KEEP_DAT") is None else None
    if row.get("done") and "dt_1f2r" in row:
        row["status"] = "MEASURED_NOT_FINAL"
    return row


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--repo", default=".")
    ap.add_argument("--deck", default=DEF_DECK)
    ap.add_argument("--ngspice", default="ngspice")
    ap.add_argument("--corners", default="tt,ss,ff,sf,fs")
    ap.add_argument("--temps", default="-40,27,125")
    ap.add_argument("--vdds", default="1.62,1.8,1.98")
    ap.add_argument("--jobs", type=int, default=2)
    ap.add_argument("--timeout", type=int, default=900)
    ap.add_argument("--out", default="results/pvt_block6")
    ap.add_argument("--seed", type=int, default=None, help="set rndseed (for *_mm corners)")
    ap.add_argument("--min-gap", type=float, default=5.0, help="ns; only for FLAG marking")
    ap.add_argument("--min-width", type=float, default=100.0, help="ns; only for FLAG marking")
    ap.add_argument("--show", action="store_true")
    a = ap.parse_args()

    repo = Path(a.repo).resolve()
    deck = (repo / a.deck) if not Path(a.deck).is_absolute() else Path(a.deck)
    if not deck.exists():
        sys.exit(f"Deck not found: {deck}")
    lines = read_deck(deck)
    if a.show:
        show(lines); return
    cwd = pick_cwd(deck, lines, repo)
    outdir = (repo / a.out); outdir.mkdir(parents=True, exist_ok=True)
    cases = list(itertools.product(a.corners.split(","), a.temps.split(","), a.vdds.split(",")))
    print(f"{len(cases)} cases, cwd={cwd}, out={outdir}", flush=True)

    rows = []
    with cf.ThreadPoolExecutor(max_workers=a.jobs) as ex:
        futs = {ex.submit(run_case, c, lines, cwd, outdir, a.ngspice, a.timeout, a.seed): c for c in cases}
        for f in cf.as_completed(futs):
            r = f.result(); rows.append(r)
            print(f"  done {r['corner']:>5s} T={r['temp']:>4s} V={r['vdd']:>4s} {r['status']}", flush=True)

    order = {c: i for i, c in enumerate(cases)}
    rows.sort(key=lambda r: order[(r["corner"], r["temp"], r["vdd"])])
    cols = ["corner", "temp", "vdd", "status"] + [k for k in MEAS_KEYS] + ["minmax_phi_V", "phi_max_V"]
    with open(outdir / "pvt_summary.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=cols, extrasaction="ignore"); w.writeheader(); w.writerows(rows)

    print("\ncorner  T(C)   VDD   gap1f2r  gap2f1r  w_phi1  w_phi2  tr_phi1  min(phi1,phi2)  note")
    for r in rows:
        if r["status"] != "MEASURED_NOT_FINAL":
            print(f"{r['corner']:>6s} {r['temp']:>5s} {r['vdd']:>5s}   {r['status']}"); continue
        g1, g2 = r["dt_1f2r"] * 1e9, r["dt_2f1r"] * 1e9
        w1, w2 = r["w_phi1"] * 1e9, r["w_phi2"] * 1e9
        mm = r.get("minmax_phi_V", float("nan"))
        note = []
        if mm > 0.05 * float(r["vdd"]): note.append("OVERLAP?")
        if min(g1, g2) < a.min_gap: note.append("gap<min")
        if min(w1, w2) < a.min_width: note.append("width<min")
        print(f"{r['corner']:>6s} {r['temp']:>5s} {r['vdd']:>5s}  {g1:7.2f}  {g2:7.2f} {w1:7.2f} {w2:7.2f}  {r['tr_phi1']*1e9:6.2f}  {mm:12.4f}   {' '.join(note) or 'ok'}")

    ok = [r for r in rows if r["status"] == "MEASURED_NOT_FINAL"]
    if ok:
        g = [min(r["dt_1f2r"], r["dt_2f1r"]) * 1e9 for r in ok]
        print(f"\nGap range over {len(ok)}/{len(rows)} valid cases: {min(g):.2f} .. {max(g):.2f} ns")
        try:
            import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
            fig, ax = plt.subplots(figsize=(8, 3.6))
            labels = [f"{r['corner']}\n{r['temp']}C\n{r['vdd']}V" for r in ok]
            ax.bar(range(len(ok)), g, color="C0"); ax.set_xticks(range(len(ok))); ax.set_xticklabels(labels, fontsize=5)
            ax.set_ylabel("non-overlap gap (ns)"); ax.grid(alpha=.3, axis="y")
            plt.tight_layout(); plt.savefig(outdir / "pvt_gap.png", dpi=150)
            print("plot:", outdir / "pvt_gap.png")
        except Exception as e:
            print("plot skipped:", e)
    print("csv :", outdir / "pvt_summary.csv")


if __name__ == "__main__":
    main()
